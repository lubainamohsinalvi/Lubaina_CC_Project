%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_num;
extern char* yytext;
extern FILE *yyin;

int yylex(void);
void yyerror(const char *s);
%}

/* bison verbose errors (optional) */
%define parse.error verbose

%union { char* str; }

/* Keywords */
%token ZIDDI AGAR YAHTO JADOTAK KARO KHLOJA CHAPO DEKHAO SUNO LEKHO SAMJHO BHAGO SOCHO KUDO GAO

/* Operators & punctuation */
%token INC DEC GEQ_ARROW LEQ
%token DBLCOLON ARROW AT

/* Values */
%token <str> ID INT_LIT FLOAT_LIT EXP_LIT STRING_LIT CHAR_LIT

%start program

%%

program
  : ZIDDI block GAO
    { printf("Syntax analysis successful\n"); }
  ;

block
  : KARO stmt_list BHAGO
  ;

stmt_list
  : stmt_list stmt
  | /* empty */
  ;

stmt
  : decl_stmt
  | assign_stmt
  | if_stmt
  | loop_stmt
  | output_stmt
  | input_stmt
  | incdec_stmt
  ;

decl_stmt
  : LEKHO id_list DBLCOLON
  ;

id_list
  : ID
  | id_list ',' ID
  ;

assign_stmt
  : ID ARROW expr DBLCOLON
  ;

if_stmt
  : AGAR '(' cond ')' KHLOJA block
  | AGAR '(' cond ')' KHLOJA block YAHTO block
  ;

loop_stmt
  : JADOTAK '(' cond ')' block
  ;

output_stmt
  : CHAPO AT expr DBLCOLON
  | DEKHAO AT expr DBLCOLON
  ;

input_stmt
  : SUNO AT ID DBLCOLON
  ;

incdec_stmt
  : ID INC DBLCOLON
  | ID DEC DBLCOLON
  ;

expr
  : expr '+' term
  | expr '-' term
  | term
  ;

term
  : term '*' factor
  | term '/' factor
  | factor
  ;

factor
  : INT_LIT
  | FLOAT_LIT
  | EXP_LIT
  | STRING_LIT
  | CHAR_LIT
  | ID
  | '(' expr ')'
  ;

cond
  : expr relop expr
  ;

relop
  : LEQ
  | GEQ_ARROW
  | '<'
  | '>'
  | '=' '='
  ;

%%

void yyerror(const char *s) {
  fprintf(stderr, "Line %d: Syntax Error -> %s\n", line_num, s);
  fprintf(stderr, "Found near: '%s'\n", (yytext ? yytext : "EOF"));
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("Error opening file"); return 1; }
  }

  yyparse();

  if (argc > 1 && yyin) fclose(yyin);
  return 0;
}
