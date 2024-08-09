//Botany - treatment items - wall mounted refilling tools an dcontainers for thereof, mechanics for refilling

/obj/item/botany/fertilizer
	name = "OV-PST bioturf storage device"
	desc = "A metal cylinder, smooth to the touch. Has a visible port at its bottom."
	desc_lore = "Like the trays they fit into, these containers follow a heavily modified corporate design and have been co-developed with PST Engineers with the help of the Harvest Star Conglomerate, a small group of farming and farming equipment-oriented corporations based in the Neroid Sector. The mixture transported in the container is grown somewhere on the PST and is a special kind of bioorganic compound accelerating plant growth. Water is also present, with programmed crystalline structures which can further be additionally programmed by adding fertilizer and other compounds and assists in repairing the plants during their rapid growth."
	icon = 'icons/sectorpatrol/botany/items/prep_items.dmi'
	icon_state = "fertilizer_tank_empty"
	var/botany_fertilizer_type
	var/botany_fertilizer_uses = 0
	var/botany_fertilizer_uses_max = 20

/obj/item/botany/fertilizer/update_icon()
	if(botany_fertilizer_uses < (0.25 * botany_fertilizer_uses_max) && botany_fertilizer_uses > 1)
		icon_state = "fertilizer_tank_low"
	if(botany_fertilizer_uses < 1)
		icon_state = "fertilizer_tank_empty"
	else
		icon_state = "fertilizer_tank_full"
	. = ..()


/obj/structure/botany/fertilizer_refill
	name = "wall mounted biomass dispenser"
	desc = "A wall mounted device with several tanks of green tinted, swirling liquid. A logo depicting multiple wheat stalks and the words 'FEED OUR FAMILIES' can be seen on the side."
	desc_lore = "Co-designed with the Harvest Star Conglomerate who are hoping to make the process more universal, these dispensers act as the final stage in a complex system of utilizing modified 3d printers to 'print' simple lifeforms akin to parasites which then process organic matter in desired ways. The term 'fertilizer' used to describe these swarms is mostly a colloquial holdover from more 'traditional' forms for fertilizing which this technology hopes to supplant."
	icon = 'icons/sectorpatrol/botany/structures/vendor.dmi'
	icon_state = "fertilizer"

/obj/structure/botany/fertilizer_refill/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/botany/fertilizer))
		var/obj/item/botany/fertilizer/C = W
		var/picked_fertilizer = tgui_input_list(usr, "The canister clicks as you connect it to the device. Select which fertilizer to fill it with.", "Select fertilizer", list("Standard", "Quality", "Rapid Growth"))
		to_chat(usr, SPAN_INFO("The dispenser recycles any leftover mass in the tank and refills it with the selected fertilizer."))
		playsound(src, 'sound/effects/spray.ogg', 25)
		C.botany_fertilizer_uses = C.botany_fertilizer_uses_max
		switch(picked_fertilizer)
			if("Standard")
				C.botany_fertilizer_type = "Standard"
			if("Quality")
				C.botany_fertilizer_type = "Quality"
			if("Rapid Growth")
				C.botany_fertilizer_type = "RapidGrowth"
		C.update_icon()
		return
	return

/obj/item/botany/additive
	name = "spray bottle"
	desc = "A small container with a top suitable for dispersal after pushing a button."
	desc_lore = "The only real improvements OV-PST manufactured dispersal containers have over their regular counter part is that they come with a standardized, preset trigger which precisely controls how much liquid is dispensed per pump. This may be particularly useful in tasks that require specific liquid concentrations."
	icon = 'icons/sectorpatrol/botany/items/prep_items.dmi'
	icon_state = "add_tank_empty"
	var/botany_additive_type
	var/botany_additive_uses = 0
	var/botany_additive_uses_max = 20

/obj/item/botany/additive/update_icon()
	if(botany_additive_uses < (0.25 * botany_additive_uses_max) && botany_additive_uses > 1)
		icon_state = "add_tank_empty"
	if(botany_additive_uses < 1)
		icon_state = "add_tank_low"
	else
		icon_state = "add_tank_full"
	. = ..()

/obj/structure/botany/additive_refill
	name = "wall mounted additive dispenser"
	desc = "A wall mounted dispneser with a nozzle that can be used to secure a spray bottle to it."
	desc_lore = "Unlike their biomass counterparts, there really isn’t that much to be said about various forms of pest control that can be acquired from this machine. One thing to keep in mind is that additives tend to react unexpectedly when used combined with excessive fertilizer boosting, potentially creating unique plant strains."
	icon = 'icons/sectorpatrol/botany/structures/vendor.dmi'
	icon_state = "additional"

/obj/structure/botany/additive_refill/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/botany/additive))
		var/obj/item/botany/additive/C = W
		var/picked_additive = tgui_input_list(usr, "You attach the bottle to the dispensers nozzle. Select which additive to fill it with.", "Select fertilizer", list("Pesticide", "Fungicide", "Herbicide"))
		to_chat(usr, SPAN_INFO("The dispenser recycles any leftover liquid and refills the bottle with the new contents."))
		playsound(src, 'sound/effects/spray.ogg', 25)
		C.botany_additive_uses = C.botany_additive_uses_max
		switch(picked_additive)
			if("Pesticide")
				C.botany_additive_type = "Pesticide"
			if("Fungicide")
				C.botany_additive_type = "Fungicide"
			if("Herbicide")
				C.botany_additive_type = "Herbicide"
		C.update_icon()
		return
	return

/obj/item/botany/bioturf_refill
	name = "OV-PST bioturf refill bag"
	desc = "A green bag made from a tough, airtight material. Has a prominent logo showing several wheat stalks printed in its center.."
	desc_lore = "PST Bioturf is a mixture of pretreated dirt mixed with water with programmed LD crystalline structures and housing a colony of lifeforms printed in one of the PST's 'biogenerators', essentially 3d printers capable of creating simple organisms. These lifeforms interface with instructions in seed packets, and fertilizer treatments and utilize the PST's latent energy streams to drastically increase the speed a plant is cultivated in. Both the PST Engineers and the corporate scientists working on this project see this solution as a way of making each and every colony in the Neroid Sector and through it in the known galaxy truly self sufficient and free from exploitation when it comes to feeding its inhabitants."
	icon = 'icons/sectorpatrol/botany/items/prep_items.dmi'
	icon_state = "bioturf_bag"
