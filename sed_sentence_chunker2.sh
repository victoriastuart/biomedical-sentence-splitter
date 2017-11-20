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
# Last updated: 2017-Nov-20

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


# ============================================================================
# NOTES:
# ======

# 1. If the script name is too long for convenient use, just rename it; e.g.: ssc

# 2. For clarity, I insert an additional line break between split sentences
#    (the \n\n part in the regex expressions, below).  If you want to avoid
#    that, just delete one of the newlines (\n) in \n\n.

# 3. Run this script on my "chunk_test_input.txt" file to get an idea of it's
#    capability (or to run your own unit tests).

# 4. If / as needed you can use the Linux "pwgen" command to generate alphanumeric
#    UID.  E.g., "pwgen 6 2" will generate two (unique) 6-character alphanumeric
#    strings.  Example:
#                 $ pwgen 8 2
#                 eej8Ae2p air4Coo2

# 5. Expressions of the sort .{1,15}\.s\s* look complicated, but they are pretty
#    simple!  Basically it says: match any character ( . ), appearing 1-15
#    times ( {1,15}, that is followed by a period ( \.) and any space ( \s\s* ) ...
#    Likewise: ^[A-Z].{1,5}\. says match any 1..5 preceding characters that are
#    not capitals, followed by a period ...
#
#    sed -i -r "s/[.](.[^0-9]{1,15})[.]/Shah7a\1./g" tmp_file
#
#    likewise translates to: match, in place, a period [.] that is followed by
#    any span of 1-15 characters {1,15}, that are not 0 through 9 [^0-9],
#    followed by another period [.].  All of that is this bit: .[^0-9]{1,15})[.]
#
#    The second half of that regex expression states: replace replace THOSE
#    periods (matched as described) with the unique alphanumeric string, Shah7a,
#    followed by a period.
#
#    sed -i -r "s/.[^.]\{1,15\}.\s\s*/\n\n/g" tmp_file
#
#    Match any character ( . ), appearing 1-15 times ( {1,15} that is NOT a
#    period ( !. ), but is followed by a period ( \.) and any space ( \s\s* ),
#    and split ( \n\n ) at that position:

# 6. Journal author name initials and journal title abbreviations are a huge
#    programmatic, technical difficulty.  My approach, below, minimizes
#    the disruptions of those viz-a-viz bone fide sentence chunking (which is
#    quite excellent!), but some issues (will inevitably) remain.  E.g., some
#    very short sentences will not get split from the others.  Overall, the
#    journal title abbreviations are handled remarkably well; the authors
#    initialization, much less so.  Fortunately, those mostly affect the
#    citations, which are not that useful for most BioNLP work (e.g.,
#    information extraction).  C'est la vie!!

# 7. AS A CONSEQUENCE OF DEALING WITH SMALL ABBREVIATED WORDS (JOURNAL TITLE
#    ABBREVIATIONS ...), NECESSARILY SOME SMALL SENTENCES WILL NOT GET SPLIT
#    FROM THE OTHERS.  E.g.: "Robert O. Watson. More more added text." HERE,
#    "WATSON." WAS PROCESSED AS AN ABBREVIATION AND THUS ESCAPED FROM SENTENCE
#    SPLITTING.
#
#    It appears that Citations at the end of papers are mostly affected by this
#    issue.  Again, given that these are mostly not utilized in most BioNLP,
#    it is a trivial (remaining) issue.  [I may return to it, one day.]
#
#    Again, "Cest la vie!"

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

# ============================================================================

# ----------------------------------------------------------------------------
# SPECIAL CASES -- COMMON ABBREVIATIONS:
# --------------------------------------

# ----------------------------------------
# PAGE NUMBER ABBREVIATIONS:

# Approach: substitute a unique alphanumeric string for "pp." (we will restore
# it later).  Generated via the Linux command: pwgen 6 1

# Page number abbreviation "pp.":

sed -r 's/ pp\. ([ivx0-9])/Cho4Ph\1/g' $input > tmp_file

# NOTE: process "pp." BEFORE "p.", otherwise substitution of the "p." in "pp."
# will incorrectly get substituted with "Cho4Ph".

# Page number abbreviation "p.":

sed -i -r 's/ p\. ([ivx0-9])/Eiph2T\1/g' tmp_file

# ----------------------------------------
# versus (vs.) ABBREVIATION:

sed -i 's/ vs\./Air5ah/g' tmp_file

# ----------------------------------------
# "E.g.", "e.g.", "I.e." or "i.e." followed by Capital letter:

sed -i 's/[eE]\.g\./Va1Eed/g' tmp_file
sed -i 's/[iI]\.e\./Uchee4/g' tmp_file

# ----------------------------------------
# "cc.", "CC." or "cf.":

sed -i -r 's/[cC]\.f\./Ri9Ohk/g' tmp_file

# ----------------------------------------
# et al. ABBREVIATION:

sed -i 's/et al\./et al/g' tmp_file

# ----------------------------------------
# PERSONAL TITLES (temporarily replace '.' with ','):

# https://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed

sed -i 's/Dr\./Dr,/g' tmp_file
sed -i 's/Drs\./Drs,/g' tmp_file
sed -i 's/Mr\./Mr,/g' tmp_file
sed -i 's/Mrs\./Mrs,/g' tmp_file
sed -i 's/Ms\./Ms,/g' tmp_file
sed -i 's/St\./St,/g' tmp_file

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

sed -i -r 's/\.\.\.\s\s*([[({'"'"'"A-Z0-9])/...\n\1/g' tmp_file

# '"'"' = escaped single quotation, used internally in single-quoted sed expression

# ----------------------------------------------------------------------------
# LEADING WHITESPACE, TABS:

# Remove all leading and trailing whitespace from sentences as well as multiple spaces:
# https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html

sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp_file

# Replace multiple spaces with single space:

sed -i 's/  */ /g' tmp_file


# ============================================================================
# AUTHOR INITIALS; JOURNAL TITLE ABBREVIATIONS:
# =============================================

# NOTES:
# 1. While I mainly mention journal title abbreviations, the same logic holds
#    for authors initials.
# 2. We will, in logical order, substitute periods in in abbreviations with
#    "Shah7a", later replacing those "Shah7a" substitutions with periods.

# ----------------------------------------------------------------------------
# FIRST, DEAL WITH TERMINAL / "ULTIMATE" ABBREVIATIONS; e.g., the last
# abbreviation in U.S.A | U.S.S.R. ...

# Matches [A-Z].space ( \s ) in (e.g) U.S.A.space:

sed -i -r 's/\.([A-Z])\.\s/.\1Shah7a /g' tmp_file

# Matches [A-Z].EOL (End of Line) in (e.g) U.S.A.EOL:

sed -i -r 's/\.([A-Z])\.$/.\1Shah7a/g' tmp_file

# Matches [A-Z].[A-Z0-9] in (e.g.) U.S.A.The next sentence... ,
# or: U.S.A.88: 7958–7962.  [Also adds the 'missing' space.]
# Note: the "not space" expression ( [^ ] ) will capture the first character
# AFTER that space, so here we need to add (also) the [a-z] part, also!

sed -i -r 's/\.([A-Z])\.([^ ][a-zA-Z0-9])/.\1Shah7a \2/g' tmp_file

# ----------------------------------------------------------------------------
# CATCH HYPHENATED NAMES ABBREVIATIONS (e.g. Chen A.-B. Jiang):

sed -i -r 's/\.-([A-Z])\./.-\1Shah7a/g' tmp_file

# ----------------------------------------------------------------------------
# NOW, DEAL WITH THE PENULTIMATE, ANTEPENULTIMATE, PREANTEPENULTIMATE ... ABBREVIATIONS:

# Matches S. in (e.g) U.S.AShah7a :

sed -i -r 's/([A-Z])\.([A-Z]Shah7a)/\1Shah7a\2/g' tmp_file

# Matches U. in (e.g) U.SShah7aAShah7a :

sed -i -r 's/([A-Z])\.([A-Z]Shah7a[A-Z]Shah7a)/\1Shah7a\2/g' tmp_file

# Extend that chain a few more times to capture longer sequences of 1-letter abbreviations:

sed -i -r 's/([A-Z])\.([A-Z]Shah7a[A-Z]Shah7a[A-Z]Shah7a)/\1Shah7a\2/g' tmp_file
sed -i -r 's/([A-Z])\.([A-Z]Shah7a[A-Z]Shah7a[A-Z]Shah7a[A-Z]Shah7a)/\1Shah7a\2/g' tmp_file

# ----------------------------------------------------------------------------
# NOW, DEAL WITH JOURNAL TITLE ANNOYANCES, in the order (e.g.) J., Am., Soc.,
# Bact., Virol. ...; i.e. sequentially process abbreviations of the type
# J. Am. Soc. Bact. Virol. ...  As this is done stepwise, it should capture
# all permutations, e.g. J. Cdn. Med. Assoc. ...

# To begin, match single-letter abbreviations preceded by a space OR at the
# start of a line:

sed -i -r 's/(^[A-Z])\./\1Shah7a/g' tmp_file
sed -i -r 's/ ([A-Z])\./ \1Shah7a/g' tmp_file

# ----------------------------------------------------------------------------
# NOW, DEAL WITH INCREASING LONGER ABBREVIATIONS: Am.; Soc.; ... :
# To capture parenthesized journal references, internally-quoted within
# sentences, that contain title abbreviations, I added here the [[({ ]
# bit.  That captures "[" (NOTE: that "[" MUST appear FIRST in the "[ ]"
# character expression), "(", "{".
# E.g.:  ... as quoted by Smith et al. (Phys. Rev. Lett. ...

sed -i -r 's/([[({ ][A-Z][a-z].{0})\./\1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{1})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{2})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{3})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{4})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{5})\./ \1Shah7a/g' tmp_file
sed -i -r 's/[[({ ]([A-Z][a-z].{6})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{7})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{8})\./ \1Shah7a/g' tmp_file
sed -i -r 's/([[({ ][A-Z][a-z].{9})\./ \1Shah7a/g' tmp_file

# ----------------------------------------------------------------------------
# CAVEAT:
# -------

# Sentences of less than length y in the {y} span above will NOT be split.

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

# That observation is important re: the "([])}])" pattern below (that searches
# for characters ")", "}" and ")").  You MUST list the "]" closing bracket
# (within the "([  ])" character class), with the "]" square bracket listed FIRST:
# "([])}])".

# The following should capture all permutations of two contiguous sentences,
# where the inter-sentence boundary may contain any permutation of terminal
# punctuation (".", "!", "?"), parentheses and brackets ("(", "{, "[", ")", "}",
# "]", and any combination of quotation marks -- and split those sentences!

# sed -i -r 's/([A-Z]\.)\s\s*([A-Z])/\1\n\2/g' tmp_file

sed -i -r 's/([a-zA-Z0-9][\.!?])\s\s*([A-Z0-9])/\1\n\2/g
           s/([a-zA-Z0-9][\.!?])(['"'"'"])\s\s*([A-Z0-9])/\1\2\n\3/g
           s/([a-zA-Z0-9]['"'"'"])([\.!?)])\s\s*([A-Z0-9])/\1\2\n\3/g
           s/([a-zA-Z0-9][\.!?])([])}])\s\s*([A-Z0-9])/\1\2\n\3/g
           s/([a-zA-Z0-9][)'"]"'}])([\.!?])\s\s*([A-Z0-9])/\1\2\n\3/g
           s/([a-zA-Z0-9][\.!?])(['"'"'"])([]})])\s\s*([A-Z0-9])/\1\2\3\n\4/g
           s/([a-zA-Z0-9][\.!?])([)'"]"'}])(['"'"'"])\s\s*([A-Z0-9])/\1\2\3\n\4/g
           s/([a-zA-Z0-9][]})])(['"'"'"])([\.!?])\s\s*([A-Z0-9])/\1\2\3\n\4/g
           s/([a-zA-Z0-9]['"'"'"])([\.!?])([]})])\s\s*([A-Z0-9])/\1\2\3\n\4/g
           s/([a-zA-Z0-9]['"'"'"])([]})])([\.!?])\s\s*([A-Z0-9])/\1\2\3\n\4/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\n\3\4/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\n\3\4/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\n\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*([[{(])([A-Z0-9])/\1\2\3\4\n\5\6/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\n\3\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*(['"'"'"])([[{(])([A-Z0-9])/\1\2\3\4\n\5\6\7/g' tmp_file

sed -i -r 's/([a-zA-Z0-9])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\n\3\4\5/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?)])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([]})])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\n\4\5\6/g
           s/([a-zA-Z0-9])([\.!?])(['"'"'"])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])([\.!?])([]})])(['"'"'"])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])([]})])(['"'"'"])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([\.!?])([]})])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6\7/g
           s/([a-zA-Z0-9])(['"'"'"])([]})])([\.!?])\s\s*([[{(])(['"'"'"])([A-Z0-9])/\1\2\3\4\n\5\6\7/g' tmp_file


# ============================================================================
# RESTORATIONS -- STAGE 1:
# ========================

# E.g. little bugs that variously remain (or have crept in during processing).

# ----------------------------------------------------------------------------
# Replace multiple (reintroduced; e.g. double) spaces with single space:

sed -i 's/  */ /g' tmp_file

# ----------------------------------------------------------------------------
# Split otherwise normal but unsplit sentences:

sed -i -r 's/(.[^\.]{1,5}[a-z])\.\s\s*([A-Z0-9])/\1.\n\2/g' tmp_file

# ----------------------------------------------------------------------------
# Split sentence ending in number from following sentence:

sed -i -r 's/([0-9])\.\s\s*([A-Z0-9])/\1.\n\2/g' tmp_file

# ----------------------------------------------------------------------------
# Split ). [A-Z]

sed -i -r 's/\)\.\s\s*([A-Z0-9])/).\n\1/g' tmp_file

# ----------------------------------------
# Split sentences ending in "St.":

sed -i -r 's/St\.\s\s*([A-Z])/St.\n\1/g' tmp_file

# ----------------------------------------
# Improperly terminated sentence:

sed -i -r 's/!\.\s\s*([A-Z])/! \n\1/g' tmp_file


# ============================================================================
# "RESTORATIONS -- STAGE 2:
# ========================

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
# Restore et al. :

sed -i 's/et al/et al./g' tmp_file

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

# ----------------------------------------
# Restore personal titles (replace ',' with '.'):

sed -i 's/St,/St./g' tmp_file
sed -i 's/Ms,/Ms./g' tmp_file
sed -i 's/Mrs,/Mrs./g' tmp_file
sed -i 's/Mr,/Mr./g' tmp_file
sed -i 's/Drs,/Drs./g' tmp_file

# ----------------------------------------------------------------------------
# LASTLY (DO AFTER ALL OF THE ABOVE!):
# RESTORE AUTHOR INITIALS, JOURNAL TITLE ABBREVIATIONS:
# -----------------------------------------------------

sed -i "s/Shah7a/./g" tmp_file


# ============================================================================
# POSTPROCESSING:
# ===============

# ----------------------------------------
# Delete { ---------- | ========== }-type lines:

sed -i '/^[-=]*$/d' tmp_file
# Deletes all of these:
#  ---------------------
#  =====================
#  --------=====--------
#  =====----------=====

#sed -i '/^-*$/d' tmp_file
#sed -i '/^=*$/d' tmp_file
# Deletes these:
#  --------------------
#  ====================
# not these:
#  -------=====--------
#  =====----------=====

# ----------------------------------------
# Delete empty (blank) lines:

#sed -i '/^$/d' tmp_file
sed -i '/^\s*$/d' tmp_file

# ----------------------------------------------------------------------------
# Split 's. [A-Z]       ## e.g.: Alzheimer's. The
# Note: need to do this near the end of this script:

sed -i -r "s/'s\. ([A-Z])/'s.\n\1/g" tmp_file


# ============================================================================
# FINAL SED OPERATION:
# ====================

# Final sed operation; output to file:

sed 's/Dr,/Dr./g' tmp_file > out_file   ## << note: this is "$output" in my script
                                        ## that reads input file, outputs output file
cat out_file

OUTPUT=$(printf out_file)
#OUTPUT=$(echo output)      ## either of these seem to work; I prefer 'printf'
export $OUTPUT

# ----------------------------------------
# Remove temp files:

rm -f tmp*

# ============================================================================

