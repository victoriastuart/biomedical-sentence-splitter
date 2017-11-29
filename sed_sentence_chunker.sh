#!/bin/bash

export LANG=C.UTF-8

# sed_sentence_chunker.sh

#      Created: 2017-Jul-20 | Victoria Stuart | "mail"..@t.."VictoriasJourney.com"
# Last updated: 2017-Nov-28

# ----------------------------------------------------------------------------
#  local: /mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_sentence_chunker.sh
# GitHub: https://github.com/victoriastuart/biomedical-sentence-splitter

# ============================================================================
# USAGE:
# ======

#      ./sed_sentence_chunker.sh
#   bash sed_sentence_chunker.sh

# This script processes text files in the "input/" directory, and outputs to the
# "output/" directory.

# ============================================================================
# PYTHON SCRIPT USAGE:
# ====================

# To use this "sed_sentence_chunker.sh" bash script in a Python script; run 
# this script in a directory that contains your text/input files in an "input/"
# directory.  Note that you must also (manually) create an "output/" directory.

# ============================================================================
# APPROACH:
# =========

#   1. Preprocessing
#   2. Split sentences
#   3. Postprocessing

# ============================================================================
# TWO VARIATIONS OF THIS SCRIPT:
# ==============================

# If desired you can edit this script for alternative runtime options, as
# summarized here.

# ----------------------------------------------------------------------------
# SCRIPT VARIANT 1: specify input, output files on the command line.
# ------------------------------------------------------------------

# Usage:
#      ./sed_sentence_chunker.sh  <input_file>  <output_file>
#   bash sed_sentence_chunker.sh  <input_file>  <output_file>

# Example:
#   ./sed_sentence_chunker.sh  chunk_test_input.txt  chunk_test_output.txt

# 1. Add these at/near top of script (note: cannot have spaces around " = " sign):

  # input=$1
  # output=$2

# 2. Comment out or delete this code section (after the Technical Notes, below):

  # FILES=$(find input -type f -iname "*")
  #
  # for f in $FILES
  #     do
  #       sed -i -e 's/ffi/ffi/g
  #                 s/fi/fi/g
  #                 ... snip ...
  #                 s/x/x/g' $f

# 3. Change "$f" in this line to "$input":

  # sed 's/pp\.\s/Cho4Ph/g' $f > tmp_file

# 4. Near the bottom of the script, add these,

  # sed 's/Dr,/Dr./g' tmp_file > $output
  # rm tmp_file

# and delete these:

  # sed -i 's/Dr,/Dr./g' tmp_file
  # mv tmp_file output/$outname

# ----------------------------------------------------------------------------
# SCRIPT VARIANT 2: directly pass input text on the command line.
# ------------------------------------------------------------------

# Usage:
#        . sed_sentence_chunker.sh  <<<  "quoted input text / sentences"      ## << note: dot space command
#   source sed_sentence_chunker.sh  <<<  "quoted input text / sentences"      ## alternative (script sourcing)

# ----------------------------------------
# Examples:
#   . sed_sentence_chunker.sh <<< "This is sentence 1. This is sentence 1."
# or:
#   S="This is sentence 3. This is sentence 4."
#   . sed_sentence_chunker.sh <<< $S

# 1. Add these at/near top of script (note: cannot have spaces around " = " sign):

  # input=$1
  # outfile=""   ## output file
  # OUTPUT=""    ## output variable

# 2. Comment out or delete this code section (after the Technical Notes, below):

  # FILES=$(find input -type f -iname "*")
  #
  # for f in $FILES
  #     do
  #       sed -i -e 's/ffi/ffi/g
  #                 s/fi/fi/g
  #                 ... snip ...
  #                 s/x/x/g' $f

# 3. Change "$f" in this line to "$input":

  # sed 's/pp\.\s/Cho4Ph/g' $f > tmp_file

# 4. Near the bottom of the script, add these,

  # sed 's/Dr,/Dr./g' tmp_file > out_file
  # OUTPUT=$(printf out_file)
  # export $OUTPUT
  # rm -f tmp*

# and delete these:

  # sed -i 's/Dr,/Dr./g' tmp_file
  # mv tmp_file output/$outname

# ============================================================================
# TECHNICAL NOTES:
# ================

# ----------------------------------------------------------------------------
# SCRIPT NAME ...:
# ----------------

# If the script name is too long for convenient use, just rename it; e.g.: ssc

# Run this script on my "chunk_test_input.txt" file to get an idea of it's
# capability (or to run your own unit tests).

# If needed you can use the Linux "pwgen" command to generate alphanumeric
# UID: "pwgen 8 2" will generate two (unique) 8-character alphanumeric strings.
# Example: $ pwgen 8 2 >> eej8Ae2p | air4Coo2

# ----------------------------------------------------------------------------
# FIRST SED COMMAND IN THIS SCRIPT:
# ---------------------------------

# After much (!) experimentation, it appears that the first sed command (below),
# outputting to the "tmp_file", MUST involve an "-r" argument (that in turn
# expects a regex expression). To achieve this, it is best to use the first
# command, as shown below.  [Otherwise, you end up with blank output.]

# ----------------------------------------------------------------------------
# [a-zA-Z] vs. [A-Za-z] :
# -----------------------

# [a-zA-Z] **also** matches the ASCII characters between z and A: [ \ ] ^ _ `
# [A-Za-z] will only match the alphabet

# https://stackoverflow.com/questions/4923380/difference-between-regex-a-z-and-a-za-z
# http://www.asciitable.com/
# https://en.wikipedia.org/wiki/ASCII#/media/File:USASCII_code_chart.png

# ----------------------------------------------------------------------------
# REGEX EXPRESSIONS:
# ------------------

# I predominantly use two sed expressions -- the second, here, involving regex:

#     sed -i    's/foo/bar/g' 
#     sed -i -r 's/foo\s?/bar/g'                ## \s? : 0 or 1 (?) spaces (\s)

#  . : any char, including newline (\n)_
# \. : period (literal period)
# -i : --in-place

# Regex "special" characters,
#   [\^$.|?*+()
# have special meaning / function, and will thus need to be \-escaped.

# { and } are literal characters, unless they're part of a valid regular
# expression token such as a quantifier, e.g.: {3}.

# https://www.regular-expressions.info/refcharacters.html

# ----------------------------------------
# HERE IS MY (WORKING) EXPERIENCE RE: SED AND REGEX:

# In non-regex sed expressions, those special characters will need to be \-escaped
# to indicate that they are a regex special (not a literal) character.

# in regex (-r) sed expressions, they will be recognized as regex special
# characters, and will not have to be \-escaped.

# Exception: as noted, [ is a special character in regex -- denoting (e.g.) the
# start of a character class / set (https://www.regular-expressions.info/charclass.html).
# HOWEVER, unlike ?{}*^$ etc., in non-regex sed expressions, we need to escape
# it, \[ if we want to match a literal "[" in our expressions. [That applies,
# also, to regex (-r) sed expressions!]. 

# To match the start (^) or end ($) of a line. don't ever \-escape the ^ or $.

# To match the end of a line (EOL) ending (e.g.) with: ... the end.
#
# sed    's/the end\.$/the end.\n\Period./g'    ## \. : literal period; $ EOL
# sed -r 's/the end\.$/the end.\n\Period./g'    ## \. : literal period; $ EOL

# sed    's/the end.$/the end.\n\Period./g'     ## .  : any single characer; $ EOL
# sed -r 's/the end.$/the end.\n\Period./g'     ## .  : any single characer; $ EOL

# To match a literal $, anywhere in a line / sentence, \-escape the $ ( \$ ):
#
# sed    's/\$/\n/g'
# sed -r 's/\$/\n/g'

# Likewise (viz-a-viz: ^ $), there is no need to ever escape * if you intend it
# to match 0 or more of the preceding expression:
#
# sed    's/foo\s*bar/Foo.\n(Bar!)/g'         ## matches 0 or more spaces between foo and bar
# sed -r 's/foo\s*bar/Foo.\n(Bar!)/g'         ## ditto
#
# sed -r 's/foo\*bar/Foo.\n(Bar!)/g'          ## matches foo*bar

# sed    's/foo*bar/Foo.\n(Bar!)/g'           ## matches foobar (0 or more o)
# sed -r 's/foo*bar/Foo.\n(Bar!)/g'           ## matches foobar (0 or more o)
# sed    's/foob*ar/Foo.\n(Bar!)/g'           ## matches foobar (0 or more b)
# sed -r 's/foob*ar/Foo.\n(Bar!)/g'           ## matches foobar (0 or more b)
# sed    's/fooz*bar/Foo.\n(Bar!)/g'          ## matches foobar (0 or more z)
# sed -r 's/fooz*bar/Foo.\n(Bar!)/g'          ## matches foobar (0 or more z)
#
# compare to:
#
# sed    's/foo?bar/Foo.\n(Bar!)/g'           ## does NOT match foobar; MATCHES foo?bar (literal ?)
# sed    's/foo\?bar/Foo.\n(Bar!)/g'          ## matches foobar (0 or 1 o); does not match foo?bar
# sed -r 's/foo?bar/Foo.\n(Bar!)/g'           ## matches foobar (0 or 1 o); does not match foo?bar

# ----------------------------------------
# MORE EXAMPLES:

# model: sed 's/foo/bar/g'

# sed    's/foo\s\?bar/Foo.\nBar!/g'
# sed -r 's/foo\s?bar/Foo.\nBar!/g'
#
## 0 or 1 (?) spaces (\s)
##        matches: foobar | foo bar
## does not match: foo  bar | foo   bar | ...

# sed    's/foo\s\{0,3\}bar/Foo.\nBar!/g'
# sed -r 's/foo\s{0,3}bar/Foo.\nBar!/g'
#
##         {0,3} : 0, 1, 2 or 3 of preceding sequence (here: space, \s)
##        matches: foobar | foo bar | foo  bar | foo   bar
## does not match: foo    bar | foo     bar | ...

# Regarding [ :

# sed    's/foo\s\?\[bar]/Foo.\n(Bar!)/g'
# sed -r 's/foo\s?\[bar]/Foo.\n(Bar!)/g'
#
##             \[: match literal [
##        matches: foo[bar] | foo [bar]
## does not match: foo  [bar] | foo   [bar] | foo    [bar] | foo     [bar] | ...
## does not match: foobar | foo bar | foo  bar | ...

# sed    's/foo\s\?[bar]/Foo.\n(Bar!)/g'
# sed -r 's/foo\s?[bar]/Foo.\n(Bar!)/g'
#
##        matches: foobar | foo bar
##                 replacing foo with Foo. and [bar] with (Bar!)ar
##                 (with a line break, \n, between them)!
## does not match: foo[bar] | foo [bar | ...
#
## Here, even in a non-regex sed expression, [bar] is being processed as a
## character class (like [A-Za-z0-9]), and so will match the b in foobar, but
## not the b in foo[bar]. To match the literal [ in that non-regex sed expression,
## \-escape the [, \[ , as shown further above / here:

# sed    's/foo\s\{0,3\}\[bar]/Foo.\n(Bar!)/g'
# sed -r 's/foo\s{0,3}\[bar]/Foo.\n(Bar!)/g'
#
##        matches: foo[bar] | foo [bar] | foo  [bar] | foo   [bar]
## does not match: foo    [bar] | foo     [bar] | ...
## does not match: foobar | foo bar | foo  bar | ...

# ----------------------------------------

# sed -r 's/\.([A-Z])\.$/.\1Shah7a/g'
#
## \. : literal period; ([A-Z]) : ASCII capitals in character class ();
## $ : end of line, non-escaped; . : period (do not need to escape in
## replace portion of the sed expression; \1 : replace with captured
## characters (class); Shah7a : an alphanumeric "tag" / substitution / 
## UID (that I will replace later with the text it represents: .)

# sed -r 's/([[({\s])pp\.\s?([ivx0-9])/\1Cho4Ph\2/g' $f > tmp_file
#
## NOTE: that "[" MUST appear FIRST in the "[...]" character expression);
## i.e., [[...].  Also, if used, escape ] (i.e., \]).  Lastly, as this is
## a -r regex expression, the ? is not \?-escaped; ...

# ----------------------------------------
# SED REGEX SUMMARY:
# ==================

# 1. No need to \-escape:   ^  (start of line)
#                           $  (EOL) 
#                           [] (character class / set)    ## sed 's/foo[b]ar/foo\nbar/g'
#                           *  (0 or more instances of matches for preceding expression)
#
# in: sed    's///g'
# or: sed -r 's///g'

# 2. \-escape:  ? (0 or 1 of preceding expression)      ## \?
#               * (0 or more of preceding expression)   ## \*
#               { and } in {i,j} expressions            ## \{0,3\}
#
#     in: sed    's///g'
# not in: sed -r 's///g'

# ----------------------------------------

# In the script below, I tried to minimize the use of "lookaheads" () in
# my sed ( -r ) expressions, as I found these to increase the runtime.
# That is, where possible / practical, I tended to prefer the simpler 
# sed -i 's///g' expressions.

# Expressions of the sort .{1,15}\.s\s* look complicated, but they are pretty
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
#    The second ("replace")_half of that regex expression states: replace replace
#    THOSE periods (matched as described) with the unique alphanumeric string,
#    Shah7a, followed by a period.
#
#    sed -i -r "s/.[^.]\{1,15\}.\s\s*/\n\n/g" tmp_file
#
#    Match any character ( . ), appearing 1-15 times ( {1,15} that is NOT a
#    period ( !. ), but is followed by a period ( \.) and any space ( \s\s* ),
#    and split ( \n\n ) at that position.

# https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html
# http://www.rexegg.com/regex-quickstart.html

# ----------------------------------------------------------------------------
# ABBREVIATIONS -- JOURNAL TITLES; AUTHORS ...
# --------------------------------------------

# Journal author name initials and journal title abbreviations are a huge
# programmatic, i.e. technical difficulty.  While my approach, below, minimizes
# the disruptions of those viz-a-viz bone fide sentence chunking, some issues
# will inevitably remain.  E.g., some very short sentences may not get split
# from the others.  C'est la vie!

# ----------------------------------------------------------------------------
# THESE COMMENTS:
# ---------------

# I deleted all of these comments from this script, leaving only the commands.
# The runtimes (time ./sed_sentence_chunker.sh) were essentially identical.

# ----------------------------------------------------------------------------
# OLDER NOTES / REFERENCE ...
# ---------------------------

# These notes are no longer relevant viz-a-viz this script, but are useful
# re: my earlier versions -- and general knowledge (preserved here!).

# ----------------------------------------
# ESCAPING SINGLE QUOTES WITHIN SINGLE-QUOTED EXPRESSIONS:
# --------------------------------------------------------

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

# sed -i -r 's/([A-Z]\.)\s\s*([A-Z])/\1\n\n\2/g' tmp_file

# To "follow" these, focus on the second part (after the \n break):
# '"'"' = escaped single quotation, used internally in single-quoted sed expression
# Since multiple spaces were converted (above) to single spaces, sentences will
# be separated by 0 or 1 spaces.  Hence, the ".?" expression, below, will match
# 0 or 1 characters, between the two parts of these sed regex expressions 
# [sentences will be split (\n) at those places].

# Replace -- again --  multiple spaces with single space:
# sed -i 's/  */ /g' tmp_file

# ----------------------------------------
# UPDATED [2017-11-24]:
# ---------------------

# With my substitution of ' " ( ) [ ] { } I no longer have to worry about
# those when splitting sentences -- this HUGELY simplifies things!!  :-D
# [E.g., look at the "main processing loops" in my older
# "sed_sentence_chunker{1|2|3}.sh" scripts!]

# As well, I took the approach that since they will not be especially relevant
# for my BioNLP work, tokenized sentences, etc. of deleting all double quotation
# marks: ".  As well, I delete all single quotes around sentences (keeping
# internal single quotes / apostrophes, with the exception that I expand most
# common contractions; e.g. it's --> it is ...).  This (also) greatly simplifies
# the processing, i.e. sentence chunking / splitting!  :-D


# ============================================================================
# ============================================================================
# PRELIMINARIES:
# ==============

# https://stackoverflow.com/questions/4638874/how-to-loop-through-a-directory-recursively-to-delete-files-with-certain-extensi
# FILES=$(find ./input-z -type f -iname "*")
# ... As a number of people have commented, this will fail if there are spaces in filenames.
#     You can work around this by temporarily setting the IFS (internal field separator) to the newline character. ...

IFS=$'\n'; set -f

FILES=$(find ./input -type f -iname "*")          ## ALL files, recursively
# can also use this, in for loop a few lines below:
# for f in $(find ./input-z -type f -iname "*")

# echo '------------------------------------------------------------------------------'
# echo '$FILES:'                      ## single-quoted, prints: $FILES:
# echo "$FILES"                       ## double-quoted, prints path/, filename (one per line)
# echo '------------------------------------------------------------------------------'

for f in $FILES
    do
      cp "$f" "tmp_file"      ## work on a copy so that input file $f is not modified

      # ----------------------------------------------------------------------
      # Preprocessing step -- replace various annoyances (different types of quotation marks; ligatures; ...):
      # https://stackoverflow.com/questions/26568952/how-to-replace-multiple-patterns-at-once-with-sed
      # https://stackoverflow.com/questions/24509214/how-to-escape-single-quote-in-sed
      #   Escape ' within single-quoted sed '...' expressions by substituting those ' with \x27; e.g.:
      #   s/'/'/g  -->  s/'/\x27/g 

      sed -i -e 's/ﬃ/ffi/g
                s/ﬁ/fi/g
                s/ﬀ/ff/g
                s/ﬂ/fl/g
                s/ﬄ/ffl/g
                s/�/μ/g
                s/␮/μ/g
                s/௡/®/g
                s/␣/α/g
                s/␤/β/g
                s/␦/δ/g
                s/5Ј-/5\x27-/g
                s/-3Ј/-3\x27/g
                s/þ/+/g
                s/¼/=/g
                s/ϭ/=/g
                s/Ɛ/=/g
                s/Ͻ/</g
                s/Ͼ/>/g
                s/␥/γ/g
                s/␧/ε/g
                s/␨/ζ/g
                s/Ϫ/-/g
                s/À/-/g
                s/# OLD:/=/g
                s/ ‫؍‬ ./=/g
                s/␹/X/g
                s/Ն/≥/g
                s/Ն/≤/g
                s/Յ/+/g
                s/Ã/*/g
                s/Â/x/g
                s/¥/x/g
                s///g
                s/™//g
                s/®//g
                s/→/>/g
                s/–/-/g
                s/Ϯ/±/g
                s/؉/+/g
                s/ϫ/x/g
                s/ϳ/~/g
                s/ʽ/\x27/g
                s/ʻ/\x27/g
                s/“/"/g
                s/ˮ/"/g
                s/”/"/g
                s/״/"/g
                s/ʺ/"/g
                s/′′/"/g
                s/〃/"/g
                s/’/\x27/g
                s/ʼ/\x27/g
                s/‘/\x27/g
                s/′/\x27/g
                s/`/\x27/g
                s/׳/\x27/g
                s/ʹ/\x27/g
                s/ꞌ/\x27/g
                s/ˊ/\x27/g
                s/ˋ/\x27/g
                s/ˌ/\x27/g
                s/—/-/g
                s/؊/-/g
                s/ϩ/+/g
                s/ϫ/x/g' tmp_file

      # ============================================================================
      # SPECIAL CASES -- COMMON ABBREVIATIONS:
      # --------------------------------------

      # ----------------------------------------
      # PAGE NUMBER ABBREVIATIONS:

      # Approach: substitute a unique alphanumeric string for "pp." (we will restore
      # it later).  Generated via the Linux command: pwgen 6 1

      # Page number abbreviation "pp.", followed by a space; unlikely to appear'
      # at EOL, so we can do a simple substitution:

      sed -i 's/pp\.\s/Cho4Ph/g' tmp_file

      # [ in character expression [] must appear first: [[]; -r regex, therefore

      # [I will process the "p." abbreviation after I strip the document of
      # extraneous whitespace.]

      # ============================================================================
      # WHITESPACE, TABS:

      # Remove leading, trailing whitespace and multiple spaces from sentences:
      # https://www.cyberciti.biz/tips/delete-leading-spaces-from-front-of-each-word.html

      sed -i 's/^[ \t]*//; s/[ \t]*$//' tmp_file       ## two (chained) sed expressions

      # Replace multiple spaces with single space:

      sed -i 's/  */ /g' tmp_file

      # ============================================================================
      # REMAINING PAGE NUMBER ABBREVIATIONS:

      # The page number abbreviation "p." is more complicated than "pp.". We
      # needed to process "pp." (above) BEFORE "p.", otherwise substitution
      # of the "p." in "pp." will incorrectly get substituted with "Cho4Ph".

      sed -i -r 's/([[({\s])p\.\s?([ivx0-9])/\1Eiph2T\2/g' tmp_file
      # [ in character class [] must appear first: [[...]

      # ============================================================================
      # BIOCHEMICAL TEXT -- AMINO ACIDS:

      # Need to do these before processing periods, as (e.g.) the p. ("protein")
      # in p.Arg62His (an amino acid substitution / variant) will be processed
      # as an abbreviation, and/or split into a sentence at that period ...

      sed -i 's/p.Ala/HieN7uuP/g' tmp_file     ## Ala  Alanine	      (A)
      sed -i 's/p.Arg/Nae0RaeZ/g' tmp_file     ## Arg	Arginine	      (R)
      sed -i 's/p.Asn/see7AuK6/g' tmp_file     ## Asn	Asparagine      (N)
      sed -i 's/p.Asp/chaeJeu1/g' tmp_file     ## Asp	Aspartic Acid   (D)
      sed -i 's/p.Cys/EiV6Gaix/g' tmp_file     ## Cys	Cysteine	      (C)
      sed -i 's/p.Gln/Ufaiph2b/g' tmp_file     ## Gln	Glutamine	      (Q)
      sed -i 's/p.Glu/Goh8eish/g' tmp_file     ## Glu	Glutamic Acid	  (E)
      sed -i 's/p.Gly/xei1Phei/g' tmp_file     ## Gly	Glycine         (G)
      sed -i 's/p.His/aak0eVei/g' tmp_file     ## His	Histidine	      (H)
      sed -i 's/p.Ile/vai9aeS3/g' tmp_file     ## Ile	Isoleucine	    (I)
      sed -i 's/p.Leu/ohzah5Ei/g' tmp_file     ## Leu	Leucine	        (L)
      sed -i 's/p.Lys/Oa4Aequo/g' tmp_file     ## Lys	Lysine	        (K)
      sed -i 's/p.Met/TheeWie7/g' tmp_file     ## Met	Methionine	    (M)
      sed -i 's/p.Phe/ohNa9pe0/g' tmp_file     ## Phe	Phenylalanine	  (F)
      sed -i 's/p.Pro/Eetaib7k/g' tmp_file     ## Pro	Proline	        (P)
      sed -i 's/p.Trp/ga3yeeGh/g' tmp_file     ## Trp	Tryptophan	    (W)
      sed -i 's/p.Tyr/DuY2Gub7/g' tmp_file     ## Tyr	Tyrosine	      (Y)
      sed -i 's/p.Ser/oezoo9Ca/g' tmp_file     ## Ser	Serine	        (S)
      sed -i 's/p.Thr/wahRoo7E/g' tmp_file     ## Thr	Threonine	      (T)
      sed -i 's/p.Val/ieKai4oo/g' tmp_file     ## Val	Valine	        (V)

      # ============================================================================
      # PERIODS:

      # To better deal with the many complications associated with periods,
      # first delete all spaces preceding  and proceeding periods. This will
      # take care of, e.g.: U. S. A. | The end . | V. A. Stuart | 
      # J. Am. Soc. Chem. ...

      sed -i 's/\s*\././g' tmp_file
      sed -i 's/\.\s*/./g' tmp_file

      # ----------------------------------------
      # Ellipses (ellipsis: ...) -- convert 3 or more periods (.) to an ellipsis:

      sed -i 's/\.\{3,\}/.../g' tmp_file

      # .. then store those ellipses as a UID:
      
      sed -i 's/\.\.\./Iet1auki/g' tmp_file

      # ... and finally convert remaining tandem periods (..) to a single period:

      sed -i 's/\.\././g' tmp_file

      # ----------------------------------------
      # version (v.) abbreviation (v. + 0 or 1 character + any number):

      sed -i -r 's/v\.\s?([0-9])/Eegh5eel\1/g' tmp_file

      # ----------------------------------------
      # versus (vs.) abbreviation:

      sed -i 's/vs\./Air5ah/g' tmp_file

      # ----------------------------------------
      # "E.g.", "e.g.", "I.e." or "i.e.":

      sed -i 's/[eE]\.g\./Va1Eed/g' tmp_file
      sed -i 's/[iI]\.e\./Uchee4/g' tmp_file

      # ----------------------------------------
      # "cc.", "CC." or "cf.":

      sed -i 's/[cC]\.\?[cC]\./Ri9Ohk/g' tmp_file
      sed -i 's/\s[cC][cC]\s/ Ri9Ohk /g' tmp_file

      sed -i 's/c\.\?f\./Tig8shei/g' tmp_file
      sed -i 's/\scf\s/ Tig8shei /g' tmp_file

      # ----------------------------------------
      # "et al." abbreviation (will restore, with period, later):

      sed -i 's/et al\./et al/g' tmp_file

      # ----------------------------------------
      # "Fig.", "fig.", "Figs.", "figs.":

      # As I don't otherwise process commas, I can simply use them as a facile
      # substitution for periods (later swapping , for . in post-processing):

      sed -i -r 's/([fF]ig[s])\./\1,/g' tmp_file

      # ----------------------------------------
      # Personal titles (again, temporarily replace '.' with ','):
      
      sed -i 's/Dr\./Dr,/g' tmp_file
      sed -i 's/Drs\./Drs,/g' tmp_file
      sed -i 's/Mr\./Mr,/g' tmp_file
      sed -i 's/Mrs\./Mrs,/g' tmp_file
      sed -i 's/Ms\./Ms,/g' tmp_file
      sed -i 's/St\./St,/g' tmp_file

      # ============================================================================
      # OTHER BIOCHEMICAL TEXT:

      # ----------------------------------------
      # SINGLE QUOTATIONS:

      # Note that some single quotes (i.e. apostrophes), e.g., 5'-, 3'-, ...
      # are important biochemistry / chemistry.  To be safe, we'll proactively
      # capture / protect these:

      sed -i "s/3'/tho6Si2o/g" tmp_file         ## e.g.: 3'-end
      sed -i "s/5'/oochie8P/g" tmp_file         ## e.g.: 5'-ATGGCTCGATCTTA...

      sed -i "s/A's/ohph5AN6/g" tmp_file        ## e.g.: (multiple adenines) multiple A's precede
      sed -i "s/C's/Ji4oopow/g" tmp_file        ## e.g.: (multiple adenines) multiple C's precede
      sed -i "s/G's/Aeyahk4A/g" tmp_file        ## e.g.: (multiple adenines) multiple G's precede
      sed -i "s/T's/oogeel3W/g" tmp_file        ## e.g.: (multiple adenines) multiple T's precede

      # ----------------------------------------
      # BIOCHEMICAL, CHEMICAL PRIMES:

      sed -i "s/1'/hooPhil4/g" tmp_file
      sed -i "s/2'/He5EiS1Z/g" tmp_file
      sed -i "s/3'/IeghuP3V/g" tmp_file
      sed -i "s/4'/Loh4aeri/g" tmp_file
      sed -i "s/5'/Aht9Vohs/g" tmp_file
      sed -i "s/6'/ReiR5zee/g" tmp_file
      sed -i "s/7'/eiTei4ri/g" tmp_file
      sed -i "s/8'/ay0ePicu/g" tmp_file
      sed -i "s/9'/seeHush2/g" tmp_file

      # ============================================================================
      # REMAINING SINGLE, DOUBLE QUOTATIONS:

      # Delete all double quotations: not particularly needed in NLP, e.g. tokenized text:

      sed -i 's/"//g' tmp_file

      # ----------------------------------------------------------------------------
      # CONTRACTIONS:

      # Deal with common contractions, before dealing with single quotes / apostrophes.
      
      # ----------------------------------------
      # First, expand common contractions:

      sed -i "s/'d/ did/g" tmp_file
      sed -i "s/'m/ am/g" tmp_file
      sed -i "s/won't/will not/g" tmp_file                    ## do this rule before the following rule
      sed -i "s/n't/ not/g" tmp_file                          ## isn't | shouldn't | wouldn't | wouldn't | ...
      sed -i "s/'ll/ will/g" tmp_file
      sed -i "s/'re/ are/g" tmp_file
      sed -i "s/'ve/ have/g" tmp_file

      sed -i "s/here's/here is/g" tmp_file                    ## here's | Here's | there's | There's | where's | Where's ...
      sed -i "s/I'd/I would/g" tmp_file
      sed -i "s/It's/It is/g" tmp_file
      sed -i "s/\sit's/ it is/g" tmp_file
      sed -i "s/That's/That is/g" tmp_file
      sed -i "s/that's/that is/g" tmp_file
      sed -i "s/What's/What is/g" tmp_file
      sed -i "s/\swhat's/ what is/g" tmp_file
      
      # ----------------------------------------
      # Next, substitute remaining contractions with UID (restore in post-processing):

      sed -i -r "s/([a-zI])'d/\1chaSaib7/g" tmp_file        ## e.g.: I'd | how'd | who'd | why'd | ...
      sed -i -r "s/([a-zI])'ll/\1UivahJ5e/g" tmp_file       ## e.g.: I'll
      sed -i -r "s/([a-zI])'m/\1chahei1O/g" tmp_file        ## e.g.: I'm
      sed -i -r "s/([a-z])'t/\1Zeep7Auy/g" tmp_file 
      sed -i -r "s/([a-z])'nt/\1Zeep7Auy/g" tmp_file        ## e.g.: is'nt [grammatical (spelling) error]
      sed -i -r "s/([a-z])'re/\1Phoh5eil/g" tmp_file        ## e.g.: you're | We're responsible ...
      # ------------------
      sed -i "s/'six/eKu6eech/g" tmp_file                   ## e.g.: escape 'six
      sed -i "s/'seven/pahl8Avu/g" tmp_file                 ## e.g.: escape 'seven
      sed -i -r "s/([a-z])'s/\1zaoGii5p/g" tmp_file         ## e.g.: there's | various possessives: Victoria's | women's | ...
      sed -i -r "s/([a-z])'\s/\1ueKek3oh/g" tmp_file        ## e.g.: plural noun possessives ending in "s": girls' dresses | Wilsons' house | ...
      # ------------------
      sed -i -r "s/([a-z])'t/\1iCuRahb6/g" tmp_file         ## e.g.: isn't
      sed -i -r "s/([a-zI])'ve/\1Roopes5f/g" tmp_file       ## e.g.: I've' | (+)'ve
      # less common / archaic:
      sed -i "s/ma'am/Quei2Eex/g" tmp_file
      sed -i "s/ne'er/IeDae7Lu/g" tmp_file                  ## e.g.: ne'er-do-well
      sed -i -r "s/o'([a-z])/Xahc3Iel\1/g" tmp_file         ## e.g.: o'clock
      sed -i "s/'twas/uph4aida/g" tmp_file                  ## e.g. 'twas the night; escapes: 'two | 'twenty ...

      # Finally, delete all remaining single quotations, apostrophes:

      sed -i "s/'//g" tmp_file

      # ============================================================================
      # PREPROCESSING MISCELLANY:

      # ----------------------------------------
      # Delete tandem commas, semicolons:

      sed -i 's/,,/,/g' tmp_file
      sed -i 's/;;/;/g' tmp_file

      # ----------------------------------------
      # Clean up improperly-terminated sentences (e.g. ?!!?!?!??!):

      # ------------------
      # Tandem question, exclamation marks:

      for i in {1..8}
      do
        sed -i 's/??/?/g' tmp_file        ## not regex (-r), so those those are
        sed -i 's/!!/!/g' tmp_file        ## literal ? ! character substitutions
      done

      # ------------------
      # Remaining [.!?] permutations:

      sed -i 's/!?/?/g' tmp_file
      sed -i 's/?!/?/g' tmp_file
      sed -i 's/?\./?/g' tmp_file
      sed -i 's/!\./!/g' tmp_file
      sed -i 's/\.?/?/g' tmp_file
      sed -i 's/\.!/!/g' tmp_file

      # ============================================================================
      # BRACKETS:

      # These can be annoying, especially re: processing.  They are important in
      # chemistry / biochemistry, however (e.g. chemical / biochemical names), so
      # for now just do the usual substitute / replace later approach.

      # The order of these steps is important: do ( [ {, then ) ] } associated
      # with periods (to split at those), then do left-over ( ) [ ] { }.

      # ----------------------------------------
      # Simplify [{ as ( ; simplify ]} as ) :

      sed -i 's/\[/(/g' tmp_file              ## \-escape the [ : \[
      sed -i 's/]/)/g' tmp_file

      sed -i 's/{/(/g' tmp_file
      sed -i 's/}/)/g' tmp_file

      sed -i 's/</(/g' tmp_file
      sed -i 's/>/)/g' tmp_file

      # ----------------------------------------
      # Delete empty parentheses:

      sed -i 's/(\s\?)//g' tmp_file

      # ----------------------------------------
      # Delete spaces following leading parentheses; delete spaces preceding lagging parentheses:

      sed -i 's/(\s\?/(/g' tmp_file
      sed -i 's/\s\?)/)/g' tmp_file

      # ----------------------------------------
      # Split parentheses associated with punctuation (.?!) at the ends of sentences:

      sed -i 's/\.)\s\?/.)\n/g' tmp_file
      sed -i 's/\.\s\?(/.\n(/g' tmp_file

      sed -i 's/?)\s\?/?)\n/g' tmp_file
      sed -i 's/?\s\?(/?\n(/g' tmp_file

      sed -i 's/!)\s\?/!)\n/g' tmp_file
      sed -i 's/!\s\?(/!\n(/g' tmp_file

      # ----------------------------------------
      # Split lines on ) ( :

      sed -i 's/)\s\?(/)\n(/g' tmp_file

      # ----------------------------------------
      # Clean up: remove parentheses at start or end of lines:

      # First, (again) remove all leading and trailing whitespace from sentences, as well as multiple spaces:

      sed -i 's/^[ \t]*//; s/[ \t]*$//' tmp_file       ## two (chained) sed expressions

      sed -i 's/^(//g' tmp_file
      sed -i 's/)$//g' tmp_file

      # ============================================================================
      # AUTHOR INITIALS; JOURNAL TITLE ABBREVIATIONS:
      # =============================================

      sed -i -r 's/(\.[A-Z][a-z]{0,13})\./\1Shah7a/g' tmp_file
      # (Proc.NatlShah7aAcad.SciShah7aUShah7aS.AShah7a104, 9346

      sed -i -r 's/(Shah7a[A-Z][a-z]{0,13})\./\1Shah7a/g' tmp_file
      # (Proc.NatlShah7aAcadShah7aSciShah7aUShah7aSShah7aAShah7a104, 9346 

      # ----------------------------------------------------------------------------
      # Match abbreviations at the start of a line.

      sed -i -r 's/(^[A-Z][a-z]{0,13})\./\1Shah7a/g' tmp_file

      # ----------------------------------------------------------------------------
      # Capture the first abbreviation inside a parenthesis ( ( ):

      sed -i -r 's/(\([A-Z][a-z]{0,13})\./\1Shah7a/g' tmp_file      ## \-escaped, literal ( inside () character substitution

      # ----------------------------------------------------------------------------
      # Authors' names -- additional processing:
      
      # ------------------
      # Match hyphenated names abbreviations (e.g. Chen A.-B. Jiang):

      sed -i -r 's/\.-([A-Z])\./Shah7a-\1Shah7a/g' tmp_file

      # ------------------
      # Clean up { space Cap(range 1:4 Caps) dot Cap | space Cap dash Cap dot } patterns:
      # William F.JShah7aMcLeod | A.BCD.Smith | ABCD.Smith | Chen A-B.JiangShah7a | ...

      sed -i -r 's/\s([A-Z]{1,4})\.([A-Z])/ \1Shah7a\2/g' tmp_file
      sed -i -r 's/\s([A-Z]-[A-Z])\./ \1Shah7a/g' tmp_file


      # ============================================================================
      # SPLIT SENTENCES ONTO SEPARATE LINES:
      # ------------------------------------

      # Here we want to process the remaining periods to split sentences onto
      # separate lines, with the caveats (i) that we do not want to split decimal
      # numbers (3.1; ... i.e. [0-9].[0-9]), and (ii) we do not want to (as much
      # as practically possible) split abbreviations (journal titles; authors; ...).

      sed -i -r 's/([\.?!])\s?([A-Z][A-Za-z0-9 ,-]{4,})/\1\n\2/g' tmp_file        ## literal space, [ ] inside that [A-Za-z ,-] character class

      # ============================================================================
      # RESTORATIONS:
      # =============

      # ----------------------------------------
      # (Re-)delete leading and trailing whitespace from sentences, as well as
      # multiple spaces (if present / inadvertently reintroduced):

      sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp_file

      # Replace multiple spaces with single space:

      sed -i 's/  */ /g' tmp_file

      # ----------------------------------------------------------------------------
      # Restorations -- amino acids (e.g.: p.Arg in p.Arg62His):

      sed -i 's/HieN7uuP/p.Ala/g' tmp_file
      sed -i 's/Nae0RaeZ/p.Arg/g' tmp_file
      sed -i 's/see7AuK6/p.Asn/g' tmp_file
      sed -i 's/chaeJeu1/p.Asp/g' tmp_file
      sed -i 's/EiV6Gaix/p.Cys/g' tmp_file
      sed -i 's/Ufaiph2b/p.Gln/g' tmp_file
      sed -i 's/Goh8eish/p.Glu/g' tmp_file
      sed -i 's/xei1Phei/p.Gly/g' tmp_file
      sed -i 's/aak0eVei/p.His/g' tmp_file
      sed -i 's/vai9aeS3/p.Ile/g' tmp_file
      sed -i 's/ohzah5Ei/p.Leu/g' tmp_file
      sed -i 's/Oa4Aequo/p.Lys/g' tmp_file
      sed -i 's/TheeWie7/p.Met/g' tmp_file
      sed -i 's/ohNa9pe0/p.Phe/g' tmp_file
      sed -i 's/Eetaib7k/p.Pro/g' tmp_file
      sed -i 's/ga3yeeGh/p.Trp/g' tmp_file
      sed -i 's/DuY2Gub7/p.Tyr/g' tmp_file
      sed -i 's/oezoo9Ca/p.Ser/g' tmp_file
      sed -i 's/wahRoo7E/p.Thr/g' tmp_file
      sed -i 's/ieKai4oo/p.Val/g' tmp_file

      # ----------------------------------------
      # Restore page number abbreviations {pp. | p.}:

      sed -i 's/Cho4Ph/pp. /g' tmp_file
      sed -i 's/Eiph2T/ p./g' tmp_file

      # ----------------------------------------
      # Restore single quotations:

      sed -i "s/tho6Si2o/3'/" tmp_file
      sed -i "s/oochie8P/5'/g" tmp_file

      sed -i "s/ohph5AN6/A's/g" tmp_file
      sed -i "s/Ji4oopow/C's/g" tmp_file
      sed -i "s/Aeyahk4A/G's/g" tmp_file
      sed -i "s/oogeel3W/T's/g" tmp_file

      # ----------------------------------------
      # Restore common contractions:

      sed -i "s/chaSaib7/'d/g" tmp_file
      sed -i "s/UivahJ5e/'ll/g" tmp_file
      sed -i "s/chahei1O/'m/g" tmp_file
      sed -i "s/Zeep7Auy/'t/g" tmp_file
      sed -i "s/Zeep7Auy/'nt/g" tmp_file
      sed -i "s/Phoh5eil/'re/g" tmp_file
      # ------------------
      sed -i "s/eKu6eech/six/g" tmp_file
      sed -i "s/pahl8Avu/seven/g" tmp_file
      sed -i "s/zaoGii5p/'s/g" tmp_file
      sed -i "s/ueKek3oh/' /g" tmp_file
      # ------------------
      sed -i "s/iCuRahb6/'t/g" tmp_file
      sed -i "s/Roopes5f/'ve/g" tmp_file
      # less common / archaic:
      sed -i "s/Quei2Eex/ma'am/g" tmp_file
      sed -i "s/IeDae7Lu/ne'er/g" tmp_file
      sed -i "s/Xahc3Iel/o'/g" tmp_file
      sed -i "s/uph4aida/'twas/g" tmp_file

      # ----------------------------------------
      # Restore biochemical, chemical primes:

      sed -i "s/hooPhil4/1'/g" tmp_file
      sed -i "s/He5EiS1Z/2'/g" tmp_file
      sed -i "s/IeghuP3V/3'/g" tmp_file
      sed -i "s/Loh4aeri/4'/g" tmp_file
      sed -i "s/Aht9Vohs/5'/g" tmp_file
      sed -i "s/ReiR5zee/6'/g" tmp_file
      sed -i "s/eiTei4ri/7'/g" tmp_file
      sed -i "s/ay0ePicu/8'/g" tmp_file
      sed -i "s/seeHush2/9'/g" tmp_file
      # ----------------------------------------
      # Restore version (v.):

      sed -i -r 's/Eegh5eel/v./g' tmp_file

      # ----------------------------------------
      # Restore versus ("vs."):

      sed -i 's/Air5ah/vs./g' tmp_file

      # ----------------------------------------
      # Restore "e.g." and "i.e.":

      sed -i 's/Va1Eed/e.g./g' tmp_file
      sed -i 's/Uchee4/i.e./g' tmp_file

      # Capitalize restored "e.g.", "i.e.", "c.f." present at the start of a sentence:

      sed -i 's/^c\.f\./Cf./g' tmp_file
      sed -i 's/^e\.g\./E.g./g' tmp_file
      sed -i 's/^i\.e\./I.e./g' tmp_file

      # ----------------------------------------
      # Restore "c.c." and "cf.":

      sed -i 's/Ri9Ohk/cc./g' tmp_file
      sed -i 's/Tig8shei/cf./g' tmp_file

      # ----------------------------------------
      # Restore ellipses (...):

      sed -i 's/Iet1auki/ .../g' tmp_file     ## add space before ...

      # ----------------------------------------
      # Restore et al. :

      sed -i 's/et al/et al./g' tmp_file

      # ----------------------------------------
      # Restore "Fig.", "fig.", "Figs.", "figs.":

      sed -i -r 's/([fF]ig[s]),/\1\./g' tmp_file

      # ----------------------------------------
      # Restore personal titles (replace ',' with '.'):

      sed -i 's/St,/St./g' tmp_file
      sed -i 's/Ms,/Ms./g' tmp_file
      sed -i 's/Mrs,/Mrs./g' tmp_file
      sed -i 's/Mr,/Mr./g' tmp_file
      sed -i 's/Drs,/Drs./g' tmp_file

      # ----------------------------------------------------------------------------
      # Miscellany: split St. at end of sentence:

      sed -i -r 's/\sSt.([A-Z])/ St.\n\1/g' tmp_file

      # ----------------------------------------------------------------------------
      # Lastly , restore author initials, journal title abbreviations:

      sed -i 's/Shah7a/./g' tmp_file


      # ============================================================================
      # POSTPROCESSING:
      # ===============

      # ----------------------------------------------------------------------------
      # Delete { ---------- | ========== }-type lines:
      # [I often use these to delimiter sections of text.]

      sed -i '/^[-=]*$/d' tmp_file
      # Deletes all of these:
      #  ---------------------
      #  =====================
      #  --------=====--------
      #  =====----------=====

      # ----------------------------------------
      # Delete any remaining empty / blank lines (if they exist):

      sed -i '/^\s*$/d' tmp_file      ## * : 0 or more instances (here, of spaces: \s)

      # ----------------------------------------
      # "Unsplit" sentences:
      
      # As a consequence of processing abbreviations, some existing abbreviations
      # get captured; e.g. [original text] "... in PD.Overall ...". That PD
      # (Parkinson's Disease) abbreviation gets preprocessed by his script as ah
      # abbreviation [PDShah7a], and so it is not present during the sentence 
      # splitting step; the period (hence unsplit sentence) is added when "Shah7a"
      # is replaced with a period.

      sed -i -r 's/\s([A-Z]{2,4})\.([A-Z])/ \1.\n\2/g' tmp_file

      # ============================================================================
      # FINAL SED OPERATION:
      # ====================

      # ----------------------------------------------------------------------------
      # Final sed operation; output to file:

      sed -i 's/Dr,/Dr./g' tmp_file

      # ----------------------------------------------------------------------------
      # Create output files, into PREEXISTING ./output directory:

      # http://pubs.opengroup.org/onlinepubs/007908799/xcu/basename.html
      # https://stackoverflow.com/questions/15803227/getting-permission-denied-on-dirname-and-basename

      # https://stackoverflow.com/questions/7194192/basename-with-spaces-in-a-bash-script
      outname=$(basename "$f")

      mv "tmp_file" "output/$outname"

      # https://stackoverflow.com/questions/4638874/how-to-loop-through-a-directory-recursively-to-delete-files-with-certain-extensi
      # At top of script: IFS=$'\n'; set -f
      # Unset here:
      unset IFS; set +f

      # ============================================================================
      # Q.E.D.!  :-D
      # ============================================================================

  done

