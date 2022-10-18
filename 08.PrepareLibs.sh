#####################################################################################################
#                Collect merge and reduce redundancy of all libraries                               #
#####################################################################################################

###Collect automatically curated Libs

cd Auto_Curation 
for i in $( ls | grep -v "scripts"); do 

        cd "$i"; 
        mkdir Merged_Libs; 
        for j in $(ls | grep "rnd"); do 

                cp "$j"/*_Consensus.fa.classified Merged_Libs/; 
        done; 
        python ../../../TE_Scripts/Merge_TELibraries.py --path Merged_Libs/ --out "$i"; cp "$i"_Merged.Consensus.fa ../../Libs/AutoLibs/; 
cd ../;  

done

cd ../Libs/AutoLibs
awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' ALL_AutLibs.fa > ALL_AutLibs_oneliner.fa
cd ../ManualLibs

###Get automatically curated consensus that were also subjected to manual curation
grep ">" ALL_ManuallyCurated.fa  | cut -d"_" -f1,2,3 | grep -w -A1 -Ff - ../AutoLibs/ALL_AutLibs_oneliner.fa | sed 's/^--//' > ../AutoLibs/ManuallyCurated_AutoLib.fa

###Get raw consensus that were also subjected to manual curation
grep ">" ALL_ManuallyCurated.fa  | cut -d"_" -f1,2,3 | grep -w -A1 -Ff - ../RawLibs/RawLib.fa | sed 's/^--//' > ../RawLibs/ManuallyCurated_RawLib.fa

###Merge RawLib AutoLib PepLib and ManualLib
cd ../
mkdir Final_Lib
cp ManualLibs/ALL_ManuallyCurated.fa Final_Lib
cp AutoLibs/ALL_AutLibs.fa Final_Lib
cp PepLibL/pac_DDE.D_cons.fa Final_Lib

python ../../TE_Scripts/Merge_TELibraries.py --path  Final_Lib/ --out FinalLib --manual ALL_ManuallyCurated.fa
cd-hit-est -T 0 -i FinalLib_Merged.Consensus.fa -M 1000000 -o FinalLib_Merged.Consensus.nr.fa -c 0.8 -n 5 -aS 0.8 -g 1 -G 0

###Classified still Unknown consensus based on BlastX searches of the longest 20 insertions against a TE-derived pep library
awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' FinalLib_Merged.Consensus.nr.fa > FullLib_Merged.Consensus.nr.fa.oneliner
grep -A1 "Unknown" FinalLib_Merged.Consensus.nr.fa > FullLib_Merged.Consensus.Unknown.oneliner
python ../../TE_Scripts/BlastX_TE_Anno.py --lib FullLib_Merged.Consensus.Unknown.oneliner --genome ALL.genomic.fa --num_threads 10 --out Unknown_Classified --TE_prot ../../Libs/RepeatPeps_Renamed.lib

#-----------------------------------------------------------------------------------------------------------###
###NB: The resulting Consensus_Classification.tsv file was used to classify all previously unknown sequences###
###"FullLib_Merged.Consensus.nr.BlastxClassified.fa" ---> Final Classified library                          ###
#-----------------------------------------------------------------------------------------------------------###
