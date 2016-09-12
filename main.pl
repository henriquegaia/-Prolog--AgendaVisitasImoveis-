%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-consult('menu.pl').
:-consult('readLineByLineFromFile.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% 1ª execução %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run:-
	deleteEntidades,
	deleteDisponibilidades,
	normalizaNomeZonas,
	geraEntidades,
	geraDisponibilidades,
	read_file,
	printDados,
	menu.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% 2ª execução e seguintes %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run2:-
	printDados,
	menu.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delete,Gera e Print
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deleteEntidades:-
	deleteAllVisitasFicheiro,
	deleteAllClientes,
	deleteAllVendedores,
	deleteAllImoveis_semProp.

deleteDisponibilidades:-
	deleteAllDisp_Cli,
	deleteAllDisp_Vend,
	deleteAllDisp_imovel,
	deleteAllPosseChave,
	deleteAllVisitas.


geraEntidades:-
	%geraClientes,
	%geraVendedores,
	%geraImoveis.
	geraImoveis2.

geraDisponibilidades:-
	%geraDisp_Cli,
	%organizaDispsCliente,
	%geraDisp_Vend,
	%organizaDispsVendedor,
	geraPosseChave.
	%geraDisp_Imovel,
	%organizaDispsImovel.


printDados:-
	printAllClientes,
	nl,nl,
	printAllDisp_Cli,
	nl,nl,
	printAllVendedores,
	nl,nl,
	printAllDisp_Vend,
	nl,nl,
	printAllImoveis_semProp,
	nl,nl,
	printAllDisp_imoveis,
	nl,nl,
	printAllPosseChave,
	nl,nl,
	printPlanoVisitasFicheiro,
	nl,nl,
	printAllVisitas,
	nl,nl.
