# CS 155 Lab Exercise 1

### Modified EASY-C Language Lexer

**Student Name:** Yenzy Urson S. Hebron\
**Student Number:** 202003090

## Compilation

`le1-202003090.flex` is the uncompiled flex file. To compile it, you may use the following commands:

```sh
flex le1-202003090.flex
gcc lex.yy.c -lfl -o le1-202003090.out
```

Alternatively, you may simply run `./compile.sh`. This runs `compile.sh` which contains the commands provided above.

Either approach will produce the executable `le1-202003090.out`. This is the lexer's binary implementation, and it may be ran as follows:

```sh
# Run without an input file, takes input from STDIN
./le1-202003090.out

# Run with an input file, tokenizing until <<EOF>> or until a lexical error is caught
./le1-202003090.out <input_file>
```

## Description

### Tokenization

This lexer recognizes the following token categories:

* `RESERVED`: Special keywords in the modified EASY-C language. These tokens can declare functions (e.g. "PROCEDURE"), declare data types (e.g. "VAR"), denote control statements (e.g. "IF") and more. Note that arithmetic, relational, and logical operators are in their own token category.
* `NUMBER`: Any sequence of digits with no leading zeros for INTs and with at most one "." for REALs. Both integers and floats (reals) are tokenized as NUMBERs. The following has been clarified as all valid number formats: `0`, `000`, `123`, `123.`, `.123`, `123.123`.
* `RELOP`: The relational operators `=`, `<>`, `<`, `<=`, `>`, and `>=` respectively.
* `LOGOP`: The logical operators `AND`, `OR`, and `NOT`.
* `PLUS`, `MINUS`, `TIMES`, `DIVIDE`, and `MODULO`: These tokens are the arithmetic operators that has been separated into different token categories to help simplify parsing rules. The corresponding lexemes are `+`, `-`, `*`, `{/|DIV}`, and `MOD` respectively. Do note that `{/|DIV}` are both tokenized as `DIVIDE`.
* `IDENT`: Short for Identifiers, or any sequence of letters and numbers that begins with a letter that can serve different purposes in the code (e.g. as variables or as function names). Note that this has lower precedence than `RESERVED` so that strings like "PROCEDURE" become `RESERVED` instead of `IDENT`. Do note that "PROCedure" is an `IDENT`.
* `STRING`: Any sequence of characters except double quotes `"`. This also accepts special, non-graphic, and/or control characters into the string literal.
* `ASSIGN`: The assignment operator `:=`.
* `COMMA`, `SEMICOLON`, `LPAREN`, `RPAREN`, `QUOTATION`: The valid punctuations that usually serve delimiter or separator purposes in the code. These are `,`, `;`, `:`, `(`, `)`, and `"` respectively. Regarding the unpaired double quotes `"`, note that despite not being legally present in its free-form in this modified EASY-C code, it is still tokenized here as a `QUOTATION`. Any issue related to this convention is expected to be handled by the parser. This has been clarified with the instructor.

On a successful match, this lexer outputs `L<line_number>: <<token_type>,<token_value>>`. This lexer strives to balance its logical complexity with the consequent complexity that it passes on to the parser. Therefore, much thought has been put into the granularity of the categories. For instance, because of their relative frequency, each valid punctuation has been given their own token category.

Another note: Because the `STRING` token accepts special characters into the string literal, which includes the newline character `\n`, the user code section for `ret_print` has been modified to also increment `lineno` on each detected `\n` in the `yytext`. We treat this as the correct and intuitive behavior by showing which line a string starts without interfering with showing the correct line numbers for the following tokens. For example, given an input file as follows:

```sh
"This is a sample input string spanning
three lines, followed immediately by a reserved word.
You may take note of the line numbers."
PROCEDURE
```

This will be tokenized as (inclusive of the printed newline characters):

```sh
L1: <STRING,"This is a sample input string spanning
three lines, followed immediately by a reserved word.
You may take note of the line numbers.">
L4: <RESERVED,PROCEDURE>
```

### Error Handling

When the lexer encounters an error, it prints `L<line_number>: lexical error <string or character>` and halts the tokenization. A more involved error handling may be done in the future, e.g. deleting the violating character to possibly correct the error, or being able to detect more than one error.

The lexer treats all illegal characters and unrecognized patterns as lexical errors. Moreover, malformed identifiers and numbers are also considered errors, for which the the error text are especially descriptive. For instance, given the malformed identifier `abc123.0333`, the error string is not just `abc123.`, it is `abc123.0333`. The following are *non-exhaustive examples* of lexical-error-causing strings:

| Error-causing string | Description |
| -------------------- | ----------- |
| `123.123.123` | malformed number: more than one "." for a float |
| `123ABC` | malformed ident: identifier starts with a digit |
| `1.....2` | malformed number: more than one "." for a float |
| `000333` | malformed number: has leading zeros, note that the number `000` is still valid, but see Remarks for more discussion |
| `1$$$$$2` | malformed number: number contains an invalid character |
| `1$$2$$3` | malformed number: number contains an invalid character |
| `ABC._BC` | malformed ident: ident contains an invalid character |

The above lexical errors have been brought to light following consultation with the instructors and after reviewing the Grammar in the MP1 Specifications, with some liberties taken. You may find the handlers for these lexical errors near the bottom of the flex file's rules.

## Remarks and Caveats

* On STRINGs, this lexer follows the grammar rule that any and all characters within a pair of double quotes `"string"` are accepted into the string literal, with the important exception of the double quotes themselves.
* Identifiers only consists of LETTERS and NUMBERS, and can only begin with LETTERS.
* I have considered separating the binary logical operators `AND` and `OR` from the unary logical operator `NOT` but eventually settled for the distinction to be handled by the parsing logic.
* I have considered tokenizing signed numbers here (I initially distinguished between `+` and `-` as symbols for signs or arithmetic operators, actually mainly just the `-`), but ultimately decided to leave this to the parser, especially after consulting the Bison files from previouos self-checks.
* Note that "space as delimiters" are being applied selectively but intuitively here. For instance, "1 + 1" and "1+1" are both accepted and tokenized the same way, but we reject "123ABC" even if "123 ABC" is accepted as separate tokens.
* I'm still thinking of allowing leading 0s in integers. For this LabEx, I decided to disallow it by basing the behavior on Python which rejects leading 0s on decimal integer literals, but C actually allows them.

## Reference

Flex Patterns:
https://www.cs.virginia.edu/~cr4bd/flex-manual/Patterns.html#Patterns

---
Department of Computer Science\
University of the Philippines Diliman

2nd Semester A.Y. 2023-2024

© Course Materials by Dr. Festin and Prof. Martinez