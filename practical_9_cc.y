%{
	#include<stdio.h>
	#include<stdlib.h>

	void yyerror(const char *s)
	int yylex(void);
}%

%token

%% 
	
S  : 'i' E 't' S S1
   | 'a'
   ;

S1 : 'e' S
   | /* empty */
   ;

E  : 'b'
   ;
%%

int main(){
	printf("Enter String:");
	if(yyparse()==0)
		prinf("Valid String\n");
	else
		printf("Invalid String\n");
	return 0;
}
