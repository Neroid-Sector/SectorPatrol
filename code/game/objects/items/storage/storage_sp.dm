//PST Toolboxes
/obj/item/storage/toolbox/uacm/genericengie

	name = "UACM engraved Toolbox"
	desc = "A toolbox with the UACM insignia clearly visible on top. Sturdier and heavier than one would expect when picked up."
	desc_lore = "Toolboxes made from surprisingly tough and heavy plastics joined mankind on their rapid ascent to the stars and have always been used for one of two purposes. The intended one - storage of tools, parts and other replacements needed for fixing devices around the area a toolbox is stored in and the unintended one - using their surprising weight and robustness to turn them into an effective weapon. Spacer rumors claim that it was a toolbox that was used to commit mankind's first murder in space, but there are at least 10 separate conflicting accounts related to that claim making it hard to verify."
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	attack_verb = list("hit")
	item_serial_distance = SERIAL_ITEM_SIZE_CLOSE

/obj/item/storage/toolbox/uacm/genericengie/fill_preset_inventory()
	new /obj/item/tool/screwdriver/uacm(src)
	new /obj/item/tool/wrench/uacm(src)
	new /obj/item/tool/crowbar/uacm(src)
	new /obj/item/tool/wirecutters/uacm(src)
	new /obj/item/device/multitool/uacm(src)
	new /obj/item/tool/drill/uacm(src)

/obj/item/storage/backpack/satchel/discrete
	name = "discrete satchel"
	desc = "A small satchel worn under clothing, obscured from view unless one knows to look for it or is performing a direct search."
	icon = 'icons/obj/sp_clothes/back/icon/back.dmi'
	icon_state = "satchel_black"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 30
	item_icons = list(
	WEAR_BACK = 'icons/obj/sp_clothes/back/onmob/back.dmi'
	)
