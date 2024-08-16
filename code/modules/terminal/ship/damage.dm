/obj/structure/terminal/damage_console/
	name = "damage control console"
	item_serial = "-DAM-CNS"
	desc = "A terminal labeled 'Damage Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 2
	terminal_id = "_weapons_control"
	var/ship_name
	var/repair_shutdown = 0
	var/obj/structure/shiptoship_master/ship_missioncontrol/linked_master_console
	var/list/damage_controls = list()
	var/list/usage_data = list(
		"repairs_max" = 2,
		"repairs_done" = 0,
		"damage" = list(
			"HP" = 5,
			"engine" = 0,
			"systems" = 0,
			"weapons" = 0,
			"hull" = 0,
			),
		)

/obj/structure/terminal/damage_console/proc/UpdateMapData()
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["HP"] = usage_data["damage"]["HP"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["engine"] = usage_data["damage"]["engine"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["systems"] = usage_data["damage"]["systems"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["weapons"] = usage_data["damage"]["weapons"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["damage"]["hull"] = usage_data["damage"]["hull"]
	linked_master_console.sector_map[linked_master_console.sector_map_data["x"]][linked_master_console.sector_map_data["y"]]["ship"]["system"]["repairs_left"] = usage_data["repairs_max"] - usage_data["repairs_done"]

/obj/structure/terminal/damage_console/proc/SetUsageData(state = 0, damage = null)
	switch(state)
		if(null)
			return
		if(0)
			usage_data["repairs_done"] = 0
		if(1)
			usage_data["repairs_done"] = usage_data["repairs_max"]
	if(damage == null)
		return
	if(damage == 0)
		usage_data["damage"]["engine"] = 0
		usage_data["damage"]["systems"] = 0
		usage_data["damage"]["weapons"] = 0
		usage_data["damage"]["hull"] = 0
		UpdateMapData()
		return
	if(damage == 1)
		usage_data["damage"]["engine"] = usage_data["damage"]["HP"]
		usage_data["damage"]["systems"] = usage_data["damage"]["HP"]
		usage_data["damage"]["weapons"] = usage_data["damage"]["HP"]
		usage_data["damage"]["hull"] = usage_data["damage"]["HP"]
		UpdateMapData()
		return

/obj/structure/terminal/damage_console/proc/ProcessShutdown(status = null)
	switch(status)
		if(null)
			return
		if(1)
			for(var/obj/structure/ship_elements/damage_control_element/coil_to_damage in damage_controls)
				INVOKE_ASYNC(coil_to_damage, TYPE_PROC_REF(/obj/structure/ship_elements/damage_control_element, GetDamaged), "critical")
			repair_shutdown = 1
			SetUsageData(state = 1, damage = 1)
			world << browse(null,"window=[terminal_id]")
			return
		if(0)
			repair_shutdown = 0
			SetUsageData(state = 1, damage = 0)
			talkas("Critical damage resolved. Lifting lockout.")
			return

/obj/structure/terminal/damage_console/proc/LinkToShipMaster(master_console as obj)

	linked_master_console = master_console
	for (var/obj/structure/ship_elements/damage_control_element/control_element_to_link in GLOB.ship_areas)
		if(control_element_to_link.ship_name == linked_master_console.sector_map_data["name"])
			control_element_to_link.LinkToConsole(src)
	terminal_id = "[linked_master_console.sector_map_data["name"]][initial(terminal_id)]"
	item_serial = "[uppertext(linked_master_console.sector_map_data["name"])][initial(item_serial)]"
	UpdateMapData()
	terminal_header += {"<div class="box"><p><center><b>"}+ html_encode("[linked_master_console.sector_map_data["name"]] - DAMAGE CONTROL") + {"</b><br>"} + html_encode("UACM 2ND LOGISTICS") + {"</center></p></div><div class="box_console"><p><center>[usage_data["damage"]["HP"]]|[usage_data["damage"]["engine"]]/[usage_data["damage"]["systems"]]/[usage_data["damage"]["weapons"]]/usage_data["damage"]["hull"]</center></p>"}
	reset_buffer()

/obj/structure/terminal/damage_console/proc/ProcessShipDamage(system = null, value = 0)
	if(system == null || value == 0) return
	var/damage_point_processed = 1
	while(damage_point_processed <= value)
		var/list/control_points_to_pick = list()
		for(var/obj/structure/ship_elements/damage_control_element/control_element_to_list in damage_controls)
			if(control_element_to_list.repair_damaged == 0)
				control_points_to_pick.Add(control_element_to_list)
		if(control_points_to_pick.len == 0) return "Error - Out of damage control points."
		var/obj/structure/ship_elements/damage_control_element/damage_point_to_process = pick(control_points_to_pick)
		damage_point_to_process.GetDamaged(damage_type = system)
		usage_data["damage"][system] += 1
		damage_point_processed += 1
	if(usage_data["damage"]["engine"] > usage_data["damage"]["HP"] || usage_data["damage"]["systems"] > usage_data["damage"]["HP"] || usage_data["damage"]["weapons"] > usage_data["damage"]["HP"] || usage_data["damage"]["hull"] > usage_data["damage"]["HP"])
		talkas("Warning. Critical damage recieved. Engaging emergency Hyperspace leapfrog.")
		world << browse(null, "window=[terminal_id]")
		return
	else
		talkas("Warning. Damage to ship [system] absorbed by LD synchronization coils. Coils damaged: [value]. Awaiting full scan.")
		linked_master_console.linked_command_chair.open_command_window("ship_status")
		return

/obj/structure/terminal/damage_console/proc/CheckCriticalFix()
	var/coils_left = 0
	for(var/obj/structure/ship_elements/damage_control_element/element_to_add in damage_controls)
		if(element_to_add.repair_damaged == 1)
			coils_left += 1
	if(coils_left != 0) return coils_left
	if(coils_left == 0)
		linked_master_console.RepairShutdown(state = 0)


/obj/structure/terminal/damage_console/attack_hand(mob/user)
	if(repair_shutdown == 0)
		terminal_display_line("Hello, [usr].")
		terminal_display_line("Scanning synchronization coils...", TERMINAL_STANDARD_SLEEP)
	if(repair_shutdown == 1)
		terminal_display_line("EMERGENCY MAINTENANCE MODE")
		terminal_display_line("Critical damage to synchronization coils. All damage must be repaired to lift the lockdown.")
	var/saved_buffer_len = terminal_buffer.len
	for (var/obj/structure/ship_elements/damage_control_element/control_element_to_check in damage_controls)
		if(control_element_to_check.repair_damaged == 1)
			terminal_display_line("Coil [control_element_to_check.item_serial], Location: [get_area_name(control_element_to_check)]")
	if(saved_buffer_len == terminal_buffer.len) terminal_display_line("No damaged coils detected.")
	return
