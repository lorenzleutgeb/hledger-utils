ba.journal: ba.csv.journal close.journal
	cat ba.csv.journal close.journal > ba.journal

ba.csv.journal: ba.csv ba.csv.rules
	hledger -f ba.csv print > ba.csv.journal

ba.csv: ba.csv.bak sanitize.sed
	iconv -f ISO8859-1 -t UTF8 ba.csv.bak | ./sanitize.sed > ba.csv

clean:
	rm -fv ba.csv ba.csv.journal ba.journal
