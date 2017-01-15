package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUBuilding extends CarousselCardUnlock{

	public function new() {
		super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
		image = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PICTURE), UISprite);
		text_name = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_NAME), TextSprite);
		text_price = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PRICE), TextSprite);
	}
	
	override public function init(pBuildingAssetName:String):Void {
		super.init(pBuildingAssetName);
		setImage(buildingAssetName);
		setName(buildingAssetName);
	}
	
	override function setName(pAssetName:String):Void {
		text_name.text = FakeTraduction.assetNameNameToTrad(pAssetName);
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		
		if (BuyManager.canBuy(buildingAssetName)) {
			Phantom.onClickShop(buildingAssetName);
			Hud.getInstance().hideBuildingHud();
			Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
		}
		
		// todo : il close le shop même si canBuy == false  :(
	}
	
}