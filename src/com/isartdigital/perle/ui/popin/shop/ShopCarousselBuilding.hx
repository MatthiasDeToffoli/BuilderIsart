package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.popin.shop.CarouselCard;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselBuilding extends ShopCaroussel{

	public function new() {
		super(AssetName.SHOP_CAROUSSEL_BUILDING); // todo:  temp ? ou change classNAme
		arrowLeft = cast(SmartCheck.getChildByName(this, "Button_ArrowLeft"), SmartButton);
		arrowRight = cast(SmartCheck.getChildByName(this, "Button_ArrowRight"), SmartButton);
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