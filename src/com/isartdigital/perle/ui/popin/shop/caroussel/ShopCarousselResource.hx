package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.card.CCUResource;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselResource extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_RESOURCE);
		arrowLeft = cast(SmartCheck.getChildByName(this, "Arrow_Left_Wood"), SmartButton); // temp
		arrowRight = cast(SmartCheck.getChildByName(this, "Arrow_Right_Stone"), SmartButton);
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
	
	override function getNewCard(pCardToShow:String):CarouselCard {
		/*return UnlockManager.checkIfUnlocked(pCardToShow) ? 
				new CCUResource() : new CCLResource();*/
				return new CCUResource();
	}
	
}