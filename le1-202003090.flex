/* le1-202003090.flex             */
/* Modified EASY-C Language Lexer */
/* 4-Mar-2024 YSHebron            */

%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
int lineno = 1;
void ret_print(char *token_type);
void yyerror();
%}

KEYWORD   PROCEDURE|VAR|INTEGER|REAL|BOOLEAN|STRING|WRITELN|IF|THEN|ELSE|WHILE|DO|FOR|TO|DOWNTO|BEGIN|END
RELOP     "="|"<>"|"<"|"<="|">"|">="
LOGOP     AND|OR|NOT
IDENT	    [a-zA-Z][a-zA-Z0-9]*
INT       (0+|[1-9][0-9]*)
REAL      {INT}"."[0-9]+|{INT}"."|"."[0-9]+
NUMBER    {INT}|{REAL}
WORD	    [^\"]+
STRING    \"({WORD}|" ")*\"

%%
{KEYWORD}	      { ret_print("KEYWORD");    }
{NUMBER}{IDENT}   { yyerror("lexical error");}
{REAL}"."         { yyerror("lexical error");}
0+{INT}           { yyerror("lexical error");}
{NUMBER}          { ret_print("NUMBER");     }
{RELOP}           { ret_print("RELOP");      }
{LOGOP}           { ret_print("LOGOP");      }
"+"               { ret_print("PLUS");       }
"-"               { ret_print("MINUS");      }
"*"               { ret_print("TIMES");      }
"/"|DIV           { ret_print("DIVIDE");     }
MOD               { ret_print("MODULO");     }
{IDENT}	         { ret_print("IDENT");      }
{STRING}          { ret_print("STRING");     }
":="              { ret_print("ASSIGN");     }
","               { ret_print("COMMA");      }
";"               { ret_print("SEMICOLON");  }
":"               { ret_print("COLON");      }
"("               { ret_print("LPAREN"); }
")"               { ret_print("RPAREN");}
"\""              { ret_print("QUOTATION");  }
"\n"              { lineno++;}
[ \t\r\f]+	      /* eat up whitespace */
.	               { yyerror("lexical error");}
%%

/* L<line_number>: [<token_type>,<token_value>] */
/* yytext = token_value */
void ret_print(char *token_type){
   printf("L%d: [%s,%s]\n", lineno, token_type, yytext);
}

/* L<line_number>: lexical error <string or character>*/
void yyerror(char *message){
   printf("L%d: %s %s\n", lineno, message, yytext);
   exit(1);
}

int main(int argc, char *argv[]){
   yyin = fopen(argv[1], "r");
   yylex();
   fclose(yyin);
   return 0;
}
