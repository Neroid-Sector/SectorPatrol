/datum/equipment_preset/uacm
	name = "UACM"

/datum/equipment_preset/uacm/basepc
	name = "UACM OV-PST Test Crew Officer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_UACM_BASEPC
	rank = JOB_UACM_BASEPC
	paygrade = "NO1"
	role_comm_title = "PST-TCR"
	skills = /datum/skills/SO
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT)

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uacm/basepc/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_standard(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/uacm/uniform_standard(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_L_STORE)

/datum/equipment_preset/uacm/newpc
	name = "UACM Comissioned Officer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_UACM_NEWPC
	rank = JOB_UACM_NEWPC
	paygrade = "NO1"
	role_comm_title = "Officer"
	skills = /datum/skills/SO
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT)

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uacm/newpc/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_standard(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/uacm/uniform_standard(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_L_STORE)

/datum/equipment_preset/uacm/rdml
	name = "UACM Rear Admiral (lower half)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/general
	assignment = JOB_UACM_RDML
	rank = JOB_UACM_RDML
	paygrade = "NO7"
	role_comm_title = "RDML"
	skills = /datum/skills/general
	languages = ALL_HUMAN_LANGUAGES

/datum/equipment_preset/uacm/rdml/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_extended(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/dress/blues/general(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/dress(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/marine/dress_cover/officer(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer(new_human), WEAR_JACKET)

/datum/equipment_preset/uacm/cmisrs_lt
	name = "CMISRS Intelligence Coordinator"
	skills = /datum/skills/CMP

	assignment = JOB_UACM_CMISRS_LT
	rank = JOB_UACM_CMISRS_LT
	paygrade = "NO3"
	role_comm_title = "IC"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_HUMAN_LANGUAGES

/datum/equipment_preset/uacm/cmisrs_lt/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel/sec
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/security

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_extended(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/uacm/cmisrs_inspector(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/provost(new_human), WEAR_JACKET)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/uacm/cmisrs(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_L_STORE)

/datum/equipment_preset/uacm/psteng
	name = "UACM PST Station Engineer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_UACM_PSTENG
	rank = JOB_UACM_PSTENG
	paygrade = "NO3"
	role_comm_title = "PST-ENG"
	skills = /datum/skills/CE
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_HUMAN_LANGUAGES

	access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT, ACCESS_SP_OVPST_SECURITY_DEFAULT, ACCESS_SP_OVPST_ENGINEERING_DEFAULT, ACCESS_SP_ADMIN)

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uacm/psteng/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_extended(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/uacm/jumpsuit_engie(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/uacm/engie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_L_STORE)

/datum/equipment_preset/uacm/Cassandra
	name = "OV-PST Cassandra - Dress"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_UACM_CASSANDRA
	rank = JOB_UACM_CASSANDRA
	paygrade = "NO5"
	role_comm_title = "PST-CSO"
	skills = /datum/skills/general
	languages = ALL_HUMAN_LANGUAGES
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT, ACCESS_SP_OVPST_SECURITY_DEFAULT, ACCESS_SP_OVPST_ENGINEERING_DEFAULT, ACCESS_SP_ADMIN)

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uacm/Cassandra/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_extended(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/sp_admin/(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sp_admin/(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/discrete(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/sp_admin/(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_L_STORE)

/datum/equipment_preset/uacm/Alysia
	name = "OV-PST Alysia - Dress"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_UACM_ALYSIA
	rank = JOB_UACM_ALYSIA
	paygrade = "NO5"
	role_comm_title = "PST-CE"
	skills = /datum/skills/general
	languages = ALL_HUMAN_LANGUAGES
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT, ACCESS_SP_OVPST_SECURITY_DEFAULT, ACCESS_SP_OVPST_ENGINEERING_DEFAULT, ACCESS_SP_ADMIN)

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uacm/Alysia/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/uacm/pst_extended(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/sp_admin/aly(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sp_admin/aly(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/discrete(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/sp_admin/Aly(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_L_STORE)
