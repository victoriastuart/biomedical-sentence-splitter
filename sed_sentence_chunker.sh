#!/bin/bash

# ----------------------------------------------------------------------------
# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_sentence_chunker.sh

# For command-line text input/output, use
# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker2.sh

# Created: 2017-Jul-20 | Victoria Stuart | "mail"..@t.."VictoriasJourney.com"
# Updated: 2017-Jul-30

# Posted (in part) to:
#   https://gist.github.com/victoriastuart/4f961f65ae4f7b742d11e95395384692

# Detailed notes: /mnt/Vancouver/Reference/Linux/chunking - sentences (delimiters; sed).txt

# If the script name is "too long" for convenient use, just rename it; e.g.: ssc

# ----------------------------------------------------------------------------
# USAGE:
# ======

#      ./sed_sentence_chunker.sh  <input_file>  <output_file>
#   bash sed_sentence_chunker.sh  <input_file>  <output_file>

# Examples:
# ---------

#   ./sed_sentence_chunker.sh  chunk_test_input.txt  chunk_test_output.txt

# Read from directory/file, output to directory/file:
#   ./sed_sentence_chunker.sh  input/chunk_test_input.txt  output/chunk_test_output.txt

# ============================================================================


# ============================================================================
# PRELIMINARIES:
# ==============

# ========================================
# INPUT, OUTPUT FILES:
# ====================

# Note -- cannot have spaces around " = " sign:
input=$1
output=$2

# ----------------------------------------
# INCORRECT USAGE:
# ----------------

# Print error message if incorrect usage
# (input and/or output file not specified):

# https://unix.stackexchange.com/questions/47584/in-a-bash-script-using-the-conditional-or-in-an-if-statement
# https://serverfault.com/questions/7503/how-to-determine-if-a-bash-variable-is-empty

if [ -z $input ] || [ -z $output ]; then
    printf "\n\tssc (sed sentence chunker; see ~/.bashrc)\n\tUsage: ssc <input_file> <output_file>\n\n";
exit; fi

# ========================================
# sed EXPRESSIONS -- PRELIMINARIES:
# =================================

# ----------------------------------------
# CITATIONS - AUTHORS ABBREVIATIONS:

# Remove periods in initials:
sed -r 's/( [A-Z])\.([A-Z])\.([A-Z])\.([A-Z])\. /\1\2\3\4 /g' $input > tmp_file_1
sed -i -r 's/( [A-Z])\. ([A-Z])\. ([A-Z])\. ([A-Z])\. /\1\2\3\4 /g' tmp_file_1

sed -i -r 's/( [A-Z])\.([A-Z])\.([A-Z])\. /\1\2\3 /g' tmp_file_1
sed -i -r 's/( [A-Z])\. ([A-Z])\. ([A-Z])\. /\1\2\3 /g' tmp_file_1

sed -i -r 's/( [A-Z])\.-([A-Z])\. /\1\2 /g' tmp_file_1
sed -i -r 's/( [A-Z])-([A-Z])\. /\1\2 /g' tmp_file_1

sed -i -r 's/( [A-Z])\.([A-Z])\. /\1\2 /g' tmp_file_1
sed -i -r 's/( [A-Z])\. ([A-Z])\. /\1\2 /g' tmp_file_1

sed -i -r 's/( [A-Z])\. /\1 /g' tmp_file_1
sed -i -r 's/( [A-Z])\. /\1 /g' tmp_file_1

# ----------------------------------------
# SPECIAL CASES -- COMMON ABBREVIATIONS:

# Comment (Victoria): there is v. likely an easier approach, but as a "quick-fix" this will do.

# Approach: substitute unique alphanumeric string for "pp." ((generated via: pwgen 6 1); restore later):

# 1. Page number abbreviation (pp.),
sed -i 's/ pp./Eiph2T/g' tmp_file_1

# 2. versus (vs.) abbreviation:
sed -i 's/ vs./Air5ah/g' tmp_file_1

# ----------------------------------------
# PERSONAL TITLES (replace '.' with ','):

# https://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed

sed -i 's/Dr. /Dr, /g' tmp_file_1
sed -i 's/Drs. /Drs, /g' tmp_file_1
sed -i 's/Mr. /Mr, /g' tmp_file_1
sed -i 's/Mrs. /Mrs, /g' tmp_file_1
sed -i 's/Ms. /Ms, /g' tmp_file_1
# This will prevent splitting on St. (Saint) abbreviation, but St. (Street) is more likely
# (esp. in biomedical literature?), esp. at end of sentenced, so commented out this line:
#sed -i 's/St. /St, /g' tmp_file_1
sed -i 's/fig. /fig, /g' tmp_file_1
sed -i 's/figs. /figs, /g' tmp_file_1
sed -i 's/Fig. /Fig, /g' tmp_file_1
sed -i 's/Figs. /Figs, /g' tmp_file_1

# ----------------------------------------
# OTHER COMPLICATIONS, PECULIARITIES:

# use "pwgen 6 2" for UUIDs (e.g. pwgen 6  2 >> AdaeJ7)

sed -i 's/," "/AdaeJ7/g' tmp_file_1
sed -i 's/??/?/g' tmp_file_1

# ------------------

# "e.g." or "i.e." followed by Capital letter:
sed -i -r 's/[eE]\.g\.\s\s*([A-Z])/Va1Eed\1/g' tmp_file_1
sed -i -r 's/[iI]\.e\.\s\s*([A-Z])/Uchee4\1/g' tmp_file_1

sed -i -r 's/[cC]\.f\.\s\s*([A-Z])/Ri9Ohk\1/g' tmp_file_1


# ========================================
# MAIN PROCESSING LOOP:
# =====================

#sed -r 's/([.?!"])\s\s*([A-Z\"])/\1\n\n\2/g' tmp_file_1 > tmp_file_2

# ----------------------------------------------------------------------------
# LEADING WHITESPACE, TABS:

# Remove all leading and trailing whitespace from sentences as well as multiple spaces:
# https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html
sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp_file_1
# Replace multiple spaces with single space:
sed -i 's/  */ /g' tmp_file_1

# Remove blank lines:
# https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
#sed -i '/^\s*$/d' tmp_file_1

# ----------------------------------------------------------------------------
# CITATIONS - JOURNAL TITLE ABBREVIATIONS:

# Another very tricky 'problem.'  Will need to approach as textual spans, presuming that
# most journal abbreviations are <= 15 characters (can adjust below, if needed).
# For comparison, how long are simple sentences?
#   "Here in the car." : 16 char
#        "In the car." : 11 char

#https://stackoverflow.com/questions/29953042/limit-sed-to-certain-character-range-in-a-line
#https://stackoverflow.com/questions/538664/using-sed-how-do-you-print-the-first-n-characters-of-a-line
# https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html

# Approach:
# ---------

# Match periods followed by a span of .{x,y} characters (replace first period
# with Shah7a; replace 2nd period with Aesh4s):

sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
# Need to iterate a few more times, to catch longer Titles, e.g. Proc. Natl. Acad. Sci. U.S.A.
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
sed -i -r "s/[.](.{1,15})[.]/Shah7a\1./g" tmp_file_1
# NOW, substitute the second period in the journal title abbreviations"
sed -i -r "s/Shah7a(.{1,15})[.]/Shah7a\1Aesh4s/g" tmp_file_1

# Logic:
# ------

# {._ _ _ _ _.}  -->  {i_ _ _ _ _.}
# Repeat / iterate expression above as needed (see explanation, above),
# then make final substitution (terminal period, in {x,y} span):
# {i_ _ _ _ _.}  -->  {i_ _ _ _ _j}
# Replace i, j substitutions later, restoring periods.

# CAVEAT:
# -------

# Input strings " " with sentences of < length y (in the {x,y} span, above) will NOT be split.  E.g.,
#   "This is S1. This is S2."
# will not split, as those sentences are only 11 characters (including the periods).
# These are expected to be relatively uncommon; if problematic, adjust the span length in {x,y}.

# - ---------------------------------------------------------------------------
# QUOTATIONS:

# Also a 'problem;' partial solution (idea) per
# https://stackoverflow.com/questions/24509214/how-to-escape-single-quote-in-sed

# Process double-quotes (" "):
sed -r 's/([?!])\s\s*/\1\n\n/g' tmp_file_1 > tmp_file_2
#sed -r 's/([."])\s\s*([A-Z"])/\1\n\n\2/g' tmp_file_1 > tmp_file_2
sed -r 's/\{5,\}.*([."])\s\s*([A-Z"])/\1\n\n\2/g' tmp_file_1 > tmp_file_2

# Process single-quotes (' '):
sed -i -r "s/([?!])\s\s*/\1\n\n/g" tmp_file_2
sed -i -r "s/([.'])\s\s*([A-Z'])/\1\n\n\2/g" tmp_file_2


# ========================================
# "RESTORATIONS:"
# ===============

# Restore comma-delimited, double-quoted strings (," "):
#sed -i -r 's/,"[\r\n]+"/," "/g' tmp_file_2
sed -i 's/AdaeJ7/," "/g' tmp_file_2

# ----------------------------------------
# Line break after "." that is followed by new sentence (uppercased string, or number):
sed -i -r 's/([.])\s\s*([A-Z0-9])/\1\n\n\2/g' tmp_file_2
#
# Restore "vs." (must appear after expression, above):
sed -i 's/Air5ah/ vs./g' tmp_file_2
#
# Restore "pp." (also must appear after 2nd previous expression, above):
sed -i 's/Eiph2T/ pp./g' tmp_file_2

# ----------------------------------------

# Restore "[fF]ig. [0-9]":
sed -i 's/fig, /fig. /g' tmp_file_2
sed -i 's/figs, /figs. /g' tmp_file_2
sed -i 's/Fig, /Fig. /g' tmp_file_2
sed -i 's/Figs, /Figs. /g' tmp_file_2

# Restore "e.g.", "i.e.".
# Note: due to the preceding rule, these two rules must follow, here
# (otherwise, the preceding rule inserts a line break following the space).
sed -i -r 's/Va1Eed/e.g. /g' tmp_file_2
sed -i -r 's/Uchee4/i.e. /g' tmp_file_2

sed -i -r 's/Ri9Ohk/c.f. /g' tmp_file_2

# ----------------------------------------

# Convert ".." to "." (ignore "...", etc.):
sed -i 's/\b\.\./\./g' tmp_file_2

# Restore personal titles (replace ',' with '.'):
#sed -i 's/St, /St. /g' tmp_file_2
sed -i 's/Ms, /Ms. /g' tmp_file_2
sed -i 's/Mrs, /Mrs. /g' tmp_file_2
sed -i 's/Mr, /Mr. /g' tmp_file_2
sed -i 's/Drs, /Drs. /g' tmp_file_2

# ----------------------------------------------------------------------------
# CITATIONS - JOURNAL ABBREVIATIONS:

sed -i "s/Shah7a/./g" tmp_file_2
sed -i "s/Aesh4s/./g" tmp_file_2

# ----------------------------------------------------------------------------
# FINAL SED OPERATION:

# OUTPUT final (processed) file:
sed 's/Dr, /Dr. /g' tmp_file_2 > $output

# ========================================
# CLEAN UP:
# =========

# ----------------------------------------
# Remove temp files:
#rm -f tmp*
rm tmp*


# ========================================
# NOTES:
# ======

# 'rm -f' is not needed in this script (needed in terminal / on command-line).

# sed command arguments:
#  -r  :  regular expressions
#  -i  :  edit in place (overwrites file)

# (not used) regex match blank lines: ^$

# ============================================================================

