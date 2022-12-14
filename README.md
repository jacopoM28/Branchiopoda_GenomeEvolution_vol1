# Branchiopoda_GenomeEvolution_vol1

## Bioinformatic pipeline used to study evolution of Transposable Elements and their repression genes in 9 branchiopods genomes.

### Species:  
 - Lpac = *Lepidurus packardi*
 - Lapu = *Lepidurus apus apus*
 - Lart = *Lepidurus arcticus*
 - Lcou = *Lepidurus couesi*
 - Lubb = *Lepidurus apu lubocki*
 - Tita = *Triops cancriformis* (SPA)
 - Tjap = *Triops cancriformis* (JAP)
 - Tlon = *Triops longicaudatus*
 - Tusa = *Triops canctiformis* (ITA) 

### Scripts:

- **00.Rename_RepeatPepsLib.sh:** Rename DDE DNA elements at the superfamily level following [Yuan and Wessler, (2011)](https://www.pnas.org/doi/10.1073/pnas.1104208108).  
- **01.RepeatModeler.sh:** De-novo TE discovery.  
- **02.Clean_Proteomes.sh:** Remove TE-related genes from a set of proteomes.  
- **03.Automatic_Refining_Libraries.sh:** Removal of genes/genes fragments and tandem repeats from libraries.  
- **04.Manual_Curation.sh:** Manual curation of a set of raw consensus.    
- **05.Automatic_Curation.sh:** Automatic curation of all consensus.  This process was run 10 times.
- **06.DDE.D_ProteinEvidences.sh** Find DDE/D-related protein evidences across all genomes.  
- **07.Lpac_AUTFams.sh** Clustering of DDE/D insertions with protein homologies. 
- **08.PrepareLibs.sh** Prepare all TE libs for RepeatMasker anayses.   
- **09.RepeatMasker.sh** TE annotation using RepeatMasker and both raw and curated TE libraries.
- **0X.TE_Repression.Genes.sh** Mining of Piwi, DICER, Ago, RdRP genes from predicted proteomes (No Lpac).

#### Data:
- **Libs:** Refernce DDE/D DNA HMM profiles.  

##### NB: all custom python scripts used for TE curation and annotion can be found in: [TE_Scripts](https://github.com/jacopoM28/Python_Scripts/tree/main/TE_scripts)
 
