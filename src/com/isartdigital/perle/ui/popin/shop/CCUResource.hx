package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProduction;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUResource extends CarousselCardUnlock{
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_BUNDLE);
		text_number_resource = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_PACK_PRICE), TextSprite);
		text_price = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_PACK_CONTENT), TextSprite);
	}
	
	override function setName(pAssetName:String):Void {
		text_number_resource.text = "" + numberToGive();	
	}
	
	override public function init(pBuildingAssetName:String):Void 
	{
		super.init(pBuildingAssetName);
		addGraphic();
	}
	
	
	private function addGraphic ():Void {
		var lAsset:String = "_goldIcon_Small";
		switch(lAssetName) {
			case("Wood pack") : lAsset = "_woodIcon_Small";
			case("Iron pack") : lAsset = "_stoneIcon_Small";
			case("Gold pack") : lAsset = "_goldIcon_Small";
			case("Karma pack") : lAsset = "_hardCurrencyIcon_Small";
		}
		
		var icon:UISprite = new UISprite(lAsset);
		var spawner = cast(SmartCheck.getChildByName(this,"Pack_Content_Icon"), UISprite);
		
		icon.position = spawner.position;
		removeChild(spawner);
		addChild(icon);
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		
		switch(lAssetName) {
			case("Wood pack") : ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, 1000);
			case("Iron pack") : ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, 1000);
			case("Gold pack") : ResourcesManager.gainResources(GeneratorType.soft, 10000);
			case("Karma pack") : ResourcesManager.gainResources(GeneratorType.hard, 100);
		}
	}
}