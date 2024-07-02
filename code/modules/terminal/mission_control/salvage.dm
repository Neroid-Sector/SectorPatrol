/obj/structure/terminal/mc_salvage
	name = "mission control terminal"
	item_serial = "OV-PST-MC-SALVAGE-RC3"
	desc = "A terminal labeled 'Mission Control', looks almost like a regular computer terminal, however if you take a closer look a blue and pink shimmer seems to be visible inside the machine itself."
	desc_lore = "The current iteration of OV-PST made 'purpose' terminals, a term used to identify computer systems meant for specific purposes, comes with the same limitation as most other LD based system - once an OS is installed, it becomes very hard to modify it and major updates to its software typically mean replacing the whole terminal. </p><p> Since all the PST technology is effectively advanced prototypes, and taking the above into account, the terminals currently focus on modularity and ease of replacement not visual attractiveness or functionality and as such resemble the rather flimsy terminals used in current generation spaceships. Their potential, however, at least in theory, is supposed to be infinitely times greater."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_reserved_lines = 2
	terminal_id = "mission_control"

/obj/structure/terminal/mc_salvage/Initialize(mapload, ...)

	terminal_header += "<center><b>"+ html_encode("MISSION CONTROL RC3") + "</B><BR>" + html_encode("OV-PST TEST CREW"+"<BR>")
	terminal_header += html_encode("COMMANDS: HELP; RESOURCES; SPIKE") + "</center>"
	. = ..()

/obj/structure/terminal/mc_salvage/proc/terminal_spike(str)
	var/spike_string = str
	if(length(html_decode(spike_string)) == 5 || length(html_decode(spike_string)) == 6)
		var/list/spike_list = list()
		for (var/obj/structure/salvage/drone_spike/spike in GLOB.salvaging_active_spikes)
			if(get_turf(spike) != null)
				var/area/spike_area = get_area(spike)
				spike_list += "[spike.spike_serial] - [spike_area.name]"
		if(spike_list.len == 0)
			terminal_display_line("No active spikes detected.")
			return
		var/spike_output = (jointext((spike_list), "</p><p>"))
		terminal_display_line("Active Spikes found. Use SPIKE and spike number to activate. Ensure all personnel have vacated the area and all other salvage items, including floor plating, have been removed.")
		terminal_buffer += spike_output
		terminal_display()
	if(length(html_decode(spike_string)) > 6)
		var/spike_argument = text2num(copytext(spike_string, 7, 0))
		for (var/obj/structure/salvage/drone_spike/spike in GLOB.salvaging_active_spikes)
			if(spike.spike_serial == spike_argument)
				terminal_display_line("Spike found. Executing deconstruction command. Standby.")
				var/area/spike_area_to_decon = get_area(spike)
				switch(spike_area_to_decon.salvage_process_area_decon())
					if(2)
						terminal_display_line("Error. Loose items found in deconstruction area.")
						return
					if(3)
						terminal_display_line("Error. Heavy objects found in deconstruction area.")
						return
					if(4)
						terminal_display_line("Error. Obstruction on floors detected. Please remove any floor panneling.")
						return
					if(1)
						terminal_display_line("Success. Area deconstruction in progress.")
						qdel(spike)
						return



/obj/structure/terminal/mc_salvage/terminal_parse(str)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	var/cut_string_to_parse = copytext(string_to_parse, 1, 6)
	switch(string_to_parse)
		if("HELP")
			if(!(terminal_id in usr.saw_narrations))
				terminal_display_line("New user detected. Welcome, [usr.name]. Displaying help message:")
				terminal_display()
				usr.saw_narrations += terminal_id
			terminal_display_line("The Mission Control Terminal is used, as the name suggests, to control critical functions of a given mission.")
			terminal_display_line("For the purpose of this exercise, you have access to two important commands:")
			terminal_display_line("RESOURCES will tell you the estimates of gathered and remaining resources.")
			terminal_display_line("SPIKE is used to control salvaging spikes, specifically fire them off once they are set. Use the command without any arguments for information.")
			terminal_display_line("Good luck!")
		if("RESOURCES")
			terminal_display_line("Querrying resource estimates. Standby.", TERMINAL_LOOKUP_SLEEP)
			terminal_display_line("RESOURCES RECOVERED / ESTIMATED MAXIMUM:")
			terminal_display_line("METALS")
			terminal_display_line("[GLOB.resources_metal] / [GLOB.salvaging_total_metal]")
			terminal_display_line("RESINS")
			terminal_display_line("[GLOB.resources_resin] / [GLOB.salvaging_total_resin]")
			terminal_display_line("ALLOYS")
			terminal_display_line("[GLOB.resources_alloy] / [GLOB.salvaging_total_alloy]")
			terminal_display_line("LD-POLYMER")
			terminal_display_line("[(GLOB.resources_metal + GLOB.resources_resin + GLOB.resources_alloy) / 5] / [GLOB.salvaging_total_ldpol]")
	// Multi word commands start here. A little hacky, but will do. Essentially cuts the ammount of expected letters for the command and if that passes, passes the whole command to a separate parser that does the work. Use case can probably be defived form len or soemthing, but I really dont feel like calculating that atm :P
		else
			switch(cut_string_to_parse)
				if("SPIKE")
					terminal_display_line("Standby. Processing Spike Buffer Command.", TERMINAL_LOOKUP_SLEEP)
					terminal_spike(string_to_parse)
				else
					terminal_display_line("Unknown Command Error Message.")
	terminal_input()
