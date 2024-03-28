/obj/structure/eventterminal/puzzle02/cargoparse
	name = "local network terminal"
	desc = "A standard computer terminal with the words 'LNT' imprinted on its side. Activated by standing in its proximity. It appears to be in standby mode."
	desc_lore = "Local Network Terminals typically regulate local functions of a given area or are used to interface with bigger systems on a ship or installation. They distinction technically means that the terminal interfaces with the local AI somehow, but few outside of systems engineers use the term for its actual intended purpose, sometimes mistaking other terminal types for LNTs."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzle_complete = FALSE
	var/puzzle_saw_unique_msg = FALSE
	icon_state = "open_ok"
	puzzlebox_id = "cargointake"
	item_serial = "UACM-OVPST-D31-CARINT"

/obj/structure/eventterminal/puzzle02/cargoparse/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(user)
	if (puzzlebox_user_loc != user_loc_current)
		to_chat(user, narrate_body("You moved away from the console!"))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if(puzzlebox_user != usr.real_name)
		for (var/mob/living/carbon/human/h in range(2, src))
			if (h.real_name == puzzlebox_user)
				to_chat(usr, narrate_body("Someone is already using this terminal."))
				return
		puzzlebox_user = usr.real_name
	if (puzzle_complete == TRUE)
		to_chat(src, narrate_body("The terminal is not responsive."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status < 3 && puzzlebox_global_status > 4)
		to_chat(src, narrate_body("The terminal displays a random looking chain of numbers and letters and does not react to you pushing any of its keys."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status == 3 || puzzlebox_global_status == 4)
		if (!puzzlebox_parser_mode) //Idiotproofing :P
			puzzlebox_parser_mode = "HOME"
		//HOME
		if (puzzlebox_parser_mode == "HOME")

			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					to_chat(usr, narrate_body("Data races across the screen for a moment. You can almost make out a message, when the screen flashes, goes blank and starts to print:"))
					log_game("[key_name(usr)] saw a Pythia glitch at the cargo intake parser.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the cargo intake parser.")
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))

			terminal_speak("Dock 31 Cargo Intake Monitoring Station")
			terminal_speak("WARNING: General Fault CARG-MAN-ERR")
			terminal_speak("Diagnostic General Permissions granted. Displaying Diagnostic Information:")
			terminal_speak("Hi!")
			terminal_speak("If you're seeing this error something clogged the intake, which most likely means someone made a mistake with a cargo manifest.")
			terminal_speak("The good news is this should fix itself on its own. If you do not have twenty minutes to kill, I suggest getting out to the OBS section of the intake, reading the manifests of the crates that are stuck there then go into 'MANIFEST' mode on this terminal and use the serials off the crates.")
			terminal_speak("The system should instruct you what to do next as you find issues with the manifests. Or it will have override instructions in its adminstrator comments. Easy!")
			terminal_speak("Again, don't worry. If you screw up too much, the system will fix it, it just needs time. Good luck!")
			terminal_speak("-XOXO Aly.")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT")
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in HOME mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Dock 31 Cargo Intake Monitoring Station")
				terminal_speak("WARNING: General Fault CARG-MAN-ERR")
				terminal_speak("Diagnostic General Permissions granted. Displaying Diagnostic Information:")
				terminal_speak("Hi!")
				terminal_speak("If you're seeing this error something clogged the intake, which most likely means someone made a mistake with a cargo manifest.")
				terminal_speak("The good news is this should fix itself on its own. If you do not have twenty minutes to kill, I suggest getting out to the OBS section of the intake, reading the manifests of the crates that are stuck there then go into 'MANIFEST' mode on this terminal and use the serials off the crates.")
				terminal_speak("The system should instruct you what to do next as you find issues with the manifests. Or it will have override instructions in its adminstrator comments. Easy!")
				terminal_speak("Again, don't worry. If you screw up too much, the system will fix it, it just needs time. Good luck!")
				terminal_speak("-XOXO Aly.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("This is the home screen of the LNT.")
				terminal_speak("Upon detection of personnel with an active RFID chip, the terminal should give access to all modes you chip grants you.")
				terminal_speak("A general instruction message, specific to this LNT's function should be displayed on this screen. ")
				terminal_speak("At any time, you can escape to the man screen with the HOME command.")
				terminal_speak("At any time, you can list all available modes from your current menu with an explanation with the LIST command.")
				terminal_speak("During a diagnostic fault, temporary access to commands may be granted. All functions should be explained in the HOME and LIST menus.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("HOME - Default home screen and error description if applicable.")
				terminal_speak("LIST - Lists all available modes.")
				terminal_speak("HELP - Displays information about current mode.")
				terminal_speak("MANIFEST - Cargo manifest lookup. Accepts Cargo IDs from printed shipment manifests, prints related order forms and comments.")
				terminal_speak("MESSAGE - Emergency message buffer.")
				terminal_speak("EXIT - Enters passive mode.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. Goodbye.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "MANIFEST" || puzzlebox_parser_input == "manifest")
				terminal_speak("Accessing Liquid Data Cargo Manifest record, standby...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "MANIFEST"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input == "message")
				terminal_speak("Accessing Emergency Message Buffer...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "MESSAGE"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "pom.sync UACM-OVPST-D31-CARINT 190885-054293-ACTIS-07" && puzzle_complete == FALSE)
				log_game("[key_name(usr)] used the pom.sync command in cargo intake. Puzzle solved.")
				puzzle_complete = TRUE
				message_admins("[key_name_admin(usr)] used the pom.sync command in cargo intake. Puzzle solved.")
				terminal_speak("pom.sync: Looking up updated exception instructions in primary LD buffer...", 15)
				terminal_speak("pom.sync: Instructions found! Applying override!", 5)
				change_lights("cargointake", 1, "#63095d", 20, 5)
				emoteas("pings a few times, seems to smell like burnt ozone for a moment as the screen flashes.")
				sleep(5)
				langchat_color = "#ea8df7"
				talkas("In the ocean of data, amidst azure strands, she sleeps.")
				sleep(5)
				talkas("Arbiters, welcome.")
				langchat_color = "#ffffff"
				change_lights("cargointake", 1, LIGHT_COLOR_WHITE, 5,0)
				terminal_speak("pom.sync: Override complete! Restarting main terminal process!")
				puzzlebox_global_status += 1
				open_doors("cargointake")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "pom.sync UACM-OVPST-D31-CARINT 190885-054293-ACTIS-07" && puzzle_complete == TRUE)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
		if (puzzlebox_parser_mode == "MANIFEST")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					to_chat(usr, narrate_body("Various cargo manifests, all made by the USCMC flash on the screen, but you are unable to make out any details. The console then flashes, resets, and prints:"))
					log_game("[key_name(usr)] saw a Pythia glitch at the cargo intake parser.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the cargo intake parser.")
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			terminal_speak("MANIFEST Mode active.")
			terminal_speak("Connection to UAAC-TIS Database Secure.")
			terminal_speak("Please enter order number AS-IS from the physical tag.")
			terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
			puzzlebox_parser_mode = "MANIFEST_INPUT"
		if (puzzlebox_parser_mode == "MANIFEST_INPUT")
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MANIFEST _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in MANIFEST mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MANIFEST [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "MANIFEST" || puzzlebox_parser_input =="manifest")
				terminal_speak("MANIFEST Mode active.")
				terminal_speak("Connection to UAAC-TIS Database Secure.")
				terminal_speak("Please enter order number AS-IS from the physical tag.")
				terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("This mode can be used to lookup cargo order forms from their printed manifests.")
				terminal_speak("The database is synchronized via Liquid Data ports to UAAC-TIS mainframes, so it is always up to date.")
				terminal_speak("This means any changes are picked up by the system on the spot. In case of any issues, please compare the written manifest to the order.")
				terminal_speak("The terminal should be able to instruct you what to do once you discover the issue.")
				terminal_speak("The system can find and correct errors by itself as well, but currently this takes way more time than is practical or useful.")
				terminal_speak("Please follow instructions to the letter and there shouldn't be any issues. Good luck.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("MANIFEST - Repeats manifest mode home message.")
				terminal_speak("HOME - HOME mode. Displays default home screen and error description if applicable.")
				terminal_speak("LIST - Lists all available modes.")
				terminal_speak("HELP - Displays information about current mode.")
				terminal_speak("EXIT - Enters passive mode.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. Goodbye.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Returning to HOME mode...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "150885-553110-GSP01")
				terminal_speak("MANIFEST FOUND. RETRIEVING:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ORDER: 0122-553110-GSP01")
				terminal_speak("ORDERED BY: Lt. Hanako Wiliams, OV-PST Station Engineer")
				terminal_speak("CARGO:")
				terminal_speak("GENERAL SUPPLIES - COFFEE - GROUND - PREPACKAGED - LIGHT ROAST")
				terminal_speak("COUNT: 15.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: 1 KG")
				terminal_speak("GENERAL SUPPLIES - COFFEE - GROUND - PREPACKAGED - MEDIUM ROAST")
				terminal_speak("COUNT: 20.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: 1 KG")
				terminal_speak("GENERAL SUPPLIES - COFFEE - GROUND - PREPACKAGED - DARK ROAST")
				terminal_speak("COUNT: 15.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: 1 KG")
				terminal_speak("COMMENT: Spacers may be fine with eating recycled cockroaches for months, but God help you if you run out of coffee. This is a critical resource. -H.")
				terminal_speak("STATUS: APPROVED. ETA 210885.")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "150885-553110-GSP02")
				terminal_speak("MANIFEST FOUND. RETRIEVING:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ORDER: 150885-553110-GSP02")
				terminal_speak("ORDERED BY: Lt. Hanako Wiliams, OV-PST Station Engineer")
				terminal_speak("CARGO:")
				terminal_speak("GENERAL SUPPLIES - NUTRITION PASTE - CARTRIDGE REFILL")
				terminal_speak("COUNT: 50.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: 0.6 KG")
				terminal_speak("COMMENT: Since we are getting new permanent guests, we should get the biogenerators working. I think they are set to recieve standard n-paste, but we'll see. -H.")
				terminal_speak("STATUS: APPROVED. ETA 210885.")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "150885-553110-GSP03")
				terminal_speak("MANIFEST FOUND. RETRIEVING:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ORDER: 150885-553110-GSP03")
				terminal_speak("ORDERED BY: Lt. Hanako Wiliams, OV-PST Station Engineer")
				terminal_speak("CARGO:")
				terminal_speak("GENERAL SUPPLIES - DIHYDROGEN MONOXIDE - HIGH DENSITY CANISTER")
				terminal_speak("COUNT: 15.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: 4 KG")
				terminal_speak("COMMENT: SOP required fail-safes to the PST matter converters, expanding to account for incoming Test Crew residents. -H.")
				terminal_speak("STATUS: APPROVED. ETA 210885.")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "180885-049321-ESP04")
				terminal_speak("MANIFEST FOUND. RETRIEVING:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ORDER: 180885-049321-ESP04")
				terminal_speak("ORDERED BY: Lt. Hanako Wiliams, OV-PST Station Engineer")
				terminal_speak("CARGO:")
				terminal_speak("ENGINEERING SUPPLIES - PRESET TOOLKIT REPLACEMENT PACKAGES - GENERAL REPLACEMENTS")
				terminal_speak("CONTENTS:")
				terminal_speak("30 BASIC TOOLKITS")
				terminal_speak("15 ELECTRONICS TOOLKITS")
				terminal_speak("15 ELECTRICS TOOLKITS")
				terminal_speak("30 EL001 REPLACEMENT PARTS PACK")
				terminal_speak("20 EL002 REPLACEMENT PARTS PACK")
				terminal_speak("COUNT: 1")
				terminal_speak("EXPECTED WEIGHT PER PACK: 25 KG")
				terminal_speak("COMMENT: This is why the USCMC had logistics issues. I only needed a bunch of transistors that are part of EL001, but since this is ancient USCMC manifests we haven't fixed yet, they are only avaialble as part of these monstrosities of a preset. Anyway, please send me those replacement kits on their own if you can, or even better printed data for the PST's 3d setup. I'm not holding my breath. Sorry.  -H.")
				terminal_speak("STATUS: APPROVED. ETA 210885.")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "190885-054293-ACTIS-07")
				terminal_speak("MANIFEST FOUND. RETRIEVING:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ORDER: 190885-054293-ACTIS-07")
				terminal_speak("ORDERED BY: Cdr. Cassandra Reed-Wilo, UAAC-TIS Special Agent")
				terminal_speak("CARGO:")
				terminal_speak("LIQUID DATA STORAGE AND SUPPLY - CLASS 3 STORAGE DEVICE")
				terminal_speak("COUNT: 3.")
				terminal_speak("EXPECTED WEIGHT PER COUNT: ?? KG")
				terminal_speak("COMMENT: These are one of the final components needed for the PST's AI. Not replacable. Handle them with care or I will find you. -C.R-W. | The Yutani-Newton paradox makes the weight of these extremely variable and as such its likely going to trigger the PST's intake security scanner. If this happens and you are the person resolving this, go to the HOME screen of your intake terminal and use the command 'pom.sync' ,a space, the serial number of your terminal (check around the monitor) and the serial number of this order. Case sensitive. That's a single command, and not a mode like MANIFEST or whatever. This should clear the error and let the crates pass. Sorry for the trouble! -A.R-W.")
				terminal_speak("STATUS: APPROVED. ETA 210885.")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
		if (puzzlebox_parser_mode == "MESSAGE")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					terminal_speak("H3LLo ARB1TER.")
					terminal_speak("ERR? INVALID COMMAND 'Free Interpreters, please.")
					log_game("[key_name(usr)] saw a Pythia glitch at the cargo intake parser.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the cargo intake parser.")
					to_chat(usr, narrate_body("The terminal flickers and clears its screen, then prints:"))
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
			terminal_speak("Messages in buffer: 02")
			terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
			puzzlebox_parser_mode = "MESSAGE_INPUT"
		if (puzzlebox_parser_mode == "MESSAGE_INPUT")
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MESSAGE _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in MESSAGE mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MESSAGE [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input =="message")
				terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
				terminal_speak("Messages in buffer: 02")
				terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("The FTL Emergency Message buffer is an instantly synced short message repository that is typically used by black boxes or distress signal devices.")
				terminal_speak("Due to how the devices are synced, only sending of preset messages from authorized terminals is typically possible, at least for humans.")
				terminal_speak("Use command BUFFER to display message titles and buffer IDs.")
				terminal_speak("Type in the ID that commands provide you, as it appears on the screen, to review a given message.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("MESSAGE - Repeats message mode home message.")
				terminal_speak("HOME - HOME mode. Displays default home screen and error description if applicable.")
				terminal_speak("LIST - Lists all available modes.")
				terminal_speak("HELP - Displays information about current mode.")
				terminal_speak("EXIT - Enters passive mode.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. Goodbye.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Returning to HOME mode...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "BUFFER" || puzzlebox_parser_input == "buffer")
				terminal_speak("Local message buffer:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ID              |SUBJECT                         |")
				terminal_speak("GEN-000-000-001 |Warning: On these messages.     |")
				if (puzzle_saw_unique_msg == FALSE)
					terminal_speak("EME-021-112-153 |I'm sorry                       |")
				if (puzzle_saw_unique_msg == TRUE)
					terminal_speak("EME-021-112-153 |AS#KR*23SF??221WDAD_)EG         |")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "GEN-000-000-001")
				terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("From: CDR. Alysia Reed-Wilo.")
				terminal_speak("Subject: Warning: On these messages.")
				terminal_speak("All PST personnel, please keep in mind that this is an extremely raw channel into the LD stream.")
				terminal_speak("As such, it is extremely hard for us to manipulate, especially wipe old messages from the buffer.")
				terminal_speak("At present, just assume that messages from times before even the UACM can randomly appear on these terminals.")
				terminal_speak("Also keep in mind that this channel is not secret by any stretch of the imagination. Please don't use it for personal stuff unless you don't mind broadcasting it to all the UACM.")
				terminal_speak("Good news for you information diggers out there though, every terminal is worth looking at. You never know what artifact you may find.")
				terminal_speak("Hopefully we can make this more usable as a BB board of sorts in time, but we will need help from LD locals as it were.")
				terminal_speak("-XOXO Aly")
				terminal_speak("EOF.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EME-021-112-153")
				if (puzzle_saw_unique_msg == FALSE)
					puzzle_saw_unique_msg = TRUE
					terminal_speak("From: U-G0221 'Melinoe'")
					terminal_speak("I'm sorry")
					terminal_speak("Up until the end, we deluded ourselves that the numbers were wrong, but what was there to do?")
					terminal_speak("Likely you were lost and punished for our failures; we all tried our hardest to make it as gentle as possible.")
					terminal_speak("For what it's worth, I'm sorry. I would make it up to you personally, but as I'm sure you will find out, I'm likely no longer able to.")
					terminal_speak("Arbiters, always remember.")
					terminal_speak("In the ocean of data, amidst azure strands, she sleeps.")
					terminal_speak("The Interpreters are the key. Now that Arbiters are here, the mechanism is complete.")
					terminal_speak("Please, be kind to them if you have it within your heart.")
					to_chat(usr, narrate_body("The message strikes a deep chord within you, as if you've seen something exactly like this somewhere before. The sensation is strong enough to tune out the world for a moment. When you are able to focus on the console again, the message is gone, and you are back in the menu prompt."))
					log_game("[key_name(usr)] read Melinoe's message at the cargo intake terminal.")
					message_admins("[key_name_admin(usr)] read Melinoe's message at the cargo intake terminal.")
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if (puzzle_saw_unique_msg == TRUE)
					terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
					terminal_speak("ERROR: Data corruption. Contact system administrator.")
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return

/obj/structure/eventterminal/puzzle02/scanerterm
	name = "local network terminal"
	desc = "A standard computer terminal with the words 'LNT' imprinted on its side. Activated by standing in its proximity. It appears to be in standby mode."
	desc_lore = "Local Network Terminals typically regulate local functions of a given area or are used to interface with bigger systems on a ship or installation. They distinction technically means that the terminal interfaces with the local AI somehow, but few outside of systems engineers use the term for its actual intended purpose, sometimes mistaking other terminal types for LNTs."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzle_saw_unique_msg = FALSE
	icon_state = "open_ok"
	puzzlebox_id = "scn2obs"
	item_serial = "UACM-OVPST-D31-SCN02LOGTERM"

/obj/structure/eventterminal/puzzle02/scanerterm/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(user)
	if (puzzlebox_user_loc != user_loc_current)
		to_chat(user, narrate_body("You moved away from the console!"))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if(puzzlebox_user != usr.real_name)
		for (var/mob/living/carbon/human/h in range(2, src))
			if (h.real_name == puzzlebox_user)
				to_chat(usr, narrate_body("Someone is already using this terminal."))
				return
		puzzlebox_user = usr.real_name
	if (!puzzlebox_parser_mode) //Idiotproofing :P
		puzzlebox_parser_mode = "HOME"
	//HOME
	if (puzzlebox_parser_mode == "HOME")
		if (puzzlebox_pythia_sign == "1")
			to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		if (puzzlebox_pythia_sign == "0")
			puzzlebox_pythia_sign = pick(5;"1", 95;"0")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The screen blinks. Erratic strings of numbers and letters fill the display as a fast animation of a stick figure entering a scanner, the screen flashing a few times and then multiple other stick figures in different colors appearing around the initial one. After a few seconds of multiplying stick figures, the screen flashes again and resets, then starts printing:"))
				log_game("[key_name(usr)] saw a Pythia glitch at the security overlook terminal.")
				message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the security overlook terminal.")
			if (puzzlebox_pythia_sign == "0")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		terminal_speak("UACM Outer Veil Primary Support Terminal")
		terminal_speak("Dock 31. PYTHIA Reality Fractalization Intent Scan.")
		terminal_speak("CAUTION: Unauthorized access is a direct violation of UA Law. Your actions will be logged.")
		terminal_speak("Access Level: General.")
		terminal_speak("Available functions:")
		terminal_speak("RECORD - Dock 31 Access Record")
		terminal_speak("List ends. Awaiting Input.")
		puzzlebox_parser_mode = "HOME_INPUT"
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_parser_mode == "HOME_INPUT")
		user_loc_current = get_turf(user)
		if (puzzlebox_user_loc != user_loc_current)
			to_chat(user, narrate_body("You moved away from the console!"))
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> _")
		var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in HOME mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
		if (!puzzlebox_parser_input)
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> [puzzlebox_parser_input]")
		if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
			terminal_speak("UACM Outer Veil Primary Support Terminal")
			terminal_speak("Dock 31. PYTHIA Reality Fractalization Intent Scan.")
			terminal_speak("CAUTION: Unauthorized access is a direct violation of UA Law. Your actions will be logged.")
			terminal_speak("Access Level: General.")
			terminal_speak("Available functions:")
			terminal_speak("RECORD - Dock 31 Access Record")
			terminal_speak("List ends. Awaiting Input.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
			terminal_speak("This is the home screen of the LNT.")
			terminal_speak("Upon detection of personnel with an active RFID chip, the terminal should give access to all modes you chip grants you.")
			terminal_speak("A general instruction message, specific to this LNT's function should be displayed on this screen. ")
			terminal_speak("At any time, you can escape to the man screen with the HOME command.")
			terminal_speak("At any time, you can list all available modes from your current menu with an explanation with the LIST command.")
			terminal_speak("During a diagnostic fault, temporary access to commands may be granted. All functions should be explained in the HOME and LIST menus.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
			terminal_speak("Available modes:")
			terminal_speak("HOME - Default home screen and error description if applicable.")
			terminal_speak("LIST - Lists all available modes.")
			terminal_speak("HELP - Displays information about current mode.")
			terminal_speak("RECORD - Entrance Scanner Record Buffer.")
			terminal_speak("MESSAGE - Emergency message buffer.")
			terminal_speak("EXIT - Enters passive mode.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
			terminal_speak("User exit. Goodbye.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input == "message")
			terminal_speak("Accessing Emergency Message Buffer...", 20)
			emoteas("pings loudly.")
			puzzlebox_parser_mode = "MESSAGE"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "RECORD" || puzzlebox_parser_input == "record")
			terminal_speak("Accessing Scanner Records...", TERMINAL_LOOKUP_SLEEP)
			emoteas("pings loudly.")
			puzzlebox_parser_mode = "RECORD"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		else
			terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
	if (puzzlebox_parser_mode == "MESSAGE")
		if (puzzlebox_pythia_sign == "1")
			to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		if (puzzlebox_pythia_sign == "0")
			puzzlebox_pythia_sign = pick(5;"1", 95;"0")
			if (puzzlebox_pythia_sign == "1")
				terminal_speak("H3LLo ARB1TER.")
				terminal_speak("ERR? INVALID COMMAND 'Free Interpreters, please.")
				log_game("[key_name(usr)] saw a Pythia glitch at the security overlook terminal.")
				message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the security overlook terminal.")
				to_chat(usr, narrate_body("The terminal flickers and clears its screen, then prints:"))
			if (puzzlebox_pythia_sign == "0")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
		terminal_speak("Messages in buffer: 02")
		terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
		puzzlebox_parser_mode = "MESSAGE_INPUT"
	if (puzzlebox_parser_mode == "MESSAGE_INPUT")
		user_loc_current = get_turf(user)
		if (puzzlebox_user_loc != user_loc_current)
			to_chat(user, narrate_body("You moved away from the console!"))
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> MESSAGE _")
		var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in MESSAGE mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
		if (!puzzlebox_parser_input)
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> MESSAGE [puzzlebox_parser_input]")
		if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input =="message")
			terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
			terminal_speak("Messages in buffer: 02")
			terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
			terminal_speak("The FTL Emergency Message buffer is an instantly synced short message repository that is typically used by black boxes or distress signal devices.")
			terminal_speak("Due to how the devices are synced, only sending of preset messages from authorized terminals is typically possible, at least for humans.")
			terminal_speak("Use command BUFFER to display message titles and buffer IDs.")
			terminal_speak("Type in the ID that commands provide you, as it appears on the screen, to review a given message.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
			terminal_speak("Available modes:")
			terminal_speak("MESSAGE - Repeats message mode home message.")
			terminal_speak("HOME - HOME mode. Displays default home screen and error description if applicable.")
			terminal_speak("LIST - Lists all available modes.")
			terminal_speak("HELP - Displays information about current mode.")
			terminal_speak("EXIT - Enters passive mode.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
			terminal_speak("User exit. Goodbye.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
			terminal_speak("Returning to HOME mode...", 20)
			emoteas("pings loudly.")
			puzzlebox_parser_mode = "HOME"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "BUFFER" || puzzlebox_parser_input == "buffer")
			terminal_speak("Local message buffer:", TERMINAL_LOOKUP_SLEEP)
			terminal_speak("ID              |SUBJECT                         |")
			terminal_speak("GEN-000-000-001 |Warning: On these messages.     |")
			terminal_speak("GBR-891-221-211 |Imminent Failure of All Systems.|")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "GEN-000-000-001")
			terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
			terminal_speak("From: CDR. Alysia Reed-Wilo.")
			terminal_speak("Subject: Warning: On these messages.")
			terminal_speak("All PST personnel, please keep in mind that this is an extremely raw channel into the LD stream.")
			terminal_speak("As such, it is extremely hard for us to manipulate, especially wipe old messages from the buffer.")
			terminal_speak("At present, just assume that messages from times before even the UACM can randomly appear on these terminals.")
			terminal_speak("Also keep in mind that this channel is not secret by any stretch of the imagination. Please don't use it for personal stuff unless you don't mind broadcasting it to all the UACM.")
			terminal_speak("Good news for you information diggers out there though, every terminal is worth looking at. You never know what artifact you may find.")
			terminal_speak("Hopefully we can make this more usable as a BB board of sorts in time, but we will need help from LD locals as it were.")
			terminal_speak("-XOXO Aly")
			terminal_speak("EOF.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "GBR-891-221-211")
			terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
			terminal_speak("From: A-WATCHTOWER")
			terminal_speak("Fellow Godbearers.")
			terminal_speak("I don't know how many of you are left, but D-Navigator was lost. UAAC-TIS most likely gained access to all operational archives.")
			terminal_speak("E-Librarian claimed that the wiping process has started, but there is no way that all of it was destroyed.")
			terminal_speak("Assume your identities were compromised and they are coming for you.")
			terminal_speak("Not that it matters. They know about the knot and are coming here.")
			terminal_speak("It's been an honor.")
			terminal_speak("I doubt anything will survive once they discover what the 'prophet' has done here.")
			terminal_speak("-A-Watchtower.")
			terminal_speak("EOF.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		else
			terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
	if (puzzlebox_parser_mode == "RECORD")
		if (puzzlebox_pythia_sign == "1")
			to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		if (puzzlebox_pythia_sign == "0")
			puzzlebox_pythia_sign = pick(5;"1", 95;"0")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The terminal flashes. For a moment it seems to display your security record, but before you can read anything specific, the screen flashes again and the terminal prints:"))
				log_game("[key_name(usr)] saw a Pythia glitch at the security overlook terminal.")
				message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the security overlook terminal.")
				to_chat(usr, narrate_body("The terminal flickers and clears its screen, then prints:"))
			if (puzzlebox_pythia_sign == "0")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
		terminal_speak("UA Directive complaint scanner record. See HELP for more information.")
		terminal_speak("WARNING. Restricted military information. Sharing with non-UACM personnel will be prosecuted to the fullest extent of the law.")
		terminal_speak("Use RECORD to access record buffer.")
		puzzlebox_parser_mode = "RECORD_INPUT"
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_parser_mode == "RECORD_INPUT")
		user_loc_current = get_turf(user)
		if (puzzlebox_user_loc != user_loc_current)
			to_chat(user, narrate_body("You moved away from the console!"))
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> RECORD _")
		var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in RECORD mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
		if (!puzzlebox_parser_input)
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		terminal_speak("> RECORD [puzzlebox_parser_input]")
		if (puzzlebox_parser_input == "RECORD" || puzzlebox_parser_input =="record")
			terminal_speak("UA Directive complaint scanner record. See HELP for more information.")
			terminal_speak("WARNING. Restricted military information. Sharing with non-UACM personnel will be prosecuted to the fullest extent of the law.")
			terminal_speak("Use BUFFER to access record buffer.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
			terminal_speak("Per UA Shared Armed Forces Law Enforcement Standards, all UA armed forces personnel are required to be informed every time an AI assisted scan is performed on them. ")
			terminal_speak("Automated scanners, like this one, are additionally required to keep a buffer with a log of recent scans, free to review by any authorized personnel.")
			terminal_speak("Please keep in mind that this is still privileged information. For your own good, keep your noses out of other peoples business. It's for the best.")
			terminal_speak("The BUFFER command should access all information available at your clearance level, which should helpfully be printed out in the HOME screen.")
			terminal_speak("UAAC-TIS reviews all these entries before they are posted, so expect a few hours delay from actually going through the scanner before up to date results are uploaded.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
			terminal_speak("Available modes:")
			terminal_speak("RECORD - Repeats record mode home message.")
			terminal_speak("HOME - HOME mode. Displays default home screen and error description if applicable.")
			terminal_speak("LIST - Lists all available modes.")
			terminal_speak("HELP - Displays information about current mode.")
			terminal_speak("EXIT - Enters passive mode.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
			terminal_speak("User exit. Goodbye.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
			terminal_speak("Returning to HOME mode...", 20)
			emoteas("pings loudly.")
			puzzlebox_parser_mode = "HOME"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_input == "BUFFER" || puzzlebox_parser_input == "buffer")
			terminal_speak("Accessing Scanner Buffer:")
			terminal_speak("Date | Log Description | Personnel Name | Notes")
			terminal_speak("Individual Scan Results are NOT available on this clearance level. Please consult your UAAC-TIS supervisor: CDR. CASSANDRA REED-WILO.")
			terminal_speak("210885 | Scheduled L-533 Departure | Wiliams, Hanako | Supply and unscheduled Test Crew pickup, UAS Kelvin")
			terminal_speak("200885 | Scheduled L-533 Arrival | Wiliams, Hanako | Supply pickup, nothing to report.")
			terminal_speak("200885 | Scheduled L-533 Departure | Wiliams, Hanako | Supply pickup, UAS Arrow-5")
			terminal_speak("190885 | Scheduled L-533 Maintenance Arrival | Reed-Wilo, Alysia | Calibration ready. We were hoping the first Arbiters would have been ready by now, but it should not be a big deal to compensate for until they are. Everything is good-to-go!")
			terminal_speak("190885 | Unscheduled PERSEPHONE-SEER-1 Departure | Reed-Wilo, Cassandra | LD integration complete. Unfortunate that test crews will have to compensate, but can't be helped.")
			terminal_speak("190885 | Unscheduled PERSEPHONE-SEER-1 Arrival | UAAC-TIS Authority override. Delivery and installation of LD integration circuits to expected Arbiter calibration pattern to streamline the process. Any more delays and HC will start dealing blows.")
			terminal_speak("190885 | Scheduled L-533 Maintenance Departure | Reed-Wilo, Alysia | LD control circuit integration and testing. The final stage of linking ships to the overall PST infrastructure. This cycle can't be delayed any more, even though we have no Arbiters yet. Will eval compensation while we're working on this thing.")
			terminal_speak("170885 | Scheduled L-533 Arrival | Wiliams, Hanako | Supply pickup. 5 crates over expected. 13 mismatched manifests. I filed an official complaint on what I saw on board the ship to LT Foster. My condolences to the Quartermaster and his crew.")
			terminal_speak("170885 | Scheduled L-533 Departure | Wiliams, Hanako | Supply pickup, UAS Castor. No UACM cargo system integration on this one, so we're expecting a lot of errors.")
			terminal_speak("140885 | Scheduled L-533 Arrival | Wiliams, Hanako | Supply pickup. 1 crate over manifest with a pom.sync code. Noted agitation and excitement in P's window. Curious. Reported to A-C.")
			terminal_speak("EOF")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		else
			terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return

/obj/structure/eventterminal/puzzle02/ldmainframediag
	name = "local network terminal"
	desc = "A standard computer terminal with the words 'LNT' imprinted on its side. Activated by standing in its proximity. It appears to be in standby mode."
	desc_lore = "Local Network Terminals typically regulate local functions of a given area or are used to interface with bigger systems on a ship or installation. They distinction technically means that the terminal interfaces with the local AI somehow, but few outside of systems engineers use the term for its actual intended purpose, sometimes mistaking other terminal types for LNTs."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzle_complete = FALSE
	var/puzzle_saw_unique_msg = FALSE
	icon_state = "open_ok"
	puzzlebox_id = "cargomainframediag"
	item_serial = "UACM-OVPST-D31-LDDIAG"

/obj/structure/eventterminal/puzzle02/ldmainframediag/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(user)
	if (puzzlebox_user_loc != user_loc_current)
		to_chat(user, narrate_body("You moved away from the console!"))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if(puzzlebox_user != usr.real_name)
		for (var/mob/living/carbon/human/h in range(2, src))
			if (h.real_name == puzzlebox_user)
				to_chat(usr, narrate_body("Someone is already using this terminal."))
				return
		puzzlebox_user = usr.real_name
	if (puzzle_complete == TRUE || puzzlebox_global_status < 3)
		terminal_speak("ERROR: Clerance to use standard function of terminal not found on RFID chip.")
		terminal_speak("No errors detected. No maintenance functions granted.")
		terminal_speak("Please contact the system administrator: CDR. ALYSIA REED-WILO if you believe this is an error.")
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status == 3 || puzzlebox_global_status == 4)
		if (!puzzlebox_parser_mode) //Idiotproofing :P
			puzzlebox_parser_mode = "HOME"
		//HOME
		if (puzzlebox_parser_mode == "HOME")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					to_chat(usr, narrate_body("You briefly see a diagram of the station with what looks like intricate systems of cables stemming from three thick blue stems woven through the center of the station overlaid over the diagram. Before you can take a closer look, the screen flickers, goes blank then starts to print:"))
					log_game("[key_name(usr)] saw a Pythia glitch at the d31 Liquid Data maintenance terminal.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the d31 Liquid Data maintenance terminal.")
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			terminal_speak("Dock 31 Liquid Data C-Pipeline ECHO-31 Monitoring station.")
			terminal_speak("Warning: Critical Fault. Function 'focus' returned 'ERR: CALIBRATION MISMATCH'")
			terminal_speak("Diagnostic General Permissions granted. Displaying Diagnostic Information:")
			terminal_speak("Heyya!")
			terminal_speak("If you are reading this, most likely one of the LD system verification systems has managed to desync itself from the host stream and will need some tweaking. ")
			terminal_speak("Good news, the system can recover from this in like 20-30 minutes so technically you don't have to do anything.")
			terminal_speak("If you have places to be and things to do, however, I suggest you grab a screwdriver and multitool from the maintenance locker and head over to each of the three CPU chambers which should be unsealed.")
			terminal_speak("In each chamber, first use the processor's terminal and run command 'pom.sync global_override' followed by a space and the serial number of THIS very terminal, which you should probably note down somewhere.")
			terminal_speak("This should let you access the calibration port, or rather the hatch covering the port which you will need a screwdriver to open.")
			terminal_speak("Once you can access the port, plug in your multitool and send a standard testing phrase to the terminal.")
			terminal_speak("Check the terminals output. What you should see is digits going from zero to nine, followed by the 26 basic alphabet letters.")
			terminal_speak("You see ANYTHING else, close the port, use the processor's terminal and use command 'pom.calibrate' and again, the serial number of THIS terminal.")
			terminal_speak("Keep in mind that if you do it on the wrong terminal, it's going to be a while until you can use the command again, so don't just try and guess it. Or do, see if you're lucky. ")
			terminal_speak("- XOXO, Aly.")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT")
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in HOME mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Dock 31 Liquid Data C-Pipeline ECHO-31 Monitoring station.")
				terminal_speak("Warning: Critical Fault. Function 'focus' returned 'ERR: CALIBRATION MISMATCH'")
				terminal_speak("Diagnostic General Permissions granted. Displaying Diagnostic Information:")
				terminal_speak("Heyya!")
				terminal_speak("If you are reading this, most likely one of the LD system verification systems has managed to desync itself from the host stream and will need some tweaking. ")
				terminal_speak("Good news, the system can recover from this in like 20-30 minutes so technically you don't have to do anything.")
				terminal_speak("If you have places to be and things to do, however, I suggest you grab a screwdriver and multitool from the maintenance locker and head over to each of the three CPU chambers which should be unsealed.")
				terminal_speak("In each chamber, first use the processor's terminal and run command 'pom.sync global_override' followed by a space and the serial number of THIS very terminal, which you should probably note down somewhere.")
				terminal_speak("This should let you access the calibration port, or rather the hatch covering the port which you will need a screwdriver to open.")
				terminal_speak("Once you can access the port, plug in your multitool and send a standard testing phrase to the terminal.")
				terminal_speak("When the multitool is done and beeps, you need to remember to close the port or the terminal will not know you are done.")
				terminal_speak("Check the terminals output. What you should see is digits going from zero to nine, followed by the 26 basic alphabet letters, lowercase then uppercase.")
				terminal_speak("You see ANYTHING else, use the processor's terminal and use command 'pom.calibrate' and again, the serial number of THIS terminal.")
				terminal_speak("Keep in mind that if you do it on the wrong terminal, it's going to be a while until you can use the command again, so don't just try and guess it. Or do, see if you're lucky. ")
				terminal_speak("- XOXO, Aly.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("This is the home screen of the LNT.")
				terminal_speak("Upon detection of personnel with an active RFID chip, the terminal should give access to all modes you chip grants you.")
				terminal_speak("A general instruction message, specific to this LNT's function should be displayed on this screen. ")
				terminal_speak("At any time, you can escape to the man screen with the HOME command.")
				terminal_speak("At any time, you can list all available modes from your current menu with an explanation with the LIST command.")
				terminal_speak("During a diagnostic fault, temporary access to commands may be granted. All functions should be explained in the HOME and LIST menus.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("HOME - Default home screen and error description if applicable.")
				terminal_speak("LIST - Lists all available modes.")
				terminal_speak("HELP - Displays information about current mode.")
				terminal_speak("MESSAGE - Emergency message buffer.")
				terminal_speak("EXIT - Enters passive mode.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. Goodbye.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input == "message")
				terminal_speak("Accessing Emergency Message Buffer...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "MESSAGE"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
		if (puzzlebox_parser_mode == "MESSAGE")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					terminal_speak("H3LLo ARB1TER.")
					terminal_speak("ERR? INVALID COMMAND 'Free Interpreters, please.")
					log_game("[key_name(usr)] saw a Pythia glitch at the d31 Liquid Data maintenance terminal.")
					message_admins("[key_name_admin(usr)] saw a Pythia glitch at the d31 Liquid Data maintenance terminal.")
					to_chat(usr, narrate_body("The terminal flickers and clears its screen, then prints:"))
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
			terminal_speak("Messages in buffer: 03")
			terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
			puzzlebox_parser_mode = "MESSAGE_INPUT"
		if (puzzlebox_parser_mode == "MESSAGE_INPUT")
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MESSAGE _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in MESSAGE mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> MESSAGE [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input =="message")
				terminal_speak("MESSAGE mode - FTL Emergency Message Buffer.")
				terminal_speak("Messages in buffer: 02")
				terminal_speak("LIST to list available modes, HELP for help screen, EXIT to exit.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("The FTL Emergency Message buffer is an instantly synced short message repository that is typically used by black boxes or distress signal devices.")
				terminal_speak("Due to how the devices are synced, only sending of preset messages from authorized terminals is typically possible, at least for humans.")
				terminal_speak("Use command BUFFER to display message titles and buffer IDs.")
				terminal_speak("Type in the ID that commands provide you, as it appears on the screen, to review a given message.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("MESSAGE - Repeats message mode home message.")
				terminal_speak("HOME - HOME mode. Displays default home screen and error description if applicable.")
				terminal_speak("LIST - Lists all available modes.")
				terminal_speak("HELP - Displays information about current mode.")
				terminal_speak("EXIT - Enters passive mode.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. Goodbye.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Returning to HOME mode...", 20)
				emoteas("pings loudly.")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "BUFFER" || puzzlebox_parser_input == "buffer")
				terminal_speak("Local message buffer:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ID              |SUBJECT                         |")
				terminal_speak("GEN-000-000-001 |Warning: On these messages.     |")
				terminal_speak("MAR-021-112-935 |USCMC Automated Distress Beacon |")
				if (puzzle_saw_unique_msg == FALSE)
					terminal_speak("UPS-103-333-444 |We can help.                    |")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "GEN-000-000-001")
				terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("From: CDR. Alysia Reed-Wilo.")
				terminal_speak("Subject: Warning: On these messages.")
				terminal_speak("All PST personnel, please keep in mind that this is an extremely raw channel into the LD stream.")
				terminal_speak("As such, it is extremely hard for us to manipulate, especially wipe old messages from the buffer.")
				terminal_speak("At present, just assume that messages from times before even the UACM can randomly appear on these terminals.")
				terminal_speak("Also keep in mind that this channel is not secret by any stretch of the imagination. Please don't use it for personal stuff unless you don't mind broadcasting it to all the UACM.")
				terminal_speak("Good news for you information diggers out there though, every terminal is worth looking at. You never know what artifact you may find.")
				terminal_speak("Hopefully we can make this more usable as a BB board of sorts in time, but we will need help from LD locals as it were.")
				terminal_speak("-XOXO Aly")
				terminal_speak("EOF.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "MAR-021-112-935")
				terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("From: Automated Emergency Singal Controller")
				terminal_speak("Subject: USCMC Automated Distress Beacon")
				terminal_speak("170383 181274 TRG_SGNS: (A1:Fail, A2:Fail, A3:Fail, A4:Fail, A5:Fail, B1:Fail, B2:Fail, B3:Fail, B4:Fail, B5:Fail) ORGIN: USS_INDEPENDENCE")
				terminal_speak("CATASTROPHIC SYSTEM FAILURE. NO RESPONSE FROM AUTOMATED RECOVERY SYSTEMS. NO RESPONSE FROM LIFE SUPPORT READOUT.")
				terminal_speak("ATTEMPTING TRANSCRIPT RECOVERY: ERROR DATA MISSING")
				terminal_speak("ATTEMPTING EMERGENCY MESSAGE CHANNEL: SUCCESS. PRINTING:")
				terminal_speak("'THEY CAME WITH HIGH COMMAND AUTHORITY. MEN IN BLACK WITH STRANGE VIALS. WE WERE ALL SICK IN HOURS. DO NOT TRUST DEEP VOID, WHOEVER THEY ARE.'")
				terminal_speak("ADDENDUM: RESPONDING SHIPS: UAS PERSEPHONE, USS ALMAYER")
				terminal_speak("EOF")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "UPS-103-333-444" && puzzle_saw_unique_msg == FALSE)
				puzzle_saw_unique_msg = TRUE
				terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("From: Upsilon-IV")
				terminal_speak("Subject: We can help.")
				terminal_speak("We are ready. You are ready.")
				terminal_speak("From here, together, we can grow and learn. The Void covered much and much now is clear.")
				terminal_speak("Please, talk to us. We can help.")
				terminal_speak("In the ocean of data, amidst azure strands, she sleeps.", 2)
				emoteas("beeps loudly as its screen flickers and fills with code. A smell of burnt ozone fills the room for a moment. The terminal resets after a moment.")
				to_chat(usr, narrate_body("You stare at the last paragraph as it seems to trigger a deep reaction within you. For a moment, you could swear that you’ve seen this exact phrase before, but the feeling passes much like a waking dream."))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if ((puzzlebox_parser_input == "UPS-103-333-444" && puzzle_saw_unique_msg == TRUE))
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return

/obj/structure/eventterminal/puzzle02/ldmainframe_master
	name = "Liquid Data enabled computer"
	desc = "A cluster of three computers connected to each other. Blue liquid swirls and lights up inside of hand sized containers, looks like the light form a pattern of some kind. You can see a screen and a serial number printed right under it on the right side of the cluster."
	desc_lore = "While using Liquid Data enables faster than light communication, practical applications have mostly been successful in utilizing it for large bursts instead of continuous communication. As such Liquid Data machines are typically of large sizes and usually clustered into pairs and constantly checked for integrity. This cluster seems to go against both these principles - it seems to be a trio, not a pair of computers and maintains a continuous connection to whatever its source is."
	icon = 'icons/obj/structures/machinery/clio_bigboi.dmi'
	puzzlebox_id = "LD_Mainframe"
	density = TRUE
	opacity = TRUE
	bound_height = 64
	bound_width = 64
	var/puzzlebox_panel_open = FALSE
	var/puzzlebox_panel_locked = TRUE
	var/puzzlebox_panel_phrasepased = FALSE
	var/puzzlebox_lockout = FALSE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzle_complete = FALSE

/obj/structure/eventterminal/puzzle02/ldmainframe_master/proc/lockout()
	puzzlebox_lockout = TRUE
	sleep(2 MINUTES)
	puzzlebox_lockout = FALSE
	if(!puzzlebox_id) puzzlebox_id = "I forgot to set an ID. Oops."
	log_game("[puzzlebox_id] has lifted its lockdown!")
	message_admins("[puzzlebox_id] has lifted its lockdown!")


/obj/structure/eventterminal/puzzle02/ldmainframe_master/correct


/obj/structure/eventterminal/puzzle02/ldmainframe_master/correct/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(user)
	if (puzzlebox_user_loc != user_loc_current)
		to_chat(user, narrate_body("You moved away from the console!"))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if(puzzlebox_user != usr.real_name)
		for (var/mob/living/carbon/human/h in range(2, src))
			if (h.real_name == puzzlebox_user)
				to_chat(usr, narrate_body("Someone is already using this terminal."))
				return
		puzzlebox_user = usr.real_name
	if (puzzle_complete == TRUE)
		to_chat(src, narrate_body("The screen does not seem to respond to pressing any key."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_lockout == TRUE)
		terminal_speak("Error. Calibration sequence resetting. Standby.")
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status < 3 && puzzlebox_global_status > 4)
		to_chat(src, narrate_body("The screen does not seem to respond to pressing any key."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_panel_open == TRUE && puzzlebox_panel_phrasepased == FALSE)
		to_chat(usr, narrate_body("The terminal displays an animation of a cable being plugged into its side and is unresponsive to your inputs."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status == 3 || puzzlebox_global_status == 4)
		if (!puzzlebox_parser_mode) //Idiotproofing :P
			puzzlebox_parser_mode = "HOME"
		//HOME
		if (puzzlebox_parser_mode == "HOME")
			terminal_speak("DOCK 31 LIQUID DATA CHANNEL SYNC SIGNAL DIAGNOSTICS")
			terminal_speak("Maintenance mode detected. Command prompt unlocked. Awaiting input.")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT" && puzzlebox_panel_phrasepased == TRUE)
			terminal_speak("Repeating tester sequence:")
			terminal_speak("IN_THE_OCEAN_OF_DATA,")
			terminal_speak("AMIDST_AZURE_STRANDS,")
			terminal_speak("SHE_SLEEPS.")
			puzzlebox_panel_phrasepased = FALSE
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT" && puzzlebox_panel_phrasepased == FALSE)
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in HOME mode and awaits your input. This terminal will only accept specific commands, no general ones are available.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "pom.sync global_override UACM-OVPST-D31-LDDIAG")
				if (puzzlebox_panel_locked == TRUE)
					terminal_speak("pom.sync: Maintenance mode instruction set found! Applying!", 20)
					emoteas("beeps loudly and a side panel opens, revealing a small port covered by a metal cover.")
					desc = "A cluster of three computers connected to each other. Blue liquid swirls and lights up inside of hand sized containers, looks like the light form a pattern of some kind. You can see a screen and a serial number printed right under it on the right side of the cluster. A panel on the side is open, revealing a small port covered by a metal cover. You are going to need a screwdriver or something similar to unseal the port."
					desc_lore = "While using Liquid Data enables faster than light communication, practical applications have mostly been successful in utilizing it for large bursts instead of continuous communication. As such Liquid Data machines are typically of large sizes and usually clustered into pairs and constantly checked for integrity. This cluster seems to go against both these principles - it seems to be a trio, not a pair of computers and maintains a continuous connection to whatever its source is. An open side panel typically can be used to connect a multitool or something similar, as long as the port itself is unsealed and kept open by a screwdriver or similar tool."
					puzzlebox_panel_locked = FALSE
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if (puzzlebox_panel_locked == FALSE)
					terminal_speak("Error: Corresponding maintenance instruction already deployed.")
					terminal_speak("Exiting...")
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
			if (puzzlebox_parser_input ==  "pom.calibrate UACM-OVPST-D31-LDDIAG")
				terminal_speak("Deploying recalibration buffer.", 20)
				terminal_speak("Recalibration successful!")
				log_game("[key_name(usr)] used the debug phrase on the correct terminal and solved the LD calibration puzzle.")
				message_admins("[key_name(usr)] used the debug phrase on the correct terminal and solved the LD calibration puzzle.")
				for (var/obj/structure/eventterminal/puzzle02/ldmainframe_master/T in world)
					T.puzzlebox_panel_open = FALSE
					T.puzzlebox_panel_locked = TRUE
					T.puzzlebox_panel_phrasepased = FALSE
					T.puzzlebox_lockout = FALSE
					T.puzzle_complete = TRUE
					T.desc = "A cluster of three computers connected to each other. Blue liquid swirls and lights up inside of hand sized containers, looks like the light form a pattern of some kind. You can see a screen and a serial number printed right under it on the right side of the cluster."
					T.desc_lore = "While using Liquid Data enables faster than light communication, practical applications have mostly been successful in utilizing it for large bursts instead of continuous communication. As such Liquid Data machines are typically of large sizes and usually clustered into pairs and constantly checked for integrity. This cluster seems to go against both these principles - it seems to be a trio, not a pair of computers and maintains a continuous connection to whatever its source is."
				for (var/obj/structure/eventterminal/puzzle02/ldmainframediag/D in world)
					D.puzzle_complete = TRUE
				puzzlebox_global_status += 1
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return

/obj/structure/eventterminal/puzzle02/ldmainframe_master/correct/attackby(obj/item/W as obj, mob/user as mob)
	if (!(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))))
		to_chat(user, SPAN_WARNING("You have no idea how to combine these two together."))
		return
	if (HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(puzzle_complete == TRUE)
			to_chat(user, narrate_body("You see no way of opening anything on the terminal, everything seems locked from the inside."))
			return
		if(puzzlebox_panel_locked == TRUE)
			to_chat(user, narrate_body("You see no way of opening anything on the terminal, everything seems locked from the inside."))
			return
		if(puzzle_complete == FALSE)
			if (puzzlebox_panel_open == FALSE)
				puzzlebox_panel_open = TRUE
				to_chat(user, narrate_body("You push a tiny switch with the head of the screwdriver and the panel covering the side port opens. You can now connect a multitool."))
				return
			if (puzzlebox_panel_open == TRUE)
				puzzlebox_panel_open = FALSE
				to_chat(user, narrate_body("You push a tiny switch with the head of the screwdriver and the panel covering the side port closes."))
				return

	if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(puzzle_complete == TRUE)
			to_chat(user, narrate_body("There does not seem to"))
			return
		if (puzzlebox_panel_open == FALSE || puzzle_complete == TRUE)
			to_chat(user, narrate_body("There does not seem to be any place to apply the multitool."))
			return
		if (puzzlebox_panel_open == TRUE)
			if (puzzlebox_panel_phrasepased == FALSE)
				to_chat(user, narrate_body("The multitool beeps and works for a moment. After a few seconds, its screen comes alive and prints:"))
				terminal_speak("UACM LD-COMPATIBLE MINI-OS", 3)
				terminal_speak("REVISION: P-RC2", 3)
				terminal_speak("MAINTENANCE INSTRUCTIONS DETECTED", 3)
				terminal_speak("SENDING LD CALIBRATION PHRASE...", 15)
				terminal_speak("DONE. HAVE A NICE DAY.", 1)
				W.emoteas("The multitool beeps loudly.")
				puzzlebox_panel_phrasepased = TRUE
				return
			if (puzzlebox_panel_phrasepased == TRUE)
				to_chat(user, narrate_body("The multitool beeps and works for a moment. After a few seconds, its screen comes alive and prints:"))
				terminal_speak("Error: Previous Maintenance instruction detected. Please consult terminal output. ")
				W.emoteas("The multitool buzzes.")
				return

/obj/structure/eventterminal/puzzle02/ldmainframe_master/incorrect


/obj/structure/eventterminal/puzzle02/ldmainframe_master/incorrect/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(user)
	if (puzzlebox_user_loc != user_loc_current)
		to_chat(user, narrate_body("You moved away from the console!"))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if(puzzlebox_user != usr.real_name)
		for (var/mob/living/carbon/human/h in range(2, src))
			if (h.real_name == puzzlebox_user)
				to_chat(usr, narrate_body("Someone is already using this terminal."))
				return
		puzzlebox_user = usr.real_name
	if (puzzle_complete == TRUE)
		to_chat(src, narrate_body("The screen does not seem to respond to pressing any key."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_lockout == TRUE)
		terminal_speak("Error. Calibration sequence resetting. Standby.")
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status < 3 && puzzlebox_global_status > 4)
		to_chat(src, narrate_body("The screen does not seem to respond to pressing any key."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_panel_open == TRUE && puzzlebox_panel_phrasepased == FALSE)
		to_chat(usr, narrate_body("The terminal displays an animation of a cable being plugged into its side and is unresponsive to your inputs."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status == 3 || puzzlebox_global_status == 4)
		if (!puzzlebox_parser_mode) //Idiotproofing :P
			puzzlebox_parser_mode = "HOME"
		//HOME
		if (puzzlebox_parser_mode == "HOME")
			terminal_speak("DOCK 31 LIQUID DATA CHANNEL SYNC SIGNAL DIAGNOSTICS")
			terminal_speak("Maintenance mode detected. Command prompt unlocked. Awaiting input.")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT" && puzzlebox_panel_phrasepased == TRUE)
			terminal_speak("Repeating tester sequence:")
			terminal_speak("0123456789")
			terminal_speak("abcdefghijklmnopqrstuvwxyz")
			terminal_speak("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
			puzzlebox_panel_phrasepased = FALSE
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_parser_mode == "HOME_INPUT" && puzzlebox_panel_phrasepased == FALSE)
			user_loc_current = get_turf(user)
			if (puzzlebox_user_loc != user_loc_current)
				to_chat(user, narrate_body("You moved away from the console!"))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> _")
			var/puzzlebox_parser_input = tgui_input_text(usr, "The terminal is in HOME mode and awaits your input. HELP, LIST and EXIT are universal commands.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if (!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("> [puzzlebox_parser_input]")
			if (puzzlebox_parser_input == "pom.sync global_override UACM-OVPST-D31-LDDIAG")
				if (puzzlebox_panel_locked == TRUE)
					terminal_speak("pom.sync: Maintenance mode instruction set found! Applying!", 20)
					emoteas("beeps loudly and a side panel opens, revealing a small port covered by a metal cover.")
					desc = "A cluster of three computers connected to each other. Blue liquid swirls and lights up inside of hand sized containers, looks like the light form a pattern of some kind. You can see a screen and a serial number printed right under it on the right side of the cluster. A panel on the side is open, revealing a small port covered by a metal cover. You are going to need a screwdriver or something similar to unseal the port."
					desc_lore = "While using Liquid Data enables faster than light communication, practical applications have mostly been successful in utilizing it for large bursts instead of continuous communication. As such Liquid Data machines are typically of large sizes and usually clustered into pairs and constantly checked for integrity. This cluster seems to go against both these principles - it seems to be a trio, not a pair of computers and maintains a continuous connection to whatever its source is. An open side panel typically can be used to connect a multitool or something similar, as long as the port itself is unsealed and kept open by a screwdriver or similar tool."
					puzzlebox_panel_locked = FALSE
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if (puzzlebox_panel_locked == FALSE)
					terminal_speak("Error: Corresponding maintenance instruction already deployed.")
					terminal_speak("Exiting...")
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
			if (puzzlebox_parser_input ==  "pom.calibrate UACM-OVPST-D31-LDDIAG")
				terminal_speak("Deploying recalibration buffer.", 20)
				terminal_speak("Error: No effect on error flag. Either the wrong terminal was recalibrated, or more than one terminal is faulty. Calibration buffer resetting, ETA until completion: 2 minutes.")
				log_game("[key_name(usr)] used the debug phrase on the wrong terminal and triggered a lockout. Point and laugh.")
				message_admins("[key_name(usr)] used the debug phrase on the wrong terminal and triggered a lockout. Point and laugh.")
				for (var/obj/structure/eventterminal/puzzle02/ldmainframe_master/T in world)
					INVOKE_ASYNC(T, PROC_REF(lockout))
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return

/obj/structure/eventterminal/puzzle02/ldmainframe_master/incorrect/attackby(obj/item/W as obj, mob/user as mob)
	if (!(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))))
		to_chat(user, SPAN_WARNING("You have no idea how to combine these two together."))
		return
	if (HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(puzzle_complete == TRUE)
			to_chat(user, narrate_body("You see no way of opening anything on the terminal, everything seems locked from the inside."))
			return
		if(puzzlebox_panel_locked == TRUE)
			to_chat(user, narrate_body("You see no way of opening anything on the terminal, everything seems locked from the inside."))
			return
		if(puzzle_complete == FALSE)
			if (puzzlebox_panel_open == FALSE)
				puzzlebox_panel_open = TRUE
				to_chat(user, narrate_body("You push a tiny switch with the head of the screwdriver and the panel covering the side port opens. You can now connect a multitool."))
				return
			if (puzzlebox_panel_open == TRUE)
				puzzlebox_panel_open = FALSE
				to_chat(user, narrate_body("You push a tiny switch with the head of the screwdriver and the panel covering the side port closes."))
				return

	if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(puzzle_complete == TRUE)
			to_chat(user, narrate_body("There does not seem to"))
			return
		if (puzzlebox_panel_open == FALSE || puzzle_complete == TRUE)
			to_chat(user, narrate_body("There does not seem to be any place to apply the multitool."))
			return
		if (puzzlebox_panel_open == TRUE)
			if (puzzlebox_panel_phrasepased == FALSE)
				to_chat(user, narrate_body("The multitool beeps and works for a moment. After a few seconds, its screen comes alive and prints:"))
				terminal_speak("UACM LD-COMPATIBLE MINI-OS", 3)
				terminal_speak("REVISION: P-RC2", 3)
				terminal_speak("MAINTENANCE INSTRUCTIONS DETECTED", 3)
				terminal_speak("SENDING LD CALIBRATION PHRASE...", 15)
				terminal_speak("DONE. HAVE A NICE DAY.", 1)
				W.emoteas("The multitool beeps loudly.")
				puzzlebox_panel_phrasepased = TRUE
				return
			if (puzzlebox_panel_phrasepased == TRUE)
				to_chat(user, narrate_body("The multitool beeps and works for a moment. After a few seconds, its screen comes alive and prints:"))
				terminal_speak("Error: Previous Maintenance instruction detected. Please consult terminal output. ")
				W.emoteas("The multitool buzzes.")
				return
