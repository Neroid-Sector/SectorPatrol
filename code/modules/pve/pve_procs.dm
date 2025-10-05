//Talking and emoting

/obj/proc/talkas(str, delay) //Talk as. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE)
	src.visible_message("<b>[src]</b> says, \"[str]\"")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return

/obj/proc/emoteas(str, delay) //Emote as. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
	src.visible_message("<b>[src]</b> [str]")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return

//Stimpack procs

/mob/living/carbon/human/proc/bind_stimpack(pack_to_bind)
	bound_injector = pack_to_bind
	var/obj/item/stim_injector/injector_to_bind = pack_to_bind
	injector_to_bind.injector_bound = 1

/mob/living/carbon/human/verb/find_injector()
	set name = "Recall Injector"
	set desc = "Recalls a bound injector."
	set category = "IC"

	if(bound_injector != null)
		usr.put_in_any_hand_if_possible(bound_injector)
		to_chat(usr, SPAN_INFO("Injector returned to hand or turf underneath."))
		return
	else
		to_chat(usr, SPAN_WARNING("No bound Injector found!"))
		return

//Resupply

/mob/living/carbon/human/verb/call_resupply()
	set name = "Call resupply"
	set desc = "Calls a resupply droppod. Depending on round state, it may be a partial or full resupply vendor."
	set category = "IC"

	var/turf_to_spawn = get_turf(src)
	if(GLOB.ammo_restock_next > world.time)
		return
	if(!do_after(usr, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, turf_to_spawn, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	if(GLOB.ammo_restock_next <= world.time)
		GLOB.ammo_restock_next = world.time + GLOB.ammo_restock_delay
		var/obj/structure/droppod/equipment/vendor/droppod
		if(GLOB.ammo_restock_full == 0)
			droppod = new /obj/structure/droppod/equipment/vendor/partial(turf_to_spawn, /obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo_refill/partial/, src)
		else
			droppod = new /obj/structure/droppod/equipment/vendor/(turf_to_spawn, /obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo_refill/, src)
		droppod.drop_time = 5 SECONDS
		droppod.launch(turf_to_spawn)
		return
	else
		to_chat(src, SPAN_WARNING("The Ammo Resupply is on cooldown!"))
		return

// Admin stuff

/client/proc/restock_adjust()
	set category = "DM.Xenosurge"
	set name = "Surge - Adjust Restock"
	set desc = "Sets parameters for restock drops."

	if(!check_rights(R_ADMIN))
		return

	var/restock_setup_value
	switch(tgui_input_list(usr, "Editing Restock Drop. Please pick an option:" , "Restock", list("Adjust next drop type","Reset drop delay","Adjust Drop Timer","Force Drop",)))
		if("Adjust next drop type")
			restock_setup_value = tgui_alert(usr, "Major drop flag status: [GLOB.ammo_restock_full]", "Restock", list("1","0"), timeout = 0)
			GLOB.ammo_restock_full = restock_setup_value
			return
		if("Reset drop delay")
			GLOB.ammo_restock_next = 0
			return
		if("Adjust Drop Timer")
			restock_setup_value = tgui_input_number(usr, "Current Delay: [GLOB.ammo_restock_delay]", "Restock", timeout = 0, min_value = 0, integer_only = TRUE)
			if(restock_setup_value != null)
				GLOB.ammo_restock_delay = restock_setup_value
				return
			else
				return
		if("Force Drop")
			var/turf/restock_turf = mob.loc
			var/obj/structure/droppod/equipment/vendor/droppod
			if(GLOB.ammo_restock_full == 0)
				droppod = new /obj/structure/droppod/equipment/vendor/partial(restock_turf, /obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo_refill/partial/, src)
			else
				droppod = new /obj/structure/droppod/equipment/vendor/(restock_turf, /obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo_refill/, src)
			droppod.drop_time = 5 SECONDS
			droppod.launch(restock_turf)
			return

