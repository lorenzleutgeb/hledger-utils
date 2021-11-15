n26.journal: n26.csv.journal
	cp n26.csv.journal n26.journal

n26.csv.journal: n26.csv n26.csv.rules
	hledger -f n26.csv print > n26.csv.journal

n26.csv: n26.csv.bak sanitize.sed
	./sanitize.sed < n26.csv.bak > n26.csv

clean:
	rm -fv n26.csv n26.csv.journal
