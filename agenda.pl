%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('agenda_semProp.pl').
:-consult('agenda_comProp.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Passar todos id's visitas para uma lista para no fim somente a ultima ter hora regresso

sequenciaVisitas(_,_,[],_,_,_,_,[]).

sequenciaVisitas(Orig,O,[H|[]],IdVend,IdCliente,TVisita,Tipo,[IdVisita|TLvisitas]):-
	Tipo==2,
	verificaCompat(O,H,IdVend,IdCliente,TVisita,Tipo,UltPontoValido,IdVisita),
	writef('UltPontoValido visita -> %w',[UltPontoValido]),nl,
	sequenciaVisitas(Orig,H,[],IdVend,IdCliente,TVisita,Tipo,TLvisitas).

sequenciaVisitas(Orig,O,[H|T],IdVend,IdCliente,TVisita,Tipo,[IdVisita|TLvisitas]):-
	verificaCompat(O,H,IdVend,IdCliente,TVisita,Tipo,UltPontoValido,IdVisita),
	writef('UltPontoValido visita -> %w',[UltPontoValido]),nl,
	sequenciaVisitas(Orig,UltPontoValido,T,IdVend,IdCliente,TVisita,Tipo,TLvisitas).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificaCompat(_,[],_,_,_,_,_,_).

verificaCompat(Orig,Dest,IdVend,IdCliente,TempoVisita,Tipo,UltPontoValido,IdVisita):-
	posseChave(_,Dest),
	nl,nl,
	write('-------------------------------------------------'),
	nl,writef('Vendedor %w tem a chave do imovel %w.',[IdVend,Dest]),nl,
	write('-------------------------------------------------'),nl,nl,
	verificaCompat_semProp(Orig,Dest,IdVend,IdCliente,TempoVisita,Tipo,UltPontoValido,IdVisita).

verificaCompat(Orig,Dest,IdVend,IdCliente,TempoVisita,Tipo,UltPontoValido,IdVisita):-
	nl,nl,
	write('-------------------------------------------------'),
	nl,writef('Vendedor %w nao tem a chave do imovel %w.',[IdVend,Dest]),nl,
	write('-------------------------------------------------'),nl,nl,
	verificaCompat_comProp(Orig,Dest,IdVend,IdCliente,TempoVisita,Tipo,UltPontoValido,IdVisita).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

regressoEscritorio(_,_,0).

regressoEscritorio(Orig,Dest,IdVisita):-
	nl,nl,
	write('-------------------------------------------------'),
	nl,writef('Vendedor regressa ao escritório.'),nl,
	write('-------------------------------------------------'),nl,nl,
	getZonaOrigem(Orig,ZonaOrig),
	getZonaDestino(Dest,ZonaDest),
	getTempoViagem(ZonaOrig,ZonaDest,CamReg,Tviagem),
	nl,
	nl,
	writef('Caminho:            \t%w',[CamReg]),
	nl,
	writef('Tempo Viagem (ida): \t%w minutos',[Tviagem]),
	%%%%%%%%%%%%%
	%update hora regresso ao escritorio
	%%%%%%%%%%%%%
	visita(IdVisita,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,_,CamVisita),
	NovoRegr is Min_f+Tviagem,
	deleteVisita(IdVisita),
	assertz(visita(IdVisita,IdVend,Imovel,IdCli,Dia,Min_i,Min_f,IniViag,DurViag,NovoRegr,CamVisita)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

insere(_,_,[],[]).

insere(X,P,L,LR):-
	insere1(X,P,1,L,LR),
	!.

insere1(X,C,C,[H|T],[X|[H|T]]):-%(numProc,posit,cont,listOri,listRet)-ENCONT
	!.

insere1(X,P,C,[H|T],[H|T2]):-%(numProc,posit,cont,listOri,listRet)-NAO ENCONT
	C2 is C+1,
	insere1(X,P,C2,T,T2).
