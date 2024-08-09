

/obj/structure/terminal/
	name = "terminal- master definition"
	desc = "This is a master item. It should not be placed anywhere in the game world."
	desc_lore = "If you have the time, please consider reporting this as a bug."
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "master"
	var/terminal_id = "default"
	var/list/terminal_buffer = list()
	var/list/terminal_trimmed_buffer = list()
	var/terminal_busy = 0
	var/terminal_line_length = 70
	var/terminal_line_height = 21
	var/terminal_reserved_lines = 0
	var/terminal_window_size = "800x800"
	var/list/terminal_header = list()

/obj/structure/terminal/proc/reset_buffer() // resets terminal buffer and creates fresh list.
	terminal_trimmed_buffer = null
	terminal_trimmed_buffer = list()
	terminal_trimmed_buffer += terminal_header

/obj/structure/terminal/Initialize(mapload, ...)
	. = ..()
	if(terminal_header) terminal_trimmed_buffer += terminal_header

/obj/structure/terminal/proc/kill_window()
	usr << browse(null, "window=[terminal_id]")
	reset_buffer()

/obj/structure/terminal/proc/terminal_display() // Display loop. HTML encodes (which incidentally should also prevent a lot of HTML shenanigans since it escapes characters) and displays current buffer. Please don't laugh at my placeholder HTML -_- , in normal circumstances should not need edits unless you want to change the style for an individual terminal.
	trim_buffer()
	var/terminal_output = ("<p>" + jointext((terminal_trimmed_buffer), "</p><p>") + "/<p>")
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	width: calc(800px - 2em);
    }
    .box {
    border-style: solid;
    height: 66px;
    }
    .box_console {
    border-style: solid;
    height: 734px;
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
	[terminal_output]
	</p>
	</div>
    </div>
	</body>
	"}
	usr << browse(terminal_html,"window=[terminal_id];display=1;size=[terminal_window_size];border=5px;can_close=0;can_resize=0;can_minimize=0;titlebar=0")
	onclose(usr, "[terminal_id]")

/obj/structure/terminal/proc/trim_buffer()
	while (terminal_trimmed_buffer.len > (terminal_line_height - terminal_reserved_lines))
		terminal_trimmed_buffer.Cut((1+terminal_reserved_lines),(2+terminal_reserved_lines))


/obj/structure/terminal/proc/terminal_display_line(text = null,delay = TERMINAL_STANDARD_SLEEP, cache = 0) // cache = 1 bypasses displaying, this is for briefing terminals that may want to parse multiple lines before displaying
	var/line_to_display = text
	if(!line_to_display) return "null string passed to display line."
	if(length(line_to_display) > terminal_line_length)
		var/cut_line
		while(length(line_to_display) > terminal_line_length)
			cut_line = copytext(line_to_display,1,terminal_line_length)
			terminal_trimmed_buffer += (html_encode(cut_line) + "&nbsp")
			terminal_buffer +=  (html_encode(cut_line) + "&nbsp")
			if(cache == 0)
				terminal_display()
				if(delay != 0) sleep(delay)
			line_to_display = copytext(line_to_display,terminal_line_length,0)
	if(length(line_to_display) <= terminal_line_length)
		terminal_trimmed_buffer += (html_encode(line_to_display) + "&nbsp")
		terminal_buffer +=  (html_encode(line_to_display) + "&nbsp")
		if(cache == 0)
			terminal_display()
			if(delay != 0) sleep(delay)


/obj/structure/terminal/proc/terminal_parse(str) //Ideally, this is the only block that should be copied into definitions down the line. Yes, the whole block. HELP is what prints as an intro to new users as well, so it should be defined no matter what unless you want it to throw errors and break :P
	var/string_to_parse = uppertext(str)
	if(!string_to_parse) return "error - null string parsed"
	switch(string_to_parse)
		if("HELP")
			if(!(terminal_id in usr.saw_narrations))
				terminal_display_line("New user detected. Welcome, [usr.name]. Displaying help message:")
				terminal_display()
				usr.saw_narrations += terminal_id
			terminal_display_line("Hello. I am a terminal and this is my intro text.")
			terminal_input()
			return
		else
			terminal_display_line("Unknown Command Error Message.")
			terminal_input()
			return

/obj/structure/terminal/proc/terminal_input() //Asks for input, kills window on cancel or escape
	terminal_display_line(">_")
	terminal_display()
	var/terminal_input = tgui_input_text(usr, message = "Please enter a command, use cancel or close the window to close the terminal.", title = "Terminal Input", encode = TRUE, timeout = 0)
	if(!terminal_input)
		kill_window()
		return "normal exit"
	terminal_trimmed_buffer.Cut(terminal_trimmed_buffer.len)
	terminal_trimmed_buffer += (html_encode(">  [uppertext(terminal_input)]_"))
	terminal_buffer += (html_encode(">  [uppertext(terminal_input)]_"))
	terminal_display()
	sleep(TERMINAL_STANDARD_SLEEP)
	terminal_parse(str = terminal_input)


/obj/structure/terminal/attack_hand(mob/user)
	if(!(terminal_id in usr.saw_narrations))
		terminal_parse("help")
	else
		terminal_input()
	return "end of input loop"
