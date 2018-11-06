#!/bin/bash
TAXON=$1
RESULT=$2
RECURSIVE=$3

#### create Database folder
DATABASE=$RESULT/Database_$TAXON
mkdir -p $DATABASE

#### get all GO annotated RBP from ancestor of TAXON

if [ ! -e "$DATABASE/RBP.fasta" ];then
	#### get anchestor of taxon id
	if [ "$RECURSIVE" == "TRUE" ];then
		if [ ! -e "$DATABASE/parseTaxonomyUniprot.temp" ];then
			query_taxonomy="http://www.uniprot.org/taxonomy/?query=ancestor:$TAXON&fil=uniprot%3A(*)&format=tab"
			curl $query_taxonomy > $DATABASE/parseTaxonomyUniprot.temp
		fi
	
		searchID=`cut -f1 $DATABASE/parseTaxonomyUniprot.temp | tail -n +2`
		for organism_id in $searchID;do
			query_go="http://www.ebi.ac.uk/QuickGO/GAnnotation?format=fasta&limit=-1&goid=GO:0003723&db=UniProtKB&tax=$organism_id"
			curl $query_go >> $DATABASE/RBP.fasta
		done
	else
		query_go="http://www.ebi.ac.uk/QuickGO/GAnnotation?format=fasta&limit=-1&goid=GO:0003723&db=UniProtKB&tax=$TAXON"
		curl $query_go > $DATABASE/RBP.fasta
	fi
	
fi

#### skip redundant entrys

if [ ! -e "$RESULT/RBP_$TAXON.fasta" ];then
	./createUniqSet.sh $RESULT $DATABASE/RBP.fasta $RESULT/RBP_$TAXON.fasta
fi

rm -f $DATABASE/*.temp
