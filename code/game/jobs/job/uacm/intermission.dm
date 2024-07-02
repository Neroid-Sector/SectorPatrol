/datum/job/uacm/basepc
	title = JOB_UACM_BASEPC
	total_positions = -1
	spawn_positions = -1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uacm/basepc

/datum/job/uacm/basepc/generate_entry_message(mob/living/carbon/human/H)
	entry_message_intro = "[GLOB.start_narration_header]"
	entry_message_body = "[GLOB.start_narration_body]"
	entry_message_end = "[GLOB.start_narration_footer]"
	return ..()


/obj/effect/landmark/start/basepc
	name = JOB_UACM_BASEPC
	icon_state = "so_spawn"
	job = /datum/job/uacm/basepc
