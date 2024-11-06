#!/bin/awk -f

# variables to declare:
# - fk:filename for kept contigs
# - fd: filename for discarded contigs
# - fs: filename to store stats for each contig
# - sample: sample name

BEGIN {
    RS = ">"
    FS = "\n"
    print "sample\tcontig.id\tlength" > fs
}

NR == 1 {
    # skip empty record created by initial ">"
    next
}

NF > 1 {
    #split header to collect contig length and kmer coverage
    split($1, header, "_")
    #select contigs >= 1000 bp
    if (header[4] >= 1000){
        # rename contig sample_contigid_length
        print ">"sample"_"header[2]"_"header[4] > fk
        for (i=2; i<=NF; i++){
            print $i > fk
        }
        #store contig stats
        print sample"\t"header[2]"\t"header[4] > fs
    }
    #discard contigs < 1000 bp
    if (header[4] < 1000){
        # rename contig sample_CD_number
        print ">"sample"_"header[2]"_"header[4] > fd
        for (i=2; i<=NF; i++){
            print $i > fd
        }
        #store contig stats
        print sample"\t"header[2]"\t"header[4] > fs
    }
}

