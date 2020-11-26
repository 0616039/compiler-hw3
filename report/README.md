# 作業 3 報告 

> 學生：陸顗文  
>
> 學號：0616039  
  
+ HW3是要建一個 AST tree 然後再用 visit 的方法 print 出語法結構  

1.如何改lex?  
> 由於希望傳回的是char*的型態,我們先在parser的union中宣告一個char* str,然後在lex的每個token加上yylval.str=strdup(yytext);讓他以char*的方式回傳給parser,接著,考慮到小數以及自然數還有八進位在結果中需要被改變,所以我先把八進位的轉成char*,然後換成10進位,而小數及自然數則是要setprecision(6),在傳回parser。  

2.如何改parser?  
> 建立 AST 便是在 parser 做的,先把需要用到的node建立出來,我是建立了  
* Program Node  
* Declaration Node  
* Variable Node  
* Constant Value Node  
* Function Node  
* Compound Statement Node  
* Assignment Node  
* Print Node  
* Read Node  
* Variable Reference Node  
* Binary Operator Node  
* Unary Operator Node  
* If Node  
* While Node  
* For Node  
* Return Node  
* Function Call Node  
> 在各自的.cpp .hpp檔宣告他們的函數以及他們要存的資料  
> 然後在union中分別宣告這些node變成type,再將原本的nonterminal加上type,例如  
* %type<state> Statement Simple  
> 便是宣告statement,simple為statement的型別  
> 接著,就是要把樹建起來,就是從token傳進來(也就是leaves),然後把所有的內容傳給parent,讓parent得到資料,最後則是傳給program。  
  
3.使用visit  
> 我是照著/ast_guideline.md的內容,把每個node要print的東西都打上去,還有一個部份是level,代表它的深度,因為要有ident,所以必須要知道它的深度才能知道他要空幾格。  
  
4.遇到的困難
> 一開始真的不知道怎麼寫,感謝助教拍影片讓我們有個大概的方向,接著在做AST的時候,因為我有時候有些資料沒傳到,所以有些會傳到NULL,造成segementation fault,這真的是最痛苦的,因為有時候還找不到bug在哪,所以就砍掉重練了QQ,好險最後有成功,沒有segementation fault的問題了,真的應該要一個一個檢查,再來是ident的問題,一開始我用偷吃步的作法,在printnode時直接固定用幾個空格,但是這個方法在測資中只能過program.p,variable.p,所以我只好去請求別人的幫忙,以至於我學會用level的方法,最後是constant的問題,一開始我不知道要換成十進位以及固定小數點為六位,所以我的constant部分一直有錯,才知道是因為我lex沒改到,但我覺得我用sstring的方法有點麻煩,不知道有沒有更好的方法QQ。

