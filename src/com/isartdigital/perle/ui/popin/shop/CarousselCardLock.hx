package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Alexis
 */
class CarousselCardLock extends CarouselCard
{

	private static inline var UNLOCK_TEXT = "Level : ";
	private var text_lock:TextSprite;
	
	override public function new() 
	{
		super(AssetName.CAROUSSEL_CARD_ITEM_LOCKED);
		text_lock = cast(SmartCheck.getChildByName(this, "Reason_locked"), TextSprite);
	}
	
	override public function init (pBuildingAssetName:String):Void {
		super.init(pBuildingAssetName);
		text_lock.text = UNLOCK_TEXT + UnlockManager.checkLevelNeeded(pBuildingAssetName);
	}
	
	override public function start ():Void {
		super.start();
	}
	
	override public function destroy():Void {
		//removeListener(MouseEventType.CLICK, onClick);
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}