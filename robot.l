%{
#include "robot.tab.h"
#include <string.h>
%}
 
%option noyywrap
 
%%
if		    {return IF;}
nclear 		    {return NCLEAR;}
paint|nothing { yylval.dir = strdup(yytext); return ACTION; }
do 		    {return DO;}
move                { return MOVE; }
while		    {return WHILE;}
"{"                 { return LBRA; }
"}"                 { return RBRA; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
","                 { return COMMA; }
"right"|"left"|"up"|"down" { yylval.dir = strdup(yytext); return DIREC-TION; }
"r"|"l"|"u"|"d" { yylval.dir = strdup(yytext); return D; }
[0-9]+              { yylval.num = atoi(yytext); return NUMBER; }
[\n\t ]+            ; // Ignore whitespace
.                   { return yytext[0]; } 
 
%%
