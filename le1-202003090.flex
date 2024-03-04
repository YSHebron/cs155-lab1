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

KEYWORD   "PROCEDURE"|"VAR"|"INTEGER"|"REAL"|"BOOLEAN"|"STRING"|"WRITELN"|"NOT"|"IF"|"THEN"|"ELSE"|"WHILE"|"DO"|"FOR"|"TO"|"DOWNTO"|"BEGIN"|"END"
RELOP     "="|"<>"|"<"|"<="|">"|">="
ADDOP     "+"|"-"|"OR"
MULOP     "*"|"/"|"DIV"|"MOD"|"AND"
IDENT	        [a-zA-Z][a-zA-Z0-9]*
INT           (0+|[1-9][0-9]*)
REAL          {INT}"."[0-9]+|{INT}"."|"."[0-9]+
NUMBER        {INT}|{REAL}
WORD	        [[:alnum:][:punct:]]+
STRING        \"({WORD}|" ")*\"

%%
{KEYWORD}	    { ret_print("KEYWORD"); }
{NUMBER}        { ret_print("NUMBER"); }
{RELOP}         { ret_print("RELOP");  }
{ADDOP} 	       { ret_print("ADDOP");  }
{MULOP} 	       { ret_print("MULOP");  }
{IDENT}	       { ret_print("IDENT");  }
{STRING}        { ret_print("STRING"); }
[+-]{NUMBER}    { yyless(1); ret_print("SIGN"); }
":="          { ret_print("ASSIGN");       }
","           { ret_print("COMMA");        }
";"           { ret_print("SEMICOLON");    }
":"           { ret_print("COLON");        }
"("           { ret_print("OPEN_PAREN");   }
")"           { ret_print("CLOSE_PAREN");  }
"\""          { ret_print("QUOTATION");    }
"\n"          { lineno++;}
[ \t\r\f]+	  /* eat up whitespace */
.	           { yyerror("lexical error");}
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
