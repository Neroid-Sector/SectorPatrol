/datum/admins/proc/mission_control_panel()
	set name = "Mission Control Panel"
	set category = "DM.Control"

	if(!check_rights(R_ADMIN)) return
	MissionControl(window = "Main")
	return

/client/verb/fixspuis()
	set name = "Force Close Sector Patrol Interfaces"
	set category = "OOC.Fix"

	if (usr.sp_uis.len != 0)
		while(usr.sp_uis.len != 0)
			var/ui_to_close = jointext(usr.sp_uis,null,1,2)
			usr << browse(null, ui_to_close)
			usr.sp_uis.Cut(1,2)
		to_chat(usr, SPAN_INFO("Sector Patrol Interfaces closed."))
		return
	else
		to_chat(usr, SPAN_INFO("No Interfaces to close in personal history. Either the UI was not configured properly, or this is not an UI error. Either way, please contact staff."))
		return

/datum/admins/proc/MissionControl(window = null)
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
	if(!check_rights(R_ADMIN)) return
	if(window == null) return
	if(window == "Main")
		if(GLOB.savefile_initiated == 0)
			window = "General"


	var/dat = {"<!DOCTYPE html>
			<html>
		"}
	//css and header
	dat += {"
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
		.text{
		padding: 5px;
		}
		</head>
		</style>
		<body>
		<div id="main_window">
		<div class="box">
		<p style="font-size: 120%;">
		<b>SECTOR PATROL DM PANEL</b>
		</p>
		</div>
		"}
	//window content
	switch(window)
		if("General")
			if(GLOB.savefile_initiated == 0)
				dat += {"
					<div class="box">
					<div class="text">
					<p>
					General state not loaded.
					</p>
					<p>
					<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];load_general_save=1'>Load or Create new General Save</A>
					</p>
					<p>
					</div>
					</div>
					"}
			if(GLOB.savefile_initiated == 1)
				dat += {"<div class="box">
				<div class="text">
				<p>
				<b>Current General Information:</b></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=date'>Date:</a> <b>[GLOB.ingame_date]</b> | <A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=time'>Time:</a> <b>[time2text((GLOB.ingame_time - SSticker.round_start_time)+ world.time,"hh:mm",0)]</b>|</p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=location'>Location:</a> <b>[GLOB.ingame_location]</b> | <A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=system'>System:</a> <b>[GLOB.ingame_current_system]</b></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=mission'>Mission Type</a>: <b>[GLOB.ingame_mission_type]</b></p>
				<p><b>Narrations:</b></p>
				<p>Mission Control:</p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=mc_hello'>Hello:</a> <b>[GLOB.mission_control_hello]</b></p>
				<p>Player Roundstart:</p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=start_header'>Header:</a> <b>[GLOB.start_narration_header]</b></p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=start_body'>Body:</a> <b>[GLOB.start_narration_body]</b></p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=start_footer'>Footer:</a> <b>[GLOB.start_narration_footer]</b></p>
				<p>Roundend:</p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=end_header'>Header:</a> <b>[GLOB.end_narration_header]</b></p><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];edit_general_info=end_body'>Body:</a> <b>[GLOB.end_narration_body]</b></p>
				</div>
				<div class="box">
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];load_general_save=1'>LOAD</A> | <A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];save_general_save=1'>SAVE</A></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];open_mission_control=Main'>Back to Main Menu</p>
				</div>
				</div>
				"}
		if("Main")
			dat += {"<div_class="box">
				<div class="text">
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];open_mission_control=General'>Load/Save, Review and Set IC Infromation</a></p>
				</div>
				</div>
				"}
		if("Comms")
		if("ShipToShip")
			if(!sts_master)
				to_chat(usr, SPAN_WARNING("Error: No STS Master found in world. Most likely a mapping error."))
				return
			if(GLOB.sector_map_initialized == 0)
				to_chat(usr, SPAN_WARNING("Sector Map not Initialized. Initializing now."))
				GLOB.sector_map_x = tgui_input_number(usr, "Verify X Height", "X Height", GLOB.sector_map_x, min_value = 1, timeout = 0)
				if(GLOB.sector_map_x == null) GLOB.sector_map_x = 100
				GLOB.sector_map_y = tgui_input_number(usr, "Verify Y Height", "Y Height", GLOB.sector_map_y, min_value = 1, timeout = 0)
				if(GLOB.sector_map_y == null) GLOB.sector_map_y = 100
				sts_master.sector_map = new/list(GLOB.sector_map_x, GLOB.sector_map_y)
				if(sts_master.populate_map() == 1) GLOB.sector_map_initialized = 1
			dat += {"<div_class="box">
				<div class="text">
				<p><b>SHIP TO SHIP PANEL</b></p>
				<p>INITIATED: [GLOB.combat_initiated] | ROUND: [GLOB.combat_round]</p>
				<p>ENTITY CONTROL</p>
				<p>ROUND FLOW CONTROL</p>
				</div>
				</div>
				"}
		if("ShipToShip_Entities")
			var/displayed_entities = (jointext((sts_master.scan_entites(category = 0, output_format = 0)), "</p><p>")+"</p><p>"+jointext((sts_master.scan_entites(category = 1, output_format = 0)), "</p><p>"))
			dat += {"<div_class="box">
				<div class="text">
				<p><b>ENTITY_CONTROL</b></p>
				<p>[displayed_entities]</p>
				<p><b>Add</b> | <b>Modify</b> | <b>Remove</b></p>
				<p><b>Load Preset</b></p>
				<p><b>Link and Initialize Player Ships</b></p>
				</div>
				</div>
				"}
		if("ShipToShip_RoundControl")
			var/round_phase_text
			dat += {"{"<div_class="box">
				<div class="text">
				<p><b>SHIP TO SHIP ROUND FLOW PANEL</b></p>
				</div>
				</div>
				"}
			switch(GLOB.round_phase)
				if(1)
					round_phase_text = "DM - Comms"
				if(2)
					round_phase_text = "DM - Movement and Firing"
				if(3)
					round_phase_text = "Players"
				if(4)
					round_phase_text = "Advancing Turn..."
			if(GLOB.round_phase == 4)
				dat+= {"<div_class="box">
				<div class="text">
				<p>TURN ADVANCING...</p>
				</div>
				</div>
				"}
			else
				dat += {"<div_class="box">
					<div class="text">
					<p>Phase: <b>[round_phase_text]</b></p>
					<p><b>Advance Phase/Turn</p>
					</div>
					</div>
					<div_class="box">
					<div class="text">
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];view_ship_log=round'>View Round Log</a></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];view_ship_log=full'>View Full Log</a></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];send_ship_comms=1'>Send Comms</a></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];control_npc_ship=1'>Change Ship Vectors</a></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sonar_ping=1'>Send Sonar Ping</a></p>
					<p>Fire as Ship</p>
					</div>
					</div>
					"}
		if("ShipToShip_LastRoundLog")
			var/log_to_display = jointext(sts_master.round_history_current, "</p><p>")
			dat += {"<div_class="box">
				<div class="text">
				<p>Current Log Round</p>
				<p>ROUND: [GLOB.combat_round]</p>
				</div>
				</div>
				<div_class="box">
				<div class="text">
				<p>[log_to_display]</p>
				</div>
				</div>
				"}
		if("ShipToShip_FullRoundLog")
			var/log_to_display = jointext(sts_master.round_history, "</p><p>")
			dat += {"<div_class="box">
				<div class="text">
				<p>Full StS Log</p>
				</div>
				</div>
				<div_class="box">
				<div class="text">
				<p>[log_to_display]</p>
				</div>
				</div>
				"}
	//footer etc
	dat += {"
		</div>
		</body>
		"}

	usr << browse(dat,"window=mission_control_[usr]_[window];display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	if(usr.sp_uis.Find("mission_control_[usr]_[window]") == 0)
		usr.sp_uis += "mission_control_[usr]_[window]"
	onclose(usr, "mission_control_[usr]_[window]")

/datum/admins/proc/view_ship_log(log_type = null)
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	if(!sts_master)
		to_chat(usr, SPAN_WARNING("Error: No sts_master item. Most likely a mapping error. Can be mostly circumvented by spawning in the master item."))
		return
	switch(log_type)
		if("round")
			MissionControl(window = "ShipToShip_LastRoundLog")
			return
		if("full")
			MissionControl(window = "ShipToShip_FullRoundLog")
			return

/datum/admins/proc/sonar_ping()
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	var/list/sonar_player_ships = list()
	var/list/sonar_npc_ships = list()
	var/sonar_scan_x = 1
	var/sonar_scan_y = 1
	while (sonar_scan_x <= GLOB.sector_map_x)
		while(sonar_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["id_tag"] != "none")
				if(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["status"] == "Player")
					sonar_player_ships += sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["name"]
				if(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["status"] != "Player")
					sonar_npc_ships += sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["name"]
			sonar_scan_y += 1
		sonar_scan_y = 1
		sonar_scan_x += 1
	var/sonar_origin = tgui_input_list(usr, "Select a sonar ORIGIN point.", "SONAR ORIGIN", sonar_npc_ships, timeout = 0)
	var/sonar_target = tgui_input_list(usr, "Select a sonar TARGET point.", "SONAR TARGET", sonar_player_ships, timeout = 0)
	var/sonar_origin_x
	var/sonar_origin_y
	sonar_scan_x = 1
	sonar_scan_y = 1
	while (sonar_scan_x <= GLOB.sector_map_x)
		while(sonar_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["name"] == sonar_origin)
				sonar_origin_x = sonar_scan_x
				sonar_origin_y = sonar_scan_y
			if(sonar_origin_x != null) break
			sonar_scan_y += 1
		if(sonar_origin_x != null) break
		sonar_scan_y = 1
		sonar_scan_x += 1
	var/sonar_roll_result = rand(1,100)
	to_chat(usr, SPAN_NOTICE("Scanner ping from [sonar_origin] to [sonar_target] roll result: [sonar_roll_result]"))
	sts_master.log_round_history(event = "npc_sonar", log_source = sonar_origin, log_target = sonar_target, log_dest_x = sonar_roll_result)
	for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_sonar in world)
		if (ship_mc_sonar.sector_map_data["name"] == sonar_target)
			ship_mc_sonar.WriteToShipLog(shiplog_event = "npc_sonar_hit", shiplog_dest_x = sonar_origin_x, shiplog_dest_y = sonar_origin_y)
		else
			ship_mc_sonar.WriteToShipLog(shiplog_event = "npc_sonar_miss")
	return

/datum/admins/proc/control_npc_ship()
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	var/list/control_npc_ships = list()
	var/control_scan_x = 1
	var/control_scan_y = 1
	while (control_scan_x <= GLOB.sector_map_x)
		while(control_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[control_scan_x][control_scan_y]["ship"]["id_tag"] != "none")
				if(sts_master.sector_map[control_scan_x][control_scan_y]["ship"]["status"] != "Player")
					control_npc_ships += sts_master.sector_map[control_scan_x][control_scan_y]["ship"]["name"]
			control_scan_y += 1
		control_scan_y = 1
		control_scan_x += 1
	var/ship_name_to_control = tgui_input_list(usr, "Select a ship to control", "Ship selection", control_npc_ships, timeout = 0)
	if(ship_name_to_control == null) return
	var/control_target_x
	var/control_target_y
	control_scan_x = 1
	control_scan_y = 1
	while (control_scan_x <= GLOB.sector_map_x)
		while(control_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[control_scan_x][control_scan_y]["ship"]["name"] == ship_name_to_control)
				control_target_x = control_scan_x
				control_target_y = control_scan_y
			if(control_target_x != null) break
			control_scan_y += 1
		if(control_target_x != null) break
		control_scan_y = 1
		control_scan_x += 1
	sts_master.open_movement_console(x = control_target_x, y = control_target_y)
	return


/datum/admins/proc/send_ship_comms()
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	var/list/comms_player_ships = list()
	var/list/comms_npc_ships = list()
	var/comms_scan_x = 1
	var/comms_scan_y = 1
	while (comms_scan_x <= GLOB.sector_map_x)
		while(comms_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["id_tag"] != "none")
				if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["status"] == "Player")
					comms_player_ships += sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"]
				if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["status"] != "Player")
					comms_npc_ships += sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"]
			comms_scan_y += 1
		comms_scan_y = 1
		comms_scan_x += 1
	var/comms_source = tgui_input_list(usr, "Select Message Sender","Sender Select",list(comms_npc_ships,"Custom"),timeout = 0)
	var/comms_source_x
	var/comms_source_y
	var/comms_source_custom
	var/comms_dest_x
	var/comms_dest_y
	if(comms_source == null) return
	if(comms_source == "Custom")
		comms_source_custom = tgui_input_text(usr, "Enter Name of comms source, will be displayed on all player comms consoles", "Custom Comms Source", timeout = 0)
		if(comms_source_custom == null) comms_source_custom = "Unknown"
	var/comms_dest = tgui_input_list(usr, "Select Message Destination", "Destination Select", list(comms_player_ships,comms_npc_ships,"System-Wide"))
	if(comms_dest == null) return
	if(comms_source != "Custom")
		comms_scan_x = 1
		comms_scan_y = 1
		while (comms_scan_x <= GLOB.sector_map_x)
			while(comms_scan_y <= GLOB.sector_map_y)
				if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"] == comms_source)
					comms_source_x = comms_scan_x
					comms_source_y = comms_scan_y
				if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"] == comms_dest)
					comms_dest_x = comms_scan_x
					comms_dest_y = comms_scan_y
				if(comms_source_x != null && comms_dest != null) break
				comms_scan_y += 1
			if(comms_source_x != null && comms_dest != null) break
			comms_scan_y = 1
			comms_scan_x += 1
	var/comms_text = tgui_input_text(usr, "Enter Comms Message", "Comms MSG", max_length = MAX_BOOK_MESSAGE_LEN, timeout = 0)
	if(comms_text == null) return
	if(comms_dest != "System-Wide")
		if(comms_source != "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				if(ship_mc_to_comm.sector_map_data["name"] == comms_dest)
					ship_mc_to_comm.comms_messages += "([ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y)]),\"[comms_source]\" - [comms_text]"
					ship_mc_to_comm.talkas("Incomming communicatins from in-sector!", 1)
					ship_mc_to_comm.linked_signals_console.talkas("Incomming communicatins from in-sector!",1)
				if(ship_mc_to_comm.sector_map_data["name"] != comms_dest)
					ship_mc_to_comm.comms_messages += "Communications Pulse detected from sector [ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y)])!"
			sts_master.log_round_history(event = "comms_ping", log_source = comms_source, log_target = comms_text, log_dest_x = comms_dest_x, log_dest_y = comms_dest_y)
			return
		if(comms_source == "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				if(ship_mc_to_comm.sector_map_data["name"] == comms_dest)
					ship_mc_to_comm.comms_messages += "[comms_source_custom] - [comms_text]"
					ship_mc_to_comm.talkas("Incomming communicatins from [comms_source_custom]!", 1)
					ship_mc_to_comm.linked_signals_console.talkas("Incomming communicatins from [comms_source_custom]!",1)
				if(ship_mc_to_comm.sector_map_data["name"] != comms_dest)
					ship_mc_to_comm.comms_messages += "Out of Sector Comms pulse detected!"
			sts_master.log_round_history(event = "comms_ping", log_source = comms_source_custom, log_target = comms_text, log_dest_x = comms_dest_x, log_dest_y = comms_dest_y)
			return
	if(comms_dest == "System-Wide")
		if(comms_source != "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				ship_mc_to_comm.comms_messages += "([ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y)]),\"[comms_source]\" - [comms_text]"
				ship_mc_to_comm.talkas("Incomming sector wide communications!", 1)
				ship_mc_to_comm.linked_signals_console.talkas("Incomming sector wide communications!",1)
			sts_master.log_round_history(event = "comms_ping_system", log_source = comms_source, log_target = comms_text)
			return
		if(comms_source == "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				ship_mc_to_comm.comms_messages += "[comms_source_custom] - [comms_text]"
				ship_mc_to_comm.talkas("Incomming sector wide communications!", 1)
				ship_mc_to_comm.linked_signals_console.talkas("Incomming sector wide communications!",1)
			sts_master.log_round_history(event = "comms_ping_system", log_source = comms_source_custom, log_target = comms_text)
			return

/datum/admins/proc/set_narration_preset()
	set name = "Comms Set Preset"
	set category = "DM.Narration"

	var/list/comms_presets = list("Mission Control","Cassandra","Alysia","Boulette","Custom")
	switch(tgui_input_list(usr,"Select a Comms Preset","PRESET",comms_presets,timeout = 0))
		if(null)
			return
		if("Mission Control")
			usr.narration_settings["Name"] = "Mission Control"
			usr.narration_settings["Location"] = "OV-PST"
			usr.narration_settings["Position"] = "TC-MC"
		if("Cassandra")
			usr.narration_settings["Name"] = "CDR. Cassandra Reed-Wilo"
			usr.narration_settings["Location"] = "OV-PST"
			usr.narration_settings["Position"] = "PST-CSO"
		if("Alysia")
			usr.narration_settings["Name"] = "CDR. Alysia Reed-Wilo"
			usr.narration_settings["Location"] = "OV-PST"
			usr.narration_settings["Position"] = "PST-CE"
		if("Boulette")
			usr.narration_settings["Name"] = "RDML. Thomas Boulette"
			usr.narration_settings["Location"] = "OV-PST"
			usr.narration_settings["Position"] = "PST-CO"
		if("Custom")
			usr.narration_settings["Name"] = tgui_input_text(usr, "Enter the name, complete with a rank prefix.", "NAME entry", usr.narration_settings["Name"], timeout = 0)
			usr.narration_settings["Location"] = tgui_input_text(usr, "Enter assignment or location, when in doubt, OV-PST works.", "LOCATION entry", usr.narration_settings["Location"], timeout = 0)
			usr.narration_settings["Position"] = tgui_input_text(usr, "Enter held position like CE, CO, RFN or whatnot. Prefaced with some specialty acronym also can work.", "POSITION entry", usr.narration_settings["Position"], timeout = 0)
	return

/datum/admins/proc/speak_to_comms()
	set name = "Comms Speak"
	set category = "DM.Narration"

	if(usr.narration_settings["Name"] == null || usr.narration_settings["Location"] == null || usr.narration_settings["Position"] == null) set_narration_preset()
	var/text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")
	while(text_to_comm != null)
		to_chat(world, "<span class='big'><span class='radio'><span class='name'>[usr.narration_settings["Name"]]<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[usr.narration_settings["Location"]] \u0028[usr.narration_settings["Position"]]\u0029\u005D </b></span><span class='message'>, says \"[text_to_comm]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
		text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")

/datum/admins/proc/save_general_save(save = null)
	if(!check_rights(R_ADMIN)) return
	var/savefile/G
	if(!save)
		G = new("data/persistance/globals.sav")
	else
		G = save
	G["Date"] << GLOB.ingame_date
	G["Time"] << GLOB.ingame_time
	G["Mission_Control_Hello"] << GLOB.mission_control_hello
	G["Location"] << GLOB.ingame_location
	G["ingame_current_system"] << GLOB.ingame_current_system
	G["Mission_Type"] << GLOB.ingame_mission_type
	G["start_narration_header"] << GLOB.start_narration_header
	G["start_narration_footer"] << GLOB.start_narration_footer
	G["start_narration_body"] << GLOB.start_narration_body
	G["end_narration_header"] << GLOB.end_narration_header
	G["end_narration_body"] << GLOB.end_narration_body
	to_chat(src, SPAN_BOLDWARNING("General data saved."))
	if(GLOB.savefile_initiated == 0) GLOB.savefile_initiated = 1
	MissionControl(window = "General")

/datum/admins/proc/load_general_save()
	if(!check_rights(R_ADMIN)) return
	var/savefile/G = new("data/persistance/globals.sav")
	if(!G)
		to_chat(usr, SPAN_INFO("General Savefile not found. Creating new file."))
		save_general_save(save = G)
	else
		G["Date"] >> GLOB.ingame_date
		G["Time"] >> GLOB.ingame_time
		G["Mission_Control_Hello"] >> GLOB.mission_control_hello
		G["Location"] >> GLOB.ingame_location
		G["ingame_current_system"] >> GLOB.ingame_current_system
		G["Mission_Type"] >> GLOB.ingame_mission_type
		G["start_narration_header"] >> GLOB.start_narration_header
		G["start_narration_footer"] >> GLOB.start_narration_footer
		G["start_narration_body"] >> GLOB.start_narration_body
		G["end_narration_header"] >> GLOB.end_narration_header
		G["end_narration_body"] >> GLOB.end_narration_body
		to_chat(src, SPAN_BOLDWARNING("General data loaded."))
		if(GLOB.savefile_initiated == 0) GLOB.savefile_initiated = 1
		MissionControl(window = "General")

/datum/admins/proc/edit_general_info(type_to_edit = null)
	if(!check_rights(R_ADMIN)) return
	if(type_to_edit == null) return
	var/oldvalue
	switch(type_to_edit)
		if("date")
			oldvalue = GLOB.ingame_date
			GLOB.ingame_date = tgui_input_text(usr, message = "Enter Date to display:", title = "Date Entry", default = "[GLOB.ingame_date]", timeout = 0)
			if(GLOB.ingame_date == null) GLOB.ingame_date = oldvalue
		if("time")
			oldvalue = GLOB.ingame_time
			var/newtime_hrs = tgui_input_number(usr, message = "In-game time, HOURS:", title = "Time Entry HOURS", timeout = 0)
			var/newtime_min = tgui_input_number(usr, message = "In-game time, MINUTES:", title = "Time Entry MINUTES", timeout = 0)
			GLOB.ingame_time = ((newtime_hrs * 36000) + (newtime_min * 600)) - world.time
			if(GLOB.ingame_time == null) GLOB.ingame_time = oldvalue
		if("mc_hello")
			oldvalue = GLOB.mission_control_hello
			GLOB.mission_control_hello = tgui_input_text(usr, message = "Change Mission Control Hello:", title = "Mission Control Hello", default = "[GLOB.mission_control_hello]", timeout = 0)
			if(GLOB.mission_control_hello == null) GLOB.mission_control_hello = oldvalue
		if("location")
			oldvalue = GLOB.ingame_location
			GLOB.ingame_location = tgui_input_text(usr, message = "Enter Location to display:", title = "Location Entry", default = "[GLOB.ingame_location]", timeout = 0)
			if(GLOB.ingame_location == null) GLOB.ingame_location = oldvalue
		if("system")
			oldvalue = GLOB.ingame_current_system
			GLOB.ingame_current_system = tgui_input_text(usr, message = "Enter System to display:", title = "Star System Entry", default = "[GLOB.ingame_current_system]", timeout = 0)
			if(GLOB.ingame_current_system == null) GLOB.ingame_current_system = oldvalue
		if("mission")
			oldvalue = GLOB.ingame_mission_type
			GLOB.ingame_mission_type = tgui_input_text(usr, message = "Enter Mission Type:", title = "Mission Type Entry", default = "[GLOB.ingame_mission_type]", timeout = 0)
			if(GLOB.ingame_mission_type == null) GLOB.ingame_mission_type = oldvalue
		if("start_header")
			oldvalue = GLOB.start_narration_header
			GLOB.start_narration_header = tgui_input_text(usr, message = "Start Narration Header:", title = "Narration Entry", default = "[GLOB.start_narration_header]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, timeout = 0)
			if(GLOB.start_narration_header == null) GLOB.start_narration_header = oldvalue
		if("start_body")
			oldvalue = GLOB.start_narration_body
			GLOB.start_narration_body = tgui_input_text(usr, message = "Start Narration Body:", title = "Narration Entry", default = "[GLOB.start_narration_body]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, timeout = 0)
			if(GLOB.start_narration_body == null) GLOB.start_narration_body = oldvalue
		if("start_footer")
			oldvalue = GLOB.start_narration_footer
			GLOB.start_narration_footer = tgui_input_text(usr, message = "Start Narration Footer:", title = "Narration Entry", default = "[GLOB.start_narration_footer]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, timeout = 0)
			if(GLOB.start_narration_footer == null) GLOB.start_narration_footer = oldvalue
		if("end_header")
			oldvalue = GLOB.end_narration_header
			GLOB.end_narration_header = tgui_input_text(usr, message = "End Narration Header:", title = "Narration Entry", default = "[GLOB.end_narration_header]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, timeout = 0)
			if(GLOB.end_narration_header == null) GLOB.end_narration_header = oldvalue
		if("end_body")
			oldvalue = GLOB.end_narration_body
			GLOB.end_narration_body = tgui_input_text(usr, message = "EBd Narration Body:", title = "Narration Entry", default = "[GLOB.end_narration_body]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, timeout = 0)
			if(GLOB.end_narration_body == null) GLOB.end_narration_body = oldvalue
	MissionControl(window = "General")
	return
