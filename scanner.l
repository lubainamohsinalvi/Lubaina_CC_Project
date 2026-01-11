%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

int line_num = 1;
%}

%option noyywrap

DELIM       [ \t]
WS          {DELIM}+
NEWLINE     \n
COMMENT     "//".*

IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
INTEGER     [0-9]+
FLOAT       [0-9]+\.[0-9]+
EXPONENTIAL [0-9]+(\.[0-9]+)?[eE][+-]?[0-9]+
STRING      \"([^"\\]|\\.)*\"
CHAR        \'([^'\\]|\\.)\'

%%

{COMMENT}     { /* ignore */ }
{WS}          { /* ignore */ }
{NEWLINE}     { line_num++; }

"Ziddi"       { return ZIDDI; }
"Agar"        { return AGAR; }
"yahto"       { return YAHTO; }
"JadoTak"     { return JADOTAK; }
"Karo"        { return KARO; }
"khloja"      { return KHLOJA; }
"Chapo"       { return CHAPO; }
"Dekhao"      { return DEKHAO; }
"Suno"        { return SUNO; }
"Lekho"       { return LEKHO; }
"Samjho"      { return SAMJHO; }
"Bhago"       { return BHAGO; }
"Socho"       { return SOCHO; }
"Kudo"        { return KUDO; }
"Gao"         { return GAO; }

"++"          { return INC; }
"--"          { return DEC; }
"=>"          { return GEQ_ARROW; }
"<="          { return LEQ; }

"::"          { return DBLCOLON; }
"->"          { return ARROW; }
"@"           { return AT; }

{EXPONENTIAL} { yylval.str = strdup(yytext); return EXP_LIT; }
{FLOAT}       { yylval.str = strdup(yytext); return FLOAT_LIT; }
{INTEGER}     { yylval.str = strdup(yytext); return INT_LIT; }
{STRING}      { yylval.str = strdup(yytext); return STRING_LIT; }
{CHAR}        { yylval.str = strdup(yytext); return CHAR_LIT; }

{IDENTIFIER}  { yylval.str = strdup(yytext); return ID; }

.             { return (int)yytext[0]; }

%%
