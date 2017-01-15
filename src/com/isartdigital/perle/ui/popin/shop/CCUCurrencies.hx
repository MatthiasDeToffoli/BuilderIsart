package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUCurrencies extends CarousselCardUnlock{

	public function new() {
		super();
	}
	
	override function setName(pAssetName:String):Void {
		numberRessource.text = "" + numberToGive();	
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		
		switch(lAssetName) {
			case("Gold pack") : ResourcesManager.gainResources(GeneratorType.soft, 10000);
			case("Karma pack") : ResourcesManager.gainResources(GeneratorType.hard, 100);
		}
	}
	
	
}