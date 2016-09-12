%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('cliente.pl').
:-consult('imovel.pl').
:-consult('vendedor.pl').
:-consult('visita.pl').
:-consult('imobiliaria.pl').
:-consult('search_aStar.pl').
:-consult('search_bf.pl').

getListaDisp_Vend(dispVendedor,IdVend,TempoVisita,FimUltVisita,L):-
	getListaDispByTempoVisita(dispVendedor,IdVend,TempoVisita,FimUltVisita,L).

getListaDisp_Cli(dispCliente,IdCli,TempoVisita,FimUltVisita,L):-
	getListaDispByTempoVisita(dispCliente,IdCli,TempoVisita,FimUltVisita,L).

getListaDisp_Prop(dispProprietario,IdProp,TempoVisita,FimUltVisita,L):-
	getListaDispByTempoVisita(dispProprietario,IdProp,TempoVisita,FimUltVisita,L).

getListaDisp_Imovel(dispImovel,IdImovel,TempoVisita,FimUltVisita,L):-
	getListaDispByTempoVisita(dispImovel,IdImovel,TempoVisita,FimUltVisita,L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

listaDeListas(L1,L2,[L1,L2]).
listaDeListas(L1,L2,L3,[L1,L2,L3]).

todasCombListaListas(L,All) :-
	findall(M, iterarListaListas(L,M), All).

iterarListaListas([],[]).

iterarListaListas([L|Ls],[M|Ms]):-
	member(M,L),
	iterarListaListas(Ls,Ms).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getTempoViagem(Orig,Dest,Cam,Tviagem):-
	Limite=80,
	aggregate_all(count, estrada(_,_,_), Nvias),
	aggregate_all(count, zona(_,_), Nzonas),
	writef('Existem %w vias.',[Nvias]),nl,
	writef('Existem %w zonas.',[Nzonas]),nl,
	writef('IF   numero vias =< %w e numero zonas =< %w ',[Limite,Limite]),nl,
	write('     -> metodo pesquisa: aStar '),nl,
	write('ELSE -> metodo pesquisa: best first '),nl,
	Nvias =< Limite,
	Nzonas =< Limite,
	!,
	aStar(Orig,Dest,Cam,Tviagem).

getTempoViagem(Orig,Dest,Cam,Tviagem):-
	bestFirst(Orig,Dest,Cam,Tviagem).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita)

caso1: o tempo compat suficiente para as viagens
getTempoViagemVendedor_caso1(100,200,50,250,20,2,40,InicioIda,InicioVisita).

caso2: usar tempo antes compat para viagens (mais algum compat)
getTempoViagemVendedor_caso2(100,200,50,250,50,2,50,InicioIda,InicioVisita).

caso3: usar tempo depois compat para viagens (mais algum compat)
getTempoViagemVendedor_caso3(100,210,50,300,50,2,60,InicioIda,InicioVisita).

caso4: caso2+caso3
getTempoViagemVendedor_caso4(100,200,50,250,100,2,50,InicioIda,InicioVisita).

*/

getTempoViagemVendedor_caso1(Min_i,Min_f,_,_,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	TCompat is (Min_f-Min_i),
	TviagemTot is (Tviagem*Tipo),%tipo =1 (aberto) ou 2 (fechado)
	TviagemMaisVisita is (TviagemTot+TVisita),
	TCompat >= (TviagemMaisVisita),
	!,
	InicioIda is Min_i,
	InicioVisita is (InicioIda+Tviagem),
	nl,
	nl,
	writef('\tO tempo de compatibilidade %w - %w é suficiente para viagens e visita. ',[Min_i,Min_f]),
	printTemposVisitaViagem(TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso1(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	getTempoViagemVendedor_caso2(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso2(Min_i,Min_f,M_iniV,_,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	TCompat is (Min_f-Min_i),
	TAntesTCompat is (Min_i-M_iniV),
	%TDepoisTCompat is (M_fimV-Min_f),
	TviagemTot is (Tviagem*Tipo),%tipo =1 (aberto) ou 2 (fechado)
	TviagemMaisVisita is (TviagemTot+TVisita),
	(TAntesTCompat+TCompat) >= TviagemMaisVisita,
	TviagemRetorno is (Tviagem * (Tipo-1)),%=TviagemRetorno ou zero (se circuito aberto)
	InicioViagRet is (Min_f-TviagemRetorno),
	InicioVisita is (InicioViagRet-TVisita),
	InicioVisita >= Min_i,
	!,
	InicioIda is (InicioVisita-Tviagem),
	nl,
	nl,
	writef('\tNecessário usar tempo disponivel do vendedor antes do tempo de compatibilidade.'),
	printTemposVisitaViagem(TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso2(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	getTempoViagemVendedor_caso3(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso3(Min_i,Min_f,_,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	TCompat is (Min_f-Min_i),
	TDepoisTCompat is (M_fimV-Min_f),
	TviagemTot is (Tviagem*Tipo),%tipo =1 (aberto) ou 2 (fechado)
	TviagemMaisVisita is (TviagemTot+TVisita),
	(TCompat+TDepoisTCompat) >= TviagemMaisVisita,
	TviagemRetorno is (Tviagem * (Tipo-1)),%=TviagemRetorno ou zero (se circuito aberto)
	InicioIda is Min_i,
	InicioVisita is (InicioIda+Tviagem),
	FimVisita is (InicioVisita+TVisita),
	FimVisita =< Min_f,
	FimViagemRetorno is (FimVisita+TviagemRetorno),
	FimViagemRetorno =< M_fimV,
	!,
	nl,
	nl,
	writef('\tNecessário usar tempo disponivel do vendedor depois do tempo de compatibilidade.'),
	printTemposVisitaViagem(TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso3(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	getTempoViagemVendedor_caso4(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso4(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	LimSupIniVisita is (Min_f-TVisita),
	Iteracoes is (LimSupIniVisita-Min_i),
	getTempoViagemVendedor_caso41(0,Iteracoes,Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita),
	nl,
	nl,
	writef('\tNecessário usar tempo disponivel do vendedor antes e depois do tempo de compatibilidade.'),
	printTemposVisitaViagem(TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

getTempoViagemVendedor_caso4(_,_,_,_,_,_,_,_,_):-
	nl,nl,nl,
	writef('\tNao existe tempo para vendedor realizar viagens e visita.'),
	nl,
	false.

getTempoViagemVendedor_caso41(Cont,Iteracoes,_,_,_,_,_,_,_,0,0):-
	Cont > Iteracoes,
	!.

getTempoViagemVendedor_caso41(Cont,Iteracoes,Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	Cont =< Iteracoes,
	InicioVisita is (Min_i+Cont),
	InicioIda is (InicioVisita-Tviagem),
	InicioIda >= M_iniV,
	FimVisita is (InicioVisita+TVisita),
	FimVisita =< Min_f,
	TviagemRetorno is (Tviagem * (Tipo-1)),%=TviagemRetorno ou zero (se circuito aberto)
	FimViagemRetorno  is (FimVisita+TviagemRetorno),
	FimViagemRetorno =< M_fimV,
	!.

getTempoViagemVendedor_caso41(Cont,Iteracoes,Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	Cont =< Iteracoes,
	!,
	Cont2 is Cont+1,
	getTempoViagemVendedor_caso41(Cont2,Iteracoes,Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printTemposVisitaViagem(TVisita,Tipo,Tviagem,InicioIda,InicioVisita):-
	nl,
	nl,
	writef('\tTempo Visita:	                 %w minutos',[TVisita]),
	nl,
	writef('\tTipo (1=aberto; 2=fechado):    %w',[Tipo]),
	nl,
	writef('\tTempo Viagem:                  %w minutos',[Tviagem]),
	nl,
	writef('\tInicio viagem ida:             %w minutos',[InicioIda]),
	nl,
	writef('\tInicio visita:                 %w minutos',[InicioVisita]),
	nl.
