/datum/job/marine/xenosurge/base
	title = "Survivor - Warden"
	gear_preset = /datum/equipment_preset/uscm/xenosurge/base
	entry_message_body = "You are a Survivor. Follow the Warden's directions. For now."

/datum/equipment_preset/uscm/xenosurge/base
	name = "Survivor - Warden"
	flags = EQUIPMENT_PRESET_MARINE
	assignment = "Survivor - Warden"
	job_title = "Survivor - Warden"
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = ""
	skills = /datum/skills/synthetic
	minimap_icon = "private"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/xenosurge/base/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/uscm/xenosurge/base/load_status(mob/living/carbon/human/new_human)
	return //No cryo munchies

/datum/equipment_preset/uscm/xenosurge/base/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(new_human), WEAR_L_EAR)
