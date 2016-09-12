%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('agenda.pl').

menu:-
	printMenu,
	read_opcao(_).

printMenu:-
	write('-----------------------------'),nl,
	write('------------ MENU -----------'),nl,
	write('-----------------------------'),nl,nl,

	%VISITA
	write('1-Visita ->	    adicionar'),nl,nl,
	%IMOVEL
	write('2-Imovel ->         adicionar'),nl,
	write('3-Imovel ->         adicionar disponibilidade'),nl,
	write('4-Imovel ->         remover  disponibilidade'),nl,nl,
	%CLIENTE
	write('5-Clientes ->       adicionar'),nl,
	write('6-Clientes ->       remover'),nl,
	write('7-Clientes ->       adicionar disponibilidade'),nl,
	write('8-Clientes ->       remover  disponibilidade'),nl,nl,
	%VENDEDOR
	write('9-Vendedores ->     adicionar'),nl,
	write('10-Vendedores ->    remover'),nl,
	write('11-Vendedores ->    adicionar disponibilidade'),nl,
	write('12-Vendedores ->    remover  disponibilidade'),nl,
	write('13-Vendedores ->    obter chave'),nl,nl,

	write('14-Terminar'),nl,nl,
	nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

action(1):-adicionarVisita.

action(2):-adicionarImovel.
action(3):-adicionaDispImovel.
action(4):-eliminaDispImovel.

action(5):-adicionaCliente.
action(6):-eliminaCliente.
action(7):-adicionaDispCliente.
action(8):-eliminaDispCliente.

action(9):-adicionaVendedor.
action(10):-eliminaVendedor.
action(11):-adicionaDispVendedor.
action(12):-eliminaDispVend.
action(13):-adicionarPosseChave.

action(14):-abort.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1
adicionarVisita:-
	%%%%%%%%%%%%%%%%%% Testes %%%%%%%%%%%%%%%
	/*
	Orig=esc,
	LDests=[i1001],
	IdVend=m1001,
	IdCli=c1001,
	TempoVisita=10,
	Tipo=2,
	*/
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	read_dados(Orig,LDests,IdVend,IdCli,TempoVisita,Tipo),
	sequenciaVisitas(Orig,Orig,LDests,IdVend,IdCli,TempoVisita,Tipo,Lids),
	getUltPtVisitaEImovel(Lids,UltIdVisita,ImovelVisitado),
	regressoEscritorio(ImovelVisitado,Orig,UltIdVisita),
	eliminaRegressosVisitas(Tipo,Lids).


%2
adicionarImovel:-
	read_novoImovel(Id),
	read_zona(Zona),
	criaImovel(Id,Zona).

%3
adicionaDispImovel:-
	read_idImovel(IdImovel),
	read_dia(Dia),
	read_inicioDisp(Inicio_M),
	read_fimDisp(Inicio_M,Fim_M),
	criaDisp_Min(dispImovel,IdImovel,Dia,Inicio_M,Fim_M).


%4
eliminaDispImovel:-
	read_disp(dispImovel,IdDisp),
	deleteDispImovelById(IdDisp).

%5
adicionaCliente:-
	write('Nome do novo cliente > '),
	read(Nome),
	novoCliente(Nome).

%6
eliminaCliente:-
	read_idCliente(IdCli),
	deleteClienteById(IdCli),
	deleteVisitasByCliId(IdCli).

%7
adicionaDispCliente:-
	read_idCliente(IdCli),
	read_dia(Dia),
	read_inicioDisp(Inicio_M),
	read_fimDisp(Inicio_M,Fim_M),
	criaDisp_Min(dispCliente,IdCli,Dia,Inicio_M,Fim_M).

%8
eliminaDispCliente:-
	read_disp(dispCliente,IdDisp),
	deleteDispCliById(IdDisp).

%9
adicionaVendedor:-
	write('Nome do novo vendedor > '),
	read(Nome),
	novoVendedor(Nome).

%10
eliminaVendedor:-
	read_idVendedor(IdVend),
	deleteVendedorById(IdVend),
	deleteVisitasByVendId(IdVend).

%11
adicionaDispVendedor:-
	read_idVendedor(IdVend),
	read_dia(Dia),
	read_inicioDisp(Inicio_M),
	read_fimDisp(Inicio_M,Fim_M),
	criaDisp_Min(dispVendedor,IdVend,Dia,Inicio_M,Fim_M).


%12
eliminaDispVend:-
	read_disp(dispVendedor,IdDisp),
	deleteDispVendById(IdDisp).


%13
adicionarPosseChave:-
	read_novaPosseChave(Nome),
	obterChave(Nome).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(Conditions -> ActionIfTrue ; ActionIfFalse)

read_dados(Origem,LDestinos,IdVend,IdCli,TempoVisita,Tipo):-
	read_origem(Origem),
	read_destinos(Origem,LDestinos),
	read_idVendedor(IdVend),
	read_idCliente(IdCli),
	read_tipo(Tipo),
	read_tempoVisita(TempoVisita).

read_dados_2(Origem,[PrimeiraVisita|_],IdVend,TempoVisita,Tipo):-
	read_origem2(PrimeiraVisita,Origem),
	read_idVendedor(IdVend),
	read_tipo(Tipo),
	read_tempoVisita(TempoVisita).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_opcao(Opcao):-

    write('Introduzir opcao > '),
    read(Tmp),
    ((
	integer(Tmp),
	( Tmp>0,Tmp=<14)
    )  ->
        (Opcao = Tmp, action(Opcao)) ;
        (write('Error!'),
	 nl,
	 read_opcao(Opcao))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_idImovel(IdImovel):-
	getAllImoveis(Limoveis),
	writef('Id Imovel %w >',[Limoveis]),
	read(Tmp),
	((
	    member(Tmp,Limoveis)
	)  ->
	( IdImovel = Tmp) ;
	(write('Erro!'),
	 nl,
	read_idImovel(IdImovel))
    ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_origem(Origem):-
	getAllImoveis(Limoveis),
	writef('Origem %w >',[Limoveis]),
	read(Tmp),
	((
	    member(Tmp,Limoveis)
	)  ->
	( Origem = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_origem(Origem))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_origem2(PrimeiraVisita,Origem):-
	getAllImoveis(Limoveis),
	writef('Origem %w >',[Limoveis]),
	read(Tmp),
	((
	    member(Tmp,Limoveis),
	    not(Tmp == PrimeiraVisita)
	)  ->
	( Origem = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_origem(Origem))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_idPlanoVisitas(Id):-
	getAllIdPlanoVisitas(L),
	writef('Id plano visitas em ficheio por agendar %w) > ',[L]),
	read(Tmp),
	((
	    member(Tmp,L)
	)  ->
	( Id = Tmp) ;
	(write('Erro! Zona inexistente.'),
	 nl,
	 read_idPlanoVisitas(Id))
    ).

read_zona(Zona):-
	getAllZonas(Lzonas),
	writef('Id zona %w) > ',[Lzonas]),
	read(Tmp),
	((
	    member(Tmp,Lzonas)
	)  ->
	( Zona = Tmp) ;
	(write('Erro! Zona inexistente.'),
	 nl,
	 read_zona(Zona))
    ).

read_destinos(Origem,[Destino|L]):-
	read_destino(Origem,Destino),
	Destino \== 'stop',
	read_destinos(Origem,L).

read_destinos(_,[]).


read_destino(Origem,Destino):-
	getAllImoveis(Limoveis),
	writef('Destino %w (stop para parar) >',[Limoveis]),
	read(Tmp),
	((
	    ((Tmp == 'stop');
	    (not(Tmp == Origem),
	    member(Tmp,Limoveis))
	)
	)  ->
	( Destino = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_destino(Origem,Destino))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_novoImovel(Nome):-
	getAllImoveis(Limoveis),
	writef('Nome novo imovel (nomes já existentes: %w) > ',[Limoveis]),
	read(Tmp),
	((
	    \+member(Tmp,Limoveis)

	)  ->
	( Nome = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_novoImovel(Nome))
    ).

read_novaPosseChave(Nome):-
	getAllImoveisPosseChave(LimoveisPosse),
	getAllImoveis(Limoveis),
	writef('Nome imovel %w) > ',[Limoveis]),
	read(Tmp),
	((
	    member(Tmp,Limoveis),
	    \+member(Tmp,LimoveisPosse)

	)  ->
	( Nome = Tmp) ;
	(write('Erro! Imovel inexistente ou posse chave já existe.'),
	 nl,
	 read_novaPosseChave(Nome))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_coordenada(Texto,C):-
    writef('Coordenada eixo %w > ',[Texto]),
    read(Tmp),
    ((
	integer(Tmp),
	( Tmp>=0)
    )  ->
        (C = Tmp) ;
        (write('Erro!'),
	 nl,
	 read_coordenada(Texto,C))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_idVendedor(IdVend):-
	read_idEntidade(vendedor,'Vendedor',IdVend).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_idCliente(IdCli):-
	read_idEntidade(cliente,'Cliente',IdCli).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_idEntidade(Pc,Texto,Id):-
	getAllId(Pc,L),
	writef('%w Id %w > ',[Texto,L]),
	read(Tmp),
	((
	    Pred=..[Pc,Tmp,_],
	    Pred
	)  ->
	( Id = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_idEntidade(Pc,Texto,Id))
    ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_tipo(Tipo):-
    write('Tipo (1=aberto, 2=fechado) > '),
    read(Tmp),
    ((
	integer(Tmp),
	( Tmp==1;Tmp==2)
    )  ->
        (Tipo = Tmp) ;
        (write('Erro!'),
	 nl,
	 read_tipo(Tipo))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_tempoVisita(T):-
    write('Tempo Visita > '),
    read(Tmp),
    ((
	integer(Tmp),
	( Tmp>0)
    )  ->
        (T = Tmp) ;
        (write('Erro!'),
	 nl,
	 read_tempoVisita(T))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_disp(Pd,IdDisp):-
    getAllDispId(Pd,L),
    writef('id disponibilidade %w > ',[L]),
    read(Tmp),
    ((
	member(Tmp,L)
    )  ->
        (IdDisp = Tmp) ;
        (write('Erro!'),
	 nl,
	 read_disp(Pd,IdDisp))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_dia(Dia):-
	write('Dia [1-7] > '),
	read(Tmp),
	((
	    integer(Tmp),
	    ( Tmp>0, Tmp <8)
	)  ->
	(Dia = Tmp) ;
	(write('Erro!'),
	 nl,
	 read_dia(Dia))
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_inicioDisp(Inicio_M):-
	write('Inicio \'HH:MM\' (entre plicas) > '),
	read(Tmp),
	((
	    horasParaMinutos(Tmp,Tmp2)
	)  ->
	(Inicio_M=Tmp2) ;
	(write('Erro!'),
	 nl,
	 read_inicioDisp(Inicio_M))
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_fimDisp(Inicio_M,Fim_M):-
	write('Fim \'HH:MM\' (entre plicas) > '),
	read(Tmp),
	((
	    horasParaMinutos(Tmp,Tmp2),
	    Tmp2>Inicio_M
	)  ->
	(Fim_M = Tmp2) ;
	(write('Erro!'),
	 nl,
	 read_fimDisp(Inicio_M,Fim_M))
    ).



