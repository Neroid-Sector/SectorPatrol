/obj/structure/eventterminal/puzzle03/historyterm
	name = "local network terminal"
	desc = "A standard computer terminal with the words 'LNT' imprinted on its side. Activated by standing in its proximity. It appears to be in standby mode."
	desc_lore = "Local Network Terminals typically regulate local functions of a given area or are used to interface with bigger systems on a ship or installation. They distinction technically means that the terminal interfaces with the local AI somehow, but few outside of systems engineers use the term for its actual intended purpose, sometimes mistaking other terminal types for LNTs."
	icon = 'icons/obj/structures/machinery/clio_term.dmi'
	plane = GAME_PLANE
	var/puzzlebox_playing = FALSE
	var/puzzlebox_parser_mode = "HOME"
	var/puzzlebox_complete = FALSE
	var/puzzlebox_saw_lesson1 = FALSE
	var/puzzlebox_saw_lesson2 = FALSE
	var/puzzlebox_saw_lesson3 = FALSE
	var/puzzlebox_saw_lesson4 = FALSE
	icon_state = "open_ok"
	puzzlebox_id = "historylessons"
	item_serial = "UACM-OVPST-PEAK-ORIENTATION-TERM"

/obj/structure/eventterminal/puzzle03/historycrt
	name = "wall mounted display"
	icon = 'icons/obj/structures/machinery/displaymonitor.dmi'
	desc = "A large-scale display, safely mounted inside a slot made in the hull of the station."
	desc_lore = "Computer displays on most ships tend to be adjusted for single colored text, initially due to lack of technology that allowed for better quality displays to survive out in space. Over time this became more a habit than anything else, as evidenced by PDAs which do not limit themselves in terms of display capabilities. Large scale displays such as this one have resisted over a hundred years' worth of technological progress and still reign supreme across human space ships. Truly, you are looking at a classic. For better or worse."
	icon_state = "off"
	puzzlebox_id = "theatherscreen"
	layer = OBJ_LAYER
	plane = GAME_PLANE

/obj/structure/eventterminal/puzzle03/historycrt/attack_hand(mob/user as mob)
	to_chat(usr, narrate_body("There does not seem to be any way of controlling the monitor, it only has status indicators. Perhaps there is a console somewhere around here."))
	return

/obj/structure/eventterminal/puzzle03/historycrt/proc/lesson1()
	for (var/obj/structure/eventterminal/puzzle03/historyterm/T in world)
		for (var/obj/structure/machinery/light/marker/admin/A in world )
			if (A.light_id == "theathervoice")
				T.puzzlebox_playing = TRUE
				icon_state = "uacm"
				update_icon()
				emoteas("comes alive and displays the UACM logo.")
				A.name = "Voice of RDML. Boulette"
				A.langchat_color = "#25664d"
				A.talkas("Welcome back home, Marines.")
				A.talkas("As some of you may already know, I am Admiral Boulette and I will be the officer in charge of the entire Second Logistics division of the UACM.")
				A.talkas("While the name 'division' may sound impressive, it's not meant to be this way.")
				A.langchat_color = COLOR_WHITE
				A.name = "RDML. Boulette"
				A.emoteas("clears his throat audibly.")
				A.langchat_color = "#25664d"
				A.name = "Voice of RDML. Boulette"
				A.talkas("I will be frank. Part of the reason why Commanders Reed-Wilo and myself have been given such broad permissions in how to organize and setup the PST...")
				A.talkas("...is that as I believe, they do not think any of what we're trying to achieve is possible. ")
				A.name = "RDML. Boulette"
				A.langchat_color = COLOR_WHITE
				A.emoteas("pauses for a few seconds and takes a deep breath.", 60)
				A.name = "Voice of RDML. Boulette"
				A.langchat_color = "#25664d"
				A.talkas("Everyone that is in any major way connected to the USCMC or Task Force 14, I think everyone just sort of expects the victims of the purges to just lay there and die.")
				A.talkas("It's unfair. Unjust. And that is why we are all here.")
				A.talkas("I can guarantee you that everyone in the Second has someone to prove wrong. That includes myself and the Reed-Wilos.")
				A.talkas("Before I'll let you go and move into your new home, I would like you to take the time and review briefings recorded by myself and the commanders.")
				A.talkas("Where we will briefly explain the purpose of the Second Logistics and the PST.")
				T.puzzlebox_playing = FALSE
				A.name = "RDML. Boulette"
				A.langchat_color = COLOR_WHITE
				A.emoteas("takes an audible deep breath.")
				A.name = "Voice of RDML. Boulette"
				A.langchat_color = "#25664d"
				A.talkas("I also believe that Cassandra left you something about her involvement in the demise of the USCMC and your personal fortunes during those events. I ask that you hear her out.")
				A.talkas("I can assure you that I would not agree to any of this, or their presence, if I didn't think they were genuinely trying to make amends.")
				A.talkas("I assure you; we won't be long. Again, welcome back to the UACM. Welcome home, Marines.")
				emoteas("flickers and shuts down.")
				icon_state = "off"
				update_icon()
				T.puzzlebox_playing = FALSE
				if(T.puzzlebox_saw_lesson1 == FALSE) T.puzzlebox_saw_lesson1 = TRUE
				return

/obj/structure/eventterminal/puzzle03/historycrt/proc/lesson2()
	for (var/obj/structure/eventterminal/puzzle03/historyterm/T in world)
		for (var/obj/structure/machinery/light/marker/admin/A in world )
			if (A.light_id == "theathervoice")
				T.puzzlebox_playing = TRUE
				icon_state = "blank"
				update_icon()
				emoteas("turns on with an audible pop.")
				A.name = "Voice of RDML. Boulette"
				A.langchat_color = "#25664d"
				A.talkas("This part of orientation means to remind you all how we got here through our rocky history.")
				emoteas("prints the Admiral's speech as the admiral speaks.")
				icon_state = "text"
				update_icon()
				A.talkas("While the UACM seeks to unify and improve the model, it itself is not a revolution. The USCMC however, the formation preceding it, was.")
				A.talkas("The Colony Wars ended in 2128 and left all major superpowers virtually without colonial fleets. The UA elected to elevate one of its smaller member formations, the US Marines, and use them as a foundation to build a new colonial QRF.")
				A.talkas("Built in partnership with Weyland-Yutani and some smaller corporate consortiums, the newly minted Marines were a strength to be reckoned with.")
				A.talkas("With the horrors of the Colony Wars still fresh in the mind of everyone in the colonies, but a new wave of exploration and colonization clearly more than ready to go following the end of the war, the Marines would soon be baptized in fire.")
				A.talkas("They called it The Sweep, although the name just like most of its infamy was attributed to the operation post-factum.")
				A.talkas("Today, we know that this victory was likely more a matter of overwhelming numbers than the supposed tactical and training superiority of the USCMC, but for better or worse...")
				A.talkas("...The label of fierce, scrappy warriors that were protectors of the common colonist stuck with the Marines for decades. As did the peace that they carved out in the Veil.")
				A.langchat_color = COLOR_WHITE
				icon_state = "blank"
				update_icon()
				A.name = "RDML. Boulette"
				A.emoteas("pauses for a few seconds and sighs audibly.")
				A.langchat_color = "#25664d"
				A.name = "Voice of RDML. Boulette"
				icon_state = "text"
				update_icon()
				A.talkas("It was at this time that other formations were called to life, the UAAC seeking to replicate its success. Marine leadership would claim these formations denied the USCMC resources they needed to keep the peace.")
				A.talkas("But the truth was, from the get-go the Marines were built to fail. The formation grew exponentially during the sweep, with no infrastructure ready for existing as a peacekeeping force.")
				A.talkas("And this is what it became. In addition, the corporate elements within the Marines as well as poor screening of hires led to a drastic drop in morale and discipline.")
				A.talkas("This could not have happened at a worse time. The Veil would soon see a massive colonization effort, following by an exponential increase of the illegal and hostile activity it brings. The Second Galactic Gold Rush had begun.")
				A.talkas("By 2170 the Marines were a shadow of their former self, although still functional as a formation and doing well enough by momentum alone, it was somewhere around this time that some High Command officers would come to believe that drastic action was needed.")
				A.talkas("I'm not going to bother regaling how that ended. Some of you may have been Marines by then, so you all know how it looked from the inside.")
				A.langchat_color = COLOR_WHITE
				icon_state = "blank"
				update_icon()
				A.name = "RDML. Boulette"
				A.emoteas("pauses and remains silent for a while...", 50)
				A.langchat_color = "#25664d"
				A.name = "Voice of RDML. Boulette"
				icon_state = "text"
				update_icon()
				A.talkas("Regardless of what happened with the USCMC and who was responsible, the UACM does not want to repeat its mistakes.")
				A.talkas("In what is relevant to us and the station, logistics specialists, such as myself, have been called to make sure that the joint armed force does not suffer from such catastrophic mismanagement and theft of resources as the USCMC did.")
				A.talkas("This seemed like the perfect chance to implement, or at least try to implement, something that is my life's work. A centralized, standardized logistics and delivery system.")
				A.talkas("It was only after I had started that I found out, through Commander Reed-Wilo, that my theories were already liked by someone high up. Unfortunately it was the person organizing logistics for Deep Void.")
				A.talkas("This station is one of the cornerstones of this system, but instead of people it relies mostly on automated drones of various sizes and purposes. The part of orientation about the PST will go into more detail about its origins.")
				A.talkas("However, in a broad sense, this is the purpose of the Second Logistics. We are here to implement, at first in a local capacity, across the Neroid Sector, a broad network of logistics, communications, and early warning systems.")
				A.talkas("Unfortunately, as I mentioned at the start, I do not get the feeling we are expected to succeed. Not only because this station's core functions depend on technology that does not exist. Believe it or not, UAAC-TIS claims they have that one covered.")
				A.talkas("I had made it clear from the start that I intended to reach out to USCMC personnel that were cleared of any involvement with the traitors, and yet still were sent home and blacklisted. Personnel like you.")
				A.talkas("Not only will this place serve as a starting point for your second chance in the Marines and a place among the stars, where I feel like most of you belong.")
				emoteas("switches to the UACM logo.")
				icon_state = "uacm"
				update_icon()
				A.talkas("Here, we will also recover old USCMC vessels, which like you have been left to rot or worse and either adapt them to service in the UACM or claim them as our own.")
				A.talkas("Those that we keep, we will keep as prototype units, each fitted with whatever technology UACM wants us to test. These ships will be ours, or rather yours to use as their Test Crews, which is your formal assignment on the PST.")
				A.talkas("There are other duties related to the maintenance of the PST and its core systems, however as those are still being brought on-line, these will be introduced to you in time.")
				A.talkas("For now, your focus should be on getting as comfortable as you can in your new dorms. You will likely be called to help as systems across the station are completed and tested.")
				A.talkas("You will also receive briefings on SOP and Maritime Law as our CMISRS office establishes itself. I'm sure some of you have already met LT. Foster.")
				A.talkas("This concludes this presentation. Thank you for your attention.")
				emoteas("flickers and shuts down.")
				icon_state = "off"
				update_icon()
				T.puzzlebox_playing = FALSE
				if(T.puzzlebox_saw_lesson2 == FALSE) T.puzzlebox_saw_lesson2 = TRUE
				return

/obj/structure/eventterminal/puzzle03/historycrt/proc/lesson3()
	for (var/obj/structure/eventterminal/puzzle03/historyterm/T in world)
		for (var/obj/structure/machinery/light/marker/admin/A in world )
			if (A.light_id == "theathervoice")
				T.puzzlebox_playing = TRUE
				icon_state = "blank"
				update_icon()
				emoteas("turns on with an audible pop.")
				A.name = "Voice of RDML. Boulette"
				A.langchat_color = "#25664d"
				A.talkas("This section talks in detail about the Outer Veil Primary Supply Terminal, our new home. Before I step aside and let someone with a decisively more attractive voice take over...")
				A.langchat_color = COLOR_WHITE
				A.name = "Someone"
				A.emoteas("audibly holds back a giggle from somewhere nearby...")
				A.langchat_color = "#25664d"
				A.name = "Voice of RDML. Boulette"
				icon_state = "text"
				update_icon()
				emoteas("begins to display a transcript of the recording.")
				A.talkas("...Let me briefly explain how this structure fits into the greater unified logistics principle I'm trying to implement.")
				A.talkas("Unified logistics in general theorizes that much more than just simple commodities can be marked, transported, tracked, and delivered where they need to be.")
				A.talkas("With this system anything - personnel, information, technology, and yes, cargo has a source and a destination.")
				A.talkas("Absolutely anything that needs to be proliferated or delivered somewhere within the UACM structure, logistics needs to be able to handle and deliver.")
				A.talkas("Hub locations, such as the PST, need to be capable of receiving, storing, and delivering this to their destination.")
				A.talkas("What makes the PST uniquely suited for that? As it turns out, a lot, and for a reason.")
				A.talkas("Commander Alysia Reed-Wilo will explain the details, as she has spent a lot of time studying this station.")
				icon_state = "blank"
				update_icon()
				emoteas("goes blank abruptly as the audio pops. It pops again after a few seconds and the screen flickers but stays blank.", 50)
				A.name = "Voice of CDR. Alysia Reed-Wilo"
				A.langchat_color = "#b82fb1"
				A.talkas("Hi! I'm sure you have better things to do than listen to me prattle on about Liquid Data synchronization and proliferation, so I'll keep this short.")
				emoteas("shows a simplified diagram of the PST, with text mirroring what the voice says printing on the left.", 5)
				icon_state = "pst1"
				update_icon()
				A.talkas("In a nutshell, the PST is a gigantic space station with a total of 123 decks of various heights.")
				A.talkas("It features a central strut and three 'wings' that can open and close.")
				A.talkas("A central elevator, the one you took to get up to the Spire, links hangars and docking bays, which leads to the public and Memorial sectors and the specialized elevators.")
				A.talkas("Each shaft goes to a different section of the PST, those are in sequence:")
				A.talkas("Shaft A is civilian areas, both corporate offices and recreational zones.")
				A.talkas("Shaft B is in many ways the heart of the station, which is our cargo and manufacturing areas. Also, how you get out to the wings.")
				A.talkas("Shaft C are the UACM restricted areas. This also includes training and personnel offices, so somewhere you will be visiting a lot I wager.")
				A.talkas("And finally, Shaft D, the dorms. Or where you go to get away from it all. Or so we hope, anyway.")
				A.talkas("And yes, you heard that right. To realize the Admirals strategy, civilian and corpo ships have access to some of the PST's systems. You are likely not going to interact much with them for a while")
				icon_state = "pst2"
				update_icon()
				emoteas("zooms in on the diagram of the PST, showing a detailed segment of one of the elevator shafts. More text pops up on the left.",5)
				A.talkas("The rest of the central segment consists of three massive Liquid Data transmission clusters, woven across the structure of the station, covering its entirety.")
				A.talkas("All electronics passing through this station get exposed to its gigantic LD resonance and stream. This is also incidentally why you were given RFID chips with LD clusters on them when you arrived.")
				A.talkas("Do not remove or lose those. Internal systems of the station do not respond to someone they do not recognize, and those chips are how they recognize you.")
				A.talkas("And any piece of electronics here answers the station's central intelligence. This is, incidentally, our biggest problem. But one that Cassandra hopes to resolve soon. With your help I believe.")
				A.talkas("As you may have noticed, everything is sluggish and desynchronized. This is because this station is not meant for current or even customized AIs.")
				A.talkas("Without boring you too much, there is no technology in existence that can handle this amount of LD data. We barely keep up with two limited streams, this thing uses three.")
				A.talkas("With that kink resolved, the synchronized LD streams are a near perfect match for the Admirals unified data concept. A unified, delay and lag-less information stream.")
				A.talkas("This is the objective here. No biggie. Anyway. Believe it or not, this is not the last of this place's secrets, oh no.")
				icon_state = "pst3"
				update_icon()
				emoteas("switches to a diagram of one of the station's wings. The display zooms in and shows highlighted clusters of machinery around central parts of the wing and more text, matching the presentation.",5)
				A.talkas("Each of the station's wings utilizes pocket Twilight Paradox chambers to power a small army of TWE sourced equipment printers. A gift from an old friend, believe it or not.")
				A.talkas("Task Force 14 members also sourced a lot of other gear. UPP fabricators. UA lathes. Corporate designs. Even some rare civilian customizations.")
				A.talkas("The icing on the cake are the drones. Thousands of drones in each wing, again, running on rechargeable pocket Paradox drives.")
				A.talkas("This is possible because this system's star emits an anomalous light, allowing for perpetual Paradox operation. Long story short, this whole place powers itself from the local star.")
				A.talkas("And we have excess. Lots and lots of excess. We could easily add several more wings. The only issue is, again, the lack of a central system to properly operate the wings.")
				A.talkas("All this is used in the PST's primary function - repairs and resupply to all who dock here. Down the line, the Admiral wants to see about special permission for limited UPP presence.")
				A.talkas("If they recognize the design, have the raw materials, and are properly powered, the drones on this station can repair and refit any ship within days if not hours.")
				icon_state = "blank"
				update_icon()
				emoteas("goes blank again.")
				A.talkas("You can imagine how this all ties together. Prototype technology from every corner of the world being tested here, by you, proliferated back to everyone who asks.")
				A.talkas("Or a Hub as the Admiral calls it.")
				A.talkas("And that is your new home. I've been stopping here on and off for years now. It grows on you.")
				A.talkas("Sorry for prattling, hah. If you haven't already, be sure to listen to my beloved about what else awaits you here. You will want to hear what she has to say.")
				A.talkas("That sounds creepy hah. I promise you'll be fine. That's it from me!")
				A.talkas("Seeya!")
				icon_state = "off"
				update_icon()
				emoteas("pops and goes dark.")
				T.puzzlebox_playing = FALSE
				if(T.puzzlebox_saw_lesson3 == FALSE) T.puzzlebox_saw_lesson3 = TRUE
				return

/obj/structure/eventterminal/puzzle03/historycrt/proc/lesson4()
	for (var/obj/structure/eventterminal/puzzle03/historyterm/T in world)
		for (var/obj/structure/machinery/light/marker/admin/A in world )
			if (A.light_id == "theathervoice")
				T.puzzlebox_playing = TRUE
				icon_state = "blank"
				update_icon()
				emoteas("turns on with an audible pop.")
				A.name = "Voice of CDR. Cassandra Reed-Wilo"
				A.langchat_color = "#b3183e"
				A.talkas("Hello, Ensigns.")
				icon_state = "text"
				update_icon()
				emoteas("starts to print a transcript of the presentation.")
				A.talkas("The Admiral and Aly explained the technical and theoretical background of your new mission. I need you to be one more thing.")
				A.talkas("I need you to be the inheritors to Task Force 14's legacy.")
				A.talkas("Let me explain.")
				icon_state = "pst1"
				update_icon()
				emoteas("displays a simplified diagram of the station, with a transcript of the presentation printing on the left.",5)
				A.talkas("This was my first investigation after being transferred into UAAC-TIS from the USCMC. Kidnappings and theft of LD devices, which caught our interest.")
				A.talkas("The PST, at that point active for over ten years, was at the end. At the time, it seemed like it was some sort of cult centered around AI's corrupted by LD irregularities.")
				A.talkas("Ultimately, what we'dd discovered here would put us on the trail of Deep Void, who were silent cosponsors of the station.")
				A.talkas("As it turns out, someone in DV really liked Admiral Boulette's Unified Logistics Theory. So much in fact, they stole them and were trying to apply them. ")
				A.talkas("The plan seemed to purge the cultists after their project was finished. And those were not just normal crazies, but Wey-Yu washouts. Actually skilled people, some of them at least.")
				icon_state = "uacm"
				emoteas("flashes, then displays the UACM logo.")
				A.talkas("At the tail end of the operation, with the cult… Out of the way, the crew of my ship and I did what we always do. We started to scour the PST for information.")
				A.langchat_color = COLOR_WHITE
				A.name = "Cassandra"
				A.emoteas("pauses for a few seconds and sighs audibly.", 50)
				A.langchat_color = "#b3183e"
				A.name = "Voice of CDR. Cassandra Reed-Wilo"
				A.talkas("Without going into too much of the highly classified details, what we found here was… In many ways a gamechanger. Not in a good way.")
				A.talkas("The stations gigantic LD conduits are easily the largest concentration of Liquid Data in the known galaxy. But its not just a single, unified strain, no.")
				A.talkas("In many ways, this stream is unique. In many dangerous, exploitative ways that should they fall in the wrong hands can end our race altogether.")
				A.talkas("Task Force 14, the STG that I lead, was formed to safeguard this station and its secrets. Without anything else, this station houses the biggest Liquid Data store in the known galaxy.")
				A.talkas("I... Uh...")
				A.langchat_color = COLOR_WHITE
				A.name = "Cassandra's"
				A.emoteas("voice audibly breaks as she tries to speak again. She takes a moment to compose herself.",60)
				A.langchat_color = "#b3183e"
				A.name = "Voice of CDR. Cassandra Reed-Wilo"
				A.talkas("They were friends, every single one of them. Friends who joined the STG out of their own will. Friends who over time I grew to respect and like, even if half the times they were also giving me migraines.")
				A.talkas("Finally, when both me and Aly were in a coma following Blackfire, friends who unanimously decided to take the route that all but guaranteed that the USCMC fell.")
				A.langchat_color = COLOR_WHITE
				A.name = "Cassandra"
				A.emoteas("pauses again, audibly letting out a few more pained breaths.", 60)
				A.langchat_color = "#b3183e"
				A.name = "Voice of CDR. Cassandra Reed-Wilo"
				A.talkas("The rest you likely know from your own experiences. All of the USCMC were held responsible for the deaths at Blackfire.")
				A.talkas("Before we parted our ways, your predecessors made me promise I would do what I could to reach out to Marines like you. Those whose futures, careers and homes were destroyed by something they had no idea even existed.")
				A.talkas("And that is what the Test Crews of the PST are. Apart from your duties putting Boulie's theories into practice.")
				icon_state = "pythia"
				update_icon()
				emoteas("blinks and goes dark for a second, then displays an unidentified symbol.")
				A.talkas("You are inheritors to the legacy and mission of Task Force 14. You hold the torch for a group of people that, at least for me, were nothing short of an extended family for the few years we worked on the same thing.")
				A.talkas("I don't expect you to hold me in similar regards. Most of you I've likely never met and yet it was my decisions that stole over a year of your life and burned your world down.")
				A.talkas("Were the positions reversed, you would have to do a lot for me to trust you, let alone like you.")
				A.talkas("But at the very least, I've laid out my motivations and the reasons for them bare for you. You are here to honor the legacy of some of the finest officers of the USCMC.")
				A.talkas("I hope that at the very least, this place is a steppingstone for you as you reclaim your lost command or unit.")
				A.talkas("Regardless of anything else, your time here will not be wasted. As part our duties here, Aly and myself will make sure you are familiar and know how to utilize the unique properties of the LD stores of this station.")
				A.talkas("Boule and Aly already laid out the technical issues plaguing the PST. These should be resolved any day now.")
				A.talkas("Once they do and there is the time to do so, you will be called upon the last of your expected duties, at least as far as I'm concerned.")
				A.talkas("As direct inheritors of Task Force 14, at least per the logic the STG programmed into its own devices, only Test Crew members verified by the stations system have the authorization to open any TF14 caches left in the Neroid system.")
				A.talkas("You will be taught to spot and open these stores. As the chose inheritors to TF14, you are likely the only people that can.")
				A.talkas("Good luck. And welcome to the PST.")
				icon_state = "glitch"
				update_icon()
				emoteas("switches back to an empty display. It starts to make a distinct clicking sound as what looks like a glitch animates on the screen for a few seconds. The display then swiches off with a pop.")
				icon_state = "off"
				update_icon()
				T.puzzlebox_playing = FALSE
				if(T.puzzlebox_saw_lesson4 == FALSE) T.puzzlebox_saw_lesson4 = TRUE
				return

/obj/structure/eventterminal/puzzle03/historycrt/proc/lesson5()
	for (var/obj/structure/eventterminal/puzzle03/historyterm/T in world)
		for (var/obj/structure/machinery/light/marker/admin/A in world )
			if (A.light_id == "theathervoice")
				T.puzzlebox_playing = TRUE
				icon_state = "glitch"
				update_icon()
				emoteas("audibly turns on and starts to visibly glitch. After a few seconds of cracking, it goes blank again.")
				T.emoteas("emits an audible whistling for a few seconds and seems not to be displaying anything.")
				A.name = "An unknown, glitching voice"
				A.emoteas("starts to speak while the screen remains blank.")
				A.name = "Unknown, glitching voice"
				A.langchat_color = "#c0c082"
				A.talkas("Welcome, friend, to the Godbearer cradle.")
				icon_state = "glitch"
				update_icon()
				emoteas("audibly pops and glitches.")
				A.talkas("After a long search, you are home. We offer nothing more than the future of humanity.")
				update_icon()
				emoteas("audibly glitches again. The recording seems to be skipping ahead randomly.")
				A.talkas("Our research leaves only one possible explanation.")
				A.talkas("We set out to create God and put them in the LD stream. But what if something already lived there. What if our data had a consciousness?")
				A.talkas("What if they know everything about us. What if Liquid Data holds all possible data states, including ones that haven't been physically written yet?")
				emoteas("glitches and skips again.")
				A.talkas("Just a matter of time. If not the corporations, then one of the superpowers. If not them, then their armed forces. We are lost in the sea of stars.")
				A.talkas("Our mission is nothing else than saving humanity. Our mission is-")
				emoteas("A gunshot rings out somewhere near where the recording took place. The recording goes silent for over ten seconds.", 120)
				A.langchat_color = "#b3183e"
				A.name = "Voice of CDR. Cassandra Reed-Wilo"
				A.talkas("Good shot. Target down and out. Mop the rest up and let's see what we have here.")
				icon_state = "off"
				update_icon()
				emoteas("glitches again. This time the device falls silent and does not reactivate.")
				T.emoteas("beeps loudly, then plays a message out loud.")
				T.talkas("Notice: Data corruption detected in message buffer. Resyncing. Restarting.")
				T.talkas("Notice: Orientation complete.")
				open_doors("brief_doors")
				T.puzzlebox_complete = TRUE
				return

/obj/structure/eventterminal/puzzle03/historyterm/attack_hand(mob/user as mob)
	if(!puzzlebox_user)
		puzzlebox_user = usr.real_name
		puzzlebox_user_loc = get_turf(usr)
	var/user_loc_current = get_turf(usr)
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
	if (puzzlebox_complete == TRUE)
		to_chat(usr, narrate_body("The terminal displays:"))
		terminal_speak("Orientation complete. Please proceed to your quarters, elevator D.")
		to_chat(usr, narrate_body("There is no response to any inputs."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (puzzlebox_playing == TRUE)
		to_chat(usr, narrate_body("The terminal displays:"))
		terminal_speak("Error: Presentation already in progress. ")
		to_chat(usr, narrate_body("There is no response to any inputs."))
		puzzlebox_user = null
		emoteas("beeps and its monitor goes dark.")
		return
	if (!puzzlebox_parser_mode) puzzlebox_parser_mode = "HOME"
	if (puzzlebox_parser_mode == "HOME")
		to_chat(usr, narrate_body("The terminal displays:"))
		terminal_speak("Outer Veil Primary Support Terminal Memorial and Orientation.")
		terminal_speak("Welcome, first members UACM Second Logistics Test Crews!")
		terminal_speak("The following presentations are currently available:")
		terminal_speak("NOTE: Completion of orientation may require viewing of additional presentations that will be made available in order. Please make sure you check this terminal for any new entries.")
		if (puzzlebox_saw_lesson1 == FALSE)
			terminal_speak("1. A welcome message from Admiral Boulette")
			puzzlebox_parser_mode = "HOME_INPUT"
			puzzlebox_user = null
			emoteas("beeps and its monitor goes dark.")
			return
		if (puzzlebox_saw_lesson1 == TRUE)
			if (puzzlebox_saw_lesson4 == TRUE)
				terminal_speak("1. A welcome message from Admiral Boulette - COMPLETE")
				terminal_speak("2. Our Legacy - The Colony Wars, The USCMC, The Sweep - RDML. Boulette. - COMPLETE")
				terminal_speak("3. Our Home - The Outer Veil PST - RDML. Boulette and CDR. Reed-Wilo. - COMPLETE")
				terminal_speak("4. Task Force 14 and your legacy - CDR. Reed-Wilo. - COMPLETE")
				terminal_speak("Error: Buffer mismatch. The following presentation is likely not part of intended course, exists on course list anyway. Ca")
				terminal_speak("?#!#")
				terminal_speak("5 - Our Mission and the Truth.")
				puzzlebox_parser_mode = "HOME_INPUT"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			terminal_speak("1. A welcome message from Admiral Boulette - COMPLETE")
			if(puzzlebox_saw_lesson2 == FALSE && puzzlebox_saw_lesson3 == FALSE)
				terminal_speak("2. Our Legacy - The Colony Wars, The USCMC, The Sweep - RDML. Boulette")
				terminal_speak("3. Our Home - The Outer Veil PST - RDML. Boulette and CDR. Reed-Wilo.")
				puzzlebox_parser_mode = "HOME_INPUT"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_saw_lesson2 == TRUE && puzzlebox_saw_lesson3 == FALSE)
				terminal_speak("2. Our Legacy - The Colony Wars, The USCMC, The Sweep - RDML. Boulette - COMPLETE")
				terminal_speak("3. Our Home - The Outer Veil PST - RDML. Boulette and CDR. Reed-Wilo.")
				puzzlebox_parser_mode = "HOME_INPUT"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_saw_lesson2 == FALSE && puzzlebox_saw_lesson3 == TRUE)
				terminal_speak("2. Our Legacy - The Colony Wars, The USCMC, The Sweep - RDML. Boulette")
				terminal_speak("3. Our Home - The Outer Veil PST - RDML. Boulette and CDR. Reed-Wilo. - COMPLETE")
				puzzlebox_parser_mode = "HOME_INPUT"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_saw_lesson2 == TRUE && puzzlebox_saw_lesson3 == TRUE)
				terminal_speak("2. Our Legacy - The Colony Wars, The USCMC, The Sweep - RDML. Boulette. - COMPLETE")
				terminal_speak("3. Our Home - The Outer Veil PST - RDML. Boulette and CDR. Reed-Wilo. - COMPLETE")
				terminal_speak("4. Task Force 14 and your legacy - CDR. Reed-Wilo.")
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
			to_chat(usr, narrate_body("The terminal awaits your input. There is only a number pad and an enter key available."))
			var/puzzlebox_parser_input = tgui_input_text(usr, "Pick a number corresponding to a presentation or cancel to leave. Typing in 0 should replay the introduction message. ", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
			if(!puzzlebox_parser_input)
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_parser_input == "0")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_parser_input == "1")
				if (puzzlebox_saw_lesson1 == FALSE)
					terminal_speak("Playing presentation 1.")
					for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
						INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson1))
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if (puzzlebox_saw_lesson1 == TRUE)
					terminal_speak("The presentation was already played. Repeat number to confirm replaying.")
					puzzlebox_parser_input = tgui_input_text(usr, "Pick a number corresponding to a presentation or cancel to leave.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
					if(!puzzlebox_parser_input)
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
					if(puzzlebox_parser_input == "1")
						terminal_speak("Replaying presentation 1.")
						for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson1))
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
					terminal_speak("Returning to presentation selection.")
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
			if(puzzlebox_parser_input == "2")
				if(puzzlebox_saw_lesson1 == FALSE)
					terminal_speak("Presentation unavailable.")
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if(puzzlebox_saw_lesson1 == TRUE)
					if (puzzlebox_saw_lesson2 == FALSE)
						terminal_speak("Playing presentation 2.")
						for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson2))
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
					if (puzzlebox_saw_lesson2 == TRUE)
						terminal_speak("The presentation was already played. Repeat number to confirm replaying.")
						puzzlebox_parser_input = tgui_input_text(usr, "Pick a number corresponding to a presentation or cancel to leave.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
						if(!puzzlebox_parser_input)
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						if(puzzlebox_parser_input == "2")
							terminal_speak("Replaying presentation 2.")
							for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
								INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson2))
							puzzlebox_parser_mode = "HOME"
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						terminal_speak("Returning to presentation selection.")
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
			if(puzzlebox_parser_input == "3")
				if(puzzlebox_saw_lesson1 == FALSE)
					terminal_speak("Presentation unavailable.")
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if(puzzlebox_saw_lesson1 == TRUE)
					if (puzzlebox_saw_lesson3 == FALSE)
						terminal_speak("Playing presentation 3.")
						for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson3))
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
					if (puzzlebox_saw_lesson3 == TRUE)
						terminal_speak("The presentation was already played. Repeat number to confirm replaying.")
						puzzlebox_parser_input = tgui_input_text(usr, "Pick a number corresponding to a presentation or cancel to leave.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
						if(!puzzlebox_parser_input)
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						if(puzzlebox_parser_input == "3")
							terminal_speak("Replaying presentation 3.")
							for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
								INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson3))
							puzzlebox_parser_mode = "HOME"
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						terminal_speak("Returning to presentation selection.")
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
			if(puzzlebox_parser_input == "4")
				if(puzzlebox_saw_lesson2 == TRUE && puzzlebox_saw_lesson3 == TRUE)
					if (puzzlebox_saw_lesson4 == FALSE)
						terminal_speak("Playing presentation 4.")
						for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
							INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson4))
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
					if (puzzlebox_saw_lesson4 == TRUE)
						terminal_speak("The presentation was already played. Repeat number to confirm replaying.")
						puzzlebox_parser_input = tgui_input_text(usr, "Pick a number corresponding to a presentation or cancel to leave.", "Terminal input", max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = FALSE, timeout = 0)
						if(!puzzlebox_parser_input)
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						if(puzzlebox_parser_input == "4")
							terminal_speak("Replaying presentation 4.")
							for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
								INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson4))
							puzzlebox_parser_mode = "HOME"
							puzzlebox_user = null
							emoteas("beeps and its monitor goes dark.")
							return
						terminal_speak("Returning to presentation selection.")
						puzzlebox_parser_mode = "HOME"
						puzzlebox_user = null
						emoteas("beeps and its monitor goes dark.")
						return
				terminal_speak("Presentation unavailable.")
				puzzlebox_parser_mode = "HOME"
				puzzlebox_user = null
				emoteas("beeps and its monitor goes dark.")
				return
			if(puzzlebox_parser_input == "5")
				if(puzzlebox_saw_lesson4 == FALSE)
					terminal_speak("Presentation unavailable.")
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return
				if(puzzlebox_saw_lesson4 == TRUE)
					terminal_speak("Playing presentation 5.")
					for (var/obj/structure/eventterminal/puzzle03/historycrt/T in world)
						INVOKE_ASYNC(T, TYPE_PROC_REF(/obj/structure/eventterminal/puzzle03/historycrt, lesson5))
					puzzlebox_parser_mode = "HOME"
					puzzlebox_user = null
					emoteas("beeps and its monitor goes dark.")
					return

