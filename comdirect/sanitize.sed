#!/usr/bin/env -S sed -E -f
# Delete useless summary lines
/.*"Umsätze (Depot|Girokonto)".*/d
/.*Keine Umsätze.*/d
/.*Neuer Kontostand.*/d
/"Buchungstag.*/d
/^\;$/d
# Delete empty lines
/^[[:space:]]*$/d
# Delete artifact in first line
1d
