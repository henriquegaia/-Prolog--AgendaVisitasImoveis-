%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-consult('entidade').
:-dynamic vendedor/2.
:-dynamic dispVendedor/5.

geraVendedores:-
	novoVendedor('Vendedor 1'),
	novoVendedor('Vendedor 2'),
	novoVendedor('Vendedor 3'),
	novoVendedor('Vendedor 4').

novoVendedor(Nome):-
	novaEntidade(vendedor,Nome).

printAllVendedores:-
	printAll(vendedor,'Vendedores').

getAllVendedores(L):-
	getAll(vendedor,L).

getAllVendedoresId(L):-
	getAllId(vendedor,L).

getNomeVendedorById(Id,Nome):-
	getNomeById(vendedor,Id,Nome).

deleteAllVendedores:-
	deleteAll(vendedor).

deleteVendedorById(Id):-
	deleteById(vendedor,dispVendedor,Id).

/**********************************************************
///////////////////////////////////////////////////////////
Disp
///////////////////////////////////////////////////////////
**********************************************************/

geraDisp_Vend:-
	criaDisp_vendedor(1,3,'10:00','18:00'),
	criaDisp_vendedor(2,3,'15:40','17:00'),
	criaDisp_vendedor(3,3,'10:00','12:00'),
	criaDisp_vendedor(2,3,'09:00','11:00'),
	criaDisp_vendedor(3,3,'13:00','18:00'),
	criaDisp_vendedor(4,3,'12:15','14:50').


criaDisp_vendedor(ID_Vend,Dia,H_i,H_f):-
	criaDisp(vendedor,dispVendedor,ID_Vend,Dia,H_i,H_f).


getAllDisp_Vend(L):-
	getAllDisp(dispVendedor,L).

printAllDisp_Vend:-
	printAllDisp(dispVendedor,'Vendedores').

getDispVendById(ID_Vend,L):-
	getDispById(dispVendedor,ID_Vend,L).

deleteAllDisp_Vend:-
	deleteAllDisp(dispVendedor).

deleteDispVendById(Id_Disp):-
	deleteDispById(dispVendedor,Id_Disp).

updateDispVendedor(IdDispV,InicioIda,Tviagem,FimVisita,Tipo):-
	dispVendedor(IdVend,IdDispV,D,Min_i,Min_f),
	TviagemRetorno is (Tviagem * (Tipo-1)),%=TviagemRetorno ou zero (se circuito aberto)
	FimViagemRetorno is (FimVisita + TviagemRetorno),
	NovoInico1 is Min_i,
	NovoFim1 is InicioIda,
	NovoInico2 is FimViagemRetorno,
	NovoFim2 is Min_f,
	criaDisp2(dispVendedor,IdVend,D,NovoInico1,NovoFim1),
	criaDisp2(dispVendedor,IdVend,D,NovoInico2,NovoFim2),
	deleteDispVendById(IdDispV),
	eliminaDispsComInicioEfimIguais(dispVendedor),
	juntaDispsInicioEfimIguais(vendedor,dispVendedor).

organizaDispsVendedor:-
	organizaDisps(vendedor,dispVendedor).
