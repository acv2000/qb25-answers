#!/usr/bin/env python3
import sys
import numpy as np
from fasta import readFASTA

# Step 1.1: Read in your parameters

fasta_file = sys.argv[1]
sigma_file = sys.argv[2]
gap_penalty = float(sys.argv[3])
out_file = sys.argv[4]

# Generate the scoring matrix 
fs = open(sigma_file)
sigma = {}
alphabet = fs.readline().strip().split()
for line in fs:
    line = line.rstrip().split()
    for i in range(1, len(line)):
        sigma[(alphabet[i - 1], line[0])] = float(line[i])
fs.close()

# Read FASTAs
input_sequences = readFASTA(open(fasta_file))
seq1_id, sequence1 = input_sequences[0]
seq2_id, sequence2 = input_sequences[1]
n = len(sequence1)
m = len(sequence2)

# Step 1.2: Initialize matrices
F_matrix = np.zeros((n + 1, m + 1)) 
T_matrix = np.zeros((n+1, m+1), dtype=str)

for i in range(1, n + 1):
    F_matrix[i, 0] = F_matrix[i - 1, 0] + gap_penalty
    T_matrix[i, 0] = 'U'

for j in range(1, m + 1):
    F_matrix[0, j] = F_matrix[0, j - 1] + gap_penalty
    T_matrix[0, j] = 'L'


# Step 1.3: Populating the matrices 

for i in range(1, n + 1):
    for j in range(1, m + 1):
        d = F_matrix[i - 1, j - 1] + sigma[(sequence1[i - 1], sequence2[j - 1])]
        u = F_matrix[i - 1, j] + gap_penalty
        l = F_matrix[i, j - 1] + gap_penalty
        F_matrix[i, j] = max(d, u, l)

        if F_matrix[i, j] == d:
            T_matrix[i, j] = 'D'
        elif F_matrix[i, j] == u:
            T_matrix[i, j] = 'U'
        else:
            T_matrix[i, j] = 'L'


# Step 1.4: Find the optimal alignment

i, j = n, m
sequence1_alignment = []
sequence2_alignment = []

while i > 0 or j > 0:
    move = T_matrix[i, j]
    if move == 'D':
        sequence1_alignment.append(sequence1[i - 1])
        sequence2_alignment.append(sequence2[j - 1])
        i -= 1
        j -= 1
    elif move == 'U':
        sequence1_alignment.append(sequence1[i - 1])
        sequence2_alignment.append('-')
        i -= 1
    else:  # 'L'
        sequence1_alignment.append('-')
        sequence2_alignment.append(sequence2[j - 1])
        j -= 1

sequence1_alignment = ''.join(sequence1_alignment[::-1])
sequence2_alignment = ''.join(sequence2_alignment[::-1])

identity_alignment = ''
for a, b in zip(sequence1_alignment, sequence2_alignment):
    identity_alignment += '|' if a == b else ' '

# Step 1.5: Write the alignment to the output

with open(out_file, 'w') as output:
    for start in range(0, len(identity_alignment), 100):
        output.write(sequence1_alignment[start:start + 100] + '\n')
        output.write(identity_alignment[start:start + 100] + '\n')
        output.write(sequence2_alignment[start:start + 100] + '\n\n')

# Calculate sequence identity 
gaps1 = sequence1_alignment.count('-')
gaps2 = sequence2_alignment.count('-')
matches = sum(1 for a, b in zip(sequence1_alignment, sequence2_alignment) if a == b)
pct1 = 100 * matches / (len(sequence1_alignment) - gaps1) if (len(sequence1_alignment) - gaps1) > 0 else 0
pct2 = 100 * matches / (len(sequence2_alignment) - gaps2) if (len(sequence2_alignment) - gaps2) > 0 else 0

# Print alignment info
print("Gaps in sequence 1:", gaps1)
print("Gaps in sequence 2:", gaps2)
print(f"Percent identity of sequence 1: {pct1:.2f}%")
print(f"Percent identity of sequence 2: {pct2:.2f}%")
print("Final alignment score:", F_matrix[n, m])