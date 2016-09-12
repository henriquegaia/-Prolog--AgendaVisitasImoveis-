%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('bc').
:-consult('estimativa').
/*

BEST FIRST

bestFirst(a,f,L,C).
L=[a,b,d,f].
C=11.

O=ORIGEM
D=DESTINO
Cam=Caminho final
C=Custo final
Ca=Custo actual
Ex=estimativa
Nc=novo custo
Cx=custo ligacao entre 2 pts
CamM=caminho melhor

*/
bestFirst(O,D,Cam,C):-
	nl,writeln('Metodo pesquisa: Best first..........'),
	bf2(D,[O],Cam,0,C).

bf2(D,[D|T],Cam,C,C):-%condicao de paragem
	reverse([D|T],Cam),
	!.


bf2(D,[H|T],Cam,Ca,C):-
	Object=(Ex,Nc,[X,H|T]),
	Goal=(
	    H \= D,
	    (estrada(H,X,Cx);estrada(X,H,Cx)),
	    \+member(X,[H|T]),
	    estimativa(X,D,Ex),
	    Nc is Ca+Cx
	),
	findall(Object,Goal,Novos),
	sort(Novos,[(_,CustoMin,CamM)|_]),%ordena por Ex
	bf2(D,CamM,Cam,CustoMin,C).

/*
bf2(D,[_|_],Cam,_,_):-
	bf2(D,D,Cam,0,0).
*/

