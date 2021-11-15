wise.journal: manual.journal aud.csv.journal eur.csv.journal
	cat manual.journal aud.csv.journal eur.csv.journal > wise.journal

aud.csv.journal: aud.csv aud.csv.rules
	hledger -f aud.csv print > aud.csv.journal

eur.csv.journal: eur.csv eur.csv.rules
	hledger -f eur.csv print > eur.csv.journal

aud.csv: aud.csv.bak
	grep -v '^BALANCE' aud.csv.bak | grep '0.00$$' > aud.csv

eur.csv: eur.csv.bak
	grep -v '^BALANCE' eur.csv.bak | grep '0.00$$' > eur.csv

TODO: aud.csv.bak eur.csv.bak
	grep '^BALANCE' {aud,eur}.csv.bak > tmp
	grep -Ev '(0.00|")$$' {aud,eur}.csv.bak >> tmp
	cat tmp | sort | uniq > TODO
	rm tmp

clean:
	rm -fv {aud,eur}.csv{,.journal} wise.journal TODO
