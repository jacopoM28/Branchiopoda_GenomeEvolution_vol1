# Brachiopoda_GenomeEvolution_vol1

## Bioinformati pipeline used to study evolution of Transposable Elements in 8 brachiopods genomes.

#### Raw Repeats annotation:

**01.RepeatModeler.sh:** De-novo TE discovery.  
**02.RepeatMasker.sh:** TE annotation with automatic generated libraries.  

#### Manual and automatic repeats annotation
**03.Automatic_Refining_Libraries.sh:** Removal of genes/genes fragments and tandem repeats from libraries.  
**04.RawCons_CopyNumber.sh:** RepeatCraft to merge fragmented repeats and extraction of raw consensus with more than 50 genomic copies.  
**05.Manual_Curation.sh:** Manual curation of a set of raw consensus.  
**06.Automatic_Curation.sh:** Automatic curation of all consensus.  



##### NB: all custom python scripts can be found in: [TE_Scripts](https://github.com/jacopoM28/Python_Scripts/tree/main/TE_scripts)
 
