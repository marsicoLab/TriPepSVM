#!/usr/bin/env bash

scriptDir=$(dirname "$0")

TEST_FILE=$1
TAXON=$2
THRESHOLD=$3
OUTFILE=$4

cp $TEST_FILE $OUTFILE
##### 9606
if [ "$TAXON" != "9606" ]; then
	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/RBP_9606.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 > $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE

	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/NRBP_9606.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 >> $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE
fi



##### 561
if [ "$TAXON" != "561" ]; then
	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/RBP_561.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 >> $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE

	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/NRBP_561.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 >> $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE

fi
##### 590
if [ "$TAXON" != "590" ]; then
	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/RBP_590.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 >> $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE

	cd-hit-2d -i2 $OUTFILE -i $scriptDir/../../../trainData/NRBP_590.fasta -c $THRESHOLD -o $OUTFILE.temp -M 0 >> $OUTFILE.log.temp
	cp $OUTFILE.temp $OUTFILE

fi

rm -f $OUTFILE*temp*


