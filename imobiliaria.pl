%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('entidade').
:-dynamic posseChave/2.

/**********************************************************
///////////////////////////////////////////////////////////
Chave
///////////////////////////////////////////////////////////
**********************************************************/

geraPosseChave:-
	obterChave(esc).


obterChave(Imovel):-
	getUltimoIdDisp_Chave(posseChave,LastId),
	ID_Disp is LastId + 1,
	validaImovel(Imovel),
	assertz(posseChave(ID_Disp,Imovel)).

getUltimoIdDisp_Chave(Pd,LastId):-
	Pred=..[Pd,Id,_],
	Goal=(
	    Pred
	),
	findall(Id,Goal,L),
	getUltimoIdDisp2(L,LastId).

validaImovel(Nome):-
	imovel(Nome,_),
	!.

validaImovel(Nome):-
	writef('%w: imovel nao existe',[Nome]),nl.

getAllImoveisPosseChave(L):-
	Pred=..[posseChave,_,NomeImovel],
	Goal=(
	    Pred
	),
	findall(NomeImovel,Goal,L).

printAllPosseChave:-
	printAll(posseChave,'Posse de Chave').

deleteAllPosseChave:-
	deleteAll(posseChave).
