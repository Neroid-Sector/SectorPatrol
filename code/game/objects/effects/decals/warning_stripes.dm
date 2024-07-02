/obj/effect/decal/warning_stripes
	name = "warning stripes"
	gender = PLURAL
	icon = 'icons/effects/warning_stripes.dmi'
	layer = WEED_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/initial_icon_state

/obj/effect/decal/warning_stripes/Initialize(mapload, ...)
	. = ..()
	initial_icon_state = icon_state

/obj/effect/decal/warning_stripes/setDir(newdir)
	. = ..()
	switch(newdir)
		if(NORTH)
			icon_state = initial_icon_state
		if(SOUTH)
			switch(initial_icon_state)
				if("W")
					icon_state = "E"
				if("N")
					icon_state = "S"
				if("E")
					icon_state = "W"
				if("S")
					icon_state = "N"
				if("SE-out")
					icon_state = "NW-out"
				if("SW-out")
					icon_state = "NE-out"
				if("NW-out")
					icon_state = "SE-out"
				if("NE-out")
					icon_state = "SW-out"

		if(EAST)
			switch(initial_icon_state)
				if("W")
					icon_state = "N"
				if("N")
					icon_state = "E"
				if("E")
					icon_state = "S"
				if("S")
					icon_state = "W"
				if("SE-out")
					icon_state = "SW-out"
				if("SW-out")
					icon_state = "NW-out"
				if("NW-out")
					icon_state = "NE-out"
				if("NE-out")
					icon_state = "SE-out"
		if(WEST)
			switch(initial_icon_state)
				if("W")
					icon_state = "S"
				if("N")
					icon_state = "W"
				if("E")
					icon_state = "N"
				if("S")
					icon_state = "E"
				if("SE-out")
					icon_state = "NE-out"
				if("SW-out")
					icon_state = "SE-out"
				if("NW-out")
					icon_state = "SW-out"
				if("NE-out")
					icon_state = "NW-out"

/obj/effect/decal/warning_stripes/asteroid
	icon_state = "warning"


/obj/effect/decal/sand_overlay
	name = "sandy edge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE
	icon = 'icons/turf/overlays.dmi'
	layer = TURF_LAYER

/obj/effect/decal/sand_overlay/sand1
	icon_state = "sand1_s"
/obj/effect/decal/sand_overlay/sand1/corner1
	icon_state = "sand1_c"
/obj/effect/decal/sand_overlay/sand2
	icon_state = "sand2_s"
/obj/effect/decal/sand_overlay/sand2/corner2
	icon_state = "sand2_c"

/obj/effect/decal/grass_overlay
	name = "grass edge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE
	icon = 'icons/turf/floors/auto_strata_grass.dmi'
	layer = TURF_LAYER

/obj/effect/decal/grass_overlay/grass1
	icon_state = "grass_outercorner"

/obj/effect/decal/grass_overlay/grass1/inner
	name = "grass edge"
	icon_state = "grass_innercorner"

/obj/effect/decal/siding
	name = "siding"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "siding1"

/obj/effect/decal/siding/wood_siding
	name = "wood siding"
	icon_state = "wood_siding1"

//Sector Patrol

/obj/effect/decal/cargo_stripes
	name = "cargo zone markers"
	gender = PLURAL
	icon = 'icons/effects/cargo_stripes.dmi'
	icon_state = "center"
	layer = WEED_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

//Label base decal
/obj/effect/decal/info_tag
	name = "orientation label"
	desc = "Serial number and undewriting description should go here."
	desc_lore = "Extra info about what lies at either end goes here"
	gender = NEUTER
	layer = TURF_LAYER
	icon = 'icons/effects/stripe_label.dmi'
	icon_state = "default"

/obj/effect/decal/info_tag/examine(mob/user)
	var/info_taghtml = {"<!DOCTYPE html>
		<html>
		<head>
		<style>
		body {
		background-color:black;
		color:#ddd;
		}
		#narrate_serial {
		font-family: 'Lucida Grande', monospace;
		color: #d4d6d6;
		text-align: center;
		padding: 0em 1em;
		}
		#narrate_serial_block {
		background: #1b1c1e;
		border: 1px solid #a4bad6;
		margin: 0.5em 15%;
		padding: 0.5em 0.75em;
		}
		#desc {
		width:90%;
		padding:5%;
		text-align:justify;
		font-size:120%;
		font-family:Tahoma, sans-serif;
		}
		</style>
		</head>
		<body>
		<div id="narrate_serial_block">
		<div id="narrate_serial">
		<p>
		[desc]
		</p>
		</div>
		</div>
		<hr>
		<div id="desc">
		<p>
		[desc_lore]
		</p>
		</div>
		</body>
		"}
	usr << browse(info_taghtml,"window=[name];display=1;size=500x600;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "[name]")

/obj/effect/decal/info_tag/Topic(href, list/href_list)
	. = ..()

/obj/effect/decal/info_tag/pst/d31
	name = "D-31 orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- D-31 -</big><br>Dock 31 Main Airlock"
	desc_lore = "Main Airlocks are effectively entrances and exits from space stations and ships, used by smaller ships that latch onto the airlocks, typically using extending pathways called 'umbilicals'."
	icon_state = "pst_d-31"

/obj/effect/decal/info_tag/pst/sec
	name = "SEC orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- SEC -</big><br>"
	desc_lore = "The label SEC indicates doors and areas that require an elevated security clearance, typically restricted for MPs and CMISRS agents."
	icon_state = "pst_sec"

/obj/effect/decal/info_tag/pst/scn
	name = "SCN orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- SCN -</big><br>"
	desc_lore = "The label SCN indicates doors and areas where computer systems actively scan its inhabitants and contents. Areas like this need to be clearly marked due to privacy and personal data handling laws passed back in the UA in the aftermath of the Colony Wars."
	icon_state = "pst_scn"

/obj/effect/decal/info_tag/pst/int
	name = "-INT- orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- -INT- -</big><br>"
	desc_lore = "The label -INT- indicates intersections. Labels like this are typically placed on the 'primary' pathway but have information regarding all pathways at an intersection and list all pathways at an intersection starting from the left-handed turn (if one exists) and moving in a clockwise fashion until all turns are covered."
	icon_state = "pst_int"

/obj/effect/decal/info_tag/pst/eng
	name = "ENG orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- ENG -</big><br>"
	desc_lore = "The label ENG indicates doors and areas related to controlling and maintaining the mechanical and computer elements of a colony, ship or station. These areas typically require an elevated engineering clearance."
	icon_state = "pst_eng"

/obj/effect/decal/info_tag/pst/cpu
	name = "CPU orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- CPU -</big><br>"
	desc_lore = "The label CPU indicates doors and areas related to the operation of ship AIs, which typically are also directly tied to the ships Twilight FTL drives and Liquid Data FTL communication systems. These areas are typically sealed to all but the highest-ranking command personnel on board a ship or station but may be sometimes unlocked by the AIs themselves if maintenance is required."
	icon_state = "pst_cpu"
/obj/effect/decal/info_tag/pst/obs
	name = "OBS orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- OBS -</big><br>"
	desc_lore = "The label OBS typically indicates an observation area of some sort, used to look at regular operations of another area without disturbing the actual process within."
	icon_state = "pst_obs"

/obj/effect/decal/info_tag/pst/san
	name = "SAN orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- SAN -</big><br>"
	desc_lore = "The label SAN indicates areas related to sanitation like toilets and showers. These are very commonly general access areas for obvious reasons. Some extra cleaning equipment may also be stored in these areas should the area they are located in be prone to certain types of grime."
	icon_state = "pst_san"

/obj/effect/decal/info_tag/pst/ela
	name = "EL-A orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- EL-A -</big><br>"
	desc_lore = "The label EL-A indicates Elevator Shaft A which can be used to access the PST's civilian sectors, which include corporate facilities and dorms as well as office and recreational areas. Likely the best (and only) place to spend your money on the station."
	icon_state = "pst_el.a"

/obj/effect/decal/info_tag/pst/elb
	name = "EL-B orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- EL-B -</big><br>"
	desc_lore = "The label EL-B indicates Elevator Shaft B which can be used to access the PST's Cargo and Manufacturing sector. This sector is unique in the sense that it also allows direct access to all three of the stations opening wings to both service and install new equipment as needed. This is also where all the receiving, sorting, and sending out happens. Any cargo shipped from outside the Veil and headed towards a UACM asset is likely to make a stop in this section of the station."
	icon_state = "pst_el.b"

/obj/effect/decal/info_tag/pst/elc
	name = "EL-C orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- EL-C - </big><br>"
	desc_lore = "The label EL-C indicates Elevator Shaft C, which is used to access the UACM restricted part of the station. This sector houses the offices of the command staff and various divisions responsible for handling logistics in specific sectors of the Outer Veil, or dedicated to special operations around the area. This is also where UACM, UAAC and UA adjacent agencies like the UAAC-TIS and CMISRS have their formal offices. Lastly, this is also the wing where UACM personnel receive training, both theoretical and practical."
	icon_state = "pst_el.c"

/obj/effect/decal/info_tag/pst/eld
	name = "EL-D orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- EL-D -</big><br>"
	desc_lore = "The label EL-D indicates Elevator Shaft D, which can be used to reach the so called “dorms” section of the station, or as it is formally known, the Residential Sector. All personnel temporarily or permanently residing on the station are housed in a room on a level in this sector and in the case of an emergency alert, are expected to take shelter there. Room size varies by level though rumors say that there are more than just simple resting facilities housed somewhere in this sector, with the reasoning being that if this is considered the safest place for personnel, it would also be the safest place for much more in case of an incursion."
	icon_state = "pst_el.d"

/obj/effect/decal/info_tag/pst/ele
	name = "EL-E orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- EL-E -</big><br>"
	desc_lore = "The label EL-E indicates the Central Elevator shaft on board the PST, technically known as the 'Primary Access Elevator - E'. The central elevator can be used to move between the main entrance and pathway to other elevator shaft - the so-called pinnacle of the station - or the opposite direction - towards on of many docking bays or berthing stations."
	icon_state = "pst_el.e"

/obj/effect/decal/info_tag/pst/ofc
	name = "OFC orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- OFC -</big><br>"
	desc_lore = "The label OFC indicates office areas, which as the name suggests are typically areas with some specific, bureaucratic function assigned to them and can be anything from personal offices of high-ranking personnel to teaching rooms and spare, unused generic spaces. "
	icon_state = "pst_ofc"

/obj/effect/decal/info_tag/pst/mem
	name = "MEM orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- MEM -</big><br>"
	desc_lore = "The label MEM indicates the memorial, an area celebrating the memory of those fallen while on duty. The PST's memorial, following the wishes of one of the stations commanders, is also dedicated to all USCMC personnel that died in the aftermath of the Blackfire Incident."
	icon_state = "pst_mem"

/obj/effect/decal/info_tag/pst/lby
	name = "LBY orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- LBY -</big><br>"
	desc_lore = "The label LBY indicates a lobby, an area that is typically open to general access that serves both as an entryway and waiting room for whatever place it connects to. These areas typically have access to some sort of form of hydration and nutrition as well as rudimentary entertainment."
	icon_state = "pst_lby"

/obj/effect/decal/info_tag/pst/drm
	name = "DRM orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- DRM -</big><br>"
	desc_lore = "The label DRM indicates dorms, private quarters of personnel living on the PST, both someone passing through or a permanent assignment."
	icon_state = "pst_drm"

/obj/effect/decal/info_tag/pst/rec
	name = "REC orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- REC -</big><br>"
	desc_lore = "The label REC indicates recreational areas, which often include public CivNet access points but can essentially be any area dedicated to down time or recreation on the station, including cafeterias and kitchens."
	icon_state = "pst_rec"

/obj/effect/decal/info_tag/pst/t14
	name = "T-14 orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- T-14 -</big><br>"
	desc_lore = "The label T-14 does not exist in the UACM orientation symbol manual and seems to be specific to the PST. The number seems significant."
	icon_state = "pst_t14"

/obj/effect/decal/info_tag/pst/mup
	name = "MUP orientation label"
	desc = "UACM Outer Veil Primary Supply Terminal <br><big>- MUP -</big><br>"
	desc_lore = "The label MUP indicates the Main Upload Point of a space station or spaceship and is usually one of the most extremely guarded spots on these objects. With proper access credentials, an MUP can be used to tweak or directly override the AI governing the stations systems. Because such access is typically impossible to trace as malicious software destroys any systems and data that it touches, agents delivering malicious software through a MUP is a very infamous way of the three superpowers sabotaging each other's endeavors. "
	icon_state = "pst_mup"
