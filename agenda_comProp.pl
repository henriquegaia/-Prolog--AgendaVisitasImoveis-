%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('agenda_comum.pl').

verificaCompat_comProp(Orig,Dest,IdVend,IdCliente,TVisita,Tipo,UltPontoValido,IdVisita):-
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
	writef('Verificar se proprietario tem %w minutos de disponibilidade ...',[TVisita]),
	nl,
	getListaDisp_Imovel(dispImovel,Dest,TVisita,FimUltVisita,L_disp_imovel),
	writef('Verificar compatibilidades entre vendedor, cliente e proprietario ...'),
	nl,
	verificaCompat_Vend_Cli_Prop(L_disp_vend,L_disp_cli,L_disp_imovel,L),
	nl,
	nl,
	write('Combinacoes de disponibilidades [IdDispVend,IdDispCli,IdDispImovel]: '),
	nl,
	write(L),
	nl,
	printCombinacoes_comProp(L),
	nl,
	nl,
	write('Comparar os elementos em cada combinacao de disponibilidades... '),
	nl,
	nl,
	getCompat_comProp(L,TVisita,L_compat),
	write('Combinacoes Validas [(IdDispVen,IdDispCli,IdDispImovel,Ini,Fim)]:     '), write(L_compat),
	nl,
	tuploIdDispToTuploTempo_comProp(L_compat,L_tup_tempo),
	write('Combinacoes Validas [(Dia,Ini,Fim,IdDispVen,IdDispCli,IdDispImovel)]: '), write(L_tup_tempo),
	nl,
	nl,
	write('Verificar se existe tempo para vendedor fazer viagem ... '),
	nl,
	nl,
	verificaSeHaTempoViagensVendedor_comProp(L_tup_tempo,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L_tup_tempo_viagens),
	nl,
	nl,
	getPrimeiraDisp_comProp(L_tup_tempo_viagens,R),
	write('(Dia, Inicio (min), Fim (min), IdDispVen,IdDispCli, IdDispImo)  mais breve para visita:    '), write(R),
	nl,
	nl,
	write('Agendar Visita ...'),
	nl,
	nl,
	agendarVisita_comProp(R,Orig,Dest,InicioIda,InicioVisita,Tviagem,TVisita,Tipo,Cam,UltPontoValido,IdVisita),
	nl,
	nl.


verificaCompat_comProp(_,_,_,_,_,_,_,_):-
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificaCompat_Vend_Cli_Prop(L_disp_vend,L_disp_cli,L_disp_imovel,L_result):-
	listaDeListas(L_disp_vend,L_disp_cli,L_disp_imovel,L4),
	todasCombListaListas(L4,L_result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printCombinacoes_comProp([]).

printCombinacoes_comProp([[IdDispVen,IdDispCli,IdDispImovel]|T]):-
	dispVendedor(_,IdDispVen,D,Mi,Mf),
	dispCliente(_,IdDispCli,D2,Mi2,Mf2),
	dispImovel(_,IdDispImovel,D3,Mi3,Mf3),
	nl,
	writef('entidade:     dia -> Inicio - Fim (minutos)'),nl,nl,
	writef('Vendedor:     %w  -> %w     - %w',[D,Mi,Mf]),nl,
	writef('Cliente:      %w  -> %w     - %w',[D2,Mi2,Mf2]),nl,
	writef('Imovel:	      %w  -> %w     - %w',[D3,Mi3,Mf3]),nl,nl,
	printCombinacoes_comProp(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*Exemplo
Tempo=20
criaDisp_vendedor    (1,2016,12,3,600,700),
criaDisp_Cliente     (2,2016,12,3,660,710),...660-700
criaDisp_proprietario(4,2016,12,3,690,730)....690-700->false
*/

getCompat_comProp([],_,[]).

getCompat_comProp([[IdDispVen,IdDispCli,IdDispImovel]|T],TempoVis,[(IdDispVen,IdDispCli,IdDispImovel,M_Inicio,M_Fim)|T2]):-
	dispVendedor(_,IdDispVen,D,Mi,Mf),
	dispCliente(_,IdDispCli,D2,Mi2,Mf2),
	dispImovel(_,IdDispImovel,D3,Mi3,Mf3),
	validaDiaVisita(D,D2,D3),
	getSobreposicaoMins(Mi,Mf,Mi2,Mf2,TempoVis,X,Y),
	getSobreposicaoMins(X,Y,Mi3,Mf3,TempoVis,M_Inicio,M_Fim),
	!,
	getCompat_comProp(T,TempoVis,T2).

getCompat_comProp([_|T],TempoVis,L_compat):-
	getCompat_comProp(T,TempoVis,L_compat).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*exemplo
tuploIdDispToTuploTempo([(1,2,6,690,700)],L).
L = [ (2016, 12, 3, 690, 700)].
*/
tuploIdDispToTuploTempo_comProp([],[]).

tuploIdDispToTuploTempo_comProp([(IdDispVend,IdDispCli,IdDispImo,Min_i,Min_f)|T],[(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)|T2]):-
	dispVendedor(_,IdDispVend,D,_,_),
	tuploIdDispToTuploTempo_comProp(T,T2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificaSeHaTempoViagensVendedor_comProp([],_,_,_,_,_,[]).

verificaSeHaTempoViagensVendedor_comProp([(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)|T],TVisita,Tipo,Tviagem,InicioIda,InicioVisita,[(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)|T2]):-
	dispVendedor(_,IdDispVend,_,M_iniV,M_fimV),
	nl,
	writef('Intervalo Compatibilidade entre entidades:            %w - %w',[Min_i,Min_f]),
	nl,
	writef('Intervalo disponivel Vendedor antes compatibilidade:  %w - %w',[M_iniV,Min_i]),
	nl,
	writef('Intervalo disponivel Vendedor depois compatibilidade: %w - %w',[Min_f,Min_f]),
	getTempoViagemVendedor_caso1(Min_i,Min_f,M_iniV,M_fimV,TVisita,Tipo,Tviagem,InicioIda,InicioVisita),
	verificaSeHaTempoViagensVendedor_comProp(T,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,T2).

verificaSeHaTempoViagensVendedor_comProp([_|T],TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L2):-
	verificaSeHaTempoViagensVendedor_comProp(T,TVisita,Tipo,Tviagem,InicioIda,InicioVisita,L2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*exemplo
getPrimeiraDisp([(2016, 12, 3, 690, 700),(2016, 12, 3, 500, 600)],R).
R = (2016, 12, 3, 500, 600).
*/

getPrimeiraDisp_comProp([],(0,0,0,0,0,0)).

getPrimeiraDisp_comProp(L,(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)):-
	sort(L,Lsorted),
	getPrimeiraDisp2_comProp(Lsorted,(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)).

getPrimeiraDisp2_comProp([(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)|_],(D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%R=(A,M,D,Min_i,Min_f,IdDispVend,IdDispCli,IdDispImo)

agendarVisita_comProp((0,_,_,_,_,_),Orig,_,_,_,_,_,_,_,Orig,0):-
	write('\tNao ? possivel agendar visita.'),
	nl,nl.

agendarVisita_comProp((D,_,_,IdDispVend,IdDispCli,IdDispImo),_,Dest,InicioIda,InicioVisita,Tviagem,TVisita,Tipo,Cam,Dest,IdVisita):-
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
	updateDispImovel(IdDispImo,InicioVisita,FimVisita),
	novaVisita(IdVend,Dest,IdCli,D,InicioVisita,FimVisita,InicioIda,Tviagem,Regresso,Cam),
	visita(IdVisita,IdVend,Dest,IdCli,D,InicioVisita,FimVisita,InicioIda,Tviagem,Regresso,Cam).
