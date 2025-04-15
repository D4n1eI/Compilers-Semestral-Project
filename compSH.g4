grammar compSH;

program:
    command*EOF
    ;


command:
    | declaration
    | std
    ;


std:
    | stdin 
    | stdout 
    ;

declaration:
    | Variable ':' type
    ;

stdin:
    | 'stdin' command
    | 'stdin' Variable
    ;

stdout:
    | Variable | 'stdout'
    ;
type: 
    | 'text'
    | 'float'
    | 'int'
    | 'program'
    ;
Integer: [0-9]+;
Variable: [a-zA-Z]+;
NEWLINE: 'r'? '\n';
WS: [ \t]+ -> skip;
COMMENT: '#' [\n]* -> skip;