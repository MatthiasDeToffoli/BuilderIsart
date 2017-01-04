package com.isartdigital.perle.game;


/**
 * Constant for assetName, assetName can be wrong named
 * but not our constant ! ;)
 * @author ambroise
 */
class AssetName{

	// Building
	public static inline var HOUSE_HELL:String = "House";
	public static inline var HOUSE_HEAVEN:String = "House";
	
	// Confirm
	public static inline var POPIN_CONFIRM_BUY_BUILDING:String = "Popin_ConfirmationBuyHouse";
	public static inline var POPIN_CONFIRM_BUY_CURRENCIE:String = "Popin_ConfirmBuyEuro";
	
	// Game
	public static inline var BTN_PRODUCTION:String = "GoldProduction";
	
	// Shop
	public static inline var SHOP_PREFIX:String = "Shop_";
	public static inline var POPIN_SHOP:String = SHOP_PREFIX + "Building";
	public static inline var SHOP_BTN_ITEM_UNLOCKED:String = SHOP_PREFIX + "Item_Unlocked";
	public static inline var SHOP_BTN_CLOSE:String = SHOP_PREFIX +  "Close_Button";
	public static inline var SHOP_BTN_PURGATORY:String = /*SHOP_PREFIX +*/ "Purgatory_Button";
	public static inline var SHOP_BTN_INTERNS:String = /*SHOP_PREFIX +*/ "Interns_Button";
	public static inline var SHOP_BTN_TAB_BUILDING:String = /*SHOP_PREFIX +*/ "Onglet_Building";
	public static inline var SHOP_BTN_TAB_DECO:String = /*SHOP_PREFIX +*/ "Onglet_Deco";
	public static inline var SHOP_BTN_TAB_INTERN:String = /*SHOP_PREFIX +*/ "Onglet_Interns";
	public static inline var SHOP_BTN_TAB_RESOURCE:String = /*SHOP_PREFIX +*/ "Onglet_Ressources";
	public static inline var SHOP_BTN_TAB_CURRENCIE:String = /*SHOP_PREFIX +*/ "Onglet_Currencies";
	
	// Shop caroussel
	public static inline var SHOP_CAROUSSEL:String = SHOP_PREFIX + "Item_List";
	
	// Info building
	public static inline var POPIN_INFO_BUILDING:String = "Fenetre_InfoMaison";
	public static inline var INFO_BUILDING_BTN_CLOSE:String = "CloseButton";
	public static inline var INFO_BUILDING_BTN_SELL:String = "SellButton";
	
	//listIntern
	public static inline var INTERN_LIST:String = "ListInterns";
	public static inline var INTERN_LIST_CANCEL:String = "ButtonCancel";
	public static inline var INTERN_LIST_LEFT:String = "_arrow_left";
	public static inline var INTERN_LIST_RIGHT:String = "_arrow_right";
	public static inline var INTERN_LIST_SPAWNER0:String = "Intern01";
	public static inline var INTERN_LIST_SPAWNER1:String = "Intern02";
	public static inline var INTERN_LIST_SPAWNER2:String = "Intern03";
	
	//in quest
	public static inline var INTERN_INFO_IN_QUEST:String = "ListInQuest";
	public static inline var BUTTON_ACCELERATE_IN_QUEST:String = "Bouton_InternSend_Clip";
	public static inline var INTERN_NAME_IN_QUEST:String = "InQuest_name";
	public static inline var TIME_IN_QUEST:String = "InQuest_time";
	public static inline var PORTRAIT_IN_QUEST:String = "InQuest_Portrait";
	
	//out quest
	public static inline var INTERN_INFO_OUT_QUEST:String = "ListOutQuest";
	public static inline var BUTTON_SEND_OUT_QUEST:String = "Bouton_SendIntern_List";
	public static inline var INTERN_NAME_OUT_QUEST:String = "_intern03_name05";
	public static inline var PORTRAIT_OUT_QUEST:String = "OutQuest_Portrait";
	
	//inter event popin
	public static inline var INTERN_EVENT:String = "Intern_Event";
	public static inline var INTERN_EVENT_DESC:String = "_event_description";
	public static inline var INTERN_EVENT_HEAVEN_CHOICE:String = "_heavenChoice_text";
	public static inline var INTERN_EVENT_HELL_CHOICE:String = "_hellChoice_text";
	public static inline var INTERN_EVENT_SEE_ALL:String = "ButtonInterns";
	public static inline var INTERN_EVENT_DISMISS:String = "BoutonDismissIntern";
	public static inline var INTERN_EVENT_SHARE:String = "Button_Friends";
	public static inline var INTERN_EVENT_CLOSE:String = "CloseButton";
	public static inline var INTERN_EVENT_CARD:String = "_event_FateCard";
	public static inline var INTERN_EVENT_NAME:String = "_event_internName";
	public static inline var INTERN_EVENT_SIDE:String = "_event_internSide";
	
	//intern popin
	public static inline var INTERN_POPIN:String = "Interns";
	public static inline var INTERN_POPIN_SIDE:String = "_intern_side";
	public static inline var INTERN_POPIN_NAME:String = "_intern_name";
	public static inline var INTERN_POPIN_SEE_ALL_CONTAINER:String = "Bouton_AllInterns_Clip";
	public static inline var INTERN_POPIN_SEE_ALL:String = "Button";
	public static inline var INTERN_POPIN_CANCEL:String = "ButtonCancel";
	
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
	public static inline var PURGATORY_POPIN_UPGRADE:String = "UpgradeButton";
	public static inline var PURGATORY_POPIN_UPGRADE_PRICE:String = "Cost";
	
	//Ftue
	public static inline var FTUE:String = "Window_NPC";
	public static inline var FTUE_BUTTON:String = FTUE+"_ButtonNext";
	public static inline var FTUE_HELL:String = FTUE+"_Hell";
	public static inline var FTUE_HEAVEN:String = FTUE+"_Heaven";
	public static inline var FTUE_NAME:String = FTUE+"_Name_TXT";
	public static inline var FTUE_SPEACH:String = FTUE+"_Speech_TXT";
	
	// HUD
	public static inline var HUD_PREFIX:String = "HUD_";
	public static inline var HUD_BTN_SHOP:String = HUD_PREFIX + "ShopButton";
	public static inline var HUD_BTN_PURGATORY:String = HUD_PREFIX + "PurgatoryButton";
	public static inline var HUD_CONTAINER_BTN_INTERNS:String = HUD_PREFIX + "InternsButton";
	public static inline var HUD_BTN_INTERNS:String = /*HUD_PREFIX + */"internsButton";
	public static inline var HUD_COUNTER_SOFT:String = HUD_PREFIX + "SoftCurrency";
	public static inline var HUD_COUNTER_HARD:String = HUD_PREFIX + "HardCurrency";
	public static inline var HUD_COUNTER_MATERIAL_HEAVEN:String = HUD_PREFIX + "MarbleCounter";
	public static inline var HUD_COUNTER_MATERIAL_HELL:String = HUD_PREFIX + "WoodCounter";
	public static inline var HUD_COUNTER_XP_HEAVEN:String = HUD_PREFIX + "HeavenXP";
	public static inline var HUD_COUNTER_XP_HELL:String = HUD_PREFIX + "HellXP";
	public static inline var HUD_COUNTER_LEVEL:String = HUD_PREFIX + "Level";
	
	public static inline var COUNTER_TXT_XP:String = "Hud_xp_txt";
	public static inline var COUNTER_TXT_RESSOURCE:String = "bar_txt";
	public static inline var COUNTER_TXT_LEVEL:String = "_level_txt";
	
	
	// add background and any other assetName coming from DA
	//bg
	public static inline var BACKGROUND_HELL:String = "Region_Enfer_Principal";
	public static inline var BACKGROUND_HEAVEN:String = "Region_Paradis_Principal";
	public static inline var BACKGROUND_STYX:String = "Styx_01_Principal";
	
	//building
	public static inline var PURGATORY:String = "Bat_Purgatory_colo_Principal";
	// i would add any wireframe assetName too here
	// maybe we make another class named WireFrame later.
	
}