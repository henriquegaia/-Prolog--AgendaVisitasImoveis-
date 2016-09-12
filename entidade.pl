%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('validacoes').
:-consult('conversoes').
:-consult('bc').

novaEntidade(P,Nome):-
	getUltimoId(P,LastId),
	Id is LastId+1,
	Pred=..[P,Id,Nome],
	assertz(Pred).

getUltimoId(P,LastId):-
	Pred=..[P,Id,_],
	Goal=(
	    Pred,
	    integer(Id)
	),
	findall(Id,Goal,L),
	getUltimoId2(L,LastId).

getUltimoId2([],0):-
	!.

getUltimoId2(L,LastId):-
	max_member(LastId,L),
	!.

printAll(P,Titulo):-
	write('-----------------------------'),nl,
	write(Titulo),nl,
	write('-----------------------------'),nl,
	write('Id \tNome '),nl,
	write('-----------------------------'),nl,
	Pred=..[P,Id,Nome],
	forall(Pred,writef('%w \t%w \n',[Id,Nome])).

getAll(P,L):-
	Pred=..[P,Id,Nome],
	Goal=(
	    Pred
	),
	findall((Id,Nome),Goal,L).

getAllId(P,L):-
	Pred=..[P,Id,_],
	Goal=(
	    Pred
	),
	findall(Id,Goal,L).


getNomeById(P,Id,Nome):-
	Pred=..[P,Id,Nome],
	Pred.

deleteAll(P):-
	Pred=..[P,_,_],
	retractall(Pred).

deleteById(Pc,Pd,Id):-
	Pred=..[Pc,Id,_],
	retract(Pred),
	deleteAllDispByEntId(Pd,Id).


/**********************************************************
///////////////////////////////////////////////////////////
Disp
///////////////////////////////////////////////////////////
**********************************************************/

criaDisp(Pc,Pd,IdEnt,Dia,H_i,H_f):-
	validaId(Pc,IdEnt),
	getUltimoIdDisp(Pd,LastId),
	ID_Disp is LastId + 1,
	horasParaMinutos(H_i,Min_i),
	horasParaMinutos(H_f,Min_f),
	validaDia(Dia),
	validaMins(Min_i,Min_f),
	Pred=..[Pd,IdEnt,ID_Disp,Dia,Min_i,Min_f],
	assertz(Pred).

criaDisp_Min(Pd,IdEnt,Dia,Min_i,Min_f):-
	getUltimoIdDisp(Pd,LastId),
	ID_Disp is LastId + 1,
	Pred=..[Pd,IdEnt,ID_Disp,Dia,Min_i,Min_f],
	assertz(Pred).

validaId(Pd,ID):-
	Pred=..[Pd,ID,_],
	Pred.

validaId(Pc,ID):-
	ID > 0,
	getUltimoId(Pc,LastId),
	ID =< LastId,
	!.

validaId(Pc,ID):-
	writef('%w: O id %w nao existe',[Pc,ID]),nl.

getUltimoIdDisp(Pd,LastId):-
	Pred=..[Pd,_,Id,_,_,_],
	Goal=(
	    Pred
	),
	findall(Id,Goal,L),
	getUltimoIdDisp2(L,LastId).

getUltimoIdDisp2([],0):-
	!.

getUltimoIdDisp2(L,LastId):-
	max_member(LastId,L),
	!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getAllDisp(P,L):-
	Pred=..[P,ID,ID_Disp,Dia,Min_i,Min_f],
	Object=(ID,ID_Disp,Dia,Min_i,Min_f),
	Goal=(
	    Pred
	),
	findall(Object,Goal,L).

getAllDispId(P,L):-
	Pred=..[P,_,ID_Disp,_,_,_],
	Object=(ID_Disp),
	Goal=(
	    Pred
	),
	findall(Object,Goal,L).


printAllDisp(P,Titulo):-
	write('-----------------------------'),nl,
	write('Disponibilidade '), write(Titulo),nl,
	write('-----------------------------'),nl,
	write('Id Ent \tId Dis \tDia \tInicio \tFim'),nl,
	write('-----------------------------'),nl,
	Pred =..[P,ID,ID_Disp,Dia,Min_i,Min_f],
	Do =(
	    Pred,
	    minutosParaHoras(Min_i,Inicio),
	    minutosParaHoras(Min_f,Fim)
	),
	Action = writef('%w \t%w \t%w \t%w \t%w\n',Args),
	Args =[ID,ID_Disp,Dia,Inicio,Fim],
	forall(Do,Action).


getDispById(P,ID,L):-
	Pred =..[P,ID,ID_Disp,Dia,Min_i,Min_f],
	Object=(ID,ID_Disp,Dia,Min_i,Min_f),
	Goal=(
	    Pred
	),
	findall(Object,Goal,L).

deleteAllDisp(P):-
	Pred =..[P,_,_,_,_,_],
	retractall(Pred).

deleteAllDispByEntId(P,EntId):-
	Pred =..[P,EntId,_,_,_,_],
	retractall(Pred).

deleteDispById(P,Id_Disp):-
	Pred =..[P,_,Id_Disp,_,_,_],
	retract(Pred).

getListaDispByTempoVisita(P,IdEnt,TempoVisita,FimUltVisita,L):-
	Object = IdDisp,
	Pred =..[P,IdEnt,IdDisp,_,Min_i,Min_f],
	Goal=(
	    Pred,
	    TempoVisita =< Min_f - Min_i,
	    Min_i > FimUltVisita
	),
	findall(Object,Goal,L).

updateDisp(Pc,Pd,IdDisp,InicioVisita,FimVisita):-
	Pred=..[Pd,IdEnt,IdDisp,D,Min_i,Min_f],
	Pred,
	NovoInico1 is Min_i,
	NovoFim1 is InicioVisita,
	NovoInico2 is FimVisita,
	NovoFim2 is Min_f,
	criaDisp2(Pd,IdEnt,D,NovoInico1,NovoFim1),
	criaDisp2(Pd,IdEnt,D,NovoInico2,NovoFim2),
	deleteDispById(Pd,IdDisp),
	eliminaDispsComInicioEfimIguais(Pd),
	juntaDispsInicioEfimIguais(Pc,Pd).

updateDisp(_,_,_,_,_):-
	writeln('erro updateDisp').

criaDisp2(P,IdEnt,Dia,Min_i,Min_f):-
	getUltimoIdDisp(P,LastId),
	Id is LastId+1,
	Pred =.. [P,IdEnt,Id,Dia,Min_i,Min_f],
	assertz(Pred).

organizaDisps(Pc,Pd):-
	eliminaDispsComInicioEfimIguais(Pd),
	juntaDispsInicioEfimIguais(Pc,Pd).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eliminar disponibilidade com fim e inicio iguais
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eliminaDispsComInicioEfimIguais(P):-
	Object = IdDisp,
	Pred =..[P,_,IdDisp,_,Min_i,Min_f],
	Goal=(
	    Pred,
	    Min_i==Min_f
	),
	findall(Object,Goal,L),
	eliminaDispsComInicioEfimIguais2(P,L).

eliminaDispsComInicioEfimIguais2(_,[]).

eliminaDispsComInicioEfimIguais2(P,[H|T]):-
	deleteDispById(P,H),
	eliminaDispsComInicioEfimIguais2(P,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%juntar disponibilidades com fim e inicio iguais
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

juntaDispsInicioEfimIguais(Pc,Pd):-
	getAllDispId(Pd,Ldisp),
	nCopiasLista(Ldisp,2,Copias),
	todasComb(Copias,TodasCombin),
	junta3(Pc,Pd,TodasCombin).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nCopiasLista([1,2,3],3,L2).

nCopiasLista(_,0,[]).

nCopiasLista(L,N,[L|T]):-
	N>0,
	N2 is N-1,
	nCopiasLista(L,N2,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try([],[]).

try([L|Ls],[M|Ms]):-
	member(M,L),
	try(Ls,Ms).

todasComb(L,All) :-
	findall(M, try(L,M), All).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

junta3(_,_,[]).

junta3(Pc,Pd,[[Id1|[Id2|_]]|T]):-
	Id1 \== Id2,
	Id1 < Id2,
	junta4(Pc,Pd,Id1,Id2),
	junta3(Pc,Pd,T).

junta3(Pc,Pd,[_|T]):-
	junta3(Pc,Pd,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

junta4(Pc,Pd,Id1,Id2):-
	Pred1 =..[Pd,IdE,Id1,D,Min_i,Min_f],
	Pred2 =..[Pd,IdE,Id2,D,Min_i2,Min_f2],
	Pred1,
	Pred2,
	((Min_i== Min_f2);(Min_i2==Min_f)),
	min(Min_i,Min_i2,NovoIni),
	max(Min_f,Min_f2,NovoFim),
	deleteDispById(Pd,Id1),
	deleteDispById(Pd,Id2),
	criaDisp(Pc,Pd,IdE,D,NovoIni,NovoFim).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
