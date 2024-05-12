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
extras=[5-hydrogen]

% yellow
