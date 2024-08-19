/obj/structure/shiptoship_master/ship_missioncontrol
	name = "mission control unit"
	desc = "A tube made from resins and LD polymers, giving it a sleek, somewhat shimmering appearance."
	desc_lore = "Mission Control units are central intelligence and processing systems that occupy the same space that \"traditional\"ships fill with an on-board AI. Unlike conventional AIs, Mission Control units instead are fully realized, intelligent sophonts, each instanced from a central version stored at the PST. Due to properties inherent to how Liquid Data works, this allows individual MC units to divert resources, be it energy or information, to the crews under its care as needed while utilizing the instantaneous transportation capabilities of Liquid Data."
	icon = 'icons/sectorpatrol/ship/mission_control.dmi'
	icon_state = "mc_off"
	var/list/sector_map_data = list(
		"name" = "none",
		"id_tag" = "none,",
		"initialized" = 0,
		"x" = 0,
		"y" = 0,
		)
	var/repair_shutdown = 0
	var/obj/structure/terminal/signals_console/linked_signals_console
	var/obj/structure/terminal/weapons_console/linked_weapons_console
	var/obj/structure/terminal/damage_console/linked_damage_console
	var/obj/structure/terminal/cargo_console/linked_cargo_console
	var/obj/structure/ship_elements/command_chair/linked_command_chair
	var/obj/structure/ship_elements/control_pad/linked_control_pad
	var/ignition = 0
	var/list/light_group_weapons = list()
	var/list/light_group_signals = list()
	var/list/light_group_command = list()
	var/list/light_group_general = list()
	var/list/tracking_list
	var/tracking_max = 3
	var/list/local_round_log = list()
	var/list/local_round_log_moves = list()
	var/list/local_round_log_full = list()
	var/list/ping_history = list()
	var/list/comms_messages = list()
	light_system = HYBRID_LIGHT
	light_color = "#660166"
	langchat_color = "#ec2fb3"

/obj/structure/shiptoship_master/ship_missioncontrol/proc/AnimateUse(type)
	switch(type)
		if(null)
			return
		if("on")
			icon_state = "mc_off_on"
			update_icon()
			set_light(2)
			sleep(20)
			icon_state = "mc_on"
			set_light(5)
			update_icon()
		if("off")
			icon_state = "mc_on_off"
			update_icon()
			set_light(2)
			sleep(15)
			icon_state = "mc_off"
			update_icon()
			set_light(0)


/obj/structure/shiptoship_master/ship_missioncontrol/proc/GetMobsInShipAreas()
	var/list/mobs_to_return = list()
	for(var/mob/mob_to_add in GLOB.mob_list)
		var/area/sts_ship/area_to_test = get_area(mob_to_add)
		if(area_to_test != null)
			if(area_to_test.ship_name == sector_map_data["name"])
				mobs_to_return.Add(mob_to_add)
	return mobs_to_return

/obj/structure/shiptoship_master/ship_missioncontrol/proc/AnnounceToCrew(message)
	to_chat(GetMobsInShipAreas(), "<span class='big'><span class='radio'><span class='name'>Mission Control<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[sector_map_data["name"]] \u0028PST-MC\u0029\u005D </b></span><span class='message'>, says \"[message]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)

/obj/structure/shiptoship_master/ship_missioncontrol/proc/LightGroup(group = null, state = null)
	switch(group)
		if("weapons")
			for(var/obj/structure/machinery/light/shiplight/light_to_switch in light_group_weapons)
				INVOKE_ASYNC(light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			return
		if("signals")
			for(var/obj/structure/machinery/light/shiplight/light_to_switch in light_group_signals)
				INVOKE_ASYNC(light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			return
		if("command")
			for(var/obj/structure/machinery/light/shiplight/light_to_switch in light_group_command)
				INVOKE_ASYNC(light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			return
		if("general")
			for(var/obj/structure/machinery/light/shiplight/light_to_switch in light_group_general)
				INVOKE_ASYNC(light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			return
		if("all")
			for(var/obj/structure/machinery/light/shiplight/w_light_to_switch in light_group_weapons)
				INVOKE_ASYNC(w_light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			for(var/obj/structure/machinery/light/shiplight/s_light_to_switch in light_group_signals)
				INVOKE_ASYNC(s_light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			for(var/obj/structure/machinery/light/shiplight/c_light_to_switch in light_group_command)
				INVOKE_ASYNC(c_light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			for(var/obj/structure/machinery/light/shiplight/g_light_to_switch in light_group_general)
				INVOKE_ASYNC(g_light_to_switch, TYPE_PROC_REF(/obj/structure/machinery/light/shiplight, StatusChange), state)
			return

/obj/structure/shiptoship_master/ship_missioncontrol/proc/Ignition()
	talkas("Standby. Beginning takeoff.")
	AnnounceToCrew("Attention crew of the [sector_map_data["name"]]. Launch procedure is under way. Takeoff in ten seconds.")
	sleep(100)
	AnnounceToCrew("Detaching from local power network. Activating LD transfer coils.")
	LightGroup(group = "all", state = "dim")
	sleep(30)
	AnimateUse("on")
	talkas("Mission Control Online. Hello, Arbiter [linked_command_chair.buckled_mob].")
	talkas("Activating main power loop. Stansby.")
	LightGroup(group = "weapons", state = "turn_on")
	linked_weapons_console.AnimateUse(1)
	talkas("Weapon systems online. Primary and Secondary cannon detected and linked.")
	LightGroup(group = "signals", state = "turn_on")
	linked_signals_console.AnimateUse(1)
	talkas("Signals system online. Probe and Tracking systems online. Communications uplink online.")
	LightGroup(group = "command", state = "turn_on")
	linked_damage_console.AnimateUse(1)
	linked_cargo_console.AnimateUse(1)
	talkas("Command chair uplink established.")
	LightGroup(group = "general", state = "turn_on")
	linked_control_pad.AnimateUse(1)
	talkas("Navigation systems ready for your input, Arbiter. The ship is yours.")
	ignition = 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/RepairShutdown(state = null)
	switch(state)
		if(null)
			return
		if(1)
			INVOKE_ASYNC(linked_signals_console,TYPE_PROC_REF(/obj/structure/terminal/signals_console/, ProcessShutdown),1)
			INVOKE_ASYNC(linked_weapons_console,TYPE_PROC_REF(/obj/structure/terminal/weapons_console/, ProcessShutdown),1)
			INVOKE_ASYNC(linked_damage_console,TYPE_PROC_REF(/obj/structure/terminal/damage_console/, ProcessShutdown),1)
			INVOKE_ASYNC(linked_cargo_console,TYPE_PROC_REF(/obj/structure/terminal/cargo_console/, ProcessShutdown),1)
			INVOKE_ASYNC(linked_command_chair,TYPE_PROC_REF(/obj/structure/ship_elements/command_chair/, ProcessShutdown),1)
			INVOKE_ASYNC(linked_control_pad,TYPE_PROC_REF(/obj/structure/ship_elements/control_pad/, ProcessShutdown),1)
			repair_shutdown = 1
		if(0)
			INVOKE_ASYNC(linked_signals_console,TYPE_PROC_REF(/obj/structure/terminal/signals_console/, ProcessShutdown),0)
			INVOKE_ASYNC(linked_weapons_console,TYPE_PROC_REF(/obj/structure/terminal/weapons_console/, ProcessShutdown),0)
			INVOKE_ASYNC(linked_damage_console,TYPE_PROC_REF(/obj/structure/terminal/damage_console/, ProcessShutdown),0)
			INVOKE_ASYNC(linked_cargo_console,TYPE_PROC_REF(/obj/structure/terminal/cargo_console/, ProcessShutdown),0)
			INVOKE_ASYNC(linked_command_chair,TYPE_PROC_REF(/obj/structure/ship_elements/command_chair/, ProcessShutdown),0)
			INVOKE_ASYNC(linked_control_pad,TYPE_PROC_REF(/obj/structure/ship_elements/control_pad/, ProcessShutdown),0)
			repair_shutdown = 0

/obj/structure/shiptoship_master/ship_missioncontrol/proc/SyncPosToMap()
	var/current_x = 1
	var/current_y = 1
	var/sync_complete = 0
	while(current_x <= GLOB.sector_map_x)
		while(current_y <= GLOB.sector_map_y)
			if(sector_map[current_x][current_y]["ship"]["id_tag"] == sector_map_data["id_tag"])
				sector_map_data["x"] = current_x
				sector_map_data["y"] = current_y
				sync_complete = 1
			if(sync_complete == 1) break
			current_y += 1
		if(sync_complete == 1) break
		current_y = 1
		current_x += 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/TrackerUpdate()
	var/current_tracker_pos = 1
	while(current_tracker_pos <= tracking_max)
		if(tracking_list[current_tracker_pos]["id_tag"] != "none")
			var/id_tag_to_track = tracking_list[current_tracker_pos]["id_tag"]
			var/current_tracker_scan_x = 1
			var/current_tracker_scan_y = 1
			var/new_tracker_x
			var/new_tracker_y
			while(current_tracker_scan_x <= GLOB.sector_map_x)
				while(current_tracker_scan_y <= GLOB.sector_map_y)
					if(sector_map[current_tracker_scan_x][current_tracker_scan_y]["ship"]["id_tag"] == id_tag_to_track)
						new_tracker_x = current_tracker_scan_x
						new_tracker_y = current_tracker_scan_y
						break
					if(sector_map[current_tracker_scan_x][current_tracker_scan_y]["missile"]["id_tag"] == id_tag_to_track)
						new_tracker_x = current_tracker_scan_x
						new_tracker_y = current_tracker_scan_y
						break
					current_tracker_scan_y += 1
				if(new_tracker_x != null) break
				current_tracker_scan_y = 1
				current_tracker_scan_x += 1
			if(new_tracker_x == null)
				tracking_list[current_tracker_pos]["id_tag"] = "none"
				tracking_list[current_tracker_pos]["x"] = 0
				tracking_list[current_tracker_pos]["y"] = 0
			else
				tracking_list[current_tracker_pos]["x"] = new_tracker_x
				tracking_list[current_tracker_pos]["y"] = new_tracker_y
		current_tracker_pos += 1


/obj/structure/shiptoship_master/ship_missioncontrol/NextTurn()
	local_round_log_full.Add("<hr><b>TURN [GLOB.combat_round]</b><hr>")
	local_round_log_full.Add(local_round_log)
	linked_command_chair.open_command_window("round_history")
	local_round_log = null
	local_round_log = list()
	SyncPosToMap()
	TrackerUpdate()
	if(sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["shield"] < 2) sector_map[sector_map_data["x"]][sector_map_data["y"]]["ship"]["shield"] += 1
	INVOKE_ASYNC(linked_signals_console,TYPE_PROC_REF(/obj/structure/terminal/signals_console/, SetUsageData),0)
	INVOKE_ASYNC(linked_weapons_console,TYPE_PROC_REF(/obj/structure/terminal/weapons_console/, SetUsageData),0)
	INVOKE_ASYNC(linked_control_pad,TYPE_PROC_REF(/obj/structure/ship_elements/control_pad/, SetUsageData),0)
	INVOKE_ASYNC(linked_damage_console,TYPE_PROC_REF(/obj/structure/terminal/damage_console/, SetUsageData),0,null)
	return 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/PingLog(entity_type = 0, pos_x = 0, pos_y = 0, name = "none", type = "none", target_x = 0, target_y = 0, speed = 0, hp = 0, faction = "none")
	switch(entity_type)
		if(1)
			ping_history.Add("[GLOB.combat_round]|<b>([pos_x],[pos_y])</b> | <b>Ship [name] - [type]</b> | IFF: <b>[faction]</b><br>Vector:<b>([target_x],[target_y])</b> Max: <b>[speed]</b> | Integrity: <b>[hp]</b>)")
		if(2)
			ping_history.Add("[GLOB.combat_round]|<b>([pos_x],[pos_y])</b> | <b>Pojectile [name] | Warhead: [type]<br>Payload: [hp] | Target:([target_x],[target_y]) | Velocity: [speed]")
		if(3)
			ping_history.Add("[GLOB.combat_round]|<b>([pos_x],[pos_y])</b> | <b>Unknown Ship:</b> Bearing: [type] | Velocity: [speed]")
		if(4)
			ping_history.Add("[GLOB.combat_round]|<b>([pos_x],[pos_y])</b> | <b>Unknown Projectile</b> Bearing: [type] | Velocity: [speed]")
	linked_command_chair.open_command_window("pings_and_tracking")

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
					target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]) - CONTACT", 10)
					target_console.terminal_display_line("Sound consistant with ship engine movement.",2)
					target_console.terminal_display_line("Bearing: [ReturnBearing(sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"], sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"])], Velocity: [sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"] + sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"]]",10)
					PingLog(entity_type = 3, pos_x = current_scan_pos_x, pos_y = current_scan_pos_y, type = ReturnBearing(sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"], sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"]), speed = sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["x"] + sector_map[current_scan_pos_x][current_scan_pos_y]["ship"]["vector"]["y"])
				if(sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["id_tag"] != "none")
					if(saved_len == target_console.terminal_buffer.len) target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]) - CONTACT",10)
					target_console.terminal_display_line("Contact. Projectile leapfrog trace detected.",2)
					target_console.terminal_display_line("Bearing: [ReturnBearing((sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["x"] - current_scan_pos_x), (sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["y"] - current_scan_pos_y))], Velocity: [sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["speed"]]", 10)
					PingLog(entity_type = 4, pos_x = current_scan_pos_x, pos_y = current_scan_pos_y, type = ReturnBearing((sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["x"] - current_scan_pos_x), (sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["target"]["y"] - current_scan_pos_y)), speed = sector_map[current_scan_pos_x][current_scan_pos_y]["missile"]["speed"])
				if(saved_len == target_console.terminal_buffer.len) target_console.terminal_display_line("Coordinate: ([current_scan_pos_x]),([current_scan_pos_y]): No contacts.",2)
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
			comms_messages.Add({"[GLOB.combat_round]|Direct message recieved. <b>Sender: [message_source]. Message: \<[message_to_add]\>.</b>"})
		if(1)
			comms_messages.Add({"[GLOB.combat_round]|Communications <b>activity detected in sector ([message_source]).</b>"})
		if(2)
			comms_messages.Add({"[GLOB.combat_round]|Incoming System-Wide <b>Message from [message_source]:</b> \<[message_to_add]\>"})
		if(3)
			comms_messages.Add({"[GLOB.combat_round]|Out of sector <b>comms pulse detected</b>!"})
	linked_command_chair.open_command_window("ship_messages")


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
					player_ship_console.talkas("New Direct Message recieved!",1)
					player_ship_console.linked_signals_console.talkas("New Direct Message recieved!",1)
	return 1

/obj/structure/shiptoship_master/ship_missioncontrol/proc/WriteToShipLog(shiplog_event = null, shiplog_dest_x = null, shiplog_dest_y = null)
	var/event_to_add_ship = shiplog_event
	var/shiplog_coordinate_x = shiplog_dest_x
	var/shiplog_coordinate_y = shiplog_dest_y
	switch(event_to_add_ship)
		if("collision_move")
			local_round_log.Add("Ship engine pattern changes suggest a <b>near-collision in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
		if("collision_boundary")
			local_round_log.Add("<b>Emergency maneuvers and rapid engine deceleration<b> detected on Twilight Boundary of Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)].")
		if("regular_move")
			local_round_log.Add("Engine noise related to <b>ship movement detected in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>.")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
		if("missile_collision")
			local_round_log.Add("Detonation detected after mulitple Projectile movement traces in Sector [SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]")
		if("missile_move","warhead_miss","warhead_homing")
			local_round_log.Add("Projectile leapfrog trace in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>.")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
		if("warhead_hit", "explosive_splash")
			local_round_log.Add("Warhead explosion detected in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
			if(local_round_log_moves.Find("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>") == 0) local_round_log_moves.Add("<b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
		if("hit_shield")
			local_round_log.Add("Deflector <b>shield impact</b> detected.")
		if("shield_break")
			local_round_log.Add("Defletor <b>shield collapse</b> detected.")
		if("destroy_complete")
			local_round_log.Add("Multiple explosions and ship fragmentation detected. High likelihood of a complete loss event.")
		if("destroy_engine")
			local_round_log.Add("Twilight Paradox Engine Collapse detected. Escape pod launches detected.")
		if("destroy_systems")
			local_round_log.Add("Rapid, repeated explosions followed by escape pod activation detected. On-board system failre likely.")
		if("destroy_weapons")
			local_round_log.Add("Wepon bay detonation detected. High casuality event expected.")
		if("destroy_hull")
			local_round_log.Add("Cascading hull breach detected. Partial ship fragmentation and high casualty event expected.")
		if("nuclear_hit")
			local_round_log.Add("<b>WARNING:</b> Nuclear detonation detected in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
			if(local_round_log_moves.Find("[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]") == 0) local_round_log_moves.Add("[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]")
		if("mip_deploy")
			local_round_log.Add("MIP Warhead reports deploying its payload in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
		if("mip_payload_fail")
			local_round_log.Add("MIP Warhead reports failure to deploy its payload due to misconfiguration in Sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>")
		if("mip_warhead_hit")
			local_round_log.Add("A MIP <b>projectile impact detected</b>.")
		if("npc_sonar_hit")
			local_round_log.Add("A conventional <b>sonar</b> pulse <b>is targetting this vessel</b>. Origin sector: <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
		if("npc_sonar_miss")
			local_round_log.Add("Conventional <b>sonar activity detected</b> in system.")
		if("missile_launch")
			local_round_log.Add("<b>Missile launch<b> detected in sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
		if("missile_own_launch")
			local_round_log.Add("Missile launched from own vessel.")
		if("secondary_fire")
			local_round_log.Add("<b>Secondary fire detected</b> in sector <b>[SectorConversion(shiplog_coordinate_x,shiplog_coordinate_y)]</b>!")
		if("secondary_own_fire")
			local_round_log.Add("Secondary fire from own vessel.")
		if("secondary_hit")
			local_round_log.Add("<b>Impact detected!</b>")
		if("secondary_miss")
			local_round_log.Add("<b>No Impact!</b>")
	linked_command_chair.open_command_window("current_round")

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
	if(id != null)
		while (current_track_pos <= tracking_max)
			if(tracking_list[current_track_pos]["id_tag"] != "none")
				if (tracking_list[current_track_pos]["id_tag"] == id) break
			current_track_pos += 1
	if(id == null)
		while (current_track_pos <= tracking_max)
			if(tracking_list[current_track_pos]["id_tag"] == "none") break
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
		var/tracker_check_result = TrackerCheck(id = sector_map[x_to_target_track][y_to_target_track]["ship"]["id_tag"])
		var/tracker_empty_slot = TrackerCheck (id = null)
		if(tracker_empty_slot == 0)
			target_console.terminal_display_line("Error: No free trackers. Use TRACKER R to terminate a tracker by ID. Tracker Lost.")
			target_console.usage_data["tracker_uses_current"] += 1
			return 1
		else if(tracker_check_result == 0)
			tracking_list[tracker_empty_slot]["x"] = x_to_target_track
			tracking_list[tracker_empty_slot]["y"] = y_to_target_track
			target_console.terminal_display_line("Success. Tracker ID [tracker_empty_slot] installed on ship entity at ([x_to_target_track],[y_to_target_track])")
			tracking_list[tracker_empty_slot]["id_tag"] = sector_map[x_to_target_track][y_to_target_track]["ship"]["id_tag"]
			target_console.usage_data["tracker_uses_current"] += 1
			return 1
	if(sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"] != "none")
		var/tracker_check_result = TrackerCheck(id = sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"])
		var/tracker_empty_slot = TrackerCheck (id = null)
		if(tracker_empty_slot == 0)
			target_console.terminal_display_line("Error: No free trackers. Use TRACKER R to terminate a tracker by ID. Tracker Lost.")
			target_console.usage_data["tracker_uses_current"] += 1
			return 1
		else if(tracker_check_result == 0)
			tracking_list[tracker_empty_slot]["x"] = x_to_target_track
			tracking_list[tracker_empty_slot]["y"] = y_to_target_track
			target_console.terminal_display_line("Success. Tracker ID [tracker_empty_slot] installed on missile entity at ([x_to_target_track],[y_to_target_track])")
			tracking_list[tracker_empty_slot]["id_tag"] = sector_map[x_to_target_track][y_to_target_track]["missile"]["id_tag"]
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
	while(current_x <= GLOB.sector_map_x)
		while(current_y <= GLOB.sector_map_y)
			if(sector_map[current_x][current_y]["ship"]["name"] == sector_map_data["name"])
				sector_map[current_x][current_y]["ship"]["status"] = "Player"
				sector_map_data["id_tag"] = sector_map[current_x][current_y]["ship"]["id_tag"]
				sector_map_data["x"] = current_x
				sector_map_data["y"] = current_y
			if(sector_map_data["x"] != 0 && sector_map_data["y"] != 0) break
			current_y += 1
		if(sector_map_data["x"] != 0 && sector_map_data["y"] != 0) break
		current_y = 1
		current_x += 1
	if(sector_map_data["x"] == 0 || sector_map_data["y"] == 0)
		to_chat(usr, SPAN_WARNING("Error. [sector_map_data["name"]] not found on Sector Map or invalid coords. Aborting."))
		return
	var/list/area_contents = list()
	for(var/area/areas_to_scan in GLOB.sts_ship_areas)
		area_contents.Add(areas_to_scan.GetAllContents())
	if(linked_signals_console == null)
		for(var/obj/structure/terminal/signals_console/console in area_contents)
			if(console.ship_name == sector_map_data["name"])
				linked_signals_console = console
				console.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_signals_console)
				to_chat(world, SPAN_INFO("Singals Console Linked at [turf_return.x],[turf_return.y]"))
				break
	if(linked_damage_console == null)
		for(var/obj/structure/terminal/damage_console/console in area_contents)
			if(console.ship_name == sector_map_data["name"])
				linked_damage_console = console
				console.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_damage_console)
				to_chat(world, SPAN_INFO("Damage Console Linked at [turf_return.x],[turf_return.y]"))
				break
	if(linked_weapons_console == null)
		for(var/obj/structure/terminal/weapons_console/console in area_contents)
			if(console.ship_name == sector_map_data["name"])
				linked_weapons_console = console
				console.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_weapons_console)
				to_chat(world, SPAN_INFO("Weapons Console Linked at [turf_return.x],[turf_return.y]"))
				break
	if(linked_cargo_console == null)
		for(var/obj/structure/terminal/cargo_console/console in area_contents)
			if(console.ship_name == sector_map_data["name"])
				linked_cargo_console = console
				console.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_cargo_console)
				to_chat(world, SPAN_INFO("Cargo Console Linked at [turf_return.x],[turf_return.y]"))
				break
	if(linked_command_chair == null)
		for(var/obj/structure/ship_elements/command_chair/chair in area_contents)
			if(chair.ship_name == sector_map_data["name"])
				linked_command_chair = chair
				chair.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_command_chair)
				to_chat(world, SPAN_INFO("Command Chair Linked at [turf_return.x],[turf_return.y]"))
				break
	if(linked_control_pad == null)
		for(var/obj/structure/ship_elements/control_pad/pad in area_contents)
			if(pad.ship_name == sector_map_data["name"])
				linked_control_pad = pad
				pad.LinkToShipMaster(master_console = src)
				var/turf/turf_return = get_turf(linked_control_pad)
				to_chat(world, SPAN_INFO("Ship Control Pad at [turf_return.x],[turf_return.y]"))
				break
	var/light_counter = 0
	for(var/obj/structure/machinery/light/shiplight/shiplight_to_add in world)
		if(shiplight_to_add.ship_name == sector_map_data["name"])
			switch(shiplight_to_add.ship_light_group)
				if(null)
					return
				if("weapons")
					light_group_weapons.Add(shiplight_to_add)
					light_counter += 1
				if("signals")
					light_group_weapons.Add(shiplight_to_add)
					light_counter += 1
				if("command")
					light_group_command.Add(shiplight_to_add)
					light_counter += 1
				if("general")
					light_group_general.Add(shiplight_to_add)
					light_counter += 1
	to_chat(world, SPAN_INFO("Light groups initialized, [light_counter] active."))
	sector_map_data["initialized"] = 1
	to_chat(world, SPAN_INFO("Ship [sector_map_data["name"]] Initalized on the Sector Map."))

/obj/structure/shiptoship_master/ship_missioncontrol/proc/IncomingMapDamage(type = null, ammount = null)
	var/type_to_deal
	switch(type)
		if(1)
			type_to_deal = "engine"
		if(2)
			type_to_deal = "systems"
		if(3)
			type_to_deal = "weapons"
		if(4)
			type_to_deal = "hull"
	linked_damage_console.ProcessShipDamage(system = type_to_deal, value = ammount)

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

/obj/structure/shiptoship_master/ship_missioncontrol/proc/GetWeaponsReadout()
	var/list/weapons_status_to_return = list()
	if(linked_weapons_console.linked_primary_cannon.loaded_projectile["loaded"] == 0)
		weapons_status_to_return.Add("Primary Weapon: <b>NOT PRIMED</b>")
	else
		weapons_status_to_return.Add("Primary Weapon: <b>[linked_weapons_console.linked_primary_cannon.loaded_projectile["missile"]]</b> - <b>[linked_weapons_console.linked_primary_cannon.loaded_projectile["warhead"]]</b>")
	if(linked_weapons_console.linked_secondary_cannon.loaded_projectile["loaded"] == 0)
		weapons_status_to_return.Add("Secondary Weapon: <b>NOT PRIMED</b>")
	else
		weapons_status_to_return.Add("Secodary Weapon: <b>[linked_weapons_console.linked_primary_cannon.loaded_projectile["type"]]</b>")
	var/probe_status
	if(linked_signals_console.linked_probe_launcher.probe_loaded == 0) probe_status = "EMPTY"
	if(linked_signals_console.linked_probe_launcher.probe_loaded == 1) probe_status = "LOADED"
	var/tracker_status
	if(linked_signals_console.linked_tracker_launcher.tracker_loaded == 0) tracker_status = "EMPTY"
	if(linked_signals_console.linked_tracker_launcher.tracker_loaded == 1) tracker_status = "LOADED"
	weapons_status_to_return.Add("PROBE: <b>[probe_status]</b>")
	weapons_status_to_return.Add("TRACKER: <b>[tracker_status]</b>")
	return weapons_status_to_return
