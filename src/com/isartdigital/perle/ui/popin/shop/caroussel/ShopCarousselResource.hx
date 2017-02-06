package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCardPack;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCardPackResource;
import com.isartdigital.perle.ui.popin.shop.card.CCUResource;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselResource extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_RESOURCE);
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
		return new CarouselCardPackResource();
	}
	
	override private function getCardToShowOverride ():Array<String> {
		var result:Array<String> = new Array<String>();
		
		for (i in 0...GameConfig.getShopPack().length) {
			if (GameConfig.getShopPack()[i].tab == ShopTab.Resources)
				result.push(GameConfig.getShopPack()[i].packName);
		}
		
		return result;
	}
	
}