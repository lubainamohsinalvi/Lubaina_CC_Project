%{
#include <stdio.h>
#include <stdlib.h>
int line_num = 1;
%}

%option noyywrap

DELIM       [ \t]
WS          {DELIM}+
NEWLINE     \n
COMMENT     "//".*

KEYWORD     (Ziddi|Agar|yahto|JadoTak|Karo|khloja|Chapo|Dekhao|Suno|Lekho|Samjho|Bhago|Socho|Kudo|Gao)
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
INTEGER     [0-9]+
FLOAT       [0-9]+\.[0-9]+
EXPONENTIAL [0-9]+(\.[0-9]+)?[eE][+-]?[0-9]+
OPERATOR    (\+\+|--|=>|<=)
PUNCTUATION (::|->|@)
STRING      \"([^"\\]|\\.)*\"
CHAR        \'([^'\\]|\\.)\'

%%

{COMMENT}   { /* Ignore comments */ }
{WS}        { /* Ignore whitespace */ }
{NEWLINE}   { line_num++; }

{KEYWORD}       { printf("Line %d: KEYWORD → %s\n", line_num, yytext); }
{OPERATOR}      { printf("Line %d: OPERATOR → %s\n", line_num, yytext); }
{PUNCTUATION}   { printf("Line %d: PUNCTUATION → %s\n", line_num, yytext); }
{IDENTIFIER}    { printf("Line %d: IDENTIFIER → %s\n", line_num, yytext); }
{INTEGER}       { printf("Line %d: INTEGER → %s\n", line_num, yytext); }
{FLOAT}         { printf("Line %d: FLOAT → %s\n", line_num, yytext); }
{EXPONENTIAL}   { printf("Line %d: EXPONENTIAL → %s\n", line_num, yytext); }
{STRING}        { printf("Line %d: STRING → %s\n", line_num, yytext); }
{CHAR}          { printf("Line %d: CHARACTER → %s\n", line_num, yytext); }

.           { printf("Line %d: ERROR → %s\n", line_num, yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
        yyin = file;
    }
    
    yylex();
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}