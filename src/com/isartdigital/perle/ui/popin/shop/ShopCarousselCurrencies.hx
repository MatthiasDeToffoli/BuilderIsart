package com.isartdigital.perle.ui.popin.shop;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselCurrencies extends ShopCaroussel{

	public function new() {
		super();
		
	}

	override function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Pack_1",
			"Shop_Pack_2",
			"Shop_Pack_3",
			"Shop_Pack_4"
		];
	}
	
}