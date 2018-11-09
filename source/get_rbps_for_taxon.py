import argparse
from bioservices import QuickGO
from bioservices import UniProt
import pandas as pd

def get_rbp_ids_for_taxon(taxon, mode='exact'):
    """ Retrieve UniProt IDs for all RBPs for a given taxon.
    """
    rna_binding_goterm = "GO:0003723"
    g = QuickGO(verbose=False)

    annot = g.Annotation(goId=rna_binding_goterm,
                         taxonId=taxon,
                         taxonUsage=mode,
                         goUsage='descendants',
                         geneProductType='protein',
                         geneProductSubset='Swiss-Prot',
                         limit=100
                        )
    num_pages = min(25, annot['pageInfo']['total'])
    #num_pages = 25
    all_dfs = []
    for page in range(1, num_pages):
        rbps = g.Annotation(goId=rna_binding_goterm,
                            taxonId=taxon,
                            taxonUsage=mode,
                            goUsage='descendants',
                            geneProductType='protein',
                            geneProductSubset='Swiss-Prot',
                            limit=100,
                            page=page)
        if type(rbps) is int:
            print (rbps, page)
        all_dfs.append(pd.DataFrame(rbps['results']))
    all_rbps = pd.concat(all_dfs)
    all_rbp_ids = all_rbps.geneProductId.unique()

    # remove trailing 'Uniprot:' of IDs
    all_rbp_ids = [i.split(':')[1] for i in all_rbp_ids]

    return all_rbp_ids


def write_fasta_for_ids(uniprot_ids, output_file):
    u = UniProt(verbose=False)
    count = 1
    all_seqs = []
    for rbp in uniprot_ids:
        all_seqs.append(u.retrieve(rbp, 'fasta'))
        if count % 100 == 0:
            print ("Retrieved sequence for {} RBPs".format(count))
        count += 1
    rbp_fasta = ''.join(all_seqs)
    with open(output_file, 'w') as f:
        f.write(rbp_fasta)
    print ("Wrote {} sequences to file".format(len(all_seqs)))


def parse_args():
    parser = argparse.ArgumentParser(description='Get RNA-binding protein AA sequences for a given taxon')
    parser.add_argument('-t', '--taxon', help='The taxon to query',
                        dest='taxon',
                        default=9606,
                        type=int
                        )
    parser.add_argument('-m', '--mode', help='"descendants" if all species under the given\
                                              one should be included, otherwise "exact"',
                        dest='mode',
                        default='exact',
                        type=str
                        )
    parser.add_argument('-o', '--output', help='where to write the resulting fasta file',
                        dest='output_file',
                        type=str
                        )
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    # parse arguments
    args = parse_args()
    # get UniProt IDs that match GO term RNA-binding
    uniprot_rbp_ids = get_rbp_ids_for_taxon(taxon=args.taxon, mode=args.mode)
    print ("Obtained {} distinct UniProt IDs of RBPs from QuickGO".format(len(uniprot_rbp_ids)))
    # get sequences for IDs and write to file
    write_fasta_for_ids(uniprot_ids=uniprot_rbp_ids, output_file=args.output_file)