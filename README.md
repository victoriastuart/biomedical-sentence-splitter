```sed```-based biomedical sentence chunking (splitting)

* My experiments in processing biomedical text with sed and regex expressions.
* Useful for biomedical natural language processing (BioNLP) pre-processing, etc.
* Not by any means perfect, but very good sentence chunking, other capabilities.
  * tests: my script > OpenNLP (v. good) ~ GeniaSS ...
* Mostly for my own use, but shared in case it's of interest/use to others.
* See my comments in the bash script for additional detail/information.

**USAGE -- sed_sentence_chunker.sh:**
```
      ./sed_sentence_chunker.sh  <input_file>  <output_file>
   bash sed_sentence_chunker.sh  <input_file>  <output_file>
```

----------

**Update (Sep 26, 2017) -- sed_sentence_chunker2.sh:**

```
A Reader asks via e-mail:

Date: 2017 Sep 26 (Tue) 22:24
From: "raja..."
To: info@Persagen.com
Subject: sentence chunker

Hi Victoria,

I am trying to use your sentence chunking program
(http://persagen.com/about/victoria/projects/sed_sentence_chunker.html).
It looks pretty good.

How can I pass a string (text fragment) to the program as an input
variable rather than passing a file name?

I also want to get back the chunked output as a string variable
for further processing. Any suggestions?

Thank you
...
```

My reply:


## EXECUTIVE SUMMARY

The updated script (attached), intended for command-line use as you requested, is

    sed_sentence_chunker2.sh

Usage is per the examples below.  Basically, call the script as follows (explanations in the output below, and in the Notes at the end of this message):

    . sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

Note the space after the period; it is not the not the usual `./script` command:

    ./sed_sentence_chunker2.sh

Alternatively, you can execute this as follows (same thing):

    source sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

As explained below, executing the script that way (note: `sed_sentence_chunker.sh`, *not* `sed_sentence_chunker2.sh` -- which honestly is much easier to use -- allows that script to write the output to a shell variable and export it to the terminal.

Otherwise, you can also do this directly in the shell (terminal) the "normal" way, and manually assign the output to a shell variable, as follows:

    ./sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    OUTPUT=$(echo output)

    cat $OUTPUT

## SAMPLE OUTPUT / TESTS

```
$ dp        ## d: date; p: pwd  [my ~/.bashrc aliases]

    Tue Sep 26 16:24:50 PDT 2017
    /mnt/Vancouver/Programming/scripts

$ ./sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'
```

The following (**note:** different use of quotations but otherwise identical) will fail to execute, as you cannot use the escape ( `\` ) character within single-quoted strings, *except* by prefixing the string with `$`, per the accepted answer at [StackOverflow](https://stackoverflow.com/questions/8254120/how-to-escape-a-single-quote-in-single-quote-string-in-bash)

```
./sed_sentence_chunker2.sh <<< ' Sentence 1. Sentence 2. Victoria\'s here! "Internal quotation 1." \'Internal quotation 2.\' '

    sed: can't read here!: No such file or directory

# Above, I needed to enter another single quote to terminate / kill
# that failed command.
```

However, this will execute (notice the addition of the `$` prefix to the input, **single-quoted** string):

```
./sed_sentence_chunker2.sh <<< $' Sentence 1. Sentence 2. Victoria\'s here! "Internal quotation 1." \'Internal quotation 2.\' '

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'
```

Again:

```
./sed_sentence_chunker2.sh <<< $' Sentence 1. Sentence 2. Victoria\'s here! '

    Sentence 1.

    Sentence 2.

    Victoria's here!
```

## ASSIGNING THE OUTPUT TO A SHELL VARIABLE

As mentioned above and explained more fully on [StackOverflow](https://stackoverflow.com/questions/496702/can-a-shell-script-set-environment-variables-of-the-calling-shell), basically, you have to "source" the file under the running shell

    source script.sh

or

    . script.sh     ## note the space: not the normal "./script.sh"
                    ## command (that loads the process in another shell!)


## EXAMPLES

```
source sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat output

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat $OUTPUT

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

grep ternal $OUTPUT

    "Internal quotation 1."
    'Internal quotation 2.'

rm $OUTPUT

    rm: remove regular file 'output'? y

# ----------------------------------------------------------------------------
# The "alternative" source execution:

. sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat output

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat $OUTPUT

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'
```

## REDIRECTING THE OUTPUT TO A FILE

... then printing the contents of that file to a shell variable.  The commonly-employed source execution (loads the process in another shell; thus the $OUTPUT variable specific in the script is not available to the parent, running shell):

```
./sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat output 

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

cat $OUTPUT

    ^C      ## hangs (as there is no $OUTPUT variable); need to kill that command
    
# E.g.:

cat applebanana

     cat: applebanana: No such file or directory

cat $applebanana    ## hangs!!

    ^C      ## manually kiled that process
    
ls -l out*

    -rw-r--r-- 1 victoria victoria 93 Sep 26 20:31 output

OUTPUT=$(printf output)     ## can also do: OUTPUT=$echo output)

cat $OUTPUT

    Sentence 1.

    Sentence 2.

    Victoria's here!

    "Internal quotation 1."

    'Internal quotation 2.'

ls -l out*

    -rw-r--r-- 1 victoria victoria 93 Sep 26 20:31 output

rm $OUTPUT

    rm: remove regular file 'output'? y

ls -l out*

    ls: cannot access 'out*': No such file or directory
```

## NOTES:

1. The `<<<` redirect feeds the string to the bash script; for more on that see this [StackOverflow](https://stackoverflow.com/questions/6541109/send-string-to-stdin) thread.

2. I wanted to see what would happen with mixed quotes {single: ' | double: "} in the input text string.  This is trivial in the original `sed_sentence_chunker.sh` script (where inout and output is passed from / to files).  It is *much* more difficult on the command-line.  The accepted answer in this [StackOverflow](https://stackoverflow.com/questions/8254120/how-to-escape-a-single-quote-in-single-quote-string-in-bash) explains how and why to escape a backslash in a single-quoted string!  Fabulous!! :-D

3. Assigning the output to a shell variable was also surprisingly difficult -- but doable, as explained (e.g.) in this [StackOverflow](https://stackoverflow.com/questions/496702/can-a-shell-script-set-environment-variables-of-the-calling-shell) thread, and illustrated in the output, above.  I modified the script (`sed_sentence_chunker.sh` >> `sed_sentence_chunker2.sh`) to output a variable; in that case you MUST "source" execute the script:

    . sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

Again, note the space after the period: it's not the normal `./sed_sentence_chunker2.sh ...` command; alternatively, you can execute (same thing) as

    source sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

Otherwise, you can also do this directly in the shell (terminal), the "normal" `./command` way, and manually assign the output to a shell variable:

    ./sed_sentence_chunker2.sh <<< " Sentence 1. Sentence 2. Victoria's here! \"Internal quotation 1.\" 'Internal quotation 2.' "

    OUTPUT=$(echo output)

    cat $OUTPUT

----------

Anyway, I hope the modified script does what you want, and that it is helpful to you!

Best,
Victoria  :-)
