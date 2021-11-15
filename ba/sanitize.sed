#!/usr/bin/env -S sed -E -f
# Delete Header
1d
# Delete inter-account transaction in new schema
2d
# Delete inter-account transaction in new schema
3d
# Fix CSV
s/\;/"\;"/g
s/\;" /\;"/g
s/^"/""/
s/"$/""/
s/^""\;//g
s/(;"")+$//
# Normalize amounts
s/([0-9]{1,3})\.([0-9]{1,3}),([0-9]{2})/\1\2\.\3/g
s/([0-9]{1,3}),([0-9]{2})/\1\.\2/g
s/(\s\s\s\s+)/   /g
# Typos
s/Wirschaftsservice/Wirtschaftsservice/g
s/(Wirtschaftsservice) GmbH\./\1 GmbH/g
s/AUFLöSUNG/Auflösung/g
s/Thaliastr\.PK/Thaliastraße PK/g
s/O[eE]BB/ÖBB/
# Normalize ATM/POS
s/(AT|DE|IE|IT|NL)\s+[0-9]+.[0-9][0-9]\s+(MAESTRO|DEBIT)?\s*(ATM|POS)/\3 \1/g
# Remove amount from ATM/POS
s/\;"(ATM|POS)\s+[0-9]+.[0-9][0-9] (AT|DE|IE|IT|NL)\s+/\;"\1 \2/g
s/([0-9]{4})"\;"ABHEBUNG AUTOMAT NR\. ([0-9]+) AM ([0-9]{2})\.([0-9]{2})\. UM ([0-9]{2}).([0-9]{2}) UHR/\1"\;"ATM AT \1-\4-\3 \5:\4 \2/
s/([0-9]{4})"\;"(AUTO|BANKO)MAT\s+([0-9]+) K[12]\s+([0-9]{2})\.([0-9]{2})\.(UM)? ([0-9]{2})[:\.]([0-9]{2})   O/\1"\;"ATM AT \1-\5-\4 \7:\8 \3/
s/([0-9]{4})"\;"ATM (AT|DE|IE|IT|NL)K2\s+([0-9]{2})\.([0-9]{2})\. ([0-9]{2}):([0-9]{2}) /\1"\;"ATM \2 \1-\4-\3 \5:\4 \2/
s/([0-9]{4})"\;"POS (AT|DE|IE|IT|NL)K2\s+([0-9]{2})\.([0-9]{2})\. ([0-9]{2}):([0-9]{2})/\1"\;"POS \2 \1-\4-\3 \5:\4 \2/
s/(POS|ATM) (AT|DE|IT|IE|NL) ([0-9]{2})\.([0-9]{2})\.([0-9]{2}) ([0-9]{2}).([0-9]{2})(K(1|2))( O)?(\s* )?/\1 \2 20\5-\4-\3 \6:\5 /
s/(POS|ATM) (AT|DE|IT|IE|NL) ([0-9]{2})\.([0-9]{2})\.([0-9]{2}) ([0-9]{2}).([0-9]{2})/\1 \2 20\5-\4-\3 \6:\5/
s/K2\s+O (([[A-Z\.0-9\-]*\s*)*)\s+([0-9]{5})/\3 \1/
s/(K2\s+O )?(ATO )?ATM S6EE([0-9]{4})\s+WIEN\s+([0-9]{4})/S6EE\3 WIEN \4/
s/(POS AT 20[0-9]{2}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}) (AT)?( O)?\s*(.*)"/\1 \4"/
s/(POS AT 20[0-9]{2}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2})\s+"/\1"/
# Transfers
s/UEBERW\. REF\./Transfer /
s/UEBERW\.(\w)/Transfer \1/
s/Überweisung/Transfer/
s/DA-NR.: ([0-9]+)/Repeating-Transfer \1/g
s/Gutschrift a\///
# Online Transfers
s/([0-9]{4})"\;"Online-Auftrag vom ([0-9]{2}).([0-9]{2})./\1"\;"Online-Transfer on \1-\3-\2/
s/Transfer(.*)REF.(FB[0-9A-Z]+)/Transfer \2 \1/
s/ zG\/ / for /
s/  zG\// for /
s/ a\// for /
s/Bareinzahlung/Cash Deposit/
s/Barauszahlung/Cash Withdrawal/
s/((SEPA|EZE)-?)?Lastschrift for/Direct Debit for/g
s/Bank Austria Cashback ([0-9]{2})\/20([0-9]{2})/Cashback 20\2-\1/
s/(\s+")/"/g
s/"(25\.00 % )?KES[Tt]"/"Capital Gains Tax"/
s/Habenzinsen/Interest/i
s/\;""\;"EUR"\;/\;/
