#!/bin/awk -f

BEGIN {
    RS = ">"
    FS = "\n"
}

NR == 1 {
    # skip empty record created by initial ">"
    next
}

NF > 1 {
    #split header
    split($1, header, "_")
    # rename contig contigid_length
    print ">"header[2]"_len_"header[4] 
    for (i=2; i<=NF; i++){
        print $i 
    }
}

