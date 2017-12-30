#! /bin/bash

## Copyright 2017 Luz Marina Martin and Noelia Almagro

## This file is part of MREPIPE

## MREPIPE is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## MREPIPE is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with MREPIPE.  If not, see <http://www.gnu.org/licenses/>.


SAMPLE_CONTROL=$1
SAMPLE_CHIP=$2
WORKING_DIR=$3
EXPERIMENT=$4
GENOME=$5
ANNOTATION=$6

## Accessing the working directory

cd $WORKING_DIR
cd $EXPERIMENT

## Creating the structure

mkdir genome 
mkdir annotation
mkdir samples
mkdir results

## Creating subfolders for each sample

cd samples

mkdir control chip

## Introducing samples in subfolders

mv $SAMPLE_CONTROL ./control/control.fastq
mv $SAMPLE_CHIP ./chip/chip.fastq

## Moving annotation

echo "Moving annotation"
echo "Moving annotation" >> $WORKING_DIR/$EXPERIMENT/logs.txt

cd ../annotation
mv $ANNOTATION ./annotation.gtf

## Moving reference genome

echo "Moving reference genome"
echo "Moving reference genome" >> $WORKING_DIR/$EXPERIMENT/logs.txt

cd ../genome
cp $GENOME ./genome.fa

## Building index for reference genome

echo "Building index for reference genome"
echo "Building index for reference genome" >> $WORKING_DIR/$EXPERIMENT/logs.txt

bowtie-build genome.fa index

echo "DIRECTORY STRUCTURE DONE"
echo "DIRECTORY STRUCTURE DONE" >> $WORKING_DIR/$EXPERIMENT/logs.txt
