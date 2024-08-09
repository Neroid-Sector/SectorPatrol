//Sector Patrol Ship to Ship combat master defs. I'm using master defs because GLOBs/Datums sure are fun, but when it comes to actually live editing values in game, being able to VV a controller wihtout any other admin commands is the best chocie I find, and that sollution needs these.area
//Because this thin guses /global/ for the grid, IN THEORY the whole system should work as long as at least one IC console is in game. For obvious reasons assuming that this will always be the case in game is not wise, so this thing will likely exist in game too.
/obj/structure/shiptoship_master
	name = "Ship to Ship Master Control"
	desc = "This shoudnt be in the main IC space, but if you're ghosted and peering behind the secenes, one of these is somewhere in the admin area. Congrats on findng it :p"
	icon = 'icons/sp_default.dmi'
	icon_state = "default"
	var/global/list/sector_map = list()
	var/global/list/round_history = list()
	var/global/list/round_history_current = list()
	var/list/variable_storage = list(
		"stored_x" = 0,
		"stored_y" = 0,
		"stored_tag" = 0,
		)
/obj/structure/shiptoship_master/proc/populate_alpha()
	add_entity (entity_type = 0, x = 40, y = 50, name = "UAS Tester", type = "Testing Vessel", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UACM", ship_damage = 10, ship_shield = 10, ship_speed = 5, salvos = 1)
	add_entity (entity_type = 0, x = 50, y = 50, name = "Stands in Place", type = "Testing Vessel", vector_x = 3, vector_y = -3, ship_status = "Operational", ship_faction = "UPP", ship_damage = 10, ship_shield = 0, ship_speed = 5, salvos = 1)
	add_entity (entity_type = 1, x = 50, y = 50, type = "Direct Scanning Target", vector_x = 10, vector_y = 20, warhead_type = "Direct", warhead_payload = 3, missile_speed = 10)
	add_entity (entity_type = 0, x = 50, y = 51, name = "UAS Moves Around", type = "Testing Vessel", vector_x = 3, vector_y = -3, ship_status = "Operational", ship_faction = "UPP", ship_damage = 10, ship_shield = 0, ship_speed = 5, salvos = 1)
	add_entity (entity_type = 1, x = 49, y = 50, type = "Nuke", vector_x = 100, vector_y = 50, warhead_type = "Nuclear", warhead_payload = 100, missile_speed = 2)
	to_chat(world, SPAN_INFO("Testing data loaded."))

/obj/structure/shiptoship_master/proc/populate_map() // This proc sets up the formatting of each sector, so each additon needs to be reflected here, but most likely in its respective move and remove scripts as well.
	var/current_x = 1
	var/current_y = 1
	while(current_y <= GLOB.sector_map_y)
		while(current_x <= GLOB.sector_map_x)
			sector_map[current_x][current_y] = list(
				"ship" = list(
					"id_tag" = "none",
					"faction" = "none",
					"status" = "none",
					"damage" = list(
						"HP" = 0,
						"engine" = 0,
						"systems" = 0,
						"weapons" = 0,
						"hull" = 0,
						),
					"shield" = 0,
					"name" = "none",
					"type" = "none",
					"vector" = list("x" = 0, "y" = 0,"speed" = 0,),
					"system" = list(
						"has_moved" = 0,
						"movement_left" = 0,
						"processed_movement" = 0,
						"repairs_left" = 0,
						"salvos_max" = 0,
						"salvos_left" = 0,
						),
					),
				"missile" = list(
					"id_tag" = "none",
					"type" = "none",
					"target" = list("x" = 0, "y" = 0, "tag" = "none"),
					"speed" = 0,
					"warhead" = list(
						"type" = "none",
						"payload" = 0,
						),
					"system" = list(
						"processed_movement" = 0,
						"has_moved" = 0,
						"derived_vector_x" = 0,
						"derived_vector_y" = 0,
						),
					),
				"other" = list(
					"special_id" = "none",
					"special_name" = "none",
					"special_type" = "none",
					"special_flavor" = "none",
					),
				)
			current_x += 1
		current_x = 1
		current_y += 1

	to_chat(world, SPAN_INFO("Sector Map Populated and ready for initial setup."))
	return 1

/obj/structure/shiptoship_master/Initialize(mapload, ...)
	. = ..()
	if (GLOB.sector_map_initialized == 0)
		sector_map = new/list(GLOB.sector_map_x, GLOB.sector_map_y)
		if(populate_map() == 1)
			populate_alpha()
			GLOB.sector_map_initialized = 1

/obj/structure/shiptoship_master/proc/add_entity (entity_type = 0, x = 1, y = 1, name = "none", type = "none", vector_x = 0, vector_y = 0, ship_status = "none", ship_faction = "none", ship_damage = 0, ship_shield = 0, ship_speed = 0, salvos = 0, warhead_type = "none", warhead_payload = 0, target_tag = "none", missile_speed = 0) // 0 ships, 1 missiles
	var/coord_x = x
	var/coord_y = y
	var/name_to_apply = name
	var/type_to_apply = type
	var/vector_x_to_apply = vector_x
	var/vector_y_to_apply = vector_y
	var/faction_to_apply = ship_faction
	var/status_to_apply = ship_status
	var/shield_to_apply = ship_shield
	var/damage_to_apply = ship_damage
	var/speed_to_apply = ship_speed
	var/salvos_to_apply = salvos
	var/warhead_to_apply = warhead_type
	var/payload_to_apply = warhead_payload
	var/target_tag_to_apply = target_tag
	var/missile_speed_to_apply = missile_speed
	if(entity_type == 0)
		sector_map[coord_x][coord_y]["ship"]["name"] = name_to_apply
		sector_map[coord_x][coord_y]["ship"]["faction"] = faction_to_apply
		sector_map[coord_x][coord_y]["ship"]["id_tag"] = "[sector_map[coord_x][coord_y]["ship"]["faction"]]-SHIP-[GLOB.sector_map_id_tag]"
		GLOB.sector_map_id_tag += 1
		sector_map[coord_x][coord_y]["ship"]["type"] = type_to_apply
		sector_map[coord_x][coord_y]["ship"]["vector"]["x"] = vector_x_to_apply
		sector_map[coord_x][coord_y]["ship"]["vector"]["y"] = vector_y_to_apply
		sector_map[coord_x][coord_y]["ship"]["vector"]["speed"] = speed_to_apply
		sector_map[coord_x][coord_y]["ship"]["status"] = status_to_apply
		sector_map[coord_x][coord_y]["ship"]["damage"]["HP"] = damage_to_apply
		sector_map[coord_x][coord_y]["ship"]["shield"] = shield_to_apply
		sector_map[coord_x][coord_y]["ship"]["system"]["salvos_max"] = salvos_to_apply
		return
	if(entity_type == 1)
		sector_map[coord_x][coord_y]["missile"]["speed"] = missile_speed_to_apply
		sector_map[coord_x][coord_y]["missile"]["type"] = type_to_apply
		sector_map[coord_x][coord_y]["missile"]["id_tag"] = "MSL-[GLOB.sector_map_id_tag]"
		GLOB.sector_map_id_tag += 1
		sector_map[coord_x][coord_y]["missile"]["warhead"]["type"] = warhead_to_apply
		sector_map[coord_x][coord_y]["missile"]["warhead"]["payload"] = payload_to_apply
		sector_map[coord_x][coord_y]["missile"]["target"]["x"] = vector_x_to_apply
		sector_map[coord_x][coord_y]["missile"]["target"]["y"] = vector_y_to_apply
		sector_map[coord_x][coord_y]["missile"]["target"]["tag"] = target_tag_to_apply
		return

/obj/structure/shiptoship_master/proc/BoundaryAdjust(value = 0, type = 0) // type = 1 for 0, 2 for x max, 3 for y max
	switch(type)
		if(1)
			if(value <= 0)
				return 1
			if(value > 0)
				return value
		if(2)
			if(value > GLOB.sector_map_x)
				return GLOB.sector_map_x
			if(value <= GLOB.sector_map_x)
				return value
		if(3)
			if(value > GLOB.sector_map_y)
				return GLOB.sector_map_y
			if(value <= GLOB.sector_map_y)
				return value

/obj/structure/shiptoship_master/proc/rem_entity(type = null, id = null, coord_x = 0, coord_y = 0) // pass type block as id for coord deletion, in the edge cases where specials shoudl persist, use wipe_specials = 0
	var/selected_type = type
	var/tag_to_remove = id
	if(selected_type == "special") tag_to_remove = selected_type
	if(tag_to_remove == null || selected_type == null) return
	if(selected_type == "id")
		var/current_x = 1
		var/current_y = 1
		while (current_y <= GLOB.sector_map_y)
			while(current_x < GLOB.sector_map_x)
				if(sector_map[current_x][current_y]["ship"]["id_tag"] == tag_to_remove)
					sector_map[current_x][current_y]["ship"]["name"] = "none"
					sector_map[current_x][current_y]["ship"]["id_tag"] = "none"
					sector_map[current_x][current_y]["ship"]["type"] = "none"
					sector_map[current_x][current_y]["ship"]["faction"] = "none"
					sector_map[current_x][current_y]["ship"]["status"] = "none"
					sector_map[current_x][current_y]["ship"]["damage"]["HP"] = 0
					sector_map[current_x][current_y]["ship"]["damage"]["engine"] = 0
					sector_map[current_x][current_y]["ship"]["damage"]["systems"] = 0
					sector_map[current_x][current_y]["ship"]["damage"]["weapons"] = 0
					sector_map[current_x][current_y]["ship"]["damage"]["hull"] = 0
					sector_map[current_x][current_y]["ship"]["shield"] = 0
					sector_map[current_x][current_y]["ship"]["vector"]["x"] = 0
					sector_map[current_x][current_y]["ship"]["vector"]["y"] = 0
					sector_map[current_x][current_y]["ship"]["vector"]["speed"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["has_moved"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["movement_left"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["processed_movement"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["repairs_left"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["salvos_max"] = 0
					sector_map[current_x][current_y]["ship"]["system"]["salvos_left"] = 0
				if(sector_map[current_x][current_y]["missile"]["id_tag"] == tag_to_remove)
					sector_map[current_x][current_y]["missile"]["warhead"]["type"] = "none"
					sector_map[current_x][current_y]["missile"]["warhead"]["patload"] = 0
					sector_map[current_x][current_y]["missile"]["id_tag"] = "none"
					sector_map[current_x][current_y]["missile"]["type"] = "none"
					sector_map[current_x][current_y]["missile"]["speed"] = 0
					sector_map[current_x][current_y]["missile"]["target"]["x"] = 0
					sector_map[current_x][current_y]["missile"]["target"]["y"] = 0
					sector_map[current_x][current_y]["missile"]["target"]["tag"] = "none"
					sector_map[current_x][current_y]["missile"]["system"]["processed_movement"] = 0
					sector_map[current_x][current_y]["missile"]["system"]["has_moved"] = 0
					sector_map[current_x][current_y]["missile"]["system"]["derived_vector_x"] = 0
					sector_map[current_x][current_y]["missile"]["system"]["derived_vector_y"] = 0

				current_x += 1
			current_x = 1
			current_y += 1
	if(selected_type == "coord")
		var/x_to_remove = coord_x
		var/y_to_remove = coord_y
		if(x_to_remove > GLOB.sector_map_x || y_to_remove > GLOB.sector_map_y || x_to_remove < 0 || y_to_remove < 0) return
		if(tag_to_remove == "ship")
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["name"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["id_tag"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["type"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["faction"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["status"] = "none"
			sector_map[x_to_remove][y_to_remove]["ship"]["damage"]["HP"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["damage"]["engine"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["damage"]["systems"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["damage"]["weapons"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["damage"]["hull"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["shield"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["vector"]["x"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["vector"]["y"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["vector"]["speed"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["has_moved"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["movement_left"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["processed_movement"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["repairs_left"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["salvos_max"] = 0
			sector_map[x_to_remove][y_to_remove]["ship"]["system"]["salvos_left"] = 0
			return
		if(tag_to_remove == "missile")
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["warhead"]["type"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["warhead"]["payload"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["id_tag"] = "none"
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["speed"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["target"]["x"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["target"]["y"] = 0
			sector_map[x_to_remove][y_to_remove][tag_to_remove]["target"]["tag"] = 0
			sector_map[x_to_remove][y_to_remove]["missile"]["type"] = "none"
			sector_map[x_to_remove][y_to_remove]["missile"]["system"]["processed_movement"] = 0
			sector_map[x_to_remove][y_to_remove]["missile"]["system"]["has_moved"] = 0
			sector_map[x_to_remove][y_to_remove]["missile"]["system"]["derived_vector_x"] = 0
			sector_map[x_to_remove][y_to_remove]["missile"]["system"]["derived_vector_y"] = 0
			return
	if(selected_type == "special")
		var/current_x = 1
		var/current_y = 1
		while (current_y <= GLOB.sector_map_y)
			while(current_x < GLOB.sector_map_x)
				sector_map[current_x][current_y]["ship"]["system"]["has_moved"] = 0
				sector_map[current_x][current_y]["ship"]["system"]["movement_left"] = 0
				sector_map[current_x][current_y]["ship"]["system"]["processed_movement"] = 0
				sector_map[current_x][current_y]["ship"]["system"]["repairs_left"] = 0
				sector_map[current_x][current_y]["ship"]["system"]["salvos_max"] = 0
				sector_map[current_x][current_y]["ship"]["system"]["salvos_left"] = 0
				sector_map[current_x][current_y]["missile"]["system"]["processed_movement"] = 0
				sector_map[current_x][current_y]["missile"]["system"]["has_moved"] = 0
				sector_map[current_x][current_y]["missile"]["system"]["derived_vector_x"] = 0
				sector_map[current_x][current_y]["missile"]["system"]["derived_vector_y"] = 0
				current_x += 1
			current_x = 1
			current_y += 1

/obj/structure/shiptoship_master/proc/ReturnBearing(x = null, y = null)
	var/x_to_check = x
	var/y_to_check = y
	if(x_to_check == null || y_to_check == null) return
	if(x_to_check == 0 && y_to_check == 0) return "None"
	if(x_to_check < -1)
		if(y_to_check > 1)
			return "NW"
		if(y_to_check < -1)
			return "SW"
	if(x_to_check > 1)
		if(y_to_check > 1)
			return "NE"
		if(y_to_check < -1)
			return "SE"
	if(x_to_check >= -1 && x_to_check <= 1)
		if(y_to_check > 0)
			return "N"
		if(y_to_check < 0)
			return "S"
	if(y_to_check == 0)
		if(x_to_check > 0)
			return "E"
		if(x_to_check < 0)
			return "W"


/obj/structure/shiptoship_master/proc/log_round_history(event = null, log_source = null, log_target = null, log_dest_x = null, log_dest_y = null)
	var/event_to_add = event
	var/log_source_to_add = log_source
	var/log_target_to_add = log_target
	var/x_to_move = log_dest_x
	var/y_to_move = log_dest_y
	if(x_to_move == null) x_to_move = 50
	if(y_to_move == null) y_to_move = 50
	if(event_to_add == null) return
	if(log_source_to_add == null) log_source_to_add = "Unidentified"
	if(log_target_to_add == null) log_target_to_add = "Unidentified"
	for(var/obj/structure/shiptoship_master/ship_missioncontrol/shipmc in world)
		shipmc.WriteToShipLog(shiplog_event = event_to_add, shiplog_dest_x = x_to_move, shiplog_dest_y = y_to_move)
	switch(event_to_add)
		if("collision")
			round_history_current.Add("The <b>[log_source_to_add]</b> barely avoided <b>a collision</b> with the <b>[log_target_to_add]!</b>")
			return
		if("collision_move")
			round_history_current.Add("The <b>[log_source_to_add]</b> reroutes towards coordinates <b>([x_to_move],[y_to_move])</b> during emergency maeouvers, <b>losing some of its momentum.</b>")
			return
		if("collision_boundary")
			round_history_current.Add("The <b>[log_source_to_add]</b> engages its <b>emergency breaking thrusters</b> as it reaches the Twilight Boundary and risks being consumed by the void. <b>It's now in a dead stop!</b>")
			return
		if("regular_move")
			round_history_current.Add("The <b>[log_source_to_add]</b> arrives at its destination at coordinates <b>([x_to_move],[y_to_move])</b>.")
			return
		if("missile_collision")
			round_history_current.Add("Projectiles <b>[log_source_to_add]</b> and <b>[log_target_to_add]</b> <b>detonate each other</b> as they leapfrog out of Hyperspace in close proximity.")
			return
		if("missile_move")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> leapfrogs to coordinates <b>([x_to_move],[y_to_move])</b>.")
			return
		if("missile_near_target")
			round_history_current.Add("The projectile <b>will reach its target next round!</b>")
			return
		if("missile_homing_bad_target")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> fails to find its target. <b>The projectile is lost.</b>")
			return
		if("warhead_homing")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> arrives at its destination and <b>looks for a new target...</b>")
			return
		if("warhead_hit")
			round_history_current.Add("Projectile <b>[log_source_to_add] strikes a target!</b>")
			return
		if("hit_shield")
			round_history_current.Add("The <b>[log_source_to_add]</b> takes <b>[x_to_move] damage</b> to its shields!")
			return
		if("shield_break")
			round_history_current.Add("<b>The shield breaks!</b>")
			return
		if("hit_engine")
			round_history_current.Add("The <b>[log_source_to_add]</b> takes <b>[x_to_move] damage</b> to its engines!")
			return
		if("hit_systems")
			round_history_current.Add("The <b>[log_source_to_add]</b> takes <b>[x_to_move] damage</b> to its systems!")
			return
		if("hit_weapons")
			round_history_current.Add("The <b>[log_source_to_add]</b> takes <b>[x_to_move] damage</b> to its weapons!")
			return
		if("hit_hull")
			round_history_current.Add("The <b>[log_source_to_add]</b> takes <b>[x_to_move] damage</b> to its hull!")
			return
		if("destroy_complete")
			round_history_current.Add("The <b>[log_source_to_add]</b> suffers cascading failure from multiple systems and is <b>torn apart in the resulting explosions!</b> There are no survivors.")
			return
		if("destroy_engine")
			round_history_current.Add("The engine of the <b>[log_source_to_add]</b> ruptures and explodes, discharging its Twilight Paradox cells and <b>leaving the ship adrift.</b> The ship launches its escape pods.")
			return
		if("destroy_systems")
			round_history_current.Add("The systems of the <b>[log_source_to_add]</b> suffer from a cascading discharge and fail one by one. With its transponder and engine controls fried, <b>the ship is coffin adrift in the void</b> and launches its escape pods.")
			return
		if("destroy_weapons")
			round_history_current.Add("After suffering a direct hit, the ammo stores of the <b>[log_source_to_add]</b> explode, killing anyone nearby. <b>With a significant part of its hull now gone, the ship's fate is sealed.</b> The surviving crew evacuates. ")
			return
		if("destroy_hull")
			round_history_current.Add("The hull of the <b>[log_source_to_add]</b> ruptures and <b>a significant part of the ship is detached.</b> Anyone who was nearby is dead, and the remaining crewmembers are now adrift in a derelict coffin. Some reach the escape pods.")
			return
		if("missile_hit_splash")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> is <b>anihilated in an explosion!</b>")
			return
		if("explosive_splash")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> explodes at coordinates <b>([x_to_move],[y_to_move])!</b>")
			return
		if("warhead_miss")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> fails to hit anything at coordinates <b>([x_to_move],[y_to_move])</b> and flies off into the void.")
			return
		if("nuclear_hit")
			round_history_current.Add("Projectile <b>[log_source_to_add]</b> reaches its target at coordinates <b>([x_to_move],[y_to_move])</b>. The <b>[log_target_to_add] and its crew perishes in a nuclear blast!</b>")
			return
		if("ship_move")
			round_history_current.Add("<b>SHIP MOVEMENT:</b><hr>")
			return
		if("missile_move")
			round_history_current.Add("<b>PROJECTILE MOVEMENT AND DETONATION:</b><hr>")
			return
		if("comms_ping")
			round_history_current.Add("Comms ping sent from <b>[log_source_to_add]</b> to coordinates ([x_to_move],[y_to_move]): [log_target_to_add]")
			message_admins("Comms message sent from [log_source_to_add]: [log_target_to_add].")
			return

/obj/structure/shiptoship_master/proc/move_on_map(type_to_move = null, origin_x = 0, origin_y = 0, target_x = 0, target_y = 0) // Actually move the ship on grid. Will account for boudaries and "bump" ships away form them, at cost of losing all velocity. Different formulas are used for ships and projectiles, so make sure to pass the right type. For type "ship", pass ship vector as destination_x/y
	var/selected_type = type_to_move
	var/move_starting_x = origin_x
	var/move_starting_y = origin_y
	var/move_target_x = target_x
	var/move_target_y = target_y
	if(selected_type == null || move_starting_x == null || move_starting_y == null || target_x == null || target_y == null) return
	switch(selected_type)
		if("ship")
			var/final_x = move_starting_x + move_target_x
			var/final_y = move_starting_y + move_target_y
			if(final_x > GLOB.sector_map_x || final_x < 1 || final_y < 1 || final_y > GLOB.sector_map_y)
				log_round_history(event = "collision_boundary", log_source = sector_map[move_starting_x][move_starting_y][selected_type]["name"], log_dest_x = final_x, log_dest_y = final_y)
				sector_map[move_starting_x][move_starting_y][selected_type]["vector"]["x"] = 0
				sector_map[move_starting_x][move_starting_y][selected_type]["vector"]["y"] = 0
				if(final_x > GLOB.sector_map_x)
					final_x = GLOB.sector_map_x
				if(final_y > GLOB.sector_map_y)
					final_y = GLOB.sector_map_y
				if(final_x <= 0)
					final_x = 1
				if(final_y <= 0)
					final_y = 1
			sector_map[final_x][final_y][selected_type]["name"] = sector_map[move_starting_x][move_starting_y][selected_type]["name"]
			sector_map[final_x][final_y][selected_type]["id_tag"] = sector_map[move_starting_x][move_starting_y][selected_type]["id_tag"]
			sector_map[final_x][final_y][selected_type]["type"] = sector_map[move_starting_x][move_starting_y][selected_type]["type"]
			sector_map[final_x][final_y][selected_type]["faction"] = sector_map[move_starting_x][move_starting_y][selected_type]["faction"]
			sector_map[final_x][final_y][selected_type]["status"] = sector_map[move_starting_x][move_starting_y][selected_type]["status"]
			sector_map[final_x][final_y][selected_type]["damage"]["HP"] = sector_map[move_starting_x][move_starting_y][selected_type]["damage"]["HP"]
			sector_map[final_x][final_y][selected_type]["damage"]["engine"] = sector_map[move_starting_x][move_starting_y][selected_type]["damage"]["engine"]
			sector_map[final_x][final_y][selected_type]["damage"]["systems"] = sector_map[move_starting_x][move_starting_y][selected_type]["damage"]["systems"]
			sector_map[final_x][final_y][selected_type]["damage"]["weapons"] = sector_map[move_starting_x][move_starting_y][selected_type]["damage"]["weapons"]
			sector_map[final_x][final_y][selected_type]["damage"]["hull"] = sector_map[move_starting_x][move_starting_y][selected_type]["damage"]["hull"]
			sector_map[final_x][final_y][selected_type]["shield"] = sector_map[move_starting_x][move_starting_y][selected_type]["shield"]
			sector_map[final_x][final_y][selected_type]["vector"]["x"] = sector_map[move_starting_x][move_starting_y][selected_type]["vector"]["x"]
			sector_map[final_x][final_y][selected_type]["vector"]["y"] = sector_map[move_starting_x][move_starting_y][selected_type]["vector"]["y"]
			sector_map[final_x][final_y][selected_type]["vector"]["speed"] = sector_map[move_starting_x][move_starting_y][selected_type]["vector"]["speed"]
			sector_map[final_x][final_y][selected_type]["system"]["has_moved"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["has_moved"]
			sector_map[final_x][final_y][selected_type]["system"]["movement_left"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["movement_left"]
			sector_map[final_x][final_y][selected_type]["system"]["processed_movement"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["processed_movement"]
			sector_map[final_x][final_y][selected_type]["system"]["repairs_left"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["repairs_left"]
			sector_map[final_x][final_y][selected_type]["system"]["salvos_max"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["salvos_max"]
			sector_map[final_x][final_y][selected_type]["system"]["salvos_left"] = sector_map[move_starting_x][move_starting_y][selected_type]["system"]["salvos_left"]
			sector_map[final_x][final_y][selected_type]["system"]["processed_movement"] = 1
			rem_entity(type = "coord", id = selected_type, coord_x = move_starting_x, coord_y = move_starting_y)
			log_round_history(event = "regular_move", log_source = sector_map[final_x][final_y][selected_type]["name"], log_dest_x = final_x, log_dest_y = final_y)
			return 1
		if("missile")
			sector_map[move_target_x][move_target_y][selected_type]["id_tag"] = sector_map[move_starting_x][move_starting_y][selected_type]["id_tag"]
			sector_map[move_target_x][move_target_y][selected_type]["type"] = sector_map[move_starting_x][move_starting_y][selected_type]["type"]
			sector_map[move_target_x][move_target_y][selected_type]["target"]["x"] = sector_map[move_starting_x][move_starting_y][selected_type]["target"]["x"]
			sector_map[move_target_x][move_target_y][selected_type]["target"]["y"] = sector_map[move_starting_x][move_starting_y][selected_type]["target"]["y"]
			sector_map[move_target_x][move_target_y][selected_type]["target"]["tag"] = sector_map[move_starting_x][move_starting_y][selected_type]["target"]["tag"]
			sector_map[move_target_x][move_target_y][selected_type]["speed"] = sector_map[move_starting_x][move_starting_y][selected_type]["speed"]
			sector_map[move_target_x][move_target_y][selected_type]["warhead"]["type"] = sector_map[move_starting_x][move_starting_y][selected_type]["warhead"]["type"]
			sector_map[move_target_x][move_target_y][selected_type]["warhead"]["payload"] = sector_map[move_starting_x][move_starting_y][selected_type]["warhead"]["payload"]
			sector_map[move_target_x][move_target_y][selected_type]["system"]["processed_movement"] = 1
			sector_map[move_target_x][move_target_y][selected_type]["system"]["has_moved"] = 1
			rem_entity(type = "coord", id = selected_type, coord_x = move_starting_x, coord_y = move_starting_y)
			log_round_history(event = "missile_move", log_source = "[sector_map[move_target_x][move_target_y][selected_type]["type"]] [sector_map[move_target_x][move_target_y][selected_type]["id_tag"]]", log_dest_x = move_target_x, log_dest_y = move_target_y)
			return 1



/obj/structure/shiptoship_master/proc/missileReTarget(missile_x = 0, missile_y = 0, missile_range = 0, x = 0, y = 0, id_tag = "none", quiet = 0)
	var/range_to_scan = missile_range
	var/missile_origin_x = missile_x
	var/missile_origin_y = missile_y
	var/x_to_scan = x
	var/y_to_scan = y
	var/id_tag_to_scan = id_tag
	if(range_to_scan == 0 || x_to_scan == 0 || y_to_scan == 0 || missile_origin_x == 0 || missile_origin_y == 0) return
	var/x_to_scan_min = BoundaryAdjust(value = (x_to_scan - range_to_scan), type = 1)
	var/y_to_scan_min = BoundaryAdjust(value = (y_to_scan - range_to_scan), type = 1)
	var/x_to_scan_max = BoundaryAdjust(value = (x_to_scan + range_to_scan), type = 2)
	var/y_to_scan_max = BoundaryAdjust(value = (y_to_scan + range_to_scan), type = 3)
	var/scan_target_x = x_to_scan_min
	var/scan_target_y = y_to_scan_min
	var/scanning_complete = 0
	while(scan_target_y <= y_to_scan_max)
		while(scan_target_x <= x_to_scan_max)
			if(id_tag_to_scan != "none")
				if(sector_map[scan_target_x][scan_target_y]["ship"]["id_tag"] == id_tag_to_scan)
					sector_map[missile_origin_x][missile_origin_y]["missile"]["target"]["x"] = scan_target_x
					sector_map[missile_origin_x][missile_origin_y]["missile"]["target"]["y"] = scan_target_y
					scanning_complete = 1
			if(sector_map[scan_target_x][scan_target_y]["ship"]["id_tag"] != "none")
				sector_map[missile_origin_x][missile_origin_y]["missile"]["target"]["x"] = scan_target_x
				sector_map[missile_origin_x][missile_origin_y]["missile"]["target"]["y"] = scan_target_y
				scanning_complete = 1
			if(scanning_complete == 1) break
			scan_target_x += 1
		if(scanning_complete == 1) break
		scan_target_x = x_to_scan_min
		scan_target_y += 1
	if(scanning_complete == 1)
		sector_map[missile_origin_x][missile_origin_y]["missile"]["system"]["processed_movement"] = 1
		sector_map[missile_origin_x][missile_origin_y]["missile"]["system"]["has_moved"] = 1
	if(scanning_complete == 0)
		if(quiet == 0)log_round_history(event = "missile_homing_bad_target", log_source = "[sector_map[missile_origin_x][missile_origin_y]["missile"]["type"]] - [sector_map[missile_origin_x][missile_origin_y]["missile"]["id_tag"]]")
		rem_entity(type = "coord", id = "missile", coord_x = missile_origin_x, coord_y = missile_origin_y)
	return 1


/obj/structure/shiptoship_master/proc/CheckCollision(type = null, x = null, y = null)
	var/x_to_check = x
	var/y_to_check = y
	var/type_to_check = type
	if(x_to_check == null || y_to_check == null || type_to_check == null) return
	if(x_to_check > GLOB.sector_map_x) x_to_check = GLOB.sector_map_x
	if(y_to_check > GLOB.sector_map_x) y_to_check = GLOB.sector_map_x
	if(x_to_check <= 0) x_to_check = 1
	if(y_to_check <= 0) y_to_check = 1
	if(sector_map[x_to_check][y_to_check][type_to_check]["id_tag"] != "none")
		return 1
	if(sector_map[x_to_check][y_to_check][type_to_check]["id_tag"] == "none")
		return 0

/obj/structure/shiptoship_master/proc/CollisionMove(move_source_x = 0, move_source_y = 0, move_destination_x = 0, move_destination_y = 0)
	var/moving_source_x = move_source_x
	var/moving_source_y = move_source_y
	var/moving_destination_x = move_destination_x
	var/moving_destination_y = move_destination_y
	if(moving_source_x <= 0 || moving_source_y <= 0 ||moving_destination_x <= 0 ||moving_destination_y <= 0) return
	while(CheckCollision(type = "ship", x = moving_destination_x, y = moving_destination_y) == 1)
		switch(ReturnBearing(x = sector_map[move_source_x][move_source_y]["ship"]["vector"]["x"], y = sector_map[move_source_x][move_source_y]["ship"]["vector"]["x"]))
			if("NW")
				moving_destination_x += 1
				if(CheckCollision(type = "ship", x = moving_destination_x, y = moving_destination_y) == 0) break
				moving_destination_y -= 1
			if("SW")
				moving_destination_x += 1
				if(CheckCollision(type = "ship", x = moving_destination_x, y = moving_destination_y) == 0) break
				moving_destination_y += 1
			if("NE")
				moving_destination_x -= 1
				if(CheckCollision(type = "ship", x = moving_destination_x, y = moving_destination_y) == 0) break
				moving_destination_y -= 1
			if("SE")
				moving_destination_x -= 1
				if(CheckCollision(type = "ship", x = moving_destination_x, y = moving_destination_y) == 0) break
				moving_destination_y += 1
			if("N")
				moving_destination_y -= 1
			if("S")
				moving_destination_y += 1
			if("E")
				moving_destination_x -= 1
			if("W")
				moving_destination_x += 1
	sector_map[moving_source_x][moving_source_y]["ship"]["vector"]["x"] = moving_destination_x - moving_source_x
	sector_map[moving_source_x][moving_source_y]["ship"]["vector"]["y"] = moving_destination_y - moving_source_y
	log_round_history(event = "collision_move", log_source = sector_map[move_source_x][move_source_y]["ship"]["name"], log_target = sector_map[moving_destination_x][moving_destination_y]["ship"]["name"], log_dest_x = moving_destination_x, log_dest_y = moving_destination_y)
	move_on_map(type_to_move = "ship", origin_x = moving_source_x, origin_y = moving_source_y, target_x = sector_map[moving_source_x][moving_source_y]["ship"]["vector"]["x"], target_y = sector_map[moving_source_x][moving_source_y]["ship"]["vector"]["y"])
	return 1

/obj/structure/shiptoship_master/proc/DisplayAndCycleSpaceRoundLog()
	var/log_display = jointext(round_history_current, "</p><p>")
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	}
	#main_window {
	font-family: 'Lucida Grande', monospace;
	font-size: 18px;
	color: #ffffff;
	text-align: center;
	padding: 0em 1em;
	}
	</style>
	</head>
	<body>
	<div id="main_window">
	<p style="font-size: 120%;">
	<b>SECTOR PATROL ALPHA</b>
	</p>
	<hr>
	<p>
	End or Round [GLOB.combat_round]:<br>
	</p>
	<hr>
	<p>[log_display]</p>
	<hr>
	</div>
	</body>
	"}
	world << browse(terminal_html,"window=log_display;display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	round_history.Add("[GLOB.combat_round]",round_history_current)
	round_history_current = list()
	GLOB.combat_round += 1
	rem_entity(type = "special")

/obj/structure/shiptoship_master/proc/missileVector(start_x = 0, start_y = 0, target_x = 0, target_y = 0, speed = 0, only_test = 0)
	var/missile_x = start_x
	var/missile_y = start_y
	var/missile_target_x = target_x
	var/missile_target_y = target_y
	var/missile_speed = speed
	var/missile_displacement_x = missile_speed / 2
	var/missile_displacement_y = floor(missile_speed / 2)
	if(missile_x == 0 || missile_y == 0 || missile_speed == 0 || missile_target_x == 0 || missile_target_y == 0) return
	var/distance_x = abs(target_x - start_x)
	var/distance_y = abs(target_y - start_y)
	if((distance_x + distance_y) <= missile_speed) return "in_range"
	if(only_test == 0)
		if((distance_x - missile_displacement_x) > 0)
			if((missile_target_x - missile_x) > 0)
				sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_x"] = missile_displacement_x
			if((missile_target_x - missile_x) < 0)
				sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_x"] = 0 - missile_displacement_x
		if((distance_x - missile_displacement_x) <= 0 ) sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_x"] = distance_x
		if((distance_y - missile_displacement_y) > 0)
			if((missile_target_y - missile_x) > 0)
				sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_y"] = missile_displacement_y
			if((missile_target_y - missile_x) < 0)
				sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_y"] = 0 - missile_displacement_y
		if((distance_y - missile_displacement_y) <= 0 ) sector_map[missile_x][missile_y]["missile"]["system"]["derived_vector_y"] = distance_y
		return 1
	return 0

/obj/structure/shiptoship_master/proc/DestructionCheck(x = 0, y = 0)
	var/x_to_destroy = x
	var/y_to_destroy = y
	if(x_to_destroy == 0 || y_to_destroy == 0) return
	var/damage_engine = sector_map[x_to_destroy][y_to_destroy]["ship"]["damage"]["engine"]
	var/damage_systems = sector_map[x_to_destroy][y_to_destroy]["ship"]["damage"]["systems"]
	var/damage_weapons = sector_map[x_to_destroy][y_to_destroy]["ship"]["damage"]["weapons"]
	var/damage_hull = sector_map[x_to_destroy][y_to_destroy]["ship"]["damage"]["hull"]
	var/damage_to_check = damage_engine + damage_systems + damage_weapons + damage_hull
	if(damage_to_check >= sector_map[x_to_destroy][y_to_destroy]["ship"]["damage"]["HP"])
		if(damage_engine > damage_systems && damage_engine > damage_weapons && damage_engine > damage_hull)
			log_round_history(event = "destroy_engine", log_source = sector_map[x_to_destroy][y_to_destroy]["ship"]["name"])
			rem_entity(type = "coord", id = "ship", coord_x = x_to_destroy, coord_y = y_to_destroy)
			return
		if(damage_systems > damage_engine && damage_systems > damage_weapons && damage_systems > damage_hull)
			log_round_history(event = "destroy_systems", log_source = sector_map[x_to_destroy][y_to_destroy]["ship"]["name"])
			rem_entity(type = "coord", id = "ship", coord_x = x_to_destroy, coord_y = y_to_destroy)
			return
		if(damage_weapons > damage_systems && damage_weapons > damage_engine && damage_weapons > damage_hull)
			log_round_history(event = "destroy_weapons", log_source = sector_map[x_to_destroy][y_to_destroy]["ship"]["name"])
			rem_entity(type = "coord", id = "ship", coord_x = x_to_destroy, coord_y = y_to_destroy)
			return
		if(damage_hull > damage_systems && damage_hull > damage_weapons && damage_hull > damage_engine)
			log_round_history(event = "destroy_hull", log_source = sector_map[x_to_destroy][y_to_destroy]["ship"]["name"])
			rem_entity(type = "coord", id = "ship", coord_x = x_to_destroy, coord_y = y_to_destroy)
			return
		log_round_history(event = "destroy_complete", log_source = sector_map[x_to_destroy][y_to_destroy]["ship"]["name"])
		rem_entity(type = "coord", id = "ship", coord_x = x_to_destroy, coord_y = y_to_destroy)
		return

/obj/structure/shiptoship_master/proc/ProcessSplashDamage(ammount = 0, x = 0, y = 0, counter = 0)
	var/ship_splash_damage_payload = ammount
	var/x_to_splash_damage = x
	var/y_to_splash_damage = y
	var/output_counter = 0
	if(ship_splash_damage_payload == 0||x_to_splash_damage == 0||y_to_splash_damage == 0) return
	var/x_to_splash_damage_max = BoundaryAdjust(value = (x_to_splash_damage + (ship_splash_damage_payload - 1)), type = 2)
	var/x_to_splash_damage_min = BoundaryAdjust(value = (x_to_splash_damage - (ship_splash_damage_payload + 1)), type = 1)
	var/y_to_splash_damage_max = BoundaryAdjust(value = (y_to_splash_damage + (ship_splash_damage_payload - 1)), type = 3)
	var/y_to_splash_damage_min = BoundaryAdjust(value = (y_to_splash_damage - (ship_splash_damage_payload + 1)), type = 1)
	if(sector_map[x_to_splash_damage][y_to_splash_damage]["ship"]["id_tag"] != "none")
		ProcessDamage(ammount = ship_splash_damage_payload, x = x_to_splash_damage, y = y_to_splash_damage)
		if(counter == 1) output_counter += 1
	var/current_x_splash = x_to_splash_damage_min
	var/current_y_splash = y_to_splash_damage_min
	while(current_x_splash < x_to_splash_damage_max)
		while(current_y_splash < y_to_splash_damage_max)
			var/damage_to_splash = ship_splash_damage_payload - (abs(y_to_splash_damage - current_y_splash) + abs(x_to_splash_damage - current_x_splash))
			if(damage_to_splash > 0)
				if(sector_map[current_x_splash][current_y_splash]["ship"]["id_tag"] != "none")
					ProcessDamage(ammount = damage_to_splash, x = current_x_splash, y = current_y_splash)
					if(counter == 1) output_counter += 1
				if(sector_map[current_x_splash][current_y_splash]["missile"]["id_tag"] != "none")
					log_round_history(event = "missile_hit_splash", log_source = "[sector_map[current_x_splash][current_y_splash]["missile"]["type"]] - [sector_map[current_x_splash][current_y_splash]["missile"]["id_tag"]]")
					rem_entity(type = "coord", id = "missile", coord_x = current_x_splash, coord_y = current_y_splash)
					if(counter == 1) output_counter += 1
			current_y_splash += 1
		current_x_splash += 1
	if (counter == 0) return 1
	if (counter == 1) return output_counter


/obj/structure/shiptoship_master/proc/ProcessDamage(ammount = 0, x = 0, y = 0)
	var/ship_damage_payload = ammount
	var/x_to_damage = x
	var/y_to_damage = y
	if(ship_damage_payload == 0||x_to_damage == 0||y_to_damage == 0) return
	if(sector_map[x_to_damage][y_to_damage]["ship"]["shield"] > 0)
		log_round_history(event = "hit_shield", log_source = sector_map[x_to_damage][y_to_damage]["ship"]["name"], log_dest_x = ship_damage_payload)
		sector_map[x_to_damage][y_to_damage]["ship"]["shield"] -= ship_damage_payload
		if(sector_map[x_to_damage][y_to_damage]["ship"]["shield"] <= 0)
			sector_map[x_to_damage][y_to_damage]["ship"]["shield"] = 0
			log_round_history(event = "shield_break")
		return 1
	if(sector_map[x_to_damage][y_to_damage]["ship"]["shield"] == 0)
		var/damage_roulette = rand(1,4)
		switch(damage_roulette)
			if(1)
				sector_map[x_to_damage][y_to_damage]["ship"]["damage"]["engine"] += ship_damage_payload
				log_round_history(event = "hit_engine", log_source = sector_map[x_to_damage][y_to_damage]["ship"]["name"], log_dest_x = ship_damage_payload)
			if(2)
				sector_map[x_to_damage][y_to_damage]["ship"]["damage"]["systems"] += ship_damage_payload
				log_round_history(event = "hit_systems", log_source = sector_map[x_to_damage][y_to_damage]["ship"]["name"], log_dest_x = ship_damage_payload)
			if(3)
				sector_map[x_to_damage][y_to_damage]["ship"]["damage"]["weapons"] += ship_damage_payload
				log_round_history(event = "hit_weapons", log_source = sector_map[x_to_damage][y_to_damage]["ship"]["name"], log_dest_x = ship_damage_payload)
			if(4)
				sector_map[x_to_damage][y_to_damage]["ship"]["damage"]["hull"] += ship_damage_payload
				log_round_history(event = "hit_hull", log_source = sector_map[x_to_damage][y_to_damage]["ship"]["name"], log_dest_x = ship_damage_payload)
		if(sector_map[x_to_damage][y_to_damage]["ship"]["status"] != "Player") DestructionCheck(x = x_to_damage, y = y_to_damage)
		return 1

/obj/structure/shiptoship_master/proc/missileColide(arriving_missile_x = 0, arriving_missile_y = 0, other_missile_x = 0, other_missile_y = 0)
	var/missile1_x = arriving_missile_x
	var/missile1_y = arriving_missile_y
	var/missile2_x = other_missile_x
	var/missile2_y = other_missile_y
	if(missile1_x == 0 || missile1_y == 0 || missile2_x == 0 || missile2_y == 0) return
	log_round_history(event = "missile_collision", log_source = "[sector_map[missile1_x][missile1_y]["missile"]["type"]] - [sector_map[missile1_x][missile1_y]["missile"]["id_tag"]]", log_target = "[sector_map[missile2_x][missile2_y]["missile"]["type"]] - [sector_map[missile2_x][missile2_y]["missile"]["id_tag"]]", log_dest_x = missile2_x, log_dest_y = missile2_y)
	rem_entity(type = "coord", id = "missile", coord_x = arriving_missile_x, coord_y = arriving_missile_y)
	rem_entity(type = "coord", id = "missile", coord_x = missile2_x, coord_y = missile2_y)

/obj/structure/shiptoship_master/proc/missileWarhead(target_x = 0, target_y = 0, origin_x = 0, origin_y = 0)
	var/x_to_explode = target_x
	var/y_to_explode = target_y
	var/exploding_missile_x = origin_x
	var/exploding_missile_y = origin_y
	if(x_to_explode == 0 || y_to_explode == 0 || exploding_missile_x == 0 || exploding_missile_y == 0) return
	switch(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["type"])
		if("Homing")
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] == "none")
				log_round_history(event = "warhead_homing", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_dest_x = x_to_explode, log_dest_y = y_to_explode)
				missileReTarget(missile_x = exploding_missile_x, missile_y = exploding_missile_y, missile_range = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["speed"], x = x_to_explode, y = y_to_explode, id_tag = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"], quiet = 0)
				return 1
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] != "none")
				if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"] == "none")
					log_round_history(event = "warhead_hit", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]")
					if(ProcessDamage(ammount = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["payload"], x = x_to_explode, y = y_to_explode) == 1)
						rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
						return 1
				if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"] != "none")
					if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"] == sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"])
						if(ProcessDamage(ammount = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["payload"], x = x_to_explode, y = y_to_explode) == 1)
							rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
							return 1
					if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"] != sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"])
						log_round_history(event = "warhead_homing", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_dest_x = x_to_explode, log_dest_y = y_to_explode)
						missileReTarget(missile_x = exploding_missile_x, missile_y = exploding_missile_y, missile_range = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["speed"], x = x_to_explode, y = y_to_explode, id_tag = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["target"]["tag"], quiet = 0)
						return 1
		if("Explosive")
			if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["system"]["processed_movement"] == 1)
				log_round_history(event = "explosive_splash", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_target = "sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["payload"]", log_dest_x = x_to_explode, log_dest_y = y_to_explode)
				var/splash_passed_ammount = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["payload"]
				rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
				ProcessSplashDamage(ammount = splash_passed_ammount, x = x_to_explode, y = y_to_explode)
			if(sector_map[exploding_missile_x][exploding_missile_y]["missile"]["system"]["processed_movement"] == 0) sector_map[exploding_missile_x][exploding_missile_y]["missile"]["system"]["processed_movement"] = 1
			return 1
		if("Direct")
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] != "none")
				log_round_history(event = "warhead_hit", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]")
				if(ProcessDamage(ammount = sector_map[exploding_missile_x][exploding_missile_y]["missile"]["warhead"]["payload"], x = x_to_explode, y = y_to_explode) == 1)
					rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
					return 1
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] == "none")
				log_round_history(event = "warhead_miss", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_dest_x = x_to_explode, log_dest_y = y_to_explode)
				rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
				return 1
		if("Nuclear")
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] != "none")
				log_round_history(event = "nuclear_hit", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_target = sector_map[x_to_explode][y_to_explode]["ship"]["name"], log_dest_x = x_to_explode, log_dest_y = y_to_explode)
				rem_entity(type = "coord", id = "ship", coord_x = x_to_explode, coord_y = y_to_explode)
				rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
				return 1
			if(sector_map[x_to_explode][y_to_explode]["ship"]["id_tag"] == "none")
				log_round_history(event = "warhead_miss", log_source = "[sector_map[exploding_missile_x][exploding_missile_y]["missile"]["type"]] - [sector_map[exploding_missile_x][exploding_missile_y]["missile"]["id_tag"]]", log_dest_x = x_to_explode, log_dest_y = y_to_explode)
				rem_entity(type = "coord", id = "missile", coord_x = exploding_missile_x, coord_y = exploding_missile_y)
				return 1

/obj/structure/shiptoship_master/proc/ProcessMovement(type = null)
	var/type_to_process = type
	if(type_to_process == null) return
	var/destination_x = 0
	var/destination_y = 0
	var/current_x = 1
	var/current_y = 1
	if(type_to_process == "ship")
		while (current_y <= GLOB.sector_map_y)
			while(current_x <= GLOB.sector_map_x)
				if(sector_map[current_x][current_y][type_to_process]["id_tag"] != "none")
					if(sector_map[current_x][current_y]["ship"]["system"]["processed_movement"] != 1)
						destination_x = current_x + sector_map[current_x][current_y][type_to_process]["vector"]["x"]
						destination_y = current_y + sector_map[current_x][current_y][type_to_process]["vector"]["y"]
						if((sector_map[current_x][current_y][type_to_process]["vector"]["x"] + sector_map[current_x][current_y][type_to_process]["vector"]["y"]) != 0)
							if(CheckCollision(type = type_to_process, x = destination_x, y = destination_y) == 1)
								if(sector_map[destination_x][destination_y][type_to_process]["system"]["processed_movement"] == 1)
									log_round_history(event = "collision", log_source = sector_map[current_x][current_y][type_to_process]["name"], log_target = sector_map[destination_x][current_y][type_to_process]["name"],log_dest_x = destination_x, log_dest_y = destination_y)
									CollisionMove(move_source_x = current_x, move_source_y = current_y, move_destination_x = destination_x, move_destination_y = destination_y)
							if(CheckCollision(type = type_to_process, x = destination_x, y = destination_y) == 0)
								move_on_map(type_to_move = type_to_process, origin_x = current_x, origin_y = current_y, target_x = sector_map[current_x][current_y][type_to_process]["vector"]["x"], target_y = sector_map[current_x][current_y][type_to_process]["vector"]["y"])
					if((sector_map[current_x][current_y][type_to_process]["vector"]["x"] + sector_map[current_x][current_y][type_to_process]["vector"]["y"]) == 0)
						sector_map[current_x][current_y]["ship"]["system"]["processed_movement"] = 1
				current_x += 1
			current_x = 1
			current_y += 1
		return 1
	if(type_to_process == "missile")
		while(current_y <= GLOB.sector_map_y)
			while(current_x <= GLOB.sector_map_x)
				if(sector_map[current_x][current_y][type_to_process]["id_tag"] != "none")
					switch(missileVector(start_x = current_x, start_y = current_y, target_x = sector_map[current_x][current_y][type_to_process]["target"]["x"], target_y = sector_map[current_x][current_y][type_to_process]["target"]["y"], speed = sector_map[current_x][current_y][type_to_process]["speed"]))
						if(1)
							if(sector_map[current_x][current_y][type_to_process]["system"]["processed_movement"] == 0)
								destination_x = current_x + sector_map[current_x][current_y][type_to_process]["system"]["derived_vector_x"]
								destination_y = current_y + sector_map[current_x][current_y][type_to_process]["system"]["derived_vector_y"]
								switch(CheckCollision(type = "missile", x = destination_x, y = destination_y))
									if(1)
										if(sector_map[destination_x][destination_y][type_to_process]["system"]["processed_movement"] == 1)
											missileColide(arriving_missile_x = current_x, arriving_missile_y = current_y, other_missile_x = destination_x, other_missile_y = destination_y)
									if(0)
										if(move_on_map(type_to_move = type_to_process, origin_x = current_x, origin_y = current_y, target_x = destination_x, target_y = destination_y) == 1)
											if(sector_map[destination_x][destination_y][type_to_process]["type"] == "PST-ATCM")
												if(sector_map[destination_x][destination_y][type_to_process]["target"]["tag"] != "none")
													missileReTarget(missile_x = current_x, missile_y = current_y, missile_range = (GLOB.sector_map_x + GLOB.sector_map_y), x = (GLOB.sector_map_x / 2), y = (GLOB.sector_map_y / 2), id_tag = sector_map[current_x][current_y][type_to_process]["target"]["tag"])
												if(sector_map[destination_x][destination_y][type_to_process]["target"]["tag"] == "none")
													log_round_history (event = "missile_homing_bad_target", log_source = "[sector_map[destination_x][destination_y][type_to_process]["type"]] - [sector_map[destination_x][destination_y][type_to_process]["id_tag"]]")
													rem_entity(type = "coord", id = type_to_process, coord_x = current_x, coord_y = current_y)
											if(missileVector(start_x = destination_x, start_y = destination_y, target_x = sector_map[destination_x][destination_y][type_to_process]["target"]["x"], target_y = sector_map[destination_x][destination_y][type_to_process]["target"]["y"], speed = sector_map[destination_x][destination_y][type_to_process]["speed"], only_test = 1) == "in_range")
												log_round_history(event = "missile_near_target", log_source = "[sector_map[destination_x][destination_y][type_to_process]["type"]] [sector_map[destination_x][destination_y][type_to_process]["id_tag"]]")
						if("in_range")
							if(sector_map[current_x][current_y][type_to_process]["system"]["processed_movement"] == 1)
								if(sector_map[current_x][current_y][type_to_process]["system"]["has_moved"] != 1)
									missileWarhead(target_x = sector_map[current_x][current_y][type_to_process]["target"]["x"], target_y = sector_map[current_x][current_y][type_to_process]["target"]["y"], origin_x = current_x, origin_y = current_y)
							if(sector_map[current_x][current_y][type_to_process]["system"]["processed_movement"] == 0) sector_map[current_x][current_y][type_to_process]["system"]["processed_movement"] = 1
				current_x += 1
			current_x = 1
			current_y += 1

/obj/structure/shiptoship_master/proc/scan_entites(category = 0, output_format = 0) // category = 0 for ships, 1 for missiles, 2 for specials. format = 0 text for screen display/ref lists. 1 creates buttons with references.
	var/list/current_entites = list()
	var/current_x = 1
	var/current_y = 1
	while (current_y <= GLOB.sector_map_y)
		while(current_x <= GLOB.sector_map_x)
			if(category == 0)
				if(sector_map[current_x][current_y]["ship"]["id_tag"] != "none")
					if(output_format == 0)
						current_entites.Add("([current_x],[current_y])<b> - [sector_map[current_x][current_y]["ship"]["id_tag"]]</b><br><b>[sector_map[current_x][current_y]["ship"]["name"]]</b> - [sector_map[current_x][current_y]["ship"]["type"]] <br><b>VECTOR:</b> [sector_map[current_x][current_y]["ship"]["vector"]["x"]],[sector_map[current_x][current_y]["ship"]["vector"]["y"]] |<b> STATUS: </b>[sector_map[current_x][current_y]["ship"]["status"]] |<b> D:</b>[sector_map[current_x][current_y]["ship"]["damage"]["HP"]] | <b>S:</b>[sector_map[current_x][current_y]["ship"]["shield"]]")
					if(output_format == 1)
						current_entites.Add(sector_map[current_x][current_y]["ship"]["id_tag"])
			if(category == 1)
				if(sector_map[current_x][current_y]["missile"]["id_tag"] != "none")
					if(output_format == 0)
						current_entites.Add("([current_x],[current_y])<b> - [sector_map[current_x][current_y]["missile"]["id_tag"]]</b> - [sector_map[current_x][current_y]["missile"]["warhead"]["type"]]<br>TARGET: <b>([sector_map[current_x][current_y]["missile"]["target"]["x"]],[sector_map[current_x][current_y]["missile"]["target"]["y"]])</b> | <b>SPEED:</b> [sector_map[current_x][current_y]["missile"]["speed"]]")
					if(output_format == 1)
						current_entites.Add(sector_map[current_x][current_y]["missile"]["id_tag"])
			current_x += 1
		current_x = 1
		current_y += 1
	if (current_entites.len == 0)
		if(category == 0)
			current_entites.Add("No active ships")
		if(category == 1)
			current_entites.Add("No active projectiles")
	return current_entites

/obj/structure/shiptoship_master/proc/open_movement_console(x = null, y = null)
	var/ship_to_move_x = x
	var/ship_to_move_y = y
	if(ship_to_move_x == null || ship_to_move_y == null) return
	if(sector_map[ship_to_move_x][ship_to_move_y]["ship"]["system"]["has_moved"] == 0 && sector_map[ship_to_move_x][ship_to_move_y]["ship"]["system"]["movement_left"] == 0)
		sector_map[ship_to_move_x][ship_to_move_y]["ship"]["system"]["movement_left"] = sector_map[ship_to_move_x][ship_to_move_y]["ship"]["vector"]["speed"]
	variable_storage["stored_x"] = ship_to_move_x
	variable_storage["stored_y"] = ship_to_move_y
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	}
	#main_window {
	font-family: 'Lucida Grande', monospace;
	font-size: 20px;
	color: #ffffff;
	text-align: center;
	padding: 0em 1em;
	}
	</style>
	</head>
	<body>
	<div id="main_window">
	<p>
	[sector_map[ship_to_move_x][ship_to_move_y]["ship"]["name"]]<br>Vector: ([sector_map[ship_to_move_x][ship_to_move_y]["ship"]["vector"]["x"]],[sector_map[ship_to_move_x][ship_to_move_y]["ship"]["vector"]["y"]])
	</p>
	<p>
	<a href='?src=\ref[src];ship_control=y_plus'>+Y</a><br><a href='?src=\ref[src];ship_control=x_minus'>-X</a> | [sector_map[ship_to_move_x][ship_to_move_y]["ship"]["system"]["movement_left"]] | <a href='?src=\ref[src];ship_control=x_plus'>+X</a><br><a href='?src=\ref[src];ship_control=y_minus'>-Y</a>
	</p>
	<p>
	<a href='?src=\ref[src];ship_control=close'>EXIT</a>
	</p>
	</div>
	</body>
	"}
	usr << browse(terminal_html,"window=[sector_map[ship_to_move_x][ship_to_move_y]["ship"]["id_tag"]]-control;display=1;size=300x300;border=5px;can_close=0;can_resize=0;can_minimize=0;titlebar=0")
	onclose(usr, "[sector_map[ship_to_move_x][ship_to_move_y]["ship"]["id_tag"]]-control")

/obj/structure/shiptoship_master/proc/mod_entity(entity_type = "none", entity_tag = "none", entity_property = "none")
	var/mod_entity_type = entity_type
	var/mod_entity_tag = entity_tag
	var/mod_entity_prop = entity_property
	if(mod_entity_tag == null || mod_entity_prop == null || mod_entity_type == null) return
	var/current_x = 1
	var/current_y = 1
	var/mod_tag_x
	var/mod_tag_y
	var/mod_original_value
	while (current_y <= GLOB.sector_map_y)
		while(current_x < GLOB.sector_map_x)
			if(sector_map[current_x][current_y]["ship"]["id_tag"] == mod_entity_tag)
				mod_tag_x = current_x
				mod_tag_y = current_y
				break
			current_x += 1
		if(mod_tag_x && mod_tag_y)
			current_x = 1
			current_y = 1
			break
		current_x = 1
		current_y += 1
	if(mod_entity_type == "ship")
		switch(mod_entity_prop)
			if("name")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter ship name or otherwise identifiable nickname", "NAME Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("faction")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter ship faction", "FACTION Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("id_tag")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter ship ID Tag","id_tag entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("type")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter ship type", "TYPE Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("status")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter ship status", "STATUS Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("damage")
				switch(tgui_input_list(usr, "Which Type of Damage?", "DAM Selector",list("HP", "engine", "systems", "weapons", "hull"), timeout = 0))
					if("HP")
						mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["HP"]
						sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["HP"] = tgui_input_number(usr, "Pick HP value","DAM Entry", default = mod_original_value,  min_value = 0, timeout = 0)
						if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["HP"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["HP"] = mod_original_value
						MasterControl()
						return
					if("engine")
						mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["engine"]
						sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["engine"] = tgui_input_number(usr, "Pick engine value","DAM Entry", default = mod_original_value,  min_value = 0, timeout = 0)
						if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["engine"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["engine"] = mod_original_value
						MasterControl()
						return
					if("systems")
						mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["systems"]
						sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["systems"] = tgui_input_number(usr, "Pick systems value","DAM Entry", default = mod_original_value,  min_value = 0, timeout = 0)
						if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["systems"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["systems"] = mod_original_value
						MasterControl()
						return
					if("HP")
						mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["weapons"]
						sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["weapons"] = tgui_input_number(usr, "Pick weapons value","DAM Entry", default = mod_original_value,  min_value = 0, timeout = 0)
						if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["weapons"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["weapons"] = mod_original_value
						MasterControl()
						return
					if("HP")
						mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["hull"]
						sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["hull"] = tgui_input_number(usr, "Pick hull value","DAM Entry", default = mod_original_value,  min_value = 0, timeout = 0)
						if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["hull"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["hull"] = mod_original_value
						MasterControl()
						return
			if("shield")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_number(usr, "Pick Shield value","SHLD Entry", default = 0,  min_value = 0, timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("vector")
				if(tgui_input_list(usr, "Open Movement Console or Hard Edit Values?", "Vector Mod Type", list("Movement Console","Hard Edit")) == "Hard Edit")
					mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"]
					sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] = tgui_input_number(usr, "Pick Vector X value","Vector X Entry", default = 0, max_value = 1000, min_value = 1000, timeout = 0)
					if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] = mod_original_value
					mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"]
					sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] = tgui_input_number(usr, "Pick Vector Y value","Vector Y Entry", default = 0, max_value = 1000, min_value = 1000, timeout = 0)
					if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] = mod_original_value
					mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["speed"]
					sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["speed"] = tgui_input_number(usr, "Pick Vector Speed value","Vector SPD Entry", default = 0, min_value = 0, timeout = 0)
					if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["speed"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["speed"] = mod_original_value
					MasterControl()
					return
				else
					open_movement_console(x = mod_tag_x, y = mod_tag_y)
					return
	if(mod_entity_type == "missile")
		switch(mod_entity_prop)
			if("type")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_text(usr, "Enter Projectile Type, a generic name of the missile model", "TYPE Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("speed")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = tgui_input_number(usr, "Pick speed value","SPD Entry", default = mod_original_value,  min_value = 0, timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop] = mod_original_value
				MasterControl()
				return
			if("target")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] = tgui_input_number(usr, "Enter Target X","Target Entry", default = mod_original_value,  min_value = 0, timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["x"] = mod_original_value
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] = tgui_input_number(usr, "Enter Target Y","Target Entry", default = mod_original_value,  min_value = 0, timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["y"] = mod_original_value
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["tag"]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["tag"] = tgui_input_text(usr, "Enter Target Tag", "Target Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["tag"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["tag"] = mod_original_value
				return
			if("warhead")
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["type"]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["type"] = tgui_input_text(usr, "Enter Warhead Type", "Warhead Entry", timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["type"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["type"] = mod_original_value
				mod_original_value = sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["payload"]
				sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["payload"] = tgui_input_number(usr, "Enter Warhead Payload","Payload Entry", default = mod_original_value,  min_value = 0, timeout = 0)
				if (sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["payload"] == null) sector_map[mod_tag_x][mod_tag_y][mod_entity_type][mod_entity_prop]["payload"] = mod_original_value
				return



/obj/structure/shiptoship_master/proc/MasterControl()
	if(variable_storage["stored_x"] != 0) variable_storage["stored_x"] = 0
	if(variable_storage["stored_y"] != 0) variable_storage["stored_y"] = 0
	var/contacts_list = (jointext((scan_entites(category = 0, output_format = 0)), "</p><p>")+"</p><p>"+jointext((scan_entites(category = 1, output_format = 0)), "</p><p>"))
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	}
	#main_window {
	font-family: 'Lucida Grande', monospace;
	font-size: 18px;
	color: #ffffff;
	text-align: center;
	padding: 0em 1em;
	}
	</style>
	</head>
	<body>
	<div id="main_window">
	<p style="font-size: 120%;">
	<b>SECTOR PATROL ALPHA</b><br>GM SPACE SYSTEM CONTROL PANEL<hr>
	</p>
	<p>
	Current System:<br>[GLOB.ingame_current_system]
	</p>
	<p style="font-size: 120%;"><b>ACTIVE ENTITIES:</b></p>
	<p>[contacts_list]</p>
	<hr>
	<p style="font-size: 120%;">CURRENT TURN: [GLOB.combat_round]<br><a href='?src=\ref[src];end_turn=1'><b>END TURN</b></a></p>
	<hr>
	<p style="font-size: 120%;">COMMANDS</p>
	<p>
	<a href='?src=\ref[src];modify_entity=1'><b>Entity Controls</b></a>
	</p>
	<p>
	<b><a href='?src=\ref[src];add_entity=1'>Add Entity</a><nbsp>-<nbsp><a href='?src=\ref[src];rem_entity=1'>Remove Entity</a><br></b>
	</p>
	</div>
	</body>
	"}
	usr << browse(terminal_html,"window=sts_master;display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "sts_master")

/obj/structure/shiptoship_master/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["add_entity"])
		switch(tgui_input_list(usr, "What type of entity to add?", "Add Entity", list("ship","missile"), timeout = 0))
			if("ship")
				var/coordinate_x = tgui_input_number(usr, "Pick the X coordinate, max: [GLOB.sector_map_x]", "Add Entity - X Coordinate", min_value = 0, timeout = 0)
				if(coordinate_x == null) return
				if(coordinate_x > GLOB.sector_map_x) coordinate_x = GLOB.sector_map_x
				var/coordinate_y = tgui_input_number(usr, "Pick the Y coordinate, max: [GLOB.sector_map_y]", "Add Entity - Y Coordinate", min_value = 0, timeout = 0)
				if(coordinate_y == null) return
				if(coordinate_y > GLOB.sector_map_y) coordinate_y = GLOB.sector_map_y
				if(sector_map[coordinate_x][coordinate_y]["ship"]["id_tag"] != "none")
					to_chat(usr, SPAN_WARNING("An Entity exists on this coordinate already."))
					return
				var/name_to_enter = tgui_input_text(usr, "Enter ship name or otherwise identifiable nickname", "NAME Entry", timeout = 0)
				if(name_to_enter == null) name_to_enter = "Unknown"
				var/type_to_enter = tgui_input_text(usr, "Enter ship type or identifiable cahracteristics if unknown ", "TYPE Entry", timeout = 0)
				if(type_to_enter == null) type_to_enter = "Unknown"
				var/faction_to_enter = tgui_input_text(usr, "Enter ship faction", "FACTION Entry", timeout = 0)
				if(faction_to_enter == null) faction_to_enter = "UNKW"
				var/status_to_enter = tgui_input_text(usr, "Enter ship status", "STATUS Entry", timeout = 0)
				if(status_to_enter == null) status_to_enter = "Unknown"
				var/damage_to_enter = tgui_input_number(usr, "Pick HP value","HP Entry", default = 0,  min_value = 0, timeout = 0)
				if(damage_to_enter == null) damage_to_enter = 0
				var/shield_to_enter = tgui_input_number(usr, "Pick value of shield", "SHLD Entry", default = 0,  min_value = 0, timeout = 0)
				if(shield_to_enter == null) shield_to_enter = 0
				var/vector_x_to_enter = tgui_input_number(usr, "Pick X value of the vector", "Vector - X", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
				if(vector_x_to_enter == null) vector_x_to_enter = 0
				var/vector_y_to_enter = tgui_input_number(usr, "Pick Y value of the vector", "Vector - X", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
				if(vector_y_to_enter == null) vector_y_to_enter = 0
				var/speed_to_enter = tgui_input_number(usr, "Pick speed", "Speed", default = 0 ,min_value = 0, timeout = 0)
				if(speed_to_enter == null)speed_to_enter = 0
				var/salvos_to_enter = tgui_input_number(usr, "Pick max ammount of salvos per round", "Max_salvos", default = 0 ,min_value = 0, timeout = 0)
				if(salvos_to_enter == null)salvos_to_enter = 0
				add_entity(entity_type = 0, x = coordinate_x, y = coordinate_y, name = name_to_enter, type = type_to_enter, vector_x = vector_x_to_enter, vector_y = vector_y_to_enter, ship_status = status_to_enter, ship_faction = faction_to_enter, ship_damage = damage_to_enter, ship_shield = shield_to_enter, ship_speed = speed_to_enter, salvos = salvos_to_enter)
				to_chat(usr, SPAN_INFO("Entity Added."))
				MasterControl()
				return
			if("missile")
				var/coordinate_x = tgui_input_number(usr, "Pick the X coordinate, max: [GLOB.sector_map_x]", "Add Entity - X Coordinate", min_value = 0, timeout = 0)
				if(coordinate_x == null) return
				if(coordinate_x > GLOB.sector_map_x) coordinate_x = GLOB.sector_map_x
				var/coordinate_y = tgui_input_number(usr, "Pick the Y coordinate, max: [GLOB.sector_map_y]", "Add Entity - Y Coordinate", min_value = 0, timeout = 0)
				if(coordinate_y == null) return
				if(coordinate_y > GLOB.sector_map_y) coordinate_y = GLOB.sector_map_y
				if(sector_map[coordinate_x][coordinate_y]["missile"]["id_tag"] != "none")
					to_chat(usr, SPAN_WARNING("A missile exists on this coordinate already."))
					return
				var/name_to_enter = tgui_input_number(usr, "Enter missile Speed", "SPEED Entry", timeout = 0)
				if(name_to_enter == null) name_to_enter = "Unknown"
				var/type_to_enter = tgui_input_text(usr, "Enter missile Type", "TYPE Entry", timeout = 0)
				if(type_to_enter == null) type_to_enter = "Unknown"
				var/warhead_to_enter = tgui_input_text(usr, "Enter warhead type", "WARHEAD Entry", timeout = 0)
				if(warhead_to_enter == null) warhead_to_enter = "Unknown"
				var/vector_x_to_enter = tgui_input_number(usr, "Pick X coord of target", "Target - X", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
				if(vector_x_to_enter == null) vector_x_to_enter = 0
				var/vector_y_to_enter = tgui_input_number(usr, "Pick Y coord of target", "Target - Y", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
				if(vector_y_to_enter == null) vector_y_to_enter = 0
				var/target_tag_to_enter = tgui_input_list(usr, "Select a target Tag", "Tag Ship", scan_entites(category = 0, output_format = 1), timeout = 0)
				if(target_tag_to_enter == null) target_tag_to_enter = "none"
				add_entity(entity_type = 1, x = coordinate_x, y = coordinate_y, name = name_to_enter, type = type_to_enter, vector_x = vector_x_to_enter, vector_y = vector_y_to_enter, warhead_type = warhead_to_enter, target_tag = target_tag_to_enter)
				to_chat(usr, SPAN_INFO("Entity Added."))
				MasterControl()
				return
	if(href_list["rem_entity"])
		switch(tgui_input_list(usr, "What type of entity to remove?", "Rem Entity", list("ship","missile"), timeout = 0))
			if("ship")
				var/id_to_remove = tgui_input_list(usr, "Which ship Entity to remove?", "Rem Ship", scan_entites(category = 0, output_format = 1), timeout = 0)
				if(id_to_remove == null) return
				rem_entity(type = "id", id = id_to_remove)
				MasterControl()
				return
			if("missile")
				var/id_to_remove = tgui_input_list(usr, "Which ship Entity to remove?", "Rem Ship", scan_entites(category = 1, output_format = 1), timeout = 0)
				if(id_to_remove == null) return
				rem_entity(type = "id", id = id_to_remove)
				MasterControl()
				return
	if(href_list["modify_entity"])
		switch(tgui_input_list(usr, "What type of entity to modify?", "Mod Entity", list("ship","missile"), timeout = 0))
			if("ship")
				var/modify_id = tgui_input_list(usr, "Select a Ship Entity to Edit", "Mod Entity", scan_entites(category = 0, output_format = 1), timeout = 0)
				var/modify_value = tgui_input_list(usr, "Select a Ship Entity Property to Edit", "Mod Entity", list("name","faction","id_tag","type","status","damage","shield","vector"), timeout = 0)
				mod_entity(entity_type = "ship", entity_tag = modify_id, entity_property = modify_value)
				return
			if("missile")
				var/modify_id = tgui_input_list(usr, "Select a missile Entity to Edit", "Mod Entity", scan_entites(category = 1, output_format = 1), timeout = 0)
				var/modify_value = tgui_input_list(usr, "Select a missile Entity Property to Edit", "Mod Entity", list("type","target","speed","warhead"), timeout = 0)
				mod_entity(entity_type = "missile", entity_tag = modify_id, entity_property = modify_value)
				return
	if(href_list["end_turn"])
		if(tgui_input_list(usr, "Advance Turn?", "Advancing Turn", list("Yes", "No"), timeout = 0) == "No")
			MasterControl()
			return
		to_chat(world, SPAN_INFO("Advancing turn in 5 seconds!"))
		sleep(50)
		log_round_history(event = "ship_move")
		var/len_to_test = round_history_current.len
		if(ProcessMovement(type = "ship") == 1)
			while(len_to_test != round_history_current.len)
				len_to_test = round_history_current.len
				ProcessMovement(type = "ship")
		len_to_test = round_history_current.len
		if(ProcessMovement(type = "missile") == 1)
			while(len_to_test != round_history_current.len)
				len_to_test = round_history_current.len
				ProcessMovement(type = "missile")
		len_to_test = 0
		while(len_to_test != round_history_current.len)
			len_to_test = round_history_current.len
			ProcessMovement(type = "missile")
		DisplayAndCycleSpaceRoundLog()
		to_chat(world,SPAN_INFO("Round advanced."))
		return
	switch(href_list["ship_control"])
		if("y_plus")
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["y"] >= sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["speed"])
				to_chat(usr,SPAN_WARNING("Error: Maxium velocity reached. Safeguards in place. Acceleration denied."))
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] == 0) sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] = 1
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] > 0)
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["y"] += 1
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] -= 1
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
		if("y_minus")
			var/reversed_max = 0 - sector_map["stored_x"]["stored_y"]["ship"]["vector"]["speed"]
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["y"] <= reversed_max)
				to_chat(usr,SPAN_WARNING("Error: Maxium velocity reached. Safeguards in place. Acceleration denied."))
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] == 0) sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] = 1
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] > 0)
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["y"] -= 1
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] -= 1
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
		if("x_plus")
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["x"] == sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["speed"])
				to_chat(usr,SPAN_WARNING("Error: Maxium velocity reached. Safeguards in place. Acceleration denied."))
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] == 0) sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] = 1
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] > 0)
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["x"] += 1
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] -= 1
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
		if("x_minus")
			var/reversed_max = 0 - sector_map["stored_x"]["stored_y"]["ship"]["vector"]["speed"]
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["x"] <= reversed_max)
				to_chat(usr,SPAN_WARNING("Error: Maxium velocity reached. Safeguards in place. Acceleration denied."))
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] == 0) sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["has_moved"] = 1
			if(sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] > 0)
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["vector"]["x"] -= 1
				sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["system"]["movement_left"] -= 1
				open_movement_console(x = variable_storage["stored_x"], y = variable_storage["stored_y"])
				return
		if("close")
			usr << browse(null,"window=[sector_map[variable_storage["stored_x"]][variable_storage["stored_y"]]["ship"]["id_tag"]]-control;display=1;size=300x300;border=5px;can_close=0;can_resize=0;can_minimize=0;titlebar=0")
			MasterControl()
			return
