aargs <- commandArgs(trailingOnly=TRUE)

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


file.1 <- args[1]
file.2 <- args[2]
directory <- as.character(args[3])

genes.1 <- unique(as.vector(read.table(file=file.1,header=FALSE)[[1]]))
print(length(genes.1))
genes.2 <- as.vector(read.table(file=file.2,header=TRUE)[[1]])
print(length(genes.2))

genes.1.2 <- unique(intersect(genes.1,genes.2))
genes.2.1 <- setdiff(genes.2, genes.1.2)

library(VennDiagram)

label.1 <- "Background"
label.2 <- "Target genes"

pdf(paste(directory, "venn_diagram.pdf", sep="/"), 7, 7)

grid.newpage()
draw.pairwise.venn(area1 = length(unique(genes.1)),
                   area2 = length(unique(genes.2)),
                   cross.area = length(unique(genes.1.2)),
                   category = c(label.1, label.2), 
                   cat.cex=1.25, cat.pos=c(-30,20), cat.dist=0.04, cex=2,
                   fill=c("green", "red"),
                   alpha=c(0.4,0.4),
                   lwd=3,fontface="bold",
                   cat.fontface="bold")

dev.off()

write.table(genes.2.1, file= paste(directory, "target_genes_not_background.txt", sep= "/"), quote= FALSE)
write.table(genes.1.2, file= paste(directory, "intersection_genes.txt", sep="/"), quote=FALSE)
