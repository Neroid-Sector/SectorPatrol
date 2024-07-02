//documents, randmizes chance to be intel using general formula (5% to be intel + 15% to be dud)

/obj/item/salvage/document
	name = "document"
	desc = "Information in written form on a piece of paper. Still the most common way of indirect communication in the galaxy. "
	desc_lore = "While the method of producing paper has evolved and currently papers are way more likely to be made from specially prepared resins that notably do not rely on organic matter in any form, the actual use remains the same - you put a writing medium to the surface to create words or pictures. Simple, yet effective. "
	salvage_contents = list(
	"metal" = 0,
	"resin" = 5,
	"alloy" = 0,
	)
	icon = 'icons/sectorpatrol/salvage/items/document.dmi'
	icon_state = "document"
	salvage_search = list(		//Main search list, has all the basic data, plus default return/reexamine texts. This is the var that is read for all text/functions of the searching system. Ideally this list should not be touched.
		"can_be_searched" = 0,
		"was_searched" = 0,
		"search_time" = SEARCH_TIME_NORMAL,
		"search_return_initial" = "There is nothing of note written in this document.",
		"search_return_complete" = "There is nothing of note written in this document."
		)
	salvage_search_alttext = list( //Alttexts for specific steps/results of searches. Copy the whole bock to customize.
		"search_return_initial" = "While scanning the document, you clearly find a note saying 'DO NOT RECYCLE' in red marker. This must be one of the Commander's 'intel' files. You mark the note and put the file to the side.",
		"search_return_complete" = "A 'DO NOT RECYCLE' note in red marker is circled in the document."
		)

/obj/item/salvage/document/random
	icon_state_max = 25
	salvage_random = 1
	pixel_randomize = 1

/obj/item/salvage/medical
	name = "medical supplies"
	desc = "Medical equipment, past its prime."
	desc_lore = "Band-Aids, gauze, ointments, splits and other assorted medical equipment. All contain a small ammount of resins. "
	salvage_contents = list(
	"metal" = 0,
	"resin" = 5,
	"alloy" = 0,
	)
	icon = 'icons/sectorpatrol/salvage/items/medical.dmi'
	icon_state = "medical"

/obj/item/salvage/medical/random
	icon_state_max = 7
	salvage_random = 0
	pixel_randomize = 1

/obj/item/salvage/clothing
	name = "clothing"
	desc = "Civilian issue spacer clothing. Made from synthetic fibers."
	desc_lore = "Not as well-crafted as the PST's own creation, these clothes remain a decent source of resins. "
	salvage_contents = list(
	"metal" = 0,
	"resin" = 10,
	"alloy" = 0,
	)
	icon = 'icons/sectorpatrol/salvage/items/clothing.dmi'
	icon_state = "clothing"

/obj/item/salvage/clothing/random
	icon_state_max = 12
	salvage_random = 0
	pixel_randomize = 1

/obj/item/salvage/electronic
	name = "handheld electronic device"
	desc = "A handheld device with a display."
	desc_lore = "Scanners of all shape and form, handheld displays and other small electronic devices are extremely common across ships due to their reliance on computer systems and can be salvaged for metals and alloys."
	salvage_contents = list(
	"metal" = 5,
	"resin" = 0,
	"alloy" = 5,
	)
	icon = 'icons/sectorpatrol/salvage/items/electronic.dmi'
	icon_state = "electronic"

/obj/item/salvage/electronic/random
	icon_state_max = 14
	salvage_random = 0
	pixel_randomize = 1

/obj/item/salvage/parts
	name = "electronic components"
	desc = "A small electronic part, most likely ripped from a bigger device."
	desc_lore = "Electronic components of bigger machines, separated from their original devices, and are likely useless.  Yields alloys when salvaged."
	salvage_contents = list(
	"metal" = 0,
	"resin" = 0,
	"alloy" = 5,
	)
	icon = 'icons/sectorpatrol/salvage/items/parts.dmi'
	icon_state = "parts"

/obj/item/salvage/parts/random
	icon_state_max = 18
	salvage_random = 0
	pixel_randomize = 1

/obj/item/salvage/resources
	name = "raw metal alloys"
	desc = "A sheet of metal alloy"
	desc_lore = "These sheets are meant to be used with on-board fabricator devices to create components as needed and available. Unlike the PST's recovery method, the sheets are not particularly efficient and lack the versality of LD-enhanced materials. They can be recycled for a decent amount of alloy and base metals."
	salvage_contents = list(
	"metal" = 10,
	"resin" = 0,
	"alloy" = 10,
	)
	icon = 'icons/sectorpatrol/salvage/items/resources.dmi'
	icon_state = "resources"

/obj/item/salvage/resources/random
	icon_state_max = 8
	salvage_random = 0
	pixel_randomize = 1

/obj/item/salvage/tools
	name = "tool"
	desc = "A construction or maitenance tool."
	desc_lore = "These tools are almost identical to the ones provided to you by the UACM. The biggest difference is that like everything created on the PST, your tools have Liquid Data traces in them that let Pythia perceive them as objects as well. These tools will need to be broken down and remade to serve a similar purpose. Yields a small amount of alloy and metals."
	salvage_contents = list(
	"metal" = 5,
	"resin" = 5,
	"alloy" = 0,
	)
	icon = 'icons/sectorpatrol/salvage/items/tools.dmi'
	icon_state = "tools"

/obj/item/salvage/tools/random
	icon_state_max = 7
	salvage_random = 0
	pixel_randomize = 1
