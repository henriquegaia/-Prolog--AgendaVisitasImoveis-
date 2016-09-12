%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
minutosParaHoras(200,H).
200/60=3.3(3)
60*0,33(3)=20M
H=3h20m
limite=(60*23)+59= 1439 minutos
*/
minutosParaHoras('---','---'):-
	!,
	true.

minutosParaHoras(M,H):-
	integer(M),
	M =< 1449,
	M >= 0,
	!,
	H_float is M/60,
	floor(H_float,H_int),
	M_float is H_float-H_int,
	M_int is (M_float*60),
	round(M_int,M_int2),
	returnHoraFormat(H_int,M_int2,H).


minutosParaHoras(_,_):-
	write('erro minutosParaHoras\n').

returnHoraFormat(H_int,M_int2,H):-
	H_int > 9,
	M_int2 > 9,
	!,
	swritef(H,'%w:%w',[H_int,M_int2]).

returnHoraFormat(H_int,M_int2,H):-
	H_int =< 9,
	M_int2 =< 9,
	!,
	swritef(H,'0%w:0%w',[H_int,M_int2]).

returnHoraFormat(H_int,M_int2,H):-
	H_int =< 9,
	!,
	swritef(H,'0%w:%w',[H_int,M_int2]).

returnHoraFormat(H_int,M_int2,H):-
	M_int2 =< 9,
	!,
	swritef(H,'%w:0%w',[H_int,M_int2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

horasParaMinutos(Horas,M):-
	split_string(Horas,":","",[H|T]),
	getMinutos(T,Min),
	atom_number(H,Hora),
	atom_number(Min,Minutos),
	integer(Hora),
	integer(Minutos),
	Hora >= 0,
	Hora =< 23,
	Minutos >= 0,
	Minutos =< 59,
	!,
	M is (Hora * 60)+ Minutos,!.

horasParaMinutos(_,_):-
	write('\nerro conversao horas para minutos\n'),
	false.

getMinutos([M|_],M):-
	!.

