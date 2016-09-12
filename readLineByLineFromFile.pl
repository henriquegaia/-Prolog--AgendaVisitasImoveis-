%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-use_module(library(readutil)).

read_file:-
    read_nomeFicheiro(FileName),
    open(FileName, read, Str),
    read_file2(Str,''),
    close(Str).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read_file2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_file2(Stream,_) :-
    at_end_of_stream(Stream),!,
	writeln(bye).

read_file2(Stream,Status) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Chars),
	name(Line,Chars),
	parse_line(Line,Status,NewStatus),
	read_file2(Stream,NewStatus).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parse_line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_line('%#Imoveis',_,imovel):-!,
	writeln(imovel).

parse_line('%#Cliente',_,cliente):-!,
	writeln(cliente).

parse_line('%#Relacao entre clientes e imoveis a visitar',_,cliente_imovel):-!,
	writeln(cliente_imovel).

parse_line('%#Mediador',_,mediador):-!,
	writeln(mediador).

parse_line(Line,imovel,imovel):-
	!,
	writeln(Line),
	split_string(Line,",","",Dados),
	inserirImovel(Dados).

parse_line(Line,cliente,cliente):-
	!,
	writeln(Line),
	split_string(Line,",","",Dados),
	inserirEntidade(cliente,dispCliente,Dados).

parse_line(Line,cliente_imovel,cliente_imovel):-
	!,
	writeln(Line),
	split_string(Line,",","",Dados),
	inserirPlanoVisitas(Dados).

parse_line(Line,mediador,mediador):-
	!,
	writeln(Line),
	split_string(Line,",","",Dados),
	inserirEntidade(vendedor,dispVendedor,Dados).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clientes e mediadores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inserirEntidade(Pc,Pd,[Id|[Nome|ListaDisps]]):-
	normalize_space(atom(Id_norm),Id),
	normalize_space(atom(Nome_norm),Nome),
	Pred=..[Pc,Id_norm,Nome_norm],
	assertz(Pred),
	inserirDispsEntidade(_,Pd,Id_norm,ListaDisps).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Imovel e proprietarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inserirImovel([IdImovel|[Zona,_,_,DispChave|ListaDisps]]):-
	normalize_space(atom(IdImovel_norm),IdImovel),
	normalize_space(atom(Zona_norm),Zona),
	normalize_space(atom(DispChave_norm),DispChave),
	verificaExistenciaImovel(IdImovel_norm,Zona_norm,DispChave_norm,ListaDisps).

inserirImovel([_|[_,_,_,_|_]]):-
	writef('ERRO: inserirImovel'),nl,nl.


verificaExistenciaImovel(IdImovel_norm,Zona_norm,DispChave_norm,ListaDisps):-
	getIdZonaByNome(Zona_norm,IdZona),
	imovel(IdImovel_norm,IdZona),
	!,
	inserirImovel_Chave(IdImovel_norm,DispChave_norm,ListaDisps).

verificaExistenciaImovel(IdImovel_norm,Zona_norm,DispChave_norm,ListaDisps):-
	getIdZonaByNome(Zona_norm,IdZona),
	assertz(imovel(IdImovel_norm,IdZona)),
	!,
	inserirImovel_Chave(IdImovel_norm,DispChave_norm,ListaDisps).


%imobiliaria nao tem chave
inserirImovel_Chave(IdImovel,'n',ListaDisps):-
	inserirDispsEntidade(imovel,dispImovel,IdImovel,ListaDisps).

%imobiliaria tem chave
inserirImovel_Chave(IdImovel,_,ListaDisps):-
	obterChave(IdImovel),
	inserirDispsEntidade(imovel,dispImovel,IdImovel,ListaDisps).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plano Visitas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inserirPlanoVisitas([_|_]).
inserirPlanoVisitas([IdCli|Lista]):-
	writef('%w-%w',[IdCli,Lista]),nl,
	novoPlanoVisitas(IdCli,Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Predicados comuns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inserirDispsEntidade(_,_,_,[]).

inserirDispsEntidade(_,Pd,Id,[Dia,Inicio,Fim|T]):-
	getDia(Dia,D),
	getIni(Inicio,I),
	getFim(Fim,F),

	text_to_string(I,I_string),
	horasParaMinutos(I_string,I_min),

	text_to_string(F,F_string),
	horasParaMinutos(F_string,F_min),

	getUltimoIdDisp(Pd,LastId),
	ID_Disp is LastId + 1,
	Pred=..[Pd,Id,ID_Disp,D,I_min,F_min],
	assertz(Pred),
	inserirDispsEntidade(_,Pd,Id,T).

getDia(Dia,D):-
	split_string(Dia,"(","",[_,Result]),
	normalize_space(atom(D2),Result),
	atom_number(D2,D).

getIni(Inicio,I):-
	normalize_space(atom(I),Inicio).

getFim(Fim,F):-
	split_string(Fim,")","",[Result,_]),
	normalize_space(atom(F),Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_nomeFicheiro(FileName):-

    write('Introduzir nome ficheiro txt (sem extensao) > '),
    read(Tmp),
    ((
	swritef(Tmp2,'%w.txt',[Tmp]),
	open(Tmp2, read, _)
    )  ->
        (FileName = Tmp2) ;
        (write('Erro!'),
	 nl,
	 read_nomeFicheiro(FileName))
    ).
