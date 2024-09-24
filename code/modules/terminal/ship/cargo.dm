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
	var/list/linked_weapons_bays = list("LD Homing" = /obj/structure/ship_elements/weapon_store,
		"Direct" = /obj/structure/ship_elements/weapon_store,
		"Accelerating Torpedo" = /obj/structure/ship_elements/weapon_store,
		"Homing" = /obj/structure/ship_elements/weapon_store,
		"Explosive" = /obj/structure/ship_elements/weapon_store,
		"MIP" = /obj/structure/ship_elements/weapon_store,
		)

/obj/structure/terminal/cargo_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	var/list/area_contents = list()
	for(var/area/areas_to_scan in GLOB.sts_ship_areas)
		area_contents.Add(areas_to_scan.GetAllContents())
	var/weapons_bay_counter = 0
	for(var/obj/structure/ship_elements/weapon_store/weapons_bay_to_link in area_contents)
		if(weapons_bay_to_link.ship_name == ship_name)
			if(weapons_bay_to_link.stored_ammo_type == "LD Homing")
				linked_weapons_bays["LD Homing"] = weapons_bay_to_link
				weapons_bay_counter += 1
			if(weapons_bay_to_link.stored_ammo_type == "Direct")
				linked_weapons_bays["Direct"] = weapons_bay_to_link
				weapons_bay_counter += 1
			if(weapons_bay_to_link.stored_ammo_type == "Accelerating Torpedo")
				linked_weapons_bays["Accelerating Torpedo"] = weapons_bay_to_link
				weapons_bay_counter += 1
			if(weapons_bay_to_link.stored_ammo_type == "Homing")
				linked_weapons_bays["Homing"] = weapons_bay_to_link
				weapons_bay_counter += 1
			if(weapons_bay_to_link.stored_ammo_type == "Explosive")
				linked_weapons_bays["Explosive"] = weapons_bay_to_link
				weapons_bay_counter += 1
			if(weapons_bay_to_link.stored_ammo_type == "MIP")
				linked_weapons_bays["MIP"] = weapons_bay_to_link
				weapons_bay_counter += 1
	to_chat(world, SPAN_INFO("[ship_name] weapons stores initalized. Stores found: [weapons_bay_counter]"))
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
			var/obj/structure/ship_elements/weapon_store/bay_to_shutdown = linked_weapons_bays["LD Homing"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_weapons_bays["Direct"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_weapons_bays["Accelerating Torpedo"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_weapons_bays["Homing"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_weapons_bays["Explosive"]
			bay_to_shutdown.repair_shutdown = 1
			bay_to_shutdown = linked_weapons_bays["MIP"]
			bay_to_shutdown.repair_shutdown = 1
			talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
			return
		if(0)
			repair_shutdown = 0
			talkas("Critical damage resolved. Lifting lockout.")
			var/obj/structure/ship_elements/weapon_store/bay_to_shutdown = linked_weapons_bays["LD Homing"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_weapons_bays["Direct"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_weapons_bays["Accelerating Torpedo"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_weapons_bays["Homing"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_weapons_bays["Explosive"]
			bay_to_shutdown.repair_shutdown = 0
			bay_to_shutdown = linked_weapons_bays["MIP"]
			bay_to_shutdown.repair_shutdown = 0
			return

/obj/structure/terminal/cargo_console/attackby(obj/item/W, mob/user)
	terminal_display_line("Welcome, [user]!", cache = 1)
	terminal_display_line("PRIMARY DELIVERY METHODS", cache = 1)
	var/obj/structure/ship_elements/weapon_store/cb = linked_weapons_bays["LD Homing"]
	terminal_display_line("LD-HOMING - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	cb = linked_weapons_bays["Direct"]
	terminal_display_line("DIRECT - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	cb = linked_weapons_bays["Accelerating Torpedo"]
	terminal_display_line("ACCELERATING TORPEDO - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	terminal_display_line("PRIMARY WARHEADS", cache = 1)
	cb = linked_weapons_bays["Homing"]
	terminal_display_line("HOMING - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	cb = linked_weapons_bays["Explosive"]
	terminal_display_line("EXPLOSIVE - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	cb = linked_weapons_bays["MIP"]
	terminal_display_line("MIP - [cb.current_items] - BAY [linked_weapons_bays[cb.bay_number]]", cache = 1)
	terminal_display_line("This terminal accepts no inputs! Have a nice day!")
	return
