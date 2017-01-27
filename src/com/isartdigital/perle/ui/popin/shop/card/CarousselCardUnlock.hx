package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Alexis
 */
class CarousselCardUnlock extends CarouselCard
{
	private var buildingName:String;
	
	override public function new(pID:String=null) {
		super(pID);
	}
	
	override public function init (pBuildingName:String):Void {
		buildingName = pBuildingName;
		super.init(pBuildingName);
		
	}
	
	override function buildCard():Void {
		super.buildCard();
		if (!BuyManager.canBuy(buildingName))
			alpha = 0.5;
			
		
	}
	
	private function setName (pAssetName:String):Void {}
	
	override private function _click (/*pEvent:EventTarget = null*/):Void {
		if (alpha == 0.5)
			return;
		super._click(/*pEvent*/);
		closeShop();
	}
	
	private function closeShop ():Void { // todo : dans la mauvaise class...
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
}