#!/bin/bash

# $1 = Branchiopoda_OG.fasta

name=$(echo $1 | awk -F"_" '{print $2}' | awk -F"." '{print $1}')

for i in $(grep ">" $1 | sed 's/>//');
	do for c in $(awk '{print $2}' "$name"_domain_positions_0.5.txt | sort -u);
		do ndomain=$(grep "$i" "$name"_domain_positions_0.5.txt | grep -c "$c")
			if [[ "$ndomain" -gt 1 ]]
				then echo -e "$ndomain""-""$c"
				else if [[ "$ndomain" -eq 0 ]]
					then :
					else echo -e "$c"
				fi 
			fi
	done > tmp
	echo -e ">""$i"$(if [[ -s tmp ]]; then echo "|"; else :; fi)$(cat tmp | sed '$!{:a;N;s/\n/_/;ta}')"\n"$(grep -A1 "$i" $1 | tail -n1) 
done
