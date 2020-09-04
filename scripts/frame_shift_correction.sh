#!/bin/bash
# Michal Strejcek @ University of Chemistry and Technology, Prague

# Based on https://doi.org/10.1186/s40168-019-0665-y

# dependencies:
# - diamond [http://www.diamondsearch.org]
# - MEGAN Community Edition [https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/megan6/]

[ $# -eq 3 ] && die "Usage: $0 [path_to_MEGAN] [path_to_refseq_bac.dmnd] [fasta_file]" 1

echo working on $3
f=${3//.*}
 
echo "Running diamond on refseq[bacteria]"
# taxid 286 = Pseudomonas
diamond blastx -d $2 -q $3 -o $f --range-culling --top 10 -F 15 --outfmt 100 -c1 -b12 -t /dev/shm --taxonlist 286

"$1"/tools/daa-meganizer -i $f.daa --longReads --classify false --lcaAlgorithm longReads --readAssignmentMode alignedBases

"$1"/tools/read-extractor -i $f.daa --frameShiftCorrect --all -o $f.corrected.fa
