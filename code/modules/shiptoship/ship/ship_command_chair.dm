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
