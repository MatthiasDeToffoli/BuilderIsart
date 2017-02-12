package com.isartdigital.perle.game;


/**
 * Constant for assetName, assetName can be wrong named
 * but not our constant ! ;)
 * It's like a GD to GDP traduction system
 * or
 * DA to GDP traduction
 * @author ambroise
 */
class AssetName{

	//building state
	public static inline var CONSTRUCT:String = "construction";
	public static inline var ANIM:String = "_anim";
	public static inline var ANIMATION:String = "animation";
	
	// Building Neutral
	public static inline var BUILDING_STYX_PURGATORY:String = "Tribunal";
	public static inline var BUILDING_STYX_PURGATORY_LEVEL2:String = "Tribunal_2";
	public static inline var BUILDING_STYX_PURGATORY_LEVEL3:String = "Tribunal_3";
	public static inline var BUILDING_STYX_VICE_1:String = "Bat_Altar_Vice_1";
	public static inline var BUILDING_STYX_VICE_2:String = "Bat_Altar_Vice_2";
	public static inline var BUILDING_STYX_VIRTUE_1:String = "Bat_Altar_Virtue_1";
	public static inline var BUILDING_STYX_VIRTUE_2:String = "Bat_Altar_Virtue_2";
	
	// Building Heaven
	public static inline var BUILDING_HEAVEN_HOUSE:String = "HeavenBuilding01";
	public static inline var BUILDING_HEAVEN_HOUSE_LEVEL2:String = "HeavenBuilding02";
	public static inline var BUILDING_HEAVEN_HOUSE_LEVEL3:String = "HeavenBuilding03";
	public static inline var BUILDING_HEAVEN_BRIDGE:String = "HeavenBuild3";
	public static inline var BUILDING_HEAVEN_COLLECTOR_LEVEL1:String = "HeavenLumberMill01";
	public static inline var BUILDING_HEAVEN_COLLECTOR_LEVEL2:String = "HeavenLumberMill02";
	public static inline var MARKETING_HOUSE:String = "HeavenMarketingPlace";
	public static inline var BUILDING_INTERN_HEAVEN_HOUSE:String = "HeavenInternsPortal";
	
	
	// Building Hell
	public static inline var BUILDING_HELL_HOUSE:String = "hellBuiding";
	public static inline var BUILDING_HELL_HOUSE_LEVEL2:String = "hellBuilding2";
	public static inline var BUILDING_HELL_HOUSE_LEVEL3:String = "hellBuilding3";
	public static inline var BUILDING_HELL_COLLECTOR_LEVEL1:String = "Hell_Quarry";
	public static inline var BUILDING_HELL_COLLECTOR_LEVEL2:String = "HellQuarry2";
	public static inline var BUILDING_INTERN_HELL_HOUSE:String = "InternHouseHell"; 
	public static inline var BUILDING_FACTORY:String = "Factory";
	
	
	// Décoration Heaven
	public static inline var DECO_HEAVEN_TREE_1:String = "HeavenPropRedTree";
	public static inline var DECO_HEAVEN_TREE_2:String = "HeavenPropTree";
	public static inline var DECO_HEAVEN_CLOUD:String = "HeavenPropCloud";
	public static inline var DECO_HEAVEN_LAKE:String = "HeavenPropLake";
	public static inline var DECO_HEAVEN_PARK:String = "HeavenPropPark";
	
	// Décoration Hell
	public static inline var DECO_HELL_BONES:String = "HellPropBones";
	public static inline var DECO_HELL_DEAD_HEAD:String = "HellPropBones02";
	public static inline var DECO_HELL_CRYSTAL_SMALL:String = "HellPropCrystal";
	public static inline var DECO_HELL_CRYSTAL_BIG:String = "HellPropCrystal02";
	public static inline var DECO_HELL_LAVA:String = "HellPropLake";
	
	// Confirm
	public static inline var POPIN_CONFIRM_BUY_CURRENCIE:String = "Popin_ConfirmBuyEuro";
	
	// Game
	public static inline var BTN_PRODUCTION:String = "ProdDone";
	
	// Element in many popin
	public static inline var BTN_CLOSE:String = "ButtonClose";
	public static inline var TIME_GAUGE_TEXT:String = "_Text_TimeSkipGaugeTime";
	public static inline var TEXT:String = "Text";
	
	// Shop
	public static inline var SHOP_PREFIX:String = "Shop_";
	public static inline var POPIN_SHOP:String = SHOP_PREFIX + "Building";
	public static inline var SHOP_BTN_CLOSE:String = SHOP_PREFIX +  "Close_Button";
	public static inline var SHOP_BTN_TAB_BUILDING:String = /*SHOP_PREFIX +*/ "Onglet_Building";
	public static inline var SHOP_BTN_TAB_DECO:String = /*SHOP_PREFIX +*/ "Onglet_Deco";
	public static inline var SHOP_BTN_TAB_INTERN:String = /*SHOP_PREFIX +*/ "Onglet_Interns";
	public static inline var SHOP_BTN_TAB_RESOURCE:String = /*SHOP_PREFIX +*/ "Onglet_Ressources";
	public static inline var SHOP_BTN_TAB_CURRENCIE:String = /*SHOP_PREFIX +*/ "Onglet_Currencies";
	public static inline var SHOP_BTN_TAB_BUNDLE:String = /*SHOP_PREFIX +*/ "Bundles_Button";
	public static inline var SHOP_CAROUSSEL_SPAWNER:String = /*SHOP_PREFIX +*/ "Item_List_Spawner";
	public static inline var SHOP_RESSOURCE_SC:String = /*SHOP_PREFIX +*/ "Player_SC";
	public static inline var SHOP_RESSOURCE_HC:String = /*SHOP_PREFIX +*/ "Player_HC";
	public static inline var SHOP_RESSOURCE_MARBRE:String = /*SHOP_PREFIX +*/ "Player_Marbre";
	public static inline var SHOP_RESSOURCE_BOIS:String = /*SHOP_PREFIX +*/ "Player_Bois";
	public static inline var SHOP_RESSOURCE_TEXT:String = /*SHOP_PREFIX +*/ "bar_txt";
	public static inline var SHOP_RESSOURCE_PACK_BUTTON:String = /*SHOP_PREFIX +*/ "Button";
	public static inline var SHOP_RESSOURCE_PACK_PRICE:String = /*SHOP_PREFIX +*/ "Pack_Content_txt";
	public static inline var SHOP_RESSOURCE_PACK_CONTENT:String = /*SHOP_PREFIX +*/ "Pack_Price";
	public static inline var SHOP_RESSOURCE_CARD_PICTURE:String = /*SHOP_PREFIX +*/ "Item_picture";
	public static inline var SHOP_RESSOURCE_CARD_NAME:String = /*SHOP_PREFIX +*/ "Item_Name";
	public static inline var SHOP_RESSOURCE_CARD_PRICE:String = /*SHOP_PREFIX +*/ "Item_CurrencyPrice";
	public static inline var SHOP_CAROUSSEL_DECO_BUILDING:String = SHOP_PREFIX + "BuildingDeco_List";
	public static inline var SHOP_CAROUSSEL_CURRENCIE:String = SHOP_PREFIX + "ResourcesTab_List";
	public static inline var SHOP_CAROUSSEL_INTERN:String = SHOP_PREFIX + "InternsTab_List";
	public static inline var SHOP_CAROUSSEL_INTERN_SEARCHING:String = SHOP_PREFIX + "InternsTab_Searching";
	public static inline var SHOP_CAROUSSEL_RESOURCE:String = SHOP_PREFIX + "ResourcesTab_List";
	public static inline var SHOP_CAROUSSEL_BUNDLE:String = SHOP_PREFIX + "Bundles_List";
	
	// Shop caroussel
	public static inline var CAROUSSEL_ARROW_LEFT:String = "Button_ArrowLeft";
	public static inline var CAROUSSEL_ARROW_RIGHT:String = "Button_ArrowRight";
	
	
	// Shop caroussel card
	public static inline var CAROUSSEL_CARD_UNLOCKED:String = "ButtonBuyBuildingDeco";
	public static inline var CAROUSSEL_CARD_UNLOCKED_BTN_INFO:String = "ButtonInfo";
	public static inline var CAROUSSEL_CARD_LOCKED:String = SHOP_PREFIX + "BuildingDeco_LockedItem";
	public static inline var CAROUSSEL_CARD_BUNDLE:String = "ButtonBundle";
	public static inline var CAROUSSEL_CARD_PACK_CURRENCY:String = "ButtonBuyPack";
	public static inline var CAROUSSEL_CARD_PACK_RESOURCE:String = "ButtonBuyPack_Ressource";
	
	// Shop caroussel card building unlock and locked
	public static inline var CARD_BACKGROUND_NEUTRAL_CONTAINER:String = "Bg";
	public static inline var CARD_BACKGROUND_HEAVEN_UP:String = "_itemunlockedHEAVEN_bg";
	public static inline var CARD_BACKGROUND_HEAVEN_DOWN:String = "_itemunlockedHEAVEN_down_bg";
	public static inline var CARD_BACKGROUND_HELL_UP:String = "_itemunlockedHELL_bg";
	public static inline var CARD_BACKGROUND_HELL_DOWN:String = "_itemunlockedHELL_down_bg";
	
	// Shop caroussel card pack
	public static inline var CARD_PACK_PRICE:String ="Pack_Price";
	public static inline var CARD_PACK_ICON_GAIN:String ="Pack_Content_Icon";
	public static inline var CARD_PACK_ICON_PRICE:String ="Pack_Price_Icon";
	public static inline var CARD_PACK_GAIN:String ="Pack_Content_txt";
	public static inline var CARD_PACK_PICTURE:String = "Pack_Picture";
		// Question : faire une boucle plutôt que de répéter le nombre de 1 à 5 ? un risque avec les GD !
	public static inline var CARD_PACK_PICTURE_KARMA_1:String = "_karmaPack1_portrait";
	public static inline var CARD_PACK_PICTURE_KARMA_2:String = "_karmaPack2_portrait";
	public static inline var CARD_PACK_PICTURE_KARMA_3:String = "_karmaPack3_portrait";
	public static inline var CARD_PACK_PICTURE_KARMA_4:String = "_karmaPack4_portrait";
	public static inline var CARD_PACK_PICTURE_KARMA_5:String = "_karmaPack5_portrait";
	public static inline var CARD_PACK_PICTURE_GOLD_1:String = "_goldPack1_portrait";
	public static inline var CARD_PACK_PICTURE_GOLD_2:String = "_goldPack2_portrait";
	public static inline var CARD_PACK_PICTURE_GOLD_3:String = "_goldPack3_portrait";
	public static inline var CARD_PACK_PICTURE_GOLD_4:String = "_goldPack4_portrait";
	public static inline var CARD_PACK_PICTURE_GOLD_5:String = "_goldPack5_portrait";
	public static inline var CARD_PACK_PICTURE_WOOD_1:String = "_woodPack1_portrait";
	public static inline var CARD_PACK_PICTURE_WOOD_2:String = "_woodPack2_portrait";
	public static inline var CARD_PACK_PICTURE_WOOD_3:String = "_woodPack3_portrait";
	public static inline var CARD_PACK_PICTURE_IRON_1:String = "_ironPack1_portrait";
	public static inline var CARD_PACK_PICTURE_IRON_2:String = "_ironPack2_portrait";
	public static inline var CARD_PACK_PICTURE_IRON_3:String = "_ironPack3_portrait";
	
	// Shop caroussel Bundle
	public static inline var CARD_BUNDLE_PICTURE:String = "_bundle_portrait_spawn";
	public static inline var CARD_BUNDLE_TEXT_NAME:String = "Title";
	public static inline var CARD_BUNDLE_TEXT_COST_IP:String = "IPCost";
	public static inline var CARD_BUNDLE_TEXT_GAIN_IRON:String = "StoneValue";
	public static inline var CARD_BUNDLE_TEXT_GAIN_WOOD:String = "WoodValue";
	public static inline var CARD_BUNDLE_TEXT_GAIN_SOFT:String = "SCValue";
	public static inline var CARD_BUNDLE_TEXT_GAIN_HARD:String = "HCValue";
	public static inline var CARD_BUNDLE_ICON_GAIN_IRON:String = "StoneIcon";
	public static inline var CARD_BUNDLE_ICON_GAIN_WOOD:String = "WoodIcon";
	public static inline var CARD_BUNDLE_ICON_GAIN_SOFT:String = "SCIcon";
	public static inline var CARD_BUNDLE_ICON_GAIN_HARD:String = "HCIcon";
	public static inline var CARD_BUNDLE_BACKGROUND:String = "BG"; // not used
	public static inline var CARD_BUNDLE_ICON_COST_IP:String = "IPIcon"; // not used
	public static inline var CARD_BUNDLE_PICTURE_1:String = "_bundle1_portrait";
	public static inline var CARD_BUNDLE_PICTURE_2:String = "_bundle2_portrait";
	public static inline var CARD_BUNDLE_PICTURE_3:String = "_bundle3_portrait";
	public static inline var CARD_BUNDLE_PICTURE_4:String = "_bundle4_portrait";
	
	// Shop caroussel Interns
	public static inline var CAROUSSEL_INTERN_BTN_REROLL:String = "Reroll_button";
	public static inline var CAROUSSEL_INTERN_HELL_CARD:String = "Intern_HellCard";
	public static inline var CAROUSSEL_INTERN_HEAVEN_CARD:String = "Intern_HeavenCard";
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER:String = "InternHouseNumber";
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER_HEAVEN:String = "_internHouseNumber";	
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER_HELL:String = "_internHouseNumber_actualValue";	
	public static inline var CAROUSSEL_INTERN_HEAVEN_PRICE:String = "_internPrice_heaven_txt";
	public static inline var CAROUSSEL_INTERN_HELL_PRICE:String = "_internPrice_hell_txt";
	
	// Shop Reroll
	public static inline var REROLL_GAUGE:String = "JaugeTimer";
	public static inline var REROLL_ACCELERATE_BUTTON:String = "Accelerate_button";
	public static inline var REROLL_GAUGE_BAR:String = "Bar";
	public static inline var REROLL_GAUGE_TEXT:String = "txt";
	
	//Shop caroussel Interns cards
	public static inline var CARD_NAME:String = "_internPortrait_Name";
	public static inline var CARD_PORTRAIT:String = "_intern_portrait";
	public static inline var CARD_GAUGE_EFFICIENCY:String = "_internCard_jauge_efficiency";
	public static inline var CARD_GAUGE_SPEED:String = "_internCard_jauge_speed";
	public static inline var CARD_GAUGE_STRESS:String = "_internCard_jauge_stress";
	
	// Popin Confirm Buy Building
	/*public static inline var POPIN_CONFIRM_BUY_BUILDING:String = "Popin_ConfirmationBuyHouse";
	public static inline var PCBB_IMG:String = "Building_Image";
	public static inline var PCBB_TEXT_NAME:String = "Building_Name";
	public static inline var PCBB_TEXT_LEVEL:String = "Building_Level_txt";
	public static inline var PCBB_PRICE:String = "Window_Infos_BuyPrice";
	public static inline var PCBB_PRICE_TEXT:String = "ButtonUpgrade_Cost_txt";
	public static inline var PCBB_GOLD_MAX:String = "Window_Infos_LimitGold";
	public static inline var PCBB_GOLD_MAX_TEXT:String = "Window_Infos_txtGoldLimit";
	public static inline var PCBB_POPULATION_MAX:String = "Window_Infos_Population";
	public static inline var PCBB_POPULATION_MAX_TEXT:String = "Window_Infos_txtPopulation";
	public static inline var PCBB_GOLD_PER_TIME:String = "Window_Infos_ProductionGold";
	public static inline var PCBB_GOLD_PER_TIME_TEXT_1:String = "Window_Infos_txtProductionGold";
	public static inline var PCBB_GOLD_PER_TIME_TEXT_2:String = "perTime";
	public static inline var PCBB_BTN_BUY:String = "BuyButton";*/
	
	// Info building
	public static inline var POPIN_INFO_BUILDING:String = "Fenetre_InfoMaison";
	public static inline var INFO_BUILDING_BTN_SELL:String = "ButtonDestroy";
	public static inline var INFO_BUILDING_BTN_UPGRADE:String = "ButtonUpgrade";
	
	//listIntern
	public static inline var INTERN_LIST:String = "ListInterns";
	public static inline var INTERN_LIST_LEFT:String = "_arrow_left";
	public static inline var INTERN_LIST_RIGHT:String = "_arrow_right";
	public static inline var INTERN_IN_QUEST_VALUE:String = "InternInQuest_Value";
	public static inline var INTERN_IN_QUEST_VALUE_MAX:String = "_internsInQuest_TotalValue";
	public static inline var INTERN_IN_QUEST_VALUE_ACTUAL:String = "_internsInQuest_value";
	
	public static inline var INTERN_HOUSE_NUMBER:String = "InternHouseNumber";
	public static inline var INTERN_HOUSE_NUMBER_HEAVEN:String = "_internHouseNumber_actualValue";
	public static inline var INTERN_HOUSE_NUMBER_HELL:String = "_internHouseNumber";
	
	public static var internListSpawners:Array<String> = ["Intern01", "Intern02", "Intern03"];
	
	
	//in quest
	public static inline var INTERN_INFO_IN_QUEST:String = "ListInQuest";
	public static inline var BUTTON_ACCELERATE_IN_QUEST:String = "Bouton_InternSend_Clip";
	public static inline var INTERN_NAME_IN_QUEST:String = "InQuest_name";
	public static inline var TIME_IN_QUEST:String = "InQuest_ProgressionBar";
	public static inline var IN_QUEST_EVENT_TIME:String = "_listInQuest_eventTime";
	public static inline var IN_QUEST_GAUGE:String = "InQuest_ProgressionBar";
	public static inline var PORTRAIT_IN_QUEST:String = "InQuest_Portrait";
	public static inline var IN_QUEST_HERO_CURSOR:String = "_listInQuest_hero";
	
	//out quest
	public static inline var INTERN_INFO_OUT_QUEST:String = "ListOutQuest";
	//public static inline var BUTTON_SEND_OUT_QUEST:String = "Bouton_SendIntern_List";
	public static inline var BUTTON_SEND_OUT_QUEST:String = "ButtonSend";
	public static inline var INTERN_NAME_OUT_QUEST:String = "_intern03_name05";
	public static inline var PORTRAIT_OUT_QUEST:String = "OutQuest_Portrait";
	public static inline var SPAWNER_BUTTON_OUT_QUEST:String = "_spawner_buttonStress_accelerate";
	public static inline var INTERN_OUT_EFF_TXT:String = "_txt_efficiency03";
	public static inline var INTERN_OUT_SEND_COST:String = "sendCost";
	public static inline var INTERN_OUT_IN_QUEST_CONTAINER:String = "InternInQuest_Value";
	public static inline var INTERN_OUT_ACTUAL_INTERNS_IN_QUEST:String = "_internsInQuest_value";
	
	//inter event popin
	public static inline var INTERN_EVENT:String = "Intern_Event";
	public static inline var INTERN_EVENT_DESC:String = "_event_description";
	public static inline var INTERN_EVENT_HEAVEN_CHOICE:String = "_heavenChoice_text";
	public static inline var INTERN_EVENT_HELL_CHOICE:String = "_hellChoice_text";
	public static inline var INTERN_EVENT_SEE_ALL:String = "ButtonInterns";
	public static inline var INTERN_EVENT_SHARE:String = "Button_Friends";
	public static inline var INTERN_EVENT_CLOSE:String = "CloseButton";
	public static inline var INTERN_EVENT_CARD:String = "_event_FateCard";
	public static inline var INTERN_EVENT_NAME:String = "_intern_name";
	public static inline var INTERN_EVENT_SIDE:String = "_intern_side";
	public static inline var INTERN_EVENT_STATS:String = "InternsStatsInEvent";
	public static inline var INTERN_EVENT_EFFICIENCY:String = "_txt_efficiency";
	
	// intern info jauges
	public static inline var INTERN_STRESS_JAUGE:String = "_jauge_stress";
	public static inline var INTERN_SPEED_JAUGE:String = "_jauge_speed";
	public static inline var INTERN_EFF_JAUGE:String = "_jauge_efficiency";
	
	//global intern properties
	public static inline var INTERN_STRESS_TXT:String = "_interns_stress";
	public static inline var INTERN_SPEED_TXT:String = "_intern_speed";
	
	public static inline var SPEED_INDICATOR:String = "_jaugeSpeed_0";
	public static inline var EFF_INDICATOR:String = "_jaugeEfficiency_0";
	
	//intern popin
	public static inline var INTERN_POPIN:String = "Interns";
	public static inline var INTERN_POPIN_SIDE:String = "_intern_side";
	public static inline var INTERN_POPIN_NAME:String = "_intern_name";
	public static inline var INTERN_POPIN_SEE_ALL_CONTAINER:String = "Bouton_AllInterns_Clip";
	public static inline var INTERN_POPIN_SEE_ALL:String = "Button";
	public static inline var INTERN_POPIN_CANCEL:String = "ButtonCancel";
	
	
	//Server Popin
	public static inline var POPIN_SERVER:String = "ConnectionIssue";
	
	//Gatcha popin
	public static inline var GATCHA_POPIN:String = "PopinGatcha";
	public static inline var GATCHA_POPIN_CLOSE_BUTTON:String = "ButtonClose";
	public static inline var GATCHA_POPIN_GATCHA_BAG:String = "GatchaBag";
	public static inline var GATCHA_POPIN_INTERN_PORTRAIT:String = "_internPortrait";
	public static inline var GATCHA_POPIN_INTERN_NAME:String = "_intern_name";
	public static inline var GATCHA_POPIN_INTERN_SIDE:String = "_intern_side";
	
	//Reward Gatcha popin
	public static inline var REWARD_GATCHA_POPIN:String = "RewardGatcha";
	public static inline var REWARD_GATCHA_POPIN_BUTTON:String = "ButtonReward";
	public static inline var REWARD_GATCHA_POPIN_VALUE:String = "_rewardGatcha_value";
	public static inline var REWARD_GATCHA_POPIN_ICON:String = "_rewardGatcha_Icon";
	
	//Max Stress popin
	public static inline var INTERN_EVENT_MAX_STRESS:String = "Popin_MaxStress";
	public static inline var MAXSTRESS_POPIN_CLOSE_BUTTON:String = "ButtonClose";
	public static inline var MAXSTRESS_POPIN_RESET_BUTTON:String = "ButtonResetStress";
	public static inline var MAXSTRESS_POPIN_DISMISS_BUTTON:String = "ButtonDismiss";
	public static inline var MAXSTRESS_POPIN_RESET_TEXT:String = "_resetStress_value_text";
	public static inline var MAXSTRESS_POPIN_INTERN_PORTRAIT:String = "_internPortrait";
	public static inline var MAXSTRESS_POPIN_INTERN_NAME:String = "_intern_name";
	public static inline var MAXSTRESS_POPIN_INTERN_SIDE:String = "_intern_side";
	
	//Intern House Popin
	public static inline var INTERN_HOUSE_INFOS_POPIN:String = "Interns";
	public static inline var INTERN_HOUSE_INFOS_POPIN_CLOSE_BUTTON:String = "ButtonClose";
	public static inline var INTERN_HOUSE_INFOS_POPIN_QUESTS_SPAWNER:String = "QuestSpawner";
	public static inline var INTERN_HOUSE_INFOS_POPIN_INTERN_NAME:String = "_intern_name";
	public static inline var INTERN_HOUSE_INFOS_POPIN_INTERN_SIDE:String = "_intern_side";
	public static inline var INTERN_HOUSE_INFOS_POPIN_INTERNS_IN_QUEST:String = "_internsInQuest_value";
	public static inline var INTERN_HOUSE_INFOS_POPIN_PORTRAIT:String = "_internPortrait";
	public static inline var INTERN_HOUSE_INFOS_POPIN_STATS:String = "_intern_bg_stats";
	public static inline var INTERN_HOUSE_INFOS_POPIN_DISMISS_BUTTON:String = "Bouton_InternDismiss_Clip";
	
	//purtagory popin
	public static inline var PURGATORY_POPIN:String = "PurgatoryPop";
	public static inline var PURGATORY_POPIN_CANCEL:String = "CloseButton";
	public static inline var PURGATORY_POPIN_SHOP:String = "ShopButton";
	public static inline var PURGATORY_POPIN_INTERN:String = "InternsButton";
	public static inline var PURGATORY_POPIN_HEAVEN_BUTTON:String = "HeavenButton";
	public static inline var PURGATORY_POPIN_HELL_BUTTON:String = "HellButton";
	public static inline var PURGATORY_POPIN_LEVEL:String = "BuildingLevel";
	public static inline var PURGATORY_POPIN_TIMER_CONTAINER:String = "UpgradeTimer";
	public static inline var PURGATORY_POPIN_TIMER:String = "TimeInfo";
	public static inline var PURGATORY_POPIN_SOUL_INFO:String = "FateTitle";
	public static inline var PURGATORY_POPIN_SOUL_NAME:String = "Name";
	public static inline var PURGATORY_POPIN_SOUL_ADJ:String = "Adjective";
	public static inline var PURGATORY_POPIN_HEAVEN_INFO:String = "HeavenINfo";
	public static inline var PURGATORY_POPIN_HELL_INFO:String = "HellInfo";
	public static inline var PURGATORY_POPIN_INFO_BAR:String = "bar_txt";
	public static inline var PURGATORY_POPIN_ALL_SOULS_INFO:String = "SoulCounter";
	public static inline var PURGATORY_POPIN_ALL_SOULS_NUMBER:String = "Value";
	public static inline var PURGATORY_POPIN_UPGRADE:String = "ButtonUpgrade";
	public static inline var PURGATORY_POPIN_UPGRADE_PRICE:String = "Cost";
	
	//Ftue
	public static inline var FTUE_SCENARIO:String = "Window_NPC";
	public static inline var FTUE_SCENARIO_WINDOW:String = "Window_Ftue_Scenario";
	public static inline var FTUE_ACTION:String = "Window_Ftue_Action";
	public static inline var FTUE_SCENARIO_BUTTON:String = FTUE_SCENARIO+"_ButtonNext";
	public static inline var FTUE_SCENARIO_HELL:String = "Window_NPC_Hell";
	public static inline var FTUE_ACTION_HELL:String = "_ftue_mascot_demona";
	public static inline var FTUE_SCENARIO_HEAVEN:String = "Window_NPC_Heaven";
	public static inline var FTUE_ACTION_HEAVEN:String = "_ftue_mascot_angela";
	public static inline var FTUE_SCENARIO_NAME:String = FTUE_SCENARIO+"_Name_TXT";
	public static inline var FTUE_SCENARIO_SPEACH:String = FTUE_SCENARIO+"_Speech_TXT";
	public static inline var FTUE_ACTION_SPEACH:String = "_infobulle_text";
	
	// HUD
	public static inline var HUD_PREFIX:String = "HUD_";
	public static inline var HUD_BTN_RESET_DATA:String = "ALPHA_ResetData";
	public static inline var HUD_BTN_SHOP:String = "ButtonShop_HUD";
	public static inline var HUD_BTN_PURGATORY:String = HUD_PREFIX + "PurgatoryButton";
	public static inline var HUD_CONTAINER_BTN_INTERNS:String = HUD_PREFIX + "InternsButton";
	public static inline var HUD_BTN_INTERNS:String = HUD_PREFIX + "InternsButton";
	public static inline var HUD_BTN_OPTIONS:String = "ButtonOptions";
	public static inline var HUD_COUNTER_SOFT:String = HUD_PREFIX + "SoftCurrency";
	public static inline var HUD_BTN_SOFT:String = /*HUD_PREFIX + */"ButtonPlusSC";
	public static inline var HUD_COUNTER_HARD:String = HUD_PREFIX + "HardCurrency";
	public static inline var HUD_BTN_HARD:String = /*HUD_PREFIX + */"ButtonPlusHC";
	public static inline var HUD_COUNTER_MATERIAL_HEAVEN:String = HUD_PREFIX + "Wood";
	public static inline var HUD_COUNTER_MATERIAL_HELL:String = HUD_PREFIX + "Iron";
	public static inline var HUD_BTN_WOOD:String = /*HUD_PREFIX + */"ButtonPlusWOOD";
	public static inline var HUD_BTN_IRON:String = /*HUD_PREFIX + */"ButtonPlusIRON";
	public static inline var HUD_COUNTER_XP_HEAVEN:String = HUD_PREFIX + "HeavenXP";
	public static inline var HUD_COUNTER_XP_HELL:String = HUD_PREFIX + "HellXP";
	public static inline var HUD_COUNTER_LEVEL:String = HUD_PREFIX + "Level";
	public static inline var HUD_MOVNG_BUILDING:String = /*HUD_PREFIX + */"MovingBuilding";
	public static inline var HUD_MOVNG_BUILDING_DESKTOP:String = /*HUD_PREFIX + */"MoveBuilding_Desktop";
	public static inline var HUD_MOVNG_BUILDING_BTN_CANCEL:String = "Button_CancelMovement";
	public static inline var HUD_MOVNG_BUILDING_BTN_CONFIRM:String = "Button_ConfirmMovement";
	
	
	public static inline var COUNTER_TXT_XP:String = "Hud_xp_txt";
	public static inline var COUNTER_TXT_RESSOURCE:String = "bar_txt";
	public static inline var COUNTER_TXT_LEVEL:String = "_level_txt";
	
	//collector popin
	public static inline var COLLECTOR_POPIN:String = "InfoCollector";
	public static inline var COLLECTOR_PANEL:String = "ProductionPanelsContainer";
	public static inline var PACK_COLLECTOR_PANEL:String = "ProductionPanel";
	public static inline var PACK_COLLECTOR_LOCK_PANEL:String = "ProductionPanel_Locked";
	public static inline var PANEL_COLLECTOR_SPAWNER:String = "_productionPanelSpawner";
	public static inline var PANEL_COLLECTOR_SPAWNER_ICON:String = "_buildRessourceIcon_Large";
	public static inline var PANEL_COLLECTOR_TIME_TEXT:String = "_time_value";
	public static inline var PANEL_COLLECTOR_GAIN:String = "_ressourceGain_text";
	public static inline var PANEL_COLLECTOR_BUTTON:String = "ButtonProduce";
	public static inline var PANEL_COLLECTOR_BUTTON_TEXT:String = "_buttonProduce_GoldValue";
	public static inline var COLLECTOR_TIME_IN_PROD:String = "CollectorInProduction";
	public static inline var COLLECTOR_TIME_GAUGE:String = "TimeGauge";
	public static inline var COLLECTOR_TIME_GAIN:String = "ProducingValue";
	public static inline var COLLECTOR_TIME_ICON:String = "ProducingIcon";
	public static inline var COLLECTOR_TIME_ACCELERATE_BUTTON:String = "AccelerateButton";
	
	//Marketing popin
	public static inline var MARKETING_POPIN:String = "InfoMarketing";
	public static inline var MARKETING_PANEL_CAMPAIGN:String = "MarketingCampaigns_Spawn";
	public static inline var MARKETING_CAMPAIGN:String = "MarketingCampaign";
	public static inline var VIDEO:String = "Video";
	public static inline var VIDEO_BTN:String = VIDEO + "Button";
	public static inline var CAMPAIGN_BTN:String = "CampaignButton";
	public static inline var CAMPAIGN_BOOST_VALUE:String = "IncomeValue";
	public static inline var CAMPAIGN_TIME_VALUE:String = "IncomeTime";
	public static inline var CAMPAIGN_PANEL_TIMER:String = "MarketingIsCampaigning";
	public static inline var CAMPAIGN_TIMER:String = "TimeBar";
	public static inline var CAMPAIGN_TIMER_BOOST_VALUE:String = "CampaignIncomingValue";
	public static inline var CAMPAIGN_TIMER_TIME_VALUE:String = "CampaignIncomingTime";
	public static inline var CANCEL_AD_VIDEO:String = "CancelVideo_Popin";
	public static inline var CANCEL_AD_VIDEO_BTN_OK:String = "ButtonStopVideo";
	
	//LevelUpPoppin
	public static inline var LEVELUP_POPPIN:String = "Popin_LevelUp";
	public static inline var LEVELUP_POPPIN_BUTTON:String = "Button_NextReward";
	public static inline var LEVELUP_POPPIN_PASSALL:String = "ButtonShowAll";
	public static inline var LEVELUP_POPPIN_LEVELBG:String = "_bg_level";
	public static inline var LEVELUP_POPPIN_LEVEL:String = "level";
	public static inline var LEVELUP_POPPIN_TYPE:String = "_txt_type";
	public static inline var LEVELUP_POPPIN_TEXT_NEW:String = "_txt_new";
	public static inline var LEVELUP_POPPIN_UNLOCK:String = "_unlock";
	public static inline var LEVELUP_POPPIN_NAME:String = "_txt_name";
	public static inline var LEVELUP_POPPIN_IMG:String = "Image";
	public static inline var LEVELUP_POPPIN_DESCRIPTION:String = "Description";
	public static inline var LEVELUP_POPPIN_CONGRATS:String = "_txt_congratulations";
	public static inline var LEVELUP_POPPIN_SKIP_TEXT:String = "Text";
	public static inline var LEVELUP_POPPIN_NEXT_TEXT:String = "_txt_continue";
	
	//Destroy Poppin
	public static inline var DESTROY_POPPIN:String = "Popin_DestroyBuilding";
	
	
	
	//XP Gauges
	public static inline var XP_GAUGE_HELL:String = "HUD_HellXP";
	public static inline var XP_GAUGE_HEAVEN:String = "HUD_HeavenXP";
	
	
	//contextual
	public static inline var CONTEXTUAL_NOT_UPGRADABLE:String = "BuiltContext_noUpgrade";
	public static inline var CONTEXTUAL_IN_UPGRADING:String = "BuiltContext_InUpgrading";
	public static inline var CONTEXTUAL_HOUSE:String = "BuiltContext_house";
	public static inline var CONTEXTUAL_MARKETING:String = "BuiltContext_Marketing";
	public static inline var CONTEXTUAL_COLLECTOR:String = "BuiltContext_Collector";
	public static inline var CONTEXTUAL_COLLECTOR_NOT_UPGRADABLE:String = "BuiltContext_Collector2";
	public static inline var HOUSE_SOUL_COUNTER:String = "SoulsCounter_house";
	public static inline var CONTEXTUAL_BTN_CANCEL:String = "ButtonCancelUpgrade";
	public static inline var CONTEXTUAL_BTN_LAST_PRODUCTION:String = "ButtonLastProd";
	// add background and any other assetName coming from DA
	//bg
	public static inline var BACKGROUND_HELL:String = "BG_Hell";
	public static inline var BACKGROUND_HEAVEN:String = "BG_Heaven";
	public static inline var BACKGROUND_STYX:String = "Styx01";
	
	public static inline var BACKGROUND_UNDER_HEAVEN = "BG_Under_heaven";
	public static inline var BACKGROUND_UNDER_HELL = "hell_bg_free";
	public static inline var BACKGROUND_UNDER_STYX = "BG_Under_Styx";
	
	//button production assets
	
	public static inline var PROD_ICON_SOFT:String = "_goldIcon__Large_Prod";
	public static inline var PROD_ICON_HARD:String = "_hardCurrencyIcon_Large";
	public static inline var PROD_ICON_WOOD:String = "_woodIcon_Large";
	public static inline var PROD_ICON_STONE:String = "_stoneIcon_Large";
	
	//icone small
	
	public static inline var PROD_ICON_SOUL_HEAVEN_SMALL:String = "_heavenSoulIcon_Small";
	public static inline var PROD_ICON_SOUL_HELL_SMALL:String = "_hellSoulIcon_Small";
	
	//icone large
	public static inline var PROD_ICON_WOOD_LARGE:String = "_woodIcon_Large";
	public static inline var PROD_ICON_STONE_LARGE:String = "_stoneIcon_Large";
	
	//Option Poppin
	public static inline var OPTION_POPPIN:String = "Options_Popin";
	public static inline var OPTION_POPPIN_CLOSE:String = "ButtonClose";
	public static inline var OPTION_POPPIN_RESETDATA:String = "ButtonDataReset";
	public static inline var OPTION_POPPIN_SFX:String = "ButtonSFXGroup";
	public static inline var OPTION_POPPIN_MUSIC:String = "ButtonMusicGroup";
	public static inline var OPTION_POPPIN_FR:String = "ButtonFrench";
	public static inline var OPTION_POPPIN_EN:String = "ButtonEnglish";
	public static inline var OPTION_POPPIN_LANGUAGE_TEXT:String = "_languageChoice_text";
	public static inline var OPTION_POPPIN_DATAS_TEXT:String = "_dataOptions_text";
	public static inline var OPTION_POPPIN_SOUND_TEXT:String = "_soundOptions_text";
	public static inline var OPTION_POPPIN_DATAS_BTN_TEXT:String = "_dataReset_button_txt";
	//public static inline var OPTION_POPPIN_SOUND_TEXT:String = "_soundOptions_text";
	
	//ResetPoppin
	public static inline var RESET_POPPIN:String = "ConfirmDataReset_Popin";
	public static inline var RESET_POPPIN_CONFIRM:String = "ButtonConfirmErase";
	public static inline var RESET_POPPIN_CANCEL:String = "ButtonCancelErase";

}