ing.csv: ing.csv.bak sanitize.sed
	iconv -f ISO8859-1 -t UTF8 ing.csv.bak | ./sanitize.sed > ing.csv

clean:
	rm ing.csv
