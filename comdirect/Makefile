comdirect.journal: comdirect.csv.journal
	cp comdirect.csv.journal  comdirect.journal

comdirect.csv.journal: comdirect.csv comdirect.csv.rules
	hledger -f comdirect.csv print > comdirect.csv.journal

comdirect.csv: comdirect.csv.bak sanitize.sed
	iconv -f ISO8859-1 -t UTF8 comdirect.csv.bak | ./sanitize.sed > comdirect.csv

clean:
	rm -fv comdirect.csv comdirect.csv.journal comdirect.journal
