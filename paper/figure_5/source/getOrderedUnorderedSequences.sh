#!/usr/bin/env bash

scriptDir=$(dirname "$0")

SEQFILE=$1
RESULT_ORDERED=$2
RESULT_DISORDERED=$3
RESULT=$4

mkdir -p $RESULT

rm -f $RESULT_ORDERED
rm -f $RESULT_UNORDERED

for ID in `grep '^>' $SEQFILE|cut -f2 -d'|'`;do
	cat <(echo ">$ID") <(grep -A 1 $ID $SEQFILE| tail -n +2) > $RESULT/temp.fa

	iupred $RESULT/temp.fa glob > $RESULT/out.temp
	
	sed -i 's/\s//g' $RESULT/out.temp
	
	cat <(echo ">$ID") <(grep "^[A-Z]*[a-z]*$" $RESULT/out.temp) > $RESULT/out2.temp
	
	Rscript $scriptDir/getSequenceFiles.r $RESULT/out2.temp $RESULT_ORDERED $RESULT_DISORDERED
done

