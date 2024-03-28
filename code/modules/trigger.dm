/obj/effect/step_trigger/message
	var/message //the message to give to the mob
	var/once = 1

/obj/effect/step_trigger/message/memorial
	message = "Please stand silently for a moment of reflection and respect. "
	once = 0

/obj/effect/step_trigger/message/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		to_chat(M, SPAN_INFO("[message]"))
		if(once)
			qdel(src)

/obj/effect/step_trigger/teleport_fancy
	var/locationx
	var/locationy
	var/uses = 1 //0 for infinite uses
	var/entersparks = 0
	var/exitsparks = 0
	var/entersmoke = 0
	var/exitsmoke = 0

/obj/effect/step_trigger/teleport_fancy/Trigger(mob/M)
	var/dest = locate(locationx, locationy, z)
	if(!M || !istype(M))
		return

	M.Move(dest)

	if(entersparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(4, 1, src)
		s.start()
	if(exitsparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(4, 1, dest)
		s.start()

	if(entersmoke)
		var/datum/effect_system/smoke_spread/s = new /datum/effect_system/smoke_spread
		s.set_up(2, 1, src, 0)
		s.start()
	if(exitsmoke)
		var/datum/effect_system/smoke_spread/s = new /datum/effect_system/smoke_spread
		s.set_up(2, 1, dest, 0)
		s.start()

	uses--
	if(uses == 0)
		qdel(src)

/obj/effect/step_trigger/message/seeonce
	var/trigger_id = ""
	once = null

/obj/effect/step_trigger/message/seeonce/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("[message]"))
			M.saw_narrations.Add("[trigger_id]")
			if(once)
				qdel(src)

//Sector Patrol event specifc

/obj/effect/step_trigger/message/seeonce/D31Scn2

	trigger_id = "D31Entrance"

/obj/effect/step_trigger/message/seeonce/D31Scn2/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("The scanner hums around you. For a moment you feel slightly disoriented."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_EARTH]")
				to_chat(M, narrate_body("For a split second, you see the slowly reclaimed, barren landscapes of Earth and its overcrowded megacities. The crowds of Earth and their constant chattering feels warm and comforting somehow. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_LUNA]")
				to_chat(M, narrate_body("For a split second, you see the halls of the learning institutions on Luna. You feel elated by the amount of raw knowledge and thought produced here. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_MARS]")
				to_chat(M, narrate_body("For a split second, you find yourself in one of the largest of Mars' Arcologies, surrounded by the bustle of corporate work. The order and direction of the Corporate Standard feels familiar and comforting. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_JUPITER]")
				to_chat(M, narrate_body("For a split second, you see the forges of Jupiter. In the distance, new forges are being built, something unseen in the last few decades. The chaos of the activity here feels refreshing. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_INNERRIM]")
				to_chat(M, narrate_body("For a split second, you find yourself among the bruised and traumatized colonists of the Inner Rim. The Colony Wars still linger here. The silence seems soothing, despite everything that has happened here. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_VEIL]")
				to_chat(M, narrate_body("For a split second, you see a diagram of the Neroid Sector, with multiple vectors converging onto it from all sides. It feels like everyone's eyes are on the Sector right now, which is both exciting and concerning. The sensation passes as quickly as it comes."))
			if (M.client.prefs.chargen_birthright == "[CHARGEN_BIRTHRIGHT_OUTERRIM]")
				to_chat(M, narrate_body("For a split second, you peer into the blackness of deep space. Something moves into the abyss, it feels wrong. It feels like both a familiar, friendly presence and something else lingers somewhere out there, beyond light. The sensation passes as quickly as it comes."))
			M.saw_narrations.Add("[trigger_id]")

/obj/effect/step_trigger/message/seeonce/D31Ent

	trigger_id = "D31Ent"

/obj/effect/step_trigger/message/seeonce/D31Ent/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("Text."))
			M.saw_narrations.Add("[trigger_id]")

/obj/effect/step_trigger/message/seeonce/Pinnacle

	trigger_id = "Pinnacle"

/obj/effect/step_trigger/message/seeonce/Pinnacle/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("Text."))
			M.saw_narrations.Add("[trigger_id]")

/obj/effect/step_trigger/message/seeonce/Dorms

	trigger_id = "Dorms"

/obj/effect/step_trigger/message/seeonce/Dorms/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("Text."))
			M.saw_narrations.Add("[trigger_id]")

/obj/effect/step_trigger/message/seeonce/Crypt

	trigger_id = "Crypt"

/obj/effect/step_trigger/message/seeonce/Crypt/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("Text."))
			M.saw_narrations.Add("[trigger_id]")

/obj/effect/step_trigger/message/seeonce/CryptInner

	trigger_id = "CryptInner"

/obj/effect/step_trigger/message/seeonce/CryptInner/Trigger(mob/M)
	if(!istype(M) || !M)
		return
	if(M.client)
		if(!("[trigger_id]" in M.saw_narrations))
			to_chat(M, narrate_body("Text."))
			M.saw_narrations.Add("[trigger_id]")
