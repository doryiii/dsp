% Dyson Sphere Program calculator

ratio(L) :-
    member(Const-KnownVar, L), \+var(KnownVar),
    maplist({Const-KnownVar}/[A-X, A-X]>>(X is A*KnownVar/Const), L, L).

% base_material(iron_ore).
% base_material(copper_ore).
% base_material(silicon_ore).
% base_material(titanium_ore).
% base_material(stone).
% base_material(coal).
% base_material(crude).
% base_material(hydrogen).
% base_material(photon).
% base_material(water).
% base_material(sulfuric_acid).
% base_material(fire_ice).
% base_material(organic).
% base_material(kimberlite).
% base_material(stalagmite).

% base_material(_-Material) :- base_material(Material).

% miner
recipe([1-iron_ore], 1-miner, []).
recipe([1-copper_ore], 1-miner, []).
recipe([1-silicon_ore], 1-miner, []).
recipe([1-titanium_ore], 1-miner, []).
recipe([1-stone], 1-miner, []).
recipe([1-coal], 1-miner, []).
recipe([1-fire_ice], 1-miner, []).
recipe([1-organic], 1-miner, []).
recipe([1-kimberlite], 1-miner, []).
recipe([1-stalagmite], 1-miner, []).

% pump
recipe([1-water], 1-pump, []).
recipe([1-sulfuric_acid], 1-pump, []).

% oil extractor
recipe([1-crude], 10-oil_extractor, []).

% orbital collector
recipe([0.8-hydrogen], 1-orbital_collector, []).
recipe([0.15-deuterium], 1-orbital_collector, []).
recipe([0.2-fire_ice], 1-orbital_collector, []).

% ray receiver
recipe([0.1-photon], 1-ray_receiver, []).

% fractionator
recipe([0.3-deuterium], 1-fractionator, [0.3-hydrogen]).

% smelter
recipe([1-iron], 1-smelter, [1-iron_ore]).
recipe([1-magnet], 1.5-smelter, [1-iron_ore]).
recipe([1-copper], 1-smelter, [1-copper_ore]).
recipe([1-silicon], 2-smelter, [2-silicon_ore]).
recipe([1-titanium], 2-smelter, [2-titanium_ore]).

recipe([1-graphite], 2-smelter, [2-coal]).
recipe([1-brick], 1-smelter, [1-stone]).
recipe([1-glass], 2-smelter, [2-stone]).
recipe([1-silicon_ore], 10-smelter, [10-stone]).

recipe([1-xtal_si], 2-smelter, [1-silicon]).
recipe([1-steel], 3-smelter, [3-iron]).
recipe([4-ti_alloy], 12-smelter, [4-titanium, 4-steel, 8-sulfuric_acid]).
recipe([1-diamond], 2-smelter, [1-graphite]).
recipe([2-diamond], 1.5-smelter, [1-kimberlite]).

% refinery
recipe([2-oil, 1-hydrogen], 4-refinery, [2-crude]).
recipe([1-graphite, 3-hydrogen], 4-refinery, [1-oil, 2-hydrogen]).
%recipe([3-oil], 4-refinery, [2-oil, 1-hydrogen, 1-coal]).

% chemical facility
recipe([1-plastic], 3-chem, [2-oil, 1-graphite]).
recipe([2-graphene], 3-chem, [3-graphite, 1-sulfuric_acid]).
recipe([2-graphene, 1-hydrogen], 2-chem, [2-fire_ice]).
recipe([2-nanotube], 4-chem, [3-graphene, 1-titanium]).
recipe([2-nanotube], 4-chem, [6-stalagmite]).
recipe([4-sulfuric_acid], 6-chem, [6-oil, 8-stone, 4-water]).
recipe([1-organic], 6-chem, [2-plastic, 1-oil, 1-water]).

% particle collider
recipe([2-antimatter, 2-hydrogen], 2-collider, [2-photon]).
recipe([5-deuterium], 2.5-collider, [10-hydrogen]).
recipe([1-strange_matter], 8-collider, [2-particle_container, 2-iron, 10-deuterium]).

% assembler
recipe([2-circuitboard], 1-assembler, [2-iron, 1-copper]).
recipe([1-component], 2-assembler, [2-silicon, 1-copper]).
recipe([1-processor], 3-assembler, [2-circuitboard, 2-component]).

recipe([1-gear], 1-assembler, [1-iron]).
recipe([2-coil], 1-assembler, [2-magnet, 1-copper]).
recipe([1-motor], 2-assembler, [2-iron, 1-gear, 1-coil]).
recipe([1-turbine], 2-assembler, [2-motor, 2-coil]).
recipe([1-supermagnet], 3-assembler, [2-turbine, 3-magnet, 1-graphite]).

recipe([1-particle_container], 4-assembler, [2-turbine, 2-copper, 2-graphene]).
recipe([1-particle_container], 4-assembler, [2-unipolar, 2-copper]).


% ---------------------------------------------------------------------------

simplify_recipe(RawOut, RawIn, Out, In) :-
    (   member(A-Item, RawOut), member(B-Item, RawIn)
    ->  A =\= B,
        (   A > B
        ->  C is A - B,
            select(A-Item, RawOut, C-Item, Out),
            select(B-Item, RawIn, In)
        ;   C is B - A,
            select(A-Item, RawOut, Out),
            select(B-Item, RawIn, C-Item, In)
    )   %   Assuming A =:= B never happens
    ;   Out = RawOut, In = RawIn
    ).

substitute_counts(In, Out) :- maplist([_N-Item, _-Item]>>(true), In, Out).
strip_counts(In, Out) :- maplist([_-Item, Item]>>(true), In, Out).
recipe_name(Outputs, Inputs, Name) :- 
    strip_counts(Outputs, ShortOutputs),
    strip_counts(Inputs, ShortInputs),
    Name = ShortOutputs-ShortInputs.

make_immediate(N-Product, NFac-(Facility-RecipeName), Inputs, Extras) :-
    % find product in one of the recipes
    recipe(BaseRawOutputs, NBaseFac-Facility, BaseRawInputs),
    simplify_recipe(BaseRawOutputs, BaseRawInputs, BaseOutputs, BaseInputs),
    member(_-Product, BaseOutputs),
    % give it a name
    recipe_name(BaseRawOutputs, BaseRawInputs, RecipeName),
    % unify ratios
    substitute_counts(BaseOutputs, Outputs),
    substitute_counts(BaseInputs, Inputs),
    append([BaseOutputs, [NBaseFac-Facility], BaseInputs], BaseAll),
    append([Outputs, [NFac-Facility], Inputs], All),
    member(N-Product, Outputs),
    maplist([NBase-Item, X-Item, NBase-X]>>(true), BaseAll, All, Ratios),
    ratio(Ratios),
    select(N-Product, Outputs, Extras).

dedup([], []).
dedup([N-Item|Rest], Deduped) :-
    (   member(M-Item, Rest)
    ->  select(M-Item, Rest, RestCombined), !,
        P is N + M, dedup([P-Item|RestCombined], Deduped)
    ;   dedup(Rest, RestDeduped),
        Deduped = [N-Item|RestDeduped]
    ).

append_dedup(ListOfLists, List) :- append(ListOfLists, L), dedup(L, List).

make(N-Product, [NFac-Facility|MoreFacilities], Extras) :-
    make_immediate(N-Product, NFac-Facility, StepInputs, StepExtras),
    write('making '), write(N-Product), write(' from '), write(StepInputs), write(' leaving '), write(StepExtras), nl,
    maplist(
        [NIn-In, TmpFacs, TmpExtras]>>(
            make(NIn-In, TmpFacs, TmpExtras)),
        StepInputs, MoreFacilitiesNested, MoreExtras),
    append_dedup(MoreFacilitiesNested, MoreFacilities),
    append_dedup([StepExtras|MoreExtras], Extras),
    \+member(_-Product, Extras).


