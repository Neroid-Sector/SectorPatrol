/client/proc/admin_blurb()
	set name = "Global Blurb Message"
	set category = "Admin.SectorPatrol"

	if(!check_rights(R_ADMIN|R_DEBUG))
		return FALSE
	var/duration = 5 SECONDS
	var/message = "ADMIN TEST"
	var/text_input = tgui_input_text(usr, "Announcement message", "Message Contents", message, timeout = 5 MINUTES)
	message = text_input
	duration = tgui_input_number(usr, "Set the duration of the alert in deci-seconds.", "Duration", 5 SECONDS, 5 MINUTES, 5 SECONDS, 20 SECONDS)
	var/confirm = tgui_alert(usr, "Are you sure you wish to send '[message]' to all players for [(duration / 10)] seconds?", "Confirm", list("Yes", "No"), 20 SECONDS)
	if(confirm != "Yes")
		return FALSE
	show_blurb(GLOB.player_list, duration, message, TRUE, "center", "center", "#bd2020", "ADMIN")
	message_admins("[key_name(usr)] sent an admin blurb alert to all players. Alert reads: '[message]' and lasts [(duration / 10)] seconds.")

/client/proc/prepare_admin_song_blurb()
	set name = "Setup Custom Song Blurb"
	set category = "Admin.SectorPatrol"

	if(!check_rights(R_ADMIN|R_DEBUG))
		return FALSE

	GLOB.song_title = tgui_input_text(usr, "Enter a Song Title", "Title selection", GLOB.song_title, MAX_MESSAGE_LEN, FALSE, TRUE, 0)
	GLOB.song_info = tgui_input_text(usr, "Enter a Song Artist/Album", "Artist/Album selection", GLOB.song_info, MAX_MESSAGE_LEN, FALSE, TRUE, 0)
	to_chat(src, SPAN_INFO("[GLOB.song_title] / [GLOB.song_info] set"))


/client/proc/cmd_admin_pythia_say() // Checks for a Pythia reciever and talks as it and any of its voices.
	set name = "Speak As Pythia"
	set category = "Admin.SectorPatrol"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	for (var/obj/structure/eventterminal/puzzle05/testament_of_sacrifice/T in world)
		if(!T)
			to_chat(usr, SPAN_WARNING("Error: Pythia reciever not spawned. Cannot pass say."))
			return
		var/pythia_say = tgui_input_text(src, "What to say as Pythia and its voices.", "Pythia Say Text", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = FALSE, timeout = 0)
		if(!pythia_say) return
		T.pythiasay(pythia_say)
		return

/client/proc/cmd_admin_mission_control_say() // Checks for a Pythia reciever and talks as it and any of its voices.
	set name = "Mission Control Comms"
	set category = "Admin.SectorPatrol"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/mission_control_say = tgui_input_text(src, "What to say as Mission Control into the general Radio Channel", "MC Say Text", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = FALSE, timeout = 0)
	if(!mission_control_say) return
	to_chat(world, "<span class='big'><span class='radio'><span class='name'>Mission Control<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005BOV-PST \u0028TC-MC\u0029\u005D </b></span><span class='message'>, says \"[mission_control_say]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
	return

/client/proc/cmd_start_sequence()
	set name = "Start Sequence"
	set category = "Admin.SectorPatrol"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/puzzlebox_admin_option = tgui_input_list(usr, "Select a Sequence", "Start Sequence", list("None - Leave", "Open Hideaway Podlocks", "Open TOS Outer Podlocks", "Open TOS Inner Podlocks"), 0)
	if (!puzzlebox_admin_option) return
	switch(puzzlebox_admin_option)
		if("None - Leave")
			return
		if("Open Hideaway Podlocks")
			for (var/obj/structure/machinery/door/poddoor/almayer/locked/A in world)
				if(A.id == "crypt-a")
					A.open()
		if("Open TOS Outer Podlocks")
			for (var/obj/structure/machinery/door/poddoor/almayer/locked/A in world)
				if(A.id == "crypt-b")
					A.open()
		if("Open TOS Inner Podlocks")
			for (var/obj/structure/machinery/door/poddoor/almayer/locked/A in world)
				if(A.id == "crypt-c")
					A.open()

/client/proc/cmd_save_turfs()

	set name = "Persistancy Save - Turfs and Objects"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	to_chat(world, SPAN_BOLDWARNING("Persistancy save initiated. Game may stop responding..."))
	sleep(5)
	GLOB.savefile_number += 1
	//Savefile number reference
	var/savefile/G = new("data/persistance/turf_obj_globals.sav")
	G["current_save"] << GLOB.savefile_number
	//Turfs
	to_chat(world, SPAN_BOLDWARNING("Saving modular turf data..."))
	sleep(5)
	var/savefile/S = new("data/persistance/turf_ovpst_[GLOB.savefile_number].sav")
	var/tile_xyz
	for(var/turf/open/floor/plating/modular/T in GLOB.turfs_saved)
		tile_xyz = "[T.x]-[T.y]-[T.z]"
		S.cd = "/[tile_xyz]"
		S["tile_top_left"] << T.tile_top_left
		S["tile_top_rght"] << T.tile_top_rght
		S["tile_bot_left"] << T.tile_bot_left
		S["tile_bot_rght"] << T.tile_bot_rght
		S["tile_seal"] << T.tile_seal
	to_chat(world, SPAN_BOLDWARNING("Turf data saved."))
	//Objects
	to_chat(world, SPAN_BOLDWARNING("Saving object data..."))
	var/savefile/I = new("data/persistance/objects_ovpst_[GLOB.savefile_number].sav")
	var/item_index = 0
	for(var/obj/obj in GLOB.objects_saved)
		var/turf/groundloc = get_turf(obj)
		if (groundloc != null)
			item_index += 1
			I.cd = "/[item_index]"
			I["objtype"] << obj.type
			I["name"] << obj.name
			I["desc"] << obj.desc
			I["desc_lore"] << obj.desc_lore
			I["x"] << groundloc.x
			I["pixel_x"] << obj.pixel_x
			I["y"] << groundloc.y
			I["pixel_y"] << obj.pixel_y
			I["z"] << groundloc.z
			I["customizable"] << obj.customizable
			I["customizable_desc"] << obj.customizable_desc
			I["customizable_desc_lore"] << obj.customizable_desc_lore
			I["dorms_PrimaryStorage"] << obj.dorms_PrimaryStorage
			I["dorms_ItemOwner"] << obj.dorms_ItemOwner
	I.cd = "/general"
	I["item_index_max"] << item_index
	to_chat(world, SPAN_BOLDWARNING("Object data saved."))
	to_chat(world, SPAN_BOLDWARNING("Persistancy save complete. You may resume playing."))

/client/proc/cmd_load_turfs()

	set name = "Persistancy Load - Turfs and Objects"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	to_chat(world, SPAN_BOLDWARNING("Performing persistant data load. The game may stop responidng..."))
	sleep(5)
	var/savefile/G = new("data/persistance/turf_obj_globals.sav")
	G["current_save"] >> GLOB.savefile_number
	to_chat(world, SPAN_BOLDWARNING("Loading turfs..."))
	var/savefile/S = new("data/persistance/turf_ovpst_[GLOB.savefile_number].sav")
	var/tile_xyz
	for(var/turf/open/floor/plating/modular/T in GLOB.turfs_saved)
		tile_xyz = "[T.x]-[T.y]-[T.z]"
		S.cd = "/[tile_xyz]"
		S["tile_top_left"] >> T.tile_top_left
		S["tile_top_rght"] >> T.tile_top_rght
		S["tile_bot_left"] >> T.tile_bot_left
		S["tile_bot_rght"] >> T.tile_bot_rght
		S["tile_seal"] >> T.tile_seal
		T.update_icon()
	to_chat(usr, SPAN_BOLDWARNING("Modular turf data restored."))
	to_chat(usr, SPAN_BOLDWARNING("Restoring item data..."))
	var/savefile/I = new("data/persistance/objects_ovpst_[GLOB.savefile_number].sav")
	var/item_index
	var/current_index = 0
	var/item_x
	var/item_y
	var/item_z
	var/item_type
	I.cd = "/general"
	I["item_index_max"] >> item_index
	while(current_index < item_index)
		current_index += 1
		I.cd = "/[current_index]"
		I["objtype"] >> item_type
		I["x"] >> item_x
		I["y"] >> item_y
		I["z"] >> item_z
		var/obj/newitem = new item_type(locate(item_x, item_y, item_z))
		I["name"] >> newitem.name
		I["desc"] >> newitem.desc
		I["desc_lore"] >> newitem.desc_lore
		I["pixel_x"] >> newitem.pixel_x
		I["pixel_y"] >> newitem.pixel_y
		I["customizable"] >> newitem.customizable
		I["customizable_desc"] >> newitem.customizable_desc
		I["customizable_desc_lore"] >> newitem.customizable_desc_lore
		I["dorms_PrimaryStorage"] >> newitem.dorms_PrimaryStorage
		I["dorms_ItemOwner"] >> newitem.dorms_ItemOwner
		newitem.PersistantObject = TRUE
		newitem.update_icon()
		newitem.update_custom_descriptions()
		if (newitem.dorms_PrimaryStorage == 1) newitem.update_dorm_storage()
	to_chat(world, SPAN_BOLDWARNING("Object data loaded."))
	to_chat(world, SPAN_BOLDWARNING("Persistancy load complete. You may resume playing."))

/client/proc/cmd_save_cargo()

	set name = "Persistancy - Save Cargo Status"
	set category = "Admin.SectorPatrol"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/savefile/G = new("data/persistance/cargo/ovpst.sav")
	G["ldpol"] << (GLOB.testcrew_ldpol + GLOB.resources_ldpol)
	G["metal"] << (GLOB.testcrew_metal + GLOB.resources_metal)
	G["resin"] << (GLOB.testcrew_resin + GLOB.resources_resin)
	G["alloy"] << (GLOB.testcrew_alloy + GLOB.resources_alloy)
	to_chat(src, SPAN_BOLDWARNING("Data Stores Updated and Saved."))

/client/proc/cmd_load_cargo()

	set name = "Persistancy - Load Cargo Status"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/savefile/G = new("data/persistance/cargo/ovpst.sav")
	G["ldpol"] >> GLOB.testcrew_ldpol
	G["metal"] >> GLOB.testcrew_metal
	G["resin"] >> GLOB.testcrew_resin
	G["alloy"] >> GLOB.testcrew_alloy
	to_chat(src, SPAN_BOLDWARNING("Data Stores Loaded."))

/client/proc/cmd_set_cargo()

	set name = "Set Cargo Status"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	tgui_input_number(usr, "Enter LDPol Store value", "LDPol", GLOB.testcrew_ldpol, timeout = 0)
	tgui_input_number(usr, "Enter Metal Store value", "Metal", GLOB.testcrew_metal, timeout = 0)
	tgui_input_number(usr, "Enter Resin Store value", "Resin", GLOB.testcrew_resin, timeout = 0)
	tgui_input_number(usr, "Enter Alloy Store value", "Alloy", GLOB.testcrew_alloy, timeout = 0)

/client/proc/cmd_show_resources()
	set name = "View Map and Total Resource Info"
	set category = "Admin.SectorPatrol"

	if(!check_rights(R_ADMIN|R_DEBUG))
		return FALSE

	to_chat(src, narrate_head("Resource Stores information:"))
	to_chat(src, narrate_body("Test Crew Stores:"))
	to_chat(src, narrate_body("LD-Pol: [GLOB.testcrew_ldpol]"))
	to_chat(src, narrate_body("Metal: [GLOB.testcrew_metal]"))
	to_chat(src, narrate_body("Resin: [GLOB.testcrew_resin]"))
	to_chat(src, narrate_body("Alloy: [GLOB.testcrew_alloy]"))
	to_chat(src, "<hr>")
	to_chat(src, narrate_body("Current level information:"))
	to_chat(src, narrate_body("LdPol - [GLOB.resources_ldpol] / [GLOB.salvaging_total_ldpol]"))
	to_chat(src, narrate_body("Metal - [GLOB.resources_metal] / [GLOB.salvaging_total_metal]"))
	to_chat(src, narrate_body("Alloy - [GLOB.resources_resin] / [GLOB.salvaging_total_resin]"))
	to_chat(src, narrate_body("Resin - [GLOB.resources_alloy] / [GLOB.salvaging_total_alloy]"))
	to_chat(src, narrate_body("Intel - [GLOB.salvaging_intel_items] / [GLOB.salvaging_total_intel_items]"))
	to_chat(src, narrate_body("Hacks - [GLOB.salvaging_intel_hacks] / [GLOB.salvaging_total_intel_hacks]"))

/client/proc/cmd_save_dorms()

	set name = "Persistancy Save - Dorms"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	to_chat(world, SPAN_BOLDWARNING("Saving dorms data..."))
	sleep(5)
	var/savefile/S = new("data/persistance/ovpst_dorms.sav")
	var/dorm_tag
	for(var/obj/structure/dorm_button/T in GLOB.dorms_button_list)
		dorm_tag = T.dorm_id_tag
		S.cd = "/[dorm_tag]"
		S["dorm_owner_name"] << T.dorm_owner_name
	to_chat(world, SPAN_BOLDWARNING("Dorms data saved."))

/client/proc/cmd_load_dorms()

	set name = "Persistancy Load - Dorms"
	set category = "Admin.Peristancy"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	to_chat(world, SPAN_BOLDWARNING("Loading dorms data..."))
	sleep(5)
	var/savefile/S = new("data/persistance/ovpst_dorms.sav")
	var/dorm_tag
	for(var/obj/structure/dorm_button/T in GLOB.dorms_button_list)
		dorm_tag = T.dorm_id_tag
		S.cd = "/[dorm_tag]"
		S["dorm_owner_name"] >> T.dorm_owner_name
	to_chat(world, SPAN_BOLDWARNING("Dorms data loaded."))
	to_chat(world, SPAN_BOLDWARNING("Moving Claimed Objects into designated Primary Storage lockers..."))
	for(var/obj/objects in world)
		if (objects.dorms_ItemOwner) objects.move_to_primary_dorm_locker()
	to_chat(world, SPAN_BOLDWARNING("Dorm data load complete!"))
