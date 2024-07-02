/obj/structure/terminal/buffer_reader
	name = "modified personal terminal"
	desc = "A personal terminal with custom key caps on the keyboard that seem to be louder than the standard issue ones. A small inscription on the side of the monitor reads 'LD Buffer Logs Collector'. "
	desc_lore = "Unlike the typical LNT, customized terminals are exceedingly rare on spaceships, partially due to the cost of the parts needed to maintain them and high chance of Crystalline contamination during Hyperspace jumps and partially because unrestricted software and hardware modifications can be a genuine threat to the lives of everyone on board a ship or installation. Getting found with one of those is typically at least grounds for an immediate and unpleasant CMISRS investigation."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	icon_state = "open_ok"
	terminal_id = "buffer_reader"
	item_serial = "UACM-OVPST-DRM37-LOGBFR"

/obj/structure/terminal/terminal_parse(str)
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	switch(string_to_parse)
		if("HELP")
			if(!(terminal_id in usr.saw_narrations))
				terminal_display_line("New user detected. Welcome, [usr.name]. Displaying help message:")
				usr.saw_narrations += terminal_id
			terminal_display_line("Hi, welcome to the Liquid Data Emergency Buffer Database!")
			terminal_display_line("We've made some progress in maintaining those thanks to our new LD caretaker. Specifically, we can now cycle messages out of any LD emergency buffer we can find into this centralized unit.")
			terminal_display_line("These messages still must exist somewhere, but at least it's one place now and we know where it is.")
			terminal_display_line("Using any terminal while having a chipped dog tag on should be more than enough for our Friend to grab any message in its LD buffer. Deletion is not instantaneous and takes several hours to sync, so no need to stay behind for that.")
			terminal_display_line("Meanwhile, on this terminal you can use the command LIST to see all available messages or a 12-character message ID to view a specific message.")
			terminal_display_line("Each message found is not only information preserved, it can also contain valuable intel, please keep that in mind when viewing terminals out on assignment.")
			terminal_display_line("Have fun!")
			terminal_display_line("-Aly.")
		if("LIST")
			terminal_display_line("LD Emergency Buffer Archive")
			terminal_display_line("ID              |SUBJECT                          |DATE RECOVERED|")
			terminal_display_line("GEN-000-000-001 |Warning: On these messages.      |    MM/DD/YYYY|")
			terminal_display_line("UAM-712-317-210 |Testing, Testing...              |   AUG/21/2185|")
			terminal_display_line("MAR-021-112-935 |USCMC Automated Distress Beacon  |   AUG/21/2185|")
			terminal_display_line("GBR-891-221-211 |Immininent failure of all systems|   AUG/21/2185|")
			terminal_display_line("UPS-103-333-444 |We can help.                     |   AUG/21/2185|")
			terminal_display_line("EME-021-112-153 |It's up to you now.              |   AUG/21/2185|")
		if ("GBR-891-221-211")
			terminal_display_line("Message found. Accessing...")
			terminal_display_line("From: A-WATCHTOWER")
			terminal_display_line("Subject: Immininent failure of all systems.")
			terminal_display_line("Fellow Godseekers.")
			terminal_display_line("I don't know how many of you are left, but D-Navigator was lost. UAAC-TIS most likely gained access to all operational archives.")
			terminal_display_line("E-Librarian claimed that the wiping process has started, but there is no way that all of it was destroyed.")
			terminal_display_line("Assume your identities were compromised and they are coming for you.")
			terminal_display_line("Not that it matters. They know about the knot and are coming here.")
			terminal_display_line("It's been an honor.")
			terminal_display_line("I doubt anything will survive once they discover what the 'prophet' has done here.")
			terminal_display_line("-A-Watchtower.")
		else
			terminal_display_line("Unknown Command Error Message.")
	terminal_input()
