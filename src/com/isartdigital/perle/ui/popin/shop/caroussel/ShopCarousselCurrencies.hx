package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.card.CarousselCardPack;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselCurrencies extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_CURRENCIE);
		
	}

	override function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Pack_1",
			"Shop_Pack_2",
			"Shop_Pack_3",
			"Shop_Pack_4"
		];
	}
	
	override private function getNewCard (pCardToShow:String):CarouselCard {
		return new CarousselCardPack();
	}
	
	override private function getCardToShow ():Array<String> {
		var result:Array<String> = new Array<String>();
		
		for (i in 0...GameConfig.getShopPack().length) {
			if (GameConfig.getShopPack()[i].tab == ShopTab.Currencies)
				result.push(GameConfig.getShopPack()[i].packName);
		}
		
		return result;
	}
	
}