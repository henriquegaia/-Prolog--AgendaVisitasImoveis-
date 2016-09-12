%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-module(estimativa,[estimativa/3]).

estimativa(C1,C2,Est):-
	coordenada(C1,X1,Y1),
	coordenada(C2,X2,Y2),
	DX is X1-X2,
	DY is (Y1-Y2),
	Est is sqrt(DX*DX+DY*DY).
