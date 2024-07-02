// Areas - for final area spiking, rooms etc
/area/salvage
	name = "salvage area master definition"
	desc = "Ideally should not be used in game, use subtypes"
	desc_lore = "What desc said. Can desc lore even be viewed for areas? I think not :P"
	has_gravity = 0
	weather_enabled = 0
	requires_power = 0
	unlimited_power = 1
	salvage_area_tag = "default"

//Procs below everything else to avoid definition loopholes

//items - no disassembly, but can be intel


/obj/item/salvage
	name = "salvage item - master definition"
	desc = "This is a master item. It shoudl not be placed anywhere in the game world."
	desc_lore = "If you have the time, please consider reporting this as a bug."
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "master"
	flags_item = NOBLUDGEON
	var/list/salvage_contents = list(
		"metal" = 0,
		"resin" = 0,
		"alloy" = 0,
		)
	var/salvage_intel_item = FALSE
	var/list/salvage_search = list(		//Main search list, has all the basic data, plus default return/reexamine texts. This is the var that is read for all text/functions of the searching system. Ideally this list should not be touched.
		"can_be_searched" = 0,
		"was_searched" = 0,
		"search_time" = SEARCH_TIME_NORMAL,
		"search_return_initial" = "After a through search you don't discover anything of note. Oops.",
		"search_return_complete" = "There is nothing special about this item."
		)
	var/list/salvage_search_alttext = list( //Alttexts for specific steps/results of searches. Copy the whole bock to customize.
		"search_return_initial" = "There seems to be unique writing or instruction on this object that warrant it being scanned for intel instead of salvaged.",
		"search_return_complete" = "There seems to be unique writing or instruction on this object that warrant it being scanned for intel instead of salvaged. "
		)
	var/desc_affix
	var/desc_lore_affix
	var/no_salvage = 0
	var/icon_state_min = 1 // Can be used with icon_state_max to further limit range of autorolled icons. For subvarieties
	var/icon_state_max = 0 // Change to a number to indicate dmi has more than one possible icon_state for randomization. Names shold be [icon_state]_[number], with last number being the value in this var.
	var/salvage_random = 0 // If 1 will roll a 5% chance for this item to be an intel document and sets it salvage_search values accordingly, and 15% to be a dummy serchable if the previous does not hapen
	var/salvage_area_tag
	var/salvage_container_tag
	var/pixel_randomize = 0

/obj/item/salvage/update_icon()
	if(icon_state_max > 0) icon_state = initial(icon_state) + "_[rand(icon_state_min,icon_state_max)]"
	. = ..()

/obj/item/salvage/proc/pixel_randomize()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/item/salvage/Initialize(mapload, ...)
	. = ..()
	if(icon_state_max > 0)
		update_icon()
	if(pixel_randomize) pixel_randomize()
	if(salvage_random)
		var/random_roll = rand(1,100)
		if(random_roll >= 95)
			salvage_search["can_be_searched"] = 1
			salvage_search["search_return_initial"] = salvage_search_alttext["search_return_initial"]
			salvage_search["search_return_complete"] = salvage_search_alttext["search_return_complete"]
			salvage_intel_item = 1
		if(random_roll >= 80 && random_roll < 95)
			salvage_search["can_be_searched"] = 1
	if(no_salvage == 0)
		GLOB.salvaging_total_ldpol += ((salvage_contents["metal"] + salvage_contents["resin"] + salvage_contents["alloy"]) / 5)
		GLOB.salvaging_total_metal += salvage_contents["metal"]
		GLOB.salvaging_total_resin += salvage_contents["resin"]
		GLOB.salvaging_total_alloy += salvage_contents["alloy"]
		GLOB.salvaging_items_objects += src
		if(salvage_intel_item) GLOB.salvaging_intel_items += 1
		var/area/currentarea = get_area(src)
		if(currentarea.salvage_area_tag != null)
			salvage_area_tag = currentarea.salvage_area_tag
	if(desc_affix != null)
		desc = initial(desc) + "</p><p>" + desc_affix
	if(desc_lore_affix != null)
		desc_lore = initial(desc_lore) + "</p><p>" + desc_lore_affix


/obj/item/salvage/examine(mob/user)
	..()
	if(salvage_search["can_be_searched"] == 1 && salvage_search["was_searched"] == 0)
		to_chat(usr, SPAN_INFO("This object can be searched for more information. Use it in your active hand to begin the search."))
	if(salvage_search["can_be_searched"] == 1 && salvage_search["was_searched"] == 1)
		to_chat(usr, SPAN_INFO("This object can be searched for more information. It looks like someone already went through it, but you can still take a closer look."))

/obj/item/salvage/proc/salvage_recycle(obj/item/salvage/recycler_nozzle/N)
	var/obj/item/salvage/recycler_nozzle/nozzle = N
	INVOKE_ASYNC(nozzle.recycler_nozzle_paired_pack, TYPE_PROC_REF(/obj/item/salvage/recycler_backpack, recycler_add_salvage), salvage_contents["metal"], salvage_contents["resin"], salvage_contents["alloy"])
	playsound(src, 'sound/effects/EMPulse.ogg', 25)
	var/obj/item/effect/decon_shimmer/decon_item/decon_effect = new (get_turf(src))
	decon_effect.pixel_x = pixel_x
	decon_effect.pixel_y = pixel_y
	sleep(15)
	icon = 'icons/turf/almayer.dmi'
	icon_state = "empty"
	plane = SPACE_PLANE
	update_icon()
	INVOKE_ASYNC(decon_effect, TYPE_PROC_REF(/obj/item/effect/decon_shimmer/decon_item, delete_with_anim))
	qdel(src)
	return

/obj/item/salvage/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/recycler_nozzle/))
		var/obj/item/salvage/recycler_nozzle/nozzle = W
		if(no_salvage)
			nozzle.talkas("Error: This item cannot be recycled.")
			return
		if(nozzle.recycler_nozzle_paired_pack == null)
			nozzle.talkas("Error: No backpack paired. Please pair this nozzle to a backpack.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		if (nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage >= nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage_max)
			nozzle.recycler_nozzle_paired_pack.talkas("Error. Backpack full. Please depoist resources.")
			nozzle.recycler_nozzle_paired_pack.recycler_full_warning()
			return
		if (nozzle.recycler_nozzle_charges < 1)
			nozzle.talkas("Error: Air canister depleted. Please recharge at nearest charging station.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		salvage_recycle(nozzle)
		return

/obj/item/salvage/attack_self(mob/user)
	. = ..()
	if(usr.a_intent == INTENT_GRAB)
		if(salvage_search["can_be_searched"] == 0)
			return
		if(salvage_search["was_searched"] == 1)
			to_chat(usr, SPAN_INFO("This item was already searched, but you can still gather the following:"))
			to_chat(usr, narrate_body(salvage_search["search_return_complete"]))
			if(salvage_intel_item == FALSE)
				to_chat(usr, SPAN_INFO("This item can be safely salvaged."))
			if(salvage_intel_item == TRUE)
				to_chat(usr, SPAN_INFO("This item should be returned for intelligence processing and should not be recycled."))
			return
		if(salvage_search["was_searched"] == 0)
			to_chat(usr, SPAN_INFO("Something seems to be off, you take a closer look at the item..."))
			if(do_after(usr, salvage_search["search_time"], INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(usr, narrate_body(salvage_search["search_return_initial"]))
				if(salvage_intel_item == FALSE)
					to_chat(usr, SPAN_INFO("This item can be safely salvaged."))
				if(salvage_intel_item == TRUE)
					to_chat(usr, SPAN_INFO("This item should be returned for intelligence processing and should not be recycled."))
				salvage_search["was_searched"] = 1
				return

// Structures and decon generation

/obj/structure/salvage
	name = "salvage structure - master definition"
	desc = "This is a master structure. It shoudl not be placed anywhere in the game world."
	desc_lore = "If you have the time, please consider reporting this as a bug."
	icon = 'icons/sectorpatrol/salvage/structures.dmi'
	icon_state = "master"
	anchored = 1
	density = 1
	opacity = 0
	var/list/salvage_contents = list(
		"metal" = 0,
		"resin" = 0,
		"alloy" = 0,
		)
	var/desc_affix
	var/desc_lore_affix
	var/hackable = 0 // If 1, spike proc will trigger as priority after using data spike. Introduce a state that breaks on decon later too, but for now keeping it simple. If 2, hack in progress, if 3 hack completed.
	var/hackable_message = 0 // If 1, will play a message after getting spiked.
	var/salvage_decon_keyword // Keyword formula: [TOOL(A to F) PAIR 1][TOOL PAIR 2](...)[INTENT(A to D) PAIR 1][INTENT PAIR2](...) ammount of steps is derived from lengh of string. Example: AFFAADBA, case insensitive
	var/list/salvage_decon_array //Alternatively just present a full array, with TRAIT_TOOL / INTENT_ pairs in each row. Presence of a decon array will make mapinit ignore the keyword, even if its set.
	var/salvage_big_item = 0 //If 1, restricts tool usage to specific item
	var/salvage_steps = 0
	var/salvage_current_step = 1
	var/no_salvage = 0
	var/salvage_area_tag = "default"
	var/salvage_container_tag
	var/icon_state_min = 1
	var/icon_state_max = 0
	var/icon_opens
	var/content_ammount = 0
	var/content_salvage_category = /obj/item/salvage

/obj/structure/salvage/proc/salvage_generate_decon()

	salvage_steps = (length(salvage_decon_keyword) / 2)
	salvage_decon_array = new/list(2,salvage_steps)
	var/salvage_gen_current_step = 0
	while (salvage_gen_current_step < salvage_steps)
		salvage_gen_current_step += 1
		var/salvage_decon_letter = uppertext(copytext(salvage_decon_keyword, salvage_gen_current_step, (salvage_gen_current_step + 1)))
		switch(salvage_decon_letter)
			if("A")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
			if("B")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_CROWBAR
			if("C")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_WIRECUTTERS
			if("D")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_WRENCH
			if("E")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_MULTITOOL
			if("F")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_DRILL
			else
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
	salvage_gen_current_step = 0
	while (salvage_gen_current_step < salvage_steps)
		salvage_gen_current_step += 1
		var/salvage_decon_letter = uppertext(copytext(salvage_decon_keyword, (salvage_gen_current_step + salvage_steps), ((salvage_gen_current_step + salvage_steps + 1))))
		switch(salvage_decon_letter)
			if("A")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HELP
			if("B")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_GRAB
			if("C")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_DISARM
			if("D")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HARM
			else
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HELP

/obj/structure/salvage/update_icon()
	if(icon_state_max > 0)
		icon_state = initial(icon_state) + "_[rand(icon_state_min,icon_state_max)]"
	if(salvage_current_step > salvage_steps)
		if(icon_opens)
			icon = icon_opens
	. = ..()

/obj/structure/salvage/proc/randomize_contents()
	if (content_salvage_category == null) return
	var/randomize_current_step = 1
	while (randomize_current_step <= content_ammount)
		var/obj/item/salvage/salvage = new content_salvage_category(get_turf(src))
		salvage.forceMove(src)
		randomize_current_step += 1


/obj/structure/salvage/Initialize(mapload, ...)
	. = ..()
	if(icon_state_max > 0)
		update_icon()
	if(salvage_container_tag)
		for(var/obj/item/salvage/items in get_turf(src))
			if(salvage_container_tag == items.salvage_container_tag)
				items.forceMove(src)
	if(content_ammount != 0) INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/salvage/, randomize_contents))
	if(salvage_decon_keyword && !salvage_decon_array) salvage_generate_decon()
	if(no_salvage == 0)
		GLOB.salvaging_total_ldpol += ((salvage_contents["metal"] + salvage_contents["resin"] + salvage_contents["alloy"])/ 5)
		GLOB.salvaging_total_metal += salvage_contents["metal"]
		GLOB.salvaging_total_resin += salvage_contents["resin"]
		GLOB.salvaging_total_alloy += salvage_contents["alloy"]
		GLOB.salvaging_items_objects += src
		if(hackable) GLOB.salvaging_total_intel_hacks += 1
		var/area/currentarea = get_area(src)
		if(currentarea.salvage_area_tag != null)
			salvage_area_tag = currentarea.salvage_area_tag
	if(desc_affix != null)
		desc = initial(desc) + "</p><p>" + desc_affix
	if(desc_lore_affix != null)
		desc_lore = initial(desc_lore) + "</p><p>" + desc_lore_affix


/obj/structure/salvage/proc/salvage_recycle(obj/item/salvage/recycler_nozzle/N)
	var/obj/item/salvage/recycler_nozzle/nozzle = N
	INVOKE_ASYNC(nozzle.recycler_nozzle_paired_pack, TYPE_PROC_REF(/obj/item/salvage/recycler_backpack, recycler_add_salvage), salvage_contents["metal"], salvage_contents["resin"], salvage_contents["alloy"])
	playsound(src, 'sound/effects/EMPulse.ogg', 25)
	var/obj/item/effect/decon_shimmer/decon_structure/decon_effect = new (get_turf(src))
	decon_effect.pixel_x = pixel_x
	decon_effect.pixel_y = pixel_y
	sleep(15)
	for(var/obj/item/salvage/items in contents)
		items.forceMove(get_turf(src))
	INVOKE_ASYNC(decon_effect, TYPE_PROC_REF(/obj/item/effect/decon_shimmer/decon_item, delete_with_anim))
	qdel(src)
	return


/obj/structure/salvage/proc/salvage_process_decon_generate_text(text = null, state = null)
	if (text == null || state == null) return
	var/text_to_return = text
	var/state_to_return = state
	switch(text_to_return)
		if(TRAIT_TOOL_SCREWDRIVER)
			switch(state_to_return)
				if("starting") return "You start to unfasten the screws on the [src]."
				if("finished") return "You remove the screws from the [src] and put them aside."
				if("examine") return "You need a screwdriver to prepare this object for salvaging."
		if(TRAIT_TOOL_CROWBAR)
			switch(state_to_return)
				if("starting") return "You start to pry the external cover off the [src] with a crowbar."
				if("finished") return "You remove the external cover from the [src]."
				if("examine") return "You need a crowbar to prepare this object for salvaging."
		if(TRAIT_TOOL_WIRECUTTERS)
			switch(state_to_return)
				if("starting") return "You start to cut the internal circutry of [src] with the wirecutters."
				if("finished") return "You finish cutting the internal circutry of [src] and make sure the internal elements are loose."
				if("examine") return "You need some wirecutters to prepare this object for salvaging."
		if(TRAIT_TOOL_WRENCH)
			switch(state_to_return)
				if("starting") return "You start to remove heavy bolts from the [src] with a wrench."
				if("finished") return "You remove the bolts from the [src]."
				if("examine") return "You need a wrench to prepare this object for salvaging."
		if(TRAIT_TOOL_MULTITOOL)
			switch(state_to_return)
				if("starting") return "You plug in a multitool to [src] and start a diagnostic routine."
				if("finished") return "The multitool finishes its routine on [src] and opens its maintenance hatch."
				if("examine") return "You need a multitool to prepare this object for salvaging."
		if(TRAIT_TOOL_DRILL)
			switch(state_to_return)
				if("starting") return "You start to drill through the [src]."
				if("finished") return "You finish drilling through the [src]."
				if("examine") return "You need a drill to prepare this object for salvaging."
		if(INTENT_HELP)
			switch(state_to_return)
				if("examine") return "The tool should be used in HELP intent."
		if(INTENT_GRAB)
			switch(state_to_return)
				if("examine") return "The tool should be used in GRAB intent."
		if(INTENT_DISARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in DISARM intent."
		if(INTENT_HARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in HARM intent."

/obj/structure/salvage/proc/salvage_return_step_text()
	if(salvage_current_step <= salvage_steps)
		var/salvage_desc = salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "examine") + " " + salvage_process_decon_generate_text(text = salvage_decon_array[2][salvage_current_step], state = "examine")
		to_chat(usr, SPAN_INFO(salvage_desc))
	if(salvage_current_step > salvage_steps)
		for(var/obj/item/salvage/items in src.contents)
			items.forceMove(get_turf(src))
			items.pixel_randomize()
		color = "#bebebe"
		update_icon()
		to_chat(usr, SPAN_INFO("This object is ready for recycling."))

/obj/structure/salvage/examine(mob/user)
	..()
	salvage_return_step_text()
	if(salvage_big_item)
		to_chat(usr, SPAN_INFO("This object is large and complex enough that it will require your full attention during decomission."))

/obj/structure/salvage/proc/salvage_process_decon()
	to_chat(usr, SPAN_INFO(salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "starting")))
	if(do_after(usr, (CRAFTING_DELAY_NORMAL * usr.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(usr, SPAN_INFO(salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "finished")))
		salvage_return_step_text()
		salvage_current_step += 1
		return 1
	return 0

/obj/structure/salvage/proc/salvage_play_message()
	talkas("Pythia Exception: Critical information flag detected. Compiling and playing back relevant infomration:")
	talkas("Hello. I am a default message. If you can see me someone, most likley silencer, forgot to set me up properly. Please report this as a bug.")
	return

/obj/structure/salvage/proc/salvage_process_spike()
	switch(hackable)
		if(1)
			emoteas("pops louldy a few times as liquid from the spike is absorbed inside.")
			hackable = 2
			langchat_color = "#9b06a8"
			talkas("Spike delivery sucessful. Caching information.")
			sleep(100)
			talkas("Infomration retrieved. Data cache pulse sent. This device now may be deconstructed.")
			hackable = 3
			if(hackable_message) INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/salvage/, salvage_play_message))
			GLOB.salvaging_intel_items += 1
			return 1
		if(2)
			to_chat(usr, SPAN_INFO("This device is already being hacked."))
			return 0
		if(3)
			to_chat(usr, SPAN_INFO("This device has already been scrapped for data."))
			return 0
		else
			return "exeption"


/obj/structure/salvage/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/recycler_nozzle/))
		var/obj/item/salvage/recycler_nozzle/nozzle = W
		if(no_salvage)
			nozzle.talkas("Error: This item cannot be recycled.")
			return
		if(nozzle.recycler_nozzle_paired_pack == null)
			nozzle.talkas("Error: No backpack paired. Please pair this nozzle to a backpack.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		if (nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage >= nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage_max)
			nozzle.recycler_nozzle_paired_pack.talkas("Error. Backpack full. Please depoist resources.")
			nozzle.recycler_nozzle_paired_pack.recycler_full_warning()
			return
		if (nozzle.recycler_nozzle_charges < 1)
			nozzle.talkas("Error: Air canister depleted. Please recharge at nearest charging station.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		if(salvage_current_step < salvage_steps)
			nozzle.talkas("Error: Unloosened fastening detected. Salvage will be suboptimal.")
			nozzle.talkas("Error: Safety mode engaged. Action disallowed.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		salvage_recycle(nozzle)
		return
	if(hackable)
		if(istype(W, /obj/item/salvage/data_spike/))
			var/obj/item/salvage/data_spike/spike = W
			if(salvage_process_spike() == 1)
				qdel(spike)
				return
			return
	if(salvage_current_step > salvage_steps)
		to_chat(usr, SPAN_INFO("This object is ready for salvaging and does not need any further tinkering."))
		return
	if(salvage_decon_array && salvage_current_step <= salvage_steps)
		if(HAS_TRAIT(W, salvage_decon_array[1][salvage_current_step]))
			if(usr.a_intent == salvage_decon_array[2][salvage_current_step])
				if(W.check_use(flag = salvage_big_item) == 1)
					if(salvage_process_decon() == 1)
						update_icon()
						if(salvage_big_item == 1) W.is_used = 0
						return
					if(salvage_big_item == 1) W.is_used = 0
					return "exception - salvage_process_decon failed"
				to_chat(usr, SPAN_INFO("You are already using this tool a big object."))
				return
			to_chat(usr, SPAN_INFO("You do not seem to be using the correct intent for this action. Look at the object for more information."))
			return
		to_chat(usr, SPAN_INFO("You do not seem to be using the correct tool for this action. Look at the object for more information."))
		return
	to_chat(usr, SPAN_INFO("You have no idea how to combine these two together."))

//turfs, tile stripping, straightforward really.

/turf/proc/salvage_decon()
	mouse_opacity = 0
	sleep(rand(1,20))
	var/obj/item/effect/decon_shimmer/decon_turf/decon_effect = new (get_turf(src))
	sleep(65)
	icon = 'icons/sectorpatrol/salvage/turfs.dmi'
	icon_state = "empty"
	plane = SPACE_PLANE
	update_icon()
	decon_effect.delete_with_anim()
	GLOB.resources_metal += salvage_contents["metal"]
	GLOB.resources_resin += salvage_contents["resin"]
	GLOB.resources_alloy += salvage_contents["alloy"]
	GLOB.resources_ldpol += (salvage_contents["metal"] + salvage_contents["resin"] + salvage_contents["alloy"] / 5)
	salvage_contents["metal"] = 0
	salvage_contents["resin"] = 0
	salvage_contents["alloy"] = 0

/turf/proc/salvage_decon_area()
	for (var/turf/T in get_area(src))
		INVOKE_ASYNC(T, TYPE_PROC_REF(/turf, salvage_decon))


/turf/open/salvage/
	name = "salvagable floor - master item"
	desc = "Yet another item that should not be player facing. Oops!"
	desc_lore = "Please report this as a bug if this is visible anywhere if you have the time."
	icon = 'icons/sectorpatrol/salvage/turfs.dmi'
	icon_state = "master"

	var/salvage_decon_keyword // Keyword formula: [TOOL(A to F) PAIR 1][TOOL PAIR 2](...)[INTENT(A to D) PAIR 1][INTENT PAIR2](...) ammount of steps is derived from lengh of string. Example: AFFAADBA, case insensitive
	var/list/salvage_decon_array //Alternatively just present a full array, with TRAIT_TOOL / INTENT_ pairs in each row. Presence of a decon array will make mapinit ignore the keyword, even if its set.
	var/salvage_steps = 0
	var/salvage_current_step = 1
	no_salvage = 0
	var/desc_affix
	var/desc_lore_affix
	var/salvage_tiles_recycled = 0

	var/list/salvage_contents_tile = list(
		"metal" = 0,
		"resin" = 0,
		"alloy" = 0,
		)

/turf/open/salvage/update_icon()
	. = ..()
	if(salvage_current_step > salvage_steps)
		desc_affix = null
		desc_lore_affix = null
		desc = initial(desc)
		desc_lore = initial(desc_lore)


/turf/open/salvage/proc/salvage_generate_decon()

	salvage_steps = (length(salvage_decon_keyword) / 2)
	salvage_decon_array = new/list(2,salvage_steps)
	var/salvage_gen_current_step = 0
	while (salvage_gen_current_step < salvage_steps)
		salvage_gen_current_step += 1
		var/salvage_decon_letter = uppertext(copytext(salvage_decon_keyword, salvage_gen_current_step, (salvage_gen_current_step + 1)))
		switch(salvage_decon_letter)
			if("A")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
			if("B")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_CROWBAR
			if("C")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_WIRECUTTERS
			if("D")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_WRENCH
			if("E")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_MULTITOOL
			if("F")
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_DRILL
			else
				salvage_decon_array[1][salvage_gen_current_step] = TRAIT_TOOL_SCREWDRIVER
	salvage_gen_current_step = 0
	while (salvage_gen_current_step < salvage_steps)
		salvage_gen_current_step += 1
		var/salvage_decon_letter = uppertext(copytext(salvage_decon_keyword, (salvage_gen_current_step + salvage_steps), ((salvage_gen_current_step + salvage_steps + 1))))
		switch(salvage_decon_letter)
			if("A")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HELP
			if("B")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_GRAB
			if("C")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_DISARM
			if("D")
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HARM
			else
				salvage_decon_array[2][salvage_gen_current_step] = INTENT_HELP


/turf/open/salvage/Initialize(mapload, ...)
	. = ..()
	if(salvage_decon_keyword && !salvage_decon_array) salvage_generate_decon()
	if(!no_salvage) GLOB.salvaging_turfs_open += src
	if(desc_affix != null)
		desc = initial(desc) + "</p><p>" + desc_affix
	if(desc_lore_affix != null)
		desc_lore = initial(desc_lore) + "</p><p>" + desc_lore_affix

/turf/open/salvage/proc/remove_decals()
	for (var/obj/effect/decal/decal in get_turf(src))
		qdel(decal)

/turf/open/salvage/proc/salvage_recycle_tile(obj/item/salvage/recycler_nozzle/N)
	var/obj/item/salvage/recycler_nozzle/nozzle = N
	INVOKE_ASYNC(nozzle.recycler_nozzle_paired_pack, TYPE_PROC_REF(/obj/item/salvage/recycler_backpack, recycler_add_salvage), salvage_contents_tile["metal"], salvage_contents_tile["resin"], salvage_contents_tile["alloy"])
	salvage_contents_tile["metal"] = 0
	salvage_contents_tile["resin"] = 0
	salvage_contents_tile["alloy"] = 0
	playsound(src, 'sound/effects/EMPulse.ogg', 25)
	var/obj/item/effect/decon_shimmer/decon_tile/decon_effect = new (get_turf(src))
	sleep(15)
	icon = 'icons/sectorpatrol/salvage/turfs.dmi'
	icon_state = "floor_base"
	desc_affix = null
	desc_lore_affix = null
	update_icon()
	INVOKE_ASYNC(src, PROC_REF(remove_decals))
	INVOKE_ASYNC(decon_effect, TYPE_PROC_REF(/obj/item/effect/decon_shimmer/decon_item, delete_with_anim))
	salvage_tiles_recycled = 1
	return


/turf/open/salvage/proc/salvage_process_decon_generate_text(text = null, state = null)
	if (text == null || state == null) return
	var/text_to_return = text
	var/state_to_return = state
	switch(text_to_return)
		if(TRAIT_TOOL_SCREWDRIVER)
			switch(state_to_return)
				if("starting") return "You unfasten the screws on the [src]."
				if("finished") return "You unfasten the screws on the [src] and put them aside."
				if("examine") return "You need a screwdriver to prepare this floor for salvaging."
		if(TRAIT_TOOL_CROWBAR)
			switch(state_to_return)
				if("starting") return "You start to loosen the tiles off the [src]."
				if("finished") return "You loosen the tiles off the[src]."
				if("examine") return "You need a crowbar to prepare this object for salvaging."
		if(TRAIT_TOOL_WIRECUTTERS)
			switch(state_to_return)
				if("starting") return "You start to cut the cables fastening the tiles to the [src]."
				if("finished") return "You finish cutting the cables fastening the tiles to the [src]."
				if("examine") return "You need some wirecutters to prepare this object for salvaging."
		if(TRAIT_TOOL_WRENCH)
			switch(state_to_return)
				if("starting") return "You start to remove heavy bolts from the [src] with a wrench."
				if("finished") return "You remove the bolts from the [src]."
				if("examine") return "You need a wrench to prepare this object for salvaging."
		if(TRAIT_TOOL_MULTITOOL)
			switch(state_to_return)
				if("starting") return "You plug in a multitool to [src] and start a diagnostic routine."
				if("finished") return "The multitool finishes its routine on [src] and beeps loudly."
				if("examine") return "You need a multitool to prepare this object for salvaging."
		if(TRAIT_TOOL_DRILL)
			switch(state_to_return)
				if("starting") return "You start to drill through the [src]."
				if("finished") return "You finish drilling through the [src]."
				if("examine") return "You need a drill to prepare this object for salvaging."
		if(INTENT_HELP)
			switch(state_to_return)
				if("examine") return "The tool should be used in HELP intent."
		if(INTENT_GRAB)
			switch(state_to_return)
				if("examine") return "The tool should be used in GRAB intent."
		if(INTENT_DISARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in DISARM intent."
		if(INTENT_HARM)
			switch(state_to_return)
				if("examine") return "The tool should be used in HARM intent."

/turf/open/salvage/proc/salvage_return_step_text()
	if(salvage_current_step <= salvage_steps)
		var/salvage_desc = salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "examine") + " " + salvage_process_decon_generate_text(text = salvage_decon_array[2][salvage_current_step], state = "examine")
		to_chat(usr, SPAN_INFO(salvage_desc))
	if(salvage_current_step > salvage_steps)
		color = "#bebebe"
		update_icon()
		to_chat(usr, SPAN_INFO("This floor is ready for recycling."))

/turf/open/salvage/examine(mob/user)
	..()
	salvage_return_step_text()

/turf/open/salvage/proc/salvage_process_decon()
	to_chat(usr, SPAN_INFO(salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "starting")))
	if(do_after(usr, (CRAFTING_DELAY_NORMAL * usr.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(usr, SPAN_INFO(salvage_process_decon_generate_text(text = salvage_decon_array[1][salvage_current_step], state = "finished")))
		salvage_current_step += 1
		salvage_return_step_text()
		return 1
	return 0

/turf/open/salvage/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/recycler_nozzle/))
		var/obj/item/salvage/recycler_nozzle/nozzle = W
		if(no_salvage)
			nozzle.talkas("Error: This floor cannot be recycled.")
			return
		if(salvage_tiles_recycled)
			nozzle.talkas("Error. Tiles already restracted. To remove the entire floor, please use a drone spike.")
			return
		if(nozzle.recycler_nozzle_paired_pack == null)
			nozzle.talkas("Error: No backpack paired. Please pair this nozzle to a backpack.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		if (nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage >= nozzle.recycler_nozzle_paired_pack.recycler_backpack_storage_max)
			nozzle.recycler_nozzle_paired_pack.talkas("Error. Backpack full. Please depoist resources.")
			nozzle.recycler_nozzle_paired_pack.recycler_full_warning()
			return
		if (nozzle.recycler_nozzle_charges < 1)
			nozzle.talkas("Error: Air canister depleted. Please recharge at nearest charging station.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		if(salvage_current_step < salvage_steps)
			nozzle.talkas("Error: Unloosened fastening detected. Salvage will be suboptimal.")
			nozzle.talkas("Error: Safety mode engaged. Action disallowed.")
			playsound(nozzle, 'sound/machines/terminal_error.ogg', 25)
			return
		salvage_recycle_tile(nozzle)
		return
	if(salvage_current_step > salvage_steps)
		to_chat(usr, SPAN_INFO("This floor is ready for salvaging and does not need any further tinkering."))
		return
	if(salvage_decon_array && salvage_current_step <= salvage_steps)
		if(HAS_TRAIT(W, salvage_decon_array[1][salvage_current_step]))
			if(usr.a_intent == salvage_decon_array[2][salvage_current_step])
				if(W.check_use(flag = 0) == 1)
					if(salvage_process_decon() == 1)
						update_icon()
						return
					if(salvage_process_decon() == 1)
						update_icon()
						W.is_used = 0
						return
					return "exception - salvage_process_decon failed"
				to_chat(usr, SPAN_INFO("This tool is already being used on an object that requires your full attention. Stop the process by moving or taking the tool out of your hand, or wait until it is finished."))
				return
			to_chat(usr, SPAN_INFO("You do not seem to be using the correct intent for this action. Look at the object for more information."))
			return
		to_chat(usr, SPAN_INFO("You do not seem to be using the correct tool for this action. Look at the object for more information."))
		return
	to_chat(usr, SPAN_INFO("You have no idea how to combine these two together."))

/turf/closed/wall/salvage
	salvage_contents = list(
		"metal" = 50,
		"resin" = 10,
		"alloy" = 10,
		)
	icon = 'icons/sectorpatrol/salvage/walls/black.dmi'
	icon_state = "blackwall"
	walltype = "blackwall"
	desc = "A thick layer of hardened metal."
	desc_lore = "From the earliest days of interstellar travel, ship hulls were always one of the least technologically impressive parts of ships, most ship designs veering more towards 'surround crew with as much steel as possible' design principle and not anything else. Notably TWE and some new UA designs introduce more complex alloys and intricate designs, but for the most part, most human ships still hold true to this principle.</p><p>Ship hulls are a good source of metals and should also yield some resins and alloys but need to be recovered via deconstruction drones utilizing a drone spike."
	tiles_with = list(
		/turf/closed/wall,
		/obj/structure/window/framed,
		/obj/structure/window_frame,
		/obj/structure/girder,
		/obj/structure/machinery/door,
	)

/turf/closed/wall/salvage/attackby(obj/item/attacking_item, mob/user)
	to_chat(usr, SPAN_NOTICE("Trying to dismantle the walls piece by piece would take too long and you lack the tools to breach the wall right now. If you want to go into or outside the ship, find a door to recycle and breach."))
	return


//area proc down here so there is no undefined funnies

/area/proc/salvage_process_area_decon() // Checks objects and items that are not nulled (i/e deleted) for matches to area tags. If suceeds, does the same for turfs but chekcs for their decon state, if none of that makes it return a fail state, proceeds and calls salvages for all turfs with area tag in salvagable turf list (to spare the dumb way BYOND handles area.contents from scanning the whole fucking world, I can likely optimize taht to specifc lists by area tag later but lets see how this performs first. If this text is still here after a while, it likley performs in the relams of 'good enough'  | returns : null - exceptions, 1 - success, 2 - non nulled items found, 3 - non nulled structures, 4 - non salvaged turfs (checks for tiles removal var)
	for(var/obj/item/salvage/salvage_item in GLOB.salvaging_items_objects)
		if(get_turf(salvage_item) == !null)
			if (salvage_item.salvage_area_tag == salvage_area_tag)
				return 2
	for(var/obj/structure/salvage/salvage_structure in GLOB.salvaging_items_objects)
		if(get_turf(salvage_structure) == !null)
			if (salvage_structure.salvage_area_tag == salvage_area_tag)
				return 3
	for(var/turf/open/salvage/open_turf in GLOB.salvaging_turfs_open)
		if(open_turf.salvage_area_tag == salvage_area_tag)
			if(open_turf.salvage_tiles_recycled == 0)
				return 4
	for(var/turf/turf_with_area_tag in GLOB.salvaging_turfs_all)
		if (turf_with_area_tag.salvage_turf_processed == 0)
			INVOKE_ASYNC(turf_with_area_tag, TYPE_PROC_REF(/turf, salvage_recycle_turf))
	return 1
