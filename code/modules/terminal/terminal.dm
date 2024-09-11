

/obj/structure/terminal/
	name = "terminal- master definition"
	desc = "This is a master item. It should not be placed anywhere in the game world."
	desc_lore = "If you have the time, please consider reporting this as a bug."
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "master"
	var/terminal_id = "default"
	var/list/terminal_buffer = list()
	var/list/terminal_trimmed_buffer = list()
	var/terminal_user
	var/list/terminal_observers = list()
	var/turf/terminal_user_turf
	var/terminal_input
	var/terminal_line_length = 70
	var/terminal_line_height = 19
	var/terminal_reserved_lines = 0
	var/terminal_window_size = "900x900"
	var/header_name = "NAME GOES HERE"
	var/terminal_header
	light_range = 3
	light_power = 3
	light_color = "#67ac67"
	light_system = HYBRID_LIGHT

/obj/structure/terminal/proc/new_user()
	if(!(terminal_id in usr.saw_narrations))
		terminal_display_line("New user detected. Welcome, [usr.name].")
		usr.saw_narrations.Add(terminal_id)
	else
		terminal_display_line("Welcome back, [usr].")
	terminal_input()
	return "end of input loop"

/obj/structure/terminal/proc/del_user()
	if(terminal_user != null)
		terminal_user << browse(null, "window=[terminal_id]")
	terminal_user = null
	terminal_user_turf = null
	kill_window()

/obj/structure/terminal/proc/check_user()
	if(terminal_user == usr && terminal_user_turf == get_turf(usr))
		return 1
	else
		return 0

/obj/structure/terminal/proc/WriteHeader()
	terminal_header = {"<center><b>[header_name]</b><br>UACM 2ND LOGISTICS</center>"}

/obj/structure/terminal/proc/AnimateUse(use)
	switch(use)
		if(null)
			return
		if(0)
			icon_state = "open_off"
			set_light(0)
			update_icon()
		if(1)
			icon_state = "open_ok"
			set_light(3)
			update_icon()

/obj/structure/terminal/Initialize(mapload, ...)
	WriteHeader()
	AnimateUse(0)
	. = ..()

/obj/structure/terminal/proc/reset_buffer() // resets terminal buffer and creates fresh list.
	terminal_trimmed_buffer = null
	terminal_trimmed_buffer = list()

/obj/structure/terminal/proc/kill_window()
	usr << browse(null, "window=[terminal_id]")
	if(terminal_observers.Find(usr) != 0) terminal_observers.Remove(usr)
	if(usr.sp_uis.Find(terminal_id) != 0) usr.sp_uis.Remove(terminal_id)

/obj/structure/terminal/proc/reset_terminal()
	if(check_user() == 1)
		reset_buffer()
		for(var/mob/mobs_to_reset_terminal in terminal_observers)
			mobs_to_reset_terminal << browse(null, "window=[terminal_id]")
		terminal_observers = null
		terminal_observers = list()
		del_user()
		return
	else
		to_chat(usr, SPAN_WARNING("Error: You are not the user of the terminal."))
		return

/obj/structure/terminal/proc/terminal_display() // Display loop. HTML encodes (which incidentally should also prevent a lot of HTML shenanigans since it escapes characters) and displays current buffer. Please don't laugh at my placeholder HTML -_- , in normal circumstances should not need edits unless you want to change the style for an individual terminal.
	if(terminal_observers.Find(usr) == 0) terminal_observers.Add(usr)
	trim_buffer()
	var/terminal_output = jointext(terminal_trimmed_buffer, "</p><p>")
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
    }
    .box {
    border-style: solid;
    height: 66px;
	width: 800px;
	}
    .text {
    padding: 0px 1em;
    }
	.text_head {
    padding: 0px 1em;
    }
    .box_console {
    border-style: solid;
    height: 734px;
	width: 800px;
    }
    .box_footer_container {
    text-align: center;
    height: 50px;
    border-style: solid;
	width: 800px;
    }
    .box_footer_left {
    float: left;
	height: 50px;
    border-style: none solid none none;
	width: 20%;
    }
    .box_footer_mid {
	height: 50px;
    float: left;
	width: 55%;
    }
    .box_footer_right {
    height: 50px;
	float: right;
    border-style: none none none solid;
	width: 20%;
    }
	#terminal_text {
	font-family: 'Courier New',
	cursive, sans-serif;
	color: #1bdd4b;
	text-align: left;
	padding: 0em, 1em;
	}
	</style>
	</head>
	<body>
	<div id = "terminal_text">
	<div class="box">
	<div class="text_head">
	<p>
	[terminal_header]
	</p>
	</div>
	</div>
	<div class="box_console">
	<div class="text">
	<p>
	[terminal_output]
	</p>
	</div>
	</div>
    <div class="box_footer_container">
    <div class="box_footer_left">
    <a href='?src=\ref[src];reset_terminal=1'><p>RESET</p></a>
    </div>
    <div class="box_footer_mid">
    <a href='?src=\ref[src];open_terminal=1'><p>START TYPING INTO THE CONSOLE</p></a>
    </div>
    <div class="box_footer_right">
    <a href='?src=\ref[src];close_terminal=1'><p>CLOSE</p></a>
    </div>
    </div>
	</div>
	</body>
	"}
	for(var/mob/mobs_to_show_terminal in terminal_observers)
		mobs_to_show_terminal << browse(terminal_html,"window=[terminal_id];display=1;size=[terminal_window_size];border=5px;can_close=0;can_resize=0;can_minimize=0;titlebar=0")
		if(mobs_to_show_terminal.sp_uis.Find(terminal_id) == 0)
			mobs_to_show_terminal.sp_uis.Add(terminal_id)

/obj/structure/terminal/proc/trim_buffer()
	while (terminal_trimmed_buffer.len > (terminal_line_height - terminal_reserved_lines))
		terminal_trimmed_buffer.Cut((1+terminal_reserved_lines),(2+terminal_reserved_lines))


/obj/structure/terminal/proc/terminal_display_line(text = null,delay = TERMINAL_STANDARD_SLEEP, cache = 0, center = 0) // cache = 1 bypasses displaying, this is for briefing terminals that may want to parse multiple lines before displaying
	var/line_to_display = text
	if(!line_to_display) return "null string passed to display line."
	terminal_trimmed_buffer.Cut(terminal_trimmed_buffer.len)
	if(length(line_to_display) > terminal_line_length)
		var/cut_line
		while(length(line_to_display) > terminal_line_length)
			cut_line = copytext(line_to_display,1,terminal_line_length)
			var/last_space = findlasttext(cut_line, " ")
			cut_line = copytext(line_to_display,1,last_space)
			if(center == 1)
				terminal_trimmed_buffer += ("<center>" + html_encode(cut_line) + "</center> &nbsp")
				terminal_buffer +=  ("<center>" + html_encode(cut_line) + "</center> &nbsp")
			else
				terminal_trimmed_buffer += (html_encode(cut_line) + "&nbsp")
				terminal_buffer +=  (html_encode(cut_line) + "&nbsp")
			if(cache == 0)
				if(center == 1) terminal_buffer += "</center>"
				terminal_display()
				if(delay != 0) sleep(delay)
			line_to_display = copytext(line_to_display,last_space,0)
	if(length(line_to_display) <= terminal_line_length)
		if(center == 1)
			terminal_trimmed_buffer += ("<center>" + html_encode(line_to_display) + "</center> &nbsp")
			terminal_buffer +=  ("<center>" + html_encode(line_to_display) + "</center> &nbsp")
		else
			terminal_trimmed_buffer += (html_encode(line_to_display) + "&nbsp")
			terminal_buffer +=  (html_encode(line_to_display) + "&nbsp")
		terminal_trimmed_buffer += html_encode(">_")
		if(cache == 0)
			terminal_display()
			if(delay != 0) sleep(delay)


/obj/structure/terminal/proc/terminal_parse(str) //Ideally, this is the only block that should be copied into definitions down the line. Yes, the whole block. HELP is what prints as an intro to new users as well, so it should be defined no matter what unless you want it to throw errors and break :P
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	switch(string_to_parse)
		if("HELP")
			terminal_display_line("Hello. I am a terminal and this is my help text.")
			terminal_input()
			return
		else
			terminal_display_line("Unknown Command Error Message.")
			terminal_input()
			return

/obj/structure/terminal/proc/terminal_input_loop()
	while(check_user() == 1)
		if(terminal_input == null)
			sleep(TERMINAL_STANDARD_SLEEP)
		else break
	if(terminal_user != null)
		to_chat(terminal_user, SPAN_WARNING("You moved away from the console."))
		del_user()
	return


/obj/structure/terminal/proc/terminal_input_prompt()
	terminal_input = tgui_input_text(terminal_user, message = "Please enter a command, use cancel or close the window to close the terminal.", title = "Terminal Input", encode = TRUE, timeout = 0)
	if(!terminal_input) del_user()
	else
		if(check_user() == 1)
			terminal_trimmed_buffer += (html_encode(">  [uppertext(terminal_input)]_"))
			terminal_buffer += (html_encode(">  [uppertext(terminal_input)]_"))
			terminal_display()
			sleep(TERMINAL_STANDARD_SLEEP)
			terminal_parse(str = terminal_input)
		else
			to_chat(terminal_user, SPAN_WARNING("You moved away from the console."))
			del_user()

/obj/structure/terminal/proc/terminal_input()
	if(check_user() == 1)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/terminal/, terminal_input_prompt))
		terminal_input_loop()
		return
	else
		if(terminal_user == usr)
			to_chat(terminal_user, SPAN_WARNING("You moved away from the console."))
			del_user()
			return
		else
			to_chat(usr, SPAN_WARNING("Someone else is alsready using the terminal, you can only watch."))
			return

/obj/structure/terminal/attack_hand(mob/user)
	if(terminal_user != null)
		terminal_display()
		return
	else
		terminal_user = usr
		terminal_user_turf = get_turf(usr)
		new_user()
		return

/obj/structure/terminal/Topic(href, list/href_list)
	if(..())
		return

	if(href_list["reset_terminal"])
		reset_terminal()
		return
	if(href_list["open_terminal"])
		terminal_input()
		return
	if(href_list["close_terminal"])
		kill_window()
		return
