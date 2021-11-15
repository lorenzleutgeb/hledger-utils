# Expected global variables (via argument files):
#  - expenses
#  - groups
#  - groups_patch
#  - users_patch

def spaces(n): [n * " "] | join("");

def bool_tonumber: if . then 1 else 0 end;

def account_separator: ":";

def line_separator: "\n";

def sanitize: select(.deleted_at == null);

def spacing:
  {
    account: "    ",
    amount: "  ",
    currency: " ",
  };

# Remove date from `name` in favor of `year`.
# Adjust `type`.
# `year` is the year of creation. For trips
# that span multiple years, the beginning
# is relevant.
# For trips, the year will be added to the
# account name, thus the name does not have
# to be unique.

def groups_as_parsed:
  [$groups[] | select(.id != 0) | {key: .id | tostring, value: {name: (.name | rtrimstr(" ")), type: .group_type, year: .created_at[:4]}}] | from_entries;

# Lists users as they are discovered in $expenses
# without any processing. For overview.
def users:
  [
    $expenses[].users[].user
    | {
        key: "\(.id)",
        value: {
	  first_name: .first_name,
	  last_name:  .last_name
	}
      }
  ]
  | unique
  | from_entries;

# Translates a user ID into a name, accounting
# for patches.
def id_to_name(id): 
  $users_patch[id | tostring]
  | if   .first_name == null then .last_name
    elif .last_name  == null then .first_name
    else "\(.first_name) \(.last_name)"
  end;

# Returns an object of all users that do not
# have an entry in `$users_patch` yet.
def not_patched:
  [
    users
    | to_entries[]
    | select(.key as $id | $users_patch | has($id) | not)
  ]
  | from_entries;

# To list all used categories
def categories:
  [
    $expenes[].category.name
  ]
  | unique;

# Checks whether an array of amounts is balanced.
# NOTE: All amounts are assumed to bear the
# same commodity/currency.
def balanced:
  [. | select(not)]
  | length as $missing
  | if   $missing == 1 then true
    elif $missing >  1 then false
    else [amounts[] | tonumber] | add == 0
    end;

def aligned(postings):
  # TODO: The following 4 lines scream for a call to reduce...
  [postings[] | .account | length] | max as $len_account |
  [postings[] | .amount | index(".") // length] | max as $amount_pre |
  [postings[] | .amount | index(".") != null | bool_tonumber] | max as $amount_dot |
  [postings[] | .amount | rindex(".") // 0] | max as $amount_post |
  ($amount_pre + $amount_dot + $amount_post) as $len_amount |
  [
    postings[]
    | spacing.account
      + spaces($len_account - (.account | length))
      + .account
      + spacing.amount
      + spaces($len_amount - (.amount | length))
      + .amount
      + spacing.currency
      + .currency
  ];

# Take a transaction, made of multiple postings, each combining account and amount.
def to_journal_entry:
  . as $expense
  | [
      "\(.date | strftime("%Y-%m-%d")) (\(.id)) \(.description) ; total:\(.total)"
    ]
    + aligned($expense.postings)
    + [""]
  | join(line_separator);

def group_name(a; expense; b):
  $groups_patch[expense.group_id | tostring] as $g
  | [id_to_name(a)]
    + ["split"]
    + if expense.group_id == 0 or expense.group_id == null
      then []
      else [$g.type] + (if $g.type == "trip" then [$g.year] else [] end) + [$g.name]
      end
    + [id_to_name(b)]
  | join(account_separator);

def expense_to_transaction: . as $expense |
  {
    currency: $expense.currency_code,
    date: $expense.date | fromdateiso8601,
    description: $expense.description,
    id: $expense.id,
    postings:
    [
      $expense.repayments[]
      |
        {
	  account: group_name(.to; $expense; .from),
	  amount: .amount,
	  currency: $expense.currency_code
	},
	{
	  account: group_name(.from; $expense; .to),
	  amount: ("-" + .amount),
	  currency: $expense.currency_code
	}
    ],
    total: $expense.cost
  };

$expenses[] | sanitize | expense_to_transaction | to_journal_entry
