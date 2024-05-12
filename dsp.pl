% Dyson Sphere Program calculator
:- consult(recipes).


simplify_io(RawOut, RawIn, Out, In) :-
    ( member(A-Item, RawOut), member(B-Item, RawIn)
    ->  ( A =:= B
        ->  select(A-Item, RawOut, Out),
            select(B-Item, RawIn, In)
        ; A > B
        ->  C is A - B,
            select(A-Item, RawOut, C-Item, Out),
            select(B-Item, RawIn, In)
        ; A < B
        ->  C is B - A,
            select(A-Item, RawOut, Out),
            select(B-Item, RawIn, C-Item, In)
        ; false
        )
    ;   Out = RawOut, In = RawIn
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

make_one(N-Prod, M-(Fac-ShortRecipe), Inputs, Extras, Recipe) :-
    recipe(Recipe), Recipe = RecipeOuts-(RecipeM-Fac)-RecipeIns,
    simplify_io(RecipeOuts, RecipeIns, BaseOuts, BaseIns),
    member(_-Prod, BaseOuts),
    append([BaseOuts, [RecipeM-Fac], BaseIns], BaseAll),

    substitute_counts(BaseOuts, Outputs),
    substitute_counts(BaseIns, Inputs),
    append([Outputs, [M-Fac], Inputs], All),

    member(N-Prod, Outputs),
    maplist([NBase-Item, X-Item, NBase-X]>>(true), BaseAll, All, Ratios),
    ratio(Ratios),
    select(N-Prod, Outputs, Extras),
    
    recipe_short_name(Recipe, ShortRecipe)/*,
    debug_write([N-Prod], [M-(Fac-ShortRecipe)], Inputs, Extras)*/.
    

make([], [], [], _).
make([N-Prod|RestOfProducts], Facs, Extras, UsedRecipes) :-
    make_one(N-Prod, StepFac, StepInputs, StepExtras, StepRecipe),
    
    
    append_dedup([StepInputs, RestOfProducts], RestToMake),
    simplify_io(StepExtras, RestToMake, StepExtrasMin, RestToMakeMin),
    make(RestToMakeMin, RestOfFacs, RestOfExtras, [StepRecipe|UsedRecipes]),
    dedup([StepFac|RestOfFacs], Facs),
    append_dedup([StepExtrasMin, RestOfExtras], Extras).
    
make(N-Product, IntermediateFacs, MiningFacs, RenewableFacs, Extras) :-
    make([N-Product], AllFacs, Extras, []),
    partition([_-(_-(_-[]))]>>(true), AllFacs, Inputs, IntermediateFacs),
    partition([_-(miner-_)]>>(true), Inputs, MiningFacs, RenewableFacs).

debug_write(Products, Facilities, Inputs, Extras) :-
    write('  making '), write(Products), write(' in '), write(Facilities),
    (Inputs = []; (Inputs \= [], write(' from '), write(Inputs))),
    (Extras = []; (Extras \= [], write(' leaving '), write(Extras))),
    nl.
