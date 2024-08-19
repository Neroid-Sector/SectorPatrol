/obj/structure/ship_elements/control_pad
	name = "ship control pad"
	desc = "A small device consisting mostly of a hard plastic case wrapped around nine objects that resemble capacitors."
	desc_lore = "Infamously one of the few hand-me-downs form the cult of Godseekers, the previous occupants of the OV-PST, the command pad taps into the PST's atypical AI and can derive specific intent - in this case, naturally adjusting the flight path of a ship according to the will of the user. Frustratingly, any document that goes into any detail of how this is achieved is highly restricted, and the only files available to PST personnel are reports of testing, not production."
	icon = 'icons/sectorpatrol/ship/ship_controller.dmi'
	icon_state = "cpad_off"
	plane = GAME_PLANE
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/ship_name
	var/list/ship_data= list("moves" = 0,"vector_x" = 0, "vector_y" = 0,"new_x" = 0, "new_y" = 0,"moves_made" = 0,)
	var/ship_speed = 5
	var/repair_shutdown = 0
	var/ship_steering = 0

/obj/structure/ship_elements/control_pad/proc/SetUsageData(state = 0)
	switch(state)
		if(null)
			return
		if(0)
			ship_data["moves"] = ship_speed
			UpdateMapData()
			return
		if(1)
			ship_data["moves"] = 0
			UpdateMapData()
			return

/obj/structure/ship_elements/control_pad/proc/AnimateUse(state)
	switch(state)
		if(null)
			return
		if(1)
			icon_state = "cpad_off_on"
			update_icon()
			sleep(5)
			icon_state = "cpad_on"

/obj/structure/ship_elements/control_pad/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			repair_shutdown = 1
			icon_state = "cpad_off"
			update_icon()
			world << browse(null, "window=[linked_master_console.sector_map_data["name"]]_CPAD")
			return
		if(0)
			repair_shutdown = 0
			SetUsageData(1)
			AnimateUse(1)
			return

/obj/structure/ship_elements/control_pad/proc/UpdateMapData()
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["vector"]["speed"] = ship_speed
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["vector"]["x"] = ship_data["vector_x"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["vector"]["y"] = ship_data["vector_y"]

/obj/structure/ship_elements/control_pad/proc/LinkToShipMaster(master_console as obj)
	linked_master_console = master_console
	SetUsageData(0)

/obj/structure/ship_elements/control_pad/proc/ship_vector()
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
		<div id="main_window"
		"}
	//content
	dat += {"
		<div class="box">
		<div class="text">
		<p>Current Vector: <b>([ship_data["vector_x"]],[ship_data["vector_y"]])</b></p>
		<p>Vector Changes: <b>([ship_data["new_x"]],[ship_data["new_y"]])</b></p>
		<p><b>[ship_data["moves_made"]]</b>/<b>[ship_speed]</p>
		</div>
		</div>
		"}
	dat += {"
		</div>
		</body>
		"}
	usr << browse(dat,"window=[linked_master_console.sector_map_data["name"]]_CPAD;display=1;size=400x200;border=5px;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "window=[linked_master_console.sector_map_data["name"]]_CPAD")

/obj/structure/ship_elements/control_pad/proc/DisplayControl(status = 0)
	ship_vector()
	if(status == 1)
		if(tgui_alert(usr, "Commit Vector ([ship_data["new_x"]],[ship_data["new_y"]])?", "VECTOR", list("YES", "NO"), timeout = 0) == "YES")
			ship_data["vector_x"] += ship_data["new_x"]
			ship_data["vector_y"] += ship_data["new_y"]
			ship_data["moves"] = ship_data["moves_made"]
			UpdateMapData()
			ship_data["new_x"] = 0
			ship_data["new_y"] = 0
			ship_data["moves_made"] = 0
			to_chat(usr, SPAN_INFO("Vector changed."))
			return
	switch(tgui_alert(usr, "[ship_name]","VECTOR",list("-Y","CONFIRM","+Y","-X","EXIT","+X"), timeout = 0))
		if(null,"EXIT")
			ship_data["new_x"] = 0
			ship_data["new_y"] = 0
			ship_data["moves_made"] = 0
			to_chat(usr, SPAN_WARNING("Vector change aborted."))
			return
		if("-Y")
			if((ship_data["vector_y"] + ship_data["new_y"] - 1) < -ship_speed || (ship_data["new_y"] - 1) < -ship_speed)
				to_chat(usr, SPAN_WARNING("Error: Proposed value would be over safe velocity. Aborting"))
			else
				if((ship_data["new_y"] - 1) < 0)
					if((ship_data["moves_made"] + 1) <= ship_speed)
						ship_data["moves_made"] += 1
						ship_data["new_y"] -= 1
					else
						to_chat(usr, SPAN_WARNING("Error: Out of moves."))
				else
					if(ship_data["moves_made"] - 1 >= 0)
						ship_data["new_y"] -= 1
						ship_data["moves_made"] -= 1
					else
						to_chat(usr, SPAN_WARNING("Error: Moves already at 0, cant subtract more."))
			DisplayControl()
			return
		if("+Y")
			if((ship_data["vector_y"] + ship_data["new_y"] + 1) > ship_speed|| (ship_data["new_y"] + 1) > ship_speed)
				to_chat(usr, SPAN_WARNING("Error: Proposed value would be over safe velocity. Aborting"))
			else
				if((ship_data["new_y"] + 1)> 0)
					if((ship_data["moves_made"] + 1) <= ship_speed)
						ship_data["moves_made"] += 1
						ship_data["new_y"] += 1
					else
						to_chat(usr, SPAN_WARNING("Error: Out of moves."))
				else
					if(ship_data["moves_made"] - 1 >= 0)
						ship_data["new_y"] += 1
						ship_data["moves_made"] -= 1
					else
						to_chat(usr, SPAN_WARNING("Error: Moves already at 0, cant subtract more."))
			DisplayControl()
			return
		if("-X")
			if((ship_data["vector_x"] + ship_data["new_x"] - 1) < -ship_speed || (ship_data["new_x"] - 1) < -ship_speed)
				to_chat(usr, SPAN_WARNING("Error: Proposed value would be over safe velocity. Aborting"))
			else
				if((ship_data["new_x"] - 1) < 0)
					if((ship_data["moves_made"] + 1) <= ship_speed)
						ship_data["new_x"] -= 1
						ship_data["moves_made"] += 1
					else
						to_chat(usr, SPAN_WARNING("Error: Out of moves."))
				else
					if(ship_data["moves_made"] - 1 >= 0)
						ship_data["new_x"] -= 1
						ship_data["moves_made"] -= 1
					else
						to_chat(usr, SPAN_WARNING("Error: Moves already at 0, cant subtract more."))
			DisplayControl()
			return
		if("+X")
			if((ship_data["vector_x"] + ship_data["new_x"] + 1) > ship_speed || (ship_data["new_x"] + 1) > ship_speed)
				to_chat(usr, SPAN_WARNING("Error: Proposed value would be over safe velocity. Aborting"))
			else
				if((ship_data["new_x"] + 1)> 0)
					if((ship_data["moves_made"] + 1) <= ship_speed)
						ship_data["new_x"] += 1
						ship_data["moves_made"] += 1
					else
						to_chat(usr, SPAN_WARNING("Error: Out of moves."))
				else
					if(ship_data["moves_made"] - 1 >= 0)
						ship_data["new_x"] += 1
						ship_data["moves_made"] -= 1
					else
						to_chat(usr, SPAN_WARNING("Error: Moves already at 0, cant subtract more."))
			DisplayControl()
			return
		if("CONFIRM")
			DisplayControl(1)
			return

/obj/structure/ship_elements/control_pad/attack_hand(mob/user)
	if(repair_shutdown == 1)
		to_chat(usr, SPAN_WARNING("The panel does not respond."))
		return
	if(ship_data["moves"] == 0)
		to_chat(usr, SPAN_WARNING("Movement for [linked_master_console.sector_map_data["name"]] has been already set!"))
		return
	if(ship_steering == 1)
		to_chat(usr, SPAN_WARNING("Someone is already using this panel."))
		return
	ship_steering = 1
	ship_data["new_x"] = 0
	ship_data["new_y"] = 0
	ship_data["moves_made"] = 0
	UpdateMapData()
	DisplayControl()
	ship_steering = 0
	return



