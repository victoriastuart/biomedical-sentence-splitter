## Biomedical Sentence Splitter

* [**Biomedical Sentence Splitter**](https://github.com/victoriastuart/biomedical-sentence-splitter) [GitHub] process files in input dir; suitable for Python scripts
* [chunk_test_input.txt](https://github.com/victoriastuart/sed_sentence_chunker/blob/master/chunk_test_input.txt) : input test file

<hr size="1" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

Accurate sentence chunking is crucial for minimizing cascading (downstream) NLP errors, e.g.: dependency parsing; semantic parsing; ...

This script, `sed_sentence_chunker.sh`, processes text files in the `input/` directory, and outputs to a (*pre-existing*) `output/` directory.

**ATTRIBUTES:**

* Linux sed (Linux stream editor) + regex expressions
* biomedical natural language processing (BioNLP) pre-processing
  * includes code to replace various annoyances (common ligatures; various quotation marks and accents; etc.) prior to the sentence chunking steps
* superior sentence chunking (splitting)
  * my script > `OpenNLP` (v. good) ~ `GeniaSS` ...
* usage: Linux command-line or bash scripts
  * the code may be easily modified (see comments in code; examples below) for command-line use
* the bash script may also be called from within Python scripts (see example, below)
* rename the script (e.g.: ssc), if for convenience you want to use a shortened script name:
* refer to my code (fully-commented) for additional detail / information / logic

Here is an example of how to call `sed_sentence_chunker.sh` from within a Python 3 script:

```
import subprocess
ssc = '/mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_sentence_chunker.sh'
subprocess.call(ssc, shell=True)
```

<hr size="3" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

**USAGE:**

*Processes text files in the `input/` directory, and outputs to the `output/` directory.*
```
   ./sed_sentence_chunker.sh
bash sed_sentence_chunker.sh
```

<hr size="3" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

I include two variations of this script, embedded / commented in the `sed_sentence_chunker.sh` code.
[Refer to those comments for simple instructions on how to modify that script, accordingly.]

<hr size="1" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

**Script variant 1:** specify input, output files on the command line

Usage:
```
   ./sed_sentence_chunker.sh  <input_file>  <output_file>
bash sed_sentence_chunker.sh  <input_file>  <output_file>
```

Example:
```
./sed_sentence_chunker.sh  chunk_test_input.txt  chunk_test_output.txt
```

<hr size="1" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

**Script variant 2:** directly pass input text on the command line

Usage:
```
# note: "dot space" command (space after the period):
. sed_sentence_chunker.sh  <<<  "quoted input text / sentences"

# alternative (script sourcing):
source sed_sentence_chunker.sh  <<<  "quoted input text / sentences"
```

Example 1:
```
. sed_sentence_chunker.sh <<< "This is sentence 1. This is sentence 2."
This is sentence 1.
This is sentence 2.

cat $OUTPUT
This is sentence 1.
This is sentence 2.
```

Example 2:
```
S="This is sentence 3. This is sentence 4."
. sed_sentence_chunker.sh <<< $S
This is sentence 1.
This is sentence 2.

cat $OUTPUT
This is sentence 1.
This is sentence 2.
```

<hr size="3" color="lightblue" width="750" align="left" style="margin-bottom:16px;">

<pre><font size="2"># ============================================================================
# TECHNICAL NOTES:      ## excerpted from sed_sentence_chunker.sh
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
</font></pre>
