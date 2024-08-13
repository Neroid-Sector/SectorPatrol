/client/proc/mission_control_panel()
	set name = "Mission Control Panel"
	set category = "DM.Control"
	if(admin_holder)
		admin_holder.MissionControl(window = "Main")
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
	if(!check_rights(0)) return
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
				<p>ROUND ADVANCING...</p>
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
					<p>View Round Log</p>
					<p>View Full Log</p>
					<p>Send Comms</p>
					<p>Change Ship Vectors</p>
					<p>Send Sonar Ping</p>
					<p>Fire as Ship</p>
					</div>
					</div>
					"}

	//footer etc
	dat += {"
		</div>
		</body>
		"}

	usr << browse(dat,"window=mission_control_[usr];display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "mission_control_[usr]")

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
