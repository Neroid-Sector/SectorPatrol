/obj/structure/customizer
	name = "customizer master item"
	desc = "In my wisdon and 20/20 hindsight, I have created this, the master item for customizers. Woe be upon you if you put it into the actual game for some reason."
	desc_lore = "But seriously, if this item is visible for players, it shoudn't be. Contact staff please."
	icon = 'icons/obj/structures/machinery/customizer.dmi'
	icon_state = "customizer_idle"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	var/active = FALSE

/obj/structure/customizer/clothing

	name = "Liquid Data enabled textile printer"
	desc = "A sturdy looking device with several thick cables connected to it. You can see a beam emitter attached to a metal rail inside. You can also see several smaller tubes that seem to emit a gentle, light-blue glow. A slot that seems to serve as a scanner is visible in front and a small screen is visible to the side."
	desc_lore = "Devices like this, albeit without the heavy cabling and with distinctly smaller lasers are often used by colony craftspeople while finishing their creations to put on fine elements like makers marks and other customizations. This specific device abuses the excess power surges resulting from activity within the PSTs enormous Liquid Data store to take this process overboard, allowing not only for fine detailing, but almost complete transformations of garments produced in the stations physical manufactories."

/obj/structure/customizer/clothing/attackby(obj/item/W, mob/user)
	if(active == TRUE)
		to_chat(usr, SPAN_NOTICE("This device is already in use by someone."))
		return
	if(istype(W, /obj/item/clothing))
		var/obj/item/clothing/A = W
		if (A.customizable == 0)
			to_chat(usr, SPAN_NOTICE("This item cannot be customized. If you would like to use this apperance sprite and there is no matching item in the dispenser, please contact a DM."))
			return
		if (A.customizable == 1)
			active = TRUE
			A.dorms_ItemOwner = usr.name
			customize_desc(A)
			active = FALSE
			return

/obj/structure/customizer/clothing/proc/customize_desc(obj/item/clothing/W)
	var/obj/item/clothing/C = W
	var/new_desc = tgui_input_text(usr, message = "Enter the item DESCRIPTION for [C.name]- what you can see by looking at an item. Try to save most context for the lore description. Old custom description will be replaced. Remember to follow general RP guidelines.", title = "Customize Description: [C.name]", default = "[C.customizable_desc]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = TRUE, timeout = 0, trim = TRUE)
	C.customizable_desc = new_desc
	var/new_desc_lore = tgui_input_text(usr, message = "Enter the item LORE INFORMATION for [C.name]- Anything of note about the item that someone could find out by consulting public resources. You may also provide context for anything visible in your description. Old custom lore information will be replaced. Remember to follow general RP guidelines.", title = "Customize Lore Information: [C.name]", default = "[C.customizable_desc_lore]", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = TRUE, timeout = 0, trim = TRUE)
	C.customizable_desc_lore = new_desc_lore
	C.update_custom_descriptions()
	to_chat(usr, SPAN_NOTICE("The machine processes your request, snatches your garment, and proceeds to apply the desired customizations. The whole process lights up the inside of the machine with a dim blue light. The machine chimes when the process is complete."))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/customizer/clothing, animate_icon))
	return

/obj/structure/customizer/clothing/proc/animate_icon()
	if(icon_state != "customizer_work")
		icon_state = "customizer_work"
		update_icon()
		sleep(80)
		icon_state = initial(icon_state)
		update_icon()
