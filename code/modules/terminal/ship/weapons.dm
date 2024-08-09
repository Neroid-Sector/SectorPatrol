/obj/structure/terminal/weapons_console/
	name = "weapons console"
	item_serial = "-WPN-CNS"
	desc = "A terminal labeled 'Weapons Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 1
	terminal_id = "_weapons_control"
	var/list/usage_data = list(
		"primary_fired" = 0,
		"salvos_max" = 2,
		"salvos_left" = 2,
		)
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/obj/structure/ship_elements/primary_cannon/linked_primary_cannon
	var/obj/structure/ship_elements/secondary_cannon/linked_secondary_cannon

/obj/structure/terminal/weapons_console/proc/UpdateMapData()
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["system"]["salvos_max"] = usage_data["salvos_max"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["system"]["salvos_left"] = usage_data["salvos_left"]

/obj/structure/terminal/weapons_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	if(!linked_primary_cannon)
		for(var/obj/structure/ship_elements/primary_cannon/cannon_to_link in world)
			if(cannon_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_primary_cannon = cannon_to_link
				to_chat(world, SPAN_INFO("Primary Cannon for ship [linked_master_console.sector_map_data["id"]] loaded."))
	if(!linked_secondary_cannon)
		for(var/obj/structure/ship_elements/secondary_cannon/cannon_to_link in world)
			if(cannon_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_secondary_cannon = cannon_to_link
				to_chat(world, SPAN_INFO("Secondary Cannon for ship [linked_master_console.sector_map_data["id"]] loaded."))
	terminal_id = "[linked_master_console.sector_map_data["name"]][initial(terminal_id)]"
	item_serial = "[uppertext(linked_master_console.sector_map_data["name"])][initial(item_serial)]"
	UpdateMapData()
	terminal_header += {"<div class="box"><p><center><b>"}+ html_encode("[linked_master_console.sector_map_data["name"]] - WEAPONS CONTROL") + {"</b><br>"} + html_encode("UACM 2ND LOGISTICS") + {"</center></p></div><div class="box_console">"}
	reset_buffer()

/obj/structure/terminal/weapons_console/proc/terminal_advanced_parse(type = null)
	switch(type)
		if(null)
			return
		if("PRIMARY")
			if(usage_data["salvos_left"] > 0)
				if(linked_primary_cannon.loaded_projectile["loaded"] == 1)
					terminal_display_line("Primary Cannon Projectile information:")
					terminal_display_line("Missile type: [linked_primary_cannon.loaded_projectile["missile"]], Speed: [linked_primary_cannon.loaded_projectile["speed"]]")
					terminal_display_line("Warhead type: [linked_primary_cannon.loaded_projectile["warhead"]], Payload: [linked_primary_cannon.loaded_projectile["payload"]]")
					if(linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["missile"]["id_tag"] == "none")
						terminal_display_line("LD Targeting system inputs ready.")
						var/fire_own_x = tgui_input_number(usr, "Enter OWN X Coordinate", "CURRENT X", max_value = GLOB.sector_map_x * 10, min_value = 1, timeout = 0)
						var/fire_own_y = tgui_input_number(usr, "Enter OWN Y Coordinate", "CURRENT Y", max_value = GLOB.sector_map_y * 10, min_value = 1, timeout = 0)
						if(fire_own_x == null) fire_own_x = 1
						if(fire_own_y == null) fire_own_y = 1
						terminal_display_line("Starting Coordinates: ([fire_own_x],[fire_own_y])")
						var/fire_target_x = tgui_input_number(usr, "Enter TARGET X Coordinate", "TARGET X", max_value = GLOB.sector_map_x * 10, min_value = 1, timeout = 0)
						var/fire_target_y = tgui_input_number(usr, "Enter TARGET Y Coordinate", "TARGET Y", max_value = GLOB.sector_map_y * 10, min_value = 1, timeout = 0)
						if(fire_target_x == null) fire_target_x = 1
						if(fire_target_y == null) fire_target_y = 1
						terminal_display_line("Target Coordinates: ([fire_target_x],[fire_target_y])")
						var/fire_target_vector_x = tgui_input_number(usr, "Enter TARGET X Vector", "TARGET VECTOR X", timeout = 0)
						var/fire_target_vector_y = tgui_input_number(usr, "Enter TARGET Y Vector", "TARGET VECTOR Y", timeout = 0)
						if(fire_target_vector_x == null) fire_target_vector_x = 0
						if(fire_target_vector_y == null) fire_target_vector_y = 0
						terminal_display_line("Target Vector: ([fire_target_vector_x],[fire_target_vector_y])")
						terminal_display_line("Calculating firing sollution.", TERMINAL_LOOKUP_SLEEP)
						terminal_display_line("READY TO FIRE.")
						if(tgui_input_list(usr, "READY TO FIRE", "FIRE", list("FIRE","Cancel"), timeout = 0) == "FIRE")
							linked_master_console.add_entity(entity_type = 1, x = linked_master_console.sector_map_data["x"], y = linked_master_console.sector_map_data["y"], type = linked_primary_cannon.loaded_projectile["missile"], vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = linked_primary_cannon.loaded_projectile["warhead"], warhead_payload = linked_primary_cannon.loaded_projectile["payload"], target_tag = linked_master_console.sector_map[fire_target_x][fire_target_y]["ship"]["id_tag"], missile_speed = linked_primary_cannon.loaded_projectile["speed"])
							INVOKE_ASYNC(linked_primary_cannon, TYPE_PROC_REF(/obj/structure/ship_elements/primary_cannon, FireCannon))
							terminal_display_line("MISSILE AWAY.")
							usage_data["salvos_left"] -= 1
							UpdateMapData()
					else
						terminal_display_line("Error: Projectile type entity already located in current position. Cannot fire primary cannon due to LD resonance.")
				else
					terminal_display_line("Error: Primary Cannon not primed.")
			else
				terminal_display_line("Error: Out of cannon salvos in this interval.")
		if("SECONDARY")
			if(usage_data["salvos_left"] > 0)
				if(linked_secondary_cannon.loaded_projectile["loaded"] == 1)
					terminal_display_line("Secondary Cannon Projectile Information:")
					terminal_display_line("Ammo type: [linked_secondary_cannon.loaded_projectile["type"]]")
					terminal_display_line("LD Targeting system inputs ready.")
					var/secondary_fire_target_x = tgui_input_number(usr, "Enter X Displacement", "TARGET X", max_value = 5, min_value = -5, timeout = 0)
					var/secondary_fire_target_y = tgui_input_number(usr, "Enter Y Displacement", "TARGET Y", max_value = 5, min_value = -5, timeout = 0)
					if(secondary_fire_target_x == null) secondary_fire_target_x = 0
					if(secondary_fire_target_y == null) secondary_fire_target_y = 0
					if(secondary_fire_target_x == 0 && secondary_fire_target_y == 0)
						terminal_display_line("Error: Targeting own position is not advisable. Aborting.")
					else if (abs(secondary_fire_target_x) + abs(secondary_fire_target_y) < 3)
						terminal_display_line("Warning: Expected hit is danger close.")
					else
						var/x_to_secondary_fire = linked_master_console.sector_map_data["x"] + secondary_fire_target_x
						var/y_to_secondary_fire = linked_master_console.sector_map_data["y"] + secondary_fire_target_y
						terminal_display_line("Vector: ([secondary_fire_target_x],[secondary_fire_target_y])")
						terminal_display_line("READY TO FIRE.")
						if(tgui_input_list(usr, "READY TO FIRE", "FIRE", list("FIRE","Cancel"), timeout = 0) == "FIRE")
							if(x_to_secondary_fire <= 0 || x_to_secondary_fire > GLOB.sector_map_x || y_to_secondary_fire <= 0 || y_to_secondary_fire > GLOB.sector_map_y)
								terminal_display_line("Error: Coordinates out of bounds. Review current position and target vector")
							else
								linked_secondary_cannon.FireCannon()
								usage_data["salvos_left"] -= 1
								UpdateMapData()
								terminal_display_line("FIRING.", TERMINAL_STANDARD_SLEEP)
								switch(linked_secondary_cannon.loaded_projectile["type"])
									if("Direct")
										if(linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["ship"]["id_tag"] != "none")
											linked_master_console.ProcessDamage(ammount = 2, x = x_to_secondary_fire, y = y_to_secondary_fire)
											terminal_display_line("Direct impact on ship detected.")
										else if (linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["missile"]["id_tag"] != "none")
											linked_master_console.rem_entity(type = "coord", id = "missile", coord_x = x_to_secondary_fire, coord_y = y_to_secondary_fire)
											terminal_display_line("Direct impact on projectile detected. Projectile destroyed.")
										else
											terminal_display_line("No impact detected.")
									if("Splash")
										terminal_display_line("Explosion detected. Analyzing...")
										var/hit_targets = linked_master_console.ProcessSplashDamage(ammount = 3, x = x_to_secondary_fire, y = y_to_secondary_fire, counter = 1)
										if(hit_targets != 0)
											terminal_display_line("Targets hit: [hit_targets]")
										else
											terminal_display_line("No impact detected.")
									if("Broadside")
										if(abs(secondary_fire_target_x) + abs(secondary_fire_target_y) > 1 || linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["ship"]["it_tag"] == "none")
											terminal_display_line("No impact detected.")
										else
											linked_master_console.ProcessDamage(ammount = 5, x = x_to_secondary_fire, y = y_to_secondary_fire)
											terminal_display_line("Direct hit detected.")
				else
					terminal_display_line("Error:Secondary Cannon not primed.")
			else
				terminal_display_line("Error: Out of cannon salvos in this interval.")

/obj/structure/terminal/weapons_console/terminal_parse(str)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	var/starting_buffer_length = terminal_buffer.len
	switch(string_to_parse)
		if("HELP")
			terminal_display_line("Available Commands:")
			terminal_display_line("STATUS - Display status of all linked cannons. This is also the welcome screen of this terminal.")
			terminal_display_line("PRIMARY - Firing control for PRIMARY cannon.")
			terminal_display_line("SECONDARY - Firing control for SECONDARY cannon.")
			terminal_display_line("Firing modes are complex operation and each offers individual step-by-step instructions, so no HELP functionality is provided.")
		if("PRIMARY")
			terminal_display_line("Establishing LD Protocol connection to Primary Cannon", TERMINAL_LOOKUP_SLEEP)
			terminal_advanced_parse(type = "PRIMARY")
		if("SECONDARY")
			terminal_display_line("Establishing LD Protocol connection to Primary Cannon", TERMINAL_LOOKUP_SLEEP)
			terminal_advanced_parse(type = "SECONDARY")
	if(starting_buffer_length == terminal_buffer.len) terminal_display_line("Error: Unknown command. Please use HELP for a list of available commands.")
	terminal_input()
	return "Parsing Loop End"

/obj/structure/terminal/weapons_console/attack_hand(mob/user)
	var/primary_status
	if(!linked_primary_cannon)
		primary_status = "OFFLINE"
	else if(linked_primary_cannon.loaded_projectile["loaded"] != 1)
		primary_status = "MISSILE NOT PRIMED, RELOAD NEEDED"
	else
		primary_status = "READY TO FIRE. MISSILE: [uppertext(linked_primary_cannon.loaded_projectile["missile"])]WARHEAD: [uppertext(linked_primary_cannon.loaded_projectile["warhead"])]"
	var/secondary_status
	if(!linked_secondary_cannon)
		secondary_status = "OFFLINE"
	else if(linked_secondary_cannon.loaded_projectile["loaded"] != 1)
		secondary_status = "NO AMMO BOX PRIMED, RELOAD NEEDED"
	else
		secondary_status = "READY TO FIRE. AMMO: [uppertext(linked_secondary_cannon.loaded_projectile["type"])]"
	terminal_display_line("Welcome, [usr.name].")
	terminal_display()
	terminal_display_line("Primary Cannon: [primary_status]")
	terminal_display_line("Secondary Cannon: [secondary_status]")
	terminal_input()
	return "Primary input loop end"
