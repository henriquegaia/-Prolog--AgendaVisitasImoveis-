%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('bc').
:-consult('estimativa').


aStar(Orig,Dest,Cam,Custo):-
	nl,writeln('Metodo pesquisa: aStar..........'),
	aStar2([(0,0,[Orig])],Dest,Cam,Custo).

aStar2([(_,Custo,[Dest|T])|_],Dest,Cam,Custo):-
	reverse([Dest|T],Cam),
	!.


aStar2([(_,Ca,[H|T])|Outros],Dest,Cam,Custo):-
	Object=(CTx,CAx,[X,H|T]),
	Goal=(
	    H\==Dest,
	    (estrada(H,X,Cx);estrada(X,H,Cx)),
	    not(member(X,T)),
	    estimativa(X,Dest,Ex),
	    CAx is Ca + Cx,
	    CTx is CAx + Ex
	),
	findall(Object,Goal,Novos),
	append(Outros,Novos,Todos),
	sort(Todos,TodosOrd),
	aStar2(TodosOrd,Dest,Cam,Custo).
