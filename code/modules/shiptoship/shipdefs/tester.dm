//Tester setup. Also a template for ship specific defs. To create new ships, create new file with these and sat the name to the same things, then stick them all on a map in sts ares that also have the ship name set. They should be able to sync, as long as an entity with the same name exists on the sector map.
//Mission Control
/obj/structure/shiptoship_master/ship_missioncontrol/tester
	sector_map_data = list(
	"name" = "UAS Tester",
	"id_tag" = "none,",
	"initialized" = 0,
	"x" = 0,
	"y" = 0,
	)

//SIGNALS

/obj/structure/terminal/signals_console/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/probe_launcher/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/tracker_launcher
	ship_name = "UAS Tester"

//WEAPONS

/obj/structure/terminal/weapons_console/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/primary_cannon/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/primer_lever/primary/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/secondary_cannon/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/primer_lever/secondary/tester
	ship_name = "UAS Tester"

//DAMAGE

/obj/structure/terminal/damage_console/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/damage_control_element/tester
	ship_name = "UAS Tester"

//CARGO, REMEMBER BAYS NEED ROUNDSTART CONTENTS IF NOT LOADED IN FROM SOMEWHERE POST LOAD

/obj/structure/terminal/cargo_console/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/cargo_bay/primary_munitions/tester
	ship_name = "UAS Tester"
	cargo_data = list(
		"missile_pst_homing" = 30,
		"missile_pst_dumbfire" = 30,
		"missile_pst_torpedo" = 30,
		"warhead_direct" = 30,
		"warhead_explosive" = 30,
		"warhead_mip" = 30,
		)

/obj/structure/ship_elements/cargo_bay/secondary_munitions
	ship_name = "UAS Tester"
	cargo_data = list(
		"secondary_direct" = 30,
		"secondary_flak" = 30,
		"secondary_broadside" = 30,
		"probe" = 30,
		"tracker" = 30,
		)

//COMMAND

/obj/structure/ship_elements/command_chair/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/command_monitor/top/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/command_monitor/front/tester
	ship_name = "UAS Tester"

/obj/structure/ship_elements/command_monitor/bottom/tester
	ship_name = "UAS Tester"

//AREAS

/area/sts_ship/tester/
	name = "UAS Tester"
	ship_name = "UAS Tester"
	area_id = "TST"

/area/sts_ship/tester/command
	name = "UAS Tester - Bridge"
	area_id = "TST"
	icon_state = "command"

/area/sts_ship/tester/weapons
	name = "UAS Tester - Weapons Bay"
	area_id = "TST"
	icon_state = "weapons"

/area/sts_ship/tester/cargo
	name = "UAS Tester - Cargo Bay"
	area_id = "TST"
	icon_state = "cargo"

/area/sts_ship/tester/engineering
	name = "UAS Tester - Engineering Bay"
	area_id = "TST"
	icon_state = "engie"
