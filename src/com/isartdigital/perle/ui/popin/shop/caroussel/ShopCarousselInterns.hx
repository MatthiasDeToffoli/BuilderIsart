package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCaroussel;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * Shop of the interns
 * @author ambroise
 * @author Emeline Berenguier
 */
class ShopCarousselInterns extends ShopCaroussel{

	public static var internsNameList(default, never):Array<String> = [];
		
	private var btnReroll:SmartButton;
	
	//Hell Card
	private var hellCard:SmartButton;
	private var hellPortrait:UISprite;
	private var hellName:TextSprite;
	private var hellGaugeEfficency:SmartComponent;
	private var hellGaugeSpeed:SmartComponent;
	private var hellPrice:TextSprite;
	
	//Heaven Card
	private var heavenCard:SmartButton;
	private var heavenPortrait:UISprite;
	private var heavenName:TextSprite;
	private var heavenGaugeEfficency:SmartComponent;
	private var heavenGaugeSpeed:SmartComponent;
	private var heavenPrice:TextSprite;
	
	//Number of intern houses
	private var houseNumber:SmartComponent;
	private var numberHousesHeaven:TextSprite;
	private var numberHousesHell:TextSprite;
	
	//ID for the interns to show
	public static var actualHeavenID:Int;
	public static var actualHellID:Int;
	private static var usedID:Map<Alignment, Array<Int>> = new Map<Alignment, Array<Int>>();
		
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN);
		getComponents();
		setValues();
		addListeners();
	}

	override public function init (pPos:Point, pTab:ShopTab):Void {
		super.init(pPos, myEnum);
	}
	
	/**
	 * Initialize the interns's ID to 
	 */
	public static function initID ():Void{
		usedID = new Map<Alignment, Array<Int>>();
		usedID[Alignment.heaven] = new Array<Int>();
		usedID[Alignment.hell] = new Array<Int>();
		
		actualHeavenID = 0;
		actualHellID = 0;
		actualHellID = getNewID(Alignment.hell);
		actualHeavenID = getNewID(Alignment.heaven);
	}
	
	public static function getNewID(pAlignment:Alignment):Int {
		var lLength:Int = usedID[pAlignment].length;
		var lID:Int = 0;
		
		if (pAlignment == Alignment.heaven) {
			
			for (i in 0...lLength) {
				if (actualHeavenID == usedID[pAlignment][i]) {
					actualHeavenID++;
					lID = actualHeavenID; 
					return lID;
				}
			}
		}
		
		if (pAlignment == Alignment.hell){
			
			for (i in 0...lLength) {
				if (actualHellID == usedID[pAlignment][i]) {
					actualHellID++;
					lID = actualHellID; 
					return lID;
				}
			}
		}
		
		return lID;
	}
	
	
	private function getComponents():Void{
		btnReroll = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_BTN_REROLL), SmartButton);
		hellCard = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HELL_CARD), SmartButton);
		heavenCard = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HEAVEN_CARD), SmartButton);
		
		houseNumber = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HOUSE_NUMBER), SmartComponent);
		numberHousesHeaven = cast(SmartCheck.getChildByName(houseNumber, AssetName.CAROUSSEL_INTERN_HOUSE_NUMBER_HEAVEN), TextSprite);
		numberHousesHell = cast(SmartCheck.getChildByName(houseNumber, AssetName.CAROUSSEL_INTERN_HOUSE_NUMBER_HELL), TextSprite);
		//numberHouses = cast(SmartCheck.getChildByName(houseNumber, AssetName.CAROUSSEL_INTERN_HOUSE_NUMBER_TEXT), SmartComponent); 
		
		hellPortrait = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_PORTRAIT), UISprite);
		hellName = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_NAME), TextSprite);
		hellGaugeEfficency = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_GAUGE_EFFICIENCY), SmartComponent);
		hellGaugeSpeed = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_GAUGE_SPEED), SmartComponent);
		hellPrice = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HELL_PRICE), TextSprite);
		
		heavenPortrait = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_PORTRAIT), UISprite);
		heavenName = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_NAME), TextSprite);
		heavenGaugeEfficency = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_GAUGE_EFFICIENCY), SmartComponent);
		heavenGaugeSpeed = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_GAUGE_SPEED), SmartComponent);
		heavenPrice = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HEAVEN_PRICE), TextSprite);	
	}
	
	/**
	 * Callback of the hoover button, to rewrite the values of the hell card
	 */
	private function setValuesHellButton():Void{
		hellName = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_NAME), TextSprite);
		hellName.text = Intern.internsMap[Alignment.hell][actualHellID].name;
	}
	
	/**
	 * Callback of the hoover button, to rewrite the values of the heaven card
	 */
	private function setValuesHeavenButton():Void{
		heavenName = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_NAME), TextSprite);
		heavenName.text = Intern.internsMap[Alignment.heaven][actualHeavenID].name;
	}
	
	private function initStars(pIntern:InternDescription, lEfficiency:SmartComponent, lSpeed:SmartComponent):Void {
		var speedIndics:Array<UISprite> = new Array<UISprite>();
		var effIndics:Array<UISprite> = new Array<UISprite>();
		
		for (i in 1...6) {
			speedIndics.push(cast(lSpeed.getChildByName("_jaugeSpeed_0" + i), UISprite));
			effIndics.push(cast(lEfficiency.getChildByName("_jaugeEfficiency_0" + i), UISprite));
		}
		
		for (i in 0...5) {
			if (pIntern.efficiency <= i) speedIndics[i].visible = false;
		}
		
		for (i in 0...5) {
			if (pIntern.speed <= i) effIndics[i].visible = false;
		}
	}
	
	/**
	 * Function to show the card's state (if you can buy or not) or the correct intern informations in the card
	 */
	private function setValues():Void{
		heavenCard.alpha = 1;
		heavenCard.buttonMode = true;
		heavenCard.interactive = true;
		
		hellCard.alpha = 1;
		hellCard.buttonMode = true;
		hellCard.interactive = true;
		
		if (Intern.internsMap[Alignment.heaven][actualHeavenID] != null) {
			heavenName.text = Intern.internsMap[Alignment.heaven][actualHeavenID].name;
			heavenPrice.text = Intern.internsMap[Alignment.heaven][actualHeavenID].price + "";
			
			setValuesStats(Intern.internsMap[Alignment.heaven][actualHeavenID]);
			
			if (!Intern.canBuy(Alignment.heaven, Intern.internsMap[Alignment.heaven][actualHeavenID])){
				heavenCard.buttonMode = false;
				heavenCard.interactive = false;
				heavenCard.alpha = 0.5;
			}
		}
		
		else {
			heavenName.text = "No more heaven intern!";
			heavenCard.buttonMode = false;
			heavenCard.interactive = false;
			heavenCard.alpha = 0.5;
		}
		
		if (Intern.internsMap[Alignment.hell][actualHellID] != null) {
			hellName.text = Intern.internsMap[Alignment.hell][actualHellID].name;
			hellPrice.text = Intern.internsMap[Alignment.hell][actualHellID].price + "";
			
			setValuesStats(Intern.internsMap[Alignment.hell][actualHellID]);
			
			if(!DialogueManager.ftueStepBuyIntern)
				if (!Intern.canBuy(Alignment.hell, Intern.internsMap[Alignment.hell][actualHellID])){
					hellCard.buttonMode = false;
					hellCard.interactive = false;
					hellCard.alpha = 0.5;
				}
		}
		
		else{
			hellName.text = "No more hell intern!";
			hellCard.buttonMode = false;
			hellCard.interactive = false;
			hellCard.alpha = 0.5;
		}
		
		setValuesNumberHousesHeaven();
		setValuesNumberHousesHell();
		
	}

	private function setValuesStats(pIntern:InternDescription):Void{
		var iEff:Int =  6 - pIntern.efficiency;
		var iSpeed:Int = 6 - pIntern.speed;
		
		if (pIntern.aligment == "heaven"){
			for (i in 1...iEff) 
				cast(heavenGaugeEfficency.getChildAt(i), UISprite).visible = false;
			
			for (i in 1...iSpeed)
				cast(heavenGaugeSpeed.getChildAt(i), UISprite).visible = false;
		}
		
		else {
			for (i in 1...iEff)
				cast(hellGaugeEfficency.getChildAt(i), UISprite).visible = false;
			
			for (i in 1...iSpeed)
				cast(hellGaugeSpeed.getChildAt(i), UISprite).visible = false;
		}

	}
	
	/**
	 * Set the correct values of the heaven intern house
	 */
	private function setValuesNumberHousesHeaven():Void{
		if (Intern.numberInternHouses[Alignment.heaven] != null && Intern.internsListAlignment[Alignment.heaven] != null){
			numberHousesHeaven.text = Intern.numberInternHouses[Alignment.heaven] - Intern.internsListAlignment[Alignment.heaven].length + "";
		}
		
		else {
			if (Intern.numberInternHouses[Alignment.heaven] == null) numberHousesHeaven.text = 0 + "";
			if (Intern.internsListAlignment[Alignment.heaven] == null) numberHousesHeaven.text = Intern.numberInternHouses[Alignment.heaven] + "";
		}
	}
	
	/**
	 * Set the correct values of the hell intern house
	 */
	private function setValuesNumberHousesHell():Void{
		if (Intern.numberInternHouses[Alignment.hell] != null && Intern.internsListAlignment[Alignment.hell] != null){
			numberHousesHell.text = Intern.numberInternHouses[Alignment.hell] - Intern.internsListAlignment[Alignment.hell].length + "";
		}
		
		else {
			if (Intern.numberInternHouses[Alignment.hell] == null) numberHousesHell.text = 0 + "";
			if (Intern.internsListAlignment[Alignment.hell] == null) numberHousesHell.text = Intern.numberInternHouses[Alignment.hell] + "";
		}
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnReroll, onClickReroll);
		Interactive.addListenerClick(hellCard, onClickHell);
		Interactive.addListenerRewrite(hellCard, setValuesHellButton);
		Interactive.addListenerRewrite(heavenCard, setValuesHeavenButton);
		Interactive.addListenerClick(heavenCard, onClickHeaven);
	}
	
	
	/**
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void {}
	
	override private function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			/*"Shop_Intern_1",
			"Shop_Intern_2",
			"Shop_Intern_3"*/
		];
	}
	
	/**
	 * Callback of the hell card's click. Verification if player can buy or not an intern
	 */
	private function onClickHell():Void{
		//Si achat possible
		if (DialogueManager.ftueStepBuyIntern || Intern.canBuy(Alignment.hell, Intern.internsMap[Alignment.hell][actualHellID])) {
			Intern.buy(Intern.internsMap[Alignment.hell][actualHellID]);
			changeID(Alignment.hell);
			closeShop();
			if (DialogueManager.ftueStepBuyIntern)
				DialogueManager.endOfaDialogue();
		}
	}
	
	/**
	 * Callback of the heaven card's click. Verification if player can buy or not an intern
	 */
	private function onClickHeaven():Void{
		if (Intern.canBuy(Alignment.heaven, Intern.internsMap[Alignment.heaven][actualHeavenID])){
			Intern.buy(Intern.internsMap[Alignment.heaven][actualHeavenID]);
			changeID(Alignment.heaven);
			closeShop();
		}
	}
	
	private function closeShop():Void{
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * System to avoid to have the same intern twice
	 * @param	pAlignment Alignment of the intern
	 */
	public static function changeID(?pAlignment:Alignment = null):Void{
		if (pAlignment != null){
			if (pAlignment == Alignment.heaven){
			usedID[Alignment.heaven].push(actualHeavenID);
			actualHeavenID = getNewID(Alignment.heaven);
			}
		
			if (pAlignment == Alignment.hell){
			usedID[Alignment.hell].push(actualHellID);
			actualHellID = getNewID(Alignment.hell);
			}
		}
		
		else {
			usedID[Alignment.heaven].push(actualHeavenID);
			actualHeavenID = getNewID(Alignment.heaven);
			
			usedID[Alignment.hell].push(actualHellID);
			actualHellID = getNewID(Alignment.hell);
		}
	}
	
	//private function selectIntern(pAlignment:Alignment):InternDescription{
		//var lID:Int;
		//pAlignment == Alignment.hell ? lID = actualHellID : lID = actualHeavenID;
		//return Intern.internsMap[pAlignment][lID];
	//}
	
	/**
	 * Callback of the reroll. Reroll the search
	 */
	private function onClickReroll ():Void {
		ShopCarousselInternsSearch.progress = 0;
		//ShopPopin.isSearching = true;
		ShopPopin.getInstance().init(ShopTab.InternsSearch);
	}
	
	override function getCardToShow():Array<String> {
		return new Array<String>();
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnReroll, onClickReroll);
		Interactive.removeListenerClick(hellCard, onClickHell);
		Interactive.removeListenerClick(heavenCard, onClickHeaven);
		Interactive.removeListenerRewrite(heavenCard, setValuesHeavenButton);
		Interactive.removeListenerRewrite(hellCard, setValuesHellButton);
		super.destroy();
	}
	
}