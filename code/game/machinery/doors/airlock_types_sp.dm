//OV-PST
//GENERICS
/obj/structure/machinery/door/airlock/almayer/uacm

	name = "generic UACM door"
	desc = "This is a placeholder. It should not be here."
	desc_lore = "This exists as a generic item to orient others in the code."
	opacity = TRUE
	no_panel = 1
	not_weldable = 1

/obj/structure/machinery/door/airlock/almayer/uacm/ovpst/general //Basic Ensign Access. For "standard" doors.
	name = "standard airlock"
	desc = "A standard airlock wihtout any specific color coding or anything else that would set it apart from the many others."
	desc_lore = "The so called 'general access' airlock is probably the most commonly used one in the galaxy, which is also why airlocks with this access level typically are the ones in their factory default colors, like this one."
	req_access = list(ACCESS_SP_OVPST_GENERAL_DEFAULT)

/obj/structure/machinery/door/airlock/almayer/uacm/ovpst/general/admin //No access to anyone but admin-privelaged characters. The DM fun zones.
	req_access = list(ACCESS_SP_ADMIN)

//OV-PST
//Security

/obj/structure/machinery/door/airlock/almayer/uacm/ovpst/security_generic
	name = "red airlock"
	desc = "A standard airlock, painted red."
	desc_lore = "Traditionally, red coloring indicates areas related to law enforcement or area security."
	icon = 'icons/obj/structures/doors/secdoor.dmi'
	req_access = list(ACCESS_SP_OVPST_SECURITY_DEFAULT)
