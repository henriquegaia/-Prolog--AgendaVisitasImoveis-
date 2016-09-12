%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



validaNums(I,F,_):-
	integer(I),
	integer(F),
	F >= I,
	!.

validaNums(_,_,Desc):-
	writef('%w : erro no inicio e/ou fim',[Desc]),nl,
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validaDia(D):-
	integer(D),
	D>0,
	D<8,
	!.

validaDia(_):-
	writef('Dia : erro'),nl,
	false.


validaDia(I,F,Ano_i,Ano_f,Mes_i,Mes_f):-
	Ano_i == Ano_f,
	Mes_i == Mes_f,
	validaNums(I,F,'Dia'),
	limitesDia(I,F).

validaDia(I,F,_,_,_,_):-
	limitesDia(I,F).

validaDia(_,_):-
	writef('Dia : erro'),nl,
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
limitesMins(I,F):-
	I<(60*24),
	F<(60*24),
	!.


validaMins(Min_i,Min_f):-
	integer(Min_i),
	integer(Min_f),
	Min_i<(60*24),
	Min_f<(60*24),
	Min_f>Min_i,
	!.

validaMins(_,_):-
	writef('Minutos : erro'),nl,
	false.


validaMins(I,F,Ano_i,Ano_f,Mes_i,Mes_f,Dia_i,Dia_f):-
	Ano_i == Ano_f,
	Mes_i == Mes_f,
	Dia_i == Dia_f,
	validaNums(I,F,'Minutos'),
	F > I,
	!,
	limitesMins(I,F).

validaMins(I,F,_,_,_,_,_,_):-
	limitesMins(I,F).

validaMins(_,_,_,_,_,_,_,_,_,_):-
	writef('Minutos : erro'),nl,
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getSobreposicaoMins(Min_i1,Min_f1,Min_i2,Min_f2,Tempo,Min_i,Min_f):-
	max(Min_i1,Min_i2,X_i),
	min(Min_f1,Min_f2,Y_f),
	Interval is (Y_f-X_i),
	Tempo =< Interval,
	!,
	Min_i is X_i,
	Min_f is Y_f,
	write('Nova comparacao:'),
	nl,
	writef('\tMin_i1= %w, Min_i2= %w, Maximo dos Minutos iniciais = %w',[Min_i1,Min_i2,X_i]),
	nl,
	writef('\tMin_f1= %w, Min_f2= %w, Minimo dos Minutos finais   = %w',[Min_f1,Min_f2,Y_f]),
	nl,
	writef('\tIntervalo apurado = %w minutos (>= %w)',[Interval,Tempo]),
	nl.


getSobreposicaoMins(_,_,_,_,_,_,_):-
	write('Nova comparacao: intervalo resultante < ao tempo visita !!!'),
	nl,
	false.

validaDiaVisita(Dia_1,Dia_2):-
	Dia_1==Dia_2,
	!.

validaDiaVisita(_,_):-
	write('validacao dia visita : erro'),nl,
	false.

validaDiaVisita(Dia_1,Dia_2,Dia_3):-
	Dia_1==Dia_2,
	Dia_2==Dia_3,
	!.

validaDiaVisita(_,_,_):-
	write('validacao dia visita : erro'),nl,
	false.

validaDiaVisita(Ano_1,Ano_2,Mes_1,Mes_2,Dia_1,Dia_2):-
	Ano_1==Ano_2,
	Mes_1==Mes_2,
	Dia_1==Dia_2,
	!.

validaDiaVisita(_,_,_,_,_,_):-
	write('valida dia visita : erro'),nl,
	false.

validaDiaVisita(Ano_1,Ano_2,Ano_3,Mes_1,Mes_2,Mes_3,Dia_1,Dia_2,Dia_3):-
	Ano_1==Ano_2,
	Ano_1==Ano_3,
	Mes_1==Mes_2,
	Mes_1==Mes_3,
	Dia_1==Dia_2,
	Dia_1==Dia_3,
	!.

validaDiaVisita(_,_,_,_,_,_,_,_,_):-
	write('valida dia visita : erro'),nl,
	false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max(A,B,A):-
	A>=B,
	!.

max(A,B,B):-
	B>A,
	!.

min(A,B,A):-
	A=<B,
	!.

min(A,B,B):-
	B<A,
	!.
