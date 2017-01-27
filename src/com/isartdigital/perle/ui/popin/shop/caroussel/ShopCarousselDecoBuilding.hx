package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.card.CCLBuilding;
import com.isartdigital.perle.ui.popin.shop.card.CCUBuilding;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselDecoBuilding extends ShopCaroussel{
	
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_DECO_BUILDING);
	}
	
	override function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Item_Unlocked_1",
			"Shop_Item_Unlocked_2",
			"Shop_Item_Locked_1"
		];
	}
	
	override function getNewCard(pCardToShow:String):CarouselCard {
		return UnlockManager.checkIfUnlocked(pCardToShow) ? 
				new CCUBuilding() : new CCLBuilding();
	}
}