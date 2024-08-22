/obj/structure/ship_elements/cargo_bay
	name = "cargo bay hatch"
	desc = "A sealed, heavy looking metal hatch."
	desc_lore = "Munitions, explosives, sensitive replacement and other valuable or potentially hazardous but not biohazardous substances are typically stored in secured cargo bays like this one. This model utilizes a set of shelves, robot arms and conveyor belts to move the cargo from within the ship hull and onto the platform, which then lifts the cargo up."
	icon = 'icons/sectorpatrol/ship/cargo_bay.dmi'
	icon_state = "cargo_bay_closed"
	var/bay_id = "default"
	var/ship_name = "none"
	var/repair_shutdown = 0
	var/list/accepted_types = list()
	var/list/cargo_data

/obj/structure/ship_elements/cargo_bay/proc/AnimateUse(state = null)
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

/obj/structure/ship_elements/cargo_bay/proc/CheckObject(incoming_icon_state = null)
	var/icon_state_to_check = incoming_icon_state
	if (icon_state_to_check == null) return
	if (accepted_types.Find(icon_state_to_check) != 0) return 1
	else return 0

/obj/structure/ship_elements/cargo_bay/proc/DispenseObject(object_to_dispense as obj)
	if(object_to_dispense == null) return
	AnimateUse(state = "open")
	new object_to_dispense(get_turf(src))
	sleep(50)
	AnimateUse(state = "close")
	return 1

/obj/structure/ship_elements/cargo_bay/proc/RecieveObject(object_to_recieve as obj)
	if(object_to_recieve == null) return
	var/obj/recieved_object = object_to_recieve
	overlays += image(recieved_object.icon,src,recieved_object.icon_state, recieved_object.layer)
	qdel(recieved_object)
	AnimateUse(state = "open")
	sleep(20)
	overlays.Cut()
	AnimateUse(state = "close")
	return 1

/obj/structure/ship_elements/cargo_bay/attackby(obj/item/W, mob/user)
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
				if(CheckObject(incoming_icon_state = PC.loaded.icon_state) == 1)
					cargo_data[PC.loaded.icon_state] += 1
					to_chat(user, SPAN_INFO("The cargo bay accepts the [PC.loaded] and starts the storage procedure."))
					RecieveObject(object_to_recieve = PC.loaded)
					return
				if(CheckObject(incoming_icon_state = PC.loaded.icon_state) == 0)
					to_chat(user, SPAN_WARNING("This bay does not accept cargo of this type. Consult the cargo terminal for bay information."))
					return
	if(istype(W, /obj/item/ship_elements/secondary_ammo/))
		var/obj/item/ship_elements/secondary_ammo/ammo_to_deposit
		if(CheckObject(incoming_icon_state = ammo_to_deposit.icon_state) == 1)
			cargo_data[ammo_to_deposit.icon_state] += 1
			to_chat(user, SPAN_INFO("The cargo bay accepts the [ammo_to_deposit] and starts the storage procedure."))
			RecieveObject(object_to_recieve = ammo_to_deposit)
			return
		if(CheckObject(incoming_icon_state = ammo_to_deposit.icon_state) == 0)
			to_chat(user, SPAN_WARNING("This bay does not accept cargo of this type. Consult the cargo terminal for bay information."))
			return

/obj/structure/ship_elements/cargo_bay/primary_munitions
	name = "Primary Munitions cargo bay"
	bay_id = "primary_munitions"
	accepted_types = list("missile_pst_homing","missile_pst_dumbfire","missile_pst_torpedo","warhead_direct","warhead_explosive","warhead_mip")
	cargo_data = list(
		"missile_pst_homing" = 0,
		"missile_pst_dumbfire" = 0,
		"missile_pst_torpedo" = 0,
		"warhead_direct" = 0,
		"warhead_explosive" = 0,
		"warhead_mip" = 0,
		)

/obj/structure/ship_elements/cargo_bay/secondary_munitions
	name = "Secondary Munitions cargo bay"
	bay_id = "secondary_munitions"
	accepted_types = list("secondary_direct","secondary_flak","secondary_broadside",)
	cargo_data = list(
		"secondary_direct" = 0,
		"secondary_flak" = 0,
		"secondary_broadside" = 0,
		"probe" = 0,
		"tracker" = 0,
		)

/obj/structure/ship_elements/cargo_bay/secondary_munitions/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/ship_probe))
		cargo_data["probe"] += 1
		to_chat(user, SPAN_INFO("The cargo bay accepts the [W] and starts the storage procedure."))
		RecieveObject(W)
		return
	if(istype(W, /obj/item/ship_tracker))
		cargo_data["tracker"] += 1
		to_chat(user, SPAN_INFO("The cargo bay accepts the [W] and starts the storage procedure."))
		RecieveObject(W)
		return
