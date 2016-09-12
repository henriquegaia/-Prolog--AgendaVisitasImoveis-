%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('entidade').
:-dynamic imovel/2.
:-dynamic dispImovel/5.

geraImoveis:-
	criaImovel(esc,a),
	criaImovel(k2,a),
	criaImovel(k3,b),
	criaImovel(k4,b),
	criaImovel(k5,c).

geraImoveis2:-
	criaImovel(esc,a).

criaImovel(Id,Zona):-
	validaNomeImovel(Id),
	validaZona(Zona),
	assertz(imovel(Id,Zona)).

validaNomeImovel(Nome):-
	getAllImoveis(L),
	\+member(Nome,L).

validaNomeImovel(Nome):-
	nl,writef('nome imovel "%w" ja existe',[Nome]),
	false.

validaZona(Z):-
        zona(Z,_),
        !.

validaZona(Z):-
	nl,writef('nome zona "%w" nao existe',[Z]),
	false.

getIdZonaByNome(Nome,Id):-
	zona(Id,Nome),
	!.

getIdZonaByNome(Nome,_):-
	nl,writef('nome zona "%w" nao existe',[Nome]),
	false.

normalizaNomeZonas:-
	Object=Zona_norm,
	Goal=(
	    zona(_,Zona),
	    normalize_space(atom(Zona_norm),Zona)
	),
	findall(Object,Goal,_).

getAllZonas(L):-
	Pred=..[zona,X,_],
	Goal=(
	    Pred
	),
	findall(X,Goal,L).

printAllImoveis_semProp:-
	write('-----------------------------'),nl,
	write('Imoveis'),nl,
	write('-----------------------------'),nl,
	write('Id \tZona'),nl,
	write('-----------------------------'),nl,
	Action = writef('%w \t%w\n',[Id,Zona]),
	forall(imovel(Id,Zona),Action).

deleteAllImoveis_semProp:-
	retractall(imovel(_,_)).

deleteImovelByNome_semProp(Nome):-
	retract(imovel(Nome,_)).

getAllImoveis(L):-
	Pred=..[imovel,X,_],
	Goal=(
	    Pred
	),
	findall(X,Goal,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getZonaOrigem(Imovel,Zona):-
	getZonaByImovel(Imovel,Zona).

getZonaDestino(Imovel,Zona):-
	getZonaByImovel(Imovel,Zona).

getZonaByImovel(Imovel,Zona):-
	imovel(Imovel,Zona),
	!.



%aggregate_all(count, imovel2(X,Y,Z,C), Count).

/**********************************************************
///////////////////////////////////////////////////////////
Disp
///////////////////////////////////////////////////////////
**********************************************************/

geraDisp_Imovel:-
	criaDisp_imovel(k1,1,'14:00','15:00'),
	criaDisp_imovel(k2,3,'15:40','17:00'),
	criaDisp_imovel(k3,3,'10:00','12:00'),
	criaDisp_imovel(k1,4,'09:00','11:00'),
	criaDisp_imovel(k4,3,'13:00','18:00'),
	criaDisp_imovel(k5,5,'12:15','14:50').


criaDisp_imovel(ID_Imovel,Dia,H_i,H_f):-
	criaDisp(imovel,dispImovel,ID_Imovel,Dia,H_i,H_f).


getAllDisp_imovel(L):-
	getAllDisp(dispImovel,L).

printAllDisp_imoveis:-
	printAllDisp(dispImovel,'imoveis').

getDispImovelById(ID_Imovel,L):-
	getDispById(dispImovel,ID_Imovel,L).

deleteAllDisp_imovel:-
	deleteAllDisp(dispImovel).

deleteDispImovelById(Id_Disp):-
	deleteDispById(dispImovel,Id_Disp).

updateDispImovel(IdDispImovel,InicioVisita,FimVisita):-
	updateDisp(imovel,dispImovel,IdDispImovel,InicioVisita,FimVisita).

% Diferente da anterior pq ainda nao foi verificado se existe
% compatibilidade tempos
updateDispImovel_semProp(IdImovel,Dia,InicioVisita,FimVisita):-
	getDispImovelById(IdImovel,ListaDisps),
	updateDispImovel_semProp2(ListaDisps,Dia,InicioVisita,FimVisita).

updateDispImovel_semProp2([],_,_,_).%nao actualiza

updateDispImovel_semProp2([(_,IdDispImovel,DiaDisp,IniDisp,FimDisp)|_],DiaVis,InicioVisita,FimVisita):-
	DiaDisp==DiaVis,
	FimVisita > IniDisp,
	InicioVisita < FimDisp,
	updateDisp(imovel,dispImovel,IdDispImovel,InicioVisita,FimVisita).

updateDispImovel_semProp2([(_,_,_,_,_)|T],DiaVis,InicioVisita,FimVisita):-
	updateDispImovel_semProp2(T,DiaVis,InicioVisita,FimVisita).

organizaDispsImovel:-
	organizaDisps(imovel,dispImovel).
