//OV-PST Airlocks
/obj/structure/machinery/door/airlock/multi_tile/uacm/general
	name = "standard airlock"
	desc = "A standard airlock wihtout any specific color coding or anything else that would set it apart from the many others."
	desc_lore = "The so called 'general access' airlock is probably the most commonly used one in the galaxy, which is also why airlocks with this access level typically are the ones in their factory default colors, like this one."
	req_access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT)
	icon = 'icons/obj/structures/doors/2x1comdoor.dmi'
	no_panel = 1
	not_weldable = 1
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uacm/general/admin
	req_access = list(ACCESS_SP_ADMIN)

/obj/structure/machinery/door/airlock/multi_tile/uacm/general/admin/elevator_inner
	name = "elevator door"
	desc = "A heavy looking metal door."
	desc_lore = "Since time immemorial, people have taken great effort not to fall out of elevators in transit. These doors are one such method. Simple, yet effective. Spaceship freight elevators have not changed the game - people still hate falling down elevator shafts."
	req_access = list()
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 22
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uacm/general/admin/elevator_outer
	name = "elevator door"
	desc = "A heavy looking metal door with an equally heavy looking glass panel that lets you peek inside."
	desc_lore = "Since time immemorial, people have taken great effort not to fall out of elevators in transit. These doors are one such method. Simple, yet effective. Spaceship freight elevators have not changed the game - people still hate falling down elevator shafts."
	req_access = list(ACCESS_SP_ADMIN)
	icon = 'icons/obj/structures/doors/4x1_elevator_access.dmi'
	icon_state = "door_locked"
	locked = TRUE
	width = 4
	openspeed = 22
	opacity = FALSE
	glass = TRUE
