/obj/structure/ship_elements/shipprop
	name = "Generic prop item"
	desc = "Yep one of those again"
	icon = 'icons/sp_default.dmi'
	icon_state = "default"
	anchored = 1
	opacity = 1
	density = 1
	unacidable = 1
	indestructible = 1
	unslashable = 1

/obj/structure/ship_elements/shipprop/attack_hand(mob/user)
	return

/obj/structure/ship_elements/shipprop/attackby(obj/item/W, mob/user)
	return

/obj/structure/ship_elements/shipprop/twilight_rail
	name = "integrated Twilight Paradox generator and Liquid Data controller"
	desc = "A bulky computer with multiple heavy-duty cables attached to its bottom. Does not seem to react to user input."
	desc_lore = "These bulky devices supposedly integrate and serve both as a Twilight Paradox energy harvester and Hyperspace field generator, but also as the ship's actual engines. While the exact mechanics that these devices used seems to currently be a highly guarded secret, it is however clear that these devices, along with the central Mission Control interface maintain a constant link to the PST's Liquid Data reserves and draw power from there which they send to the rest of the ship. "
	icon = 'icons/obj/structures/machinery/clio_bigboi.dmi'
	icon_state = "closed"
	bound_height = 64
	bound_width = 64

/obj/structure/ship_elements/shipprop/power_distribution
	name = "OV-PST LD based power distributor"
	desc = "A heavy metal housing over what looks like multiple coils stacked on top of each other. Has a terminal on its front but does not seem to react to user input."
	desc_lore = "Power transmitted from the PST via Liquid Data is distributed from the Twilight Paradox rail rooms to these devices, which handle storing of excess (and a modest charge to keep the ship running should the link to the PST is broken) and adjusting power flow to actively meet the needs of the ship. Similar devices exist in conventional starships, but typically are mixed with conventional power generators which these don't seem to have at all."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smes_prop"

/obj/structure/ship_elements/shipprop/systems_monitor
	name = "systems monitor"
	desc = "A wall mounted console that seems to be displaying power, air and temperature information about the room or hallway its mounted in. Does not seem to react to any inputs."
	desc_lore = "Of all the elements of the PST power systems, the controllers probably look the most like their traditional counterparts, however this is where the similarities end. Since everything is controlled by one centralized system, these monitors also display readouts from all of them and use this terminal as a critical information tool during emergencies."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "apc_prop"


/obj/structure/ship_elements/shipprop/vent
	name = "air vent"
	desc = "A remote-controlled vent that constricts and relaxes, letting a stream of air into the room."
	desc_lore = "To extend the time spaceships spend without the need to replenish their concentrated air stores, most ships actively scrub their air and monitor the air pressure inside, using that as a basic reference when replenishing oxygen form the stores. These vents are both the origin and end point of the systems, as they can be reconfigured to both suck in and push out air from the internal system."
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "on"
