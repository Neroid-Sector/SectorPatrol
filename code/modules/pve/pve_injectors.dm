// The actual chemical
/datum/reagent/medical/stimfluid
	name = "Stimulant liquid"
	id = "SuperStim"
	description = "A light green tinted watery liquid. Smells like fresh apples. Tastest awful, which is why it should be injected."
	reagent_state = LIQUID
	color = "#8ae786"
	custom_metabolism = AMOUNT_PER_TIME(1, 10)
	data = 0
	overdose = 200
	properties = list(PROPERTY_OMNIPOTENT = 20,PROPERTY_DEFIBRILLATING = 20,PROPERTY_CARDIOSTABILIZING = 10, PROPERTY_PAINKILLING = 5)

//Stim stuff

/obj/item/stim_injector
	name = "UACM GA-8 WY brand Combat Stimulant Syringe"
	desc = "An autoinjector with five compartments."
	icon = 'code/modules/pve/stim.dmi'
	icon_state = "stim_5"
	var/owner_mob
	var/volume = 25
	var/cooldown_time = 0
	var/cooldown_val = 50
	var/injector_bound

/obj/item/stim_injector/update_icon()
	if(reagents.total_volume > 0)
		var/num_to_append = floor(reagents.total_volume / 5)
		var/text_to_append = num2text(num_to_append)
		if(num_to_append > 1)
			icon_state = "stim_[text_to_append]"
		else
			icon_state = "stim_empty"
	else
		icon_state = "stim_empty"
	. = ..()

/obj/item/stim_injector/Initialize(mapload, ...)
	. = ..()
	create_reagents(volume)
	reagents.add_reagent("SuperStim", volume)

/obj/item/stim_injector/attack_self(mob/user)
	. = ..()
	attack(user, user)

/obj/item/stim_injector/attack(mob/living/M, mob/living/user)
	if(user.bound_injector == null && injector_bound == 0)
		var/mob/living/carbon/human/human_to_bind = user
		if(human_to_bind) human_to_bind.bind_stimpack(src)
	if(volume <= 0)
		to_chat(user, SPAN_WARNING("Your stim is empty!"))
	if(cooldown_time > world.time)
		return
	if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	cooldown_time = world.time + cooldown_val
	playsound(loc, 'sound/items/hypospray.ogg', 60, 1)
	reagents.reaction(M, INGEST)
	reagents.trans_to(M, 5)
	user.visible_message("[user] injects [M] with the Super Stimulant!", "You inject [M] with the Super Stimulant!")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with a SuperStim by [key_name(user)].")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has injected [key_name(M)] with a SuperStim.")
	var/mob/living/carbon/target_human = M
	for (var/obj/limb/limb_in_mob in target_human)
		if(limb_in_mob.status & LIMB_BROKEN)
			target_human.pain.apply_pain(-PAIN_BONE_BREAK)
			limb_in_mob.status &= ~LIMB_BROKEN
	update_icon()

