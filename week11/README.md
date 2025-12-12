# Step 1.1
# Number of reads = (Coverage * Genome size) / read length 
#                 = (3 * 1,000,000)/100
#                 = 30,000

# Step 1.4
# About  5% of the genome has not been sequenced, this result matches a Poisson distribution very well!
# A normal distribution also does a decent job at capturing the coverage but not as accurately as the Poisson distribution.

# Step 1.5
# About  0.0037% of the genome has not been sequenced, this result matches a Poisson distribution perfectly!
# The normal distribution provides a very good approximation as well at 10X but not perfect as the Poisson distribution.

# Step 1.6
# About  0.0004% of the genome has not been sequenced, this result matches a both distributiuons almost perfectly!
# At a very high coverage, the Normal distribution is very accurate and differences between the two distributions are negligible.

# Step 2.4
# dot -Tpng debruijn_graph.dot -o ex2_digraph.png

# Step 2.5 
# TCTTATTGATTGATTGAT

# Step 2.6 
# To reconstruct a genome very accurately, you would need to be able to generate pretty long reads, little to no sequencing errors, and high coverage.




