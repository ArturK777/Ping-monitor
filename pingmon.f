REQUIRE /STRING lib\include\string.f
REQUIRE CONCAT ~micro\lib\str.f

4 CONSTANT N_ITEMS \ max number of nodes
255 CONSTANT N_LEN  \ max length of nodelist string
0 VALUE FILEID
CREATE N_STR 0 , \ number of node strings in list
CREATE MAX_LEN 0 , \ max len of node string
CREATE tSTR N_LEN ALLOT \ temp string buffer
CREATE NODES[] N_ITEMS N_LEN * ALLOT \ array of nodes
: ?COMM ( addr -- c ) C@ 92 = ; \ is comment? "\"
: TRIM  ( str len -- str len-i ) \ Trim white space from end of string (from toolbelt.f)
    BEGIN  DUP WHILE
        1-  2DUP + C@ IsDelimiter 0=
    UNTIL 1+ THEN ;
: BL-SKIP  ( str len -- str+i len-i ) \ Skip over white space at start of string (from toolbelt.f)  
    BEGIN  DUP WHILE  OVER C@ IsDelimiter
    WHILE  1 /STRING  REPEAT THEN ;
: OPEN_LST ( -- fileid ) \ open list of nodes to ping "nodes.txt"
	SOURCE-NAME \ full name of source .f file
	CUT-PATH \ cut pathname
	S" nodes.txt" CONCAT \ full name of nodes.txt
\	2DUP DUMP CR 
 	R/O OPEN-FILE THROW DUP TO FILEID ;
: SCAN_LST ( fileid -- ) \ measuring nodelist size
    BEGIN
        DUP tSTR N_LEN ROT READ-LINE THROW
    WHILE
         tSTR SWAP
         BL-SKIP \ skip leadind spaces
         SWAP DUP ?COMM IF
            .S CR 2DROP
         ELSE .S CR 
            SWAP 2DUP TYPE CR .S CR
            MAX_LEN @ MAX MAX_LEN !
            N_STR 1+!
            DROP
         THEN
    REPEAT  DROP
;   
: DIM_A ( i -- a ) N_LEN * NODES[] + ; \ NODES[i] cell addr
: READ_DIM ( fileid -- ) \ read nodes.txt to NODES[]
    N_ITEMS 0 DO DUP
        I DIM_A N_LEN 2- ROT .S ." *** " READ-LINE .S THROW ." --> " FILEID FILE-POSITION . D. CR 
        2DROP
    LOOP
;
CR .( ---) CR 
	OPEN_LST
    SCAN_LST
\	READ_LST
\    READ_DIM
    CLOSE-FILE THROW
\    NODES[] 100 DUMP

CR .( ===) CR .S

: READ_LST
	\ читаем по адресу HERE не более 1кЅ
    DUP HERE 1024 ROT \ преобразовали из ( fid ) в ( fid addr-here 1024 fid )
    READ-FILE THROW \ получили число реально считанныйх байт
    HERE SWAP TYPE \ распечатаем их с адреса HERE
	DUP FILE-SIZE
\    CLOSE-FILE THROW \ всЄ, закончили
;
