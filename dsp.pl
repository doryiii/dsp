% Dyson Sphere Program calculator
% To use, run swipl, then
%   consult(dsp).
%   make_all(10-yellow_matrix, [coal]).
% to find all ways to make yellow matrix without mining for coal.
% other advanced queries (e.g. only show recipes without Kimberlite) are
% available via make/3 predicate.

:- consult(recipes).
:- table is_renewable/1.
:- table recipe/1.
:- table make_step/5.


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

make_step(N-Prod, M-(Fac-ShortRecipe), Inputs, Extras, Recipe) :-
    recipe(Recipe), Recipe = RecipeOuts-(RecipeM-Fac)-RecipeIns,
    balance(RecipeOuts, RecipeIns, BaseOuts, BaseIns),
    member(_-Prod, BaseOuts),
    append([BaseOuts, [RecipeM-Fac], BaseIns], BaseAll),

    substitute_counts(BaseOuts, Outputs),
    substitute_counts(BaseIns, Inputs),
    append([Outputs, [M-Fac], Inputs], All),

    member(N-Prod, Outputs),
    maplist([NBase-Item, X-Item, NBase-X]>>(true), BaseAll, All, Ratios),
    ratio(Ratios),
    select(N-Prod, Outputs, Extras),
    
    recipe_short_name(Recipe, ShortRecipe).

make([], [], []).
make([N-Prod|RestOfProds], Facs, Extras) :-
    NFloat is N*1.0,
    make_step(NFloat-Prod, StepFac, StepInputs, StepExtras, _),
    balance(RestOfProds, StepExtras, TrueRestOfProds, TrueStepExtras),
    append_dedup([TrueRestOfProds, StepInputs], ToMakes),
    make(ToMakes, RestOfFacs, RestOfExtras),
    dedup([StepFac|RestOfFacs], Facs),
    append_dedup([TrueStepExtras, RestOfExtras], Extras).

print_result([]).
print_result([[Mfgs, Miners, RenewableCollectors, Extras]|Rest]) :-
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
    nl,
    print_result(Rest).
    
debug_write(Products, Facilities, Inputs, Extras) :-
    write('  making '), write(Products), write(' in '), write(Facilities),
    (Inputs = []; (Inputs \= [], write(' from '), write(Inputs))),
    (Extras = []; (Extras \= [], write(' leaving '), write(Extras))),
    nl.

make_all(N-Prod, Ignores) :-
    findall(
        [Mfgs, Miners, Renewables, Extras],
        (   make([N-Prod], AllFacsF, ExtrasF),
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
