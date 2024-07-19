/obj/item/botany/seed_packet
	name = "seed packet master item"
	desc = "Master item - should not be in game"
	desc_lore = "These packets are part of the sustainability system being co-developed by the PST and the Harvest Star Conglomerate. These packets contain seeds suspended in a special nutrition jelly which also contains basic LD instructions for the active elements in the bioturf mixture used in the trays."
	icon = 'icons/sectorpatrol/botany/plants.dmi'
	icon_state = "default"
	var/list/botany_plant_data = list(
		"name" = "default",
		"yield" = 5,
		"additive" = "none",
		"aftercare" = "none",
		"repeating" = 0,
		)

/obj/item/botany/tool
	name = "A real botany tool master item"
	desc = "I swear I'm not deteriorating. Anyway, master item, should not be in game, blah blah."
	desc_lore = "Botany requires a light touch and so the tools used in the pruning, raking, cutting and otherwise caring for plants made on the PST reflect this by typically being smaller, lighter and generally more precision oriented than their 'big' counterparts. Like everything related to the cycle of botany on board the PST, these tools were also co-designed by the Harvest Star Conglomerate."
	icon = 'icons/sectorpatrol/botany/items/prep_items.dmi'
	icon_state = "default"
	var/botany_aftercare_type = "default"

/obj/item/botany/tool/proc/use_fx(tool_type = null)
	if(tool_type == null) return
	var/tool_used = tool_type
	switch(tool_used)
		if("rake")
			to_chat(usr, SPAN_INFO("You rake though the biomass in the tray, removing visibly clumped pieces and discarding them. The plant seems to get quickly healthier."))
			playsound(src, 'sound/effects/vegetation_walk_0.ogg')
			return

/obj/structure/botany/tray
	name = "Botany Tray Master Item"
	desc = "This is a general item that hides all the botany mechanics in-code. It should not be in the game."
	desc_lore = "This will be redundant soon and I shoudnt really be doing this anymore. The lore_desc, not the master item."
	icon = 'icons/sp_default.dmi'
	icon_state = "default"
	langchat_color = "#52f35a"
	var/plant_icon = 'icons/sectorpatrol/botany/plants.dmi'
	var/list/botany_tray = list(
		"plant_type" = "empty",
		"fertilizer" = "empty",
		"additional" = "empty",
		"cycle" = 0,
		"loud" = 1,
		)
	var/list/botany_factors = list(
		"yield" = 0,
		"quality" = 0,
		"additive" = "none",
		"aftercare" = "none",
		"cycle_time" = 200,
		)

/obj/structure/botany/tray/update_icon()
	overlays = null
	overlays += image(icon, src, "[icon_state]")
	if(botany_tray["plant_type"] != "empty")overlays += image(plant_icon, src, "[icon_state]_grow[botany_tray["cycle"]]")

/obj/structure/botany/tray/proc/botany_process_growth()
	switch(botany_tray["cycle"])
		if (1)
			update_icon()
			if(botany_tray["loud"] == 1) talkas("Rapid growth process started. Please add any fertalizer and additives beofre the first cycle completes.")
			return
		if(2)
			switch(botany_tray["fertilizer"])
				if("XQuality","XRapidGrowth")
					botany_tray["plant_type"] = "spoiled"
					botany_tray["cycle"] = 5
					if(botany_tray["loud"] == 1) talkas("Error. Unexpected reaction to fertalizer detected. Bad proportions expected. Crop lost.")
				if("empty")
					botany_factors["yield"] -= 1
					botany_factors["quality"] -= 1
					botany_factors["cycle_time"] += 100
				if("Quality")
					botany_factors["quality"] += 1
					botany_factors["cycle_time"] += round(0.25 * botany_factors["cycle_time"])
				if("2Quality")
					botany_factors["yield"] -= round(0.75 * botany_factors["yield"])
					botany_factors["quality"] += 2
					botany_factors["cycle_time"] += round(0.5 * botany_factors["cycle_time"])
				if("RapidGrowth")
					botany_factors["yield"] -= round (0.25 * botany_factors["yield"])
					botany_factors["cycle_time"] -= round(0.25 * botany_factors["cycle_time"])
				if("2RapidGrowth")
					botany_factors["yield"] -= round (0.5 * botany_factors["yield"])
					botany_factors["cycle_time"] -= round(0.5 * botany_factors["cycle_time"])
				if("3RapidGrowth")
					botany_factors["yield"] -= round (0.5 * botany_factors["yield"])
					botany_factors["quality"] -= 1
					botany_factors["cycle_time"] -= round(0.75 * botany_factors["cycle_time"])
			botany_tray["fertilizer"] = "empty"
			if(botany_factors["additive"] != botany_tray["additional"])
				botany_factors["yield"] -= 1
				botany_factors["quality"] -= 1
			botany_tray["additional"] = "empty"
		if(3)
			if(botany_tray["loud"] == 1)
				emoteas("Beeps loudly")
				talkas("Entering final growth stages. Aftercare inspection recommended.")
		if(4)
			if(botany_factors["aftercare"] != "none")
				botany_factors["yield"] -= 1
				botany_factors["quality"] -= 1
			talkas("Growth complete. Plant ready for harvest.")
	update_icon()


/obj/structure/botany/tray/proc/botany_cycle_loop()
	while(botany_tray["cycle"] <= 4)
		sleep(botany_factors["cycle_time"])
		botany_tray["cycle"] += 1
		botany_process_growth()

/obj/structure/botany/tray/proc/add_component(component_name = null)
	var/component_to_add = component_name
	if (component_to_add == null) return
	switch(component_to_add)
		if("Standard")
			botany_tray["fertilizer"] = "Standard"
			return
		if("Quality")
			if(botany_tray["fertilizer"] == "Quality")
				botany_tray["fertilizer"] = "2Quality"
				return
			if(botany_tray["fertilizer"] == "2Quality")
				botany_tray["fertilizer"] = "XQuality"
				return
			if(botany_tray["fertilizer"] == "XQuality")
				botany_tray["fertilizer"] = "XQuality"
				return
			else
				botany_tray["fertilizer"] = "Quality"
				return
		if("RapidGrowth")
			if(botany_tray["fertilizer"] == "RapidGrowth")
				botany_tray["fertilizer"] = "2RapidGrowth"
				return
			if(botany_tray["fertilizer"] == "2RapidGrowth")
				botany_tray["fertilizer"] = "3RapidGrowth"
				return
			if(botany_tray["fertilizer"] == "3RapidGrowth")
				botany_tray["fertilizer"] = "XRapidGrowth"
				return
			if(botany_tray["fertilizer"] == "XRapidGrowth")
				botany_tray["fertilizer"] = "XRapidGrowth"
				return
			else
				botany_tray["fertilizer"] = "RapidGrowth"
				return
		if("Pesticide")
			botany_tray["additional"] = "Pesticide"
		if("Fungicide")
			botany_tray["additional"] = "Fungicide"
		if("Herbicide")
			botany_tray["additional"] = "Herbicide"

/obj/structure/botany/tray/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/botany/fertilizer))
		var/obj/item/botany/fertilizer/C = W
		if(C.botany_fertilizer_type == null || C.botany_fertilizer_uses < 1)
			to_chat(usr, SPAN_WARNING("The tray buzzes. The container seems to be empty."))
			playsound(src, 'sound/machines/terminal_error.ogg', 25)
			return
		to_chat(src, "You connect the tank to the tray and let it inject a dose of fertilizer.")
		playsound(src, 'sound/effects/spray.ogg', 25)
		add_component(component_name = C.botany_fertilizer_type)
		return

	if(istype(W, /obj/item/botany/additive))
		var/obj/item/botany/additive/C = W
		if(C.botany_additive_type == null || C.botany_additive_uses < 1)
			to_chat(usr, SPAN_WARNING("You push on the trigger but nothing happens."))
			playsound(src, 'sound/machines/terminal_error.ogg', 25)
			return
		to_chat(src, "You spray an even ammount of additive onto the tray.")
		playsound(src, 'sound/effects/spray.ogg', 25)
		add_component(component_name = C.botany_additive_type)
		return

	if(istype(W, /obj/item/botany/seed_packet))
		if(botany_tray["plant_type"] != "empty")
			to_chat(usr, SPAN_WARNING("This tray already has growing in it. To restart it, use a fresh bioturf package on the tray."))
			return
		var/obj/item/botany/seed_packet/P = W
		botany_tray["plant_type"] = P.botany_plant_data["name"]
		botany_factors["yield"] = P.botany_plant_data["yield"]
		botany_factors["additive"] = P.botany_plant_data["additive"]
		botany_factors["aftercare"] = P.botany_plant_data["aftercare"]
		update_icon()
		to_chat(usr, SPAN_INFO("You plant the seeds in the tray."))
		qdel(P)
		return

	if(istype(W, /obj/item/botany/tool))
		var/obj/item/botany/tool/tool = W
		if(botany_tray["plant_type"] == "empty")
			to_chat(usr, SPAN_WARNING("There is nothing growing in this tray."))
			return
		if(botany_factors["aftercare"] != tool.botany_aftercare_type)
			to_chat(usr, SPAN_WARNING("There is no reason to use this tool on this plant right now."))
			return
		if(botany_factors["aftercare"] == tool.botany_aftercare_type)
			tool.use_fx(tool_type = tool.botany_aftercare_type)
			botany_factors["aftercare"] = "none"
			return

/obj/structure/botany/tray/standard

	name = "prototype rapid hydroponics tray"
	desc = "A tray with what looks like a mixture of black, muddy dirt and blue tinted water. A logo depicting multiple wheat stalks and the words 'FEED OUR FAMILIES' can be seen on the side."
	desc_lore = "These trays follow a heavily modified corporate design and have been co-developed with PST Engineers with the help of the Harvest Star Conglomerate, a small group of farming and farming equipment-oriented corporations based in the Neroid Sector. The mixture used in the trays is grown somewhere on the PST and is a special kind of bioorganic compound accelerating plant growth. The water has programmed crystalline structures which can further be additionally programmed by adding fertilizer and other compounds and assists in repairing the plants during their rapid growth."
	icon = 'icons/sectorpatrol/botany/structures/tray.dmi'
	icon_state = "tray"
