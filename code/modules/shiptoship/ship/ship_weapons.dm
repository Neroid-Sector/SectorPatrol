/obj/structure/ship_elements/missile_ammo
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	name = "missile ammo master item"
	desc = "Haha nope. Should not be in game either :P"
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "default"
	var/missile_type
	var/warhead_type
	var/element_value = 0

/obj/structure/ship_elements/missile_ammo/update_icon()
	if(missile_type)
		icon = 'icons/sectorpatrol/ship/weapon_ammo64.dmi'
		icon_state = missile_type
		bound_width = 64
		bound_height = 32
	if(warhead_type)
		icon_state = warhead_type
		icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
		icon_state = warhead_type
		bound_width = 32
		bound_height = 32
	if(warhead_type && missile_type)
		icon = initial(icon)
		icon_state = initial(icon_state)
		bound_x = initial(bound_x)
		bound_y = initial(bound_y)
	. = ..()

/obj/item/ship_elements/secondary_ammo
	name = "secondary ammo master item"
	desc = "Haha nope. Should not be in game either :P"
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "default"
	var/ammo_type = "none"

/obj/item/ship_elements/secondary_ammo/update_icon()
	icon_state = "secondary_[ammo_type]"
	. = ..()

/obj/structure/ship_elements/primary_cannon
	name = "\improper PST Type-A Prototype Cannon"
	desc = "A complex piece of heavy machinery without any clear indications how to use it, only warning labels. Complete with a tray that extends from the cannon itself."
	icon = 'icons/sectorpatrol/ship/cannons96.dmi'
	desc_lore = "In PST technical jargon, Weapon System Type A essentially stands for\"Primary\" or \"Missile\" based weapon system. This system encodes regular information passed to it from user terminals and converts it to a format understandable by the PSTs Mission Control system. The system's primary unique feature is when the missile has the right navigational data, it will always strike its target even if it moves or changes its vector."
	icon_state = "primary_unloaded"
	density = TRUE
	anchored = TRUE
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unslashable = TRUE
	unacidable = TRUE
	var/ship_name = "none"
	var/weapon_fired = 0
	var/list/loaded_projectile = list("missile" = "none",
		"missile_open" = 0,
		"warhead" = "none",
		"warhead_open" = 0,
		"speed" = 0,
		"payload" = 0,
		"factor" = 0,
		"loaded" = 0,
		)

/obj/structure/ship_elements/primary_cannon/update_icon(loading = 0)
	overlays.Cut()
	if(loading == 0)
		if(loaded_projectile["loaded"] == 0)
			overlays += image("primary_unloaded")
			if(loaded_projectile["missile"] != "none")
				overlays += image("tray_missile_[loaded_projectile["missile"]]")
			if(loaded_projectile["warhead"] != "none")
				overlays += image("tray_warhead_[loaded_projectile["warhead"]]")
			return
		if(loaded_projectile["loaded"] == 1)
			overlays += image("primary_loaded")
			return
	if(loading == 1)
		switch(icon_state)
			if("primary_unloaded")
				overlays += image("primary_load")
				icon_state = "primary_load"
				return
			if("primary_load")
				overlays += image("primary_loaded")
				icon_state = "primary_loaded"
				return
			if("primary_loaded")
				overlays += image("primary_fire")
				icon_state = "primary_fire"
				return
			if("primary_fire")
				overlays += image("primary_unloaded")
				icon_state = "primary_unloaded"
				return

/obj/structure/ship_elements/primary_cannon/proc/animate_use()
	switch(icon_state)
		if("primary_unloaded")
			update_icon(loading = 1)
			sleep(20)
			update_icon(loading = 1)
			return
		if("primary_loaded")
			update_icon(loading = 1)
			sleep(30)
			update_icon(loading = 1)
			return

/obj/structure/ship_elements/primary_cannon/proc/FireCannon()
	loaded_projectile["missle_open"] = 0
	loaded_projectile["warhead"] = "none"
	loaded_projectile["warhead_open"] = 0
	loaded_projectile["speed"] = 0
	loaded_projectile["payload"] = 0
	loaded_projectile["factor"] = 0
	loaded_projectile["loaded"] = 0
	animate_use()

/obj/structure/ship_elements/primary_cannon/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/powerloader_clamp) || !HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL) || !HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(usr, SPAN_WARNING("You have no idea how to use these together."))
		return
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return
		if(PC.loaded)
			if(!istype(PC.loaded, /obj/structure/ship_elements/missile_ammo))
				to_chat(user, SPAN_WARNING("There is no way you can put \the [PC.loaded] into \the [src]!"))
				return

			var/obj/structure/ship_elements/missile_ammo/AmmoToInsert = PC.loaded
			if(AmmoToInsert.missile_type != null)
				if(loaded_projectile["missile"] != "none")
					to_chat(user, SPAN_WARNING("\The [src] already has a missile loaded."))
					return
				if(loaded_projectile["missile"] == "none")
					to_chat(user, SPAN_NOTICE("You load \the [AmmoToInsert] into \the [src]."))
					loaded_projectile["missile"] = AmmoToInsert.missile_type
					loaded_projectile["speed"] = AmmoToInsert.element_value
					qdel(AmmoToInsert)
			else
				if(AmmoToInsert.warhead_type != null)
					if(loaded_projectile["warhead"] != "none")
						to_chat(user, SPAN_WARNING("\The [src] already has a warhead loaded."))
						return
					if(loaded_projectile["warhead"] == "none")
						to_chat(user, SPAN_NOTICE("You load \the [AmmoToInsert] into \the [src]."))
						loaded_projectile["warhead"] = AmmoToInsert.missile_type
						loaded_projectile["payload"] = AmmoToInsert.element_value
						qdel(AmmoToInsert)
			playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
			PC.loaded = null
			update_icon()
			PC.update_icon()
		else
			if(loaded_projectile["missile"] != "none")
				var/obj/structure/ship_elements/missile_ammo/AmmoToGrab = new (src)
				AmmoToGrab.missile_type = loaded_projectile["missile"]
				AmmoToGrab.element_value = loaded_projectile["speed"]
				AmmoToGrab.update_icon()
				loaded_projectile["missile"] = "none"
				loaded_projectile["missile_open"] = 0
				loaded_projectile["speed"] = 0
				PC.grab_object(user, AmmoToGrab, "big_crate", 'sound/machines/hydraulics_2.ogg')
			else if(loaded_projectile["warhead"] != "none")
				var/obj/structure/ship_elements/missile_ammo/AmmoToGrab = new (src)
				AmmoToGrab.warhead_type = loaded_projectile["warhead"]
				AmmoToGrab.element_value = loaded_projectile["payload"]
				AmmoToGrab.update_icon()
				loaded_projectile["warhead"] = "none"
				loaded_projectile["warhead_open"] = 0
				loaded_projectile["payload"] = 0
				PC.grab_object(user, AmmoToGrab, "big_crate", 'sound/machines/hydraulics_2.ogg')
			update_icon()
			return
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(usr.a_intent == INTENT_HELP || usr.a_intent == INTENT_DISARM)
			if(loaded_projectile["warhead"] == "none")
				to_chat(usr, SPAN_WARNING("There is no warhead to open in this tray."))
				return
			if(loaded_projectile["warhead"] != "none")
				playsound(src, 'sound/items/Screwdriver2.ogg')
				if(loaded_projectile["warhead_open"] == 0)
					to_chat(usr, SPAN_INFO("You open a small hatch on the warhead, exposing a connection port."))
					loaded_projectile["warhead_open"] = 1
					return
				if(loaded_projectile["warhead_open"] == 1)
					to_chat(usr, SPAN_INFO("You close the hatch on the warhead."))
					loaded_projectile["warhead_open"] = 0
					return
		if(usr.a_intent == INTENT_GRAB || usr.a_intent == INTENT_HARM)
			if(loaded_projectile["missile"] == "none")
				to_chat(usr, SPAN_WARNING("There is no missile to open in this tray."))
				return
			if(loaded_projectile["missile"] != "none")
				playsound(src, 'sound/items/Screwdriver2.ogg')
				if(loaded_projectile["missile_open"] == 0)
					to_chat(usr, SPAN_INFO("You open a small hatch on the missile, exposing a connection port."))
					loaded_projectile["missile_open"] = 1
					return
				if(loaded_projectile["missile_open"] == 1)
					to_chat(usr, SPAN_INFO("You close the hatch on the missile."))
					loaded_projectile["missile_open"] = 0
					return
	if(HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL))
		if(usr.a_intent == INTENT_HELP || usr.a_intent == INTENT_DISARM)
			if(loaded_projectile["warhead"] == "none")
				to_chat(usr, SPAN_WARNING("There is no warhead in this tray."))
				return
			if(loaded_projectile["warhead"] != "none")
				if(loaded_projectile["warhead_open"] == 0)
					to_chat(usr, SPAN_WARNING("You need to open the hatch with a screwdriver first."))
					return
				if(loaded_projectile["warhead_open"] == 1)
					var/value_to_adjust = tgui_input_number(usr, "Select new PAYLOAD value. Each PAYLOAD point is worth 5 SPEED points. Current balance: [loaded_projectile["factor"]].", "PAYLOAD value", loaded_projectile["payload"], timeout = 0, integer_only = 1)
					loaded_projectile["factor"] -= (value_to_adjust - loaded_projectile["payload"])
					loaded_projectile["payload"] = value_to_adjust
					playsound(usr, 'sound/machines/twobeep.ogg')
					to_chat(usr, SPAN_INFO("[value_to_adjust] set. Factor balance: [loaded_projectile["factor"]]"))
					return
		if(usr.a_intent == INTENT_GRAB || usr.a_intent == INTENT_HARM)
			if(loaded_projectile["missile"] == "none")
				to_chat(usr, SPAN_WARNING("There is no missile in this tray."))
				return
			if(loaded_projectile["missile"] != "none")
				if(loaded_projectile["missile_open"] == 0)
					to_chat(usr, SPAN_WARNING("You need to open the hatch with a screwdriver first."))
					return
				if(loaded_projectile["missile_open"] == 1)
					var/value_to_adjust = tgui_input_number(usr, "Select new SPEED value. Each PAYLOAD point is worth 5 SPEED points. Current balance: [loaded_projectile["factor"]].", "SPEED value", loaded_projectile["speed"], timeout = 0, integer_only = 1)
					if(((value_to_adjust - loaded_projectile["payload"]) / 5) >= 0)
						loaded_projectile["factor"] -= ceil((value_to_adjust - loaded_projectile["payload"]) / 5)
					else
						loaded_projectile["factor"] -= floor((value_to_adjust - loaded_projectile["payload"]) / 5)
					loaded_projectile["speed"] = value_to_adjust
					playsound(usr, 'sound/machines/twobeep.ogg')
					to_chat(usr, SPAN_INFO("[value_to_adjust] set. Factor balance: [loaded_projectile["factor"]]"))
					return

/obj/structure/ship_elements/primer_lever/primary
	name = "primary cannon priming lever"
	desc = "A firm looking lever"
	desc_lore = "The OV-PST made weapons need to \"prime\" is a different process than priming conventional weaponry and involves conversion of data and activation of special LD trackers that let the PST see the projectile, but the end effect is the same - once primed, the weapon must be fired to clear it."
	icon = 'icons/sectorpatrol/ship/switches.dmi'
	icon_state = "lever"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = TRUE
	unslashable = TRUE
	var/obj/structure/ship_elements/primary_cannon/paired_device

/obj/structure/ship_elements/primer_lever/primary/proc/animate_use()
	icon_state = "lever_use"
	update_icon()
	sleep(12)
	icon_state = "lever"
	update_icon()

/obj/structure/ship_elements/primer_lever/primary/Initialize(mapload, ...)
	for (var/obj/structure/ship_elements/primary_cannon/cannon_to_pair in get_area(src))
		if(cannon_to_pair != null) paired_device = cannon_to_pair
	. = ..()

/obj/structure/ship_elements/primer_lever/primary/attack_hand(mob/user)
	if(!paired_device || paired_device.loaded_projectile["warhead"] == "none" || paired_device.loaded_projectile["missile"] == "none")
		to_chat(usr, SPAN_WARNING("The lever does not budge."))
		return
	else
		to_chat(usr, SPAN_INFO("You push the priming lever."))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/ship_elements/primer_lever/primary/, animate_use))
		if(paired_device.loaded_projectile["warhead_open"] == 1)
			playsound(paired_device, 'sound/machines/warning-buzzer.ogg')
			paired_device.talkas("Warning: Warhead hatch open. Priming aborted.")
			return
		if(paired_device.loaded_projectile["missile_open"] == 1)
			playsound(paired_device, 'sound/machines/warning-buzzer.ogg')
			paired_device.talkas("Warning: Missile hatch open. Priming aborted.")
			return
		if(paired_device.loaded_projectile["factor"] != 0 || paired_device.loaded_projectile["speed"] <= 0 || paired_device.loaded_projectile["payload"] <= 0)
			playsound(paired_device, 'sound/machines/warning-buzzer.ogg')
			paired_device.talkas("Warning: Missle misconfigured. Priming aborted.")
			return
		else
			paired_device.loaded_projectile["loaded"] = 1
			sleep(5)
			INVOKE_ASYNC(paired_device, TYPE_PROC_REF(/obj/structure/ship_elements/primary_cannon, animate_use))
			sleep(20)
			paired_device.talkas("Projectile primed. Cannon ready to fire.")
			return

/obj/structure/ship_elements/secondary_cannon
	name = "\improper PST Type-S Prototype Cannon"
	desc = "A complex piece of heavy machinery without any clear indications how to use it, only warning labels. Seems to be loaded by sliding in boxes into a slot on the back."
	icon = 'icons/sectorpatrol/ship/cannons96.dmi'
	desc_lore = "In PST technical jargon, Weapon System Type S essentially stands for\"Side\" or \"Additonal\" weapon system and are expected to be used at close range targets and without tracking - projectiles launched from this system strike their target immediately, which remains its primary advantage that compensates for its extremely short range, in ship-to-ship combat terms anyway."
	icon_state = "secondary_unloaded"
	density = TRUE
	anchored = TRUE
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unslashable = TRUE
	unacidable = TRUE
	var/ship_name = "none"
	var/list/loaded_projectile = list(
		"type" = "none",
		"loaded" = 0
		)

/obj/structure/ship_elements/secondary_cannon/update_icon()
	overlays.Cut()
	if(icon_state == "secondary_unloaded")
		overlays += image("secondary_load")
		icon_state = "secondary_load"
		return
	if(icon_state == "secondary_load")
		overlays += image("secondary_loaded")
		icon_state = "secondary_loaded"
		return
	if(icon_state == "secondary_loaded")
		overlays += image("secondary_fire")
		icon_state = "secondary_fire"
		return
	if(icon_state == "secondary_fire")
		overlays += image("secondary_unloaded")
		icon_state = "secondary_unloaded"
		return

/obj/structure/ship_elements/secondary_cannon/proc/animate_use()
	switch(icon_state)
		if("secondary_unloaded")
			update_icon()
			sleep(5)
			update_icon()
			return
		if("secondary_loaded")
			update_icon()
			sleep(5)
			update_icon()
			return

/obj/structure/ship_elements/secondary_cannon/proc/FireCannon()
	loaded_projectile["type"] = "none"
	loaded_projectile["loaded"] = 0
	animate_use()

/obj/structure/ship_elements/secondary_cannon/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/ship_elements/secondary_ammo))
		to_chat(SPAN_WARNING("You have no idea how to use these two together."))
		return
	if(istype(W, /obj/item/ship_elements/secondary_ammo))
		if(loaded_projectile["loaded"] == 1)
			to_chat(usr, SPAN_WARNING("The secondary cannon is loaded and primed. It needs to be discharged before you can load it again."))
			return
		if(loaded_projectile["type"] != "none")
			to_chat(usr, SPAN_WARNING("A box is already loaded into the cannon. Remove it with an empty hand and GRAB intent to load a different box."))
			return
		if(loaded_projectile["type"] == "none")
			to_chat(usr, SPAN_INFO("The ammo box slides into place and is ready for priming!"))
			var/obj/item/ship_elements/secondary_ammo/AmmoToInsert = W
			loaded_projectile = AmmoToInsert.ammo_type
			qdel(AmmoToInsert)
			return

/obj/structure/ship_elements/secondary_cannon/attack_hand(mob/user)
	if(usr.a_intent == INTENT_GRAB)
		if(loaded_projectile["loaded"] == 1)
			to_chat(usr, SPAN_WARNING("The secondary cannon is loaded and primed. It needs to be discharged before you can unload it."))
			return
		if(loaded_projectile["loaded"] == 0)
			if(loaded_projectile["type"] == "none")
				to_chat(usr, SPAN_WARNING("There is no ammo to remove from this cannon."))
				return
			if(loaded_projectile["type"] != "none")
				var/obj/item/ship_elements/secondary_ammo/AmmoToGrab = new (src)
				AmmoToGrab.ammo_type = loaded_projectile["type"]
				AmmoToGrab.update_icon()
				usr.put_in_active_hand(AmmoToGrab)
				to_chat(usr, SPAN_INFO("You remove [AmmoToGrab] from the cannon."))
				loaded_projectile["type"] = "none"
				return

/obj/structure/ship_elements/primer_lever/secondary
	name = "primary cannon priming lever"
	desc = "A firm looking lever"
	desc_lore = "The OV-PST made weapons need to \"prime\" is a different process than priming conventional weaponry and involves conversion of data and activation of special LD trackers that let the PST see the projectile, but the end effect is the same - once primed, the weapon must be fired to clear it."
	icon = 'icons/sectorpatrol/ship/switches.dmi'
	icon_state = "lever"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = TRUE
	unslashable = TRUE
	var/obj/structure/ship_elements/secondary_cannon/paired_device

/obj/structure/ship_elements/primer_lever/secondary/proc/animate_use()
	icon_state = "lever_use"
	update_icon()
	sleep(12)
	icon_state = "lever"
	update_icon()

/obj/structure/ship_elements/primer_lever/secondary/Initialize(mapload, ...)
	for (var/obj/structure/ship_elements/secondary_cannon/cannon_to_pair in get_area(src))
		if(cannon_to_pair != null) paired_device = cannon_to_pair
	. = ..()

/obj/structure/ship_elements/primer_lever/secondary/attack_hand(mob/user)
	if(!paired_device || paired_device.loaded_projectile["type"] == "none")
		to_chat(usr, SPAN_WARNING("The lever does not budge."))
		return
	else
		to_chat(usr, SPAN_INFO("You push the priming lever."))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/ship_elements/primer_lever/secondary/, animate_use))
		paired_device.loaded_projectile["loaded"] = 1
		sleep(5)
		INVOKE_ASYNC(paired_device, TYPE_PROC_REF(/obj/structure/ship_elements/secondary_cannon, animate_use))
		sleep(20)
		paired_device.talkas("Projectile primed. Cannon ready to fire.")
	. = ..()
