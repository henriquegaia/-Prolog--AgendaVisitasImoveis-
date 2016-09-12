%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ALGAV 2015/2016 Grupo33 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-dynamic coordenada/3.
:-dynamic estrada/3.
:-dynamic zona/2.

zona(a,'Hospital Sao Joao').
zona(b,'Areosa').
zona(c,'Prelada').
zona(d,'Paranhos').
zona(e,'Contumil').
zona(f,'Boavista').
zona(g,'Antas').
zona(h,'Fonte da Moura').
zona(i,'Foz do Douro').
zona(j,'Campanha').
zona(l,'Massarelos').
zona(m,'Lordelo do Ouro').
zona(n,'Campo 24 Agosto').
zona(o,'Azevedo').
zona(p,'Vitoria').
zona(q,'Freixo').
zona(r,'Fontainhas').

coordenada(a,45,95).
coordenada(b,90,95).
coordenada(c,15,85).
coordenada(d,40,80).
coordenada(e,70,80).
coordenada(f,25,65).
coordenada(g,65,65).
coordenada(h,45,55).
coordenada(i,5,50).
coordenada(j,80,50).
coordenada(l,65,45).
coordenada(m,25,40).
coordenada(n,55,30).
coordenada(o,80,30).
coordenada(p,25,15).
coordenada(q,80,15).
coordenada(r,55,10).

estrada(a,b,45).
estrada(a,c,32).
estrada(a,d,16).
estrada(a,e,30).
estrada(b,e,25).
estrada(d,e,30).
estrada(c,d,26).
estrada(c,f,23).
estrada(c,i,37).
estrada(d,f,22).
estrada(f,h,23).
estrada(f,m,25).
estrada(f,i,25).
estrada(i,m,23).
estrada(e,f,48).
estrada(e,g,16).
estrada(e,j,32).
estrada(g,h,23).
estrada(g,l,20).
estrada(g,j,22).
estrada(h,m,25).
estrada(h,n,27).
estrada(h,l,23).
estrada(j,l,16).
estrada(j,o,20).
estrada(l,n,19).
estrada(l,o,22).
estrada(m,n,32).
estrada(m,p,25).
estrada(n,p,34).
estrada(n,r,20).
estrada(o,n,25).
estrada(o,q,15).

%NOVAS
/*
estrada(s,b,21).
estrada(s,e,11).
estrada(t,b,20).
estrada(t,e,10).
estrada(t,a,25).
estrada(s,e,11).
estrada(s,b,21).
estrada(s,j,40).
estrada(u,i,22).
estrada(u,p,18).
estrada(u,m,14).
estrada(x,m,14).
estrada(x,p,18).
estrada(x,n,20).
estrada(x,h,27).
estrada(y,n,18).
estrada(y,o,14).
estrada(y,r,18).
estrada(y,q,11).
estrada(v,g,16).
estrada(v,h,16).
estrada(v,d,14).
estrada(v,e,22).
estrada(z,f,29).
estrada(z,m,15).
estrada(z,i,25).
estrada(aa,l,20).
estrada(aa,j,14).
estrada(aa,q,27).
estrada(aa,o,14).
estrada(ab,q,11).
estrada(ab,y,10).
estrada(ab,r,15).
estrada(ac,r,20).
estrada(ac,p,14).
estrada(ad,c,14).
estrada(ad,d,21).
estrada(ae,i,15).
estrada(ae,af,25).
estrada(ae,u,11).
estrada(af,p,20).
estrada(af,ag,15).
estrada(ag,ac,15).
estrada(ah,c,18).
estrada(ah,i,20).
estrada(ah,f,21).
estrada(ah,d,36).

%81ª
estrada(p,y,45).

*/
