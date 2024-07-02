//OV-PST printed
/obj/item/tool/wrench/uacm
	name = "UACM engraved wrench"
	desc = "A wrench with the UACM logo and a serial number engraved into the handle."
	desc_lore = "Wrenches are common tools used anywhere someone needs something loosened or tightened. Larger bolts typically require automated, pneumatic machines to safely install and remove, but most spaceships use a unified range of bolt and screw sizes making the manufacture of only one, universal size wrench possible. The engraving seems a bit extravagant and seems to be unique to the PST."
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE
	inherent_traits = list(TRAIT_TOOL_WRENCH)

/obj/item/tool/crowbar/uacm
	name = "UACM engraved crowbar"
	desc = "A crowbar with the UACM logo and a serial number engraved into the handle."
	desc_lore = "Crowbars are your best friend whenever something needs to be wedged open, which on board of spaceships and space faring installations means that they are particularly useful when dealing with power failures. Most internal airlocks have a hidden switch that can be accessed with a crowbar that releases their basic lock in case of power loss, but secure or external airlocks may be sealed to prevent this. The engraving seems a bit extravagant and seems to be unique to the PST."
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE
	inherent_traits = list(TRAIT_TOOL_CROWBAR)

/obj/item/tool/screwdriver/uacm
	name = "UACM engraved screwdriver"
	desc = "A screwdriver with the UACM logo and a serial number engraved into the handle."
	desc_lore = "Screwdrivers are used to tighten and loosen screws that typically hold together smaller pieces of electronics like computers or maintenance panels. A universal, 'star' shaped design was very quickly developed by humanity after their rapid ascent to the stars to ensure compatibility as both the screws and the screwdrivers have a bad tendency to get lost within 10 minutes of any space voyage. A standard issue screwdriver's handle is hollow, the inside used for carrying spare screws. Due to this, engravings on screwdrivers are not that unusual, although a serial number is not something found outside of the PST."
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE
	inherent_traits = list(TRAIT_TOOL_SCREWDRIVER)

/obj/item/tool/wirecutters/uacm
	name = "UACM engraved wirecutters"
	desc = "A set of wirecutters with the UACM logo and a serial number engraved into the handle."
	desc_lore = "Wirecutters, as the name suggests, come in handy whenever wires need to be split, typically during work on small electronic systems or while servicing power cables along ships and installations. What the name does not reveal and what most people that haven't used one of these tools for themselves do not realize is that standard wirecutters such as these also have several rings and grooves etched into their squeezing segment which can be used to thread and rebind cut wires, effectively making this tool but a wire cuter and un-cutter. This of course is an exceptionally long way of explaining that these tools can be used to both cut and mend cut wires if there is enough spare length to patch them up. The engraving seems a bit extravagant and seems to be unique to the PST."
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE
	inherent_traits = list(TRAIT_TOOL_WIRECUTTERS)

/obj/item/tool/weldingtool/experimental/uacm
	name = "UACM prototype welding unit"
	desc = "A handheld device with a visible nozzle and a squeeze trigger handle. The UACM logo and a small inscription is engraved into the side."
	desc_lore = "Welding torches typically require fuel and eye protection, the so called 'welding unit' being prototyped on the PST is supposed to be a counter to both those setbacks and more. Utilizing some of the first miniaturized Twilight-Paradox powered batteries, this device can recharge itself and produces a high heat, controlled flame that is safer and produces light that is not harmful to the human eyes long term. Several such devices were prototyped over the last few years of the USCMC existence, but how exactly did this design end up being used on the PST is not clear, as it seems to be just part of the stations standard issue equipment set."
	icon_state = "welder_c"
	has_welding_screen = TRUE
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE
	inherent_traits = list(TRAIT_TOOL_BLOWTORCH)

/obj/item/tool/drill/uacm
	name = "UACM engraved drill"
	desc = "You can be totally screwy with this."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "drill"
	pickup_sound = 'sound/handling/multitool_pickup.ogg'
	drop_sound = 'sound/handling/screwdriver_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	inherent_traits = list(TRAIT_TOOL_DRILL)
