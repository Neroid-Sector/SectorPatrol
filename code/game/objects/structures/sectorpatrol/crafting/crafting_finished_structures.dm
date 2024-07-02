//Table

/obj/structure/surface/modular/table
	name = "table"
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "table_metal_black"
	desc = "A tabletop attached to a frame with a set of screws. The top is made to look like wood, but on closer inspection is clearly artificial. Can be used to put things on top of, believe it or not."
	desc_lore = "Tables are, well, tables. Any time a human and sometimes non-human needs a place to put things, point at things, nap, sleep, drink, eat on, eat off, hit in anger, throw at enemies, play cards on and many, many, MANY other uses, tables are the devices of choice. Out in space, tables are used as often and in as many applications as they are back on Earth and will likely continue doing so in the foreseeable future. "
	var/variant_id = "default"
	anchored = 1
	opacity = FALSE
	density = TRUE
	PersistantObject = TRUE

/obj/structure/surface/modular/table/attackby(obj/item/C, mob/user)

	if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] loosens the screws attaching the table top to its frame."), SPAN_INFO("You loosen the screws attaching the table top to its frame."), SPAN_DANGER("You hear metal scratch against metal."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src, soundin = 'sound/items/Screwdriver.ogg', vol = 25, vary = 1)
				var/obj/structure/crafting/frame/table/frame = new(get_turf(src))
				frame.icon_state = icon_state
				frame.variant_id = variant_id
				frame.crafting_top_ready = TRUE
				qdel(src)
				return
	..()

/obj/structure/surface/modular/table/attack_hand(mob/user)
	. = ..()
	if(usr.a_intent == INTENT_DISARM)
		if(do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] flips a lever near one of the legs of the table, detaching it from the floor."), SPAN_INFO ("You flip a lever near one of the legs of the table, detaching it from the floor."))
			anchored = !anchored

/obj/structure/surface/modular/table/gray
	icon_state = "table_metal_gray"
	variant_id = "gray"

//Bed
/obj/structure/bed/modular/
	name = "bed"
	desc = "A metal frame supporting an expanding foam mattress and a pillow."
	desc_lore = "Beds, like chairs, tend to be one of the most customized items on board human spaceships. From decorative arts to whole customized frames and patterned mattress covers, to hand woven, non-replicated bedsheets. Personal space can be a signifier of status and most out in the galaxy start with their bed itself."
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "bed"
	var/crafting_bed_bedsheet_id = "default"
	var/variant_id = "default"
	anchored = 1
	opacity = FALSE
	density = TRUE
	PersistantObject = TRUE

/obj/structure/bed/modular/attackby(obj/item/C, mob/user)

	if(istype(C, /obj/item/grab) && !buckled_mob)
		var/obj/item/grab/G = C
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			var/atom/blocker = LinkBlocked(user, user.loc, loc)
			if(blocker)
				to_chat(user, SPAN_WARNING("\The [blocker] is in the way!"))
			else
				to_chat(user, SPAN_NOTICE("You place [M] on [src]."))
				M.forceMove(loc)
		return TRUE

	if(HAS_TRAIT(C, TRAIT_TOOL_MULTITOOL))
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] Attaches the multitool to the port on the side of the mattress. The device beeps."), SPAN_INFO("You attach the multitool to the port on the side of the mattress. The device beeps."), SPAN_DANGER("You hear a soft beep."))
			playsound(src, soundin = 'sound/machines/terminal_select.ogg', vol = 10, vary = 1)
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src, soundin = 'sound/items/air_release.ogg', vol = 25, vary = 1)
				var/obj/structure/crafting/frame/bed/frame = new(get_turf(src))
				frame.variant_id = variant_id
				var/obj/item/crafting/top/bed/top = new(get_turf(src))
				top.variant_id = crafting_bed_bedsheet_id
				qdel(src)
				return
	return

/obj/structure/bed/modular/attack_hand(mob/user)
	. = ..()
	if(usr.a_intent == INTENT_DISARM)
		if(do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(src, soundin = 'sound/items/Screwdriver2.ogg', vol = 25, vary = 1)
			user.visible_message(SPAN_NOTICE("[user] flips a lever near one of the legs of the bed, detaching it from the floor."), SPAN_INFO ("You flip a lever near one of the legs of the bed, detaching it from the floor."))
			anchored = !anchored

/obj/structure/bed/modular/verb/rotate_pillow()
	set category = "Object"
	set name = "Rotate Pillow"
	set src in view(1)

	if(usr.is_mob_incapacitated())
		return

	if(ishuman(usr))
		usr.visible_message(SPAN_NOTICE("[usr] moves the pilow to the other side of the mattress."), SPAN_INFO("You move the pilow to the other side of the mattress."))
		playsound(src, soundin = 'sound/effects/rustle3.ogg', vol = 25, vary = 1)
		if (dir == NORTH)
			dir = SOUTH
		else
			dir = NORTH
		update_icon()
		return

//Desk Lamp

/obj/item/device/modular/lamp
	name = "desk lamp"
	desc = "An assembled frame and base with a lightbulb, ready to illuminate any surface in range."
	desc_lore = "While most crews do what they can to illuminate their ships with power not being an issue thanks to the Twilight Paradox drives, there are places where personal lights such as this one are not only useful but preferred. It’s not uncommon for ship personnel to keep them on both their work and private desks for that extra light when needed."
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "lamp"
	light_range = 5
	light_power = 1
	light_color = COLOR_WHITE
	w_class = SIZE_LARGE
	var/variant_id = "default"
	var/crafting_lamp_bulb_color = COLOR_WHITE
	var/crafting_lamp_top_color = "default"
	var/on = FALSE
	PersistantObject = TRUE

/obj/item/device/modular/lamp/update_icon()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/item/device/modular/lamp/attack_hand(mob/user)
	if(user.a_intent == INTENT_HELP)
		if(!isturf(user.loc))
			to_chat(user, SPAN_WARNING("You cannot turn the light [on ? "off" : "on"] while in [user.loc].")) //To prevent some lighting anomalies.
			return FALSE
		on = !on
		playsound(src, soundin = 'sound/machines/click.ogg', vol = 25, vary = 1)
		set_light_on(on)
		update_icon()
		return TRUE
	if(user.a_intent == INTENT_DISARM)
		user.put_in_active_hand(src)
		return


/obj/item/device/modular/lamp/attackby(obj/item/C, mob/user)
	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		if(on)
			to_chat(user, SPAN_INFO("Turn off the lamp by clicking on it with an empty hand in GRAB mode before removing the bulb."))
			return
		to_chat(user, SPAN_NOTICE("You push down on the release button for the bulb..."))
		if(do_after(user, CRAFTING_DELAY_SHORT, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/item/crafting/frame/lamp/frame = new(get_turf(src))
			playsound(src, soundin = 'sound/items/Screwdriver2.ogg', vol = 25, vary = 1)
			frame.crafting_lamp_top_color = crafting_lamp_top_color
			frame.variant_id = variant_id
			frame.icon_state = "lamp"
			frame.update_icon()
			frame.name = "assembled desk lamp"
			frame.desc = "A weighed base with a curved top attached to it, both made from light resin that resembles metal. The lightbulb is missing."
			frame.desc_lore = "While in a lot of NRPS compliant objects, connecting all tops to their frames means that the assembly is complete, the standard does allow extra steps in this final phase. This typically means either cosmetic touches or electric/electronic assemblies. Now that the base and tops are secured, screwing in an appropriate desk lamp light bulb will complete the assembly."
			var/obj/item/crafting/top/lamp/bulb/bulb = new(get_turf(src))
			bulb.crafting_lamp_bulb_color = crafting_lamp_bulb_color
			user.put_in_active_hand(bulb)
			qdel(src)
			return
	return

//Drawers

/obj/structure/closet/modular/drawers
	name = "drawers"
	desc = "Two drawers mounted in a frame that can be slid in and out."
	desc_lore = "Personal storage lockers come in all shapes and sizes, but open drawers such as this one are some of the most common. From clothes to personal effects, the availability and versatility of drawers like these means they are very widely used."
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "drawer"
	icon_closed = "drawer"
	icon_opened = "drawer_open"
	storage_capacity = 15
	store_mobs = FALSE
	anchored = 1
	opacity = FALSE
	density = TRUE
	var/variant_id = "default"
	var/crafting_drawer_color = "default"
	PersistantObject = TRUE

/obj/structure/closet/modular/drawers/attackby(obj/item/C, mob/user)
	if(src.opened)
		if(istype(C, /obj/item/grab))
			if(isxeno(user)) return
			var/obj/item/grab/G = C
			if(G.grabbed_thing)
				src.MouseDrop_T(G.grabbed_thing, user)   //act like they were dragged onto the closet
			return
		if(C.flags_item & ITEM_ABSTRACT)
			return 0
		user.drop_inv_item_to_loc(C,loc)
	if(src.opened == 0)
		if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
			if(user.a_intent == INTENT_GRAB)
				user.visible_message(SPAN_NOTICE("[user] starts to remove the drawers from the frame."), SPAN_INFO("You start to remove the drawers from the frame."), SPAN_DANGER("You hear loud metal scraping."))
				if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					dump_contents()
					playsound(src, soundin = 'sound/effects/metal_close.ogg', vol = 25, vary = 1)
					var/obj/item/crafting/top/drawers/top = new(get_turf(src))
					top.variant_id = crafting_drawer_color
					var/obj/structure/crafting/frame/drawers/frame = new(get_turf(src))
					frame.variant_id = variant_id
					qdel(src)
					return
		return
	return

/obj/structure/closet/modular/drawers/attack_hand(mob/user)
	. = ..()
	if(usr.a_intent == INTENT_DISARM)
		if(do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(src, soundin = 'sound/items/Screwdriver2.ogg', vol = 25, vary = 1)
			user.visible_message(SPAN_NOTICE("[user] flips a lever near the bottom of the drawers, detaching it from the floor."), SPAN_INFO ("You flip a lever near the bottom of the drawers, detaching it from the floor."))
			anchored = !anchored

//office chair

/obj/structure/bed/chair/modular/office
	icon = 'icons/obj/items/sp_crafting.dmi'
	icon_state = "officechair_white"
	name = "office chair"
	desc = "A somewhat comfortable looking seat and backrest attached to a metal frame with four legs. A small wheel is attached to each of the legs."
	desc_lore = "Chairs on wheels tend to be preferred by spaceship personnel on account of there being a lot of back-and-forth movement even within a single work area. These chairs also handle turbulence better and don’t fall over as much during regular spaceship operation, something that becomes very noticeable for someone that spends weeks on the same station."
	var/variant_id
	var/crafting_chair_top_id
	var/crafting_chair_wheel_id
	propelled = FALSE
	can_rotate = TRUE
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	picked_up_item = null
	drag_delay = 1
	PersistantObject = TRUE
	stacked_size = 0

/obj/structure/bed/chair/modular/office/attackby(obj/item/C, mob/user)

	if(istype(C, /obj/item/grab) && !buckled_mob)
		var/obj/item/grab/G = C
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			var/atom/blocker = LinkBlocked(user, user.loc, loc)
			if(blocker)
				to_chat(user, SPAN_WARNING("\The [blocker] is in the way!"))
			else
				to_chat(user, SPAN_NOTICE("You place [M] on [src]."))
				M.forceMove(loc)
		return TRUE

	if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
		if(user.a_intent == INTENT_GRAB)
			user.visible_message(SPAN_NOTICE("[user] starts to loosen the clamp holding the chair seat."), SPAN_INFO("You start to loosen the clamp holding the chair seat."), SPAN_DANGER("You hear metalic scraping."))
			if(do_after(user, (CRAFTING_DELAY_NORMAL * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src, soundin = 'sound/items/Screwdriver.ogg', vol = 25, vary = 1)
				var/obj/item/crafting/top/chair/seat/top = new(get_turf(src))
				top.variant_id = crafting_chair_top_id
				var/obj/structure/crafting/frame/chair/frame = new(get_turf(src))
				frame.variant_id = variant_id
				frame.crafting_chair_wheel_id = crafting_chair_wheel_id
				qdel(src)
				return
	return
