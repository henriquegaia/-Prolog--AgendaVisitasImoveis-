%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-consult('entidade').
:-dynamic cliente/2.
:-dynamic dispCliente/5.


geraClientes:-
	novoCliente('Cliente 1'),
	novoCliente('Cliente 2'),
	novoCliente('Cliente 3'),
	novoCliente('Cliente 4').

novoCliente(Nome):-
	novaEntidade(cliente,Nome).

printAllClientes:-
	printAll(cliente,'Clientes').

getAllClientes(L):-
	getAll(cliente,L).

getAllClientesId(L):-
	getAllId(cliente,L).


getNomeClienteById(Id,Nome):-
	getNomeById(cliente,Id,Nome).

deleteAllClientes:-
	deleteAll(cliente).

deleteClienteById(Id):-
	deleteById(cliente,dispCliente,Id).

/**********************************************************
///////////////////////////////////////////////////////////
Disp
///////////////////////////////////////////////////////////
**********************************************************/

geraDisp_Cli:-
	criaDisp_Cliente(1,3,'14:00','15:00'),
	criaDisp_Cliente(2,3,'15:40','17:00'),
	criaDisp_Cliente(3,3,'10:00','12:00'),
	criaDisp_Cliente(2,3,'09:00','11:00'),
	criaDisp_Cliente(3,3,'13:00','18:00'),
	criaDisp_Cliente(4,3,'12:15','14:50').


criaDisp_Cliente(ID_Cli,Dia,H_i,H_f):-
	criaDisp(cliente,dispCliente,ID_Cli,Dia,H_i,H_f).


getAllDisp_Cli(L):-
	getAllDisp(dispCliente,L).

printAllDisp_Cli:-
	printAllDisp(dispCliente,'Clientes').

getDispCliById(ID_Cli,L):-
	getDispById(dispCliente,ID_Cli,L).

deleteAllDisp_Cli:-
	deleteAllDisp(dispCliente).

deleteDispCliById(Id_Disp):-
	deleteDispById(dispCliente,Id_Disp).

updateDispCliente(IdDispC,InicioVisita,FimVisita):-
	updateDisp(cliente,dispCliente,IdDispC,InicioVisita,FimVisita).

organizaDispsCliente:-
	organizaDisps(cliente,dispCliente).
