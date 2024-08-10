/obj/structure/ship_elements/cargo_bay
	name = "cargo bay hatch"
	desc = "A sealed, heavy looking metal hatch."
	desc_lore = "Munitions, explosives, sensitive replacement and other valuable or potentially hazardous but not biohazardous substances are typically stored in secured cargo bays like this one. This model utilizes a set of shelves, robot arms and conveyor belts to move the cargo from within the ship hull and onto the platform, which then lifts the cargo up."
	icon = 'icons/sectorpatrol/ship/cargo_bay.dmi'
	icon_state = "cargo_bay_closed"
	var/bay_id = "default"
	var/ship_name = "none"
	var/obj/structure/terminal/cargo_console/linked_cargo_console

/obj/structure/ship_elements/cargo_bay/proc/AnimateUse()
	switch(icon_state)
		if("cargo_bay_closed")
			icon_state = "cargo_bay_opening"
			update_icon()
			sleep(40)
			icon_state = "cargo_bay_open"
			update_icon()
		if("cargo_bay_open")
			icon_state = "cargo_bay_closing"
			update_icon()
			sleep(12)
			icon_state = "cargo_bay_closed"
			update_icon()

/obj/structure/ship_elements/cargo_bay/proc/DispenseObject(object_to_dispense as obj)
	AnimateUse()
	new object_to_dispense(get_turf(src))
	sleep(100)
	AnimateUse()
