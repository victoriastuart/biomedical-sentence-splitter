#!/bin/bash

# sed_sentence_chunker.sh

# ----------------------------------------------------------------------------
# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_sentence_chunker.sh

# For command-line text input/output, use
# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker2.sh

# Created: 2017-Jul-20 | Victoria Stuart | "mail"..@t.."VictoriasJourney.com"
# Updated: 2017-Jul-30
#          2017-Oct-{02 | 03 |04}

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
# PRELIMINARIES:
# ==============

# ----------------------------------------
# INPUT, OUTPUT FILES:
# --------------------

# Note -- cannot have spaces around " = " sign:
input=$1
output=$2

# ----------------------------------------
# ALERT - INCORRECT USAGE:
# ------------------------

# Print error message if incorrect usage
# (input and/or output file not specified):

# https://unix.stackexchange.com/questions/47584/in-a-bash-script-using-the-conditional-or-in-an-if-statement
# https://serverfault.com/questions/7503/how-to-determine-if-a-bash-variable-is-empty

if [ -z $input ] || [ -z $output ]; then
    printf "\n\tssc (sed sentence chunker; see ~/.bashrc)\n\tUsage: ssc <input_file> <output_file>\n\n";
exit; fi

# ----------------------------------------
# CITATIONS - AUTHORS ABBREVIATIONS:

# Remove periods in initials:
sed -r 's/( [A-Z])\.([A-Z])\.([A-Z])\.([A-Z])\. /\1\2\3\4 /g' $input > tmp_file
sed -i -r 's/( [A-Z])\. ([A-Z])\. ([A-Z])\. ([A-Z])\. /\1\2\3\4 /g' tmp_file

sed -i -r 's/( [A-Z])\.([A-Z])\.([A-Z])\. /\1\2\3 /g' tmp_file
sed -i -r 's/( [A-Z])\. ([A-Z])\. ([A-Z])\. /\1\2\3 /g' tmp_file

sed -i -r 's/( [A-Z])\.-([A-Z])\. /\1\2 /g' tmp_file
sed -i -r 's/( [A-Z])-([A-Z])\. /\1\2 /g' tmp_file

sed -i -r 's/( [A-Z])\.([A-Z])\. /\1\2 /g' tmp_file
sed -i -r 's/( [A-Z])\. ([A-Z])\. /\1\2 /g' tmp_file

sed -i -r 's/( [A-Z])\. /\1 /g' tmp_file
sed -i -r 's/( [A-Z])\. /\1 /g' tmp_file

# ----------------------------------------
# SPECIAL CASES -- COMMON ABBREVIATIONS:

# ----------------------------------------
# PAGE NUMBER ABBREVIATIONS:
# --------------------------

# Approach: substitute unique alphanumeric string for "pp."
# [Generated via "pwgen 6 1" (restore later).]

# Page number abbreviation "pp.":
sed -i -r 's/ pp. ([ivx0-9])/Cho4Ph\1/g' tmp_file

# NOTE: process "pp." BEFORE "p.", otherwise substitution of the "p." in "pp." will
# incorrectly get substituted with "Cho4Ph".

# Page number abbreviation "p.":
sed -i -r 's/ p. ([ivx0-9])/Eiph2T\1/g' tmp_file

# ----------------------------------------
# versus (vs.) abbreviation:

sed -i 's/ vs./Air5ah/g' tmp_file

# ----------------------------------------
# PERSONAL TITLES (replace '.' with ','):

# https://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed

sed -i 's/Dr. /Dr, /g' tmp_file
sed -i 's/Drs. /Drs, /g' tmp_file
sed -i 's/Mr. /Mr, /g' tmp_file
sed -i 's/Mrs. /Mrs, /g' tmp_file
sed -i 's/Ms. /Ms, /g' tmp_file

# This will prevent splitting on St. (Saint) abbreviation, but St. (Street) is more likely
# (esp. in biomedical literature?), esp. at end of sentenced, so commented out this line:
#sed -i 's/St. /St, /g' tmp_file

sed -i 's/fig. /fig, /g' tmp_file
sed -i 's/figs. /figs, /g' tmp_file
sed -i 's/Fig. /Fig, /g' tmp_file
sed -i 's/Figs. /Figs, /g' tmp_file

# ----------------------------------------
# OTHER COMPLICATIONS, PECULIARITIES:

# use "pwgen 6 2" for UUIDs (e.g. pwgen 6  2 >> AdaeJ7)

sed -i 's/," "/AdaeJ7/g' tmp_file
sed -i 's/??/?/g' tmp_file

# ------------------

# "e.g." or "i.e." followed by Capital letter:
sed -i -r 's/[eE]\.g\.\s\s*([A-Z])/Va1Eed\1/g' tmp_file
sed -i -r 's/[iI]\.e\.\s\s*([A-Z])/Uchee4\1/g' tmp_file

sed -i -r 's/[cC]\.f\.\s\s*([A-Z])/Ri9Ohk\1/g' tmp_file

# ----------------------------------------
# LEADING WHITESPACE, TABS:

# Remove all leading and trailing whitespace from sentences as well as multiple spaces:
# https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html
sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp_file

# Replace multiple spaces with single space:
sed -i 's/  */ /g' tmp_file

# ----------------------------------------
# CITATIONS - JOURNAL TITLE ABBREVIATIONS:

# Another very tricky 'problem' -- by far the greatest challenge!  I needed to approach
# these as textual spans, presuming that most journal abbreviations are <= 15 characters
#    "Gastroenterol."  : 14 char
# This "span" can can be adjusted below, if / as needed.

#https://stackoverflow.com/questions/29953042/limit-sed-to-certain-character-range-in-a-line
#https://stackoverflow.com/questions/538664/using-sed-how-do-you-print-the-first-n-characters-of-a-line
# https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html

# ----------------------------------------
# APPROACH:
# ---------

#   Match periods followed by a span of .{x,y} characters (replace first period
#   with Shah7a; replace 2nd period with Aesh4s):

# ----------------------------------------
# LOGIC:
# ------

#   {._ _ _ _ _.}  -->  {i_ _ _ _ _.}
#   Repeat / iterate expression above as needed (see explanation, above),
#   then make final substitution (terminal period, in {x,y} span):
#   {i_ _ _ _ _.}  -->  {i_ _ _ _ _j}
#   Replace i, j substitutions later, restoring periods.

# We will need to iterate this a few more times, to catch longer abbreviated journal titles,
# e.g.: Proc. Natl. Acad. Sci. U.S.A.

# ----------------------------------------
# IMPLEMENTATION:
# ---------------

for i in {1..10}
do
   sed -i -r "s/[.](.[^0-9]{1,15})[.]/Shah7a\1./g" tmp_file
done

# NOW, substitute the second periods (that remain) in the journal title abbreviations:

sed -i -r "s/Shah7a(.[^0-9]{1,15})[.]/Shah7a\1Aesh4s/g" tmp_file

# Fortunately, journal titles very rarely contain numbers [0-9]; therefore, the negation
# [^0-9] prevents the two regex expressions above from capturing (e.g.)
#
#   ... follow-up in PD. Overall, 64.1% of patients ...
#
# If that was allowed to occur, then the Shah7a / 1Aesh4s substitutions of that
# period and that decimal point would prevent those two sentences from being split
# i.e., when those substitutions are replaced with periods, again).
# In this example, those periods (period / decimal point, actually) were within
# the {1,15} span, and thus processed.  Negating numbers from those regex patterns
# means that situations of that type are largely avoided (as much as is possible)!

# To recap:
#
#   sed -i -r "s/[.](.[^0-9]{1,15})[.]/Shah7a\1./g" tmp_file
#
# translates to:
#
#   match, in place, A PERIOD [.] that is followed by any span of 1-15 characters {1,15},
#   that are not 0 through 9 [^0-9], followed by another period [.].
#
# All of that is this bit: .[^0-9]{1,15})[.]
#
# The second half of that regex expression states:
#
#   replace replace THOSE periods (matched as described) with the unique alphanumeric
#   string, Shah7a, followed by a period.
#
# We need to add that last period, to capture other, "adjacent"
# (within the {1,15} span) journal title abbreviations.
#
# Whew!  :-p

# ----------------------------------------
# CAVEAT:
# -------

# Input strings " " with sentences of < length y (in the {x,y} span, above) will NOT be split.  E.g.,
#
#   "This is S1. This is S2."
#
# will not split, as those sentences are only 11 characters (including the periods).
# These are expected to be relatively uncommon; if problematic, adjust the span length in {x,y}.

# As I said, abbreviated journal titles complicate things.  :-/


# ========================================
# "MAIN" PROCESSING LOOP:
# =======================

# ----------------------------------------
# PROCESS SENTENCES:

sed -i -r 's/([).?!])\s\s*([A-Z0-9([{])/\1\n\n\2/g' tmp_file

# ----------------------------------------
# PROCESS QUOTATIONS:

# Also a 'problem;' partial solution (idea) per
# https://stackoverflow.com/questions/24509214/how-to-escape-single-quote-in-sed

# Process double-quoted (" ") sentences:
sed -i -r 's/([."])\s\s*([A-Z"])/\1\n\n\2/g' tmp_file

# Process single-quoted (' ') sentences:
sed -i -r "s/([.'])\s\s*([A-Z'])/\1\n\n\2/g" tmp_file


# ========================================
# "RESTORATIONS:"
# ===============

# Restore comma-delimited, double-quoted strings (," "):
sed -i 's/AdaeJ7/," "/g' tmp_file

# ----------------------------------------
# Line break after "." that is followed by new sentence (uppercased string, or number):
sed -i -r 's/([.])\s\s*([A-Z0-9])/\1\n\n\2/g' tmp_file
#
# Restore "vs." (must appear after expression, above):
sed -i 's/Air5ah/ vs./g' tmp_file
#
# Restore page number abbreviations {pp. | p.}
# (also must appear after 2nd previous expression, above):
sed -i 's/Eiph2T/ p. /g' tmp_file
sed -i 's/Cho4Ph/ pp. /g' tmp_file

# ----------------------------------------
# Restore "[fF]ig. [0-9]":
sed -i 's/fig, /fig. /g' tmp_file
sed -i 's/figs, /figs. /g' tmp_file
sed -i 's/Fig, /Fig. /g' tmp_file
sed -i 's/Figs, /Figs. /g' tmp_file

# Restore "e.g.", "i.e.".
# Note: due to the preceding rule, these two rules must follow, here
# (otherwise, the preceding rule inserts a line break following the space).
sed -i -r 's/Va1Eed/e.g. /g' tmp_file
sed -i -r 's/Uchee4/i.e. /g' tmp_file

sed -i -r 's/Ri9Ohk/c.f. /g' tmp_file

# ----------------------------------------

# Convert ".." to "." (ignore "...", etc.):
sed -i 's/\b\.\./\./g' tmp_file

# Restore personal titles (replace ',' with '.'):
#sed -i 's/St, /St. /g' tmp_file
sed -i 's/Ms, /Ms. /g' tmp_file
sed -i 's/Mrs, /Mrs. /g' tmp_file
sed -i 's/Mr, /Mr. /g' tmp_file
sed -i 's/Drs, /Drs. /g' tmp_file

# ----------------------------------------------------------------------------
# CITATIONS - JOURNAL ABBREVIATIONS:

sed -i "s/Shah7a/./g" tmp_file
sed -i "s/Aesh4s/./g" tmp_file

# The journals abbreviations approach (earlier) is complicated; it captures
# (and restores, here) some unintended non-journal abbreviations text, e.g.
# "). " etc.  Therefore, we need  penultimate sed expression, here, to correct those:
sed -i -r "s/\)\.\s\s*/).\n\n/g" tmp_file

# This looks complicated: basically it says:
# match any character ( . ), appearing 1-15 times ( {1,15} that is NOT a period ( !. ),
# but followed by a period ( \.) and any space ( \s\s* ), and split ( \n\n ) at that position:
sed -i -r "s/.[^.]\{1,15\}.\s\s*/\n\n/g" tmp_file

# ----------------------------------------------------------------------------
# FINAL SED OPERATION:

# Final sed operation; output to file:
sed 's/Dr, /Dr. /g' tmp_file > $output

# ========================================
# CLEAN UP:
# =========

# ----------------------------------------
# Remove temp files:
#rm -f tmp*
rm tmp*

# ============================================================================

