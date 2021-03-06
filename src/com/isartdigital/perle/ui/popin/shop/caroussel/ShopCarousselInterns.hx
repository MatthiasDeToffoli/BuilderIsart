package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCaroussel;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Shop of the interns
 * @author ambroise
 * @author Emeline Berenguier
 */
class ShopCarousselInterns extends ShopCaroussel{

	public static var internsNameList(default, never):Array<String> = [];
	
	private var btnReroll:SmartButton;
	private var btnRerollTxt:TextSprite;
	
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
	private var heavenNoPlace:SmartComponent;
	
	//Number of intern houses
	private var houseNumber:SmartComponent;
	private var numberHousesHeaven:TextSprite;
	private var numberHousesHell:TextSprite;
	private var houseText:TextSprite;
	private var hellNoPlace:SmartComponent;
	
	//Interns to show
	private static var hellIntern:InternDescription;
	private static var heavenIntern:InternDescription;
	
	//ID for the interns to show
	public static var actualHeavenID:Int;
	public static var actualHellID:Int;
	private static var usedID:Map<Alignment, Array<Int>> = new Map<Alignment, Array<Int>>();
		
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN);
		getComponents();
		chooseRandomIntern();
		addListeners();
		setValues();
		//SmartCheck.traceChildrens(this);
	}

	override public function init (pPos:Point, pTab:ShopTab):Void {
		super.init(pPos, myEnum);
	}
	
	override function destroyArrows():Void {
		return null;
	}
	
	/**
	 * Select 2 random interns depending of the player's level
	 */
	private function chooseRandomIntern():Void{
		if (hellIntern == null) hellIntern = chooseRandomInternHell();
		if (heavenIntern == null) heavenIntern = chooseRandomInternHeaven();
	}
	
	/**
	 * Selection of the random hell intern
	 * @return
	 */
	private static function chooseRandomInternHell():InternDescription{
		var lRandom:Int = Math.round(Math.random() * Intern.internsToUnlockHell[UnlockManager.getLevelUnlockHell()].length) - 1;
		if (lRandom < 0) lRandom = 0;
		var lInternRandomHell:InternDescription = Intern.internsToUnlockHell[UnlockManager.getLevelUnlockHell()][lRandom];
		
		return lInternRandomHell;
	}
	
	/**
	 * Selection of the random heaven intern
	 * @return
	 */
	private static function chooseRandomInternHeaven():InternDescription{
		var lRandom:Int = Math.round(Math.random() * Intern.internsToUnlockHeaven[UnlockManager.getLevelUnlockHeaven()].length) - 1;
		if (lRandom < 0) lRandom = 0;
		var lInternRandomHeaven:InternDescription = Intern.internsToUnlockHeaven[UnlockManager.getLevelUnlockHeaven()][lRandom];
		
		return lInternRandomHeaven;
	}	
	
	private function getComponents():Void{
		btnReroll = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_BTN_REROLL), SmartButton);
		btnRerollTxt = cast(SmartCheck.getChildByName(btnReroll, AssetName.CAROUSSEL_INTERN_BTN_REROLL_TXT), TextSprite);
		
		hellCard = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HELL_CARD), SmartButton);
		heavenCard = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HEAVEN_CARD), SmartButton);
		
		houseNumber = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_HOUSE_NUMBER), SmartComponent);
		
		var cardHouseHell:SmartComponent = cast(houseNumber.getChildByName(AssetName.CAROUSSEL_PORTAL_CARD_HELL), SmartComponent);
		var cardHouseHeaven:SmartComponent = cast(houseNumber.getChildByName(AssetName.CAROUSSEL_PORTAL_CARD_HEAVEN), SmartComponent);
		
		numberHousesHell = cast(cast(cast(SmartCheck.getChildByName(houseNumber, "_internHouseNumber_HellBG"), SmartComponent).getChildAt(0), SmartComponent).getChildByName("_internHouseNumber_actualValue"), TextSprite);
		numberHousesHeaven = cast(cast(cast(SmartCheck.getChildByName(houseNumber, "_internHouseNumber_HeavenBG"), SmartComponent).getChildAt(0), SmartComponent).getChildByName("_internHouseNumber"), TextSprite);
		
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
		hellName.text = hellIntern.name;
		
		hellGaugeEfficency = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_GAUGE_EFFICIENCY), SmartComponent);
		hellGaugeSpeed = cast(SmartCheck.getChildByName(hellCard, AssetName.CARD_GAUGE_SPEED), SmartComponent);
		initStars(hellIntern, hellGaugeEfficency, hellGaugeSpeed);
	}
	
	/**
	 * Callback of the hoover button, to rewrite the values of the heaven card
	 */
	private function setValuesHeavenButton():Void{
		heavenName = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_NAME), TextSprite);
		heavenName.text = heavenIntern.name;
		
		heavenGaugeEfficency = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_GAUGE_EFFICIENCY), SmartComponent);
		heavenGaugeSpeed = cast(SmartCheck.getChildByName(heavenCard, AssetName.CARD_GAUGE_SPEED), SmartComponent);
		initStars(heavenIntern, heavenGaugeEfficency, heavenGaugeSpeed);
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
		
		btnRerollTxt.text = Localisation.getText("LABEL_SHOPINTERN_INTERN_REROLL_BUTTON");
		//houseText.text =  Localisation.allTraductions["LABEL_SHOPINTERN_INTERNHOUSE_NUMBER_TXT"];
		
		setValuesHeavenCard();
		setValuesHellCard();
		
		setValuesNumberHousesHeaven();
		setValuesNumberHousesHell();
		
		if (Intern.numberInternHouses[Alignment.heaven] - Intern.internsListAlignment[Alignment.heaven].length <= 0) {
			cast(getChildByName("_goldIcon_Medium_Heaven"), UISprite).visible = false;
			cast(getChildByName("_internPrice_heaven_txt"), TextSprite).visible = false;
			heavenCard.visible = false;
			heavenPortrait.visible = false;
		}
		
		if ((Intern.numberInternHouses[Alignment.hell] - Intern.internsListAlignment[Alignment.hell].length <= 0) && !DialogueManager.ftueStepBuyIntern) {
			cast(getChildByName("_goldIcon_Medium_Hell"), UISprite).visible = false;
			cast(getChildByName("_internPrice_hell_txt"), TextSprite).visible = false;
			hellCard.visible = false;
			hellPortrait.visible = false;
		}
		
		if (DialogueManager.ftueStepBuyIntern) {
			numberHousesHell.text = 1 + "";
		}
	}
	
	private function setValuesHellCard():Void{
		if (hellIntern != null) {
			hellName.text = hellIntern.name;
			hellPrice.text = hellIntern.price + "";
			
			if(!DialogueManager.ftueStepBuyIntern)
				if (!Intern.canBuy(Alignment.hell, hellIntern)){
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
		
		initStars(hellIntern, hellGaugeEfficency, hellGaugeSpeed);
		SpriteManager.spawnComponent(hellPortrait, hellIntern.portrait, hellCard, TypeSpawn.SPRITE, true);
	}

	private function setValuesHeavenCard():Void{
		if (heavenIntern != null) {
			heavenName.text = heavenIntern.name;
			heavenPrice.text = heavenIntern.price + "";
			
			if (!Intern.canBuy(Alignment.heaven, heavenIntern)){
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
		
		initStars(heavenIntern, heavenGaugeEfficency, heavenGaugeSpeed);
		SpriteManager.spawnComponent(heavenPortrait, heavenIntern.portrait, heavenCard, TypeSpawn.SPRITE, true);
	}
	
	/**
	 * Set the correct values of the heaven intern house
	 */
	private function setValuesNumberHousesHeaven():Void{
		if (Intern.numberInternHouses[Alignment.heaven] != null && Intern.internsListAlignment[Alignment.heaven] != null && (Intern.numberInternHouses[Alignment.heaven] > Intern.internsListAlignment[Alignment.heaven].length)){
			numberHousesHeaven.text = Intern.numberInternHouses[Alignment.heaven] - Intern.internsListAlignment[Alignment.heaven].length + "";
		}		
		else {
			numberHousesHeaven.text = 0 + "";
		}
	}
	
	/**
	 * Set the correct values of the hell intern house
	 */
	private function setValuesNumberHousesHell():Void{
		if (Intern.numberInternHouses[Alignment.hell] != null && Intern.internsListAlignment[Alignment.hell] != null && (Intern.numberInternHouses[Alignment.hell] > Intern.internsListAlignment[Alignment.hell].length)){
			numberHousesHell.text = Intern.numberInternHouses[Alignment.hell] - Intern.internsListAlignment[Alignment.hell].length + "";
		}		
		else {
			numberHousesHell.text = 0 + "";
		}
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnReroll, onClickReroll);
		Interactive.addListenerClick(hellCard, onClickHell);
		Interactive.addListenerRewrite(hellCard, setValuesHellButton);
		Interactive.addListenerRewrite(hellCard, setValuesHellCard);
		Interactive.addListenerRewrite(heavenCard, setValuesHeavenButton);
		Interactive.addListenerRewrite(heavenCard, setValuesHeavenCard);
		Interactive.addListenerClick(heavenCard, onClickHeaven);
		Interactive.addListenerRewrite(btnReroll, rerollRewrite);
	}
	
	
	/**
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void {
		return null;
	}
	
	/**
	 * Callback of the hell card's click. Verification if player can buy or not an intern
	 */
	private function onClickHell():Void{
		//Si achat possible
		if (DialogueManager.ftueStepBuyIntern || Intern.canBuy(Alignment.hell, hellIntern)) {
			SoundManager.getSound("SOUND_SPEND").play();
			Intern.buy(hellIntern);
			closeShop();
			
			if (DialogueManager.ftueStepBuyIntern)
				DialogueManager.endOfaDialogue();
		}
	}
	
	/**
	 * Callback of the heaven card's click. Verification if player can buy or not an intern
	 */
	private function onClickHeaven():Void{
		if (Intern.canBuy(Alignment.heaven, heavenIntern)){
			SoundManager.getSound("SOUND_SPEND").play();
			Intern.buy(heavenIntern);
			closeShop();
		}
	}
	
	private function rerollRewrite():Void {
		btnRerollTxt = cast(SmartCheck.getChildByName(btnReroll, AssetName.CAROUSSEL_INTERN_BTN_REROLL_TXT), TextSprite);
		
	}
	
	private function closeShop():Void{
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * Callback of the reroll. Reroll the search
	 */
	private function onClickReroll ():Void {	
		if (Intern.numberInternHouses[Alignment.heaven] - Intern.internsListAlignment[Alignment.heaven].length > 0 || Intern.numberInternHouses[Alignment.hell] - Intern.internsListAlignment[Alignment.hell].length > 0) {
			hellIntern = null;
			heavenIntern = null;
			//if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			//	return;
			ShopCarousselInternsSearch.progress = 0;
			//ShopPopin.isSearching = true;
			ShopPopin.getInstance().init(ShopTab.InternsSearch);
		}
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnReroll, onClickReroll);
		Interactive.removeListenerClick(hellCard, onClickHell);
		Interactive.removeListenerClick(heavenCard, onClickHeaven);
		Interactive.removeListenerRewrite(heavenCard, setValuesHeavenButton);
		Interactive.removeListenerRewrite(hellCard, setValuesHellButton);
		Interactive.removeListenerRewrite(btnReroll, rerollRewrite);
		super.destroy();
	}
	
}