flatex.journal: flatex.csv.journal
	cp flatex.csv.journal flatex.journal

flatex.csv.journal: flatex.csv flatex.csv.rules
	hledger -f flatex.csv print > flatex.csv.journal

flatex.csv: flatex.csv.bak
	cp flatex.csv.bak flatex.csv

clean:
	rm -fv flatex.csv flatex.csv.journal
