cd ../new/
if [ $# -ne 1 ]; then
	echo "usage: ./pso.sh <configNum> # between 1 and 8"
	exit
fi
time octave pso.m $1 | tee ../logs/dumpPSO$1.txt
