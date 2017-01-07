package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.DisplayObject;

/**
 * ...
 * @author ambroise
 */
class ConfirmBuyBuilding extends SmartPopin {

	private static inline var PER_TIME:String = "min"; // todo : traduc toute langue ?
	private static inline var LEVEL:String = "Level"; // todo : traduc toute langue ?

	private static var instance:ConfirmBuyBuilding;
	
	private var image:UISprite;
	
	private var textName:TextSprite;
	private var textLevel:TextSprite;
	private var textPrice:TextSprite;
	private var textGoldMax:TextSprite;
	private var textPopulationMax:TextSprite;
	private var textGoldPerTime1:TextSprite;
	private var textGoldPerTime2:TextSprite;
	
	private var btnExit:SmartButton;
	private var btnBuy:SmartButton;
	
	private var buildingAssetName:String;
	
	public static function getInstance (): ConfirmBuyBuilding {
		if (instance == null) instance = new ConfirmBuyBuilding();
		return instance;
	}
	
	private function new() {
		super(AssetName.POPIN_CONFIRM_BUY_BUILDING);
		
		var lPrice:DisplayObject = SmartCheck.getChildByName(this, AssetName.PCBB_PRICE);
		var lGoldMax:DisplayObject = SmartCheck.getChildByName(this, AssetName.PCBB_GOLD_MAX);
		var lPopulationMax:DisplayObject = SmartCheck.getChildByName(this, AssetName.PCBB_POPULATION_MAX);
		var lGoldPerTime:DisplayObject = SmartCheck.getChildByName(this, AssetName.PCBB_GOLD_PER_TIME);
		
		image = cast(SmartCheck.getChildByName(this, AssetName.PCBB_IMG), UISprite);
		textName = cast(SmartCheck.getChildByName(this, AssetName.PCBB_TEXT_NAME), TextSprite);
		textLevel = cast(SmartCheck.getChildByName(this, AssetName.PCBB_TEXT_LEVEL), TextSprite);
		textPrice = cast(SmartCheck.getChildByName(lPrice, AssetName.PCBB_PRICE_TEXT), TextSprite);
		textGoldMax = cast(SmartCheck.getChildByName(lGoldMax, AssetName.PCBB_GOLD_MAX_TEXT), TextSprite);
		textPopulationMax = cast(SmartCheck.getChildByName(lPopulationMax, AssetName.PCBB_POPULATION_MAX_TEXT), TextSprite);
		textGoldPerTime1 = cast(SmartCheck.getChildByName(lGoldPerTime, AssetName.PCBB_GOLD_PER_TIME_TEXT_1), TextSprite);
		textGoldPerTime2 = cast(SmartCheck.getChildByName(lGoldPerTime, AssetName.PCBB_GOLD_PER_TIME_TEXT_2), TextSprite);
		
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.PCBB_BTN_CLOSE), SmartButton);
		btnBuy = cast(SmartCheck.getChildByName(this, AssetName.PCBB_BTN_BUY), SmartButton);
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnBuy.on(MouseEventType.CLICK, onClickBuy);
	}
	
	public function init (pAssetName:String):Void {
		buildingAssetName = pAssetName;
		setImage(buildingAssetName);
		setName(buildingAssetName);
		// todo : faire en fonction des données du building
		setPrice(Math.floor(Math.random() * 100));
		setGoldMax(500);
		setLevel(12);
		setPopulationMax(99);
		setGoldPerTimePerSoul(50, 30);
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 400;
		lImage.height = 400;
		image.addChild(lImage);
		lImage.start();
	}
	
	private function setName (pString:String):Void { //todo : from building config then traduction ?
		textName.text = pString;
	}
	
	private function setPrice (pInt:Int):Void { // todo : from building config
		textPrice.text = Std.string(pInt);
	}
	
	private function setLevel (pInt:Int):Void { // todo: from player data
		textLevel.text = LEVEL + Std.string(pInt); 
	}
		
	private function setGoldMax (pInt:Int):Void { //todo : from Building config
		textGoldMax.text = Std.string(pInt);
	}
	
	private function setPopulationMax (pInt:Int):Void { //todo : from Building config
		textPopulationMax.text = Std.string(pInt);
	}
	
	private function setGoldPerTimePerSoul (pGold:Int, pTime:Int):Void { //todo : from Building config (probably not a string)
		textGoldPerTime1.text = Std.string(pGold) ;
		textGoldPerTime2.text = Std.string(pTime) + PER_TIME;
	}
	
	private function onClickBuy ():Void {
		if (BuyManager.canBuy(buildingAssetName)) {
			Phantom.onClickShop(buildingAssetName);
			Hud.getInstance().hideBuildingHud();
			Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
			Hud.getInstance().show();
			UIManager.getInstance().closeCurrentPopin();
			UIManager.getInstance().closeCurrentPopin();
		} else {
			displayCantBuy();
		}
		
	}
	
	private function displayCantBuy ():Void {
		trace("can't buy you need more money !!");
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	override public function destroy():Void {
		instance = null;
		btnBuy.removeListener(MouseEventType.CLICK, onClickBuy);
		btnExit.removeListener(MouseEventType.CLICK, onClickExit);
		
		super.destroy();
	}
	
}