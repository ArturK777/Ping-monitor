\ nodelist parser 
USER >IN_  ( -- a-addr )
: PARSE_\ ( c-addr u -- c-addr1 u1 )
	OVER >IN_ !
    BEGIN
			>IN_ C@ DUP 32 > .S ." *** " CR
		WHILE . CR
			>IN_ 1+!
    REPEAT
;

: PARSE_ ( c-addr u -- c-addr1 u1 )
	0 DO DUP I + C@
		DUP 32 > IF EMIT ELSE DROP CR THEN
	LOOP CR CR ;
: TEMP  ( -- c-addr u )  S" 10.0.0.100 temp 5" ;

TEMP
PARSE_

 .S
