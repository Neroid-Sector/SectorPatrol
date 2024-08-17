/obj/structure/terminal/weapons_console/
	name = "weapons console"
	item_serial = "-WPN-CNS"
	desc = "A terminal labeled 'Weapons Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 0
	terminal_id = "_weapons_control"
	var/ship_name
	var/repair_shutdown = 0
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

/obj/structure/terminal/weapons_console/proc/SetUsageData(state = 0)
	switch(state)
		if(null)
			return
		if(0)
			usage_data["primary_fired"] = 0
			usage_data["salvos_left"] = usage_data["salvos_max"]
			UpdateMapData()
			return
		if(1)
			usage_data["primary_fired"] = 1
			usage_data["salvos_left"] = 0
			UpdateMapData()
			return

/obj/structure/terminal/weapons_console/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			repair_shutdown = 1
			linked_primary_cannon.repair_shutdown = 1
			linked_secondary_cannon.repair_shutdown = 1
			world << browse(null, "window=[terminal_id]")
			talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
			return
		if(0)
			repair_shutdown = 0
			linked_primary_cannon.repair_shutdown = 0
			linked_secondary_cannon.repair_shutdown = 0
			SetUsageData(1)
			talkas("Critical damage resolved. Lifting lockout.")
			return

/obj/structure/terminal/weapons_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	var/list/area_contents
	for(var/area/areas_to_scan in GLOB.sts_ship_areas)
		area_contents += areas_to_scan.GetAllContents()
	if(!linked_primary_cannon)
		for(var/obj/structure/ship_elements/primary_cannon/cannon_to_link in area_contents)
			if(cannon_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_primary_cannon = cannon_to_link
				to_chat(world, SPAN_INFO("Primary Cannon for ship [linked_master_console.sector_map_data["name"]] loaded."))
				linked_primary_cannon.LeverLink()
				break
	if(!linked_secondary_cannon)
		for(var/obj/structure/ship_elements/secondary_cannon/cannon_to_link in area_contents)
			if(cannon_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_secondary_cannon = cannon_to_link
				to_chat(world, SPAN_INFO("Secondary Cannon for ship [linked_master_console.sector_map_data["name"]] loaded."))
				linked_secondary_cannon.LeverLink()
				break
	terminal_id = "[linked_master_console.sector_map_data["name"]][initial(terminal_id)]"
	item_serial = "[uppertext(linked_master_console.sector_map_data["name"])][initial(item_serial)]"
	UpdateMapData()
	header_name = "[linked_master_console.sector_map_data["name"]] - WEAPONS CONTROL"
	WriteHeader()
	reset_buffer()

/obj/structure/terminal/weapons_console/proc/terminal_advanced_parse(type = null)
	switch(type)
		if(null)
			return
		if("PRIMARY")
			if(usage_data["salvos_left"] > 0)
				if(linked_primary_cannon.loaded_projectile["loaded"] == 1)
					terminal_display_line("Primary Cannon Firing Sequence:")
					terminal_display_line("[linked_primary_cannon.loaded_projectile["name"]] - [linked_primary_cannon.loaded_projectile["missile"]]")
					terminal_display_line("Speed: [linked_primary_cannon.loaded_projectile["speed"]]")
					terminal_display_line("Warhead: [linked_primary_cannon.loaded_projectile["warhead"]]")
					terminal_display_line("Payload: [linked_primary_cannon.loaded_projectile["payload"]]")
					if(linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["missile"]["id_tag"] == "none")
						if(linked_primary_cannon.loaded_projectile["missile"] == "LD Homing")
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
							if(tgui_alert(usr, "READY TO FIRE", "FIRE", list("FIRE","Cancel"), timeout = 0) == "FIRE")
								if(linked_master_console.sector_map[fire_target_x][fire_target_y]["ship"]["vector"]["x"] == fire_target_vector_x && linked_master_console.sector_map[fire_target_x][fire_target_y]["ship"]["vector"]["y"] == fire_target_vector_y && fire_own_x == linked_master_console.sector_map_data["x"] && fire_own_y == linked_master_console.sector_map_data["y"])
									linked_master_console.add_entity(entity_type = 1, x = linked_master_console.sector_map_data["x"], y = linked_master_console.sector_map_data["y"], name = linked_primary_cannon.loaded_projectile["name"] ,type = linked_primary_cannon.loaded_projectile["missile"], vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = linked_primary_cannon.loaded_projectile["warhead"], warhead_payload = linked_primary_cannon.loaded_projectile["payload"], target_tag = linked_master_console.sector_map[fire_target_x][fire_target_y]["ship"]["id_tag"], missile_speed = linked_primary_cannon.loaded_projectile["speed"])
								else
									linked_master_console.add_entity(entity_type = 1, x = linked_master_console.sector_map_data["x"], y = linked_master_console.sector_map_data["y"], name = linked_primary_cannon.loaded_projectile["name"] ,type = linked_primary_cannon.loaded_projectile["missile"], vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = linked_primary_cannon.loaded_projectile["warhead"], warhead_payload = linked_primary_cannon.loaded_projectile["payload"], target_tag = "none", missile_speed = linked_primary_cannon.loaded_projectile["speed"])
								INVOKE_ASYNC(linked_primary_cannon, TYPE_PROC_REF(/obj/structure/ship_elements/primary_cannon, FireCannon))
								terminal_display_line("MISSILE AWAY.")
								usage_data["salvos_left"] -= 1
								usage_data["primary_fired"] = 1
								UpdateMapData()
								terminal_parse("STATUS", no_input = 1)
								linked_master_console.log_round_history(event = "missile_launch", log_source = linked_master_console.sector_map_data["name"], log_dest_x = linked_master_console.sector_map_data["x"], log_dest_y = linked_master_console.sector_map_data["y"])
								for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
									if(ship_sts_to_log.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
										ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_own_launch")
									if(ship_sts_to_log.sector_map_data["name"] != linked_master_console.sector_map_data["name"])
										ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_launch")
						else
							terminal_display_line("Coordinate Targeting mode.")
							var/fire_target_x = tgui_input_number(usr, "Enter TARGET X Coordinate", "TARGET X", max_value = GLOB.sector_map_x * 10, min_value = 1, timeout = 0)
							var/fire_target_y = tgui_input_number(usr, "Enter TARGET Y Coordinate", "TARGET Y", max_value = GLOB.sector_map_y * 10, min_value = 1, timeout = 0)
							terminal_display_line("Entering coordinates...", TERMINAL_LOOKUP_SLEEP)
							terminal_display_line("READY TO FIRE.")
							if(tgui_alert(usr, "READY TO FIRE", "FIRE", list("FIRE","Cancel"), timeout = 0) == "FIRE")
								linked_master_console.add_entity(entity_type = 1, x = linked_master_console.sector_map_data["x"], y = linked_master_console.sector_map_data["y"], name = linked_primary_cannon.loaded_projectile["name"] ,type = linked_primary_cannon.loaded_projectile["missile"], vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = linked_primary_cannon.loaded_projectile["warhead"], warhead_payload = linked_primary_cannon.loaded_projectile["payload"], target_tag = "none", missile_speed = linked_primary_cannon.loaded_projectile["speed"])
								INVOKE_ASYNC(linked_primary_cannon, TYPE_PROC_REF(/obj/structure/ship_elements/primary_cannon, FireCannon))
								terminal_display_line("MISSILE AWAY.")
								usage_data["salvos_left"] -= 1
								usage_data["primary_fired"] = 1
								UpdateMapData()
								terminal_parse("STATUS", no_input = 1)
								linked_master_console.log_round_history(event = "missile_launch", log_source = linked_master_console.sector_map_data["name"], log_dest_x = linked_master_console.sector_map_data["x"], log_dest_y = linked_master_console.sector_map_data["y"])
								for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
									if(ship_sts_to_log.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
										ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_own_launch")
									else
										ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_launch")
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
					else
						if (abs(secondary_fire_target_x) + abs(secondary_fire_target_y) < 3) terminal_display_line("Warning: Expected hit is danger close.")
						var/x_to_secondary_fire = linked_master_console.sector_map_data["x"] + secondary_fire_target_x
						var/y_to_secondary_fire = linked_master_console.sector_map_data["y"] + secondary_fire_target_y
						terminal_display_line("Vector: ([secondary_fire_target_x],[secondary_fire_target_y])")
						terminal_display_line("READY TO FIRE.")
						if(tgui_alert(usr, "READY TO FIRE", "FIRE", list("FIRE","Cancel"), timeout = 0) == "FIRE")
							if(x_to_secondary_fire <= 0 || x_to_secondary_fire > GLOB.sector_map_x || y_to_secondary_fire <= 0 || y_to_secondary_fire > GLOB.sector_map_y)
								terminal_display_line("Error: Coordinates out of bounds. Review current position and target vector")
							else
								var/fired_secondary_ammo = linked_secondary_cannon.loaded_projectile["type"]
								linked_secondary_cannon.FireCannon()
								usage_data["salvos_left"] -= 1
								UpdateMapData()
								terminal_display_line("FIRING.", TERMINAL_STANDARD_SLEEP)
								linked_master_console.log_round_history(event = "secondary_fire", log_source = linked_master_console.sector_map_data["name"], log_dest_x = x_to_secondary_fire, log_dest_y = y_to_secondary_fire)
								for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
									if(ship_sts_to_log.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
										ship_sts_to_log.WriteToShipLog(shiplog_event = "secondary_own_fire")
									else
										ship_sts_to_log.WriteToShipLog(shiplog_event = "secondary_fire")
								switch(fired_secondary_ammo)
									if("Direct")
										if(linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["ship"]["id_tag"] != "none")
											linked_master_console.ProcessDamage(ammount = 2, x = x_to_secondary_fire, y = y_to_secondary_fire)
											terminal_display_line("Direct impact on ship detected.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_hit")
										else if (linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["missile"]["id_tag"] != "none")
											linked_master_console.rem_entity(type = "coord", id = "missile", coord_x = x_to_secondary_fire, coord_y = y_to_secondary_fire)
											terminal_display_line("Direct impact on projectile detected. Projectile destroyed.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_hit")
										else
											terminal_display_line("No impact detected.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_miss")
									if("Flak")
										terminal_display_line("Explosion detected. Analyzing...")
										var/hit_targets = linked_master_console.ProcessSplashDamage(ammount = 3, x = x_to_secondary_fire, y = y_to_secondary_fire, counter = 1)
										if(hit_targets != 0)
											terminal_display_line("Targets hit: [hit_targets]")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_hit")
										else
											terminal_display_line("No impact detected.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_miss")
									if("Broadside")
										if(abs(secondary_fire_target_x) + abs(secondary_fire_target_y) > 1 || linked_master_console.sector_map[x_to_secondary_fire][y_to_secondary_fire]["ship"]["it_tag"] == "none")
											terminal_display_line("No impact detected.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_miss")
										else
											linked_master_console.ProcessDamage(ammount = 5, x = x_to_secondary_fire, y = y_to_secondary_fire)
											terminal_display_line("Direct hit detected.")
											for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log_effect in world)
												if(ship_sts_to_log_effect.sector_map_data["name"] == linked_master_console.sector_map_data["name"])
													ship_sts_to_log_effect.WriteToShipLog(shiplog_event = "secondary_hit")
								terminal_parse("STATUS", no_input = 1)
				else
					terminal_display_line("Error:Secondary Cannon not primed.")
			else
				terminal_display_line("Error: Out of cannon salvos in this interval.")

/obj/structure/terminal/weapons_console/terminal_parse(str, no_input = 0)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	var/starting_buffer_length = terminal_buffer.len
	switch(string_to_parse)
		if("STATUS")
			var/primary_status
			if(linked_primary_cannon.loaded_projectile["loaded"] != 1)
				primary_status = 0
			else
				primary_status = 1
			var/secondary_status
			if(linked_secondary_cannon.loaded_projectile["loaded"] != 1)
				secondary_status = 0
			else
				secondary_status = 1
			switch(primary_status)
				if(null)
					terminal_display_line("Primary Cannon OFFLINE")
				if(1)
					terminal_display_line("Primary Cannon: READY")
				if(0)
					terminal_display_line("Primary Cannon: RELOAD NEEDED")
			switch(secondary_status)
				if(null)
					terminal_display_line("Secondary Cannon OFFLINE")
				if(1)
					terminal_display_line("Secondary Cannon: READY")
				if(0)
					terminal_display_line("Secondary Cannon: RELOAD NEEDED")
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
			terminal_display_line("Establishing LD Protocol connection to Secondary Cannon", TERMINAL_LOOKUP_SLEEP)
			terminal_advanced_parse(type = "SECONDARY")
	if(starting_buffer_length == terminal_buffer.len) terminal_display_line("Error: Unknown command. Please use HELP for a list of available commands.")
	if(no_input == 0) terminal_input()
	return "Parsing Loop End"

/obj/structure/terminal/weapons_console/attack_hand(mob/user)
	if(repair_shutdown == 0)
		terminal_parse("STATUS", no_input = 1)
		terminal_input()
		return "Primary input loop end"
	if(repair_shutdown == 1)
		terminal_display_line("EMERGENCY REPAIR MODE. CRITICAL DAMAGE TO LD SYNCHRONIZATION COILS.")
		terminal_display_line("Terminal disabled. Consult the Damage Control terminal.")
		return
