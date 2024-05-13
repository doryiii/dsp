% Recipes that Dory is using for 10sps

% blue
factories=[
    30-lab-[blue_matrix]-[coil,circuitboard],
    5-assembler-[coil]-[magnet,copper],
    15.0-smelter-[magnet]-[iron_ore],
    10-smelter-[copper]-[copper_ore],
    5-assembler-[circuitboard]-[iron,copper],
    10-smelter-[iron]-[iron_ore]
]
miners=[20-iron_ore,10-copper_ore]

% red
factories=[
    60-lab-[red_matrix]-[graphite,hydrogen],
    80-refinery-[graphite,hydrogen]-[oil,hydrogen],
    40-refinery-[oil,hydrogen]-[crude]
]
renewables=[200-crude]
extras=[10-hydrogen]

% yellow
factories=[
    80-lab-[yellow_matrix]-[diamond,ti_xtal],
    7.5-smelter-[diamond]-[kimberlite],
    40-assembler-[ti_xtal]-[organic,titanium],
    60-smelter-[titanium]-[titanium_ore]
]
miners=[5-kimberlite,10-organic,60-titanium_ore]

% purple
factories=[
    100-lab-[purple_matrix]-[processor,fiber]
    60-assembler-[processor]-[circuitboard,component]
    80-assembler-[fiber]-[nanotube,xtal_si,plastic]
    20-assembler-[circuitboard]-[iron,copper]
    80-assembler-[component]-[silicon,copper]
    40-chem-[nanotube]-[graphene,titanium]
    40-smelter-[xtal_si]-[silicon]
    30-chem-[plastic]-[oil,graphite]
    40-smelter-[iron]-[iron_ore]
    60-smelter-[copper]-[copper_ore]
    200-smelter-[silicon]-[silicon_ore]
    30-chem-[graphene,hydrogen]-[fire_ice]
    20-smelter-[titanium]-[titanium_ore]
    60-refinery-[oil,hydrogen]-[crude]
    40-refinery-[graphite,hydrogen]-[oil,hydrogen]
]
miners=[40-iron_ore,60-copper_ore,200-silicon_ore,20-titanium_ore]
renewables=[150-fire_ice,300-crude]
extras=[40-hydrogen]

% green
factories=[
    120-lab-[green_matrix]-[graviton_lens,quantum_chip]
    30-assembler-[graviton_lens]-[diamond,strange_matter]
    30-assembler-[quantum_chip]-[processor,plane_filter]
    15-smelter-[diamond]-[kimberlite]
    40-collider-[strange_matter]-[particle_container,iron,deuterium]
    30-assembler-[processor]-[circuitboard,component]
    120-assembler-[plane_filter]-[casimir_xtal,ti_glass]
    40-assembler-[particle_container]-[turbine,copper,graphene]
    150-smelter-[iron]-[iron_ore]
    25-collider-[deuterium]-[hydrogen]
    10-assembler-[circuitboard]-[iron,copper]
    40-assembler-[component]-[silicon,copper]
    40-assembler-[casimir_xtal]-[ti_xtal,graphene,hydrogen]
    50-assembler-[ti_glass]-[glass,titanium,water]
    40-assembler-[turbine]-[motor,coil]
    90-smelter-[copper]-[copper_ore]
    40-chem-[graphene,hydrogen]-[fire_ice]
    80-smelter-[silicon]-[silicon_ore]
    40-assembler-[ti_xtal]-[organic,titanium]
    40-smelter-[glass]-[stone]
    100-smelter-[titanium]-[titanium_ore]
    80-assembler-[motor]-[iron,gear,coil]
    40-assembler-[coil]-[magnet,copper]
    40-assembler-[gear]-[iron]
    120-smelter-[magnet]-[iron_ore]
]
miners=[10-kimberlite,230-iron_ore,90-copper_ore,80-silicon_ore,10-organic,40-stone,100-titanium_ore]
renewables=[250-hydrogen,20-water,200-fire_ice]
extras=[]

% 20 renewable organic
factories=[
    120-chem-[organic]-[plastic,oil,water]
    120-chem-[plastic]-[oil,graphite]
    280-refinery-[oil,hydrogen]-[crude]
    160-refinery-[graphite,hydrogen]-[oil,hydrogen]
]
renewables=[20-water,1400-crude]
extras=[110-hydrogen]
