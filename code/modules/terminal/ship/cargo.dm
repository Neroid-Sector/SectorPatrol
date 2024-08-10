/obj/structure/terminal/cargo_console/
	name = "munitions cargo bay console"
	item_serial = "-MUNCRG-CNS"
	desc = "A terminal labeled 'Cargo Bay - Munitions Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 2
	terminal_id = "_weapons_control"
	var/repair_shutdown = 0
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/list/linked_cargo_bays = list()
	var/list/cargo_bay_contents = list(
		"bay_1" = list(
			"missile_homing" = 0,
			"missile_dumbfire" = 0,
			"missile_torpedo" = 0,
			"warhead_direct" = 0,
			"warhead_explosive" = 0,
			"warhead_mip" = 0,
			),
		"bay_2" = list(
			"secondary_direct" = 0,
			"secondary_flak" = 0,
			"secondary_broadside" = 0,
			),
		)
