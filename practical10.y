%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex();
%}

%union {
    double val;
}

%token <val> NUMBER
%type <val> E T F G L

%%

L : L E '\n'        { printf("Result = %g\n", $2); }
  | /* empty */
  ;

E : E '+' T       { $$ = $1 + $3; }
  | E '-' T       { $$ = $1 - $3; }
  | T             { $$ = $1; }
  ;

T : T '*' F       { $$ = $1 * $3; }
  | T '/' F       {
                    if($3 == 0) {
                        printf("Division by zero error\n");
                        exit(1);
                    }
                    $$ = $1 / $3;
                  }
  | F             { $$ = $1; }
  ;

F : G '^' F       { $$ = pow($1, $3); }
  | G             { $$ = $1; }
  ;

G : '(' E ')'     { $$ = $2; }
  | NUMBER        { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    printf("Invalid expression\n");
}

int main() {
    printf("Enter expressions (Ctrl+D to stop):\n");
    yyparse();
    return 0;
}