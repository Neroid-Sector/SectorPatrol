/obj/structure/machinery/cm_vending/clothing/super_snowflake/sp_civclothes
	name = "OV-PST Civilian Clothing Production Line Dispenser"
	desc = "A generic looking vending machine, displaying various articles of clothing on its colored screen. Seems to react to anyone approaching it. This device seems to be connected to a thick Liquid Data conduit that ties to the rest of the station."
	desc_lore = "Recreated from generic blueprints of vending machines acquired from Earth, these devices have two key unique qualities. First, the screens and electronic parts were all manufactured on the PST, meaning that they all carry traces of the stations Liquid Data foundries and are also able to display colored images if they are not taken off station. Second, these devices aren't vending machines at all, but rather end points in a complex manufacturing system that, at least in theory, utilizes polymers, resins and unique metal alloys to manufacture everything its crew may need."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "clothes"
	item_types = list(/obj/item/clothing/head/sp_personal/basehat, /obj/item/clothing/under/sp_personal/baseunder/, /obj/item/clothing/suit/sp_personal/basejacket/, /obj/item/clothing/socks/compression/thigh/, /obj/item/clothing/shoes/sp_personal/baseshoe/)
	vend_delay = 2 SECONDS
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/clothing/super_snowflake/sp_tiles
	name = "OV-PST NRPS compliant tile press"
	desc = "A complex machine connected to a sizable Liquid Data port that colors, stamps, and 'bakes' NRPS compliant floor tiles on demand."
	desc_lore = "Machines like these are used in other manufacturing facilities that produce NRPS compliant tiles, this one however seems to have been heavily modified to both make the process work with the unique materials and energy threshold available on the PST and to be Liquid Data compatible. The result is hard to deny, a complete set of tiles can be 'baked' in around 10 seconds compared to a whole day in most solutions. Near infinite stores of energy, as it turns out, have their benefit."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "tiles"
	item_types = list(/obj/item/stack/modulartiles, /obj/item/modular/sealant)
	vend_delay = 10 SECONDS
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/clothing/super_snowflake/sp_tiles

/obj/item/reagent_container/food/snacks/mre_pack/uacm
	name = "OV-PST All-In-One Hypernutrient meal"
	desc = "A disposable, recyclable food tray with surprisingly juicy white lumps that feel almost like meat if you close your eyes. Amd pinch your nose. While the presentation leaves much to be desired, the aroma isn't bad and at least the food looks fresh."
	desc_lore = "The energy required to properly create, cultivate, harvest, and turn biomatter into something edible on-board ships or space stations means that any technology of this type remained a fever dream and to anyone's knowledge never was explored to any extent. It is curious then that the PST not only seems to have a pipeline fully capable of just that, but this does also not seem to be the initial iteration of this technology considering how refined it seems to be. This would likely mean this technology was pioneered back when the PST belonged to the cult of the Godseekers and Deep Void. Bon Appetit!"
	icon = 'icons/obj/items/sp_cargo.dmi'
	icon_state = "pstmeal"

/obj/item/reagent_container/food/snacks/mre_pack/uacm/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 25)
	bitesize = 3
/obj/structure/machinery/cm_vending/sorted/sectorpatrol/food
	name = "OV-PST Meal Assembly Station"
	desc = "USCM Food Vendor, containing standard military Prepared Meals."
	desc_lore = "This machine seems to not only dispense the food but also serves as the last stage in the PSTs bio generation process. Depending on the desired texture of the food, this machine can flash heat or freeze the product right before handing it out. The end product certainly does not look like what it claims to be, but it very much tastes like it almost to the letter."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "food"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 28
	deny_delay = 20


/obj/structure/machinery/cm_vending/sorted/sectorpatrol/food/populate_product_list(scale)
	listed_products = list(
		list("UACM OV-PST BIOMASS PROCESSOR", -1, null, null),
		list("I promise this tastes and works better than it looks. Unlockng the full potential of this technology will require a Corporate contract most likely. I'll fill you in when it's time. For now, the only consolation I have is that this is what everyone is eating. -C.", -1, null, null),
		list("OV-PST Hyperprotein All-In-One Meal", 50, /obj/item/reagent_container/food/snacks/mre_pack/uacm, VENDOR_ITEM_REGULAR),
	)

/obj/item/reagent_container/food/drinks/coffee/uacm
	desc = "A brown, thick paper cup with a hot beverage inside, complete with a spill proof lid and a cardboard straw. 100% recyclable, including the liquid inside. The coffee smells bland, but has a decent, medium roast flavor and a decent kick to it."
	desc_lore = "OV-PST coffee is not grown, but rather manufactured as a compound that is injected into recycled water, then warmed up after careful blending. This is likely why the coffee ends up smelling more like bad water, however the lab-perfected taste tends to make up for this at least somewhat."

/obj/item/reagent_container/food/drinks/tea/uacm
	name = "tea"
	desc = "A brown, thick paper cup with a hot beverage inside, complete with a spill proof lid and a cardboard straw. 100% recyclable, including the liquid inside. The liquid inside seems odorless and colorless, but tastes like a good, strong, Earl Gray tea."
	desc_lore = "OV-PST tea is not grown, but rather manufactured as a compound that is injected into recycled water, then warmed up after careful blending. The lack of color and odor is a byproduct of this process - artificial flavorings and colors throw the taste off too much, at least that is what the PST's systems claim. The experience isn't bad, but the lack of an aroma is certainly noticeable."

/obj/item/reagent_container/food/drinks/h_chocolate/uacm
	name = "hot coffee"
	desc = "A brown, thick paper cup with a hot beverage inside, complete with a spill proof lid and a cardboard straw. 100% recyclable, including the liquid inside. Appears to contain a genuine, natural cup of hot chocolate. A near perfect mix of sweet and dark."
	desc_lore = "Artificial chocolate rivaling and in many cases topping in quality natural sources is the product of refugees fleeing the fall of Europe into the Northern Republic. The Northerners, keen to strike back at what is undeniably a threat to their very existence, would often support unorthodox projects they thought would be useful against the UPP in the long run. Artificial chocolate, along with other endangered 'comfort' products like coffee, tea and honey were perfected in cooperation with UA and TWE partners as a way of curing UPP dominance on the black market of these crops and substances. As such, it is probably the only foodstuff on the PST that tastes, looks and smells just like you would expect it."
/obj/structure/machinery/cm_vending/sorted/sectorpatrol/hot_drink
	name = "OV-PST hot drink dispenser"
	desc = "A simple dispenser that drops a cup and fills it with a warmed-up liquid. A small console can be used to select a beverage. A light blue cable sticking out of the devices frame suggests that it has been modified to work in a Liquid Data environment."
	desc_lore = "An often not mentioned aspect of life on bigger space faring installations and ships is the constant fight against moisture. Closed air environment hate moisture and somehow, humans just can't stop getting… Moist. Under most circumstances powering a system that would in any significant way reduce, let alone nullify moisture devastating long term effect on say heavy machinery or ship hulls would be considered a fool's errand. There is no power source known to man, or in fact conceivable by current human understanding of physics that would get the job done without producing a net loss. The PST is not concerned about power. Moisture is recycled to the last drop, a non-insignificant part of it is distilled, re-mineralized and then reused. Like, in hot beverage dispensers for instance. Bottoms up!"
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "coffee"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 28
	deny_delay = 20

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/hot_drink/populate_product_list(scale)
	listed_products = list(
		list("UACM OV-PST HOT BEVARAGE DISPENSER", -1, null, null),
		list("Artificial Coffee, Real Caffeine", 50, /obj/item/reagent_container/food/drinks/coffee/uacm, VENDOR_ITEM_REGULAR),
		list("Tea flavored water. Contains Caffeine.", 50, /obj/item/reagent_container/food/drinks/tea/uacm, VENDOR_ITEM_REGULAR),
		list("Hot Chocolate", 50, /obj/item/reagent_container/food/drinks/h_chocolate/uacm, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/cigrette
	name = "stripped cigarette dispenser"
	desc = "A cigarette dispensing machine stripped of all branding."
	desc_lore = "Cigarette companies formed a single trust at the turn of the century as they firmly attached themselves to humanities efforts in the stars. Their hold on patents, trademarks and anything related to smoking tobacco is undisputed and as such, no real research is taking place into spaceborne alternatives. The fact that this machine seems to have been stolen rather than created on board the PST seems to suggest that instead of reproduction someone picked a more… Direct route of acquiring these machines and their contents."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "cigs"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 10
	deny_delay = 10

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/cigrette/populate_product_list(scale)
	listed_products = list(
		list("FREE CIGARETTES. DON'T ASK QUESTIONS, OKAY?", -1, null, null),
		list("Koorlander Gold", 20, /obj/item/storage/fancy/cigarettes/kpack, VENDOR_ITEM_REGULAR),
		list("Arcturian Ace", 20, /obj/item/storage/fancy/cigarettes/arcturian_ace, VENDOR_ITEM_REGULAR),
		list("Emerald Green", 20, /obj/item/storage/fancy/cigarettes/emeraldgreen, VENDOR_ITEM_REGULAR),
		list("Weyland-Yutani Gold", 20, /obj/item/storage/fancy/cigarettes/wypacket, VENDOR_ITEM_REGULAR),
		list("Lady Fingers", 20, /obj/item/storage/fancy/cigarettes/lady_finger, VENDOR_ITEM_REGULAR),
		list("Executive Select", 20, /obj/item/storage/fancy/cigarettes/blackpack, VENDOR_ITEM_REGULAR),
		list("FREE LIGHTERS. THEY CAME WITH THE CIGS.", -1, null, null),
		list("Disposable lighter", 100, /obj/item/tool/lighter/random, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/soda
	name = "stripped soda dispenser"
	desc = "A soda dispensing machine and fridge, stripped of all branding."
	desc_lore = "Every planet, ship, tourist destination, foundry, kennel, and orphanage out in the galaxy has a soft beverage of choice. And they have opinions about it, best expressed over consuming said soft drinks, mixed with copious amounts of alcohol. This is most likely why the PST seems to be littered with copious amounts of Souto soft drinks, but perhaps it may not be the best of ideas to question this choice."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "Cola_Machine"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 10
	deny_delay = 10

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/soda/populate_product_list(scale)
	listed_products = list(
		list("REGULAR SOUTO SOFT DRINKS", -1, null, null),
		list("Souto Classic", 20, /obj/item/reagent_container/food/drinks/cans/souto/classic, VENDOR_ITEM_REGULAR),
		list("Cherry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/cherry, VENDOR_ITEM_REGULAR),
		list("Lime Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/lime, VENDOR_ITEM_REGULAR),
		list("Grape Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/grape, VENDOR_ITEM_REGULAR),
		list("Blue Raspberry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/blue, VENDOR_ITEM_REGULAR),
		list("Peach Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/peach, VENDOR_ITEM_REGULAR),
		list("Cranberry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/cranberry, VENDOR_ITEM_REGULAR),
		list("Vanilla Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/vanilla, VENDOR_ITEM_REGULAR),
		list("Pineapple Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/pineapple, VENDOR_ITEM_REGULAR),
		list("DIET SOUTO SOFT DRINKS", -1, null, null),
		list("Diet Souto Classic", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/classic, VENDOR_ITEM_REGULAR),
		list("Diet Cherry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/cherry, VENDOR_ITEM_REGULAR),
		list("Diet Lime Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/lime, VENDOR_ITEM_REGULAR),
		list("Diet Grape Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/grape, VENDOR_ITEM_REGULAR),
		list("Diet Blue Raspberry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/blue, VENDOR_ITEM_REGULAR),
		list("Diet Peach Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/peach, VENDOR_ITEM_REGULAR),
		list("Diet Cranberry Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry, VENDOR_ITEM_REGULAR),
		list("Diet Vanilla Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla, VENDOR_ITEM_REGULAR),
		list("Diet Pineapple Souto", 20, /obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/salvage
	name = "OV PST Salvaging Gear Dispenser"
	desc = "A bulky machine that seems to be connected to a bigger storage below this deck."
	desc_lore = "Dispensers like these are considered standard and are required whenever handling of classified, prototype or experimental gear is involved. Since the Test Crews use PST created gear, all infused with Pythia's LD traces at the very least, all gear must be accessed through a dispenser for security purposes. These devices also disinfect, inspect and repair/replace any gear that may require it."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "spacesuit"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 10
	deny_delay = 10

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/salvage/populate_product_list(scale)
	listed_products = list(
		list("SPACESUITS - MANDATORY", -1, null, null),
		list("LD-Polymer Spacesuit", 10, /obj/item/clothing/head/helmet/space/uacm, VENDOR_ITEM_REGULAR),
		list("LD-Polymer Spacesuit Helmet", 10, /obj/item/clothing/suit/space/uacm, VENDOR_ITEM_REGULAR),
		list("TANK AND NOZZLES", -1, null, null),
		list("Backpack - One per 3 person squad", 1, /obj/item/salvage/recycler_backpack, VENDOR_ITEM_REGULAR),
		list("Nozzles - One per squad memeber. One spare.", 4, /obj/item/salvage/recycler_nozzle, VENDOR_ITEM_REGULAR),
		list("TOOLS", -1, null, null),
		list("Left Hand Pouch - Screwdriver, wirecutters, multitool.", 10, /obj/item/storage/pouch/uacm/salvage/left, VENDOR_ITEM_REGULAR),
		list("Left Hand Pouch - Drill, crowbar, wrench.", 10, /obj/item/storage/pouch/uacm/salvage/right, VENDOR_ITEM_REGULAR),
		list("High powered flashlight.", 10, /obj/item/device/flashlight/salvage, VENDOR_ITEM_REGULAR),
		list("Intel Document Pouch", 10, /obj/item/storage/pouch/document/uacm_salvage, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/spikes
	name = "OV PST LD Encrypter"
	desc = "A heavily modified 3d printer with multiple strange looking, blue-tinted devices attached to it."
	desc_lore = "Encrypted, or polarized Liquid Data is utilized by intelligence service of all three of the major superpowers to maintain an always up to date FTL comms network across all assets. This also means that any civilian research into LD data capabilities is prohibited, and LD stores are highly guarded secrets. But LD Encryption, at least as claimed by the OV-PST Engineering Corps, can be used for far more than just simple data synchronization. With the help of a special device, like the one you are looking at, LD cells can be given specific instructions that can be later utilized in data collection or coordination. This device can be used to prepare LD-enabled spikes useful in salvaging for either data collection or final deconstruction of cleared rooms."
	icon = 'icons/obj/structures/machinery/vending_sp.dmi'
	icon_state = "intel"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	vend_delay = 10
	deny_delay = 10

/obj/structure/machinery/cm_vending/sorted/sectorpatrol/spikes/populate_product_list(scale)
	listed_products = list(
		list("LD Data Spike - Data Extraction", 50, /obj/item/salvage/data_spike, VENDOR_ITEM_REGULAR),
		list("LD Drone Spike - Final Room Deconstruction", 50, /obj/item/salvage/drone_spike, VENDOR_ITEM_REGULAR),
	)
