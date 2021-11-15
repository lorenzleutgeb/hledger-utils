#!/usr/bin/env -S sed -E -f
1d
/^,+$/d
/.*Geldmarktfonds Preisänderung.*"-0.00",EUR.*/d
# Normalize amounts
s/"(-)?([0-9]{1,3})\.([0-9]{1,3}),([0-9]{2})"/"\1\2\3\.\4"/g
s/"(-)?([0-9]+),([0-9]+)"/"\1\2\.\3"/g
