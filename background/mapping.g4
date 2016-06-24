grammar mapping;

//import fluentpath;

mapping
    : mappingName usesStatement* importsStatement* inputStatement+ ruleStatement+
    ;


mappingName
    : 'map' '"' URL '"' '=' ID
    ;

usesStatement
    : 'uses' '"' URL '"' 'as' useMode
    ;

useMode
    : 'source'
    | 'queried'
    | 'target'
    | 'produced'
    ;

importsStatement
    : 'imports' '"' URL '"'
    ;

inputStatement
    : 'input' ID ':' ID 'as' useMode
    ;

ruleStatement
    : ID ':' 'for' sourceStatements 'make'
    ;

sourceStatements
    : sourceStatement (',' sourceStatement)*
    ;

sourceStatement
    : 'optional'? contextExpression variableBinding? whereStatement? checkStatement?
    ;

variableBinding
    : 'as' ID
    ;

whereStatement
    : 'where' fluentPathExpression
    ;

checkStatement
    : 'check' fluentPathExpression
    ;

contextExpression
    : '@'? ID ('.' ID)*
    ;

fluentPathExpression
    : (. | '(' | ')' | '\'' | '\"' )+
    ;


ID
    : [A-Za-z0-9\-\._]+           // Max length is 64 positions
    ;

URL
    : (HTTP|FTP)'://'~[\s/$\.\?#"].~[\s"]*
    ;

fragment HTTP
    : ('H'|'h')('T'|'t')('T'|'t')('P'|'p')('S'|'s')?
    ;

fragment FTP
    : ('F'|'f')('T'|'t')('P'|'p')
    ;


// Pipe whitespace to the HIDDEN channel to support retrieving source text through the parser.
WS
        : [ \n\r\t]+ -> channel(HIDDEN)
        ;

COMMENT
        : '/*' .*? '*/' -> channel(HIDDEN)
        ;

LINE_COMMENT
        : '//' ~[\r\n]* [\n\r] -> channel(HIDDEN)
        ;
