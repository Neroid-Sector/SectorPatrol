//Crafting items - everything pickupable

/obj/structure/crafting/

	name = "crafting master structure"
	desc = "Hi! I should not be in game."
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "default"
	var/variant_id //For referring unique icon/ccolor variants to transfer

//packages

/obj/structure/crafting/packages/
	name = "package"
	icon_state = "package_xl"
	desc = "Brown packaging in the shape of a box. If just looked at, seems like cardboard, but when touched, one would see that it seems way more rigid and seems to be in fact some sort of resin.  Seems like it would be easy to break open, but the process would clearly be one way. A label is visible on one of its corners."
	desc_lore = "The Northern Republic Production Standard not only dictates screw hole sizes and tube lengths, but also regulates both packaging and labeling of anything adhering to the standard when it is produced. Essentially this means that every NRPS standard complaint wrapping is made of the same brownish artificial resin, meant to be a combination of cardboard and Styrofoam, and always comes with a label oriented towards the bottom-right hand corner of the package. Essentially this means that if you can read the letters, the package is likely upright."
	opacity = FALSE
	density = TRUE

/obj/structure/crafting/packages/table
	icon_state = "package_xl"
	item_serial = "NRPS COMPLIANT<hr>ALL-PURPOSE TABLE, SQUARE, BLACK, ONE<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_STRUCTURE_SIZE_FAR
	variant_id = "default"

/obj/structure/crafting/packages/table/attack_hand(mob/user)
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		new /obj/item/crafting/frame_elements/table(get_turf(src))
		new /obj/item/crafting/top/table(get_turf(src))
		qdel(src)
		return

/obj/structure/crafting/packages/bed
	icon_state = "package_long"
	item_serial = "NRPS COMPLIANT<hr>PLAIN BED AND EXPANDING MATTRESS PACKAGE, COMES WITH ONE (1) STANDARD BED SHEET<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_STRUCTURE_SIZE_FAR
	variant_id = "default"

/obj/structure/crafting/packages/bed/attack_hand(mob/user)
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		new /obj/item/crafting/frame_elements/bed(get_turf(src))
		new /obj/item/crafting/top/bed(get_turf(src))
		qdel(src)
		return


/obj/structure/crafting/packages/dormstruts
	icon_state = "package_long"
	item_serial = "NRPS COMPLIANT<hr>MODULAR FLOOR STRUT x60<br>MODULAR FLOOR TILE x60<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_STRUCTURE_SIZE_FAR
	variant_id = "default"

/obj/structure/crafting/packages/dormstruts/attack_hand(mob/user)
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		var/obj/item/stack/rods/floorstrut/strut1 = new(get_turf(src))
		var/obj/item/stack/rods/floorstrut/strut2 = new(get_turf(src))
		var/obj/item/stack/modulartiles/tile1 = new(get_turf(src))
		var/obj/item/stack/modulartiles/tile2 = new(get_turf(src))
		strut1.amount = 30
		strut1.update_icon()
		strut2.amount = 30
		strut2.update_icon()
		tile1.amount = 30
		tile1.update_icon()
		tile2.amount = 30
		tile2.update_icon()
		qdel(src)
		return
//frames

/obj/structure/crafting/frame/
	name = "structure frame master object"
	icon_state = "default"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands."
	anchored = 0
	var/crafting_top_ready = FALSE

/obj/structure/crafting/frame/table
	name = "table frame"
	desc = "A set of metal rods in two distinct lengths, put together to form a table frame and secured by a set of screws."
	icon_state = "table_metal_frame"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Once assembled, table frames need a top, which then should be secured using a wrench. The table can be disassembled using a screwdriver as well."

/obj/structure/crafting/frame/table/attack_hand(mob/user)
	if(crafting_top_ready == TRUE)
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] lifts a table top of its frame."), SPAN_INFO("You lift a table top of its frame."))
			if(do_after(user, (CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				switch(icon_state)
					if("table_metal_black")
						var/obj/item/crafting/top/table/tabletop = new(get_turf(user))
						user.put_in_active_hand(tabletop)
					if("table_metal_gray")
						var/obj/item/crafting/top/table/gray/tabletop = new(get_turf(user))
						user.put_in_active_hand(tabletop)
				name = "table frame"
				icon_state = "table_metal_frame"
				desc = "A set of metal rods in two distinct lengths, put together to form a table frame and secured by a set of screws."
				crafting_top_ready = FALSE
				anchored = 0
				return
	return


/obj/structure/crafting/frame/table/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/table/))
		var/obj/item/crafting/top/table/W = C
		user.visible_message(SPAN_NOTICE("[user] starts starts to align a table top with a frame."), SPAN_INFO("You start to to align a table top with a frame."))
		if(do_after(user, (CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			switch(W.variant_id)
				if("default")
					icon_state = "table_metal_black"
				if("gray")
					icon_state = "table_metal_gray"
			name = "table frame with an aligned top"
			desc = "A set of metal rods in two distinct lengths, put together to form a table frame and secured by a set of screws. A table top is aligned with the frame."
			crafting_top_ready = TRUE
			anchored = 1
			qdel(W)
			return

	if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
		if(crafting_top_ready == TRUE)
			user.visible_message(SPAN_NOTICE("[user] tightens the screws attaching the table top to its frame."), SPAN_INFO("You tighten the screws attaching the table top to its frame."), SPAN_DANGER("You hear metal scratch against metal."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				switch(icon_state)
					if("table_metal_black")
						new /obj/structure/surface/modular/table(get_turf(src))
						qdel(src)
						return
					if("table_metal_gray")
						new /obj/structure/surface/modular/table/gray(get_turf(src))
						qdel(src)
						return

	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		if(crafting_top_ready == TRUE)
			to_chat(usr, SPAN_NOTICE("Remove the top before disassembling the frame. To remove the top, click the frame with an empty hand in GRAB mode."))
			return
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] starts to disassemble the frame."), SPAN_INFO("You start to disassemble the frame."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				var/obj/item/crafting/frame_elements/table/elements = new(get_turf(usr))
				elements.variant_id = variant_id
				qdel(src)
				return

	to_chat(usr, SPAN_NOTICE("You don't seem to be able to use this at the moment. Place a table top before trying to tighten the screws or use a screwdriver in GRAB mode to disassemble the frame."))
	return


/obj/structure/crafting/frame/bed
	name = "bed frame"
	desc = "Four metal bards and supporting rods, put together into a bed frame. Held together by a series of screws."
	icon_state = "bed_frame"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Once assembled, bed frames are ready for an expandable mattress and don't require any further tinkering. A screwdriver can be used to take the frame apart again."

/obj/structure/crafting/frame/bed/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/bed))
		var/obj/item/crafting/top/bed/top = C
		user.visible_message(SPAN_NOTICE("[user] places a bag in the middle of the frame and pushes a button on the side."), SPAN_INFO("You place a bag in the middle of the frame and push a button on the side."))
		if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/bed/modular/bed = new(get_turf(src))
			bed.crafting_bed_bedsheet_id = top.variant_id
			bed.variant_id = variant_id
			qdel(top)
			qdel(src)
			return

	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] starts to disassemble the frame."), SPAN_INFO("You start to disassemble the frame."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				var/obj/item/crafting/frame_elements/bed/B = C
				B.variant_id = variant_id
				qdel(src)
				return

	to_chat(SPAN_INFO("You cannot seem to combine these together. Use an inflatable matress to finish assembling the frame, or use a screwdriver in GRAB intent to disassemble the frame into its basic elements."))
	return

/obj/structure/crafting/frame/drawers
	name = "cabinet frame"
	desc = "Several sheets of metal snapped together along the edges using a series of premade hooks and holes."
	icon_state = "drawer_frame"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Once assembled, cabinet frames need a set of drawers that clip onto inlaid tracks and don't require any additional tinkering. A crowbar can be used to wedge the elements apart."

/obj/structure/crafting/frame/drawers/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/drawers))
		var/obj/item/crafting/top/drawers/D = C
		user.visible_message(SPAN_NOTICE("[user] slides metal drawers into the cabinet frame."), SPAN_INFO("You slide metal drawers into the cabinet frame."), SPAN_WARNING("You hear metal sliding against metal."))
		if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/closet/modular/drawers/O = new(get_turf(src))
			O.crafting_drawer_color = D.variant_id
			O.variant_id = variant_id
			qdel(D)
			qdel(src)
			return

	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		if (user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] starts to detach elements of a cabinet frame from each other."), SPAN_INFO("You start to detach elements of a cabinet frame from each other."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				var/obj/item/crafting/frame_elements/drawers/frame = new(get_turf(src))
				frame.variant_id = variant_id
				qdel(src)
				return

	to_chat(user, SPAN_INFO("You cannot seem to combine these together. Insert drawers to finish assembling the frame, or use a crowbar in GRAB intent to disassemble the frame into its basic elements."))
	return

/obj/structure/crafting/frame/chair
	name = "office chair base with wheels"
	desc = "An office chair with four 'legs', each one has a colored wheel at its tip."
	var/crafting_chair_wheel_id = "default"
	var/crafting_chair_wheels = 4
	icon_state = "chair_base_wheels"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Once the wheels are secured, office chairs need a seat attached and then tightened with a wrench. The wheels can be removed with just your hands."

/obj/structure/crafting/frame/chair/attack_hand(mob/user)
	if(user.a_intent == INTENT_GRAB)
		if(crafting_chair_wheels > 0)
			user.visible_message(SPAN_NOTICE("[user] starts to twist the wheels out of the chair frame."), SPAN_INFO("You start to twist the wheels out of the chair frame."), SPAN_WARNING("You a series of pops."))
			while(crafting_chair_wheels > 0)
				if(do_after(user, (CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					crafting_chair_wheels -= 1
					if(crafting_chair_wheels == 0)
						var/obj/item/crafting/top/chair/wheels/wheels = new(get_turf(usr))
						var/obj/item/crafting/frame_elements/chair/frame = new(get_turf(usr))
						wheels.variant_id = crafting_chair_wheel_id
						user.put_in_hands(wheels)
						frame.variant_id = variant_id
						user.put_in_hands(frame)
						qdel(src)
			return
	return

/obj/structure/crafting/frame/chair/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/chair/seat/))
		var/obj/structure/crafting/frame/chair/W = C
		user.visible_message(SPAN_NOTICE("[user] pushes a chair seat and backrest onto a chair frame."), SPAN_INFO("You push a chair seat and backrest onto a chair frame."), SPAN_WARNING("You hear a metallic thud."))
		if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/bed/chair/modular/office/chair = new(get_turf(usr))
			chair.variant_id = variant_id
			chair.crafting_chair_wheel_id = crafting_chair_wheel_id
			chair.crafting_chair_top_id = W.variant_id
			qdel(src)
			qdel(W)
			return
	return
