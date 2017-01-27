package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Alexis
 */
class CarousselCardLock extends CarouselCard
{

	private static inline var UNLOCK_TEXT = "Level : ";
	private var buildingName:String;
	private var text_lock:TextSprite;
	
	override public function new() {
		super(AssetName.CAROUSSEL_CARD_LOCKED);
	}
	
	override public function init(pName:String):Void {
		buildingName = pName;
		super.init(pName);
	}
	
	override function buildCard ():Void {
		super.buildCard();
		
		image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		text_lock = cast(SmartCheck.getChildByName(this, "Reason_locked"), TextSprite);
		setText();
	}
	
	private function setText ():Void {
		text_lock.text = UNLOCK_TEXT + UnlockManager.checkLevelNeeded(buildingName);
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}