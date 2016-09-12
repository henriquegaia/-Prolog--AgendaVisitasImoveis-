%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('agenda_comum.pl').

verificaCompat_semProp(Orig,Dest,IdVend,IdCliente,TVisita,Tipo,UltPontoValido,IdVisita):-
	getZonaOrigem(Orig,ZonaOrig),
	getZonaDestino(Dest,ZonaDest),
	getTempoViagem(ZonaOrig,ZonaDest,Cam,Tviagem),
	nl,
	nl,
	writef('Caminho:            \t%w',[Cam]),
	nl,
	writef('Tempo Viagem (ida): \t%w minutos',[Tviagem]),
	nl,
	writef('Verificar se vendedor tem %w minutos de disponibilidade ...',[TVisita]),
	nl,
	getFimUltimaVisita(FimUltVisita),
	getListaDisp_Vend(dispVendedor,IdVend,TVisita,FimUltVisita,L_disp_vend),
	writef('Verificar se cliente tem %w minutos de disponibilidade ...',[TVisita]),
	nl,
	getListaDisp_Cli(dispCliente,IdCliente,TVisita,FimUltVisita,L_disp_cli),
	nl,
	writef('Verificar compatibilidades entre vendedor e cliente ...'),
	nl,
	verificaCompat_Vend_Cli(L_disp_vend,L_disp_cli,L),
	nl,
	nl,
	write('Combinacoes de disponibilidades [IdDispVend,IdDispCli]: '),
	nl,
	write(L),
	nl,
	printCombinacoes_semProp(L),
	nl,
	nl,
	write('Comparar os elementos em cada combinacao de disponibilidades... '),
	nl,
	nl,
	getCompat_semProp(L,TVisita,L_compat),
	write('Combinacoes Validas [(IdDispVen,IdDispCli,Ini,Fim)]:     '), write(L_compat),
	nl,
	tuploIdDispToTuploTempo_semProp(L_compat,L_tup_tempo),
	write('Combinacoes Validas [(Dia,Ini,Fim,IdDispVen,IdDispCli)]: '), write(L_tup_tempo),
	nl,
	nl,
	write('Verificar se existe tempo para vendedor fazer viagem ... '),
	nl,
	nl,
	verificaSeHaTempoViagensVendedor_semProp(L_tup_tempo,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L_tup_tempo_viagens),
	nl,
	nl,
	getPrimeiraDisp_semProp(L_tup_tempo_viagens,R),
	write('(Dia, Inicio (min), Fim (min), IdDispVen,IdDispCli) mais breve para visita:    '), write(R),
	nl,
	nl,
	write('Agendar Visita ...'),
	nl,
	nl,
	agendarVisita_semProp(R,Orig,Dest,InicioIda,InicioVisita,Tviagem,TVisita,Tipo,Cam,UltPontoValido,IdVisita),
	nl,
	nl.

verificaCompat_semProp(_,_,_,_,_,_,_,_):-
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificaCompat_Vend_Cli(L_disp_vend,L_disp_cli,L_result):-
	listaDeListas(L_disp_vend,L_disp_cli,L3),
	todasCombListaListas(L3,L_result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printCombinacoes_semProp([]).

printCombinacoes_semProp([[IdDispVen,IdDispCli]|T]):-
	dispVendedor(_,IdDispVen,D,Mi,Mf),
	dispCliente(_,IdDispCli,D2,Mi2,Mf2),
	nl,
	writef('entidade:     dia -> Inicio - Fim (minutos)'),nl,nl,
	writef('Vendedor:     %w  -> %w     - %w',[D,Mi,Mf]),nl,
	writef('Cliente:      %w  -> %w     - %w',[D2,Mi2,Mf2]),nl,
	printCombinacoes_semProp(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getCompat_semProp([],_,[]).

getCompat_semProp([[IdDispVen,IdDispCli]|T],TempoVis,[(IdDispVen,IdDispCli,M_Inicio,M_Fim)|T2]):-
	dispVendedor(_,IdDispVen,D,Mi,Mf),
	dispCliente(_,IdDispCli,D2,Mi2,Mf2),
	validaDiaVisita(D,D2),
	getSobreposicaoMins(Mi,Mf,Mi2,Mf2,TempoVis,M_Inicio,M_Fim),
	!,
	getCompat_semProp(T,TempoVis,T2).

getCompat_semProp([_|T],TempoVis,L_compat):-
	getCompat_semProp(T,TempoVis,L_compat).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tuploIdDispToTuploTempo_semProp([],[]).

tuploIdDispToTuploTempo_semProp([(IdDispVend,IdDispCli,Min_i,Min_f)|T],[(D,Min_i,Min_f,IdDispVend,IdDispCli)|T2]):-
	dispVendedor(_,IdDispVend,D,_,_),
	tuploIdDispToTuploTempo_semProp(T,T2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificaSeHaTempoViagensVendedor_semProp([],_,_,_,_,_,[]).

verificaSeHaTempoViagensVendedor_semProp([(D,Min_i,Min_f,IdDispVend,IdDispCli)|T],TVisita,Tipo,Tviagem,InicioIda,InicioVisita,[(D,Min_i,Min_f,IdDispVend,IdDispCli)|T2]):-
	dispVendedor(_,IdDispVend,_,M_iniV,M_fimV),
	nl,
	writef('Intervalo Compatibilidade entre entidades:            %w - %w',[Min_i,Min_f]),
	nl,
	writef('Intervalo disponivel Vendedor antes compatibilidade:  %w - %w',[M_iniV,Min_i]),
	nl,
	writef('Intervalo disponivel Vendedor depois compatibilidade: %w - %w',[Min_f,Min_f]),
	getTempoViagemVendedor_caso1(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita),
	verificaSeHaTempoViagensVendedor_comProp(T,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,T2).

verificaSeHaTempoViagensVendedor_semProp([_|T],TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L2):-
	verificaSeHaTempoViagensVendedor_comProp(T,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getPrimeiraDisp_semProp([],(0,0,0,0,0)).

getPrimeiraDisp_semProp(L,(D,Min_i,Min_f,IdDispVend,IdDispCli)):-
	sort(L,Lsorted),
	getPrimeiraDisp2_semProp(Lsorted,(D,Min_i,Min_f,IdDispVend,IdDispCli)).

getPrimeiraDisp2_semProp([(D,Min_i,Min_f,IdDispVend,IdDispCli)|_],(D,Min_i,Min_f,IdDispVend,IdDispCli)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agendarVisita_semProp((0,_,_,_,_),Orig,_,_,_,_,_,_,_,Orig,0):-
	write('\tNao é possivel agendar visita.'),
	nl,nl.

agendarVisita_semProp((D,_,_,IdDispVend,IdDispCli),_,Dest,InicioIda,InicioVisita,Tviagem,TVisita,Tipo,Cam,Dest,IdVisita):-
	writef('\tDia:                     %w',[D]),nl,
	TviagemRetorno is (Tviagem * (Tipo-1)),
	writef('\tInicio Viagem Vendedor:  %w',[InicioIda]),nl,
	writef('\tDuracao Viagem Vendedor: %w',[Tviagem]),nl,
	writef('\tInicio Visita:           %w',[InicioVisita]),nl,
	writef('\tDuracao Visita:          %w',[TVisita]),nl,
	writef('\tDuracao Viagem Retorno:  %w',[TviagemRetorno]),nl,
	FimVisita is InicioVisita+TVisita,
	Regresso is ((FimVisita+TviagemRetorno)*(Tipo-1)),
	dispVendedor(IdVend,IdDispVend,_,_,_),
	dispCliente(IdCli,IdDispCli,_,_,_),
	updateDispVendedor(IdDispVend,InicioIda,Tviagem,FimVisita,Tipo),
	updateDispCliente(IdDispCli,InicioVisita,FimVisita),
	updateDispImovel_semProp(Dest,D,InicioVisita,FimVisita),
	novaVisita(IdVend,Dest,IdCli,D,InicioVisita,FimVisita,InicioIda,Tviagem,Regresso,Cam),
	visita(IdVisita,IdVend,Dest,IdCli,D,InicioVisita,FimVisita,InicioIda,Tviagem,Regresso,Cam).

