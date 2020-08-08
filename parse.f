
: PARSE@ ( c-addr u -- c-addr1 u1 ) 
    BEGIN 0
    WHILE
    REPEAT
;
: TEMP  ( -- c-addr u )  S" 10.0.0.100 temp 5" ;

TEMP
PARSE@

 .S
