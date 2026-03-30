%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int yylex();
void yyerror(const char *s);

int isNumber(char *s) {
    int i = 0, dot = 0;
    if (s[0] == '\0') return 0;

    while (s[i]) {
        if (s[i] == '.') {
            dot++;
            if (dot > 1) return 0;
        } else if (!isdigit(s[i])) {
            return 0;
        }
        i++;
    }
    return 1;
}

char* fold(char *a, char op, char *b) {
    char *res = (char*)malloc(100);

    if (isNumber(a) && isNumber(b)) {
        double x = atof(a);
        double y = atof(b);
        double ans;

        switch(op) {
            case '+': ans = x + y; break;
            case '-': ans = x - y; break;
            case '*': ans = x * y; break;
            case '/': ans = x / y; break;
            default: ans = 0;
        }

        sprintf(res, "%.2f", ans);

        int len = strlen(res);
        while (len > 0 && res[len - 1] == '0') {
            res[len - 1] = '\0';
            len--;
        }
        if (len > 0 && res[len - 1] == '.') {
            res[len - 1] = '\0';
        }
    } else {
        sprintf(res, "%s %c %s", a, op, b);
    }

    return res;
}
%}

%union {
    char *str;
}

%token <str> NUMBER ID
%type <str> E T F

%%

L : E '\n' { printf("Optimized expression: %s\n", $1); }
  ;

E : E '+' T { $$ = fold($1, '+', $3); }
  | E '-' T { $$ = fold($1, '-', $3); }
  | T       { $$ = $1; }
  ;

T : T '*' F { $$ = fold($1, '*', $3); }
  | T '/' F { $$ = fold($1, '/', $3); }
  | F       { $$ = $1; }
  ;

F : '(' E ')' { $$ = $2; }
  | NUMBER    { $$ = $1; }
  | ID        { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    printf("Invalid expression\n");
}

int main() {
    printf("Enter expression: ");
    yyparse();
    return 0;
}