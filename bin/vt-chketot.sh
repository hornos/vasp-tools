#!/bin/bash

CAT=cat
GPLOT=gnuplot

_inp="${1:-OSZICAR}"
inp=${_inp%%.gz}
dat=${inp}.dat
plt=${inp}.plt


if test "${_inp}" != "${inp}" ; then
  CAT=zcat
fi


${CAT} "${inp}" | \
awk '/^ *[0-9]+ *F=/{gsub(/=/,"",$8);printf "%4d %12.6f %12.6f %21.9f\n",$1,$3,$5,$8}' \
> ${dat}

cat > ${plt} << EOF
set title "${inp}"
set xlabel "Step"
set ylabel "Energy [eV]"
set pointsize 2
plot "${dat}" using 1:2 title "calcs" with points, \
     "${dat}" using 1:2 smooth csplines title "csplines"
EOF

${GPLOT} -persist ${plt}
rm ${dat} ${plt}
