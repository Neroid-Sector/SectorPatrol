/turf/open/floor/plating/modular

	name = "UACM standarized interior plating"
	desc = "Metal plates attached to the hull, with small, predrilled holes doting their surface."
	desc_lore = "This special plating is typically permanently installed on ship hull floors meant for private or recreational locations. They come with small holes predrilled in preset, standardized distances that allow for the installation of modular tile struts, which in turn are used with the UACM standardized tiling system to add some color to private quarters of UACM personnel. The tiles themselves are printed in the PST's fabrication wings at minimal material cost. The drawback here is the amount of manual labor required to put these together and the fact that, some Marines argue at least, the UACM lacks any sense of style. Most agree that the jury is still out on that last one."
	icon = 'icons/obj/items/floortiles.dmi'
	icon_state = "plating"
	intact_tile = FALSE
	tool_flags = NO_FLAGS
	var/struts_install = 0
	var/struts_ready = 0
	var/tiles_install = 0
	var/tiles_color = "default"
	var/base_icon = "plating"

/turf/open/floor/plating/modular/attack_hand(mob/user)
	if(user.a_intent == INTENT_GRAB)
		if(struts_install == 0)
			return
		if(tiles_install > 0)
			to_chat(usr, SPAN_NOTICE("You should remove the tiles before you touch the struts. The snapping mechanism needs to be released with a crowbar in GRAB intent."))
			return
		if(struts_install == struts_ready)
			to_chat(usr, SPAN_NOTICE("The strut does not budge. You need to loosen its screws with a screwdriver in GRAB intent."))
			return
		if(struts_install > struts_ready)
			user.visible_message(SPAN_NOTICE("[user] gathers metalic bars of the plating."), SPAN_INFO("You pick up the struts." ))
			while (struts_install > struts_ready)
				struts_install -= 1
				if(struts_install > 0)
					icon_state = "[base_icon]_s[struts_install]"
					update_icon()
				if (struts_install == 0)
					icon_state = "[base_icon]"
					update_icon()
				var/obj/item/stack/rods/floorstrut/fs = new(get_turf(user))
				var/replace = (user.get_inactive_hand()==src)
				if(QDELETED(src) && replace)
					user.put_in_hands(fs)
					sleep(2)
			return

/turf/open/floor/plating/modular/attackby(obj/item/C, mob/user)
	if(iswelder(C))
		if(!HAS_TRAIT(C, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/welder = C
		if(welder.isOn() && broken == 1)
			if(welder.remove_fuel(1, user))
				playsound(src, 'sound/items/Welder.ogg', 25, 1)
				if(struts_install > 0)
					user.visible_message(SPAN_NOTICE("[user] starts to fix the struts and plating."), SPAN_INFO("You start fixing the struts and plating." ), SPAN_DANGER("You hear a hissing that gets distinctly louder for short intervals."))
					if(do_after(user, (CRAFTING_DELAY_LONG + (15 * struts_install)) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						user.visible_message(SPAN_NOTICE("[user] fixes the struts and plating."), SPAN_INFO("You fix the struts and plating." ), SPAN_DANGER("The hissing stops."))
						icon_state = "[base_icon]_s[struts_install]"
						name = "[initial(name)] and modular struts"
						desc = "[initial(desc)] At least one metal strut has been placed and matched to the openings on the plating, ready to be attached to the platform."
						desc_lore = "[initial(desc_lore)] The struts, screws and other elements that can be attached to the plating are all in compliance with the Northern Republic Production Standard, guaranteeing compatibility with almost any human ship in existence."
						broken = FALSE
						burnt = FALSE
						return
				if(struts_install == 0)
					user.visible_message(SPAN_NOTICE("[user] starts to fix the plating."), SPAN_INFO("You start fixing the plating." ), SPAN_DANGER("You hear a hissing that gets distinctly louder for short intervals."))
					if(do_after(user, CRAFTING_DELAY_LONG * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						user.visible_message(SPAN_NOTICE("[user] fixes the plating."), SPAN_INFO("You fix the plating." ), SPAN_DANGER("The hissing stops."))
						icon_state = base_icon
						desc = initial(desc)
						desc_lore = initial(desc_lore)
						broken = FALSE
						burnt = FALSE
						return
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		to_chat(user, SPAN_NOTICE("There does not seem to be a way to put these two together at the moment."))
		return
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	if(istype(C, /obj/item/stack/modulartiles))
		var/obj/item/stack/modulartiles/T = C
		if (!T)
			return
		if(T.get_amount() < 1)
			return
		if(tiles_install >= 4)
			return
		if(broken)
			to_chat(user, SPAN_NOTICE("There is too much damage to continue installing the tiles. Use a welder to fix the damage."))
			return
		if(burnt)
			to_chat(user, SPAN_NOTICE("There is too much damage to continue installing the tiles. Use a screwdriver to start cleaning it."))
			return
		if(struts_ready < 4)
			to_chat(user, SPAN_NOTICE("To avoid damage and make sure they are even, you should finish installing four struts on the panel before you start attaching tiles."))
			return
		if(tiles_install < 4)
			if(tiles_install == 0)
				name = "Partially finished floor tiling"
				desc = "Four metal struts attached to holes on the floor plating with some modular floor tiles already slotted into the struts. "
				desc_lore = "These modular tiles are typically attached onto special plating that is typically permanently installed on ship hull floors meant for private or recreational locations. The plating comes with small holes predrilled in preset, standardized distances that allow for the installation of modular tile struts, which in turn are used with the UACM standardized tiling system to add some color to private quarters of UACM personnel. The tiles and struts that hold them are themselves are printed in the PST's fabrication wings at minimal material cost. "
				tiles_color = T.tiles_color
				if(!tiles_color)
					to_chat(SPAN_BOLDWARNING("Warning. No tile color value inherited from tiles. This is most likely a scripting error. A default will be used. Please ping a Game Master and note what tile you used."))
					tiles_color = initial(tiles_color)
			user.visible_message(SPAN_NOTICE("[user] starts snapping panels onto struts."), SPAN_INFO("You start to snap panels onto struts. They attach with an audible click that somehow feels very satisfying."),SPAN_INFO("You hear a series of oddly satisfying clicks."))
			while(tiles_install < 4)
				T.use(1)
				tiles_install += 1
				if(tiles_install == 4)
					icon_state = "[tiles_color]"
					update_icon()
					name = "modular floor tiling"
					desc = "Four NRPS compliant modular tiles snapped to struts attached to special plating attached to the hull. A Northern Republic classic. "
					desc_lore = "These modular tiles are typically attached onto special plating that is typically permanently installed on ship hull floors meant for private or recreational locations. The plating comes with small holes predrilled in preset, standardized distances that allow for the installation of modular tile struts, which in turn are used with the UACM standardized tiling system to add some color to private quarters of UACM personnel. The tiles and struts that hold them are themselves are printed in the PST's fabrication wings at minimal material cost. "
				else
					icon_state = "[tiles_color][tiles_install]"
					update_icon()
					sleep(3)
			user.visible_message(SPAN_NOTICE("[user] finishes attaching floor tiles to struts."), SPAN_INFO("You finish snapping the pannels to the struts."),SPAN_INFO("The clicks stop."))
			return
		to_chat(user, SPAN_NOTICE("There does not seem to be a way to put these two together at the moment."))
		return

	if(istype(C, /obj/item/stack/rods/floorstrut))
		if(broken)
			to_chat(user, SPAN_NOTICE("There is too much damage to continue installing the struts. Use a welder to fix the damage."))
			return
		if(burnt)
			to_chat(user, SPAN_NOTICE("There is too much damage to continue installing the struts. Use a screwdriver to start cleaning it."))
			return
		if(struts_install < 4)
			var/obj/item/stack/rods/floorstrut/F = C
			if(F.get_amount() < 1)
				return
			user.visible_message(SPAN_NOTICE("[user] starts laying out and aligning struts on the floor."), SPAN_INFO("You start putting the struts down and aligning them with the holes in the plating." ), SPAN_DANGER("You hear a shuffling."))
			if(struts_install == 0)
				name = "[initial(name)] and modular struts"
				desc = "[initial(desc)] At least one metal strut has been placed and matched to the openings on the plating, ready to be attached to the platform."
				desc_lore = "[initial(desc_lore)] The struts, screws and other elements that can be attached to the plating are all in compliance with the Northern Republic Production Standard, guaranteeing compatibility with almost any human ship in existence."
			while(struts_install < 4)
				if(do_after(user, CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					F.use(1)
					struts_install += 1
					icon_state = "[base_icon]_s[struts_install]"
					update_icon()
			user.visible_message(SPAN_NOTICE("[user] finishes aligning struts on the floor."), SPAN_INFO("You finish aligning the struts. They should now be fastened with a screwdriver."))
			return
		if(struts_install >= 4)
			to_chat(usr, SPAN_WARNING("All predrilled openings already have a strut on them."))
			return
		to_chat(user, SPAN_NOTICE("There does not seem to be a way to put these two together at the moment."))
		return

	if(HAS_TRAIT(C, TRAIT_TOOL_SCREWDRIVER))
		if(broken)
			to_chat(user, SPAN_NOTICE("There is too much damage to continue installing the struts. Use a welder to fix the damage."))
			return
		if(burnt)
			user.visible_message(SPAN_NOTICE("[user] starts to unscrew and clean the struts and plating."), SPAN_INFO("You start to unscrew and clean the struts and plating.."), SPAN_DANGER("You hear a very faint scraping noise."))
			if(do_after(user, (CRAFTING_DELAY_LONG + (15 * struts_ready)) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE("[user] fixes the struts and plating."), SPAN_INFO("You fix the struts and plating." ), SPAN_DANGER("The scraping stops."))
				if(struts_install)
					icon_state = "[base_icon]_s[struts_ready]"
					update_icon()
					name = "[initial(name)] and modular struts"
					desc = "[initial(desc)] At least one metal strut has been placed and matched to the openings on the plating, ready to be attached to the platform."
					desc_lore = "[initial(desc_lore)] The struts, screws and other elements that can be attached to the plating are all in compliance with the Northern Republic Production Standard, guaranteeing compatibility with almost any human ship in existence."
					broken = FALSE
					burnt = FALSE
				return
		if (user.a_intent == INTENT_GRAB)
			if  (struts_ready > 0)
				user.visible_message(SPAN_NOTICE("[user] uses a screwdriver on the plating struts."), SPAN_INFO("You start to unscrew the struts."))
				while(struts_ready > 0)
					if(do_after(user, CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION),INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						sleep(2)
						if(do_after(user, CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION),INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
							struts_ready -= 1
							sleep(2)
				user.visible_message(SPAN_NOTICE("[user] finishes working on the plating."), SPAN_INFO("You finished unfasting all of the struts. You can pick them up by using an empty hand in GRAB intent." ))
			if (struts_ready == 0)
				to_chat(user, SPAN_NOTICE("All the struts are already unfastened. To pick them up, use an empty hand and GRAB intent."))
				return
		if (user.a_intent == INTENT_HELP)
			if (struts_install == 0)
				to_chat(user, SPAN_NOTICE("There is noting for you to screw in. Place a strut first."))
				return
			if (struts_install == struts_ready)
				if (struts_ready < 4)
					to_chat(user, SPAN_NOTICE("There is noting more for you to screw in. Place anoter strut first. If you want to remove struts, switch to GRAB intent."))
					return
				if (struts_ready >= 4)
					to_chat(user, SPAN_NOTICE("All the struts are in place and secured. There is nothing else to screw in. If you want to remove struts, switch to GRAB intent."))
					return
			if (struts_install > struts_ready)
				user.visible_message(SPAN_NOTICE("[user] starts to work on the paneling."), SPAN_INFO("You start to secure the struts."))
				while (struts_install > struts_ready)
					if(do_after(user, CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						sleep(2)
						if(do_after(user, CRAFTING_DELAY_SHORT * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
							struts_ready += 1
				user.visible_message(SPAN_NOTICE("[user] finishes working on the plating."), SPAN_INFO("You fasten all available struts." ))
				return
		to_chat(user, SPAN_NOTICE("There does not seem to be a way to put these two together at the moment."))
		return

	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		if (user.a_intent == INTENT_GRAB)
			if(tiles_install > 0 && tiles_install <= 4)
				user.visible_message(SPAN_NOTICE("[user] starts to detach floor tiles from their struts. They make an audible, disticnt pop."), SPAN_INFO("You start detaching tiles. They make an audible, distinct pop."), SPAN_DANGER("You hear disticnt, quiet popping."))
				while (tiles_install > 0)
					tiles_install -= 1
					var/obj/item/stack/modulartiles/R = new(src, 1, /obj/item/stack/modulartiles)
					R.tiles_color = tiles_color
					R.icon_state = "tiles_[tiles_color]"
					R.update_icon()
					R.add_to_stacks(usr)
					sleep(2)
				user.visible_message(SPAN_NOTICE("[user] finishes detaching the tiles."), SPAN_INFO("You finish detaching the tiles."), SPAN_DANGER("The popping stops."))
				return
			if (tiles_install == 0)
				to_chat(usr, SPAN_INFO("There are no tiles to remove."))
				return
		to_chat(user, SPAN_NOTICE("There does not seem to be a way to put these two together at the moment. If you are trying to remove tiles, please switch to GRAB intent."))
		return



/turf/open/floor/plating/modular/break_tile_to_plating()
	if (!broken)
		struts_install = initial(struts_install)
		struts_ready = initial(struts_ready)
		tiles_install = initial(tiles_install)
		icon_state = "platingdmg[pick(1, 3)]"
		name = "heavilly damaged [initial(name)]"
		desc = "[initial(desc)] ]It's heavily damaged and in need of repairs. The attached struts are mangled beyond repair."
		desc_lore = "[initial(desc_lore)] Physical damage on plating like this is best removed using a welder. Modular struts that attach tiles to the ground are not particularly explosion resistant, so they get damaged easily, requiring complete replacements. This fact is not seen as a flow by the Northern Republic that maintains the standard, as they argue explosions should not be an occurrence in areas where these tiles are used unless something is very wrong."
		broken = 1
	return

/turf/open/floor/plating/modular/break_tile()
	if (!broken && !burnt)
		tiles_install = 0
		if (struts_ready == 0)
			icon_state = "platingdmg2"
			name = "damaged [initial(name)]"
			desc = "[initial(desc)] It's damaged and in need of repairs."
			desc_lore = "[initial(desc_lore)] Physical damage on plating like this is best removed using a welder. Somehow the struts on this panel survived whatever blew off the tiles, but typically they are not particularly explosion resistant, so they get damaged easily, requiring complete replacements. This fact is not seen as a flow by the Northern Republic that maintains the standard, as they argue explosions should not be an occurrence in areas where these tiles are used unless something is very wrong."
		if (struts_ready > 0)
			icon_state = "[base_icon]_s[struts_ready]"
			name = "damaged [initial(name)] and modular struts"
			desc = "[initial(desc)] At least one metal strut has been placed and matched to the openings on the plating, ready to be attached to the platform. The plating and struts are badly damaged and will need repairs."
			desc_lore = "[initial(desc_lore)] The struts, screws and other elements that can be attached to the plating are all in compliance with the Northern Republic Production Standard, guaranteeing compatibility with almost any human ship in existence. Physical damage on plating like this is best removed using a welder. Somehow the struts on this panel survived whatever blew off the tiles, but typically they are not particularly explosion resistant, so they get damaged easily, requiring complete replacements. This fact is not seen as a flow by the Northern Republic that maintains the standard, as they argue explosions should not be an occurrence in areas where these tiles are used unless something is very wrong."
		broken = 1
	return

/turf/open/floor/plating/modular/burn_tile()
	if (!broken && !burnt)
		tiles_install = 0
		if (struts_ready == 0)
			icon_state = "panelscorched"
			name = "burnt [initial(name)]"
			desc = "[initial(desc)] It looks badly burnt and will need to be cleaned before use."
			desc_lore = "[initial(desc_lore)] The tiles following the Northern Republic standard will by design burn off as fast as possible while generating as little heat and smoke as possible. This typically is enough to save the struts that hold them in place, all they need is a little cleaning that will require you to loosen their bolts with a screwdriver first."
		if (struts_ready > 0)
			icon_state = "[base_icon]_s[struts_ready]"
			name = "burnt [initial(name)] and modular struts"
			desc = "[initial(desc)] At least one metal strut has been placed and matched to the openings on the plating, ready to be attached to the platform. It looks badly burnt and will need to be cleaned before use."
			desc_lore = "[initial(desc_lore)] The struts, screws and other elements that can be attached to the plating are all in compliance with the Northern Republic Production Standard, guaranteeing compatibility with almost any human ship in existence. The tiles following the Northern Republic standard will by design burn off as fast as possible while generating as little heat and smoke as possible. This typically is enough to save the struts that hold them in place, all they need is a little cleaning that will require you to loosen their bolts with a screwdriver first."
		burnt = 1
	return
/turf/open/floor/plating/modular/completed
	struts_install = 4
	struts_ready = 4
	tiles_install = 4
	icon_state = "default"
	tiles_color = "default"


/turf/open/floor/plating/modular/completed/Initialize()
	. = ..()
	name = "modular floor tiling"
	desc = "Four NRPS compliant modular tiles snapped to struts attached to special plating attached to the hull. A Northern Republic classic. "
	desc_lore = "These modular tiles are typically attached onto special plating that is typically permanently installed on ship hull floors meant for private or recreational locations. The plating comes with small holes predrilled in preset, standardized distances that allow for the installation of modular tile struts, which in turn are used with the UACM standardized tiling system to add some color to private quarters of UACM personnel. The tiles and struts that hold them are themselves are printed in the PST's fabrication wings at minimal material cost. "

//Specific completed colors

/turf/open/floor/plating/modular/completed/white
	icon_state = "white"
	tiles_color = "white"
