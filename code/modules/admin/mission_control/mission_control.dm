/client/verb/fixspuis()
	set name = "Force Close Sector Patrol Interfaces"
	set category = "OOC.Fix"

	if (usr.sp_uis.len != 0)
		while(usr.sp_uis.len != 0)
			var/ui_to_close = jointext(usr.sp_uis,null,1,2)
			usr << browse(null, "window=[ui_to_close]")
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
			dat += {"<div class="box">
				<div class="text">
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];open_mission_control=General'>Load/Save, Review and Set IC Infromation</a></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sts_control_panel=1'>Ship to Ship Control Panel</A></p>
				<p>All panels and subpanels should also be reachable through the DM tab in the status window!</p>
				</div>
				</div>
				"}
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
				load_template()
				link_player_ships()
			dat += {"<div class="box">
				<div class="text">
				<p><b>SHIP TO SHIP PANEL</b></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];toggle_sts=initialized'>INITIATED</A>: [GLOB.combat_initiated] | <A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];toggle_sts=turn'>ROUND</A>: <b>[GLOB.combat_round]</b></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sts_entity_panel=1'>ENTITY CONTROL</A></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sts_round_flow_panel=1'>ROUND FLOW CONTROL</A></p>
				</div>
				</div>
				"}
		if("ShipToShip_Entities")
			var/displayed_entities = (jointext((sts_master.scan_entites(category = 0, output_format = 0)), "</p><p>")+"</p><p>"+jointext((sts_master.scan_entites(category = 1, output_format = 0)), "</p><p>"))
			dat += {"<div class="box">
				<div class="text">
				<p><b>ENTITY_CONTROL</b></p>
				<p>[displayed_entities]</p>
				<p><b><p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];entity_editor=add'>Add</A></b> | <b><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];entity_editor=modify'>Modify</A></b> | <b><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];entity_editor=remove'>Remove</A></b></p>
				<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];entity_editor=mapx'>Map max X:</A><b>[GLOB.sector_map_x]</b> | <A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];entity_editor=mapy'>Map max Y:</A> <b>[GLOB.sector_map_y]</b>
				<p><b><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];load_template=1'>Load Preset</A></b></p>
				<p><b><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];link_player_ships=1'>Link and Initialize Player Ships</A></b></p>
				</div>
				</div>
				"}
		if("ShipToShip_RoundControl")
			var/round_phase_text
			var/round_next_text
			dat += {"<div class="box">
				<div class="text">
				<p><b>SHIP TO SHIP ROUND FLOW PANEL</b></p>
				</div>
				</div>
				"}
			switch(GLOB.round_phase)
				if(1)
					round_phase_text = "DM - Movement and Firing"
					round_next_text = "Advance Phase"
				if(2)
					round_phase_text = "Players - DM Setting Comms"
					round_next_text = "Advance Phase"
				if(3)
					round_phase_text = "Players"
					round_next_text = "<b>NEXT TURN</b>"
				if(4)
					round_phase_text = "Advancing Turn..."
			if(GLOB.round_phase == 4)
				dat+= {"<div class="box">
				<div class="text">
				<p>TURN ADVANCING...</p>
				</div>
				</div>
				"}
			else
				dat += {"<div class="box">
					<div class="text">
					<p>Round: <b><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];toggle_sts=turn'>[GLOB.combat_round]</A></b></p>
					<p>Phase: <b>[round_phase_text]</b></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];next_phase=1'>[round_next_text]</A></p>
					</div>
					</div>
					<div class="box">
					<div class="text">
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];view_ship_log=round'>View Round Log</A></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];view_ship_log=full'>View Full Log</A></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];send_ship_comms=1'>Send Comms</A></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];control_npc_ship=1'>Change Ship Vectors</A></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sonar_ping=1'>Send Sonar Ping</A></p>
					<p><A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];fire_as_ship=1'>Fire as Ship</A></p>
					</div>
					</div>
					"}
		if("ShipToShip_LastRoundLog")
			var/log_to_display = jointext(sts_master.round_history_current, "</p><p>")
			dat += {"<div class="box">
				<div class="text">
				<p>Current Log Round</p>
				<p>ROUND: [GLOB.combat_round]</p>
				</div>
				</div>
				<div class="box">
				<div class="text">
				<p>[log_to_display]</p>
				</div>
				</div>
				"}
		if("ShipToShip_FullRoundLog")
			var/log_to_display = jointext(sts_master.round_history, "</p><p>")
			dat += {"<div class="box">
				<div class="text">
				<p>Full STS Log</p>
				</div>
				</div>
				<div class="box">
				<div class="text">
				<p>[log_to_display]</p>
				</div>
				</div>
				"}
		if("ShipToShip_PrevRoundLog")
			var/log_to_display = jointext(sts_master.round_history_previous, "</p><p>")
			dat += {"<div class="box">
				<div class="text">
				<p>End of Round log for Round [GLOB.combat_round]</p>
				</div>
				</div>
				<div class="box">
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
		usr.sp_uis.Add("mission_control_[usr]_[window]")
	onclose(usr, "mission_control_[usr]_[window]")

/datum/admins/proc/load_template()
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	var/new_map = tgui_alert(usr, "Do yo wish to destroy everything on the old map?", "REPLACE?", list("Yes","No"), timeout = 0)
	if(new_map == null) new_map = "No"
	switch(tgui_input_list(usr, "Select Template:","TEMPLATE select",list("Blank","Deploy the Amelia", "Deploy the Marie","Tester Targets","Escapees","Pursuers"),timeout = 0))
		if(null)
			return
		if("Blank")
			sts_master.clear_map()
		if("Deploy the Amelia")
			if(new_map == "Yes") sts_master.clear_map()
			sts_master.add_entity(entity_type = 0, x = 3, y = 2, name = "UAS Amelia", type = "OV-PST Rapid Pursuit Interceptor", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UACM", ship_damage = 5, ship_shield = 2, ship_speed = 5, salvos = 2)
			return
		if("Deploy the Marie")
			if(new_map == "Yes") sts_master.clear_map()
			sts_master.add_entity(entity_type = 0, x = 4, y = 73, name = "UAS Amelia", type = "OV-PST Rapid Pursuit Interceptor", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UACM", ship_damage = 5, ship_shield = 2, ship_speed = 5, salvos = 2)
			return
		if("Tester Targets")
			sts_master.add_entity(entity_type = 0, x = 7, y = 5, name = "Weapons Test Drone Alpha", type = "OV-PST Prototype Testing Drone", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UACM", ship_damage = 1, ship_shield = 0, ship_speed = 2, salvos = 0)
			sts_master.add_entity(entity_type = 0, x = 2, y = 72, name = "Weapons Test Drone Beta", type = "OV-PST Prototype Testing Drone", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UACM", ship_damage = 1, ship_shield = 0, ship_speed = 2, salvos = 0)
		if("Escapees")
			sts_master.add_entity(entity_type = 0, x = 52, y = 98, name = "TPS Workers Glory", type = "Chelyabinsk Class Heavy Transport", vector_x = 0, vector_y = -3, ship_status = "Operational", ship_faction = "UPP", ship_damage = 10, ship_shield = 0, ship_speed = 3, salvos = 0)
		if("Pursuers")
			sts_master.add_entity(entity_type = 0, x = 92, y = 98, name = "TPS Devils Bones", type = "Kaifeng Class Frigate", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UPP", ship_damage = 5, ship_shield = 0, ship_speed = 4, salvos = 1)
			sts_master.add_entity(entity_type = 0, x = 90, y = 97, name = "TPS Peoples Hammer", type = "Kaifeng Class Frigate", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UPP", ship_damage = 5, ship_shield = 0, ship_speed = 4, salvos = 1)
			sts_master.add_entity(entity_type = 0, x = 94, y = 99, name = "TPS Tyrants Ashes", type = "Kaifeng Class Frigate", vector_x = 0, vector_y = 0, ship_status = "Operational", ship_faction = "UPP", ship_damage = 5, ship_shield = 0, ship_speed = 4, salvos = 1)

/datum/admins/proc/link_player_ships()
	if(!check_rights(R_ADMIN)) return
	var/init_counter = 0
	for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_to_link in world)
		if(ship_to_link.sector_map_data["name"] != "none")
			ship_to_link.FindShipOnMap()
			init_counter += 1
	to_chat(usr, SPAN_INFO("Initalization complete. Ships found: [init_counter]."))
	sts_entity_panel()
	return

/datum/admins/proc/entity_editor(type)
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	switch(type)
		if(null)
			return
		if("add")
			switch(tgui_input_list(usr, "What type of entity to add?", "Add Entity", list("ship","missile"), timeout = 0))
				if("ship")
					var/coordinate_x = tgui_input_number(usr, "Pick the X coordinate, max: [GLOB.sector_map_x]", "Add Entity - X Coordinate", min_value = 1, timeout = 0)
					if(coordinate_x == null) return
					if(coordinate_x > GLOB.sector_map_x) coordinate_x = GLOB.sector_map_x
					var/coordinate_y = tgui_input_number(usr, "Pick the Y coordinate, max: [GLOB.sector_map_y]", "Add Entity - Y Coordinate", min_value = 1, timeout = 0)
					if(coordinate_y == null) return
					if(coordinate_y > GLOB.sector_map_y) coordinate_y = GLOB.sector_map_y
					if(sts_master.sector_map[coordinate_x][coordinate_y]["ship"]["id_tag"] != "none")
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
					sts_master.add_entity(entity_type = 0, x = coordinate_x, y = coordinate_y, name = name_to_enter, type = type_to_enter, vector_x = vector_x_to_enter, vector_y = vector_y_to_enter, ship_status = status_to_enter, ship_faction = faction_to_enter, ship_damage = damage_to_enter, ship_shield = shield_to_enter, ship_speed = speed_to_enter, salvos = salvos_to_enter)
				if("missile")
					var/coordinate_x = tgui_input_number(usr, "Pick the X coordinate, max: [GLOB.sector_map_x]", "Add Entity - X Coordinate", min_value = 0, timeout = 0)
					if(coordinate_x == null) return
					if(coordinate_x > GLOB.sector_map_x) coordinate_x = GLOB.sector_map_x
					var/coordinate_y = tgui_input_number(usr, "Pick the Y coordinate, max: [GLOB.sector_map_y]", "Add Entity - Y Coordinate", min_value = 0, timeout = 0)
					if(coordinate_y == null) return
					if(coordinate_y > GLOB.sector_map_y) coordinate_y = GLOB.sector_map_y
					if(sts_master.sector_map[coordinate_x][coordinate_y]["missile"]["id_tag"] != "none")
						to_chat(usr, SPAN_WARNING("A missile exists on this coordinate already."))
						return
					var/name_to_enter = tgui_input_text(usr, "Enter missile Name", "NAME Entry", timeout = 0)
					if(name_to_enter == null) name_to_enter = "Unknown"
					var/speed_to_enter = tgui_input_number(usr, "Enter missile Speed", "SPEED Entry", timeout = 0)
					if(speed_to_enter == null) speed_to_enter = 0
					var/type_to_enter = tgui_input_text(usr, "Enter missile Type", "TYPE Entry", timeout = 0)
					if(type_to_enter == null) type_to_enter = "Unknown"
					var/warhead_to_enter = tgui_input_text(usr, "Enter warhead type", "WARHEAD Entry", timeout = 0)
					if(warhead_to_enter == null) warhead_to_enter = "Unknown"
					var/vector_x_to_enter = tgui_input_number(usr, "Pick X coord of target", "Target - X", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
					if(vector_x_to_enter == null) vector_x_to_enter = 0
					var/vector_y_to_enter = tgui_input_number(usr, "Pick Y coord of target", "Target - Y", default = 0,max_value = 1000 ,min_value = -1000, timeout = 0)
					if(vector_y_to_enter == null) vector_y_to_enter = 0
					var/list/target_tag_list = list()
					target_tag_list.Add(sts_master.scan_entites(category = 0, output_format = 1))
					target_tag_list.Add("None")
					var/target_tag_to_enter = tgui_input_list(usr, "Select a target Tag", "Tag Ship", target_tag_list , timeout = 0)
					if(target_tag_to_enter == null || target_tag_to_enter == "None") target_tag_to_enter = "none"
					sts_master.add_entity(entity_type = 1, x = coordinate_x, y = coordinate_y, name = name_to_enter, type = type_to_enter, vector_x = vector_x_to_enter, vector_y = vector_y_to_enter, warhead_type = warhead_to_enter, target_tag = target_tag_to_enter, missile_speed = speed_to_enter)
			to_chat(usr, SPAN_INFO("Entity Added."))
		if("remove")
			switch(tgui_input_list(usr, "What type of entity to remove?", "Rem Entity", list("ship","missile"), timeout = 0))
				if("ship")
					var/id_to_remove = tgui_input_list(usr, "Which ship Entity to remove?", "Rem Ship", sts_master.scan_entites(category = 0, output_format = 1), timeout = 0)
					if(id_to_remove == null) return
					sts_master.rem_entity(type = "id", id = id_to_remove)
				if("missile")
					var/id_to_remove = tgui_input_list(usr, "Which ship Entity to remove?", "Rem Ship", sts_master.scan_entites(category = 1, output_format = 1), timeout = 0)
					if(id_to_remove == null) return
					sts_master.rem_entity(type = "id", id = id_to_remove)
			to_chat(usr, SPAN_INFO("Entity Removed."))
		if("modify")
			switch(tgui_input_list(usr, "What type of entity to modify?", "Mod Entity", list("ship","missile"), timeout = 0))
				if("ship")
					var/modify_id = tgui_input_list(usr, "Select a Ship Entity to Edit", "Mod Entity", sts_master.scan_entites(category = 0, output_format = 1), timeout = 0)
					var/modify_value = tgui_input_list(usr, "Select a Ship Entity Property to Edit", "Mod Entity", list("name","faction","id_tag","type","status","damage","shield","vector"), timeout = 0)
					sts_master.mod_entity(entity_type = "ship", entity_tag = modify_id, entity_property = modify_value)
				if("missile")
					var/modify_id = tgui_input_list(usr, "Select a missile Entity to Edit", "Mod Entity", sts_master.scan_entites(category = 1, output_format = 1), timeout = 0)
					var/modify_value = tgui_input_list(usr, "Select a missile Entity Property to Edit", "Mod Entity", list("name","type","target","speed","warhead"), timeout = 0)
					sts_master.mod_entity(entity_type = "missile", entity_tag = modify_id, entity_property = modify_value)
			to_chat(usr, SPAN_INFO("Value modified."))
		if("mapx")
			var/old_value = GLOB.sector_map_x
			GLOB.sector_map_x = tgui_input_number(usr, "Select map X size", "Max X", GLOB.sector_map_x, min_value = 1, timeout = 0)
			if(GLOB.sector_map_x == null || GLOB.sector_map_x < 1) GLOB.sector_map_x = old_value
			to_chat(usr, SPAN_INFO("[GLOB.sector_map_x] set."))
		if("mapy")
			var/old_value = GLOB.sector_map_y
			GLOB.sector_map_y = tgui_input_number(usr, "Select map X size", "Max X", GLOB.sector_map_y, min_value = 1, timeout = 0)
			if(GLOB.sector_map_y == null || GLOB.sector_map_y < 1) GLOB.sector_map_y = old_value
			to_chat(usr, SPAN_INFO("[GLOB.sector_map_y] set."))
	sts_entity_panel()
	return


/datum/admins/proc/display_crawl(type)
	switch(type)
		if(null)
			return
		if("combat_initiate")
			show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "SPACE COMBAT INITALIZED", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "turn_number", ignore_key = FALSE, speed = 1)
			sleep(100)
			show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "TURN [GLOB.combat_round] STARTING...", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "turn_number", ignore_key = FALSE, speed = 1)
			sleep(100)
			to_chat(world, narrate_head("Ship to ship combat initiated!"))
			to_chat(world, narrate_body("<b>Hostile ships detected in your sector.</b> Please standby as the DM sets up the initial round."))
		if("combat_end")
			show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "SPACE COMBAT CONCLUDED", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "turn_number", ignore_key = FALSE, speed = 1)

/datum/admins/proc/toggle_sts(type = null)
	if(!check_rights(R_ADMIN)) return
	switch(type)
		if(null)
			return
		if("initialized")
			if(GLOB.combat_initiated == 0)
				if(tgui_input_list(usr, "Initailize Space Combat?","INITALIZE",list("Yes","No"), timeout = 0) == "Yes")
					if(GLOB.combat_round != 1)
						if(tgui_input_list(usr, "Combat round is not 1. Reset Combat round to 1?", "ROUND NOT 1", list("Yes", "No"), timeout = 0) == "Yes")
							GLOB.combat_round = 1
					GLOB.combat_initiated = 1
					INVOKE_ASYNC(src, PROC_REF(display_crawl),"combat_initiate")
			if(GLOB.combat_initiated == 1)
				if(tgui_input_list(usr, "End Space Combat?","INITALIZE",list("Yes","No"), timeout = 0) == "Yes")
					GLOB.combat_initiated = 0
					INVOKE_ASYNC(src, PROC_REF(display_crawl),"combat_end")
		if("turn")
			var/original_number = GLOB.combat_round
			GLOB.combat_round = tgui_input_number(usr, "Set Combat Round", "ROUND", GLOB.combat_round, min_value = 1, timeout = 0)
			if(GLOB.combat_round == null || GLOB.combat_round < 1) GLOB.combat_round = original_number
	MissionControl(window = "ShipToShip")
	return


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

/datum/admins/proc/next_phase()
	if(!check_rights(R_ADMIN)) return
	if(GLOB.round_phase == 4)
		to_chat(usr, SPAN_WARNING("Error: Round is advancing."))
		return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	if(tgui_alert(usr, "Advance to next phase? (Current Phase: [GLOB.round_phase])", "PHASE confirmation", list("Yes","No"), timeout = 0) == "Yes")
		switch(GLOB.round_phase)
			if(1)
				to_chat(world, narrate_head("<b>Player Turn</b>"))
				to_chat(world, narrate_body("<b>Damage and Movement have been processed.</b> The DM is setting up comm responses and other relevant in-round events.<b>You may repair damage, use your pings and fire your weapons.</b>"))
				to_chat(world, narrate_body("Await sending <b>Comms Messages</b> until this phase is complete."))
				GLOB.round_phase = 2
			if(2)
				to_chat(world, narrate_body("All comms responses and outstanding issues have been clear. <b>The DM is ready to advance the round</b>, but for now there is no time limit on the remaining player turn."))
				to_chat(world, narrate_body("<b>It is now safe to send new comms from the Signals console.</b>"))
				GLOB.round_phase = 3
			if(3)
				to_chat(world, narrate_head("<b>Player Turn Ending</b>"))
				to_chat(world, narrate_body("The DM has chosen to advance the round. Ships will be moved and firing will be processed in 5 seconds."))
				sleep(50)
				GLOB.round_phase = 4
				sts_master.NextTurn()
				MissionControl(window = "ShipToShip_PrevRoundLog")
				GLOB.combat_round += 1
				GLOB.round_phase = 1
				show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "TURN [GLOB.combat_round] STARTING...", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "turn_number", ignore_key = FALSE, speed = 1)
				to_chat(world, narrate_head("<b>DM Turn</b>"))
				to_chat(world, narrate_body("The DM is now setting up ship movement, secondary fire and any other round-critical factors. <b>You may react to initial damage, coming from long range projectiles in an IC fashion</b>, but refrain from doing any mechanical fixes or other actions just yet."))
				to_chat(world, narrate_body("The DM may not have time to respond to queries during this time in order to resolve this state as quick as possible."))
			if(4)
				return
	MissionControl(window = "ShipToShip_RoundControl")



/datum/admins/proc/fire_as_ship()
	if(!check_rights(R_ADMIN)) return
	var/obj/structure/shiptoship_master/sts_master
	for(var/obj/structure/shiptoship_master/sts_master_to_link in world)
		sts_master = sts_master_to_link
		break
	var/list/fire_sources = list()
	var/list/fire_targets = list()
	var/fire_scan_x = 1
	var/fire_scan_y = 1
	while (fire_scan_x <= GLOB.sector_map_x)
		while(fire_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["id_tag"] != "none")
				if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["status"] == "Player")
					fire_targets.Add(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["name"])
				if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["status"] != "Player")
					if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["system"]["salvos_left"] > 0)
						fire_sources.Add(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["name"])
			fire_scan_y += 1
		fire_scan_y = 1
		fire_scan_x += 1
	if(fire_sources.len == 0)
		to_chat(usr, SPAN_WARNING("No ships with salvos left available."))
		return
	var/ship_to_fire = tgui_input_list(usr, "Select a NPC ship to fire with", "Fire SOURCE", fire_sources, timeout = 0)
	if(ship_to_fire == null) return
	var/firing_ship_x
	var/firing_ship_y
	fire_scan_x = 1
	fire_scan_y = 1
	while (fire_scan_x <= GLOB.sector_map_x)
		while(fire_scan_y <= GLOB.sector_map_y)
			if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["name"] == ship_to_fire)
				firing_ship_x = fire_scan_x
				firing_ship_y = fire_scan_y
				break
			fire_scan_y += 1
		if(firing_ship_x != null) break
		fire_scan_y = 1
		fire_scan_x += 1
	var/list/positions_to_fire = list("Primary","Secondary","Mark Ship As Fired")
	var/secondary_scan_bottom_x = sts_master.BoundaryAdjust(firing_ship_x - 5,1)
	var/secodnary_scan_bottom_y = sts_master.BoundaryAdjust(firing_ship_y - 5,1)
	var/secondary_scan_top_x = sts_master.BoundaryAdjust(firing_ship_x + 5,2)
	var/secondary_scan_top_y = sts_master.BoundaryAdjust(firing_ship_y + 5,3)
	var/secondary_scan_current_x = secondary_scan_bottom_x
	var/secondary_scan_current_y = secodnary_scan_bottom_y
	var/list/secondary_targets = list()
	while(secondary_scan_current_x <= secondary_scan_top_x)
		while(secondary_scan_current_y <= secondary_scan_top_y)
			if(abs(firing_ship_y - secondary_scan_current_y) + abs(firing_ship_x - secondary_scan_current_x) <= 5)
				if(sts_master.sector_map[secondary_scan_current_x][secondary_scan_current_y]["ship"]["id_tag"] != "none" && sts_master.sector_map[secondary_scan_current_x][secondary_scan_current_y]["ship"]["id_tag"] != sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["id_tag"])
					secondary_targets.Add(sts_master.sector_map[secondary_scan_current_x][secondary_scan_current_y]["ship"]["id_tag"])
				if(sts_master.sector_map[secondary_scan_current_x][secondary_scan_current_y]["missile"]["id_tag"] != "none")
					secondary_targets.Add(sts_master.sector_map[secondary_scan_current_x][secondary_scan_current_y]["missile"]["id_tag"])
			secondary_scan_current_y += 1
		secondary_scan_current_y = secodnary_scan_bottom_y
		secondary_scan_current_x += 1
	switch(tgui_input_list(usr, "Select a Weapon to fire", "WEAPON choice", positions_to_fire, timeout = 0))
		if(null)
			return
		if("Primary")
			if(sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_left"] != sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_max"])
				to_chat(usr,SPAN_WARNING("Cannot fire Primary - Ship already fired."))
				return
			if(sts_master.sector_map[firing_ship_x][firing_ship_y]["missile"]["id_tag"] != "none")
				to_chat(usr,SPAN_WARNING("Cannot fire Primary - Missle present at location."))
				return
			fire_targets.Add("Coordinates")
			var/target_to_fire = tgui_input_list(usr, "Select Target", "TARGET choice", fire_targets, timeout = 0)
			if(target_to_fire == null) return
			var/fire_target_x
			var/fire_target_y
			var/fire_target_tag
			if(target_to_fire != "Coordinates")
				fire_scan_x = 1
				fire_scan_y = 1
				while (fire_scan_x <= GLOB.sector_map_x)
					while(fire_scan_y <= GLOB.sector_map_y)
						if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["name"] == target_to_fire)
							fire_target_x = fire_scan_x
							fire_target_y = fire_scan_y
							fire_target_tag = sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["id_tag"]
							break
						fire_scan_y += 1
					if(fire_target_x != null) break
					fire_scan_y = 1
					fire_scan_x += 1
			if(target_to_fire == "Coordinates")
				fire_target_x = tgui_input_number(usr, "Enter X Coordinate to target", "Custom X Coord", 1, GLOB.sector_map_x, 1, timeout = 0)
				fire_target_y = tgui_input_number(usr, "Enter Y Coordinate to target", "Custom X Coord", 1, GLOB.sector_map_y, 1, timeout = 0)
			if(fire_target_x == null || fire_target_y == null) return
			var/firing_missile_name = tgui_input_text(usr, "Enter Name of Missile", "Missile NAME", "Missile",timeout = 0)
			var/firing_missile_payload = tgui_input_number(usr, "Enter payload of missile", "Missile PAYLOAD", 1, min_value = 1, timeout = 0)
			var/firing_missile_speed = tgui_input_number(usr, "Enter speed of missile", "Missile SPEED", 1, min_value = 1, timeout = 0)
			if(firing_missile_name == null) firing_missile_name = "Missile"
			if(firing_missile_payload == null) firing_missile_payload = 1
			if(firing_missile_speed == null) firing_missile_speed = 5
			switch(tgui_input_list(usr, "Select Missle to fire","Missile TYPE", list("Direct-Direct","Direct-Homing","Direct-Seeking","Direct-Explosive","Direct-Nuclear"),timeout = 0))
				if(null)
					return
				if("Direct-Direct")
					sts_master.add_entity (entity_type = 1, x = firing_ship_x, y = firing_ship_y, name = firing_missile_name, type = "Standard", vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = "Direct", warhead_payload = firing_missile_payload, target_tag = "none", missile_speed = firing_missile_speed)
				if("Direct-Homing")
					sts_master.add_entity (entity_type = 1, x = firing_ship_x, y = firing_ship_y, name = firing_missile_name, type = "Standard Homing", vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = "Homing", warhead_payload = firing_missile_payload, target_tag = "none", missile_speed = firing_missile_speed)
				if("Direct-Seeking")
					sts_master.add_entity (entity_type = 1, x = firing_ship_x, y = firing_ship_y, name = firing_missile_name, type = "Homing Seeking", vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = "Homing", warhead_payload = firing_missile_payload, target_tag = fire_target_tag, missile_speed = firing_missile_speed)
				if("Direct-Explosive")
					sts_master.add_entity (entity_type = 1, x = firing_ship_x, y = firing_ship_y, name = firing_missile_name, type = "Standard Explosive", vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = "Explosive", warhead_payload = firing_missile_payload, target_tag = "none", missile_speed = firing_missile_speed)
				if("Direct-Nuclear")
					if(tgui_alert(usr, "Are you SURE you want to send a nuke at [target_to_fire]? Values will be overwritten with lowest, edit them directly.","NUKE Confirm", list("Yes","No"), timeout = 0) == "Yes")
						sts_master.add_entity (entity_type = 1, x = firing_ship_x, y = firing_ship_y, name = firing_missile_name, type = "Nuclear", vector_x = fire_target_x, vector_y = fire_target_y, warhead_type = "Nuclear", warhead_payload = 1, target_tag = "none", missile_speed = 1)
			sts_master.log_round_history(event = "missile_launch", log_source = ship_to_fire, log_dest_x = firing_ship_x, log_dest_y = firing_ship_y)
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
				if(ship_sts_to_log.sector_map_data["name"] == ship_to_fire)
					ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_own_launch")
				if(ship_sts_to_log.sector_map_data["name"] != ship_to_fire)
					ship_sts_to_log.WriteToShipLog(shiplog_event = "missile_launch")
			sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_left"] -= 1
			to_chat(usr, SPAN_INFO("Primary Weapon fired."))
		if("Secondary")
			if(sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_left"] == sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_max"])
				if(tgui_alert(usr, "Confirm Secondary Fire without firing Primary?", "Secondary Fire CONFIRM", list("Yes","No"), timeout = 0) == "No") return
			secondary_targets.Add("Vector")
			var/id_to_secondary_target = tgui_input_list(usr, "Select a target for Secondary fire", "Secondary TARGET", secondary_targets,timeout = 0)
			if(id_to_secondary_target == null) return
			var/secondary_target_x
			var/secondary_target_y
			if(id_to_secondary_target != "Vector")
				fire_scan_x = 1
				fire_scan_y = 1
				while(fire_scan_x <= GLOB.sector_map_x)
					while(fire_scan_y <= GLOB.sector_map_y)
						if(sts_master.sector_map[fire_scan_x][fire_scan_y]["ship"]["id_tag"] == id_to_secondary_target)
							secondary_target_x = fire_scan_x
							secondary_target_y = fire_scan_y
							break
						if(sts_master.sector_map[fire_scan_x][fire_scan_y]["missile"]["id_tag"] == id_to_secondary_target)
							secondary_target_x = fire_scan_x
							secondary_target_y = fire_scan_y
							break
						fire_scan_y += 1
					if(secondary_target_x != null) break
					fire_scan_y = 1
					fire_scan_x += 1
			if(id_to_secondary_target == "Vector")
				var/secondary_target_vector_x = tgui_input_number(usr, "Enter vector X of secondary fire", "Secondary VECTOR_X", 0, 5, -5, timeout = 0)
				if(secondary_target_vector_x == null) return
				var/secondary_target_vector_y = tgui_input_number(usr, "Enter vector Y of secondary fire", "Secondary VECTOR_Y", 0, 5, -5, timeout = 0)
				if(secondary_target_vector_y == null) return
				secondary_target_x = firing_ship_x + secondary_target_vector_x
				secondary_target_y = firing_ship_y + secondary_target_vector_y
			if(secondary_target_x == null || secondary_target_y == null) return
			var/secondary_payload = tgui_input_number(usr, "Select Secondary Damage", "Secondary PAYLOAD", 1, min_value = 1, timeout = 0)
			if(secondary_payload == null) return
			switch(tgui_input_list(usr, "Select Secondary Projectille", "Secondary WARHEAD", list("Direct","Explosive"), timeout = 0))
				if(null)
					return
				if("Direct")
					sts_master.log_round_history(event = "secondary_fire", log_source = ship_to_fire, log_dest_x = secondary_target_x, log_dest_y = secondary_target_y)
					for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
						ship_sts_to_log.WriteToShipLog(shiplog_event = "secondary_fire", shiplog_dest_x = firing_ship_x, shiplog_dest_y = firing_ship_y)
					sts_master.ProcessDamage(secondary_payload, secondary_target_x, secondary_target_y)
				if("Explosive")
					sts_master.log_round_history(event = "secondary_fire", log_source = ship_to_fire, log_dest_x = firing_ship_x, log_dest_y = firing_ship_y)
					for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_sts_to_log in world)
						ship_sts_to_log.WriteToShipLog(shiplog_event = "secondary_fire", shiplog_dest_x = firing_ship_x, shiplog_dest_y = firing_ship_y)
					sts_master.ProcessSplashDamage(ammount = secondary_payload, x = secondary_target_x, y = secondary_target_y)
			sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_left"] -= 1
			to_chat(usr, SPAN_INFO("Secondary weapon fired."))
		if("Mark Ship As Fired")
			sts_master.sector_map[firing_ship_x][firing_ship_y]["ship"]["system"]["salvos_left"] = 0
			sts_master.log_round_history(event = "passes_turn", log_source = ship_to_fire, log_dest_x = firing_ship_x, log_dest_y = firing_ship_y)
			to_chat(usr, SPAN_INFO("Ship marked as complete."))
	MissionControl(window = "ShipToShip_RoundControl")
	view_ship_log("round")
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
					sonar_player_ships.Add(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["name"])
				if(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["status"] != "Player")
					sonar_npc_ships.Add(sts_master.sector_map[sonar_scan_x][sonar_scan_y]["ship"]["name"])
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
					control_npc_ships.Add(sts_master.sector_map[control_scan_x][control_scan_y]["ship"]["name"])
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
					comms_player_ships.Add(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"])
				if(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["status"] != "Player")
					comms_npc_ships.Add(sts_master.sector_map[comms_scan_x][comms_scan_y]["ship"]["name"])
			comms_scan_y += 1
		comms_scan_y = 1
		comms_scan_x += 1
	var/list/final_source_list = list()
	final_source_list.Add(comms_npc_ships)
	final_source_list.Add("Vector")
	var/comms_source = tgui_input_list(usr, "Select Message Sender","Sender Select",final_source_list,timeout = 0)
	var/comms_source_x
	var/comms_source_y
	var/comms_source_custom
	var/comms_dest_x
	var/comms_dest_y
	if(comms_source == null) return
	if(comms_source == "Custom")
		comms_source_custom = tgui_input_text(usr, "Enter Name of comms source, will be displayed on all player comms consoles", "Custom Comms Source", timeout = 0)
		if(comms_source_custom == null) comms_source_custom = "Unknown"
	var/list/final_destination_list = list()
	final_destination_list.Add(comms_player_ships)
	final_destination_list.Add(comms_npc_ships)
	final_destination_list.Add("System-Wide")
	var/comms_dest = tgui_input_list(usr, "Select Message Destination", "Destination Select", final_destination_list, timeout = 0)
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
					ship_mc_to_comm.CommsLog(message_type = 0, message_source = "[comms_source], Sector ([ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y)])", message_to_add = comms_text)
					ship_mc_to_comm.talkas("Incomming communicatins from in-sector!", 1)
					ship_mc_to_comm.linked_signals_console.talkas("Incomming communicatins from in-sector!",1)
				if(ship_mc_to_comm.sector_map_data["name"] != comms_dest)
					ship_mc_to_comm.CommsLog(message_type = 1, message_source = ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y), message_to_add = comms_text)
			sts_master.log_round_history(event = "comms_ping", log_source = comms_source, log_target = comms_text, log_dest_x = comms_dest_x, log_dest_y = comms_dest_y)
			return
		if(comms_source == "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				if(ship_mc_to_comm.sector_map_data["name"] == comms_dest)
					ship_mc_to_comm.CommsLog(message_type = 0, message_source = comms_source_custom, message_to_add = comms_text)
					ship_mc_to_comm.talkas("Incomming communicatins from [comms_source_custom]!", 1)
					ship_mc_to_comm.linked_signals_console.talkas("Incomming communicatins from [comms_source_custom]!",1)
				if(ship_mc_to_comm.sector_map_data["name"] != comms_dest)
					ship_mc_to_comm.CommsLog(message_type = 3)
			sts_master.log_round_history(event = "comms_ping", log_source = comms_source_custom, log_target = comms_text, log_dest_x = comms_dest_x, log_dest_y = comms_dest_y)
			return
	if(comms_dest == "System-Wide")
		if(comms_source != "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				ship_mc_to_comm.CommsLog(message_type = 2, message_source = "[comms_source], Sector ([ship_mc_to_comm.SectorConversion(x = comms_source_x, y = comms_source_y)])", message_to_add = comms_text)
				ship_mc_to_comm.talkas("Incomming system wide communications!", 1)
				ship_mc_to_comm.linked_signals_console.talkas("Incomming system wide communications!",1)
			sts_master.log_round_history(event = "comms_ping_system", log_source = comms_source, log_target = comms_text)
			return
		if(comms_source == "Custom")
			for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm)
				ship_mc_to_comm.CommsLog(message_type = 2, message_source = comms_source_custom, message_to_add = comms_text)
				ship_mc_to_comm.talkas("Incomming system wide communications!", 1)
				ship_mc_to_comm.linked_signals_console.talkas("Incomming system wide communications!",1)
			sts_master.log_round_history(event = "comms_ping_system", log_source = comms_source_custom, log_target = comms_text)
			return

/datum/admins/proc/set_narration_preset()
	set name = "Speak as NPC over comms - setup NPC"
	set category = "DM.Narration"
	if(!check_rights(R_ADMIN)) return

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
	set name = "Speak as NPC over comms"
	set category = "DM.Narration"
	if(!check_rights(R_ADMIN)) return

	if(usr.narration_settings["Name"] == null || usr.narration_settings["Location"] == null || usr.narration_settings["Position"] == null) set_narration_preset()
	var/list/comms_destination = list("Everyone")
	for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_comm_list in world)
		if(ship_mc_to_comm_list.sector_map_data["initialized"] == 1)
			comms_destination.Add(ship_mc_to_comm_list.sector_map_data["name"])
	var/comms_destination_choice
	if(comms_destination.len <= 1)
		comms_destination_choice = "Everyone"
	else
		comms_destination_choice = tgui_input_list(usr,"Select Destination for Comms","DESTINATION pick",comms_destination,timeout = 0)
	if(comms_destination_choice == null) return
	var/text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")
	if(comms_destination_choice == "Everyone")
		while(text_to_comm != null)
			to_chat(world, "<span class='big'><span class='radio'><span class='name'>[usr.narration_settings["Name"]]<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[usr.narration_settings["Location"]] \u0028[usr.narration_settings["Position"]]\u0029\u005D </b></span><span class='message'>, says \"[text_to_comm]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
			text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")
		return
	else
		var/obj/structure/shiptoship_master/ship_missioncontrol/comm_target_ship_mc
		for(var/obj/structure/shiptoship_master/ship_missioncontrol/ship_mc_to_send_comms in world)
			if(ship_mc_to_send_comms.sector_map_data["name"] == comms_destination_choice)
				comm_target_ship_mc = ship_mc_to_send_comms
				break
		var/list/mobs_to_send_comms = comm_target_ship_mc.GetMobsInShipAreas()
		if(mobs_to_send_comms.Find(usr) == 0)
			mobs_to_send_comms.Add(usr)
		while(text_to_comm != null)
			to_chat(mobs_to_send_comms, "<span class='big'><span class='radio'><span class='name'>[usr.narration_settings["Name"]]<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[usr.narration_settings["Location"]] \u0028[usr.narration_settings["Position"]]\u0029\u005D </b></span><span class='message'>, says \"[text_to_comm]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
			text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] to [comms_destination_choice] or cancel to exit.")
		return

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

/datum/admins/proc/ChangeSpaceLocation()
	set name = "Change ingame location and backdrop"
	set category = "DM.Narration"

	if(!check_rights(R_ADMIN)) return

	var/new_location = tgui_input_list(usr, "Current backdrop: [GLOB.backdrop_type]","LOCATION",list("space","space_cat"))
	switch(new_location)
		if("space")
			GLOB.ingame_current_system = "Tau-Gamma 331, Neroid Sector"
			show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "NOW ARRIVING:\n<b>[GLOB.ingame_current_system]</b>", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "now_arriving", ignore_key = TRUE, speed = 1)
			GLOB.backdrop_type = "space"
			for(var/mob/mob in GLOB.mob_list)
				mob.update_backdrop()
		if("space_cat")
			GLOB.ingame_current_system = "Mew-Orionis 420, Nyaoid Sewctow"
			show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "NOW ARRIVING:\n<b>[GLOB.ingame_current_system]</b>", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "now_arriving", ignore_key = TRUE, speed = 1)
			GLOB.backdrop_type = "space_cat"
			for(var/mob/mob in GLOB.mob_list)
				mob.update_backdrop()
		else
			return

/datum/admins/proc/SaveLog()
	set name = "Save STS Logs"
	set category = "DM.Control"

	if(!check_rights(R_ADMIN)) return

	for(var/obj/structure/shiptoship_master/sts_master in world)
		sts_master.SaveLog()
		break
	to_chat(usr, SPAN_INFO("Logs saved."))

/datum/admins/proc/mission_control_panel()
	set name = "Mission Control Panel"
	set category = "DM.Control"

	if(!check_rights(R_ADMIN)) return
	usr.client.admin_holder.MissionControl(window = "Main")
	return

/datum/admins/proc/sts_control_panel()
	set name = "STS Setup Panel"
	set category = "DM.STS"

	if(!check_rights(R_ADMIN)) return
	usr.client.admin_holder.MissionControl(window = "ShipToShip")
	return

/datum/admins/proc/sts_round_flow_panel()
	set name = "STS Round Flow Panel"
	set category = "DM.STS"

	if(!check_rights(R_ADMIN)) return
	usr.client.admin_holder.MissionControl(window = "ShipToShip_RoundControl")
	return

/datum/admins/proc/sts_entity_panel()
	set name = "STS Entity Control Panel"
	set category = "DM.STS"

	if(!check_rights(R_ADMIN)) return
	usr.client.admin_holder.MissionControl(window = "ShipToShip_Entities")
	return
