% *****************************************************
% *						part 1 						  *
% ********************  fc_course  ********************
%fc_course(C) :- course(C, _, 3); course(C, _, 4). 
fc_course(C) :- course(C, _, Units), (Units=3; Units=4).

% ********************  prereq_110  ********************
prereq_110(C) :- course(C, Clist, _), member(ecs110,Clist).
% ********************    puzzle	********************	
	
% all facts: state(farmer, wolf, goat, cabbage)
state(left,left,left,left).  %safe 
state(right,left,left,left).
state(right,left,left,right).
state(right,left,right,left). %safe
state(right,right,left,left).
state(left,left,right,left). %safe
state(right,left,right,right). %safe
state(right,right,right,left). %safe
state(left,left,right,right).
state(left,left,left,right). %safe
state(left,right,left,left). %safe
state(left,right,right,left).
state(right,left,left,right).
state(right,right,left,right). %safe
state(right,right,left,left).
state(left,right,left,right). %safe
state(right,right,right,right).  %safe

%**************************************
opposite(A,B) :- (A=left,B=right);(A=right,B=left).

%**************************************
unsafe(state(F,W,G,C)) :- 
	(opposite(F,W),opposite(F,G),opposite(F,C));
	(opposite(F,W),opposite(F,G),opposite(C,W),opposite(C,G));
	(opposite(F,C),opposite(F,G),opposite(W,C),opposite(W,G)).

%**************************************
safe(state(F,W,G,C)) :- \+ unsafe(state(F,W,G,C)).

%**************************************
take(X,A,B) :- member(X,[none,wolf,goat,cabbage]),opposite(A,B).

%**************************************
arc(take(none,A,B),state(A,W,G,C),state(B,W,G,C)) :- opposite(A,B).
arc(take(wolf,A,B),state(A,A,G,C),state(B,B,G,C)) :- opposite(A,B).
arc(take(goat,A,B),state(A,W,A,C),state(B,W,B,C)) :- opposite(A,B).
arc(take(cabbage,A,B),state(A,W,G,A),state(B,W,G,B)) :- opposite(A,B).

%**************************************	
go(Start,Dest,Route) :- go_help(Start,Dest,[],[],R),reverse(R,Route).
	go_help(X,X,Trail,Moves,Moves).
	go_help(Place,Y,Trail,Moves,Route) :-	
		arc(Take,Place,Next),
		safestate(Place,Next,Trail),
		go_help(Next,Y,[Place|Trail],[Take|Moves],Route).
		
	safestate(X,Y,T) :- safe(Y),legal(X,T).
		legal(X,[]).
		legal(X,[H|T]) :- \+ X=H,legal(X,T).	

%**************************************
%**************************************
solve :- go(state(left,left,left,left),state(right,right,right,right),Route),printlist(Route).
printlist([]).
printlist([H|T]) :- write(H), nl, printlist(T).	
	
	
	
	
	
	