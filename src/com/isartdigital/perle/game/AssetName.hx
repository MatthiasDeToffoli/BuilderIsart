package com.isartdigital.perle.game;
import com.isartdigital.perle.ui.popin.choice.Choice.RewardType;


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
	public static inline var BUILDING_HELL_HOUSE:String = "hellBuilding";
	public static inline var BUILDING_HELL_HOUSE_LEVEL2:String = "hellBuilding2";
	public static inline var BUILDING_HELL_HOUSE_LEVEL3:String = "hellBuilding3";
	public static inline var BUILDING_HELL_COLLECTOR_LEVEL1:String = "Hell_Quarry";
	public static inline var BUILDING_HELL_COLLECTOR_LEVEL2:String = "HellQuarry2";
	public static inline var BUILDING_INTERN_HELL_HOUSE:String = "InternHouseHell";
	public static inline var BUILDING_FACTORY:String = "HellFactory";
	
	
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
	
	//values change
	public static inline var VALUES_GAIN:String = "ValueChange_Positive";
	public static inline var VALUES_LOST:String = "ValueChange_Negative";
	public static inline var VALUES_CHANGE_ICON:String = "icon";
	public static inline var VALUES_CHANGE_TEXT:String = "value";
	
	//screen
	public static inline var LOGO_ISART:String = 'logo_ISART.png';
	// Confirm
	public static inline var POPIN_CONFIRM_BUY_CURRENCIE:String = "Popin_ConfirmBuyEuro";
	
	// Game
	public static inline var BTN_PRODUCTION:String = "ProdDone";
	
	// Element in many popin
	public static inline var BTN_CLOSE:String = "ButtonClose";
	public static inline var TIME_GAUGE_TEXT:String = "_Text_TimeSkipGaugeTime";
	public static inline var TEXT:String = "Text";
	public static inline var TIME_ACCELERATE_BUTTON_TXT:String = "_accelerate_cost";
	
	//buyRegionButton
	public static inline var BTN_BUY_REGION:String = "ButtonBuyRegion";
	public static inline var BTN_BUY_REGION_PRICE:String = "Cost";
	
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
	public static inline var SHOP_CAROUSSEL_DECO_BUILDING:String = SHOP_PREFIX + "BuildingDeco_List";
	public static inline var SHOP_CAROUSSEL_CURRENCIE:String = SHOP_PREFIX + "ResourcesTab_List";
	public static inline var SHOP_CAROUSSEL_INTERN:String = SHOP_PREFIX + "InternsTab_List";
	public static inline var SHOP_CAROUSSEL_INTERN_SEARCHING:String = SHOP_PREFIX + "InternsTab_Searching";
	public static inline var SHOP_CAROUSSEL_RESOURCE:String = SHOP_PREFIX + "ResourcesTab_List";
	public static inline var SHOP_CAROUSSEL_BUNDLE:String = SHOP_PREFIX + "Bundles_List";
	
	// Shop caroussel
	public static inline var CAROUSSEL_ARROW_LEFT:String = "Button_ArrowLeft";
	public static inline var CAROUSSEL_ARROW_RIGHT:String = "Button_ArrowRight";
	public static inline var CAROUSSEL_ARROW_PAGE_NUMBER:String = "_navigArrows_counter_txt";
	
	// Shop caroussel card
	public static inline var CAROUSSEL_CARD_UNLOCKED:String = "ButtonBuyBuildingDeco";
	public static inline var CAROUSSEL_CARD_UNLOCKED_BTN_INFO:String = "ButtonInfo";
	public static inline var CAROUSSEL_CARD_LOCKED:String = SHOP_PREFIX + "BuildingDeco_LockedItem";
	public static inline var CAROUSSEL_CARD_BUNDLE:String = "ButtonBundle";
	public static inline var CAROUSSEL_CARD_PACK_CURRENCY:String = "ButtonBuyPack";
	public static inline var CAROUSSEL_CARD_PACK_CURRENCY_VIDEO:String = "ButtonBuyPack_Video";
	public static inline var CAROUSSEL_CARD_PACK_RESOURCE:String = "ButtonBuyPack_Ressource";
	public static inline var CAROUSSEL_CARD_BTN_INFO:String = "ButtonInfo";
	
	// Shop caroussel card building unlock and locked
	public static inline var CARD_BACKGROUND_NEUTRAL_CONTAINER:String = "Bg";
	public static inline var CARD_BACKGROUND_HEAVEN_UP:String = "_itemunlockedHEAVEN_bg";
	public static inline var CARD_BACKGROUND_HEAVEN_DOWN:String = "_itemunlockedHEAVEN_down_bg";
	public static inline var CARD_BACKGROUND_HELL_UP:String = "_itemunlockedHELL_bg";
	public static inline var CARD_BACKGROUND_HELL_DOWN:String = "_itemunlockedHELL_down_bg";
	
	// Shop caroussel card building/deco
	public static inline var CARD_BUILDING_PICTURE:String = "Item_picture";
	public static inline var CARD_BUILDING_NAME:String = "Item_Name";
	public static inline var CARD_BUILDING_PRICE_SOFT_HARD:String = "Item_CurrencyPrice";
	public static inline var CARD_BUILDING_PRICE_WOOD:String = "Item_ResourcePrice";
	public static inline var CARD_BUILDING_PRICE_IRON:String = "Item_ResourcePrice2";
	public static inline var CARD_BUILDING_ICON_SOFT_HARD:String = "Currency_icon";
	public static inline var CARD_BUILDING_ICON_WOOD:String = "Resource_icon";
	public static inline var CARD_BUILDING_ICON_IRON:String = "Resource_icon2";
	
	// Shop caroussel card pack
	public static inline var CARD_PACK_PRICE:String ="Pack_Price";
	public static inline var CARD_PACK_ICON_GAIN:String ="Pack_Content_Icon";
	public static inline var CARD_PACK_ICON_PRICE:String ="Pack_Price_Icon";
	public static inline var CARD_PACK_GAIN:String ="Pack_Content_txt";
	public static inline var CARD_PACK_PICTURE:String = "Pack_Picture";
		//// Question : faire une boucle plutôt que de répéter le nombre de 1 à 5 ? un risque avec les GD !
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
	public static inline var CAROUSSEL_INTERN_BTN_REROLL_TXT:String = "Txt";
	public static inline var CAROUSSEL_INTERN_HELL_CARD:String = "Intern_HellCard";
	public static inline var CAROUSSEL_INTERN_HEAVEN_CARD:String = "Intern_HeavenCard";
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER:String = "InternHouseNumber";
	public static inline var CAROUSSEL_INTERN_HOUSE_TEXT:String = "_internHouseNumber_text";
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER_HEAVEN:String = "_internHouseNumber";	
	public static inline var CAROUSSEL_INTERN_HOUSE_NUMBER_HELL:String = "_internHouseNumber_actualValue";	
	public static inline var CAROUSSEL_INTERN_HEAVEN_PRICE:String = "_internPrice_heaven_txt";
	public static inline var CAROUSSEL_INTERN_HELL_PRICE:String = "_internPrice_hell_txt";
	
	public static inline var CAROUSSEL_PORTAL_CARD_HELL:String = "_internHouseNumber_HellBG";
	public static inline var CAROUSSEL_PORTAL_CARD_HEAVEN:String = "_internHouseNumber_HeavenBG";
	public static inline var CAROUSSEL_NO_PORTAL_HEAVEN_IMG:String = "_internShop_portal_heaven";
	public static inline var CAROUSSEL_NO_PORTAL_HELL_IMG:String = "_internShop_noPortal_hell";
	public static inline var CAROUSSEL_NO_PORTAL_HEAVEN_TXT:String = "_internSHop_noPortal_text_heaven";
	public static inline var CAROUSSEL_NO_PORTAL_HELL_TXT:String = "_internSHop_noPortal_text_hell";
	
	// Shop Reroll
	public static inline var REROLL_GAUGE:String = "JaugeTimer";
	public static inline var REROLL_GAUGE_TITLE:String = "_searchingInterns_text";
	public static inline var REROLL_ACCELERATE_BUTTON:String = "Accelerate_button";
	public static inline var REROLL_GAUGE_BAR:String = "Bar";
	public static inline var REROLL_GAUGE_TEXT:String = "txt";
	public static inline var REROLL_GAUGE_MASK:String = "_jauge_searchingMasque";
	
	//Shop caroussel Interns cards
	public static inline var CARD_NAME:String = "_internPortrait_Name";
	public static inline var CARD_PORTRAIT:String = "_intern_portrait";
	public static inline var CARD_GAUGE_EFFICIENCY:String = "_internCard_jauge_efficiency";
	public static inline var CARD_GAUGE_SPEED:String = "_internCard_jauge_speed";
	public static inline var CARD_GAUGE_STRESS:String = "_internCard_jauge_stress";
	
	// Popin Confirm Buy Building
	public static inline var POPIN_CONFIRM_BUY_BUILDING:String = "Popin_ConfirmationBuyHouse";
	public static inline var PCBB_IMG:String = "Building_Image";
	public static inline var PCBB_TEXT_NAME:String = "Building_Name";
	public static inline var PCBB_INFO_POPULATION:String = "Window_Infos_Population";
	public static inline var PCBB_BTN_BUY:String = "BuyButton";
	public static inline var PCBB_BTN_CLOSE:String = "ButtonClose";
	
	// Popin Confirm Buy Building infos population
	public static inline var PCBB_POPULATION_ICON_SOUL:String = "Soul_Icon";
	public static inline var PCBB_POPULATION_TXT_MAX:String = "Window_Infos_txtPopulation";
	
	// Popin Confirm Buy Building btn buy
	public static inline var PCBB_BTN_BUY_TXT:String = "Value";
	public static inline var PCBB_BTN_BUY_ICON:String = "CurrencyIcon";
	
	
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
	public static inline var INTERN_OUT_SEND_COST:String = "sendCost ";
	public static inline var INTERN_OUT_IN_QUEST_CONTAINER:String = "InternInQuest_Value";
	public static inline var INTERN_OUT_ACTUAL_INTERNS_IN_QUEST:String = "_internsInQuest_value";
	
	//inter event popin
	public static inline var GLOBAL_INTERN_STATS:String = "InternStats";
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
	public static inline var INTERN_EVENT_PORTRAIT:String = "_event_internPortrait";	
	public static inline var INTERN_EVENT_STRESS:String = "_interns_stress";	
	public static inline var INTERN_EVENT_HELL_STRESS:String = "_hellStressEffect";
	public static inline var INTERN_EVENT_HEAVEN_STRESS:String = "_heavenStressEffect";
	public static inline var INTERN_EVENT_HELL_CURRENCY:String = "RewardHell0";
	public static inline var INTERN_EVENT_HEAVEN_CURRENCY:String = "RewardHeaven0";
	public static inline var INTENSITY_MARKER:String = "IntensityMarker";
	public static inline var REWARD_CURRENCY_INDICATOR_SPAWNER:String = "RessourceIndicator";
	public static inline var REWARD_CURRENCY_VALUE_SPAWNER:String = "Event_RessourcesReward";
	
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
	public static inline var INTERN_POPIN_SEE_ALL:String = "Button";
	public static inline var INTERN_POPIN_CANCEL:String = "ButtonCancel";
	
	
	//Server Popin
	public static inline var POPIN_SERVER:String = "ConnectionIssue";
	
	//Gatcha popin
	public static inline var GATCHA_POPIN:String = "PopinGatcha";
	public static inline var GATCHA_POPIN_TITLE:String = "_popinGatcha_text";
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
	//public static inline var MAXSTRESS_POPIN_RESET_TEXT:String = "Text";
	public static inline var MAXSTRESS_POPIN_RESET_TEXT:String = "Value";
	public static inline var MAXSTRESS_POPIN_INTERN_PORTRAIT:String = "_internPortrait";
	public static inline var MAXSTRESS_POPIN_INTERN_NAME:String = "_intern_name";
	public static inline var MAXSTRESS_POPIN_INTERN_SIDE:String = "_intern_side";
	public static inline var MAXSTRESS_POPIN_INTERN_STATS:String = "InternStats";
	
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
	public static inline var PURGATORY_POPIN_CARD:String = "_purgatory_fate_card";
	public static inline var PURGATORY_POPIN_HEAVEN_BUTTON:String = "HeavenButton";
	public static inline var PURGATORY_POPIN_INVITE_BUTTON:String = "InviteButton";
	public static inline var PURGATORY_POPIN_HELL_BUTTON:String = "HellButton";
	public static inline var PURGATORY_POPIN_LEVEL:String = "BuildingLevel";
	public static inline var PURGATORY_POPIN_TIMER_CONTAINER:String = "UpgradeTimer";
	public static inline var PURGATORY_POPIN_TIMER:String = "TimeInfo";
	public static inline var PURGATORY_POPIN_SOUL_CARD:String = "SoulCard";
	public static inline var PURGATORY_POPIN_SOUL_INFO:String = "_fateTitle";
	public static inline var PURGATORY_POPIN_SOUL_INFO_FR:String = "_fateTitle_FR";
	public static inline var PURGATORY_POPIN_SOUL_NAME:String = "Name";
	public static inline var PURGATORY_POPIN_SOUL_ADJ:String = "Adjective";
	public static inline var PURGATORY_POPIN_HEAVEN_INFO:String = "HeavenINfo";
	public static inline var PURGATORY_POPIN_HELL_INFO:String = "HellInfo";
	public static inline var PURGATORY_POPIN_INFO_BAR:String = "bar_txt";
	public static inline var PURGATORY_POPIN_ALL_SOULS_INFO:String = "SoulCounter";
	public static inline var PURGATORY_POPIN_ALL_SOULS_NUMBER:String = "Value";
	public static inline var PURGATORY_POPIN_UPGRADE:String = "ButtonUpgrade";
	public static inline var PURGATORY_POPIN_UPGRADE_PRICE_SOFT:String = "_Upgrade_goldCost";
	public static inline var PURGATORY_POPIN_UPGRADE_PRICE_WOOD:String = "_Upgrade_woodCost";
	public static inline var PURGATORY_POPIN_UPGRADE_PRICE_STONE:String = "_Upgrade_stoneCost";
	//cards
	public static inline var PURGATORY_CARD_EVIL_GIRL_1:String = "_arrivingSoul_evil_1";
	public static inline var PURGATORY_CARD_EVIL_GIRL_2:String = "_arrivingSoul_evil_2";
	public static inline var PURGATORY_CARD_EVIL_GIRL_3:String = "_arrivingSoul_evil_3";
	public static inline var PURGATORY_CARD_EVIL_BOY_1:String = "_arrivingSoul_evil_4";
	public static inline var PURGATORY_CARD_EVIL_BOY_2:String = "_arrivingSoul_evil_5";
	public static inline var PURGATORY_CARD_EVIL_BOY_3:String = "_arrivingSoul_evil_6";
	public static inline var PURGATORY_CARD_GOOD_GIRL_1:String = "_arrivingSoul_good_1";
	public static inline var PURGATORY_CARD_GOOD_GIRL_2:String = "_arrivingSoul_good_2";
	public static inline var PURGATORY_CARD_GOOD_GIRL_3:String = "_arrivingSoul_good_3";
	public static inline var PURGATORY_CARD_GOOD_BOY_1:String = "_arrivingSoul_good_4";
	public static inline var PURGATORY_CARD_GOOD_BOY_2:String = "_arrivingSoul_good_5";
	public static inline var PURGATORY_CARD_GOOD_BOY_3:String = "_arrivingSoul_good_6";
	
	//Ftue
	public static inline var FTUE:String = "Window_FTUE";
	public static inline var FTUE_SCENARIO:String = "Window_NPC";
	public static inline var FTUE_SCENARIO_WINDOW:String = "Window_Ftue_Scenario";
	public static inline var FTUE_SCENARIO_WINDOW_HEAVEN:String = "Window_Ftue_Angel_Scenario";
	public static inline var FTUE_SCENARIO_WINDOW_HELL:String = "Window_Ftue_Demon_Scenario";
	public static inline var FTUE_ACTION:String = "Window_Ftue_Action";
	public static inline var FTUE_ACTION_HELL:String = "Window_Ftue_Demon_Action";
	public static inline var FTUE_ACTION_HEAVEN:String = "Window_Ftue_Angel_Action";
	public static inline var FTUE_SCENARIO_BUTTON:String = "ButtonNext";
	public static inline var FTUE_SCENARIO_BUTTON_END:String = "ButtonEndDialog";
	public static inline var FTUE_SCENARIO_HELL:String = "Window_NPC_Hell";
	//public static inline var FTUE_ACTION_HELL:String = "_ftue_mascot_demona";
	public static inline var FTUE_SCENARIO_HEAVEN:String = "Window_NPC_Heaven";
	//public static inline var FTUE_ACTION_HEAVEN:String = "_ftue_mascot_angela";
	public static inline var FTUE_SCENARIO_NAME:String = FTUE_SCENARIO+"_Name_TXT";
	public static inline var FTUE_SCENARIO_SPEACH:String = "_ftue_txt";
	public static inline var FTUE_SCENARIO_SPEACH_SCENARIO:String = "_ftue_txt_scenario";
	public static inline var FTUE_SCENARIO_SPEACH_ACTION:String = "_ftue_txt_action";
	public static inline var FTUE_ACTION_SPEACH:String = "_infobulle_text";
	//FTUE HAND ICON
	public static inline var FTUE_DRAG:String = "Ftue_DragHand";
	public static inline var FTUE_DRAG_MOVE:String = "Ftue_DragHandPurgatory";
	//FtueIcons
	public static inline var FTUE_ICONS:String = "IconHolder_Main";
	public static inline var FTUE_ICON_5:String = "_ftue_dialogFR_5";
	public static inline var FTUE_ICON_6:String = "_ftue_dialogFR_6";
	public static inline var FTUE_ICON_11:String = "_ftue_dialogFR_11";
	public static inline var FTUE_ICON_12:String = "_ftue_dialogFR_12";
	public static inline var FTUE_ICON_13:String = "_ftue_dialogFR_13";
	public static inline var FTUE_ICON_15:String = "_ftue_dialogFR_15";
	public static inline var FTUE_ICON_17:String = "_ftue_dialogFR_17";
	public static inline var FTUE_ICON_18:String = "_ftue_dialogFR_18";
	public static inline var FTUE_ICON_20:String = "_ftue_dialogFR_20";
	public static inline var FTUE_ICON_22:String = "_ftue_dialogFR_22";
	public static inline var FTUE_ICON_24:String = "_ftue_dialogFR_24";
	public static inline var FTUE_ICON_25:String = "_ftue_dialogFR_25";
	public static inline var FTUE_ICON_34:String = "_ftue_dialogFR_34";
	public static inline var FTUE_ICON_38:String = "_ftue_dialogFR_38";
	public static inline var FTUE_ICON_39:String = "_ftue_dialogFR_39";
	public static inline var FTUE_ICON_40:String = "_ftue_dialogFR_40";
	public static inline var FTUE_ICON_44:String = "_ftue_dialogFR_44";
	public static inline var FTUE_ICON_45:String = "_ftue_dialogFR_45";
	public static inline var FTUE_ICON_49:String = "_ftue_dialogFR_49";
	public static inline var FTUE_ICON_52:String = "_ftue_dialogFR_52";
	public static inline var FTUE_ICON_54:String = "_ftue_dialogFR_54";
	
	public static inline var FTUE_ICON_EN_5:String = "_ftue_dialogEN_5";
	public static inline var FTUE_ICON_EN_6:String = "_ftue_dialogEN_6";
	public static inline var FTUE_ICON_EN_11:String = "_ftue_dialogEN_11";
	public static inline var FTUE_ICON_EN_12:String = "_ftue_dialogEN_12";
	public static inline var FTUE_ICON_EN_13:String = "_ftue_dialogEN_13";
	public static inline var FTUE_ICON_EN_15:String = "_ftue_dialogEN_15";
	public static inline var FTUE_ICON_EN_17:String = "_ftue_dialogEN_17";
	public static inline var FTUE_ICON_EN_18:String = "_ftue_dialogEN_18";
	public static inline var FTUE_ICON_EN_20:String = "_ftue_dialogEN_20";
	public static inline var FTUE_ICON_EN_22:String = "_ftue_dialogEN_22";
	public static inline var FTUE_ICON_EN_24:String = "_ftue_dialogEN_24";
	public static inline var FTUE_ICON_EN_25:String = "_ftue_dialogEN_25";
	public static inline var FTUE_ICON_EN_34:String = "_ftue_dialogEN_34";
	public static inline var FTUE_ICON_EN_38:String = "_ftue_dialogEN_38";
	public static inline var FTUE_ICON_EN_39:String = "_ftue_dialogEN_39";
	public static inline var FTUE_ICON_EN_40:String = "_ftue_dialogEN_40";
	public static inline var FTUE_ICON_EN_44:String = "_ftue_dialogEN_44";
	public static inline var FTUE_ICON_EN_45:String = "_ftue_dialogEN_45";
	public static inline var FTUE_ICON_EN_49:String = "_ftue_dialogEN_49";
	public static inline var FTUE_ICON_EN_52:String = "_ftue_dialogEN_52";
	public static inline var FTUE_ICON_EN_54:String = "_ftue_dialogEN_54";
	
	
	// HUD
	public static inline var HUD_PREFIX:String = "HUD_";
	public static inline var HUD_BTN_RESET_DATA:String = "ALPHA_ResetData";
	public static inline var HUD_BTN_SHOP:String = "ButtonShop_HUD";
	public static inline var HUD_BTN_PURGATORY:String = HUD_PREFIX + "PurgatoryButton";
	public static inline var HUD_CONTAINER_BTN_INTERNS:String = HUD_PREFIX + "InternsButton";
	public static inline var HUD_BTN_INTERNS:String = HUD_PREFIX + "InternsButton";
	public static inline var HUD_BTN_INTERNS_LOCK:String = "HUD_internsLockedMC";
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
	public static inline var HUD_XP_GAUGE_MASK_HEAVEN_CONTAINER:String = "HUD_Xp_Bar_Heaven";
	public static inline var HUD_XP_GAUGE_MASK_HELL_CONTAINER:String = "HUD_Xp_Bar_Hell";
	public static inline var HUD_XP_GAUGE_GLOW:String = "ftueGlow";
	public static inline var HUD_MISSION_DECO:String = "MissionIndicator";
	public static inline var HUD_MISSION_DECO_TEXT:String = "_missionObjectiveCounter";
	
	
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
	
	//confirmation accelerate popin
	public static inline var CONFIRMATION_ACCELERATE_POPIN:String = "Popin_SkipTime";
	public static inline var CONFIRMATION_ACCELERATE_POPIN_TEXT_ACTION:String = "Verb";
	public static inline var CONFIRMATION_ACCELERATE_POPIN_GAUGE:String = "Timebased Gauge";
	public static inline var CONFIRMATION_ACCELERATE_POPIN_BTN:String = "Button_SkipTimeConfirm";
	
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
	
	//DailyRewardPopin
	public static inline var DAILYREWARDS_POPPIN:String = "Popin_DailyRewards";
	public static inline var DAILYREWARD_POPIN_CLOSE:String = "ButtonClose";
	public static inline var DAILYREWARD_POPIN_GAIN_BUTTON:String = "ButtonDaily";
	public static inline var DAILYREWARD_POPIN_GAIN_BUTTON_TEXT:String = "Layer 1";
	public static inline var DAILYREWARD_POPIN_WOOD:String = "_dailyReward_value_wood";
	public static inline var DAILYREWARD_POPIN_IRON:String = "_dailyReward_value_iron";
	public static inline var DAILYREWARD_POPIN_GOLD:String = "_dailyReward_value_gold";
	public static inline var DAILYREWARD_POPIN_KARMA:String = "_dailyReward_value_karma";
	public static inline var DAILYREWARD_POPIN_DAY_BG_SMALL:String = "_dayBG_small";
	public static inline var DAILYREWARD_POPIN_DAY:String = "Day";
	public static inline var DAILYREWARD_POPIN_CURRENT:String = "Current";
	public static inline var DAILYREWARD_POPIN_DAY_SMALL:String = "_Day";
	public static inline var DAILYREWARD_POPIN_TEXT_SMALL:String = "Small_txt";
	public static inline var DAILYREWARD_POPIN_TEXT:String = "_getRewards_txt";
	public static inline var DAILYREWARD_POPIN_TEXT_DAY:String = "_firstDay_txt";
	public static inline var DAILYREWARD_POPIN_TEXT_DAY_LABEL:String = "LABEL_DAILYREWARDS_DAY_";
	
	
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
	
	public static inline var BACKGROUND_UNDER:String = "BG_Galaxy";
	
	//button production assets
	
	public static inline var PROD_ICON_SOFT:String = "_goldIcon__Large_Prod";
	public static inline var PROD_ICON_SOFT_ANIM:String = "GoldPickup_Anim";
	public static inline var PROD_ICON_HARD:String = "_hardCurrencyIcon_Large";
	public static inline var PROD_ICON_WOOD:String = "_woodIcon_Large";
	public static inline var PROD_ICON_STONE:String = "_stoneIcon_Large";
	public static inline var PROD_ICON_GOLD_LARGE:String = "_goldIcon_Large";
	
	//icone small
	public static inline var PROD_ICON_SOFT_SMALL:String = "_goldIcon_Small";
	public static inline var PROD_ICON_HARD_SMALL:String = "_hardCurrencyIcon_Small";
	public static inline var PROD_ICON_WOOD_SMALL:String = "_woodIcon_Small";
	public static inline var PROD_ICON_STONE_SMALL:String = "_stoneIcon_Small";
	public static inline var PROD_ICON_SOUL_HEAVEN_SMALL:String = "_heavenSoulIcon_Small";
	public static inline var PROD_ICON_SOUL_HELL_SMALL:String = "_hellSoulIcon_Small";
	
	//icone large
	public static inline var PROD_ICON_WOOD_LARGE:String = "_woodIcon_Large";
	public static inline var PROD_ICON_STONE_LARGE:String = "_stoneIcon_Large";
	public static inline var PROD_ICON_NEUTRAL_SOUL_LARGE:String = "_neutralSoulIcon_Large";
	public static inline var PROD_ICON_GENERIC_LARGE:String = "_genericIcon_Large";
	
	//icone medium
	public static inline var ICON_GOLD_MEDIUM:String = "_goldIcon_Medium";
	public static inline var ICON_HARD_MEDIUM:String = "_hardCurrencyIcon_Medium";
	public static inline var ICON_WOOD_MEDIUM:String = "_woodIcon_Medium";
	public static inline var ICON_STONE_MEDIUM:String = "_stoneIcon_Medium";
	public static inline var ICON_SOUL_MEDIUM:String = "_neutralSoulIcon_Medium";
	
	//Option Poppin
	public static inline var OPTION_POPPIN:String = "Options_Popin";
	public static inline var OPTION_POPPIN_CLOSE:String = "ButtonClose";
	public static inline var OPTION_POPPIN_RESETDATA:String = "ButtonDataReset";
	public static inline var OPTION_POPPIN_SFX:String = "ButtonSFXGroup";
	public static inline var OPTION_POPPIN_SFX_ON:String = "_buttonSFX_on_txt";
	public static inline var OPTION_POPPIN_MUSIC:String = "ButtonMusicGroup";
	public static inline var OPTION_POPPIN_FR:String = "ButtonFrench";
	public static inline var OPTION_POPPIN_EN:String = "ButtonEnglish";
	public static inline var OPTION_CREDITS:String = "ButtonCredits";
	public static inline var OPTION_POPPIN_LANGUAGE_TEXT:String = "_languageChoice_text";
	public static inline var OPTION_POPPIN_DATAS_TEXT:String = "_dataOptions_text";
	public static inline var OPTION_POPPIN_SOUND_TEXT:String = "_soundOptions_text";
	public static inline var OPTION_POPPIN_DATAS_BTN_TEXT:String = "_dataReset_button_txt";
	//public static inline var OPTION_POPPIN_SOUND_TEXT:String = "_soundOptions_text";
	
	//ResetPoppin
	public static inline var RESET_POPPIN:String = "ConfirmDataReset_Popin";
	public static inline var RESET_POPPIN_CONFIRM:String = "ButtonConfirmErase";
	public static inline var RESET_POPPIN_CANCEL:String = "ButtonCancelErase";
	public static inline var RESET_POPPIN_TEXT:String = "_confirmDataReset_txt";
	public static inline var RESET_POPPIN_CANCEL_TEXT:String = "_buttonCancelErase_text";
	public static inline var RESET_POPPIN_CONFIRM_TEXT:String = "_buttonConfirmErase_text";
	
	//OnlaunchPoppin
	public static inline var ONLAUNCH_POPPIN:String = "OnLaunchPopin";
	public static inline var ONLAUNCH_POPPIN_CONTINUE:String = "ButtonContinueGame";
	public static inline var ONLAUNCH_POPPIN_CLOSE:String = "ButtonClose";
	public static inline var ONLAUNCH_POPPIN_CANIMPERIUM:String = "ButtonCanimperium";
	public static inline var ONLAUNCH_POPPIN_DEPTHS:String = "ButtonDepths";
	public static inline var ONLAUNCH_POPPIN_YELDIZ:String = "ButtonYeldiz";
	public static inline var ONLAUNCH_POPPIN_MONSTERHAVEN:String = "ButtonMonsterHaven";
	public static inline var ONLAUNCH_POPPIN_BLOOMINGSKY:String = "ButtonBloomingSky";
	public static inline var ONLAUNCH_POPPIN_ISART:String = "ButtonLogoIsart";
	public static inline var ONLAUNCH_POPPIN_TEXT1:String = "_onLaunch_txt1";
	public static inline var ONLAUNCH_POPPIN_TEXT2:String = "_onLaunch_txt2";
	public static inline var ONLAUNCH_POPPIN_TEXT_BUTTON_CONTINUE:String = "Layer 2";
	
	//IsartPoints Poppin
	public static inline var ISARTPOINTS_POPPIN:String = "IsartPointsInfo";
	public static inline var ISARTPOINTS_POPPIN_CLOSE:String = "ButtonClose";
	public static inline var ISARTPOINTS_POPPIN_CONTINUE:String = "ButtonOkIpInfo";
	public static inline var ISARTPOINTS_POPPIN_REMAININGIP:String = "_remainingIP";
	
	public static function getCurrencyAssetName(reward:RewardType):String {
		if (reward == RewardType.gold) return ICON_GOLD_MEDIUM;
		if (reward == RewardType.karma) return ICON_HARD_MEDIUM;
		if (reward == RewardType.wood) return ICON_WOOD_MEDIUM;
		if (reward == RewardType.iron) return ICON_STONE_MEDIUM;
		if (reward == RewardType.soul) return ICON_SOUL_MEDIUM;
		return "noName";
	}
}