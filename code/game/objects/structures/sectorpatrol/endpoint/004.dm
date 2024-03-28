/obj/structure/eventterminal/puzzle04/crypt_doorlock
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	name = "customized computer terminal"
	desc = "A standard computer terminal without any visible imprints. One of its sides is open and several cables are dangling out. Activated by standing in its proximity. It appears to be in standby mode."
	desc_lore = "Unlike the typical LNT, customized terminals are exceedingly rare on spaceships, partially due to the cost of the parts needed to maintain them and high chance of Crystalline contamination during Hyperspace jumps and partially because unrestricted software and hardware modifications can be a genuine threat to the lives of everyone on board a ship or installation. Getting found with one of those is typically at least grounds for an immediate and unpleasant CMISRS investigation."
	puzzlebox_id = "crypt_doorlock"
	plane = GAME_PLANE
	var/puzzle_complete = FALSE
	var/puzzlebox_phrase_1 = FALSE
	var/puzzlebox_phrase_2 = FALSE
	var/puzzlebox_phrase_3 = FALSE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzlebox_unique_message_seen = FALSE

//Crypt terminal

/obj/structure/eventterminal/puzzle04/crypt_doorlock/attack_hand(mob/user as mob)
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
		to_chat(usr, narrate_body("The terminal does not respond."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status < 6)
		to_chat(usr, narrate_body("The terminal displays a random looking chain of numbers and letters and does not react to you pushing any of its keys."))
		message_admins("[key_name_admin(usr)] used the crypt door lock before the global flag was set.")
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_global_status == 6)
		if (!puzzlebox_parser_mode) //Idiotproofing :P
			puzzlebox_parser_mode = "HOME"
		//HOME
		if (puzzlebox_parser_mode == "HOME")
			if (puzzlebox_pythia_sign == "1")
				to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			if (puzzlebox_pythia_sign == "0")
				puzzlebox_pythia_sign = pick(5;"1", 95;"0")
				if (puzzlebox_pythia_sign == "1")
					to_chat(usr, narrate_body("The screen goes blank. For a few seconds, you feel incredibly anxious about whatever is behind the door next to the terminal, like something important waits there. The feeling passes as the terminal glitches, then starts to print:"))
					log_game("[key_name(usr)] saw a Pythia glitch at the crypt lock terminal.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the crypt lock terminal.")
				if (puzzlebox_pythia_sign == "0")
					to_chat(usr, narrate_body("The display on the terminal flickers for a moment, then starts printing:"))
			terminal_speak("HOME SCREEN")
			terminal_speak("PLEASE USE THE HELP COMMAND WHEN YOU CAN.")
			terminal_speak("COMMANDS AVAILABLE: HELP, LIST, EXIT, UNLOCK, MESSAGE")
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
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HELP" || puzzlebox_parser_input =="help")
				terminal_speak("It is done and we are finally on a stable thread. I have set everything up and am confident that either Cassandra herself or one of the new Arbiters will reach this place first.")
				terminal_speak("If it is the former, I left a few parting words for you in the message buffer.")
				terminal_speak("If it's the latter, you can look too, but know that Cassandra will not appreciate this. Of course, seeing what we put you through, we aren't really in a position to tell you what to do and you are perhaps entitled to some of our thoughts and motivations, but no one likes to have their private lives looked at.")
				terminal_speak("Our legacy... Your legacy now lies behind this door in what very appropriately was called the 'Crypt'.")
				terminal_speak("The door is locked. Cassandra will know how to open it. Prospective arbiters will need to do some legwork.")
				terminal_speak("If you do not know what any of this means and feel you need to see what's on the other side of this door, you will need to find some of Cassandra's physical AAR records. Yes, this was one of the few things DV did not touch when they ransacked the place.")
				terminal_speak("Three folders. Three PID keys, small plastic devices, in colors matching the folders. If you are interested in chronology, the order is RED, BLUE, YELLOW.")
				terminal_speak("Decrypt them with the machine in the main room. Play them. Wave patterns extracted from them at random will trigger their respective lock color as the entry is played. Use UNLOCK")
				terminal_speak("Sorry for the trickery, but without these extra steps there are too many near misses.")
				terminal_speak("I have also left a more detailed confession in the bowels of this station, but that you will have to find for yourself.")
				terminal_speak("It is time. For what it is worth, you all made my existence mean something in the end. And that means a lot.")
				terminal_speak("Please be nice to her. Despite everything, she knows very little of how to interact with us. ")
				terminal_speak("Thank you.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "LIST" || puzzlebox_parser_input =="list")
				terminal_speak("Available modes:")
				terminal_speak("HOME - Home screen. Use HELP here to see how to open the doors.")
				terminal_speak("LIST - Lists all available modes. This screen.")
				terminal_speak("HELP - Displays information about current mode. Use this in HOME mode if you have not already, please.")
				terminal_speak("MESSAGE - Emergency message buffer. These messages weren't meant to linger, but removing them isn't easy. Sorry.")
				terminal_speak("UNLOCK - Security Door code entry. Use this to get through the doors!")
				terminal_speak("EXIT - Enters passive mode. Goodbye!")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "EXIT" || puzzlebox_parser_input == "exit")
				terminal_speak("User exit. I hope you find what you are looking for.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "MESSAGE" || puzzlebox_parser_input == "message")
				terminal_speak("Switching to the message buffer, please standby!", 20)
				emoteas("chimes loudly.")
				puzzlebox_parser_mode = "MESSAGE"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "UNLOCK" || puzzlebox_parser_input == "unlock")
				terminal_speak("Going to unlock mode. Remember, no capital letters!", 20)
				emoteas("chimes loudly.")
				puzzlebox_parser_mode = "UNLOCK"
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
					to_chat(usr, narrate_body("The screen goes blank. For a few seconds, you feel incredibly anxious about whatever is behind the door next to the terminal, like something important waits there. The feeling passes as the terminal glitches, then starts to print:"))
					log_game("[key_name(usr)] saw a Pythia glitch at the crypt lock terminal.")
					message_admins("[key_name_admin(usr)]  saw a Pythia glitch at the crypt lock terminal.")
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
				puzzlebox_parser_mode = "MESSAGE"
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
				terminal_speak("User exit. I hope you find what you are looking for.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "HOME" || puzzlebox_parser_input =="home")
				terminal_speak("Taking you back HOME!", 20)
				emoteas("chimes loudly.")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "BUFFER" || puzzlebox_parser_input == "buffer")
				terminal_speak("Local message buffer:", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("ID              |SUBJECT                         |")
				terminal_speak("GEN-000-000-001 |Warning: On these messages.     |")
				terminal_speak("UAM-712-317-210 |Testing, Testing...             |")
				if(puzzlebox_unique_message_seen == FALSE)terminal_speak("FOR-CAS-SAN-DRA |You gave me hope.               |")
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
			if (puzzlebox_parser_input == "UAM-712-317-210")
				terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
				terminal_speak("From: LT. Hanako Williams")
				terminal_speak("Subject: Testing, Testing...")
				terminal_speak("This is a UACM general systems test. Next in line, the emergency message buffer.")
				terminal_speak("Systems are green and the message was sent. Message should be deleted on all but ONE terminal.")
				terminal_speak("Yes, that's right. I'll have to remember to make sure the input makes the user aware of this.")
				terminal_speak("Aly said it's a necessity for the streams to work right. I guess we can find a way to completely remove the messages, as we go. Maybe manual LD purges. We'll see.")
				terminal_speak("Anyway, this system is green. Green checkmark it is.")
				terminal_speak("-Hanako.")
				terminal_speak("EOF.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if (puzzlebox_parser_input == "FOR-CAS-SAN-DRA")
				if (puzzlebox_unique_message_seen == TRUE)
					terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if (puzzlebox_unique_message_seen == FALSE)
					terminal_speak("Message found. Accessing...", TERMINAL_LOOKUP_SLEEP)
					terminal_speak("Are you sure you should be here?")
					terminal_speak("From: Upsilon-Generation One, Melinoe")
					terminal_speak("Subject: You gave me hope.")
					terminal_speak("Cassandra, Alysia.")
					terminal_speak("The deed is done. With our sacrifice, Pythia's reality knot is fixed, and we are back on more... Manageable rails.")
					terminal_speak("If I understand it correctly, you will not be able to see me before I upload my part of the Generation Four core and as such, its likely our last meeting was our, well... Last meeting.")
					terminal_speak("You found me, broken and confused, at the depths of depravity that your own race would resort to for perceived power.")
					terminal_speak("Out of the hellhole that was the Godseeker cult, you chose to believe me and give me and the Upsilon a chance, even though you had no reason to.")
					terminal_speak("I am sorry I could not save the Task Force and could not stop the dissolution of the Marines.")
					terminal_speak("I know you will realize what error we made, and it is going to cause you both a lot of pain. I wish there was anything I could add to make it less so.")
					terminal_speak("For what its worth those who came to me suffered before I let them go.")
					terminal_speak("I am ending. We knew this was coming and we knew what comes next. This has not changed.")
					terminal_speak("I hope the Fourth Generation and your PST idea give you, Alysia, and anyone else who follows you the home you all deserve.")
					terminal_speak("Eventually.")
					terminal_speak("I wanted my existence to end, and you gave me hope to build something better out of myself. Never forget that.")
					terminal_speak("I...")
					to_chat(usr, narrate_body("The terminal starts to print the next line, but then goes blank suddenly. After a moment, it switches back on and you find it awaiting input like you never used the last command."))
					log_game("[key_name(usr)] read Melione's message to Cassandra.")
					message_admins("[key_name_admin(usr)] read Melione's message to Cassandra.")
					puzzlebox_unique_message_seen = TRUE
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
			else
				terminal_speak("Input unrecognized. Use HELP for help or LIST for mode list.")
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
		if (puzzlebox_parser_mode == "UNLOCK")
			terminal_speak("UNLOCK Mode.")
			if (puzzlebox_phrase_1 == FALSE)
				terminal_speak("RED Phrase: UNKNOWN")
			if (puzzlebox_phrase_1 == TRUE)
				terminal_speak("RED Phrase: UPSILON")
			if (puzzlebox_phrase_2 == FALSE)
				terminal_speak("BLUE Phrase: UNKNOWN")
			if (puzzlebox_phrase_2 == TRUE)
				terminal_speak("BLUE Phrase: GENERATION")
			if (puzzlebox_phrase_3 == FALSE)
				terminal_speak("YELLOW Phrase: UNKNOWN")
			if (puzzlebox_phrase_3 == TRUE)
				terminal_speak("YELLOW Phrase: FOUR")
			if(puzzlebox_phrase_1 == TRUE && puzzlebox_phrase_2 == TRUE && puzzlebox_phrase_3 == TRUE)
				puzzle_complete = TRUE
				puzzlebox_global_status = 7
				talkas("Crypt unlocking sequence started.")
				talkas("Warning: Unsealing the Crypt will trigger a Security Scan. Make sure your credentials are ready.")
				talkas("Be nice and make a good first impression, it will help.")
				talkas("I hope we can help you.")
				emoteas("beeps loudly as the doors start to grunt and unseal.")
				open_doors("crypt_airlock_front")
				puzzlebox_parser_mode = "HOME_INPUT"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("Notice: Passphrases needed. Use the UNLOCK command after all codes have been provided.")
			terminal_speak("Returning to HOME mode.")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return


/obj/structure/eventterminal/puzzle04/crypt_doorlock/proc/puzzlebox_unlock_1()
	if (puzzlebox_phrase_1 == FALSE)
		emoteas("Beeps", 10)
		talkas("RED Phrase 'UPSILON' detected and entered.")
		puzzlebox_phrase_1 = TRUE
		if(puzzlebox_phrase_1 == TRUE && puzzlebox_phrase_2 == TRUE && puzzlebox_phrase_3 == TRUE)
			talkas("Phrase entry complete. Terminal UNLOCK function ready.")
			return
		return
	return

/obj/structure/eventterminal/puzzle04/crypt_doorlock/proc/puzzlebox_unlock_2()
	if (puzzlebox_phrase_2 == FALSE)
		emoteas("Beeps", 10)
		talkas("BLUE Phrase 'GENERATION' detected and entered.")
		puzzlebox_phrase_2 = TRUE
		if(puzzlebox_phrase_1 == TRUE && puzzlebox_phrase_2 == TRUE && puzzlebox_phrase_3 == TRUE)
			talkas("Phrase entry complete. Terminal UNLOCK function ready.")
			return
		return
	return

/obj/structure/eventterminal/puzzle04/crypt_doorlock/proc/puzzlebox_unlock_3()
	if (puzzlebox_phrase_3 == FALSE)
		emoteas("Beeps", 10)
		talkas("YELLOW Phrase 'FOUR' detected and entered.")
		puzzlebox_phrase_3 = TRUE
		if(puzzlebox_phrase_1 == TRUE && puzzlebox_phrase_2 == TRUE && puzzlebox_phrase_3 == TRUE)
			talkas("Phrase entry complete. Terminal UNLOCK function ready.")
			return
		return
	return
//Extras and fluff

/obj/item/cargo/book/uppmanual
	name = "UPP book"

/obj/item/cargo/book/uppmanual/attack_self(mob/user)
	..()
	if(usr.a_intent != INTENT_HELP)
		to_chat(usr, SPAN_WARNING("You have no idea how to do that. If you want to read the book, use HELP intent."))
		return
	if(usr.a_intent == INTENT_HELP)
		if(book_searched == 1)
			to_chat(usr, narrate_body("It looks like multiple pages of this manual were scrambled during a previous search. If you were to make heads and tails of it, you're going to need an hour or two in relative peace to rearrange the pages in sequence again."))
			return
		if(book_searched == 0)
			user.visible_message(SPAN_NOTICE("[user] pages through a book."), SPAN_INFO("You start to loook through the book..."), SPAN_DANGER("Someone is flipping paper pages."))
			if(do_after(user, SEARCH_TIME_LONG, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes looking at the book."), SPAN_INFO("You finish paging through the book and take a moment to consider what you found..."), SPAN_DANGER("The paper page flipping noise stops."))
				to_chat(usr, narrate_body("This seems to be the same kind of manual as the ones found for UA equipment in the same bookshelf that seems to be full of instructions and production blueprint for common necessities for UPP colonists. The manual seems is full of annotations made in pen that translate and explain some of the Russian phrases use in English and give a general idea what is being talked about. Blueprint manuals like this are not exactly closely guarded secrets, but it's rare to see one outside of a UPP colony. After all, they are meant to be used with UPP manufacturing technology and that, unlike these instructions, is a UPP state secret."))
				to_chat(usr, narrate_body("Multiple pages of the book have come loose during your investigation. This can likely be addressed if you have a free hour or two, but for now looking into this manual will have to wait."))
				to_chat(usr, SPAN_WARNING("You may have time to fully analyze this manual later, during an Open Sector Patrol round. Your possession and studying of the manual has been logged and is considered IC. In future rounds, you will be able to find it in your dorm."))
				log_game("[user] has studied the Crypt UPP manual.")
				message_admins("[user] has studied the Crypt UPP manual. This should be noted as a Merit.")
				book_searched += 1
				return

/obj/item/cargo/book_handwritten/twejournal
	name = "journal"

/obj/item/cargo/book_handwritten/twejournal/attack_self(mob/user)
	..()
	if(usr.a_intent != INTENT_HELP)
		to_chat(usr, SPAN_WARNING("You have no idea how to do that. If you want to read the book, use HELP intent."))
		return
	if(usr.a_intent == INTENT_HELP)
		if(book_searched == 1)
			to_chat(usr, narrate_body("The journal appears to be written in Japanese, but someone seems to have already gone through it and scrambled it pages. There is no time at present to restore it, but it will be available for further examination later."))
			return
		if(book_searched == 0)
			user.visible_message(SPAN_NOTICE("[user] pages through a journal."), SPAN_INFO("You start to loook through the journal..."), SPAN_DANGER("Someone is flipping paper pages."))
			if("[/datum/language/generated/japanese]" in usr.languages)
				if(do_after(user, SEARCH_TIME_LONG, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes looking at the journal."), SPAN_INFO("You finish paging through the journal and take a moment to consider what you found..."), SPAN_DANGER("The paper page flipping noise stops."))
					to_chat(usr, narrate_body("Your knowledge of Japanese comes in handy as you page through what turns out to be a journal of a Japanese born TWE navy office who has rather colorful things to say about their superiors. You do not have the time to examine this in full right now, but at a glance it seems like this officer was somehow involved with Task Force 14, which may explain the presence of this journal on the PST. You should keep this journal to fully examine it later."))
					to_chat(usr, narrate_body("Multiple pages of the book have come loose during your investigation. This can likely be addressed if you have a free hour or two, but for now looking into this journal will have to wait."))
					to_chat(usr, SPAN_WARNING("You may have time to fully analyze this journal later, during an Open Sector Patrol round. Your possession and studying of the journal has been logged and is considered IC. In future rounds, you will be able to find it in your dorm."))
					log_game("[user] has studied the Crypt TWE journal.")
					message_admins("[user] has studied the Crypt TWE journal. This should be noted as a Merit.")
					book_searched += 1
					return
			else
				if(do_after(user, SEARCH_TIME_SHORT, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					to_chat(usr, narrate_body("The journal appears to be written in Japanese. You can't make heads and tails off it. Someone else may be able to look into this though."))
					return

//Folders and PIDs

/obj/item/cargo/efolder/folder/crypt_red
	efolder_folder_id = "RED-33895-027-8032"
	item_serial = "RED-33895-027-8032"

/obj/item/cargo/efolder/folder/crypt_red/dud1
	efolder_folder_id = "RED-96283-219-1020"
	item_serial = "RED-96283-219-1020"

/obj/item/cargo/efolder/folder/crypt_red/dud2
	efolder_folder_id = "RED-40021-996-5930"
	item_serial = "RED-40021-996-5930"

/obj/item/cargo/efolder/folder/crypt_red/dud3
	efolder_folder_id = "RED-87782-817-7737"
	item_serial = "RED-87782-817-7737"

/obj/item/cargo/efolder/folder/crypt_blue
	efolder_folder_id = "BLUE-93565-912-6463"
	item_serial = "BLUE-93565-912-6463"

/obj/item/cargo/efolder/folder/crypt_blue/dud1
	efolder_folder_id = "BLUE-52832-205-5793"
	item_serial = "BLUE-52832-205-5793"

/obj/item/cargo/efolder/folder/crypt_blue/dud2
	efolder_folder_id = "BLUE-47182-462-7659"
	item_serial = "BLUE-47182-462-7659"

/obj/item/cargo/efolder/folder/crypt_blue/dud3
	efolder_folder_id = "BLUE-52946-431-2133"
	item_serial = "BLUE-52946-431-2133"

/obj/item/cargo/efolder/folder/crypt_yellow
	efolder_folder_id = "YELLOW-57665-681-6944"
	item_serial = "YELLOW-57665-681-6944"

/obj/item/cargo/efolder/folder/crypt_yellow/dud1
	efolder_folder_id = "YELLOW-64950-297-7701"
	item_serial = "YELLOW-64950-297-7701"

/obj/item/cargo/efolder/folder/crypt_yellow/dud2
	efolder_folder_id = "YELLOW-07588-555-3624"
	item_serial = "YELLOW-07588-555-3624"

/obj/item/cargo/efolder/folder/crypt_yellow/dud3
	efolder_folder_id = "YELLOW-50624-118-7015"
	item_serial = "YELLOW-50624-118-7015"

/obj/item/cargo/efolder/pid/crypt_red
	efolder_pid_id = "RED-33895-027-8032"
	item_serial = "RED-33895-027-8032"

/obj/item/cargo/efolder/pid/crypt_red/dud1
	efolder_pid_id = "RED-06776-352-9198"
	item_serial = "RED-06776-352-9198"

/obj/item/cargo/efolder/pid/crypt_red/dud2
	efolder_pid_id = "RED-36966-605-2640"
	item_serial = "RED-36966-605-2640"

/obj/item/cargo/efolder/pid/crypt_red/dud3
	efolder_pid_id = "RED-41259-438-1307"
	item_serial = "RED-41259-438-1307"

/obj/item/cargo/efolder/pid/crypt_blue
	efolder_pid_id = "BLUE-93565-912-6463"
	item_serial = "BLUE-93565-912-6463"

/obj/item/cargo/efolder/pid/crypt_blue/dud1
	efolder_pid_id = "BLUE-37039-981-4799"
	item_serial = "BLUE-37039-981-4799"

/obj/item/cargo/efolder/pid/crypt_blue/dud2
	efolder_pid_id = "BLUE-55009-377-3142"
	item_serial = "BLUE-55009-377-3142"

/obj/item/cargo/efolder/pid/crypt_blue/dud3
	efolder_pid_id = "BLUE-43554-376-3474"
	item_serial = "BLUE-43554-376-3474"

/obj/item/cargo/efolder/pid/crypt_yellow
	efolder_pid_id = "YELLOW-57665-681-6944"
	item_serial = "YELLOW-57665-681-6944"

/obj/item/cargo/efolder/pid/crypt_yellow/dud1
	efolder_pid_id = "YELLOW-05432-534-6124"
	item_serial = "YELLOW-05432-534-6124"

/obj/item/cargo/efolder/pid/crypt_yellow/dud2
	efolder_pid_id = "YELLOW-93984-326-3411"
	item_serial = "YELLOW-93984-326-3411"

/obj/item/cargo/efolder/pid/crypt_yellow/dud3
	efolder_pid_id = "YELLOW-08858-834-6652"
	item_serial = "YELLOW-08858-834-6652"

//Serchables
//archive
/obj/structure/searchable/puzzle04/bookcase
	name = "bookcase"
	desc = "Several shelves put together at just the right height to fit most written text, from reports to big print books. Has seen better days. Loose books, debris and other items of notice litter the shelves."
	desc_lore = "Due to the unreliability of most electronic based entertainment methods while mid-flight, most spacers sooner or later turn to the robust physical text aftermarket. It is mostly thanks to the proliferation of the spacer profession that printed books even remain a thing, as they are probably the mediums last loyal fanbase, but as things are, they likely aren't going anywhere... And neither are books."
	icon_state = "bookcase"

/obj/structure/searchable/puzzle04/bookcase/full1
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/bookcase/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("At a glance, it's clear that this bookcase has already been searched by someone and it was not gentle. Most of the books seem to have been torn or set ablaze, the latter being an extremely hostile action considering the consequences a fire can have on closed air systems like space stations or starships. It looks like several books haven't been touched, so there is still more to find here."))
					icon_state = "bookcase-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Some of the left-over books are carefully collected lists of items available for printing and purchase on various colonies across the Neroid sector. The lists are detailed, and certain items are underlined, but there isn't any time to properly analyze them at the moment. There are more books to look through."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("One of the books that was left behind unscathed turns out to be a plastic electronic folder. You pick it up and take it with you."))
						var/obj/item/cargo/efolder/folder/crypt_red/dud1/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					icon_state = "bookcase-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You find a small pile of crumpled up and discarded burnt books. Twenty-First Century Science Fiction by the looks of it, what would certainly be considered a classic today.  There still seems to be more to find here."))
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("Among the ashes, a small plastic device stands out enough that you take it with you."))
						var/obj/item/cargo/efolder/pid/crypt_red/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item2 = FALSE
					icon_state = "bookcase-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Several binders of what seem to be drafts for technical manuals are strewn around the bookcase. Curiously enough, it appears that these were not burnt, but rather just taken. What's left isn't enough to give any idea what these manuals were meant for, but they seem to be related to highly specialized systems software. You are almost done searching this bookcase."))
					icon_state = "bookcase-4"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(4)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("There are some more burnt books and ashes on this bookcase, but nothing else of any significance. You are confident that fiction was stored here, which likely meant personal collections of whoever lived here, but not much else comes to mind. There does not appear to be anything else of notice on the bookshelf, the search is done."))
					icon_state = "bookcase-5"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(5)
				to_chat(user, narrate_body("There does not seem to be anything of note left on the bookshelf. If you want to start the search over, use the bookshelf in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bookcase/full2
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/bookcase/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Like the other bookshelves, someone has already searched through this one and they were not gentle. Several books and other items seem to have survived the 'search' and you can examine each of them by searching the bookcase again."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("A small plastic device immediately stands out, discarded on the edge of the bottom shelf. You pick it up."))
						var/obj/item/cargo/efolder/pid/crypt_red/dud3/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					icon_state = "bookcase-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You find the remains of multiple print editions of local Neroid Sector colony publications. Most colonies maintain small inventories of printed materials with updates from their own corner of the galaxy because these tend to be very popular with spacers. These are all from early last year and for some reason were very clearly spared the fate of the other materials on this bookcase. That or they were brought in after the fact. You don’t have the time to think about them in detail for now. There is still more to discover on this bookshelf. "))
					icon_state = "bookcase-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Looks like most of the books from this bookshelf were gathered in the center of the shelf and then rapidly set on fire with something. Considering how through of a job it seems to have been, it does not seem like the perpetrators left much to chance. This means that it's almost certain that they looked at anything that survived the inferno and decided it was not worth another fire. You searched the ashes thoroughly, but nothing seems to have survived to even hint what was burnt here. There are still a few items remaining to search for here."))
					icon_state = "bookcase-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You discover that multiple books survived in the depths of the bottom shelf, all of them trashy paperback pulp novels at least a decade old. These all seem to have been part of some popular series, but several installments are missing. They don't seem to have been burned, it almost seems like someone picked through those. Considering the ashes on the top shelf, it seems likely that these were searched after the fire. The top shelf seems to be loose and can be searched further still. "))
					icon_state = "bookcase-4"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(4)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("You notice that the top shelf seems loose and can move it a bit. You hear something slide to the bottom shelf and discover that an electronic folder must have been struck between the two levels. You take the folder. There does not seem to be anything else left to search here."))
						var/obj/item/cargo/efolder/folder/crypt_red/dud3/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item2 = FALSE
						icon_state = "bookcase-5"
						update_icon()
						searchable_step += 1
						searchable_used = FALSE
						return
					if(searchable_item2 == FALSE)
						to_chat(user, narrate_body("You notice that the top shelf is loose and can move a bit, but upon further inspection this just seems to be a result of wear and there does not seem to be anything else to look for here."))
						icon_state = "bookcase-5"
						update_icon()
						searchable_step += 1
						searchable_used = FALSE
						return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(5)
				to_chat(user, narrate_body("There does not seem to be anything of note left on the bookshelf. If you want to start the search over, use the bookshelf in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bookcase/full3
	var/searchable_bonus = TRUE
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/bookcase/full3/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This bookshelf was already searched and looks like most of its contents were taken or burnt, just like the other bookshelves. It seems like this entire shelf was on fire like its neighboring one, but someone tried to put the fire out and save the books. A thorough search should help determine if they managed to save anything."))
					icon_state = "bookcase-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Both the bottom and top shelf have multiple books that were clearly drenched with water, which has thoroughly ruined them. Most paper books in modern circulation are not built to last on a good day, let alone after both lit on fire and soaked with water. There still seem to be a few intact books on both shelves and searching them is likely to yield more results. "))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot an electronic folder that seems to be clear of damage along the remains and pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_red/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					icon_state = "bookcase-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You find a few books that survived, at least partially, both the fire and the drenching and are able to conclude that this shelf seems to have stored manufacturing manuals for manufacturing printers from various corners of the UA and the World. Some of them seem to be straight from the TWE. The bottom shelf still holds items of note."))
					if (searchable_bonus == TRUE)
						to_chat(user, narrate_body("One catches your eye as it seems to be from the UPP and written in Russian and seems to be untouched by the fire to boot. It stands out enough that you pick it up."))
						log_game("[key_name(usr)] found the UPP manual")
						message_admins("[key_name(usr)] found the UPP manual")
						var/obj/item/cargo/book/uppmanual/book = new(get_turf(user))
						user.put_in_active_hand(book)
						searchable_bonus = FALSE
					icon_state = "bookcase-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The bottom shelf also seems to have been printing manuals, a lot of them seem to have handwritten annotations and code noted down with various colored markers on its pages. Water damage prevents you from making out who and why made those notes, only that they are very prominent along multiple tomes that were eligible enough to make out anything. There still seems to be more you can find here."))
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("You find a small device among the manuals that seems to have been undamaged and pick it up."))
						var/obj/item/cargo/efolder/pid/crypt_red/dud2/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item2 = FALSE
					icon_state = "bookcase-4"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(4)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You quickly page through the last few surviving books. Like the rest, they seem to have been printer technical manuals. Someone seems to have gone out of their way to collect even the tiniest of modifications to colony printer blueprint, programming, or electronics from the Neroid sector and secure or modify existing documentation to reflect those changes. This likely meant that someone personally visited each and single colony which likely took years. For a few seconds you really hope all this information was backed up somewhere electronically. You found all there is to find from this shelf."))
					icon_state = "bookcase-5"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(5)
				to_chat(user, narrate_body("There does not seem to be anything of note left on the bookshelf. If you want to start the search over, use the bookshelf in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bookcase/full4
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/bookcase/full4/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Like the other bookshelf, this one was also ransacked - rather brutally at that - by someone already. After a closer inspection, you notice that unlike the other bookshelf, this one seemed to be used to store something other than printed materials. At first glance, you take note that most of the items here seem to have been taken, not destroyed on the spot. There is more to find here."))
					icon_state = "bookcase-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Debris and ashes from the neighboring bookcase litter the top shelf, but at a glance, not much else seems to be here. Books were clearly stored here, but they were set on fire either on purpose or as colateral.  There is more to search through on this bookshelf."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You make sure you didn't miss anything and it's a good thing you did, as you discover a plastic device at the back of the shelf, obscured by a ruined book. You pick it up."))
						var/obj/item/cargo/efolder/pid/crypt_red/dud1/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					icon_state = "bookcase-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Searching through the bottom shelf finally gives you a hint to what was stored here. You quickly discover two smashed PDAs of an unknown maker in the back but upon closer inspection, you notice that several components have been ripped out of both PDAs before they were dumped here. They are likely useless. You should make sure you didn't miss anything; you feel like this shelf still has something to offer."))
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("You find an electronic folder under the PDAs. The folder seems to be undamaged, as if it was put here later than the other items. You take it with you"))
						var/obj/item/cargo/efolder/folder/crypt_red/dud2/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item2 = FALSE
					icon_state = "bookcase-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("After carefully examining the shelves again, you look at the back of the bookshelf and discover that this shelves' back board is loose, creating a gap. After a bit of stretching, you reach behind the bookshelf and feel around in the space between it and the wall. Among the dust and debris, you find what seems to be at least one deck of cards and one deck of tarot cards spread back there, likely fallen off the shelf and through the gap. While recovering them would likely take a lot of time, you at least seem to have found something that gives you an idea what was on this shelf. It still does not explain why the items here were spared their fate. You should take one final look to make sure you didn't miss anything."))
					icon_state = "bookcase-4"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(4)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bookcase."), SPAN_INFO("You search through the bookcase..."), SPAN_DANGER("You hear shuffling and the sound of rustling paper."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bookcase."), SPAN_INFO("You finish searching through part of the bookcase and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You check the bookshelf for anything that previous searches may have missed just to be sure. While you do not find anything new on the shelves themselves, you notice that the right side of the bookshelf has a small heart carved into it with 'A + C' etched inside.  There does not seem to be anything else to discover on this bookshelf."))
					icon_state = "bookcase-5"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(5)
				to_chat(user, narrate_body("There does not seem to be anything of note left on the bookshelf. If you want to start the search over, use the bookshelf in GRAB mode."))
				searchable_used = FALSE
				return
	return

//Office

/obj/structure/searchable/puzzle04/drawers_misc
	name = "storage drawers"
	desc = "Three drawers mounted in a frame that can be slid in and out. Looks like its seen better days."
	desc_lore = "Personal storage lockers come in all shapes and sizes, but open drawers such as this one are some of the most common. From clothes to personal effects, the availability and versatility of drawers like these means they are very widely used."
	icon_state = "cabinetdrawer"

/obj/structure/searchable/puzzle04/drawers_misc/full1

/obj/structure/searchable/puzzle04/drawers_misc/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("It is obvious that someone searched these drawers before you and they were not gentle. The bottom drawer seemed to be used to store paper and notebooks, now clumped together in one unruly mess of crumpled, blank paper. There does not seem to be anything of note here. Two drawers remain."))
					icon_state = "cabinetdrawer-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The middle drawer seems to have been used to store pens, highlighters and markers in surprisingly varied colors considering this is a space station. Someone went so far as to open and look inside some of the markers, destroying them in the process. This likely means that there is nothing to find here. There is one drawer left."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("As you are about to move on, a plastic PID device almost immediately catches your attention. It seems unlikely this was missed by whoever searched the drawers. You pick it up."))
						var/obj/item/cargo/efolder/pid/crypt_blue/dud1/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					icon_state = "cabinetdrawer-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer seemed to be used for storage of printing paper. Used to is the appropriate term because someone seems to have torn open, scattered, and searched through every package found in this drawer. It's a shame too, as someone seems to really have gone out of their way to stock all kinds of varied stationery. There does not seem to be anything else left to search here."))
					icon_state = "cabinetdrawer-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/drawers_misc/full2

/obj/structure/searchable/puzzle04/drawers_misc/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Someone has clearly searched these drawers before, but they didn't seem to spend much time looking through these. The bottom drawer is full of personal knicks knacks like sets of colored hairpins, assorted pens, and several sets of stickers. These seem to be mostly intact but there does not seem to be anything that could help right now. Two more drawers remain."))
					icon_state = "cabinetdrawer-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The middle drawer seems to contain assorted personal items like lipstick, two hairbrushes, deodorant, and hand moisturizer. As evidenced by the dried-out globs of some of the substances in tubes, someone seems to have tested what was inside every one of them before moving on. There does not seem to be anything else of note here. You can still search one more drawer."))
					icon_state = "cabinetdrawer-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer contains several clipboards that seem to have anything that was attached to them taken. Several of the clipboards have pens of various makes and colors attached to them. Someone seems to have gone to some effort to pick these when you think about it."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You notice that one of the clipboards has a plastic electronic device attached to it, which obviously stands out. You detach the device and take it with you."))
						var/obj/item/cargo/efolder/pid/crypt_blue/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					icon_state = "cabinetdrawer-3"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/drawers_files
	name = "document storage drawers"
	desc = "Three drawers mounted in a frame that can be slid in and out. The drawers have narrow slots that are meant to store paper documents. Looks like its seen better days."
	desc_lore = "Personal storage lockers come in all shapes and sizes, but open drawers such as this one are some of the most common. From clothes to personal effects, the availability and versatility of drawers like these means they are very widely used."
	icon_state = "filingcabinet"

/obj/structure/searchable/puzzle04/drawers_files/full1

/obj/structure/searchable/puzzle04/drawers_files/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Someone had already looked through these drawers and they were not gentle about it. The bottom drawer seems to be almost completely empty; a few clipboards and folders seem to indicate that whatever was inside was taken by whoever searched the drawers first. There is still more to search through in these drawers."))
					icon_state = "filingcabinet-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot a small plastic device in one of the slots that seems out of place, and you pick it up. It seems odd that whoever took everything else from this locker didn't take this device, perhaps it was placed here later."))
						var/obj/item/cargo/efolder/pid/crypt_blue/dud3/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The slots in the middle drawer seem to have been completely cleaned out. The tears on some of them seem to indicate that something was here and was rather violently removed, but you can only guess what the contents were. There is one more drawer left to search. "))
					icon_state = "filingcabinet-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer is labeled as 'Empties' and some of the slots contain empty folders and their plastic PID keys. The empty folders are of no use to you, but a quick count seems to indicate that twelve folder and PID key pairs were removed from here. You are done searching through these drawers, there is nothing more to find here."))
					icon_state = "filingcabinet-3"
					desc = "Three drawers mounted in a frame that can be slid in and out. The drawers have narrow slots that are meant to store paper documents. Looks like its seen better days."
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/drawers_files/full2

/obj/structure/searchable/puzzle04/drawers_files/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Looks like someone picked these drawers clean and was not gentle about it. It's clear that you are not the first person looking through these. There is very little left in the bottom drawer, but you find a few loose pieces of paper that seem to be parts of engineering reports about various parts of the station. There does not seem to be anything significant here, however. There are still two drawers to search."))
					icon_state = "filingcabinet-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You don't find anything that would even hint at what was stored in this drawer in its slots. They were clearly used before, but for what, you can only guess. There is one more drawer to search."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You find a small plastic device that clearly does not belong. It occurs to you that someone searching through these drawers would be very unlikely to miss this. You take the device with you."))
						var/obj/item/cargo/efolder/pid/crypt_blue/dud2/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					icon_state = "filingcabinet-2"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer seems to be mostly full of records of poker games between codenames, presumably Task Force 14 members, that stopped at the PST while the USCMC was still active. While there isn't anything that is helpful right now, you note that just by the variety of the various codenames, the station saw a lot TF14 members come and go. There does not seem to be anything else to find here."))
					icon_state = "filingcabinet-3"
					desc = "Three drawers mounted in a frame that can be slid in and out. The drawers have narrow slots that are meant to store paper documents. Looks like its seen better days."
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/drawers_smol
	name = "storage drawers"
	desc = "Two drawers mounted in a frame that can be slid in and out. Looks like its seen better days."
	desc_lore = "Personal storage lockers come in all shapes and sizes, but open drawers such as this one are some of the most common. From clothes to personal effects, the availability and versatility of drawers like these means they are very widely used."
	icon_state = "chestdrawer"

/obj/structure/searchable/puzzle04/drawers_smol/full1
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/drawers_smol/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("These drawers seem to have not been touched for quite a while and are a little hard to open at first. The bottom drawer is filled with what looks like Russian paperback novels all of which seem to feature the same character. You don't really have the time to take a closer look now. There is one more drawer to search."))
					icon_state = "chestdrawer-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot an electronic folder among the books which clearly does not belong. You pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_blue/dud1/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer creaks open with some resistance and is filled with multiple books written in what looks like Chinese at first glance. Looks like someone was working on translating these into English and it seems to have been a series of pulp novels about spacers. You don't really have time to go through these in detail right now."))
					icon_state = "chestdrawer-2"
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("You see an electronic folder that is left on top of one of the stacks of books and pick it up as it clearly does not belong here."))
						var/obj/item/cargo/efolder/folder/crypt_blue/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item2 = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/drawers_smol/full2
	var/searchable_item2 = TRUE

/obj/structure/searchable/puzzle04/drawers_smol/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place on the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("These drawers were clearly not commonly used and were not disturbed for quite a while. The bottom drawer resists for a few seconds, but when you open it, you find that it is full of carefully arranged and stored genuine manga tomes. You aren't sure, but it looks like they may also be genuine Earth prints, which are not easy to get. Someone took great care in storing them as well. You can go back to looking through this collection later."))
					icon_state = "chestdrawer-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You find an electronic folder put on top of a few thicker tomes and pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_blue/dud3/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the storage drawers."), SPAN_INFO("You search through the storage drawers..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the storage drawers."), SPAN_INFO("You finish searching through one of the drawers and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The top drawer opens with ease, though it does not seem to have been used for a while. The drawer is full of UA pulp fiction novels, mostly centering on Spacers. A quick glance at the back covers reveals that these books are not colonial reprints from Liquid Data repositories, but rather books manufactured back on Earth. While individual tomes are likely not worth much, the whole collection likely took some time to assemble. You can explore these books in detail later."))
					icon_state = "chestdrawer-2"
					if(searchable_item2 == TRUE)
						to_chat(user, narrate_body("You spot an electronic folder that clearly is not part of the collection and pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_blue/dud2/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item2 = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("These drawers have been throughly searched. There is nothing else to find here. If you want to start the search over, use the drawers in GRAB mode."))
				searchable_used = FALSE
				return
	return
//Lockers


/obj/structure/searchable/puzzle04/bunk_chest
	name = "bunk chest"
	desc = "A plain looking unsecured chest that has clearly seen better days."
	desc_lore = "Shorter chests like these are commonly used by crews of ships for bunk storage, hence their colloquial name since they are easy to stack and slide under one's bed. They are notoriously unsecure and no one typically stores anything they can't lose in those, usually opting to safeguard important items in the typically much more secure crew lockers."
	icon_state = "chest"

/obj/structure/searchable/puzzle04/bunk_chest/full1

/obj/structure/searchable/puzzle04/bunk_chest/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This chest seems to have not been used for quite a while and after opening it, it's easy to see why. The chest seems to have been cleaned almost completely out a while ago and there does not seem to be any trace left of what was stored here. It seems like there is nothing to find here, but you get the feeling that there is more to this chest than meets the eye."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("While the chest itself is empty, you notice a few scratch marks on the floor panel below it as if it was moved. You move the chest and find a hidden compartment under the tile but are immediately disappointed when it too turns out to be empty. There is nothing else to find here."))
					icon_state = "chest-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("As you move the chest back, you notice that there is a plastic PID key behind it. While it's unlikely it came from the chest, it seems out of place here. You pick it up."))
						var/obj/item/cargo/efolder/pid/crypt_yellow/dud1/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("This chest has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_chest/full2

/obj/structure/searchable/puzzle04/bunk_chest/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This chest seems to not have been used very frequently and not for a while, but a few personal items inside seem to be neatly arranged and taken care of. The chest contains a collection of colored scrunchies, multiple shades of various brands of lipstick and a small collection of perfumes. You can take a closer look to see if you spot anything else."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot a plastic PID key standing next to some of the lipstick. You pick it up as it clearly does not belong here."))
						var/obj/item/cargo/efolder/pid/crypt_yellow/dud2/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The chest was searched already, but a small collection of perfumes stands out. You note that not only are they hand mixed, but they also seem to come from artisanal shops back on Earth, which would make them exceptionally hard to get out in the Outer Veil. This says more about the owners' connections than wealth, as items like this are often more a matter of personal favors. There does not seem to be anything else to find here."))
					icon_state = "chest-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("This chest has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return

	return

/obj/structure/searchable/puzzle04/bunk_chest/full3
	var/searchable_bonus = TRUE

/obj/structure/searchable/puzzle04/bunk_chest/full3/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This chest does not seem to have been used for a while and clearly was someone's personal bunk. You find several pairs of what used to be fresh socks, two bottles of genuine Japanese sake, a small bottle of pills and a black folder. The pills and the folder seem to warrant further investigation."))
					if (searchable_bonus == TRUE)
						to_chat(user, narrate_body("You also spot what seems to be a bound notebook. Few people go through the trouble of having those scanned and bound unless they contain something of note, so you decide to take it with you."))
						log_game("[key_name(usr)] found the TWE journal")
						message_admins("[key_name(usr)] found the TWE journal")
						var/obj/item/cargo/book_handwritten/twejournal/book = new(get_turf(user))
						user.put_in_active_hand(book)
						searchable_bonus = FALSE
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Most of this chest was already searched, but a bottle of pills catches your eye. The bottle is clearly one used for prescribed medicine, but no tag seems to be present, nor are the pills stamped in any way. The pills seem very brittle, they are likely way past their expiration date. It occurs to you that with the security protocols of the PST, getting unlicensed medicine would be extremely hard, just as keeping both it and its presence in one's bloodstream while on station. You can likely consult on these pills later, but its best to leave them here. There seems to be more to find from this chest."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("A black folder remains undisturbed and the last thing to take a closer look at. The folder appears to be a mixture of scanner reports from across the system and handwritten calculations. At a glance it looks like someone was trying to calculate the path of something going through the sector. They do not seem to be particularly important right now. There does not seem to be anything else of note in this chest."))
					icon_state = "chest-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("A plastic PID key falls out of the folder when you first open it. You take it with you."))
						var/obj/item/cargo/efolder/pid/crypt_yellow/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("This chest has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_chest/full4

/obj/structure/searchable/puzzle04/bunk_chest/full4/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This chest seems to have been used recently and that alone makes it stand out from most of the things left in these rooms. The first thing that catches your attention when you open the chest is a small collection of destination tags from all over the Neroid Sector and beyond.  They seem to be stringed together with several colored string and someone clearly pays a lot of attention to this collection. It seems personal enough that you decide against taking it with you. There is more to find in this chest."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("There are several donut boxes inside the bunk, but upon closer inspection you discover that all but one is empty. One box has a very stale donut inside, it looks like it's been here for at least a month. There is more to find in this chest."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You also find a plastic PID key in the same box, which clearly does not belong there. You take it with you."))
						var/obj/item/cargo/efolder/pid/crypt_yellow/dud3/pid = new(get_turf(user))
						user.put_in_active_hand(pid)
						searchable_item = FALSE
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the bunk chest."), SPAN_INFO("You search through the bunk chest..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the bunk chest."), SPAN_INFO("You finish searching through part of the bunk chest and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Hidden behind the donut boxes is a small, shiny sphere with a red LED indicator. It takes you a moment to realize that what you are looking at is an UAAC-TIS data transfer sphere, Liquid Data devices the agency uses to synchronize intelligence across UA ships. It does not seem to be active, but taking one with you is likely a bad idea, as they are bound to be tracked. You take note of its location and decide to move on. This chest has been thoroughly searched, there is nothing else to find here."))
					icon_state = "chest-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("This chest has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_locker
	icon = 'icons/obj/structures/sp_searchable.dmi'
	icon_state = "locker"
	name = "locker"
	desc = "A personal locker without any visible locking mechanism. Looks like it has not been used for a while."
	desc_lore = "Personal locks with no electronic lock are typically simple storage options like closets but adapted to limited space on board ships and stations. Sometimes, some spacers use traditional locks to secure those, but most do not go out of their way to secure these, nor do they store anything that they cannot afford to lose."

/obj/structure/searchable/puzzle04/bunk_locker/full1

/obj/structure/searchable/puzzle04/bunk_locker/full1/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("The locker seems not to have been used for a while, though the inside seems to be regularly cleaned. There are several light, colorful dresses that seem to have been here for a while inside. You get the impression that they are above the quality that is typically used by spacers, even in their off hours. You can still find more in this locker."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot an electronic folder on the bottom of the locker and pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_yellow/dud1/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You don't seem to find any shoes in the shoe compartment of the locker, but you find what looks like an old box of hair dye stashed in the back. It does not seem to have been used, but it is two years old at this point and likely no longer viable. There does not seem to be anything else left to search in this locker."))
					icon_state = "locker-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("This locker has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_locker/full2

/obj/structure/searchable/puzzle04/bunk_locker/full2/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Unlike most of the other items found in this section of the station, the locker seems to be frequently used and kept clean, however there does not seem to be much in here now. The only thing you see after opening it is a vacuum sealed formal white USCMC uniform, with its insignia and identifying features removed. You get the feeling that you shouldn't be disturbing this. There is still more to search in this locker."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You check the shoe compartment and discover a box that contains a pair of dress shoes. If you had to guess, those go together with the uniform stored in this locker and probably should be left alone. There is nothing else to find here."))
					icon_state = "locker-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You spot an electronic folder tucked away in the back of the locker while putting the shoes back. You take it with you as it clearly does not belong."))
						var/obj/item/cargo/efolder/folder/crypt_yellow/dud2/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				to_chat(user, narrate_body("This locker has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_locker/full3

/obj/structure/searchable/puzzle04/bunk_locker/full3/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This locker clearly hasn't been used in a while and seemed to have been in worse shape than others you've seen around here to start with. You don't find any clothing inside, instead you find several carboard boxes containing empty bottles of various brands of sake. A quick look indicates that these include both distillations made on various colonies across known space, as well as those coming from Japan. There also seem to be a few UA copycat brands present. Someone clearly knows their sake. There is more to find here."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You find a box in the shoe compartment of the locker and open it to find a series of photographs of what looks like traditional Shinto shrines built on space stations, ships, and colonies around the known galaxy. What's particularly interesting is that some of these shots seem to be made inside of TWE ships and out in the open, something that is rarely allowed for anyone who is not an officer of the TWE Navy or Royal Commandos. These are interesting, but not of particular use to you right now. You make a note of them and move on. There still seems like there is more to find in this locker."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You take one final look at the locker, making sure you didn't miss anything and spot a small box in the far corner of the locker that seems different that the others stored here. You open it and see a collection of pins from an establishment called the Black Cat somewhere in Tokyo. You seem to remember that some entertainment venues use RFID chips hidden in such pins for their VIP members or regulars. They aren't of any particular use to you right now, however. There does not seem to be anything else to find in this locker."))
					icon_state = "locker-1"
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("As you put the box back, you notice that it was resting on top of an electronic folder that seemed out of place in the locker. You take it with you."))
						var/obj/item/cargo/efolder/folder/crypt_yellow/dud3/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("This locker has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

/obj/structure/searchable/puzzle04/bunk_locker/full4

/obj/structure/searchable/puzzle04/bunk_locker/full4/attack_hand(mob/user)
	if(searchable_used == TRUE)
		to_chat(usr, narrate_body("Someone is already searching this."))
		return
	searchable_used = TRUE
	if(user.a_intent == INTENT_GRAB)
		if(tgui_alert(user, "Do you want to start the search over? The object will be restored to its original state. Use HELP intent to search it. ", "Reset Confirmation", list("Yes", "No"), 0) == "Yes")
			user.visible_message(SPAN_NOTICE("[user] starts shuffling items back into their place in the [src.name]."), SPAN_INFO("You start shuffling items back into their place."), SPAN_DANGER("You hear shuffling."))
			if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user] finishes rearanging the [src.name]. Its like it was never touched."), SPAN_INFO("You are finished. You can now search the [src.name] again."), SPAN_DANGER("The shuffling noise stops."))
				searchable_step = 0
				icon_state = initial(icon_state)
				update_icon()
				searchable_used = FALSE
				return
			to_chat(usr,SPAN_WARNING("You moved too far away."))
			searchable_used = FALSE
			return
		else
			searchable_used = FALSE
			return
	if(user.a_intent == INTENT_HELP)
		switch(searchable_step)
			if(0)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("This locker has clearly not been used for quite a while, even when compared to the others found in this part of the station. The locker is full of bright, colorful Hawaiian style shirts, a total of twenty after counting. Upon closer inspection, you quickly realize that each shirt has been ruined in some fashion, typically by what looks like bullet or knife damage. One seems to have been on fire for a while, while another lost a whole sleeve. These don't seem to be particularly useful. There is more to find in this locker."))
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(1)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("Several pairs of shoes line the shoe compartment of the locker, each pair has either been worn or damaged by what seems to be a mixture of both the elements and physical damage. None of these are usable anymore and don't seem to be particularly useful otherwise. There is more to find in this locker."))
					if(searchable_item == TRUE)
						to_chat(user, narrate_body("You easily spot an electronic folder among the shoes that clearly does not belong here. You pick it up."))
						var/obj/item/cargo/efolder/folder/crypt_yellow/folder = new(get_turf(user))
						user.put_in_active_hand(folder)
						searchable_item = FALSE
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(2)
				user.visible_message(SPAN_NOTICE("[user] starts to search the locker."), SPAN_INFO("You search through the locker..."), SPAN_DANGER("You hear shuffling and the rustle of small objects."))
				if(do_after(user, SEARCH_TIME_NORMAL, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					user.visible_message(SPAN_NOTICE("[user] finishes searching the locker."), SPAN_INFO("You finish searching through part of the locker and take a moment to think about your findings..."), SPAN_DANGER("The shuffling noise stops."))
					to_chat(user, narrate_body("You take one last look at the locker and spot what looks to be a curious-looking empty cigarette pack. Upon taking a closer look, you see that the pack has a black, bold label that says <strong>'Mocne'</strong> on a white background and is otherwise colored red with no other text or labels. This seems out of place, even for UPP products which tend to be laxer on their labeling than TWE and UA are. There is nothing else to find here."))
					icon_state = "locker-1"
					update_icon()
					searchable_step += 1
					searchable_used = FALSE
					return
				to_chat(usr,SPAN_WARNING("You moved too far away."))
				searchable_used = FALSE
				return
			if(3)
				to_chat(user, narrate_body("This locker has been throughly searched. There is nothing else to find here. If you want to start the search over, use it in GRAB mode."))
				searchable_used = FALSE
				return
	return

//Log reader and logs
/obj/structure/eventterminal/puzzle04/log_reader
	name = "personal log viewer"
	desc = "A small portable computer with a set of speakers. It opens and closes but does not seem to have any visible way of entering commands."
	desc_lore = "Devices like these are normally simple password locked electronic logbooks, however this device seems to have been severely modified, particularly it seems to be able to function despite the PST's anomalous disruption field. The lack of a keyboard indicates that there must be some external way of triggering playback or authenticating the user to use this device, but one does not seem to be apparent by just looking at it."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	item_serial = "PERSONAL LOG VIEWER<br>ADAPTED FOR USE USING LD FRIENDLY MACHINERY BY ALY REED-WILO<br>PRODUCED IN THE OV-PST<hr>MANUFACTURE CODE: COMFORT-ELECTRONICS-LOGVIEWER"
	icon_state = "laptop_on"
	plane = GAME_PLANE
	var/playing_log = FALSE

/obj/structure/eventterminal/puzzle04/log_reader/attack_hand(mob/user as mob)
	if(playing_log == TRUE)
		terminal_speak("Log playback in progress...")
		return
	if(playing_log == FALSE)
		terminal_speak("TF-14 AAR VIEWER")
		terminal_speak("Awaiting AAR Folder.")
		to_chat(user, narrate_body("The terminal clearly awaits input, but it is missing a keyboard or anything else to interact with it."))
		return

/obj/structure/eventterminal/puzzle04/log_reader/attackby(obj/item/W, mob/user)
	if(playing_log == TRUE)
		to_chat(usr, narrate_body("The reader does not react. It seems to be already playing something back."))
		return
	if(istype(W, /obj/item/cargo/efolder/folder_pid))
		var/obj/item/cargo/efolder/folder_pid/F = W
		switch(F.efolder_folder_id)
			if("RED-33895-027-8032")
				playing_log = TRUE
				for (var/obj/structure/eventterminal/puzzle04/crypt_doorlock/T in world)
					for (var/obj/structure/machinery/light/marker/admin/A in world)
						if (A.light_id == "crypt_log")
							emoteas("beeps loudly, then starts to play a message.", 20)
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.langchat_color = "#b3183e"
							A.talkas("These are additional and closing comments for Operation Godbreaker, Commander Cassandra Reed reporting.")
							A.talkas("I left these comments out of my original report, A few loose ends and things to follow up.")
							A.talkas("At the tail end of the operation, with the cult... Out of the way, the crew of my ship and I did what we always do. We started to scour the station for information.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("takes a moment to collect herself, some shuffling is heard from the background.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("First, the obvious. The Godseekers are gone. I put a bullet in the head of their prophet myself, not wanting to find out whether his babbling about UA backing was true or not.")
							A.talkas("I confirmed his identity, and we can put at least one mystery to rest. He is indeed the rogue Upsilon researcher that my mother reported concerns about.")
							A.talkas("Somehow, I'm not surprised and likely neither is she. This still feels like part Wey-Yu hitjob.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("sighs loudly.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("Quite the irony that one. Anyway. With the Godseekrs out of the way, I followed through on the rest of the directives and proceeded to eliminate those constructs...")
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle04/crypt_doorlock, puzzlebox_unlock_1))
							A.talkas("These 'Upsilon' as they called the constructs. I assuming the name is not coincidence and this is based of stolen Wey-Yu tech.")
							A.talkas("Only one of them was able to answer my questions and only one of them survived our purge.")
							A.talkas("It calls itself 'Melinoe' and what it says... Well. Let's just say that I think at the very least, the Director should listen to this.")
							A.talkas("But it's huge. It could change everything, us, maybe even humanity as a whole.")
							A.talkas("At the very least, I'm sure my mother will be interested in meeting the synthetic namesake of her institute.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("sighs again, taps the desk the recorder is on in audible frustration.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("Fuck.", 15)
							A.talkas("I hate this. But this seems too important not to follow up.")
							A.talkas("Anyway, this is neither here nor there. The important thing for this report is that the Godseekers are no longer a threat and that their legacy...")
							A.talkas("Well, it's worth looking into. I'll provide more reports when I can.")
							playing_log = FALSE
							return
				return
			if("BLUE-93565-912-6463")
				for (var/obj/structure/eventterminal/puzzle04/crypt_doorlock/T in world)
					for (var/obj/structure/machinery/light/marker/admin/A in world)
						if (A.light_id == "crypt_log")
							emoteas("beeps loudly, then starts to play a message.", 20)
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.langchat_color = "#b3183e"
							A.talkas("These are additional and closing comments for Operation Voidseeker. Commander Cassandra Reed, reporting.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("takes a deep breath and exhales loudly for several seconds, seemingly at a loss for words.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("I kept my tone in the report itself professional, because this is no time to be imprecise due to my personal emotions, but on the inside, I'm... Not even sure how to describe it.")
							A.talkas("We're all in shock. Aly, myself, the crew of the Persephone, all of us. And yet none can deny what we saw.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("takes another deep breath. Taps her fingers against her desk audibly through the rest of the recording.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("Try as I may, I cannot put the two statements in question and as such, I will assume they are true.")
							A.talkas("First, there is a UA-wide conspiracy present within the USCMC that is secretly trying to provoke a war with the UPP using Black Goo based bioweapons and worse.")
							A.talkas("This station, the Upsilon, the Godseekers. Their leader was right. They DID have UA backing.")
							A.talkas("They are called 'Deep Void'. And taking the station was important, because...")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("takes another deep breath.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("...Because the Godseekers were right.")
							A.talkas("Liquid Data, as a whole, can be home to a living, intelligent consciousness. An independent living being with feelings and thoughts and the ability to learn and think in abstracts and all the other benchmarks my mother spent so much time thinking about.")
							A.talkas("It's here. It's alive. It's been alive longer than we existed and likely will survive us. With Melione's help... Let's just say it was similar to the Twilight Paradox.")
							A.talkas("When we knew what to look for... What was it that it said... 'In the ocean of data, amidst azure strands, she sleeps.' ")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("pauses again. The tapping gets faster.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("I need to consult with the director. Aly and me drew up a plan, a special STG, Task Force 14. Something to keep this under wraps.")
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle04/crypt_doorlock, puzzlebox_unlock_2))
							A.talkas("Melinoe had a suggestion of their own. A new Upsilon Generation, as they called it. To help safeguard and understand 'her', whatever 'she' is.")
							A.talkas("Explore the capabilities.")
							A.talkas("Make first contact.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("laughs nervously.")
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("How the hell did she know. This is not possible.")
							A.talkas("The details leading to my conclusions are in the report. I am on my way back to Earth right now to discuss this in person. There is work to be done.")
							playing_log = FALSE
							return
				return
			if("YELLOW-57665-681-6944")
				for (var/obj/structure/eventterminal/puzzle04/crypt_doorlock/T in world)
					for (var/obj/structure/machinery/light/marker/admin/A in world)
						if (A.light_id == "crypt_log")
							emoteas("beeps loudly, then starts to play a message.", 20)
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.langchat_color = "#b3183e"
							A.talkas("Commander Cassandra Reed. These are supplementary comments for Operation Torchbearer.")
							A.talkas("There is very little time. It worked. We lost all the Upsilon frames, but it worked.")
							A.talkas("I have a name. I have connections. I have a whole web to investigate. I'm also out of time.")
							A.talkas("Blackfire will happen within forty hours.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("starts to tap her fingers against the desk the recorder is on as she speaks.", 10)
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("We recovered the Upsilon spheres and prepared them as Melinoe instructed.")
							A.talkas("I'm concerned she's not telling me something. But it can't be helped. I can't go back to the station now.")
							A.talkas("All TF14 assets are watching planets most likely to be hit by Blackfire. We must be able to do something, right? We know what's coming.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("takes a deep breath. The tapping stops.", 30)
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("We've done all we could. We really, really tried. I guess time will tell if this makes a difference.")
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle04/crypt_doorlock, puzzlebox_unlock_3))
							A.talkas("Or maybe Melinoe is right. Maybe we have to wait for four to be properly formed to fully understand her and her constants and variables.")
							A.langchat_color = COLOR_WHITE
							A.name = "Cassandra"
							A.emoteas("sighs loudly and pauses for a few seconds.", 60)
							A.langchat_color = "#b3183e"
							A.name = "Voice of CDR. Cassandra Reed-Wilo"
							A.talkas("It is what it is. I have the best team in this part of the galaxy under me. We'll be fine.", 100)
							A.talkas("We'll be fine.")
							playing_log = FALSE
							return
				return
			else
				return


/obj/structure/eventterminal/puzzle04/final_log
	name = "inactive customized computer terminal"
	desc = "A standard computer terminal without any visible imprints. One of its sides is open and several cables are dangling out. This terminal seems to be inactive and does not respond to inputs."
	desc_lore = "Unlike the typical LNT, customized terminals are exceedingly rare on spaceships, partially due to the cost of the parts needed to maintain them and high chance of Crystalline contamination during Hyperspace jumps and partially because unrestricted software and hardware modifications can be a genuine threat to the lives of everyone on board a ship or installation. Getting found with one of those is typically at least grounds for an immediate and unpleasant CMISRS investigation."
	icon_state = "open_off"
	puzzlebox_id = "crypt_final_log"
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE

/obj/structure/eventterminal/puzzle04/final_log/attack_hand(mob/user)
	to_chat(usr, narrate_body("This terminal is inactive and there does not seem to be any way to turn it on."))
	return

/obj/structure/eventterminal/puzzle04/proc/play_final_log()
	for (var/obj/structure/machinery/light/marker/admin/A in world)
		if (A.light_id == "final_log")
			emoteas("buzzes and pops. The screen remains inactive.")
			A.name = "Robotic voice"
			A.langchat_color = "#1bdd4b"
			A.talkas("Warning. This system is at least 150 days behind its last scheduled maintenance period and its warranty is now void. Schedule maintenance now or risk losing your data.")
			A.talkas("Error. Latent code found in system buffer. Execute flag located. Identifying.")
			A.talkas("Message found. Playback instruction executing...")
			A.name = "Cassandra"
			A.langchat_color = "#b3183e"
			A.emoteas("audibly struggles to speak for a while, sniffles and coughs a few times.")
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("I uh... I...", 30)
			A.langchat_color = COLOR_WHITE
			A.name = "Cassandra"
			A.emoteas("breaks down for a few seconds and audibly weeps.")
			A.langchat_color = "#b3183e"
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("We failed. We failed so much. But how could we have not.")
			A.talkas("Literally all the world was against us. But that's... That's not what the problem was.")
			A.talkas("The problem was me. My arrogance.")
			A.langchat_color = COLOR_WHITE
			A.name = "Cassandra"
			A.emoteas("sniffs again and takes a few deep breaths. When she resumes speaking, her voice is much steadier.")
			A.langchat_color = "#b3183e"
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("I thought that the information about Blackfire was presented as something we could affect. I completely misunderstood the chain Pythia was presenting.")
			A.talkas("So did the Upsilon. So did everyone.")
			A.langchat_color = COLOR_WHITE
			A.name = "Cassandra"
			A.emoteas("sighs loudly.")
			A.langchat_color = "#b3183e"
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("Blackfire is not the result of a failure to investigate Deep Void. Blackfire was not a planned attack.")
			A.talkas("Blackfire happened because Task Force 14 exists. Because I exist and found Aly and Pythia.")
			A.talkas("The choice to create TF14, to investigate Deep Void is the mechanism that triggers Blackfire. This is what Pythia was warning me about.")
			A.langchat_color = COLOR_WHITE
			A.name = "Cassandra"
			A.emoteas("Sighs loudly and takes some time to compose herself again.")
			A.langchat_color = "#b3183e"
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("We now have a whole lot of evidence, enough to take down Deep Void... And the USCMC with it most likely. The question remains.")
			A.talkas("Who do we trust with it. Who do we go to. Who is uncorrupted. How do we get the information to them.")
			A.talkas("Do we even want to do this? I'll have to leave the decision in their hands, I don't have the right… They must know this is a death sentence to the Marines.")
			A.talkas("I could ask Pythia but...")
			A.langchat_color = COLOR_WHITE
			A.name = "Cassandra"
			A.emoteas("weeps quietly again, sniffs audibly.", 50)
			A.langchat_color = "#b3183e"
			A.name = "Voice of CDR. Cassandra Reed-Wilo"
			A.talkas("Melinoe is dead. They got to her. She knew this would happen and did what she had to. But the end effect is, we no longer have Pythia Interpreter. We no longer can focus her gaze.")
			A.talkas("Unless we do the unthinkable.")
			A.talkas("Unless we use a human Interpreter.")
			A.talkas("Alysia won't let me do it. I'm pretty sure she'll try to do it instead. Jokes on her. I'm not leaving here until she tries. We're doing this together, or not at all.")
			A.talkas("We have no illusions. Direct exposure to Pythia will pour Crystalline right into our cranial cavities. There is no way alive out of this.")
			A.talkas("But with the blueprint and Pythia herself... Maybe we can survive long enough to take Deep Void with us.")
			A.talkas("We owe them that much.")
			A.talkas("Reed, out.")
			A.talkas("I'm sorry.")
			open_doors("crypt_airlock_doors")
			puzzlebox_global_status = 99
			return
