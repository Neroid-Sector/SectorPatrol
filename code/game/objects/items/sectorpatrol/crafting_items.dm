//Crafting items - everything pickupable

/obj/item/crafting/

	name = "crafting master item"
	desc = "Hi! I should not be in game."
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "default"
	var/variant_id = "default" //For referring unique icon/ccolor variants to transfer

//packages

/obj/item/crafting/packages/
	name = "package"
	icon_state = "default"
	desc = "Brown packaging in the shape of a box. If just looked at, seems like cardboard, but when touched, one would see that it seems way more rigid and seems to be in fact some sort of resin.  Seems like it would be easy to break open, but the process would clearly be one way. A label is visible on one of its corners."
	desc_lore = "The Northern Republic Production Standard not only dictates screw hole sizes and tube lengths, but also regulates both packaging and labeling of anything adhering to the standard when it is produced. Essentially this means that every NRPS standard complaint wrapping is made of the same brownish artificial resin, meant to be a combination of cardboard and Styrofoam, and always comes with a label oriented towards the bottom-right hand corner of the package. Essentially this means that if you can read the letters, the package is likely upright."

/obj/item/crafting/packages/chair
	icon_state = "package_l"
	w_class = SIZE_LARGE
	item_serial = "NRPS COMPLIANT<hr>OFFICE STYLE CHAIR, BLACK, ONE<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_ITEM_SIZE_FAR

/obj/item/crafting/packages/chair/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		new /obj/item/crafting/frame_elements/chair(get_turf(usr))
		new /obj/item/crafting/top/chair/seat(get_turf(usr))
		new /obj/item/crafting/top/chair/wheels(get_turf(usr))
		qdel(src)
		return

/obj/item/crafting/packages/drawer
	icon_state = "package_l"
	w_class = SIZE_LARGE
	item_serial = "NRPS COMPLIANT<hr>DRAWER CHEST, BLACK, ONE<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_ITEM_SIZE_FAR

/obj/item/crafting/packages/drawer/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		new /obj/item/crafting/frame_elements/drawers(get_turf(usr))
		new /obj/item/crafting/top/drawers(get_turf(usr))
		qdel(src)
		return


/obj/item/crafting/packages/lamp
	icon_state = "package_m"
	w_class = SIZE_MEDIUM
	item_serial = "NRPS COMPLIANT<hr>DESK LAMP, BLACK, ONE<hr>UACM OUTER VEIL PST"
	item_serial_distance = SERIAL_ITEM_SIZE_MEDIUM

/obj/item/crafting/packages/lamp/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[user] starts to unwrap a package."), SPAN_INFO("You start to unwrap the pacckage."), SPAN_DANGER("You hear tearing sounds."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] tears through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_INFO("You tear through the package, revealing its contents. Once ripped, the packing material quickly turns to a fine dust."), SPAN_DANGER("The ripping stops."))
		new /obj/item/crafting/frame/lamp(get_turf(usr))
		new /obj/item/crafting/top/lamp/base(get_turf(usr))
		new /obj/item/crafting/top/lamp/bulb(get_turf(usr))
		qdel(src)
		return


// Frames

/obj/item/crafting/frame/
	name = "item frame master object"
	icon_state = "default"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands."

/obj/item/crafting/frame/lamp
	name = "desk lamp frame"
	desc = "A weighted metal plate with a slot."
	icon_state = "lamp_base"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Lamp frames do not need any assembly and are ready for their tops out of the box."
	var/crafting_lamp_top_color

/obj/item/crafting/frame/lamp/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/lamp/base))
		if(icon_state == "lamp_base")
			var/obj/item/crafting/top/lamp/base/D = C
			user.visible_message(SPAN_NOTICE("[user] starts to attach a lamp top to its base."), SPAN_INFO("You start to attach a lamp top to its base."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				crafting_lamp_top_color = D.variant_id
				qdel(D)
				icon_state = "lamp"
				update_icon()
				name = "assembled desk lamp"
				desc = "A weighed frame with a curved top attached to it, both made from light resin that resembles metal. The lightbulb is missing."
				desc_lore = "While in a lot of NRPS compliant objects, connecting all tops to their frames means that the assembly is complete, the standard does allow extra steps in this final phase. This typically means either cosmetic touches or electric/electronic assemblies. Now that the frame and tops are secured, screwing in an appropriate desk lamp light bulb will complete the assembly."
				return
		if(icon_state == "lamp")
			to_chat(user, SPAN_NOTICE("A top is already attached. Insert a desk lamp light bulb next."))
			return

	if(istype(C, /obj/item/crafting/top/lamp/bulb))
		if(icon_state == "lamp")
			var/obj/item/crafting/top/lamp/bulb/bulb = C
			user.visible_message(SPAN_NOTICE("[user] starts to screw a light bulb into the desk lamp."), SPAN_INFO("You start to screw a light bulb into the desk lamp."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				var/obj/item/device/modular/lamp/lamp = new(get_turf(src))
				lamp.crafting_lamp_top_color = crafting_lamp_top_color
				lamp.crafting_lamp_bulb_color = bulb.crafting_lamp_bulb_color
				lamp.variant_id = variant_id
				qdel(bulb)
				qdel(src)
				return
		if(icon_state == "lamp_base")
			to_chat(user, SPAN_NOTICE("There is no top attached to the frame."))
			return

	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		if(user.a_intent == INTENT_GRAB)
			if(icon_state == "lamp")
				user.visible_message(SPAN_NOTICE("[user] starts to detach a lamp top from its frame."), SPAN_INFO("You start to detach a lamp top from its frame."))
				if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					var/obj/item/crafting/top/lamp/base/top = new(get_turf(src))
					top.variant_id = crafting_lamp_top_color
					user.put_in_hands(top)
					crafting_lamp_top_color = null
					icon_state = "lamp_base"
					update_icon()
					name = "desk lamp frame"
					desc = "A weighted metal plate with a slot."
					desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Lamp frames do not need any assembly and are ready for their tops out of the box."
					return
			if(icon_state == "lamp_base")
				to_chat(user, SPAN_INFO("There is no top attached to this frame."))
				return
	to_chat(usr, SPAN_NOTICE("You cannot seem to combine these together. Use a lamp top or light bulb to finish the assembly, or a screwdriver in GRAB mode to remove a top if one is present."))
	return


// Loose frame parts

/obj/item/crafting/frame_elements
	name = "frame elements master object"
	icon_state = "default"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands."

/obj/item/crafting/frame_elements/table
	name = "table frame elements"
	icon_state = "table_metal_frame_parts"
	desc = "A set of metal rods in two distinct lengths and a set of screws to hold them together."
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Table frame assembly per the Standard begins with assembling the frame with a screwdriver and the provided parts."

/obj/item/crafting/frame_elements/table/attackby(obj/item/C, mob/user)
	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		user.visible_message(SPAN_NOTICE("[user] starts to assemble a frame with a screwdriver."), SPAN_INFO("You start to assemble the frame."), SPAN_DANGER("You hear metal gently brushing against other metal."))
		if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/crafting/frame/table/R = new(get_turf(usr))
			R.variant_id = variant_id
			qdel(src)
			return
	else
		to_chat(usr, SPAN_NOTICE("There does not seem to be any reason to do that. If you are trying to assemble the frame, use a screwdriver."))
		return

/obj/item/crafting/frame_elements/drawers
	name = "carbinet frame elements"
	icon_state = "drawer_frame_parts"
	desc = "Several metal sheets with a set of notches and hooks."
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Cabinet frames can be assembled by hand and don't require any additional tools thanks to the system of hooks and notches. "

/obj/item/crafting/frame_elements/drawers/attack_self(mob/user)
	..()
	user.visible_message(SPAN_NOTICE("[user] starts to assemble a cabinet frame from its components."), SPAN_INFO("You start to assemble a cabinet frame from its components."), SPAN_DANGER("You hear metal gently brushing against other metal."))
	if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		var/obj/structure/crafting/frame/drawers/R = new(get_turf(usr))
		R.variant_id = variant_id
		qdel(src)
		return

/obj/item/crafting/frame_elements/chair
	name = "office chair base"
	icon_state = "chair_base"
	desc = "The base and hydraulics part of an office chair, with a small lever used to control the height of the finished assembly."
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Office chair frames do not need assembly and are ready for their tops. Due to how the seat and back is mounted, the wheels should be attached first."
	var/crafting_chair_wheels = 0

/obj/item/crafting/frame_elements/chair/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/crafting/top/chair/wheels/))
		var/obj/item/crafting/top/chair/wheels/W = C
		user.visible_message(SPAN_NOTICE("[user] starts to attach wheels into a chair frame."), SPAN_INFO("You start to attach wheels into a chair frame."), SPAN_DANGER("You hear gentle popping."))
		while(crafting_chair_wheels < 5)
			if(do_after(user, (CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				crafting_chair_wheels += 1
				if(crafting_chair_wheels == 4)
					user.visible_message(SPAN_NOTICE("[user] finishes attaching wheels to a chair frame and puts the chair down."), SPAN_INFO("You finish attaching wheels to a chair frame and put the chair down."), SPAN_DANGER("You hear a firm tap."))
					var/obj/structure/crafting/frame/chair/R = new(get_turf(usr))
					R.variant_id = variant_id
					R.crafting_chair_wheel_id = W.variant_id
					qdel(src)
					qdel(W)
					return
	else
		to_chat(usr, SPAN_NOTICE("There does not seem to be any reason to do that. If you are trying to assemble the frame, start with the wheels."))
		return

/obj/item/crafting/frame_elements/bed
	name = "bed frame elements"
	icon_state = "bed_frame_parts"
	desc = "Four thick rods and several smaller ones and a set of screws meant to hold them together."
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard must have a detachable base, called a frame. Frames can come in all shapes and sizes, typically need to be assembled first and as close to where the given object resides as possible. Per the NRPS, each individual piece of a frame must be attachable and detachable by using only a screwdriver, which typically means that any assembly utilizing the NRPS comes with screws that are used to assemble the frame or can be assembled with just one's hands. Bed frame assembly per the Standard begins with assembling the frame with a screwdriver and the provided parts."

/obj/item/crafting/frame_elements/bed/attackby(obj/item/C, mob/user)

	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		user.visible_message(SPAN_NOTICE("[user] starts to assemble a frame with a screwdriver."), SPAN_INFO("You start to assemble the frame."), SPAN_DANGER("You hear metal gently brushing against other metal."))
		if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/crafting/frame/bed/R = new(get_turf(usr))
			R.variant_id = variant_id
			qdel(src)
			return
	else
		to_chat(usr, SPAN_NOTICE("There does not seem to be any reason to do that. If you are trying to assemble the frame, use a screwdriver."))
		return


// Top components

/obj/item/crafting/top/
	name = "top master object"
	icon_state = "default"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard comes with a set of one or more components that attach to their respective frames. These elements are called 'tops' and typically are meant to be both highly modular and highly customizable. The NRPS does not care too much about aesthetics (except where they influence assembly) and there is a fair share of bigger and smaller companies out in the galaxy that make their living by producing unique, personalized top parts for NRPS compliant items. Tops are meant to come with no additional assembly parts, everything needed to attach one to its frame should already be present on the frame itself after assembly. "

/obj/item/crafting/top/table
	name = "black table top"
	desc = "Made from light weight resins but printed to look and feel like painted wood. Cool to the touch. Comes with a set of slots at one side."
	icon_state = "table_top_black"
/obj/item/crafting/top/table/gray
	name = "gray table top"
	icon_state = "table_top_gray"
	variant_id = "gray"

/obj/item/crafting/top/lamp/base
	name = "black lamp top"
	desc = "A curved, resin frame made to look and feel like metal, with a small electrical assembly on one end and a hook on the other."
	icon_state = "lamp_top"

/obj/item/crafting/top/lamp/bulb
	name = "desk lamp bulb"
	desc = "A small light bulb, too small for any wall or floor fixture."
	icon_state = "lamp_bulb"
	var/crafting_lamp_bulb_color = LIGHT_COLOR_WHITE

/obj/item/crafting/top/bed
	name = "compressed white mattress"
	desc = "A sealed, very stretchy container with a white, foamy liquid inside. A light and a button are visible on the side."
	icon_state = "bed_matress"
	desc_lore = "Any object produced in adherence to the Northern Republic Production Standard comes with a set of one or more components that attach to their respective frames. These elements are called 'tops' and typically are meant to be both highly modular and highly customizable. The NRPS does not care too much about aesthetics (except where they influence assembly) and there is a fair share of bigger and smaller companies out in the galaxy that make their living by producing unique, personalized top parts for NRPS compliant items. Tops are meant to come with no additional assembly parts, everything needed to attach one to its frame should already be present on the frame itself after assembly.<br><br>While formally called a mattress, these tops have little to do with what is considered one on Earth. Released in the Northern Republic and immediately appended into the NRPS, these stretchy, rubber like bags are filled with a foamy side product of smoke suppression systems research. When exposed to impact, a reaction within the liquid makes it rapidly expand into a thick, uniform substance which is generally considered extremely comfortable to rest on. Once set, the substance can be liquified again by sending a high enough electric charge through it, typically achieved by plugging in a multitool to the side of the mattress. "

/obj/item/crafting/top/chair/seat
	name = "black office chair seat"
	desc = "A black seat connected to a backrest by a metal rod that also lets the backrest tilt depending on how much pressure is applied to it. A big slot and a small handle is visible on the bottom."
	icon_state = "chair_top"

/obj/item/crafting/top/chair/wheels
	name = "black office chair wheels"
	desc = "A set of small wheels with small, notched metal rods sticking out of their frames. "
	icon_state = "chair_wheels"

/obj/item/crafting/top/drawers
	name = "black cabinet drawers"
	desc = "Two slide-in cabinet drawers with grooves etched on the side."
	icon_state = "drawer_drawers"
