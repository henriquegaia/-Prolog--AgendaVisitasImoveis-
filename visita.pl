%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-dynamic visita/11.
:-dynamic planoVisitas/3.

novoPlanoVisitas(IdCli,ListaImoveis):-
	getUltimoIdVis(LastId),
	Id is LastId+1,
	Pred = planoVisitas(Id,IdCli,ListaImoveis),
	assertz(Pred).

novaVisita(IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,Regr,Cam):-
	getUltimoIdVis(LastId),
	Id is LastId+1,
	Pred = visita(Id,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,Regr,Cam),
	assertz(Pred).

getUltimoIdVis(LastId):-
	Goal=(
	    planoVisitas(Id,_,_)
	),
	findall(Id,Goal,L),
	getUltimoId2Vis(L,LastId).

getUltimoIdVis(LastId):-
	Goal=(
	    visita(Id,_,_,_,_,_,_,_,_,_,_)
	),
	findall(Id,Goal,L),
	getUltimoId2Vis(L,LastId).

getUltimoId2Vis([],0):-
	!.

getUltimoId2Vis(L,LastId):-
	max_member(LastId,L),
	!.

getAllVisitas(L):-
	Pred = visita(Id,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,Regr,Cam),
	Goal=(
	    Pred
	),
	findall(visita(Id,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,Regr,Cam),Goal,L).

getAllIdPlanoVisitas(L):-
	Goal=(
	    planoVisitas(Id,_,_)
	),
	findall(Id,Goal,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getFimUltimaVisita(FimVisita):-
	getUltimoIdVis(UltIdVis),
	getFimUltimaVisita2(UltIdVis,FimVisita).

getFimUltimaVisita2(0,0).

getFimUltimaVisita2(UltIdVis,FimVisita):-
	visita(UltIdVis,_,_,_,_,_,FimVisita,_,_,_,_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getUltPtVisitaEImovel([],0,0).

getUltPtVisitaEImovel(Lids,UltIdVisita,ImovelVisitado):-
	max_member(UltIdVisita,Lids),
	UltIdVisita \== 0,
	!,
	visita(UltIdVisita,_,ImovelVisitado,_,_,_,_,_,_,_,_).

getUltPtVisitaEImovel(_,0,0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deleteVisita(Id):-
	retract(visita(Id,_,_,_,_,_,_,_,_,_,_)).

deleteVisitasByCliId(Id):-
	retractall(visita(_,_,_,Id,_,_,_,_,_,_,_)).

deleteVisitasByVendId(Id):-
	retractall(visita(_,Id,_,_,_,_,_,_,_,_,_)).

deleteAllVisitasFicheiro:-
	retractall(planoVisitas(_,_,_)).

deleteAllVisitas:-
	retractall(visita(_,_,_,_,_,_,_,_,_,_,_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printPlanoVisitasFicheiro:-
	write('-----------------------------'),nl,
	write('Visitas em ficheiro '),nl,
	write('-----------------------------'),nl,
	write('Id \tId Cli \tLista de Imoveis '),nl,
	write('-----------------------------'),nl,
	Pred = planoVisitas(Id,IdCli,ListaImoveis),
	Action = writef('%w \t%w \t%w\n',Args),
	Args = [Id,IdCli,ListaImoveis],
	forall(Pred,Action).

printAllVisitas:-
	ordenaVisitas,
	write('-----------------------------'),nl,
	write('Visitas agendadas'),nl,
	write('-----------------------------'),nl,
	write('Id Vi \tIdVend \tImovel \tIdCli \tDia \tDur_V \tIni_V \tIni \tFim \tRegr \tCam '),nl,
	write('-----------------------------'),nl,
	Pred = visita(Id,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,Regr,Cam),
	Do =(
	    Pred,
	    minutosParaHoras(Min_i,Inicio),
	    minutosParaHoras(Min_f,Fim),
	    minutosParaHoras(IniViag,NovoIniViag),
	    minutosParaHoras(DurViag,NovaDurViag),
	    minutosParaHoras(Regr,NovoRegr)
	),
	Action = writef('%w - \t%w \t%w \t%w \t%w \t%w \t%w \t%w \t%w \t%w \t%w\n',Args),
	Args = [Id,IdVend,Imovel,IdCli,Dia,NovaDurViag,NovoIniViag,Inicio,Fim,NovoRegr,Cam],
	forall(Do,Action),
	printLegenda.

printLegenda:-
	nl,
	writeln('Legenda ---------------------'),
	writeln('Id Vi  =  id Visita'),
	writeln('IdVend =  id vendedor/mediador'),
	writeln('Imovel =  id imovel'),
	writeln('IdCli  =  id cliente'),
	writeln('Dia    =  dia visita'),
	writeln('Dur_V  =  duracao da viagem expressa no caminho (Cam)'),
	writeln('Ini_V  =  hora inicio da viagem vendedor até ao ponto de visita'),
	writeln('Ini    =  hora de inicio da visita'),
	writeln('Fim    =  hora de fim da visita'),
	writeln('Regr   =  hora de regresso do vendedor ao ponto inicial do plano de visitas'),
	writeln('Cam    =  caminho a percorrer até ao ponto de visita').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%retira hora de regresso das visitas onde nao ha regresso à origem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eliminaRegressosVisitas(Tipo,Lids):-
	max_member(Max,Lids),
	eliminaRegressosVisitas2(Max,Lids),
	!,
	eliminaRegressoUltVisita(Tipo,Max).

eliminaRegressosVisitas2(_,[]).

eliminaRegressosVisitas2(IdUltVisita,[H|T]):-
	IdUltVisita \== H,
	Pred_old = visita(H,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,_,Cam),
	Pred_new = visita(H,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,'---',Cam),
	retract(Pred_old),
	asserta(Pred_new),
	eliminaRegressosVisitas2(IdUltVisita,T).

eliminaRegressosVisitas2(IdUltVisita,[_|T]):-
	eliminaRegressosVisitas2(IdUltVisita,T).


eliminaRegressoUltVisita(1,IdUltVisita):-
	Pred_old = visita(IdUltVisita,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,_,Cam),
	Pred_new = visita(IdUltVisita,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,'---',Cam),
	retract(Pred_old),
	asserta(Pred_new).

eliminaRegressoUltVisita(_,_):-true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ordena o predicado visita por dia e depois por hora inicio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ordenaVisitas:-
	getAllVisitas(Lvis),
	predsort(maisBreve,Lvis,LvisOrd),
	deleteAllVisitas,
	assertOrdenado(LvisOrd).


maisBreve(>, visita(_,_,_,_,Dia1,_,_,_,_,_,_),visita(_,_,_,_,Dia2,_,_,_,_,_,_)) :-
        Dia1>Dia2.

maisBreve(<, visita(_,_,_,_,Dia1,_,_,_,_,_,_),visita(_,_,_,_,Dia2,_,_,_,_,_,_)) :-
        Dia1<Dia2.

maisBreve(=, visita(_,_,_,_,Dia1,Inicio1,_,_,_,_,_),visita(_,_,_,_,Dia2,Inicio2,_,_,_,_,_)) :-
        Dia1=Dia2,
	Inicio1=Inicio2.

maisBreve(>, visita(_,_,_,_,Dia1,Inicio1,_,_,_,_,_),visita(_,_,_,_,Dia2,Inicio2,_,_,_,_,_)) :-
        Dia1=Dia2,
	Inicio1>Inicio2.

maisBreve(<, visita(_,_,_,_,Dia1,Inicio1,_,_,_,_,_),visita(_,_,_,_,Dia2,Inicio2,_,_,_,_,_)) :-
        Dia1=Dia2,
	Inicio1<Inicio2.

assertOrdenado([]).

assertOrdenado([H|T]):-
	assertz(H),
	assertOrdenado(T).
