grammar CompSh;

program:
	stat* EOF
	;
stat:
	  expr
	| pipe
	| declaration 
	;
declaration:
	Variable (',' Variable)* ':' type
	;
pipe:
	  expr '|' expr		#PipeSingle
	| expr '||' expr	#PipeStdout	
	| expr '|&' expr	#PipeStderr	
	| expr '|?' expr	#PipeExit	
	| expr '|$' expr	#PipeExpression
	;
expr:
	  op=('+'|'-') expr					#ExprUnary
	| '(' expr ')'						#ExprParenthesis
	| expr op=('*'|'/'|'%') expr		#ExprMultDivMod
	| expr op=('+'|'-') expr			#ExprAddSub
	| type '(' expr ')' 				#ExprConversion
	| 'store' 'in' Variable (':' type)?	#ExprStore
	| '!' expr                      			#ExprNot
	| expr op=('='|'/='|'>'|'>='|'<'|'<=') expr	#ExprBranch
    | expr '||' expr              				#ExprOr
    | expr '&&' expr                      		#ExprAnd
	| Integer			#ExprInteger
	| Real				#ExprReal
	| Text				#ExprText
	|  Text '+' Text	#ExprConcat
	| 'stdin' (Text)?	#ExprStdin
	| 'stdout'			#ExprStdout
	| 'stderr'			#ExprStderr
	| '!' Text '!'		#ExprExternal
	| '!!' Text '!!' 	#ExprExecIsh
	| Variable			#ExprVariable
	;
type:
	 'text'
	|'integer'
	|'real'
	|'program'
	;
loop:
	  'loop' stat* 'until' expr'end'				#LoopTail
	| 'loop' 'while' stat* 'do' expr 'end'			#LoopHead
	| 'loop' stat* 'while' expr 'do' stat* 'end'	#LoopMiddle	
	;
if:
    'if' expr 'then' stat* ('else if' expr 'then' stat* )*  ('else' stat* )? 'end'
	;
Integer: [0-9]+;
Real: [0-9]+('.'[0-9]+)?;
Text: '"' .*? '"';
Variable: [a-zA-Z][a-zA-Z0-9]*;
NEWLINE:	'\r'? '\n';
WS:			[ \t]+ -> skip;
COMMENT: '#' .*? ~[\n]* -> skip;
ERROR: .;
