#!/bin/bash -login
#PBS -l walltime=24:00:00,nodes=1:ppn=4,mem=24Gb
#mdiag -A ged
#PBS -m abe
#PBS -N BWA-MEM

module load bwa/0.7.12.r1044

cd $PBS_O_WORKDIR

mkdir /tmp/$SM

bwa mem -t 4 -M -R "@RG\tID:$RGID\tSM:$SM\tPL:$PL\tLB:$LB\tPU:$PU" $Bwa_ref $R1.pe.fq $R2.pe.fq > /tmp/$SM/pe_aligned_reads.sam
bwa mem -t 4 -M -R "@RG\tID:$RGID\tSM:$SM\tPL:$PL\tLB:$LB\tPU:$PU" $Bwa_ref <(cat $R1.se.fq $R2.se.fq) > /tmp/$SM/se_aligned_reads.sam

rsync -rlpgoDvh --append-verify /tmp/$SM/pe_aligned_reads.sam .
rsync -rlpgoDvh --append-verify /tmp/$SM/se_aligned_reads.sam .

qstat -f ${PBS_JOBID}

