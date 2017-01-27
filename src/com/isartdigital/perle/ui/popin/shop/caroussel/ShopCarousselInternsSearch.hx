package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselInternsSearch extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN_SEARCHING);
	}
	
	/**
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void { }

	override private function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Intern_?_1",
			"Intern_?_2",
			"Intern_?_3"
		];
	}
	
}