#!/bin/bash

# /mnt/Vancouver/Programming/scripts/sed_sentence_chunker/sed_characters2.sh

# Replace ligatures, poorly-converted 'nonsensensical' characters, other BioNLP hindrances

# CHARACTER SET TO TEST MY "SED CHARACTER REPLACEMENT" CODE (REPLACES SOME LIGATURES, VARIOUS QUOTATION MARKS, OTHER ANNOYANCES ...):

# ﬃ | ﬁ | ﬀ | ﬂ | ﬄ | � | ␮ | ௡ | ␣ | ␤ | ␦ | 5Ј- | -3Ј | þ | ¼ | ϭ | Ɛ | Ͻ | Ͼ | ␥ | ␧ | ␨ | Ϫ | À | OLD: | ‫؍‬ . | ␹ | Ն | Ն | Յ | Ã | Â | ¥ |  | ™ | ® | → | – | Ϯ | ؉ | ϫ | ϳ | ʽ | ʻ | “ | ˮ | ” | ״ | ʺ | ′′ | 〃 | ’ | ʼ | ‘ | ′ | ` | ׳ | ʹ | ꞌ | ˊ | ˋ | ˌ | — | ؊ | ϩ | ϫ

# http://www.fileformat.info/info/charset/UTF-8/list.htm

# https://stackoverflow.com/questions/24509214/how-to-escape-single-quote-in-sed
#   Escape ' within single-quoted sed '...' expressions by substituting those ' with \x27; e.g.:
#   s/’/'/g  -->  s/’/\x27/g


#FILES=~/pdfs/*.txt
# FILES=*.txt
# FILES=a.txt

FILES=input/**

echo "... PROCESSING: sed character preprocessing (various annoyances) ..."

for f in $FILES
do
  cp $f g     ## work on a copy so that the input file $f is not modified
  # sed -e 's/ﬃ/ffi/g
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
            #s/ϫ/x/g' $f
            s/ϫ/x/g' g
  # cat $f
  # cat g
done


