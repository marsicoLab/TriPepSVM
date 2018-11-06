#!/bin/bash

scriptDir=$(dirname "$0")

TAXON=$1
RESULT=$2

DATABASE=$RESULT/TEMP_NEG

mkdir -p $DATABASE

if [ ! -e "$DATABASE/parseProteinSwissprot.fasta" ];then
	query_swissprot_proteom="http://www.uniprot.org/uniprot/?query=reviewed:yes+taxonomy:$TAXON&format=fasta"
	curl $query_swissprot_proteom > $DATABASE/parseProteinSwissprot.fasta
fi

# remove all critical proteins based on protocoll 
if [ ! -e "$DATABASE/swissprot_keyword.txt" ];then
	for KEYWORD in `cut -f2 $scriptDir/../data/Keywords.txt`;do
		query_keyword="http://www.uniprot.org/uniprot/?query=keyword:$KEYWORD+reviewed:yes+taxonomy:$TAXON&format=tab"		
		curl $query_keyword >> $DATABASE/swissprot_keyword.txt
	done
fi

cut -f1 $DATABASE/swissprot_keyword.txt | tail -n +2 |sort|uniq > $DATABASE/swissprot_keyword_id.temp

Rscript $scriptDir/getSVMSequences.r $DATABASE/swissprot_keyword_id.temp $DATABASE/parseProteinSwissprot.fasta $DATABASE/withoutKeywordUniprot.fasta.temp 3
Rscript $scriptDir/removeBadLength.r $DATABASE/withoutKeywordUniprot.fasta.temp $DATABASE/withoutBadLength.fasta.temp

cd-hit -i $DATABASE/withoutBadLength.fasta.temp -o $DATABASE/removed_redundand.fasta.temp -c 0.75 -n 5 -g 1 -G 0 -aS 0.8 -d 0 -p 1 -T 0 -M 0 > $DATABASE/log.txt.temp
hmmsearch -E 10 --cpu 4 --tblout $DATABASE/'prediction.temp' --domtblout $DATABASE/'prediction_domains.temp' $scriptDir/../data/hmm_script.hmm $DATABASE/removed_redundand.fasta.temp > $DATABASE/'out.temp'

sed '/^#/d' $DATABASE/'prediction.temp' | cut -f2 -d'|' | sort | uniq > $DATABASE/criticalSetFromHMMs.txt.temp
Rscript $scriptDir/getSVMSequences.r $DATABASE/criticalSetFromHMMs.txt.temp $DATABASE/removed_redundand.fasta.temp $DATABASE/remove_HMM_critical.fasta.temp 2

grep '^>' $RESULT/RBP_$TAXON.fasta | cut -f2 -d'|' > $DATABASE/$TAXON'_annotated.txt.temp'

Rscript $scriptDir/getSVMSequences.r $DATABASE/$TAXON'_annotated.txt.temp' $DATABASE/remove_HMM_critical.fasta.temp $DATABASE/removed_ann.fasta.temp 2
Rscript $scriptDir/getSVMSequences.r $scriptDir/../data/uniprot_rna_binding.txt  $DATABASE/removed_ann.fasta.temp $DATABASE/removed_rna.fasta.temp 2
Rscript $scriptDir/getSVMSequences.r $scriptDir/../data/uniprot_dna_binding.txt $DATABASE/removed_rna.fasta.temp $DATABASE/removed_dna.fasta.temp 2
Rscript $scriptDir/getSVMSequences.r $scriptDir/../data/uniprot_nucleotid_binding.txt $DATABASE/removed_dna.fasta.temp $RESULT/NRBP_$TAXON.fasta 2

#rm -R $DATABASE






























