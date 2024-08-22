/obj/structure/terminal/cargo_console/
	name = "munitions cargo bay console"
	item_serial = "-MUNCRG-CNS"
	desc = "A terminal labeled 'Cargo Bay - Munitions Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 0
	terminal_id = "_cargo_control"
	var/ship_name
	var/repair_shutdown = 0
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/list/linked_cargo_bays = list("primary_munitions" = /obj/structure/ship_elements/cargo_bay/primary_munitions,
		"secondary_munitions" = /obj/structure/ship_elements/cargo_bay/secondary_munitions,
		)

/obj/structure/terminal/cargo_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	var/list/area_contents = list()
	for(var/area/areas_to_scan in GLOB.sts_ship_areas)
		area_contents.Add(areas_to_scan.GetAllContents())
	for(var/obj/structure/ship_elements/cargo_bay/primary_bay_to_link in area_contents)
		if(linked_master_console.sector_map_data["name"] == primary_bay_to_link.ship_name)
			if(primary_bay_to_link.bay_id == "primary_munitions")
				linked_cargo_bays["primary_munitions"] = primary_bay_to_link
				to_chat(world, SPAN_INFO("Primary Munitions bay for [linked_master_console.sector_map_data["name"]] initiated."))
				break
	for(var/obj/structure/ship_elements/cargo_bay/secondary_bay_to_link in area_contents)
		if(linked_master_console.sector_map_data["name"] == secondary_bay_to_link.ship_name)
			if(secondary_bay_to_link.bay_id == "secondary_munitions")
				linked_cargo_bays["secondary_munitions"] = secondary_bay_to_link
				to_chat(world, SPAN_INFO("Secondary Munitions bay for [linked_master_console.sector_map_data["name"]] initiated."))
				break
	terminal_id = "[linked_master_console.sector_map_data["name"]][initial(terminal_id)]"
	item_serial = "[uppertext(linked_master_console.sector_map_data["name"])][initial(item_serial)]"
	header_name = "[linked_master_console.sector_map_data["name"]] CARGO CONTROL"
	WriteHeader()
	reset_buffer()

/obj/structure/terminal/cargo_console/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			repair_shutdown = 1
			world << browse(null, "window=[terminal_id]")
			var/obj/structure/ship_elements/cargo_bay/bay_to_shutdown = linked_cargo_bays["primary_munitions"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_cargo_bays["secondary_munitions"]
			bay_to_shutdown.repair_shutdown = 1
			talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
			return
		if(0)
			repair_shutdown = 0
			talkas("Critical damage resolved. Lifting lockout.")
			var/obj/structure/ship_elements/cargo_bay/bay_to_shutdown = linked_cargo_bays["primary_munitions"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_cargo_bays["secondary_munitions"]
			bay_to_shutdown.repair_shutdown = 0
			return

/obj/structure/terminal/cargo_console/proc/terminal_advanced_parse(type = null, string = null)
	if(type == null || string == null) return
	switch(type)
		if("RETR")
			var/obj/structure/ship_elements/cargo_bay/bay_to_dispense = linked_cargo_bays["primary_munitions"]
			switch(string)
				if("M_H20")
					if(bay_to_dispense.cargo_data["missile_pst_homing"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["missile_pst_homing"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/missile_homing)
						terminal_display_line("[bay_to_dispense.cargo_data["missile_pst_homing"]] left in store.")
					else
						terminal_display_line("Error: Stock empty. Resupply recommended.")
				if("M_D40")
					if(bay_to_dispense.cargo_data["missile_pst_dumbfire"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["missile_pst_dumbfire"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/missile_dumbfire)
						terminal_display_line("[bay_to_dispense.cargo_data["missile_pst_dumbfire"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("M_T05")
					if(bay_to_dispense.cargo_data["missile_pst_torpedo"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["missile_pst_torpedo"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/missile_torpedo)
						terminal_display_line("[bay_to_dispense.cargo_data["missile_pst_torpedo"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("W_D03")
					if(bay_to_dispense.cargo_data["warhead_direct"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["warhead_direct"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/warhead_direct)
						terminal_display_line("[bay_to_dispense.cargo_data["warhead_direct"]] left in store.")
					else
						terminal_display_line("Error: Stock empty. Resupply recommended.")
				if("W_E02")
					if(bay_to_dispense.cargo_data["missile_pst_homing"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["missile_pst_homing"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/missile_homing)
						terminal_display_line("[bay_to_dispense.cargo_data["missile_pst_homing"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("W_M03")
					if(bay_to_dispense.cargo_data["warhead_mip"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["warhead_mip"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/structure/ship_elements/missile_ammo/warhead_mip)
						terminal_display_line("[bay_to_dispense.cargo_data["warhead_mip"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
			bay_to_dispense = linked_cargo_bays["secondary_munitions"]
			switch(string)
				if("S-D02")
					if(bay_to_dispense.cargo_data["secondary_direct"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["secondary_direct"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/item/ship_elements/secondary_ammo/direct)
						terminal_display_line("[bay_to_dispense.cargo_data["secondary_direct"]] left in store.")
					else
						terminal_display_line("Error: Stock empty. Resupply recommended.")
				if("S-E03")
					if(bay_to_dispense.cargo_data["secondary_flak"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["secondary_flak"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/item/ship_elements/secondary_ammo/flak)
						terminal_display_line("[bay_to_dispense.cargo_data["secondary_flak"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("S-B05")
					if(bay_to_dispense.cargo_data["secondary_broadside"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["secondary_broadside"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/item/ship_elements/secondary_ammo/broadside)
						terminal_display_line("[bay_to_dispense.cargo_data["secondary_broadside"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("X-P01")
					if(bay_to_dispense.cargo_data["probe"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["probe"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/item/ship_probe)
						terminal_display_line("[bay_to_dispense.cargo_data["probe"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")
				if("X-T01")
					if(bay_to_dispense.cargo_data["tracker"] > 0)
						to_chat(usr,SPAN_ADMIN("Dispensing."))
						bay_to_dispense.cargo_data["tracker"] -= 1
						INVOKE_ASYNC(bay_to_dispense,TYPE_PROC_REF(/obj/structure/ship_elements/cargo_bay, DispenseObject), /obj/item/ship_tracker)
						terminal_display_line("[bay_to_dispense.cargo_data["tracker"]] left in store.")
					else
						terminal_display_line("Error: Stock empty.")



/obj/structure/terminal/cargo_console/terminal_parse(str)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	var/starting_buffer_length = terminal_buffer.len
	switch(string_to_parse)
		if("HELP")
			terminal_display_line("Available Commands:")
			terminal_display_line("CARGO - takes inventory of cargo bays. This display is also visible after login.")
			terminal_display_line("RETR - Retrieve Cargo. Use format: TAG_ID , as seen in the CARGO readout.")
			terminal_display_line("The cargo bay will automatically detect and pick up deposited munitions.")
			terminal_display_line("No further information available.")
		if("CARGO")
			terminal_display_line("Current stocks:")
			terminal_display_line("BAY 1 - primary ship ammo:")
			terminal_display_line("MISSILES | TAG: M")
			var/obj/structure/ship_elements/cargo_bay/bay_to_scan = linked_cargo_bays["primary_munitions"]
			terminal_display_line("Hunter | ID: H20 | [bay_to_scan.cargo_data["missile_pst_homing"]] in storage.")
			terminal_display_line("Panther | ID: D40 | [bay_to_scan.cargo_data["missile_pst_dumbfire"]] in storage.")
			terminal_display_line("Inferno | ID: T05 | [bay_to_scan.cargo_data["missile_pst_torpedo"]] in storage.")
			terminal_display_line("WARHEADS | TAG: W")
			terminal_display_line("Standard | ID: D03 | [bay_to_scan.cargo_data["warhead_direct"]] in storage.")
			terminal_display_line("Explosive | ID: E02 | [bay_to_scan.cargo_data["warhead_explosive"]] in storage.")
			terminal_display_line("MIP | ID: M03 | [bay_to_scan.cargo_data["warhead_mip"]] in storage.")
			terminal_display_line("BAY 2 - secondary ship ammo:")
			bay_to_scan = linked_cargo_bays["secondary_munitions"]
			terminal_display_line("TYPE S | TAG: S")
			terminal_display_line("Direct | ID: D02 | [bay_to_scan.cargo_data["secondary_direct"]] in storage.")
			terminal_display_line("Flak | ID: E03 | [bay_to_scan.cargo_data["secondary_flak"]] in storage.")
			terminal_display_line("Broadside | ID: B05 | [bay_to_scan.cargo_data["secondary_broadside"]] in storage.")
			terminal_display_line("SPECIAL | TAG: X")
			terminal_display_line("EYE-7 probe | ID: P01 | [bay_to_scan.cargo_data["probe"]]")
			terminal_display_line("PHA-1 tracker | ID: T01 | [bay_to_scan.cargo_data["tracker"]]")
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
