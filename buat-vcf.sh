#!/bin/bash
# use a 'here document' to create the Vcard format
## add/remove Vcard fields between the 'EOM' start/end marks
#function create_vcard {
#cat << EOM
#BEGIN:VCARD
#VERSION:3.0
#FN:customer name
#N:$NAMA_KONTAK
#TEL;TYPE=CELL:${CELL_NUMBER}
#EMAIL;TYPE=PREF:${EMAIL_KONTAK}
#END:VCARD
#EOM
#}
###

IN_FILE=$1
#NAMA_KONTAK=$(awk '{print $1}')
#CELL_NUMBER=$(awk '{print $2}')
#EMAIL_KONTAK=$(awk '{print $3}')

TOTAL_BARIS_IN=$(wc -l ${IN_FILE})
TOTAL_BARIS_OUT=$(wc -l ${OUT})
## if IN_FILE missing show usage
if [[ "${IN_FILE}" == "" ]] ; then printf "\n\tUsage: $0 Input_file_name\n\n" ; exit 1 ; fi

OUT=${IN_FILE}.vcf
## if OUT already exists then rename
if [[ -e ${OUT} ]] ; then mv ${OUT} ${OUT}.last ; fi

awk '{print "BEGIN:VCARD\nVERSION:3.0\nFN:"$1"\nN:"$1"\nTEL;TYPE=CELL:"$2"\nEMAIL;TYPE=PREF:"$3"\nEND:VCARD"}' ${IN_FILE} > ${OUT}
#create_vcard >> ${OUT}
echo "total baris input ${TOTAL_BARIS_IN}"
echo "total baris output ${OUT}"
ls -l ${OUT}
exit 0
