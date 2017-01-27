package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCaroussel;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselBundle extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_BUNDLE);
	}
	
	override function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"BundleSpawner1",
			"BundleSpawner2",
			"BundleSpawner3"
		];
	}
	
	override private function getCardToShow ():Array<String> {
		var result:Array<String> = new Array<String>();
		
		for (i in 0...GameConfig.getShopPack().length) {
			if (GameConfig.getShopPack()[i].tab == ShopTab.Bundle)
				result.push(GameConfig.getShopPack()[i].packName);
		}
		
		return result;
	}
	
}