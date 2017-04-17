package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import pixi.core.display.DisplayObject;
import pixi.interaction.EventTarget;

/**
 * Popin that give more info on the building.
 * Accessible from the shop by clicking on the info btn.
 * @author ambroise
 */
class ConfirmBuyBuilding extends SmartPopin {
	
	private static var instance:ConfirmBuyBuilding;
	private var btnExit:SmartButton;
	private var btnBuy:SmartButton;
	private var image:UISprite;
	private var textName:TextSprite;
	private var textPrice:TextSprite;
	private var textPopulationMax:TextSprite;
	private var iconPopulationMax:UISprite;
	private var buildingName:String;
	private var imgAssetName:String;
	private var iconSoulAssetName:String;
	
	public static function getInstance (): ConfirmBuyBuilding {
		if (instance == null) instance = new ConfirmBuyBuilding();
		return instance;
	}
	
	private function new() {
		super(AssetName.POPIN_CONFIRM_BUY_BUILDING);
		var lPopulationMax:DisplayObject = SmartCheck.getChildByName(this, AssetName.PCBB_INFO_POPULATION);
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.PCBB_BTN_CLOSE), SmartButton);
		btnBuy = cast(SmartCheck.getChildByName(this, AssetName.PCBB_BTN_BUY), SmartButton);
		image = cast(SmartCheck.getChildByName(this, AssetName.PCBB_IMG), UISprite);
		textName = cast(SmartCheck.getChildByName(this, AssetName.PCBB_TEXT_NAME), TextSprite);
		textPrice = cast(SmartCheck.getChildByName(btnBuy, AssetName.PCBB_BTN_BUY_TXT), TextSprite);
		textPopulationMax = cast(SmartCheck.getChildByName(lPopulationMax, AssetName.PCBB_POPULATION_TXT_MAX), TextSprite);
		iconPopulationMax = cast(SmartCheck.getChildByName(lPopulationMax, AssetName.PCBB_POPULATION_ICON_SOUL), UISprite);
	}
	
	public function init (pBuildingName:String, pOnClickBuy:EventTarget->Void):Void {
		buildingName = pBuildingName;
		imgAssetName = BuildingName.getAssetName(buildingName);
		var lConfig:TableTypeBuilding = GameConfig.getBuildingByName(buildingName);
		iconSoulAssetName = getSoulIconName(lConfig.alignment);
		
		textName.text = Localisation.getText(buildingName);
		textPrice.text = Std.string(lConfig.costGold);
		textPopulationMax.text = Std.string(lConfig.maxSoulsContained);
		SmartPopinExtended.setImage(image, imgAssetName);
		SmartPopinExtended.setIcon(iconSoulAssetName, iconPopulationMax);
		
		Interactive.addListenerClick(btnExit, onClickExit);
		if (!BuyManager.canBuy(buildingName)) { /*&& !DialogueManager.ftueStepClickOnCard*/
			btnBuy.alpha = 0.5;
		} else {
			// on click buy close popin (exit) and call the card on click buy.
			Interactive.addListenerClick(btnBuy, onClickExit);
			Interactive.addListenerClick(btnBuy, cast(pOnClickBuy));
		}
		
		Interactive.addListenerRewrite(btnBuy, rewriteBtnBuy);
	}
	
	private function rewriteBtnBuy(){
		cast(SmartCheck.getChildByName(btnBuy, AssetName.PCBB_BTN_BUY_TXT), TextSprite).text = Std.string(GameConfig.getBuildingByName(buildingName).costGold);
	}
	
	private function getSoulIconName (pAlignment:Alignment):String {
		switch (pAlignment) {
			case Alignment.neutral: return AssetName.ICON_SOUL_MEDIUM;
			case Alignment.heaven: return AssetName.PROD_ICON_SOUL_HEAVEN_SMALL;
			case Alignment.hell: return AssetName.PROD_ICON_SOUL_HELL_SMALL;
			default: return null;
		}
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	override public function destroy():Void {
		Interactive.removeListenerRewrite(btnBuy, rewriteBtnBuy);
		instance = null;
		Interactive.removeListenerClick(btnExit, onClickExit);
		btnBuy.removeAllListeners();
		super.destroy();
	}
	
}