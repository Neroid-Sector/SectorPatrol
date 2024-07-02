/obj/docking_port/stationary/emergency_response/pst_start
	name = "Deep Space, Outer Veil PST approach."
	dir = NORTH
	id = "ovpst_starter"
	roundstart_template = /datum/map_template/shuttle/uacm_ovpst_salvage_tug
	width = 30
	height = 30

/obj/docking_port/stationary/emergency_response/external/pst_dock31
	name = "Outer Veil PST, Dock 31"
	dir = NORTH
	id = "ovpst_d31"
	width = 27
	height = 9
	airlock_id = "d31-entrance"
	airlock_area = /area/ovpst/airlock/d31

/obj/docking_port/mobile/emergency_response/l533
	name = "Shuttle L-533"
	id = "uacm_ovpst_transit_L-533"
	preferred_direction = EAST
	port_direction = EAST
	width = 27
	height = 9
	movement_force = list("KNOCKDOWN" = 2, "THROW" = 0)
	callTime = 10
	ignitionTime = 55
	rechargeTime = 0
	prearrivalTime = 0
	var/starboard_door
	var/port_door

/obj/docking_port/mobile/emergency_response/l533/Initialize(mapload)
	. = ..()
	external_doors = list()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			if(air.id == "starboard_door")
				starboard_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
			else if(air.id == "port_door")
				port_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
	if(!port_door)
		WARNING("No port door found for [src]")
	if(!starboard_door)
		WARNING("No starboard door found for [src]")

/datum/map_template/shuttle/l533
	name = "Shuttle L-533"
	shuttle_id = "uacm_ovpst_transit_L-533"

/area/shuttle/l533
	name = "Shuttle L-533"

//Elevator placeholders

/obj/docking_port/stationary/emergency_response/external/pst_elevator_e_d31
	name = "Outer Veil PST Elevator Shaft E, Dock 31"
	dir = NORTH
	id = "ovpst_el-e_d31"
	width = 11
	height = 11
	airlock_id = "e-d31"
	airlock_area = /area/ovpst/airlock/ele_e_d31

/obj/docking_port/stationary/emergency_response/external/pst_elevator_e_pinnacle
	name = "Outer Veil PST Elevator Shaft E, Pinnacle"
	dir = NORTH
	id = "ovpst_el-e_pin"
	width = 11
	height = 11
	airlock_id = "e-pin"
	airlock_area = /area/ovpst/airlock/ele_e_pin

/obj/docking_port/mobile/emergency_response/pst_elevator_e
	name = "Outer Veil PST Elevator E"
	id = "uacm_ovpst_ele-e"
	preferred_direction = EAST
	port_direction = EAST
	width = 11
	height = 11
	movement_force = list("KNOCKDOWN" = 1, "THROW" = 0)
	callTime = 10
	ignitionTime = 55
	rechargeTime = 0
	prearrivalTime = 0
	var/starboard_door
	var/port_door

/obj/docking_port/mobile/emergency_response/pst_elevator_e/Initialize(mapload)
	. = ..()
	external_doors = list()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			if(air.id == "starboard_door")
				starboard_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
			else if(air.id == "port_door")
				port_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
	if(!port_door)
		WARNING("No port door found for [src]")
	if(!starboard_door)
		WARNING("No starboard door found for [src]")

/datum/map_template/shuttle/pst_elevator_e
	name = "Outer Veil PST Elevator E"
	shuttle_id = "uacm_ovpst_ele-e"

/area/shuttle/pst_elevator_e
	name = "Outer Veil PST Elevator E"

/obj/docking_port/stationary/emergency_response/external/pst_elevator_d_drm
	name = "Outer Veil PST Elevator Shaft D, Dormitories level 37"
	dir = NORTH
	id = "ovpst_el-d_drm"
	width = 11
	height = 11
	airlock_id = "d-drm"
	airlock_area = /area/ovpst/airlock/ele_d_drm

/obj/docking_port/stationary/emergency_response/external/pst_elevator_d_pin
	name = "Outer Veil PST Elevator Shaft D, Pinnacle"
	dir = NORTH
	id = "ovpst_el-d_pin"
	width = 11
	height = 11
	airlock_id = "d-pin"
	airlock_area = /area/ovpst/airlock/ele_d_pin


/obj/docking_port/mobile/emergency_response/pst_elevator_d
	name = "Outer Veil PST Elevator D"
	id = "uacm_ovpst_ele-d"
	preferred_direction = EAST
	port_direction = EAST
	width = 11
	height = 11
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	callTime = 10
	ignitionTime = 55
	rechargeTime = 0
	prearrivalTime = 0
	var/starboard_door
	var/port_door

/obj/docking_port/mobile/emergency_response/pst_elevator_d/Initialize(mapload)
	. = ..()
	external_doors = list()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			if(air.id == "starboard_door")
				starboard_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
			else if(air.id == "port_door")
				port_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
	if(!port_door)
		WARNING("No port door found for [src]")
	if(!starboard_door)
		WARNING("No starboard door found for [src]")

/datum/map_template/shuttle/pst_elevator_d
	name = "Outer Veil PST Elevator d"
	shuttle_id = "uacm_ovpst_ele-d"

/area/shuttle/pst_elevator_d
	name = "Outer Veil PST Elevator D"

/obj/docking_port/stationary/emergency_response/pst_shaft_e
	name = "OV-PST, Elevator Shaft E"
	dir = NORTH
	id = "pst_shaft_e"
	roundstart_template = /datum/map_template/shuttle/pst_elevator_e
	width = 11
	height = 11

/obj/docking_port/stationary/emergency_response/pst_shaft_d
	name = "OV-PST, Elevator Shaft D"
	dir = NORTH
	id = "pst_shaft_d"
	roundstart_template = /datum/map_template/shuttle/pst_elevator_d
	width = 11
	height = 11

//Salvage Tug

/obj/docking_port/mobile/emergency_response/uacm_ovpst_salvage_tug
	name = "Shuttle L-533"
	id = "uacm_ovpst_salvage_tug"
	preferred_direction = EAST
	port_direction = EAST
	width = 10
	height = 14
	movement_force = list("KNOCKDOWN" = 2, "THROW" = 0)
	callTime = 10
	ignitionTime = 55
	rechargeTime = 0
	prearrivalTime = 0
	var/starboard_door
	var/port_door

/obj/docking_port/mobile/emergency_response/uacm_ovpst_salvage_tug/Initialize(mapload)
	. = ..()
	external_doors = list()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			if(air.id == "starboard_door")
				starboard_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
			else if(air.id == "port_door")
				port_door = air
				external_doors += list(air)
				air.breakable = FALSE
				air.indestructible = TRUE
				air.unacidable = TRUE
	if(!port_door)
		WARNING("No port door found for [src]")
	if(!starboard_door)
		WARNING("No starboard door found for [src]")

/datum/map_template/shuttle/uacm_ovpst_salvage_tug
	name = "OV-PST Test Crew Salvage Tug"
	shuttle_id = "uacm_ovpst_salvage_tug"

/area/shuttle/uacm_ovpst_salvage_tug
	name = "OV-PST Test Crew Salvage Tug"
