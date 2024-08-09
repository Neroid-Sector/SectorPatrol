/obj/item/ship_probe
	name = "EYE-7 probe"
	desc = "A see-through tube containing electronic systems tied to an antenna that seems to gently glow."
	desc_lore = "EYE-7 probes are designed to interface with the OV-PST's unique battlefield overview system and provide a direct, grid-based feed of an area of operations to all ships linked to the PST's so called Mission Control system. The probes effectively provide a focusing point for the stations' unique artificial intelligence that allows it to feed precise, position-based information which gives unprecedented battlefield orientation capabilities compared to currently used technology."
	icon = 'icons/sectorpatrol/ship/probe.dmi'
	icon_state = "probe"
	flags_item = NOBLUDGEON

/obj/structure/ship_elements/probe_launcher
	name = "EYE-7 probe launcher system"
	desc = "A long tube connected to what looks like a simple loading port and a status indicator."
	desc_lore = "EYE-7 launchers work to translate the position-based vectors relayed by the ships systems into universal coordinates as understood by the Mission Control system used by the UACM's OV-PST. This is effectively the last point in the chain where coordinates are still fed relative to the ship's position, once the probe is launched everything else is in the hands of the system governing the coordinate-based navigation the PST uses."
	icon = 'icons/sectorpatrol/ship/probe96.dmi'
	icon_state = "probe_launcher"
	anchored = 1
	opacity = 1
	density = 1
	var/ship_name = "none" //This has to match the name of the ship its on, as saved on its Mission Control structure.
	var/probe_loaded = 0

/obj/structure/ship_elements/probe_launcher/proc/LaunchContent()
	emoteas("Launches its contets with a loud swoosh!")
	playsound(src, 'sound/effects/bamf.ogg', 25)
	probe_loaded = 0

/obj/structure/ship_elements/probe_launcher/attackby(obj/item/W, mob/user)
	if(!(istype(W, /obj/item/ship_probe)))
		to_chat(usr, SPAN_WARNING("You have no idea how to use these two together."))
		return
	if(istype(W, /obj/item/ship_probe))
		if(probe_loaded == 1)
			to_chat(usr, SPAN_WARNING("A probe is already loaded."))
			return
		if(probe_loaded == 0)
			usr.visible_message(SPAN_INFO("[usr] starts to reload the probe launcher."), SPAN_INFO("You start to reload the probe launcher"), SPAN_WARNING("You hear loud, mechanic clicking!"))
			if(do_after(usr, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				usr.visible_message(SPAN_INFO("[usr] reloads the probe launcher."), SPAN_INFO("The probe slides into the tube and an audible click is heard."), SPAN_WARNING("The clicking stops after a beep."))
				probe_loaded = 1
				qdel(W)
				return
	return

/obj/item/ship_tracker
	name = "PHA-1 type tracker device"
	desc = "A drone sized device encased in polymer glass with slightly glowing, greenish electronic parts visible inside."
	desc_lore = "PHA-1 Trackers are EYE-7 probes that have undergone further modification and integration into the PST's systems and offer a permanent window for the Mission Control system to any entity they manage to attach themselves to. This means that while they do not feed any other information, these devices will always feed their location back to the system, allowing for live tracking."
	icon = 'icons/sectorpatrol/ship/probe.dmi'
	icon_state = "tracker"
	flags_item = NOBLUDGEON

/obj/structure/ship_elements/tracker_launcher
	name = "PHA-1 tracker launcher system"
	desc = "A long tube connected to what looks like a simple loading port and a status indicator."
	desc_lore = "Like the trackers themselves, the PHA-1 tracker launchers are modified EYE-7 drone stations which like the probes takes relative data and turns it into the coordinate-based information that the PST's Mission Control system relies on."
	icon = 'icons/sectorpatrol/ship/probe96.dmi'
	icon_state = "tracker_launcher"
	anchored = 1
	opacity = 1
	density = 1
	var/ship_name = "none" //This has to match the name of the ship its on, as saved on its Mission Control structure.
	var/tracker_loaded = 0

/obj/structure/ship_elements/tracker_launcher/proc/LaunchContent()
	emoteas("Launches its contets with a loud swoosh!")
	playsound(src, 'sound/effects/bamf.ogg', 25)
	tracker_loaded = 0

/obj/structure/ship_elements/tracker_launcher/attackby(obj/item/W, mob/user)
	if(!(istype(W, /obj/item/ship_tracker)))
		to_chat(usr, SPAN_WARNING("You have no idea how to use these two together."))
		return
	if(istype(W, /obj/item/ship_tracker))
		if(tracker_loaded == 1)
			to_chat(usr, SPAN_WARNING("A tracker is already loaded."))
			return
		if(tracker_loaded == 0)
			usr.visible_message(SPAN_INFO("[usr] starts to reload the tracker launcher."), SPAN_INFO("You start to reload the tracker launcher"), SPAN_WARNING("You hear loud, mechanic clicking!"))
			if(do_after(usr, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				usr.visible_message(SPAN_INFO("[usr] reloads the tracker launcher."), SPAN_INFO("The tracker slides into the tube and an audible click is heard."), SPAN_WARNING("The clicking stops after a beep."))
				tracker_loaded = 1
				qdel(W)
				return
	return
