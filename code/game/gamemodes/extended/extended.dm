/datum/game_mode/extended
	name = "Sector Patrol"
	config_tag = "Sector Patrol"
	required_players = 0
	latejoin_larva_drop = 0
	votable = FALSE
	var/research_allocation_interval = 10 MINUTES
	var/next_research_allocation = 0
	taskbar_icon = 'icons/taskbar/gml_sectorpatrol.png'

/datum/game_mode/announce()
	to_world("<B>Sector Patrol ALPHA</B>")
	show_blurb(GLOB.player_list, duration = 10 SECONDS, message = "<b>[GLOB.ingame_date]\n[GLOB.ingame_location]</b>\nLocal time: [time2text(GLOB.ingame_time,"hh:mm",0)]", screen_position = "CENTER,BOTTOM+1.5:16", text_alignment = "center", text_color = "#ffaef2", blurb_key = "introduction", ignore_key = FALSE, speed = 1)

/datum/game_mode/extended/get_roles_list()

	return GLOB.ROLES_SP_INTERMISSION


/datum/game_mode/extended/post_setup()
	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	initialize_post_marine_gear_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	round_time_lobby = world.time
	return ..()

/datum/game_mode/extended/process()
	. = ..()
	if(next_research_allocation < world.time)
		GLOB.chemical_data.update_credits(GLOB.chemical_data.research_allocation_amount)
		next_research_allocation = world.time + research_allocation_interval

/datum/game_mode/extended/check_finished()
	if(round_finished)
		return TRUE

/datum/game_mode/extended/check_win()
	return

/datum/game_mode/extended/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
	world << musical_track

	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = GLOB.clients.len
		GLOB.round_statistics.log_round_statistics()

	calculate_end_statistics()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()


	return TRUE
