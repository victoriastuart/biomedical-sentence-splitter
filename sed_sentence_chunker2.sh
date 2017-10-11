#!/bin/bash

# ----------------------------------------------------------------------------
# https://github.com/victoriastuart/sed_sentence_chunker/blob/master/sed_sentence_chunker2.sh
# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_sentence_chunker2.sh

# Modification of:
#   https://github.com/victoriastuart/sed_sentence_chunker/blob/master/sed_sentence_chunker.sh
#   /mnt/Vancouver/Programming/scripts/sed_sentence_chunker.sh

# Detailed in my GitHub repo,
#   https://github.com/victoriastuart/sed_sentence_chunker/blob/master/README.md
# and my Personal Projects page at Persagen.com,
#   http://persagen.com/about/victoria/projects/sed_sentence_chunker.html

#      Created: 2017-Sep-26 | Victoria Stuart | info@Persagen.com
# Last updated: 2017-Oct-10

# ============================================================================
# USAGE:
# ======

# See comments at: http://persagen.com/about/victoria/projects/sed_sentence_chunker.html

#        . sed_sentence_chunker2.sh  <<<  "quoted input text / sentences"      ## << note: dot space command
#   source sed_sentence_chunker2.sh  <<<  "quoted input text / sentences"      ## alternative (script sourcing)

# ----------------------------------------
# Example 1:
# ----------

#   . sed_sentence_chunker2.sh <<< "This is sentence 1. This is sentence 1."
#   This is sentence 1.
#
#   This is sentence 2.

#   cat $OUTPUT
#   This is sentence 1.
#
#   This is sentence 2.


# ----------------------------------------
# Example 2:
# ----------

#   S="This is sentence 3. This is sentence 4."

#   . sed_sentence_chunker2.sh <<< $S
#   This is sentence 3.
#
#   This is sentence 4.

#   cat $OUTPUT
#   This is sentence 3.
#
#   This is sentence 4.

# ----------------------------------------------------------------------------
# NOTES:
# ------

# 1. If the script name is too long for convenient use, just rename it; e.g.: ssc

# 2. For clarity, I insert an additional line break between split sentences
#    (the \n\n part in the regex expressions, below).  If you want to avoid
#    that, just delete one of the newlines (\n) in \n\n.

# 3. Run this script on my "chunk_test_input.txt" file to get an idea of it's capability.

# 4. If / as needed you can use the Linux "pwgen" command to generate alphanumeric
#    UID.  E.g., "pwgen 6 2" will generate two (unique) 6-character alphanumeric
#    strings.  Example:
#                 $ pwgen 8 2
#                 eej8Ae2p air4Coo2

# ============================================================================


# ============================================================================
# PRELIMINARIES:
# ==============

# ----------------------------------------
# INPUT, OUTPUT FILES:
# --------------------

# Note -- cannot have spaces around " = " sign:
input=$1
outfile=""   ## output file
OUTPUT=""    ## output variable

# ----------------------------------------------------------------------------
# CITATIONS - AUTHORS INITIALS:

# Remove periods in authors initials:

sed -r 's/([A-Z][\. ])([A-Z][\. ])/\1\2/g' $input > tmp_file

# NOTE that this, above, is the first sed expression in this script; therefore
# it needs to be declared outside the loop below (that iteratively does the
# same thing):

for i in {1..6}
do
    sed -i -r 's/([A-Z][\. ])([A-Z][\. ])/\1\2/g' tmp_file
done


# ----------------------------------------------------------------------------
# SPECIAL CASES -- COMMON ABBREVIATIONS:

# ----------------------------------------
# PAGE NUMBER ABBREVIATIONS:
# --------------------------

# Approach: substitute a unique alphanumeric string for "pp." (we will restore
# it later).  Generated via the Linux command: pwgen 6 1

# Page number abbreviation "pp.":

sed -i -r 's/ pp\. ([ivx0-9])/Cho4Ph\1/g' tmp_file

# NOTE: process "pp." BEFORE "p.", otherwise substitution of the "p." in "pp."
# will incorrectly get substituted with "Cho4Ph".

# Page number abbreviation "p.":

sed -i -r 's/ p\. ([ivx0-9])/Eiph2T\1/g' tmp_file

# ----------------------------------------
# versus (vs.) abbreviation:

sed -i 's/ vs\./Air5ah/g' tmp_file

# ----------------------------------------
# "E.g.", "e.g.", "I.e." or "i.e." followed by Capital letter:

sed -i 's/[eE]\.g\./Va1Eed/g' tmp_file
sed -i 's/[iI]\.e\./Uchee4/g' tmp_file

# ----------------------------------------
# "cc.", "CC." or "cf.":

sed -i -r 's/[cC]\.f\./Ri9Ohk/g' tmp_file

# ----------------------------------------
# PERSONAL TITLES (temporarily replace '.' with ','):

# https://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed

sed -i 's/Dr\. /Dr, /g' tmp_file
sed -i 's/Drs\. /Drs, /g' tmp_file
sed -i 's/Mr\. /Mr, /g' tmp_file
sed -i 's/Mrs\. /Mrs, /g' tmp_file
sed -i 's/Ms\. /Ms, /g' tmp_file

# This will prevent splitting on St. (Saint) abbreviation, but St. (Street) is
# more likely (esp. in biomedical literature?), esp. at end of sentenced, so
# I commented out this line:
#
# sed -i 's/St. /St, /g' tmp_file

# ----------------------------------------
# "Fig.", "fig.", "Figs.", "figs.":

sed -i -r 's/([fF]ig[s])\./\1,/g' tmp_file

# ----------------------------------------------------------------------------
# OTHER COMPLICATIONS, PECULIARITIES:

# ----------------------------------------
# Tandem question marks:

for i in {1..8}
do
   sed -i 's/??/?/g' tmp_file
done

# ----------------------------------------
# Ellipses (ellipsis: ...):

sed -i -r 's/\.\.\.\s\s*([[({'"'"'"A-Z0-9])/...\n\n\1/g' tmp_file

# '"'"' = escaped single quotation, used internally in single-quoted sed expression

# ----------------------------------------------------------------------------
# LEADING WHITESPACE, TABS:

# Remove all leading and trailing whitespace from sentences as well as multiple spaces:
# https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html

sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp_file

# Replace multiple spaces with single space:

sed -i 's/  */ /g' tmp_file


# ============================================================================
# CITATIONS - JOURNAL TITLE ABBREVIATIONS:
# ----------------------------------------

# Another very tricky 'problem' -- by far the greatest challenge!  I needed to approach
# these as textual spans, presuming that most journal abbreviations are <= 15 characters
#    "Gastroenterol."  : 14 char
# This "span" can can be adjusted below, if / as needed.

# https://stackoverflow.com/questions/29953042/limit-sed-to-certain-character-range-in-a-line
# https://stackoverflow.com/questions/538664/using-sed-how-do-you-print-the-first-n-characters-of-a-line
# https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html

# ----------------------------------------
# APPROACH:
# ---------

# Match periods followed by a span of .{x,y} characters (replace first period
# with Shah7a; replace 2nd period with Aesh4s):

# ----------------------------------------
# LOGIC:
# ------

# {._ _ _ _ _.}  -->  {i_ _ _ _ _.}
# Repeat / iterate expression above as needed (see explanation, above),
# then make final substitution (terminal period, in {x,y} span):
# {i_ _ _ _ _.}  -->  {i_ _ _ _ _j}
# Replace i, j substitutions later, restoring periods.

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

# ============================================================================


# ============================================================================
# "MAIN" PROCESSING LOOP:
# =======================

# ----------------------------------------------------------------------------
# PROCESS SENTENCES:
# ------------------

# To escape a single quote within a single-quoted sed expression, you need to
# terminate / chain the single quotes.  E.g., to escape an internal ', terminate
# the sed single-quoted expression with another (internal) ', then escape the
# internal single quote inside the sed expression: "'", then add back (chain)
# another single quote ' to "continue / chain" the sed expression. Similarly,
# to escape (e.g.) a bracket [ ] inside the optional match [] pattern within a
# sed expression, chain the sed command, quoting the bracket term: ['"]"'] ...

# https://stackoverflow.com/questions/18370536/sed-or-operator-in-set-of-regex
# https://stackoverflow.com/questions/14813145/boolean-or-in-sed-regex

# https://serverfault.com/questions/466118/using-sed-to-remove-both-an-opening-and-closing-square-bracket-around-a-string
#   ... all members of a character class lose special meaning (with a few
#       exceptions). And ] loses its meaning if it is placed first.
#
# That observation is important re: the "([])}])" pattern below (that searches
# for characters ")", "}" and ")").  You MUST list the "]" closing bracket
# (within the "([  ])" character class), with the "]" square bracket listed FIRST:
# "([])}])".

# The following should capture all permutations of two contiguous sentences,
# where the inter-sentence boundary may contain any permutation of terminal
# punctuation (".", "!", "?"), parentheses and brackets ("(", "{, "[", ")", "}",
# "]", and any combination of quotation marks -- and split those sentences!

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*([A-Z0-9])/\1\2\n\n\3/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*([A-Z0-9])/\1\2\3\n\n\4/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*([A-Z0-9])/\1\2\3\n\n\4/g
           s/([a-zA-Z0-9])([\.!?])([])}])\s\s*([A-Z0-9])/\1\2\3\n\n\4/g
           s/([a-zA-Z0-9])([)'"]"'}])([\.!?])\s\s*([A-Z0-9])/\1\2\3\n\n\4/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*([A-Z0-9])/\1\2\3\4\n\n\5/g
           s/([a-zA-Z0-9])([\.!?])([)'"]"'}])(['"'"'"])\s\s*([A-Z0-9])/\1\2\3\4\n\n\5/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*([A-Z0-9])/\1\2\3\4\n\n\5/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*([A-Z0-9])/\1\2\3\4\n\n\5/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*([A-Z0-9])/\1\2\3\4\n\n\5/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\n\n\3\4/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\n\n\3\4/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\n\n\3\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\n\n\3\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\n\5\6\7/g' tmp_file


# ============================================================================
# "RESTORATIONS:"
# ===============

# ----------------------------------------
# Restore "vs.":

sed -i 's/Air5ah/ vs./g' tmp_file

# ----------------------------------------
# Restore page number abbreviations {pp. | p.}:

sed -i 's/Eiph2T/ p\. /g' tmp_file
sed -i 's/Cho4Ph/ pp\. /g' tmp_file

# ----------------------------------------
# Restore "e.g." and "i.e.":

sed -i 's/Va1Eed/e.g./g' tmp_file
sed -i 's/Uchee4/i.e./g' tmp_file

# ----------------------------------------
# Restore "cf.":

sed -i 's/Ri9Ohk/c.f./g' tmp_file

# ----------------------------------------
# Capitalize restored "e.g.", "i.e." and "c.f." that appear at the start of a sentence:

sed -i 's/^c\.f\./C.f./g' tmp_file
sed -i 's/^e\.g\./E.g./g' tmp_file
sed -i 's/^i\.e\./I.e./g' tmp_file

# ----------------------------------------
# Restore "Fig.", "fig.", "Figs.", "figs.":

sed -i -r 's/([fF]ig[s]),/\1\./g' tmp_file

# ----------------------------------------
# Convert ".." to "." (ignore "...", etc.):

sed -i 's/\b\.\./\./g' tmp_file

# Restore personal titles (replace ',' with '.'):

# sed -i 's/St, /St. /g' tmp_file
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

# OUTPUT final (processed) file:
sed 's/Dr, /Dr. /g' tmp_file > out_file     ## << note: "$output" in script that reads input file, outputs output file
cat out_file

OUTPUT=$(printf out_file)
#OUTPUT=$(echo output)      ## either of these seem to work; I prefer 'printf'
export $OUTPUT


# ============================================================================
# CLEAN UP:
# =========

# ----------------------------------------
# Remove temp files:
#rm -f tmp*
rm -f tmp*

# ============================================================================

