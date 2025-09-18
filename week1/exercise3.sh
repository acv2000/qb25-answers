# Create four .bed files corresponding to 1_Active and 12_Repressed for NHEK and NHLF
grep 1_Active nhek.bed > nhek-active.bed
# 14013 entries 
grep 1_Active nhlf.bed > nhlf-active.bed
grep 12_Repressed nhek.bed > nhek-repr.bed
grep 12_Repressed nhlf.bed > nhlf-repr.bed

# Construct a bedtools command to test where there is any overlap between 1_Active and 12_Repressed in a given condition (aka mutually exclusive)
bedtools intersect -a nhek-active.bed -b nhek-repr.bed | wc -l 

# Regions that are active in NHEK and NHLF
bedtools intersect -u -a nhek-active.bed -b nhlf-active.bed > active_both.bed
# 11608 entries

# Regions that are active in NHEK but not active in NHLF
bedtools intersect -v -a nhek-active.bed -b nhlf-active.bed > active_onlynhek.bed
# 2405 entries

# Construct three bedtools intersect commands to see the effect of using the arguments -f 1, -F 1, and -f 1 -F 1 when comparing -a nhek-active.bed -b nhlf-active.bed
bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1
bedtools intersect -F 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1
bedtools intersect -f 1 -F 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1

# -f 1: Requires that all of feature A (NHEK) is in feature B (NHLF)
# -F 1: Requires that all of feature B (NHLF) is in feature A (NHEK)
# -f 1 -F 1: Requires a perfect overlap between both features 

# Active in NHEK, Active in NHLF
bedtools intersect -a nhek-active.bed -b nhlf-active.bed > active_both1.bed
head -n 1 active_both1.bed
# All nine conditions have a promoter that overlaps with this region, all active

# Active in NHEK, Repressed in NHLF
bedtools intersect -a nhek-active.bed -b nhlf-repr.bed > active_nhek_repre_nhlf.bed
head -n 1 active_nhek_repre_nhlf.bed
# Active in NHEK, HMEC, H1-hESC, & GM12878 (promoter regions), & repressed in NHLF & HSMM

# Repressed in NHEK, Repressed in NHLF
bedtools intersect -a nhek-repr.bed -b nhlf-repr.bed > repre_both.bed
head -n 1 repre_both.bed
# Inactive in all 9 regions 