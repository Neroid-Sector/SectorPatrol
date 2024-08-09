/obj/structure/ship_elements/damage_control_element
	name = "Liquid Data synchronization coil"
	desc = "A device hidden in a circular slot in the hull."
	desc_lore = "One of the cornerstones of the OV-PST based Mission Control system, these systems supposedly contain replacement packets for the ships various critical systems which somehow manage to \"centralize\" all damage done to the ship in these central points, allowing for easy damage control and repairs. Any documentation available is notoriously vague about how this process is possible and very casually skirts over the multiple laws of physics this seems to fly in the face of."
	icon = 'icons/sectorpatrol/ship/damage_control.dmi'
	icon_state = "damage_0"
	item_serial = "ORIGIN-NDE-DMS"
	anchored = TRUE
	plane = FLOOR_PLANE
	unacidable = TRUE
	unslashable = TRUE
	opacity = FALSE
	density = FALSE
	var/ship_name = "none"
	var/generate_max_steps = 5
	var/repair_keyword
	var/list/repair_array
	var/repair_steps
	var/repair_current_step
	var/repair_damaged = 0
	var/repair_in_use

/obj/structure/ship_elements/damage_control_element/update_icon()
	. = ..()
	switch(icon_state)
		if("damage_1","damage_2","damage_5")
			desc = initial(desc)
		if("damage_3","damage_4")
			desc = "A long metal tube concealing a metal rig with multiple racks, with each rack storing a board or mechanical element that either needs servicing or has recently been fixed."

/obj/structure/ship_elements/damage_control_element/proc/repair_generate_steps()

	repair_steps = (length(repair_keyword) / 2)
	if(repair_array != null) repair_array = null
	repair_array = new/list(2,repair_steps)
	var/repair_gen_current_step = 0
	while (repair_gen_current_step < repair_steps)
		repair_gen_current_step += 1
		var/repair_letter = uppertext(copytext(repair_keyword, repair_gen_current_step, (repair_gen_current_step + 1)))
		switch(repair_letter)
			if("A")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
			if("B")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_CROWBAR
			if("C")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_WIRECUTTERS
			if("D")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_WRENCH
			if("E")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_MULTITOOL
			if("F")
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_DRILL
			else
				repair_array[1][repair_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
	repair_gen_current_step = 0
	while (repair_gen_current_step < repair_steps)
		repair_gen_current_step += 1
		var/salvage_decon_letter = uppertext(copytext(repair_keyword, (repair_gen_current_step + repair_steps), ((repair_gen_current_step + repair_steps + 1))))
		switch(salvage_decon_letter)
			if("A")
				repair_array[2][repair_gen_current_step] = INTENT_HELP
			if("B")
				repair_array[2][repair_gen_current_step] = INTENT_GRAB
			if("C")
				repair_array[2][repair_gen_current_step] = INTENT_DISARM
			if("D")
				repair_array[2][repair_gen_current_step] = INTENT_HARM
			else
				repair_array[2][repair_gen_current_step] = INTENT_HELP
	repair_current_step = 1

/obj/structure/ship_elements/damage_control_element/proc/repair_generate_keyword()
	if(repair_keyword != null) repair_keyword = null
	var/current_keyword_gen_step = 1
	var/tool_letters
	var/intent_letters
	while (current_keyword_gen_step <= generate_max_steps)
		tool_letters += pick("A","B","C","D","E","F")
		intent_letters += pick("A","B","C","D")
		current_keyword_gen_step += 1
	repair_keyword = tool_letters + intent_letters

/obj/structure/ship_elements/damage_control_element/proc/useblink()
	var/current_color = color
	color = "#acacac"
	sleep(3)
	color = current_color

/obj/structure/ship_elements/damage_control_element/proc/repair_generate_av(tool = null)
	if(tool == null) return
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/ship_elements/damage_control_element/, useblink))
	var/av_to_play = tool
	switch(av_to_play)
		if(TRAIT_TOOL_SCREWDRIVER)
			playsound(src, 'sound/items/Screwdriver.ogg', 25)
			return
		if(TRAIT_TOOL_CROWBAR)
			playsound(src, 'sound/items/Crowbar.ogg', 25)
			return
		if(TRAIT_TOOL_WIRECUTTERS)
			playsound(src, 'sound/items/Wirecutter.ogg', 25)
			return
		if(TRAIT_TOOL_WRENCH)
			playsound(src, 'sound/items/Ratchet.ogg', 25)
			return
		if(TRAIT_TOOL_MULTITOOL)
			playsound(src, 'sound/machines/ping.ogg', 25)
			return
		if(TRAIT_TOOL_DRILL)
			playsound(src, 'sound/items/Drill.ogg', 25)
			return

/obj/structure/ship_elements/damage_control_element/proc/repair_generate_text(text = null, state = null)
	if (text == null || state == null) return
	var/text_to_return = text
	var/state_to_return = state
	switch(text_to_return)
		if(TRAIT_TOOL_SCREWDRIVER)
			switch(state_to_return)
				if("starting") return "You pick away at the scorching marks on cable endings. Burnt bits seem to come off in huge chunks."
				if("finished") return "You finish removing the scorched wire endings. Blue get covers and seems to repair and refix the cables once you are finished."
				if("examine") return "A cable connection was burnt away, damaging both the cable and the device it is connected to. A <b>screwdriver</b> needs to be used to separate them."
		if(TRAIT_TOOL_CROWBAR)
			switch(state_to_return)
				if("starting") return "You start wedging a scorched module out of the device."
				if("finished") return "You wedge a burnt module out of the device. Blue, stringy crystal-like structures immediately start to fill in the empty space and replace the missing element."
				if("examine") return "A module panel was scorched and needs to be removed with a <b>crowbar</b>."
		if(TRAIT_TOOL_WIRECUTTERS)
			switch(state_to_return)
				if("starting") return "You start to cut through the burnt mass holding the damaged element."
				if("finished") return "You cut through the burnt mass with the wirecutters and remove the burnt element. A blue, crystal structure fills out the now empty space and creates a replacement for the lost part."
				if("examine") return "A burnt element dangles from a mass of fused wires and will need <b>wirecutters</b> to remove."
		if(TRAIT_TOOL_WRENCH)
			switch(state_to_return)
				if("starting") return "You start to loosen the bolt holding the destroyed element."
				if("finished") return "You remove the bolt and remove the mangled element. A blue crystal mass rapidly grows to replicate the shape of the lost element, then hardens and takes on its appearance."
				if("examine") return "A mechanical element was mangled beyond repair, a <b>wrench</b> should be used to loosen the bolt holding it in place."
		if(TRAIT_TOOL_MULTITOOL)
			switch(state_to_return)
				if("starting") return "You connect the multitool to the device and begin a diagnostic routine."
				if("finished") return "The diagnostic routine finishes, and the display goes blank. Somehow, you feel that the device approves."
				if("examine") return "A small display seems to be flashing an exclamation mark. A <b>multitool</b> can be connected to the device to fix the problem."
		if(TRAIT_TOOL_DRILL)
			switch(state_to_return)
				if("starting") return "You start to drill a new aligned threaded port into the modules and device surface."
				if("finished") return "You finish drilling the port, which immediately fills with a blueish, soft substance. After a few seconds the substance hardens and forms a bolt."
				if("examine") return "An explosion has destroyed a mounting port for one of the devices panels. You will need a <b>drill</b> to create a new one."
		if(INTENT_HELP)
			switch(state_to_return)
				if("examine") return "The tool should be used in <b>HELP</b> intent."
		if(INTENT_GRAB)
			switch(state_to_return)
				if("examine") return "The tool should be used in <b>GRAB</b> intent."
		if(INTENT_DISARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in <b>DISARM</b> intent."
		if(INTENT_HARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in <b>HARM</b> intent."

/obj/structure/ship_elements/damage_control_element/proc/repair_return_step_text()
	if(repair_current_step <= repair_steps)
		var/repair_text = repair_generate_text(text = repair_array[1][repair_current_step], state = "examine") + " " + repair_generate_text(text = repair_array[2][repair_current_step], state = "examine")
		to_chat(usr, SPAN_INFO(repair_text))
	if(repair_current_step > repair_steps)
		to_chat(usr, SPAN_INFO("The repairs are finished. The module can be retracted."))
		icon_state = "damage_4"

/obj/structure/ship_elements/damage_control_element/examine(mob/user)
	..()
	if(icon_state == "damage_0") to_chat(usr, SPAN_INFO("This device is functioning correctly."))
	if(icon_state == "damage_1") to_chat(usr, SPAN_INFO("The device indicates damage. Use an <b>empty hand</b> on <b>GRAB</b> intent to open it."))
	if(icon_state == "damage_3") to_chat(usr, SPAN_INFO(repair_generate_text()))
	if(icon_state == "damage_4") to_chat(usr, SPAN_INFO("The repairs to the device are finished and it can be pushed back into its socket. Use an <b>empty hand</b> with <b>HELP</b> intent."))

/obj/structure/ship_elements/damage_control_element/proc/repair_process_step()
	to_chat(usr, SPAN_INFO(repair_generate_text(text = repair_array[1][repair_current_step], state = "starting")))
	repair_generate_av(tool = repair_array[1][repair_current_step])
	repair_in_use = 1
	if(do_after(usr, (CRAFTING_DELAY_NORMAL * usr.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(usr, SPAN_INFO(repair_generate_text(text = repair_array[1][repair_current_step], state = "finished")))
		repair_in_use = 0
		repair_current_step += 1
		repair_return_step_text()
		return 1
	repair_in_use = 0
	return 0

/obj/structure/ship_elements/damage_control_element/attackby(obj/item/W, mob/user)
	if(repair_current_step > repair_steps)
		to_chat(usr, SPAN_INFO("This device has been fully repaired."))
		return
	if(repair_in_use == 1)
		to_chat(usr, SPAN_INFO("Someone is already working on this."))
		return
	if(repair_array && repair_current_step <= repair_steps)
		if(HAS_TRAIT(W, repair_array[1][repair_current_step]))
			if(usr.a_intent == repair_array[2][repair_current_step])
				if(repair_process_step() == 1)
					update_icon()
					return
				return "exception - repair_process_step failed"
			to_chat(usr, SPAN_INFO("You do not seem to be using the correct intent for this action. Look at the object for more information."))
			return
		to_chat(usr, SPAN_INFO("You do not seem to be using the correct tool for this action. Look at the object for more information."))
		return
	to_chat(usr, SPAN_INFO("You have no idea how to combine these two together."))

/obj/structure/ship_elements/damage_control_element/attack_hand(mob/user)
	if(icon_state == "damage_1")
		icon_state = "damage_2"
		update_icon()
		playsound(src, 'sound/machines/windowdoor.ogg', 25)
		emoteas("slides out of its socket and opens a side panel.", 1)
		sleep(9)
		icon_state = "damage_3"
		update_icon()
		return
	if(icon_state == "damage_4")
		icon_state = "damage_5"
		update_icon()
		playsound(src, 'sound/machines/windowdoor.ogg', 25)
		emoteas("slides back into its socket.", 1)
		sleep(9)
		icon_state = "damage_1"
		update_icon()
		return
	to_chat(usr, SPAN_INFO("The device does not budge and does not seem to have any direct way of interaction."))
