% Recipes that Dory is using

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
