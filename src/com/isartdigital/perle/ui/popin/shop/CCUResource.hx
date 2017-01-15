package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
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