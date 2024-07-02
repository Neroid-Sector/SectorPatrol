/obj/item/effect/decon_shimmer
	name = "deconstruction effect"
	icon = 'icons/effects/salvage_decon.dmi'
	icon_state = "default"
	mouse_opacity = 0
	anchored = TRUE
	var/shimmer_type // used to reference which icon to use,see the dmi for acceptable names

/obj/item/effect/decon_shimmer/Initialize(mapload, ...)
	. = ..()
	var/new_icon_state = shimmer_type + "_decon_start"
	icon_state = new_icon_state
	update_icon()

/obj/item/effect/decon_shimmer/proc/delete_with_anim()
	var/new_icon_state = shimmer_type + "_decon_end"
	icon_state = new_icon_state
	update_icon()
	sleep(15)
	qdel(src)
	return

/obj/item/effect/decon_shimmer/decon_turf
	shimmer_type = "turf"

/obj/item/effect/decon_shimmer/decon_item
	shimmer_type = "item"

/obj/item/effect/decon_shimmer/decon_structure
	shimmer_type = "structure"

/obj/item/effect/decon_shimmer/decon_tile
	shimmer_type = "tiles"
