#!/bin/bash
LISTD=./whois-test/list-ukm4
HASIL=./whois-test
AKHIR=./whois-test/hasil-ukm4-0.csv
AKHIR2=./whois-test/hasil-ukm4-1.csv

for r in $(cat $LISTD);
	do 
		if [ -e $HASIL/$r.txt ]; then
			echo "Berkas $r.txt telah ada, menghapusnya"
			rm -rfv $HASIL/$r.txt
		fi
		echo "Menjalankan perintah whois -h whois.pandi.or.id $r > $HASIL/$r.txt"
		whois --verbose -h whois.pandi.or.id $r > $HASIL/$r.txt;
		echo "Menunggu 15 detik......"
		sleep 15 # whois server menolak flood jika dijalankan terus menerus
done

if [ -e $AKHIR ]; then
	echo "Berkas $AKHIR telah ada, menghapusnya..."
	rm -rfv $AKHIR;
fi

for t in $(cat $LISTD); 
	do 
		echo "Memroses berkas $HASIL/$t.txt"
		TEST1=`grep "DOMAIN NOT FOUND" $HASIL/$t.txt`
		if [ -n "$TEST1" ]; then
			echo "$t,DOMAIN NOT FOUND,," >> $AKHIR
		else
			cat $HASIL/$t.txt | awk -F: '/^Domain Name/{line=$2","}\
			#/^Created On/{line=line""$2":"$3":"$4}\
			#/^Last Updated On/{line=line","$2":"$3":"$4}\
			#/^Expiration Date/{line=line","$2":"$3":"$4}\
			#/^Registrant Name/{line=line","$2}\
			#/^Registrant Street1/{line=line","$2}\
			#/^Registrant Street2/{line=line","$2}\
			#/^Registrant Street3/{line=line","$2}\
			#/^Registrant City/{line=line","$2}\
			#/^Registrant State\/Province/{line=line","$2}\
			#/^Registrant Postal Code/{line=line","$2}\
			#/^Registrant Phone/{line=line","$2}\
			#/^Registrant Email/{line=line","$2}\
			/^Name Server:NS/{print line","$2;}' | awk '!seen[$1]++' >> $AKHIR
			echo "Proses selesai, tidak menghapus $HASIL/$t.txt"
			#rm -rfv $HASIL/$t.txt;
		fi
done

uniq --check-chars=10 $AKHIR > $AKHIR2
