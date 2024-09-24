/obj/structure/ship_elements/weapon_store
	name = "Primary weapon storage"
	desc = "A sealed, heavy looking metal hatch."
	desc_lore = "Munitions, explosives, sensitive replacement and other valuable or potentially hazardous but not biohazardous substances are typically stored in secured cargo bays like this one. This model utilizes a set of shelves, robot arms and conveyor belts to move the cargo from within the ship hull and onto the platform, which then lifts the cargo up."
	icon = 'icons/sectorpatrol/ship/cargo_bay.dmi'
	icon_state = "cargo_bay_closed"
	var/current_items = 40
	var/items_max = 40
	var/stored_ammo_path
	var/stored_ammo_type
	var/repair_shutdown = 0
	var/ship_name
	var/bay_number = 1

/obj/structure/ship_elements/weapon_store/proc/AnimateUse(state = null)
	var/state_to_animate = state
	if(state_to_animate == null)
		switch(icon_state)
			if("cargo_bay_open")
				state_to_animate = "close"
			if("cargo_bay_closed")
				state_to_animate = "open"
	switch(state_to_animate)
		if("open")
			icon_state = "cargo_bay_opening"
			update_icon()
			sleep(40)
			icon_state = "cargo_bay_open"
			update_icon()
		if("close")
			icon_state = "cargo_bay_closing"
			update_icon()
			sleep(12)
			icon_state = "cargo_bay_closed"
			update_icon()

/obj/structure/ship_elements/weapon_store/proc/DispenseObject(object_to_dispense as obj)
	if(object_to_dispense == null) return
	AnimateUse(state = "open")
	new object_to_dispense(get_turf(src))
	sleep(50)
	AnimateUse(state = "close")
	return 1

/obj/structure/ship_elements/weapon_store/proc/RecieveObject(object_to_recieve as obj)
	if(object_to_recieve == null) return
	var/obj/recieved_object = object_to_recieve
	overlays += image(recieved_object.icon,src,recieved_object.icon_state, recieved_object.layer)
	qdel(recieved_object)
	AnimateUse(state = "open")
	sleep(20)
	overlays.Cut()
	AnimateUse(state = "close")
	return 1

/obj/structure/ship_elements/weapon_store/attackby(obj/item/W, mob/user)
	if(repair_shutdown == 1)
		to_chat(usr, SPAN_WARNING("An emergency shutdown is in effect and this bay is inoperable."))
		return
	if(istype(W, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = W
		if(!PC.linked_powerloader)
			qdel(PC)
			return
		if(PC.loaded)
			if(!istype(PC.loaded, /obj/structure/ship_elements/missile_ammo))
				to_chat(user, SPAN_WARNING("There is no way you can put \the [PC.loaded] into \the [src]!"))
				return
			else
				if(current_items >= items_max)
					to_chat(usr, SPAN_WARNING("This storage bay is full!"))
					return
				var/obj/structure/ship_elements/missile_ammo/ammo_to_take = PC.loaded
				if(ammo_to_take.missile_type == stored_ammo_type || ammo_to_take.warhead_type == stored_ammo_type)
					to_chat(usr, SPAN_INFO("A platform extends from the bay and you deposit the [PC.loaded] there."))
					RecieveObject(PC.loaded)
					current_items += 1
				else
					to_chat(usr, SPAN_WARNING("This bay does not accept that kind of ammo!"))
		else
			if(current_items == 0)
				to_chat(usr, SPAN_WARNING("This bay is empty."))
				return
			if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return
			to_chat(usr, SPAN_INFO("You stop the walker on a pressure plate in front of the dispenser."))
			DispenseObject(stored_ammo_path)
			current_items -= 1
	else
		to_chat(usr, SPAN_WARNING("The pressure plates in the bays respond only to the weight of crewed walkers."))
		return
