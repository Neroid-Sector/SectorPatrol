/obj/structure/shiptoship_master/ship_missioncontrol
	name = "Why yes, another master item"
	desc = "This definition contains critical code. Look for map specific instances down the line :p"
	var/list/sector_map_data = list(
		"name" = "none",
		"id_tag" = "none,",
		"initialized" = 0,
		"x" = 0,
		"y" = 0,
		)
	var/list/linked_consoles = list("signals" = null,)
	var/list/tracking_list
	var/tracking_max = 3
	var/list/local_round_log = list()
	var/list/local_round_log_moves = list()
	var/list/ping_history = list()
	var/list/comms_messages = list()

/obj/structure/shiptoship_master/ship_missioncontrol/proc/PingLog(entity_type = 0, pos_x = 0, pos_y = 0, name = "none", type = "none", target_x = 0, target_y = 0, speed = 0, hp = 0, faction = "none")
	switch(entity_type)
		if(1)
			ping_history.Add("<b>([pos_x],[pos_y])</b> | <b>Ship [name] - [type]</b> | IFF: <b>[faction]</b><br>Vector:<b>([target_x],[target_y])</b> Max: <b>[speed]</b> | Integrity: <b>[hp]</b>)")
		if(2)
			ping_history.Add("<b>([pos_x],[pos_y])</b> | <b>Pojectile [name] | Warhead: [type]<br>Payload: [hp] | Target:([target_x],[target_y]) | Velocity: [speed]")
		if(3)
			ping_history.Add("<b>([pos_x],[pos_y])</b> | <b>Unknown Ship:</b> Bearing: [type] | Velocity: [speed]")
		if(4)
			ping_history.Add("<b>([pos_x],[pos_y])</b> | <b>Unknown Projectile</b> Bearing: [type] | Velocity: [speed]")

/obj/structure/shiptoship_master/ship_missioncontrol/proc/ScannerPing(incoming_console as obj, probe_target_x = 0, probe_target_y = 0, range = 0)
	var/obj/structure/terminal/signals_console/target_console = incoming_console
	var/x_to_target_scan = target_console.linked_master_console.sector_map_data["x"] + probe_target_x
	var/y_to_target_scan = target_console.linked_master_console.sector_map_data["y"] + probe_target_y
	if(x_to_target_scan < 1 || x_to_target_scan > GLOB.sector_map_x)
		target_console.terminal_display_line("Error: X coordinate outside of Twilight Boudary. Probe lost.")
		target_console.usage_data["ping_uses_current"] += 1
		return 1
	if(y_to_target_scan < 1 || y_to_target_scan > GLOB.sector_map_x)
		target_console.terminal_display_line("Error: Y coordinate outside of Twilight Boudary. Probe lost.")
		target_console.usage_data["ping_uses_current"] += 1
		return 1
	target_console.terminal_display_line("Connection to probe established. Reading data...", TERMINAL_LOOKUP_SLEEP)
	var/scan_boundary_x_min = BoundaryAdjust(x_to_target_scan - range, type = 1)
	var/scan_boundary_y_min = BoundaryAdjust(y_to_target_scan - range, type = 1)
	var/scan_boundary_x_max = BoundaryAdjust(x_to_target_scan + range, type = 2)
	var/scan_boundary_y_max = BoundaryAdjust(y_to_target_scan + range, type = 3)
	var/current_scan_pos_x = scan_boundary_x_min
	var/current_scan_pos_y = scan_boundary_y_min
	if(sector_map[x_to_target_scan][y_to_target_scan]["ship"]["id_tag"] != "none")
		target_console.terminal_display_line("Probe reports presence of a ship in its sector. Querrying Pythia.", TERMINAL_LOOKUP_SLEEP)
		target_console.terminal_display_line("Pythia reports entity as \"[sector_map[x_to_target_scan][y_to_target_scan]["ship"]["name"]]\"")
		target_console.terminal_display_line("Type: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["type"]], IFF Response: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["faction"]].")
		target_console.terminal_display_line("Vector: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["x"]],[sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["y"]], Maximum velocity: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["speed"]]")
		target_console.terminal_display_line("Hull Integrity Readout: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["HP"] - (sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["hull"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["weapons"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["systems"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["engines"])], Shield: [sector_map[x_to_target_scan][y_to_target_scan]["ship"]["shield"]]")
		PingLog(entity_type = 1, pos_x = x_to_target_scan, pos_y = y_to_target_scan ,name = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["name"], type = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["type"], target_x = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["x"], target_y = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["y"], speed = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["speed"], hp = (sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["HP"] - (sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["hull"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["weapons"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["systems"] + sector_map[x_to_target_scan][y_to_target_scan]["ship"]["damage"]["engines"])), faction = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["faction"])
		if(sector_map[x_to_target_scan][y_to_target_scan]["ship"]["status"] == "player") target_console.terminal_display_line("Upsilon-Pythia Node detected. This is an OV-PST Test Crew vessel.")
	if(sector_map[x_to_target_scan][y_to_target_scan]["missile"]["id_tag"] != "none")
		target_console.terminal_display_line("Projectile leapfrog trace detected in probe sector. Querrying Pythia.", TERMINAL_LOOKUP_SLEEP)
		target_console.terminal_display_line("Projectile ID: \"[sector_map[x_to_target_scan][y_to_target_scan]["missile"]["type"]]\" relative velocity:[sector_map[x_to_target_scan][y_to_target_scan]["missile"]["speed"]].")
		target_console.terminal_display_line("Warhead type: [sector_map[x_to_target_scan][y_to_target_scan]["missile"]["warhead"]["type"]], Payload: [sector_map[x_to_target_scan][y_to_target_scan]["missile"]["warhead"]["payload"]].")
		target_console.terminal_display_line("Based on readout, the projectiles target is: ([sector_map[x_to_target_scan][y_to_target_scan]["missile"]["target"]["x"]],[sector_map[x_to_target_scan][y_to_target_scan]["missile"]["target"]["y"]]])")
		PingLog(entity_type = 2, pos_x = x_to_target_scan, pos_y = y_to_target_scan, name = sector_map[x_to_target_scan][y_to_target_scan]["missile"]["type"], type = sector_map[x_to_target_scan][y_to_target_scan]["missile"]["warhead"]["type"], hp = sector_map[x_to_target_scan][y_to_target_scan]["missile"]["warhead"]["payload"], target_x = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["x"], target_y = sector_map[x_to_target_scan][y_to_target_scan]["ship"]["vector"]["y"], speed = sector_map[x_to_target_scan][y_to_target_scan]["missile"]["speed"])
		if(sector_map[x_to_target_scan][y_to_target_scan]["missile"]["target"]["tag"] != "none") target_console.terminal_display_line("missile is homing onto a specific target and may change its vector.")
	while(current_scan_pos_y <= scan_boundary_y_max)
		while(current_scan_pos_x <= scan_boundary_x_max)
			if((current_scan_pos_x == x_to_target_scan) && (current_scan_pos_y == y_to_target_scan))
				current_scan_pos_x += 1
				continue
			if((abs(x_to_target_scan - current_scan_pos_x) + abs(y_to_target_scan - current_scan_pos_y)) <= range)

				var/saved_len = target_console.terminal_buffer.len
				if(sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["id_tag"] != "none")
					target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]) - CONTACT")
					target_console.terminal_display_line("Sound consistant with ship engine movement.")
					target_console.terminal_display_line("Bearing: [ReturnBearing(sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"], sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"])], Velocity: [sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"] + sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"]]")
					PingLog(entity_type = 3, pos_x = current_scan_pos_x, pos_y = current_scan_pos_y, type = ReturnBearing(sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"], sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"]), speed = sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"] + sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"])
				if(sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["id_tag"] != "none")
					if(saved_len == target_console.terminal_buffer.len) target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]) - CONTACT")
					target_console.terminal_display_line("Contact. Projectile leapfrog trace detected.")
					target_console.terminal_display_line("Bearing: [ReturnBearing((sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["x"] - current_scan_pos_x), (sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["y"] - current_scan_pos_y))], Velocity: [sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["speed"]]")
					PingLog(entity_type = 4, pos_x = current_scan_pos_x, pos_y = current_scan_pos_y, type = ReturnBearing((sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["x"] - current_scan_pos_x), (sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["y"] - current_scan_pos_y)), speed = sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["speed"])
				if(saved_len == target_console.terminal_buffer.len) target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]): No contacts.")
			current_scan_pos_x += 1
		current_scan_pos_x = scan_boundary_x_min
		current_scan_pos_y += 1
	target_console.usage_data["ping_uses_current"] += 1
	return 1


/obj/structure/shiptoship_master/ship_missioncontrol/proc/SectorConversion(x = 0, y = 0) // Converts coords to map sector. If coordinates do not line up, even sectors should get the extra row.
	var/x_to_sectorconvert = x
	var/y_to_sectorconvert = y
	if(x_to_sectorconvert < 1 || x_to_sectorconvert > GLOB.sector_map_x || y_to_sectorconvert < 1 || y_to_sectorconvert > GLOB.sector_map_y) return "out_of_bounds"
	var/sector_to_return_x = floor(x_to_sectorconvert / (floor(GLOB.sector_map_x / GLOB.sector_map_sector_size)))
	var/sector_to_return_y = floor(y_to_sectorconvert / (floor(GLOB.sector_map_y / GLOB.sector_map_sector_size)))
	var/value_to_return = "[sector_to_return_x]-[sector_to_return_y]"
	return value_to_return

/obj/structure/shiptoship_master/ship_missioncontrol/proc/CommsLog(message_type = 0, message_source = null, message_to_add = null)
	if(message_source == null || message_to_add == null) return
	switch(message_type)
		if(0)
			comms_messages.Add("<b>Direct message recieved.</b> Sender ID: [message_source]. Message reads: <[message_to_add]>.")
		if(1)
			comms_messages.Add("<b>Communications activity detected</b> in sector ([message_source]).")
		if(2)
			comms_messages.Add("<b>Incoming Priority Message from [message_source]:</b> \"[message_to_add]\"")

/obj/structure/shiptoship_master/ship_missioncontrol/proc/CommsPing(incoming_console as obj, x_to_comms_ping = 0, y_to_comms_ping = 0, message_to_comms_ping = null)
	var/obj/structure/terminal/signals_console/target_console = incoming_console
	if(x_to_comms_ping < 1 || x_to_comms_ping > GLOB.sector_map_x)
		target_console.terminal_display_line("Error: X coordinate out of bounds. Message not sent. Pulse expended.")
		target_console.usage_data["signal_pulses_current"] += 1
		return 1
	if(y_to_comms_ping < 1 || y_to_comms_ping > GLOB.sector_map_y)
		target_console.terminal_display_line("Error: Y coordinate out of bounds. Message not sent. Pulse expended.")
		target_console.usage_data["signal_pulses_current"] += 1
		return 1
	target_console.terminal_display_line("Sending comms pulse to coordinates ([x_to_comms_ping],[y_to_comms_ping])")
	log_round_history(event = "comms_ping", log_source = sector_map_data["name"], log_target = message_to_comms_ping, log_dest_x = x_to_comms_ping, log_dest_y = y_to_comms_ping)
	for(var/obj/structure/shiptoship_master/ship_missioncontrol/all_ship_consoles in world)
		all_ship_consoles.CommsLog(message_type = 1, message_source = SectorConversion(x = x_to_comms_ping, y = y_to_comms_ping))
	if(sector_map[x_to_comms_ping][y_to_comms_ping]["ship"]["id_tag"] != "none")
		if(sector_map[x_to_comms_ping][y_to_comms_ping]["ship"]["status"] == "Player")
			for (var/obj/structure/shiptoship_master/ship_missioncontrol/player_ship_console in world)
				if(player_ship_console.sector_map_data["id_tag"] == sector_map[x_to_comms_ping][y_to_comms_ping]["ship"]["id_tag"])
					player_ship_console.CommsLog(message_type = 0, message_source = sector_map_data["name"], message_to_add = message_to_comms_ping)
					player_ship_console.talkas("New Direct Message recieved!")
	return 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/WriteToShipLog(shiplog_event = null, shiplog_dest_x = null, shiplog_dest_y = null)
	var/event_to_add_ship = shiplog_event
	var/shiplog_coordinate_x = shiplog_dest_x
	var/shiplog_coordinate_y = shiplog_dest_y
	switch(event_to_add_ship)
		if("collision_move")
			local_round_log.Add("Ship engine pattern changes suggest a <b>near-collision in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			return
		if("collision_boundary")
			local_round_log.Add("<b>Emergency maneuvers and rapid engine deceleration<b> detected on Twilight Boundary of Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)].")
			return
		if("regular_move")
			local_round_log.Add("Engine noise related to <b>ship movement detected in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>.")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			return
		if("missile_collision")
			local_round_log.Add("Detonation detected after mulitple Projectile movement traces in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]")
			return
		if("missile_move","warhead_miss","warhead_homing")
			local_round_log.Add("Projectile leapfrog trace in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>.")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			return
		if("warhead_hit", "explosive_splash")
			local_round_log.Add("Warhead explosion detected in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			return
		if("hit_shield")
			local_round_log.Add("Deflector <b>shield impact</b> detected.")
			return
		if("shield_break")
			local_round_log.Add("Defletor <b>shield collapse</b> detected.")
			return
		if("destroy_complete")
			local_round_log.Add("Multiple explosions and ship fragmentation detected. High likelihood of a complete loss event.")
			return
		if("destroy_engine")
			local_round_log.Add("Twilight Paradox Engine Collapse detected. Escape pod launches detected.")
			return
		if("destroy_systems")
			local_round_log.Add("Rapid, repeated explosions followed by escape pod activation detected. On-board system failre likely.")
			return
		if("destroy_weapons")
			local_round_log.Add("Wepon bay detonation detected. High casuality event expected.")
			return
		if("destroy_hull")
			local_round_log.Add("Cascading hull breach detected. Partial ship fragmentation and high casualty event expected.")
			return
		if("nuclear_hit")
			local_round_log.Add("<b>WARNING:</b> Nuclear detonation detected in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
			if(local_round_log_moves.Find("[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]") == 0) local_round_log_moves.Add("[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]")
			return

/obj/structure/shiptoship_master/ship_missioncontrol/Initialize(mapload, ...)
	. = ..()
	if(tracking_max > 0)
		tracking_list = new/list(tracking_max)
		var/current_row = 1
		while (current_row <= tracking_max)
			tracking_list[current_row] = list(
			"x" = 0,
			"y" = 0,
			"id_tag" = "none",
			)
			current_row += 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/TrackerCheck(id = null) //Checks tracker buffer, if no id is given, returns free tracker slot. If id is passed, returns the slot where a the given ID resides.
	var/current_track_pos = 1
	while (current_track_pos <= tracking_max)
		if(tracking_list[current_track_pos]["id_tag"] != "none")
			if(id != null)
				if (tracking_list[current_track_pos]["id_tag"] == id) break
			else
				break
		current_track_pos += 1
	if(current_track_pos > tracking_max) current_track_pos = 0
	return current_track_pos



/obj/structure/shiptoship_master/ship_missioncontrol/proc/TrackerPing(incoming_console as obj, track_target_x = 0, track_target_y = 0)
	var/obj/structure/terminal/signals_console/target_console = incoming_console
	var/x_to_target_track = target_console.linked_master_console.sector_map_data["x"] + track_target_x
	var/y_to_target_track = target_console.linked_master_console.sector_map_data["y"] + track_target_y
	if(x_to_target_track < 1 || x_to_target_track > GLOB.sector_map_x)
		target_console.terminal_display_line("Error: X coordinate outside of Twilight Boudary. Tracker lost.")
		target_console.usage_data["tracker_uses_current"] += 1
		return 1
	if(y_to_target_track < 1 || y_to_target_track > GLOB.sector_map_x)
		target_console.terminal_display_line("Error: Y coordinate outside of Twilight Boudary. Tracker lost.")
		target_console.usage_data["tracker_uses_current"] += 1
		return 1
	if(sector_map[x_to_target_track][y_to_target_track]["ship"]["id_tag"] != "none")
		if(TrackerCheck(id = sector_map[x_to_target_track][y_to_target_track]["ship"]["id_tag"]) == 0)
			if(TrackerCheck() != 0)
				tracking_list[TrackerCheck()]["x"] = x_to_target_track
				tracking_list[TrackerCheck()]["y"] = y_to_target_track
				target_console.terminal_display_line("Success. Tracker ID [TrackerCheck()] installed on ship entity at ([x_to_target_track],[y_to_target_track])")
				tracking_list[TrackerCheck()]["id_tag"] = sector_map[x_to_target_track][y_to_target_track]["ship"]["id_tag"]
				target_console.usage_data["tracker_uses_current"] += 1
				return 1
			else
				target_console.terminal_display_line("Error: No free trackers. Use TRACKER R to terminate a tracker by ID. Tracker Lost.")
				target_console.usage_data["tracker_uses_current"] += 1
				return 1
	if(sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"] != "none")
		if(TrackerCheck(id = sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"]) == 0)
			if(TrackerCheck() != 0)
				tracking_list[TrackerCheck()]["x"] = x_to_target_track
				tracking_list[TrackerCheck()]["y"] = y_to_target_track
				target_console.terminal_display_line("Success. Tracker ID [TrackerCheck()] installed on ship entity at ([x_to_target_track],[y_to_target_track])")
				tracking_list[TrackerCheck()]["id_tag"] = sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"]
				target_console.usage_data["tracker_uses_current"] += 1
				return 1
			else
				target_console.terminal_display_line("Error: No free trackers. Use TRACKER R to terminate a tracker by ID.")
				target_console.usage_data["tracker_uses_current"] += 1
				return 1
	else
		target_console.terminal_display_line("Error: No entity to track detected. Tracker lost.")
		target_console.usage_data["tracker_uses_current"] += 1
		return 1




/obj/structure/shiptoship_master/ship_missioncontrol/proc/FindShipOnMap() // Should only be called after setting up the sector map and putting a ship with a corssesponding ["name"] segment set to match
	var/current_x = 1
	var/current_y = 1
	to_chat(world, SPAN_INFO("Initializing ship [sector_map_data["name"]]!"))
	if(linked_consoles["signals"] == null)
		for(var/obj/structure/terminal/signals_console/console in get_area(src))
			linked_consoles["signals"] = console
			console.LinkToShipMaster(master_console = src)
			var/turf/turf_return = get_turf(console)
			to_chat(world, SPAN_INFO("Singals Console Linked at [turf_return.x],[turf_return.y]"))
	while(current_x <= GLOB.sector_map_x)
		while(current_y <= GLOB.sector_map_y)
			if(sector_map[current_x][current_y]["ship"]["name"] == sector_map_data["name"])
				sector_map[current_x][current_y]["ship"]["status"] = "Player"
				sector_map_data["id_tag"] = sector_map[current_x][current_y]["ship"]["id_tag"]
				sector_map_data["x"] = current_x
				sector_map_data["y"] = current_y
				to_chat(world, SPAN_INFO("Ship [sector_map_data["name"]] Initalized on the Sector Map."))
			if(sector_map_data["x"] != 0 && sector_map_data["y"] != 0) break
			current_y += 1
		if(sector_map_data["x"] != 0 && sector_map_data["y"] != 0) break
		current_y = 1
		current_x += 1
	if(sector_map_data["x"] != 0 && sector_map_data["y" != 0]) return 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/GetTrackingList(type = 0)
	var/list/tracking_list_to_return = list()
	var/current_tracking_position = 1
	while (current_tracking_position <= tracking_max)
		if(tracking_list[current_tracking_position]["id_tag"] == "none") break
		tracking_list_to_return.Add("ID: [current_tracking_position] - <b>([tracking_list[current_tracking_position]["x"]],[tracking_list[current_tracking_position]["y"]])</b>")
		current_tracking_position += 1
	if(type == 1) return (current_tracking_position - 1)
	if(tracking_list_to_return.len == 0) tracking_list_to_return.Add("No tracking active.")
	return tracking_list_to_return

/obj/structure/shiptoship_master/ship_missioncontrol/proc/GetStatusReadout()
	var/list/status_list_to_return = list()
	status_list_to_return.Add("<b>HULL INTEGRITY: [(sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["HP"]) - (sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["engine"] + sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["systems"] + sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["weapons"] + sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["hull"])]</b> <b>SHIELDS: [sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["shield"]]</b>")
	status_list_to_return.Add("<b> Damage Readout:</b>","Engines: [sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["engine"]]","Systems: [sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["systems"]]","Weapons: [sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["weapons"]]","Hull: [sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["damage"]["hull"]]")
	return status_list_to_return

/obj/structure/shiptoship_master/ship_missioncontrol/proc/OpenMissionControl(screen_type = "general")
	var/display_html
	var/sensor_to_display
	var/detailed_sonar_to_display
	var/detailed_ping_history
	var/tracking_to_display = jointext(GetTrackingList(), "</p><p>")
	var/pings_to_display
	var/messages_to_display
	var/status_to_display = jointext(GetStatusReadout(), "</p><p>")
	if(ping_history.len == 0) pings_to_display = "No ping history."
	if(ping_history.len <= 5 && ping_history.len != 0) pings_to_display = jointext(ping_history, "</p><p>")
	if(ping_history.len > 5) pings_to_display = jointext(ping_history.Copy((ping_history.len - 5)), "<br>")
	if(local_round_log_moves.len != 0) sensor_to_display = jointext(local_round_log_moves, " | ")
	if(!sensor_to_display) sensor_to_display = "No updates."
	if(local_round_log.len != 0) detailed_sonar_to_display = jointext(local_round_log, "</p></p>- ")
	if(ping_history.len != 0) detailed_ping_history = jointext(ping_history, "</p></p>")
	if(comms_messages.len == 0) messages_to_display = "No messages to dispplay."
	if(comms_messages.len <= 5 && comms_messages.len != 0) messages_to_display = jointext(comms_messages, "<br>")
	if(comms_messages.len > 5) messages_to_display = jointext(comms_messages.Copy((comms_messages.len - 5)), "<br>")
	switch(screen_type)
		if("general")
			display_html = {"<!DOCTYPE html>
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
            .box {
            border-style: solid;
            }
			.column {
			float: left;
			font-family: 'Lucida Grande', monospace;
			font-size: 18px;
			color: #ffffff;
            text-align: center;
			}

			.left {
			width: 30%;
			}

			.right {
			width: 70%;
			}
            .row:after {
            content: "";
            display: table;
            clear: both;
            }
			</style>
			</head>
			<body>
			<div id="main_window">
            <div class="box">
			<p style="font-size: 120%;">
			<b>UACM 2ND LOGISTICS<br>[sector_map_data["name"]]</b>
			</p>
            </div>
            <div class="box">
			<p>
			<b>COMMAND OVERVIEW:<br><br>Detailed logs are accessible through Mission Control terminal.<hr></b>
			</p>
			<p><b>Ship position:</b> Sector [SectorConversion(x = sector_map_data["x"], y = sector_map_data["y"])]</p>
            </div>
            <div class="box">
			<p><b>Communications Log:</b></p>
			<p>[messages_to_display]</p>
            </div>
			<div class="box">
				<div class="row">
					<div class="column left">
						<div class="box">
						<p><b>Sonar Report:</b></p>
						<p>[sensor_to_display]</p>
						</div>
					</div>
					<div class="column right">
						<div class="box">
						<p><b>Active Probe Pings:</b></p>
						<p>[pings_to_display]</p>
						</div>
				</div>
			</div>
			</div>
            <div class="box">
			<p><b>Tracking Updates:</b></p>
			<p>[tracking_to_display]</p>
            </div>
            <div class="box">
			<p><b>SHIP STATUS:</b></p>
			<p>[status_to_display]</b></p>
            </div>
			</div>
			</body>
			"}
		if("sonar")
			display_html = {"<!DOCTYPE html>
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
            .box {
            border-style: solid;
            }
			</style>
			</head>
			<body>
			<div id="main_window">
			<div class="box">
			<p style="font-size: 120%;">
			<b>UACM 2ND LOGISTICS<br>[sector_map_data["name"]]<hr></b>
			</p>
			</div>
			<div class="box">
			<p>
			<b>DETAILED SONAR LOG:</b>
			</p>
			<p>
			- [detailed_sonar_to_display]
			</p>
			</div>
			</div>
			</body>
			"}
		if("ping")
			display_html = {"<!DOCTYPE html>
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
            .box {
            border-style: solid;
            }
			}
			</style>
			</head>
			<body>
			<div id="main_window">
			<div class="box">
			<p style="font-size: 120%;">
			<b>UACM 2ND LOGISTICS<br>[sector_map_data["name"]]<hr></b>
			</p>
			</div>
			<div class="box">
			<p>
			<b>DETAILED PING LOG:</b>
			</p>
			<p>
			[detailed_ping_history]
			</p>
			</div>
			</div>
			</body>
			"}
	usr << browse(display_html,"window=ship_[screen_type]_[sector_map_data["name"]];display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "ship_[screen_type]_[sector_map_data["name"]]")
