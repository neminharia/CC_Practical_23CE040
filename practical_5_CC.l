%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int line_no = 1;

char symbol_table[100][50];
int sym_count = 0;

void add_to_symbol_table(char *id) {
    for(int i = 0; i < sym_count; i++) {
        if(strcmp(symbol_table[i], id) == 0) {
            return; 
        }
    }
    strcpy(symbol_table[sym_count], id);
    sym_count++;
}
%}
DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          (_|{LETTER})({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+(\.{DIGIT}+)?
CHAR_CONST  '[^']'
WHITESPACE  [ \t\r]

%%

\n { line_no++; }

{WHITESPACE}+ {  }

"//".* {  }
"/*"([^*]|\*+[^*/])*\*+"/"  {  }

"int"|"float"|"char"|"return"|"if"|"else"|"while"|"for"|"void"|"double"|"long"|"struct"|"break"|"continue" { 
    printf("Keyword: %s\n", yytext); 
}

"+"|"-"|"*"|"/"|"="|"<"|">"|"%"|"."|"=="|"!="|"<="|">=" { 
    printf("Operator: %s\n", yytext); 
}

[,;(){}\[\]&] { 
    printf("Punctuation: %s\n", yytext); 
}

{ID} { 
    printf("Identifier: %s\n", yytext); 
    add_to_symbol_table(yytext);
}

{NUMBER} { 
    printf("Constant: %s\n", yytext); 
}

{CHAR_CONST} { 
    printf("Constant: %s\n", yytext); 
}

\".*\" { 
    printf("String: %s\n", yytext); 
}

{DIGIT}+({LETTER}|_)+ { 
    printf("\nLEXICAL ERRORS\n");
    printf("Line %d : %s invalid lexeme\n", line_no, yytext);
}

. { 
    printf("LEXICAL ERROR: Unknown character %s at line %d\n", yytext, line_no); 
}

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    
    printf("TOKENS\n");
    yylex();

    printf("\nSYMBOL TABLE ENTRIES\n");
    for(int i = 0; i < sym_count; i++) {
        printf("%d) %s\n", i+1, symbol_table[i]);
    }

    return 0;
}