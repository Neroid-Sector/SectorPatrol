// Sector Patrol Pesistance Dorm Mechanics
// Master def file

// Dorm button and button claiming.

/obj/structure/dorm_button
	name = "wall mounted button"
	desc = "A button. It can be pushed. Most likely will trigger things."
	desc_lore = "While this button does not appear to be in any way unusual, it is linked to a central dorm database and can be used, along with a properly working and chipped UACM PST id card, to 'claim' or 'unclaim' a dorm room. These functions should be available via right click menu of the item."
	icon = 'icons/sectorpatrol/buttons/dorm_control.dmi'
	icon_state = "dorm_button"
	var/dorm_owner_name
	var/dorm_id_tag = "default" // This needs to have unique values for each room or it will not save between rounds right

/obj/structure/dorm_button/proc/update_owner() // Copies owner to area. Copies area tag as a failsafe as well so saving reflects in round changes.
	var/area/ovpst/dorm/area = get_area(src)
	area.dorm_id_tag = dorm_id_tag
	if(dorm_owner_name == null)
		area.dorm_owner_name = null
		area.dorm_id_tag = initial(area.dorm_id_tag)
		dorm_id_tag = area.dorm_id_tag
		area.dorm_primary_storage = null
		return
	area.dorm_owner_name = dorm_owner_name
	area.dorm_id_tag = dorm_id_tag

/obj/structure/dorm_button/verb/claim() //Claims/unclaims rooms
	set category = "Object"
	set name = "Claim or unclaim dorm room"
	set src in view(1)
	if(usr.is_mob_incapacitated())
		return

	if(ishuman(usr))
		if(dorm_owner_name == null)
			if(GLOB.dorms_name_list.Find(usr.name) == 0)
				GLOB.dorms_name_list += usr.name
				dorm_owner_name = usr.name
				to_chat(usr, SPAN_INFO("Dorm Claimed."))
				update_owner()
				return
			else
				to_chat(usr, SPAN_WARNING("Error: You appear to have already claimed a dorm. Please unclaim your current dorm room before trying to claim another one."))
		if(dorm_owner_name)
			if(dorm_owner_name == usr.name)
				GLOB.dorms_name_list -= usr.name
				dorm_owner_name = null
				to_chat(usr, SPAN_INFO("Dorm Unclaimed."))
				update_owner()
				return
			else
				to_chat(usr, SPAN_INFO("This dorm is claimed by someone else."))
				return

/obj/structure/dorm_button/verb/unclaim_primary_storage() //Unclaims Primary Storage
	set category = "Object"
	set name = "Clear Main Storage Assignment"
	set src in view(1)
	if(usr.is_mob_incapacitated())
		return

	if(ishuman(usr))
		if(dorm_owner_name)
			if(dorm_owner_name == usr.name)
				var/area/ovpst/dorm/area = get_area(src)
				if(area.dorm_primary_storage)
					var/obj/storage_object = area.dorm_primary_storage
					storage_object.dorms_PrimaryStorage = 0
					area.dorm_primary_storage = initial(area.dorm_primary_storage)
					to_chat(usr, SPAN_INFO("Primary Storage unclaimed."))
					return
				else
					to_chat(usr, SPAN_INFO("No Primary Storage Set"))
					return
			else
				to_chat(usr, SPAN_INFO("This dorm is claimed by someone else."))
				return

/obj/structure/dorm_button/Initialize(mapload, ...)
	. = ..()
	GLOB.dorms_button_list += src
	update_owner()

/area/ovpst/dorm
	name = "OV-PST Dorm Area"
	desc = "General Dorms Def"
	icon = 'icons/sectorpatrol/areas/ovpst_dorms.dmi'
	icon_state = "dorms"
	var/dorm_owner_name // Set from the buttons and will be overriden by them in game.
	var/dorm_id_tag = "default" // USE UNIQUE AREA DEFINITIONS FOR EACH DORM. Set from the buttons and will be overriden by them in game.
	var/dorm_primary_storage

