package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCardPackCurrency;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCardPackCurrencyVideo;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselCurrencies extends ShopCaroussel{

	private var KARMA_AD(default,never):String = 'karma ad';
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_CURRENCIE);
		
	}

	override function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Pack_1",
			"Shop_Pack_2",
			"Shop_Pack_3",
			"Shop_Pack_4",
			"Shop_Pack_5",
			"Shop_Pack_6"
		];
	}
	
	override private function getNewCard (pCardToShow:String):CarouselCard {
		return pCardToShow == KARMA_AD ? new CarouselCardPackCurrencyVideo() : new CarouselCardPackCurrency();
	}
	
	override private function getCardToShowOverride ():Array<String> {
		var result:Array<String> = new Array<String>();
		
		for (i in 0...GameConfig.getShopPack().length) {
			if (GameConfig.getShopPack()[i].tab == ShopTab.Currencies){
				if (GameConfig.getShopPack()[i].packName == KARMA_AD) result.unshift(GameConfig.getShopPack()[i].packName);
				else result.push(GameConfig.getShopPack()[i].packName);
			}
		}
		
		return result;
	}
	
}