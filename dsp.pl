% Dyson Sphere Program calculator
% To use, run swipl, then
%   consult(dsp).
%   make_all(10-yellow_matrix, [coal]).
% to find all ways to make yellow matrix without mining for coal.
% other advanced queries (e.g. only show recipes without Kimberlite) are
% available via make/3 predicate.

:- consult(recipes).
% :- table is_renewable/1.
% :- table recipe/1.
% :- table make_step/5.


is_renewable(Material) :-
    recipe(Outs-(_-Fac)-[]),
    Fac \= miner,
    member(_-Material, Outs).

balance(InRight, InLeft, OutRight, OutLeft) :-
    ( member(A-Item, InRight), member(B-Item, InLeft)
    ->  ( A =:= B
        ->  select(A-Item, InRight, OutRightTmp),
            select(B-Item, InLeft, OutLeftTmp)
        ; A > B
        ->  C is A - B,
            select(A-Item, InRight, C-Item, OutRightTmp),
            select(B-Item, InLeft, OutLeftTmp)
        ; A < B
        ->  C is B - A,
            select(A-Item, InRight, OutRightTmp),
            select(B-Item, InLeft, C-Item, OutLeftTmp)
        ; false
        ),
        balance(OutRightTmp, OutLeftTmp, OutRight, OutLeft)
    ;   OutRight = InRight, OutLeft = InLeft
    ).

ratio(L) :-
    member(Const-KnownVar, L), \+var(KnownVar),
    maplist({Const-KnownVar}/[A-X, A-X]>>(X is A*KnownVar/Const), L, L).

substitute_counts(In, Out) :- maplist([_N-Item, _-Item]>>(true), In, Out).
strip_counts(In, Out) :- maplist([_-Item, Item]>>(true), In, Out).
recipe_short_name(Outputs-_-Inputs, ShortOutputs-ShortInputs) :-
    strip_counts(Outputs, ShortOutputs),
    strip_counts(Inputs, ShortInputs).

dedup([], []).
dedup([N-Item|Rest], Deduped) :-
    (   member(M-Item, Rest)
    ->  select(M-Item, Rest, RestCombined), !,
        P is N + M, dedup([P-Item|RestCombined], Deduped)
    ;   dedup(Rest, RestDeduped),
        Deduped = [N-Item|RestDeduped]
    ).

append_dedup(ListOfLists, List) :- append(ListOfLists, L), dedup(L, List).

make_step(N-Prod, M-(Fac-ShortRecipe), Inputs, Extras, P-Proliferator) :-
    recipe(Recipe), Recipe = RecipeOuts-(RecipeM0-Fac)-RecipeIns,
    balance(RecipeOuts, RecipeIns, BaseOuts, BaseIns0),
    member(_-Prod, BaseOuts),
    ( (Proliferator = proliferator3, RecipeIns \= [])
    ->  RecipeM is RecipeM0 / 1.25,
        maplist([X0-Thing, X-Thing]>>(X is X0 / 1.25), BaseIns0, BaseIns),
        foldl([X-_, In, Out]>>(Out is In + X), BaseIns, 0, InsCount),
        BaseP is InsCount / 74
    ;   RecipeM = RecipeM0,
        BaseIns = BaseIns0,
        BaseP = 0
    ),
    append([BaseOuts, [RecipeM-Fac], BaseIns, [BaseP-Proliferator]], BaseAll),

    substitute_counts(BaseOuts, Outputs),
    substitute_counts(BaseIns, Inputs),
    append([Outputs, [M-Fac], Inputs, [P-Proliferator]], All),

    member(N-Prod, Outputs),
    maplist([NBase-Item, X-Item, NBase-X]>>(true), BaseAll, All, Ratios),
    ratio(Ratios),
    select(N-Prod, Outputs, Extras),
    
    recipe_short_name(Recipe, ShortRecipe).

make([], [], [], 0-_).
make([N-Prod|RestOfProds], Facs, Extras, P-Proliferator) :-
    NFloat is N*1.0,
    make_step(NFloat-Prod, StepFac, StepInputs, StepExtras, StepP-Proliferator),
    balance(RestOfProds, StepExtras, TrueRestOfProds, TrueStepExtras),
    append_dedup([TrueRestOfProds, StepInputs], ToMakes),
    make(ToMakes, RestOfFacs, RestOfExtras, RestOfP-Proliferator),
    dedup([StepFac|RestOfFacs], Facs),
    append_dedup([TrueStepExtras, RestOfExtras], Extras),
    P is StepP + RestOfP.

print_result([]).
print_result([[Mfgs, Miners, RenewableCollectors, Extras, P]|Rest]) :-
    maplist([N-(Fac-(Ins-Outs)), N-Fac-Ins-Outs]>>(true), Mfgs, MfgsP),
    maplist([N-(_-([Item]-[])), N-Item]>>(true), Miners, MinersP),
    maplist([N-(_-([Item]-[])), N-Item]>>(true),
            RenewableCollectors, RenewableCollectorsP),
    write('factories=['), nl,
    maplist([Fac]>>(write('    '), write(Fac), nl), MfgsP),
    write(']'), nl,
    write('miners='), write(MinersP), nl,
    write('renewables='), write(RenewableCollectorsP), nl,
    write('extras='), write(Extras), nl,
    write('proliferator3='), format('~2f', P), nl,
    nl,
    print_result(Rest).
    
debug_write(Products, Facilities, Inputs, Extras) :-
    write('  making '), write(Products), write(' in '), write(Facilities),
    (Inputs = []; (Inputs \= [], write(' from '), write(Inputs))),
    (Extras = []; (Extras \= [], write(' leaving '), write(Extras))),
    nl.

make_all(N-Prod) :- make_all(N-Prod, []).
make_all(N-Prod, Ignores) :- make_all(N-Prod, Ignores, proliferator3).
make_all(N-Prod, Ignores, P) :-
    findall(
        [Mfgs, Miners, Renewables, Extras, Px],
        (   make([N-Prod], AllFacsF, ExtrasF, Px-P),
            maplist([MFloat-X, M-X]>>(M is ceiling(MFloat)), AllFacsF, AllFacs),
            maplist([MFloat-X, M-X]>>(M is ceiling(MFloat)), ExtrasF, Extras),
            partition([_-(_-(_-[]))]>>(true), AllFacs, Inputs, Mfgs),
            maplist({Inputs}/[Ignore]>>(\+member(_-(_-([Ignore]-_)), Inputs)), Ignores),
            partition([_-(miner-_)]>>(true), Inputs, Miners, Renewables)
        ),
        Bag
    ),
    print_result(Bag),
    length(Bag, Total), write('== '), write(Total), write(' ways =='),
    nl.
