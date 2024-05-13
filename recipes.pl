
% pump
recipe([1-water]-(1-pump)-[]).
recipe([1-sulfuric_acid]-(1-pump)-[]).

% oil extractor
recipe([1-crude]-(10-oil_extractor)-[]).

% orbital collector
recipe([8-hydrogen]-(10-orbital_collector)-[]).
recipe([15-deuterium]-(100-orbital_collector)-[]).
recipe([2-fire_ice]-(10-orbital_collector)-[]).

% ray receiver
recipe([1-photon]-(10-ray_receiver)-[]).

% miner
recipe([1-iron_ore]-(1-miner)-[]).
recipe([1-copper_ore]-(1-miner)-[]).
recipe([1-silicon_ore]-(1-miner)-[]).
recipe([1-titanium_ore]-(1-miner)-[]).
recipe([1-stone]-(1-miner)-[]).
recipe([1-coal]-(1-miner)-[]).
% recipe([1-fire_ice]-(1-miner)-[]).  % renewable
recipe([1-organic]-(1-miner)-[]).
recipe([1-kimberlite]-(1-miner)-[]).
recipe([1-stalagmite]-(1-miner)-[]).
recipe([1-grating_xtal]-(1-miner)-[]).

% fractionator
recipe([3-deuterium]-(10-fractionator)-[3-hydrogen]).

% smelter
recipe([1-iron]-(1-smelter)-[1-iron_ore]).
recipe([1-magnet]-(1.5-smelter)-[1-iron_ore]).
recipe([1-copper]-(1-smelter)-[1-copper_ore]).
recipe([1-silicon]-(2-smelter)-[2-silicon_ore]).
recipe([1-titanium]-(2-smelter)-[2-titanium_ore]).

recipe([1-graphite]-(2-smelter)-[2-coal]).
recipe([1-brick]-(1-smelter)-[1-stone]).
recipe([1-glass]-(2-smelter)-[2-stone]).
% recipe([1-silicon_ore]-(10-smelter)-[10-stone]).  % should not use

recipe([1-xtal_si]-(2-smelter)-[1-silicon]).
recipe([1-steel]-(3-smelter)-[3-iron]).
recipe([4-ti_alloy]-(12-smelter)-[4-titanium, 4-steel, 8-sulfuric_acid]).
recipe([1-diamond]-(2-smelter)-[1-graphite]).
recipe([2-diamond]-(1.5-smelter)-[1-kimberlite]).

% refinery
recipe([2-oil, 1-hydrogen]-(4-refinery)-[2-crude]).
recipe([1-graphite, 3-hydrogen]-(4-refinery)-[1-oil, 2-hydrogen]).
% recipe([3-oil]-(4-refinery)-[2-oil, 1-hydrogen, 1-coal]).  % should not use

% chemical facility
recipe([1-plastic]-(3-chem)-[2-oil, 1-graphite]).
% recipe([2-graphene]-(3-chem)-[3-graphite, 1-sulfuric_acid]).  % should not use
recipe([2-graphene, 1-hydrogen]-(2-chem)-[2-fire_ice]).
recipe([2-nanotube]-(4-chem)-[3-graphene, 1-titanium]).
recipe([2-nanotube]-(4-chem)-[6-stalagmite]).
% recipe([4-sulfuric_acid]-(6-chem)-[6-oil, 8-stone, 4-water]).  % renewable
recipe([1-organic]-(6-chem)-[2-plastic, 1-oil, 1-water]).

% particle collider
recipe([2-antimatter, 2-hydrogen]-(2-collider)-[2-photon]).
recipe([5-deuterium]-(2.5-collider)-[10-hydrogen]).
recipe([1-strange_matter]-(8-collider)-[2-particle_container, 2-iron, 10-deuterium]).

% assembler
recipe([1-proliferator]-(0.5-assembler)-[1-coal]).
recipe([1-proliferator2]-(1-assembler)-[2-proliferator, 1-diamond]).
recipe([1-proliferator3]-(2-assembler)-[2-proliferator2, 1-nanotube]).

recipe([1-gear]-(1-assembler)-[1-iron]).
recipe([2-coil]-(1-assembler)-[2-magnet, 1-copper]).
recipe([1-motor]-(2-assembler)-[2-iron, 1-gear, 1-coil]).
recipe([1-turbine]-(2-assembler)-[2-motor, 2-coil]).
recipe([1-supermagnet]-(3-assembler)-[2-turbine, 3-magnet, 1-graphite]).

recipe([1-particle_container]-(4-assembler)-[2-turbine, 2-copper, 2-graphene]).
recipe([1-particle_container]-(4-assembler)-[2-unipolar, 2-copper]).
recipe([1-graviton_lens]-(6-assembler)-[4-diamond, 1-strange_matter]).

recipe([2-circuitboard]-(1-assembler)-[2-iron, 1-copper]).
recipe([1-component]-(2-assembler)-[2-silicon, 1-copper]).
recipe([1-processor]-(3-assembler)-[2-circuitboard, 2-component]).

recipe([1-ti_xtal]-(4-assembler)-[1-organic, 3-titanium]).
recipe([2-ti_glass]-(5-assembler)-[2-glass, 2-titanium, 2-water]).
recipe([1-casimir_xtal]-(4-assembler)-[1-ti_xtal, 2-graphene, 12-hydrogen]).
recipe([1-casimir_xtal]-(4-assembler)-[8-grating_xtal, 2-graphene, 12-hydrogen]).
recipe([1-plane_filter]-(12-assembler)-[1-casimir_xtal, 2-ti_glass]).
recipe([1-quantum_chip]-(6-assembler)-[2-processor, 2-plane_filter]).

recipe([1-fiber]-(8-assembler)-[2-nanotube, 2-xtal_si, 1-plastic]).

recipe([2-deuteron_fuel]-(12-assembler)-[1-ti_alloy, 20-deuterium, 1-supermagnet]).
recipe([2-prism]-(2-assembler)-[3-glass]).
recipe([1-photon_combiner]-(3-assembler)-[1-grating_xtal, 1-circuitboard]).
recipe([1-photon_combiner]-(3-assembler)-[2-prism, 1-circuitboard]).
recipe([2-sail]-(4-assembler)-[1-graphene, 1-photon_combiner]).
recipe([1-frame]-(6-assembler)-[4-nanotube, 1-ti_alloy, 1-silicon]).
recipe([1-sphere_part]-(8-assembler)-[3-frame, 3-sail, 3-processor]).
recipe([1-rocket]-(6-assembler)-[2-sphere_part, 4-deuteron_fuel, 2-quantum_chip]).

recipe([1-annihilation_sphere]-(20-assembler)-[1-particle_container, 1-processor]).
recipe([2-antimatter_fuel]-(24-assembler)-[12-antimatter, 12-hydrogen, 1-annihilation_sphere, 1-ti_alloy]).

% lab
recipe([1-blue_matrix]-(3-lab)-[1-coil, 1-circuitboard]).
recipe([1-red_matrix]-(6-lab)-[2-graphite, 2-hydrogen]).
recipe([1-yellow_matrix]-(8-lab)-[1-diamond, 1-ti_xtal]).
recipe([1-purple_matrix]-(10-lab)-[2-processor, 1-fiber]).
recipe([2-green_matrix]-(24-lab)-[1-graviton_lens, 1-quantum_chip]).
recipe([1-white_matrix]-(15-lab)-[1-blue_matrix, 1-red_matrix, 1-yellow_matrix, 1-purple_matrix, 1-green_matrix, 1-antimatter]).
