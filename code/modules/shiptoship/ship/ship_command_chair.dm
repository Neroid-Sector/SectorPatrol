/obj/structure/ship_elements/command_chair
	name = "command chair"
	desc = "A comfortable, sturdy looking chair."
	desc_lore = "Made from scratch on the PST, this chair is meant to match the natural shapes of its user for maximum comfort and generally is made with the idea that whoever uses it, uses it for hours at a time. Additionally, LD enabled sensors in both the chairs backrest and frame make sure that the person using it and the terminals that are linked to it are authorized to be there. How does the device exactly accomplish this is not clear, but it will not work with Marine IDs that do not contain the PST issues RFID chips."
	icon = 'icons/sectorpatrol/ship/throne.dmi'
	icon_state = "command_chair"
	can_buckle = TRUE
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/obj/structure/ship_elements/command_monitor/top/linked_top_screen
	var/obj/structure/ship_elements/command_monitor/front/linked_front_screen
	var/obj/structure/ship_elements/command_monitor/bottom/linked_bot_screen
	var/ship_name = "none"
	var/repair_shutdown = 0

/obj/structure/ship_elements/command_chair/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			repair_shutdown = 1
			linked_top_screen.repair_shutdown = 1
			linked_front_screen.repair_shutdown = 1
			linked_bot_screen.repair_shutdown = 1
			talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
			return
		if(0)
			repair_shutdown = 0
			linked_top_screen.repair_shutdown = 0
			linked_top_screen.use_fx(type = "off")
			linked_front_screen.repair_shutdown = 0
			linked_front_screen.use_fx(type = "off")
			linked_bot_screen.repair_shutdown = 0
			linked_bot_screen.use_fx(type = "off")
			talkas("Critical damage resolved. Lifting lockout.")
			return

/obj/structure/ship_elements/command_chair/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	if(!linked_top_screen)
		for(var/obj/structure/ship_elements/command_monitor/top/top_to_link in world)
			if(top_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_top_screen = top_to_link
				to_chat(world, SPAN_INFO("Top Moniotor for ship [linked_master_console.sector_map_data["id"]] loaded."))
	if(!linked_front_screen)
		for(var/obj/structure/ship_elements/command_monitor/front/front_to_link in world)
			if(front_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_front_screen = front_to_link
				to_chat(world, SPAN_INFO("Front Monitor for ship [linked_master_console.sector_map_data["id"]] loaded."))
	if(!linked_bot_screen)
		for(var/obj/structure/ship_elements/command_monitor/bottom/bot_to_link in world)
			if(bot_to_link.ship_name == linked_master_console.sector_map_data["name"])
				linked_bot_screen = bot_to_link
				to_chat(world, SPAN_INFO("Bottom Monitor for ship [linked_master_console.sector_map_data["id"]] loaded."))

/obj/structure/ship_elements/command_monitor
	name = "command monitor"
	icon = 'icons/sectorpatrol/ship/throne.dmi'
	icon_state = "default"
	desc = "A high-quality looking monitor, nested in a sturdy looking frame that seems to be permanently attached to its base."
	desc_lore = "Monitors that are part of the central PST Mission Control system utilize LD enabled polymers to display more than just green text which already puts them above and beyond most display devices found on board space vessels. To top that off, working in tandem with their chair and their uplink to the PST's central system, these chairs seem to inherently know what data their user wants displayed almost as they think about it."
	var/ship_name = "none"
	var/obj/structure/ship_elements/command_chair/linked_command_chair
	var/repair_shutdown = 0
	var/icon_base


/obj/structure/ship_elements/command_monitor/proc/ChairLink(chair_to_link as obj)
	linked_command_chair = chair_to_link

/obj/structure/ship_elements/command_monitor/proc/use_fx(type)
	switch(type)
		if(null)
			return
		if("on")
			sleep(rand(1,15))
			icon_state = icon_base + "_on"
			update_icon()
		if("off")
			icon_state = icon_base + "_off"
			update_icon()

/obj/structure/ship_elements/command_monitor/proc/open_command_window(type)
	var/dat
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
		<div class="text">
		<p style="font-size: 120%;">
		<b>SECTOR PATROL DM PANEL</b>
		</p>
		</div>
		</div>
		"}
	//content
	dat += {"
		<div class="box">
		<div class="text">
		"}
	switch(type)
		if(null)
			return
		if("current_round")
			var/current_round
			if(linked_command_chair.linked_master_console.local_round_log.len == 0) current_round = "No recent Sonar activity."
			if(linked_command_chair.linked_master_console.local_round_log.len != 0) current_round = jointext(linked_command_chair.linked_master_console.local_round_log, "</p><p>")
			dat +={"<p><b>Sonar Activity:</b></p>
				<p>[current_round]</p>
				"}
		if("round_history")
			var/round_history
			if(linked_command_chair.linked_master_console.local_round_log_full.len == 0) round_history = "No Sonar history in buffer."
			if(linked_command_chair.linked_master_console.local_round_log_full.len != 0) round_history = jointext(linked_command_chair.linked_master_console.local_round_log_full, "</p><p>")
			dat +={"<p><b>Sonar Activity History Buffer:</b></p>
				<p>[round_history]</p>
				"}
		if("pings_and_tracking")
			var/activity_summary
			var/pings_and_tracking
			if(linked_command_chair.linked_master_console.ping_history.len == 0) pings_and_tracking += "No ping history."
			if(linked_command_chair.linked_master_console.ping_history.len != 0) pings_and_tracking += jointext(linked_command_chair.linked_master_console.ping_history, "</p><p>")
			pings_and_tracking += jointext(linked_command_chair.linked_master_console.GetTrackingList(), "</p><p>")
			if(linked_command_chair.linked_master_console.local_round_log_moves.len == 0) activity_summary = "No recent activity."
			if(linked_command_chair.linked_master_console.local_round_log_moves.len != 0) activity_summary = jointext(linked_command_chair.linked_master_console.local_round_log_moves, " | ")
			dat +={"<p><b>Pings and Tracking:</b></p>
				<p>Activity update:</p>
				<p><b>[activity_summary]</b></p>
				<p>Pings and Trackers readout:</p>
				<p>[pings_and_tracking]</p>
				"}
		if("ship_messages")
			var/ship_messages
			if(linked_command_chair.linked_master_console.comms_messages.len == 0) ship_messages = "No messages to display."
			if(linked_command_chair.linked_master_console.comms_messages.len != 0) ship_messages = jointext(linked_command_chair.linked_master_console.comms_messages, "</p><p>")
			dat +={"<p><b>Recieved Messages:</b></p>
				<p>[ship_messages]</p>
				"}
		if("weapon_status")
			var/weapon_status = jointext(linked_command_chair.linked_master_console.GetWeaponsReadout(), "</p><p>")
			dat +={"<p><b>Launcher Status:</b></p>
				<p>[weapon_status]</p>
				"}
		if("ship_status")
			var/ship_status = jointext(linked_command_chair.linked_master_console.GetStatusReadout(), "</p><p>")
			dat +={"<p><b>Launcher Status:</b></p>
				<p>[ship_status]</p>
				"}
	dat += {"</div>
		</div>
		"}
	//footer etc
	dat += {"
		</div>
		</body>
		"}
	usr << browse(dat,"window=commander_console_[usr]_[type];display=1;size=800x800;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	if(usr.sp_uis.Find("commander_console_[usr]_[type]") == 0)
		usr.sp_uis += "commander_console_[usr]_[type]"
	onclose(usr, "commander_console_[usr]_[type]")

/obj/structure/ship_elements/command_monitor/top
	name = "right command monitor"
	icon_state = "top_off"
	icon_base = "top"

/obj/structure/ship_elements/command_monitor/front
	name = "front command monitor"
	icon_state = "front_off"
	icon_base = "front"

/obj/structure/ship_elements/command_monitor/bottom
	name = "left command monitor"
	icon_state = "bot_off"
	icon_base = "bot"
