# ./getIUPred.sh

scriptDir=$(dirname "$0")

SEQFILE=$1
RESULTFILE=$2
RESULT=$3

rm -f $RESULTFILE

for ID in `grep '^>' $SEQFILE|cut -f2 -d'|'`;do
	echo $ID
	grep -A 1 "$ID|" $SEQFILE > $RESULT/temp.fa
	iupred $RESULT/temp.fa glob > $RESULT/out.temp
	
	sed -i 's/\s//g' $RESULT/out.temp
	
	LENGTH=`tail -n +2 $RESULT/temp.fa | wc -m` 
	Rscript $scriptDir/getDomainContent.r $RESULT/out.temp $LENGTH $RESULTFILE
done

