/obj/structure/terminal/damage_console/
	name = "damage control console"
	item_serial = "-DAM-CNS"
	desc = "A terminal labeled 'Damage Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 1
	terminal_id = "_weapons_control"
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/list/usage_data = list(
		"repairs_max" = 2,
		"repairs_done" = 0,
		"damage" = list(
			"HP" = 5,
			"engine" = 0,
			"systems" = 0,
			"weapons" = 0,
			"hull" = 0,
			),
		)

/obj/structure/terminal/damage_console/proc/UpdateMapData()
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["HP"] = usage_data["damage"]["HP"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["engine"] = usage_data["damage"]["engine"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["systems"] = usage_data["damage"]["systems"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["weapons"] = usage_data["damage"]["weapons"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["hull"] = usage_data["damage"]["hull"]
