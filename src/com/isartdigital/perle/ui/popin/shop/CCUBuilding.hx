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
		setRessourcesPrice();
	}
	
	private function setRessourcesPrice() {
	
		var item_price = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice"), TextSprite);
		var item_price2 = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice2"), TextSprite);
		var item_icon = cast(SmartCheck.getChildByName(this, "Resource_icon"), UISprite);
		var item_icon2 = cast(SmartCheck.getChildByName(this, "Resource_icon2"), UISprite);
		this.removeChild(item_price);	
		this.removeChild(item_price2);	
		this.removeChild(item_icon);	
		this.removeChild(item_icon2);	
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