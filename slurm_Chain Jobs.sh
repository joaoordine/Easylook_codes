# Submitting chain jobs

## One job should only run after another previous one is already running
sbatch --dependency=68062326 process_blast_out.sh # the number after = should be the jobID 

## One job should only run after any previous jobs I submitted have finished 
sbatch --dependency=afterany:11217468 process_blast_out.sh 
