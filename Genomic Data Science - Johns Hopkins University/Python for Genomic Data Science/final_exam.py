def find_orfs(seq_id, seq, frame=1):
    """ find_orfs returns a dictionary where the key = seq_id and corresponding values are 
    the start & stop positions, and length of all the orfs of a particular sequence """

    search_start_pos = 0
#    orf_list = list()
    orf_dict = dict()
    orf_number = 0
    
    while True:
    
        # Search for start codon
        start_codon = 'atg'    
        
        for i in range(search_start_pos + (frame - 1), len(seq), 3):
            codon = seq[i:i+3].lower()
#            print codon
            if codon == start_codon:
                start_codon_pos = i + 1
#                print 'start codon position is', start_codon_pos
                break
        else:
            if len(orf_dict) < 1:
#                orf_list.append([0, 0, 0])
                seq_orf_id = seq_id + "_orf" + str(orf_number)
                orf_dict[seq_orf_id] = [0, 0 ,0]
            return orf_dict
        
        # Search for stop codon
        stop_codons = ['tga', 'tag', 'taa']
        
        for i in range(start_codon_pos - 1, len(seq), 3):
            codon = seq[i:i+3].lower()
#            print codon
            if codon in stop_codons:
                stop_codon_pos = i + 3
#                print 'stop codon position is', stop_codon_pos
                break
        else:
            if len(orf_dict) < 1:
#                orf_list.append([0, 0, 0])
                seq_orf_id = seq_id + "_orf" + str(orf_number)
                orf_dict[seq_orf_id] = [0, 0 ,0]
            return orf_dict

        # Splice sequence to obtain ORF
        orf_seq = seq[start_codon_pos - 1 : stop_codon_pos]
        orf_length = len(orf_seq)
        # Assign orf to sequence orf number
        orf_number += 1
        seq_orf_id = seq_id + "_orf" + str(orf_number)
        orf_dict[seq_orf_id] = [start_codon_pos, stop_codon_pos, orf_length]
#        orf_list.append([start_codon_pos, stop_codon_pos, orf_length])
     
        # Search remainder of sequence for other ORFs
        search_start_pos = stop_codon_pos - (frame - 1)
        
# ===========================================================================================

def find_longest_orf(seq_dict, frame):

    ''' find_longest_orf finds the longest orf from a list of sequences. Returns a tuple
    containing the seq_orf_id, start, stop, positions of orf, and length of orf. '''

    ''' seq_dict is a dictionary that contains the sequence id, sequence length, and sequence
    of all of the sequences in the .fasta file. '''

    max_orf_all_seqs_dict = dict()

    # Loop through each sequence

    for seq_id in seq_dict:
        ''' find_orf returns a dictionary of the start & stop positions, and length of all
        the orfs of a particular sequence. '''
    
        seq = seq_dict[seq_id][2]
    
        orfs_list = find_orfs(seq_id, seq, frame)

        # Determine longest orf for each sequence

        max_orf_length_single_seq = max(orfs_list[seq_orf_id][2] for seq_orf_id in orfs_list)   
        print seq_id + ':', 'longest orf in reading frame %d is %d bp.' \
            %(frame, max_orf_length_single_seq)

        # Create a dictionary of the longest orf from each sequence. Includes seq_id, 
        # start/stop positions, length)

        for seq_id_orf, orf in orfs_list.items():
            if orf[2] == max_orf_length_single_seq:
                max_orf_all_seqs_dict[seq_id_orf] = orfs_list[seq_id_orf]
        
    # Determine longest orf out of all the sequences
    max_orf_length_all_seqs = max(max_orf_all_seqs_dict[seq_orf_id][2] \
        for seq_orf_id in max_orf_all_seqs_dict)   
    
    # Add all information (i.e., seq_id, start/stop positions, length) of longest orf to tuple
    for seq_id_orf, orf in max_orf_all_seqs_dict.items():
        if orf[2] == max_orf_length_all_seqs:
            max_orf_all_seqs = (seq_id_orf, max_orf_all_seqs_dict[seq_id_orf])

    # Return a tuple containing the seq_orf_id, start & stop positions of orf, and length
    # of orf.
    return max_orf_all_seqs

# ===========================================================================================

# Questions 1-3

''' Create a dictionary seq_dict where key = seq_id (e.g., seq_1) and the corresponding value
contains the sequence id, sequence length, and sequence of all of the sequences in the .fasta 
file. '''

print "Questions 1-3:" '\n'

import inspect

file = open('dna2.fasta')


seq_count = 0               # Keep track of number of sequences in file
line_count = 0              # Keep track of number of lines in file
seq = ''                    # Initialize sequence
seq_dict = dict()           # Initialize sequence dictionary
# seq_id_dict = dict()        # Initialize id dictionary
seq_length_list = list()    # Initialize sequence lengths list

attribute_list = list()

num_lines = len(open('dna2.fasta').readlines())

for line in file:
    line_count += 1
    line = line.strip()

    if not line.startswith('>') and line_count < num_lines:
        seq += line

    elif line_count == num_lines:
        seq += line
        seq_length_list.append(len(seq))
        seq_dict[seq_id] = [id, len(seq), seq]

    elif line.startswith('>'):
    
        if len(seq) > 0:
            seq_length_list.append(len(seq))
            seq_dict[seq_id] = [id, len(seq), seq]

        seq_count += 1
        id = line
        seq_id = 'seq_' + str(seq_count)

        # initialize new sequence
        seq = ''        
           
print 'The are %d sequences in this file.' %seq_count, '\n'
print 'The length of these %d sequences are as follows:' % seq_count, seq_length_list, '\n'
print 'The longest sequence in the file is %d bp.' % max(seq_length_list), '\n'
print 'The shortest sequence in the file is %d bp.' % min(seq_length_list), '\n'

print "======================================================================================", '\n'

# ===========================================================================================

# Question 4: What is the length of the longest ORF appearing in reading frame 2 of any of
# the sequences? 

print "Question 4:" '\n'

frame = 2
longest_orf_frame_2 = find_longest_orf(seq_dict, frame)

print 'The seq_orf_id, start and stop positions, and length of longest orf of all sequences'
print 'in reading frame %d are as follows:'  %frame, longest_orf_frame_2, '\n'

print "======================================================================================", '\n'

# ===========================================================================================

# Question 5: What is the starting position of the longest ORF in reading frame 3 in any of
# the sequences? The position should indicate the character number where the ORF begins. 

print "Question 5:" '\n'

frame = 3

longest_orf_frame_3 = find_longest_orf(seq_dict, frame)

print
print 'The seq_orf_id, start and stop positions, and length of longest orf of all sequences'
print 'in reading frame %d are as follows:'  %frame, longest_orf_frame_3, '\n'

print "======================================================================================", '\n'

# ===========================================================================================

# Question 6: What is the length of the longest ORF appearing in any sequence and in any
# forward reading frame?

print "Question 6:" '\n'

num_frames = 3

# Loop through all sequences with all 3 forward reading frames

for i in range(1, num_frames + 1):
    frame = i
    longest_orf = find_longest_orf(seq_dict, frame)
    print
    print 'The seq_orf_id, start and stop positions, and length of longest orf of all sequences'
    print 'in reading frame %d are as follows:'  %frame, longest_orf, '\n'

print "======================================================================================", '\n'

    
# ===========================================================================================

# Question 7: What is the length of the longest forward ORF that appears in the sequence with
# the identifier gi|142022655|gb|EQ086233.1|16?

print "Question 7:" '\n'

id = 'gi|142022655|gb|EQ086233.1|16'
target_seq = dict()

for seq_id in seq_dict:
    if id not in seq_dict[seq_id][0]: continue
    target_seq_id = seq_id
    target_seq[seq_id] = seq_dict[seq_id]
    
print 'Sequence that has id "%s" is %s.' %(id, target_seq_id), '\n'

# Loop through all 3 forward reading frames of of target sequence to find longest orf of each

for i in range(1, num_frames + 1):
    frame = i
    longest_orf = find_longest_orf(target_seq, frame)
    
    print 'The seq_orf_id, start and stop positions, and length of longest orf of all sequences'
    print 'in reading frame %d are as follows:'  %frame, longest_orf, '\n'

print "======================================================================================", '\n'

# ===========================================================================================

def frag_lib(seq, frag_len):
    """ frag_lib returns a list of all of the fragments of length frag_len in a sequence. """

    frag_list = list()
        
    # Create a list of all fragments of length frag_len
        
    for i in range(0, len(seq) - frag_len + 1):
        frag = seq[i:i+frag_len].lower()
#        print frag
        frag_list.append(frag)

    return frag_list


# ===========================================================================================

import inspect

file = open('dna2.fasta')


seq_count = 0               # Keep track of number of sequences in file
line_count = 0              # Keep track of number of lines in file
seq = ''                    # Initialize sequence
seq_dict = dict()           # Initialize sequence dictionary
# seq_id_dict = dict()        # Initialize id dictionary
seq_length_list = list()    # Initialize sequence lengths list

attribute_list = list()

num_lines = len(open('dna2.fasta').readlines())

for line in file:
    line_count += 1
    line = line.strip()

    if not line.startswith('>') and line_count < num_lines:
        seq += line

    elif line_count == num_lines:
        seq += line
        seq_length_list.append(len(seq))
        seq_dict[seq_id] = [id, len(seq), seq]

    elif line.startswith('>'):
    
        if len(seq) > 0:
            seq_length_list.append(len(seq))
            seq_dict[seq_id] = [id, len(seq), seq]

        seq_count += 1
        id = line
        seq_id = 'seq_' + str(seq_count)

        # initialize new sequence
        seq = ''        

# ===========================================================================================

# Question 8: Find the most frequently occurring repeat of length 6 in all sequences.
# How many times does it occur in all?

print 'Question 8: \n'

frag_len = 6
frag_list = list()
frag_list_all = list()
frag_count = dict()

for seq_id in seq_dict:
       
    seq = seq_dict[seq_id][2]
    frag_list = frag_lib(seq, frag_len)
#    print frag_list
#    print len(frag_list)
    frag_list_all += frag_list
    
#print frag_list_all
#print len(frag_list_all)

# Create a dictionary of fragments and their counts
for frag in frag_list_all:
    frag_count[frag] = frag_count.get(frag, 0) + 1
    
#print frag_count
#print len(frag_count)

# Loop through fragment dictionary to get the max fragment count

frag_max = None
count_max = None

for frag, count in frag_count.items():
    if count_max is None or count > count_max:
        count_max = count
        frag_max = frag

print 'Fragment %s, of length %d, occurs %d times in all the sequences.' \
%(frag_max, frag_len, count_max), '\n'

print "======================================================================================", '\n'

# ===========================================================================================

# Question 9: Find all repeats of length 12 in the input file. Let's use Max to specify the
# number of copies of the most frequent repeat of length 12. How many different 12-base
# sequences occur Max times?

print 'Question 9: \n'

frag_len = 12
frag_list = list()
frag_list_all = list()
frag_count = dict()
frag_max_list = list()

for seq_id in seq_dict:
       
    seq = seq_dict[seq_id][2]
    frag_list = frag_lib(seq, frag_len)
#    print frag_list
#    print len(frag_list)
    frag_list_all += frag_list
    
#print frag_list_all
#print len(frag_list_all)

# Create a dictionary of fragments and their counts
for frag in frag_list_all:
    frag_count[frag] = frag_count.get(frag, 0) + 1
    
#print frag_count
#print len(frag_count)

# Loop through fragment dictionary to get the max fragment count

frag_max = None
count_max = None

for frag, count in frag_count.items():
    if count_max is None or count > count_max:
        count_max = count
        frag_max = frag
        frag_max_list = list()
        frag_max_list.append(frag)
    elif count == count_max:
        frag_max_list.append(frag)


print 'These %d fragments, %s, of length %d, are the most frequent repeat in all \
of the sequences, occuring %d times each.' %(len(frag_max_list), frag_max_list, frag_len, count_max), '\n'

print "======================================================================================", '\n'

# ===========================================================================================

# Question 10: Which one of the following repeats of length 7 has a maximum number of
# occurrences?

print 'Question 10: \n'

frag_len = 7
frag_list = list()
frag_list_all = list()
frag_count = dict()

for seq_id in seq_dict:
       
    seq = seq_dict[seq_id][2]
    frag_list = frag_lib(seq, frag_len)
#    print frag_list
#    print len(frag_list)
    frag_list_all += frag_list
    
#print frag_list_all
#print len(frag_list_all)

# Create a dictionary of fragments and their counts
for frag in frag_list_all:
    frag_count[frag] = frag_count.get(frag, 0) + 1
    
#print frag_count
#print len(frag_count)

# Loop through fragment dictionary to get the max fragment count

frag_max = None
count_max = None

for frag, count in frag_count.items():
    if count_max is None or count > count_max:
        count_max = count
        frag_max = frag

print 'Fragment %s, of length %d, occurs %d times in all the sequences.' \
%(frag_max, frag_len, count_max), '\n'