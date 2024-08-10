/obj/structure/terminal/cargo_console/
	name = "munitions cargo bay console"
	item_serial = "-MUNCRG-CNS"
	desc = "A terminal labeled 'Cargo Bay - Munitions Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 2
	terminal_id = "_cargo_control"
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

/obj/structure/terminal/cargo_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	if(!linked_cargo_bays)
		for(var/obj/structure/ship_elements/cargo_bay/bay_to_link in world)
			if(linked_master_console.sector_map_data["name"] == bay_to_link.ship_name)
				linked_cargo_bays += bay_to_link
	terminal_id = "[linked_master_console.sector_map_data["name"]][initial(terminal_id)]"
	item_serial = "[uppertext(linked_master_console.sector_map_data["name"])][initial(item_serial)]"
	terminal_header += {"<div class="box"><p><center><b>"}+ html_encode("[linked_master_console.sector_map_data["name"]] - CARGO BAY CONTROL") + {"</b><br>"} + html_encode("UACM 2ND LOGISTICS") + {"</center></p></div><div class="box_console">"}
	reset_buffer()

/obj/structure/terminal/cargo_console/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			repair_shutdown = 1
			world << browse(null, "window=[terminal_id]")
			talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
			return
		if(0)
			repair_shutdown = 0
			talkas("Critical damage resolved. Lifting lockout.")
			return

/obj/structure/terminal/cargo_console/proc/terminal_advanced_parse(type = null, string = null)
	if(type == null || string == null) return
	switch(type)
		if("RETR")
			switch(string)
				if("aaa")
					to_chat(usr,SPAN_ADMIN("Bleh."))


/obj/structure/terminal/cargo_console/terminal_parse(str)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	var/starting_buffer_length = terminal_buffer.len
	switch(string_to_parse)
		if("HELP")
			terminal_display_line("Available Commands:")
			terminal_display_line("CARGO - takes inventory of cargo bays. This display is also visible after login.")
			terminal_display_line("RETR - used with cargo tag found in the CARGO menu, retrieves one of the selected cargo.")
			terminal_display_line("No further information available.")
		if("CARGO")
			terminal_display_line("Current stocks:")
			terminal_display_line("BAY 1 - primary ship ammo:")
			terminal_display_line("")
	if(starting_buffer_length == terminal_buffer.len)
		var/tracked_position = 1
		while(tracked_position <= length(string_to_parse))
			var/type_to_parse = copytext(string_to_parse, 1, tracked_position + 1)
			var/argument_to_parse = trimtext(copytext(string_to_parse, tracked_position + 1))
			terminal_advanced_parse(type = type_to_parse, string = argument_to_parse)
			tracked_position += 1
	if(starting_buffer_length == terminal_buffer.len) terminal_display_line("Error: Unknown command. Please use HELP for a list of available commands.")
	terminal_input()
	return "Parsing Loop End"
