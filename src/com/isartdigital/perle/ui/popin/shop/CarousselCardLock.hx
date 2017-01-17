package com.isartdigital.perle.ui.popin.shop;
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
	private var text_lock:TextSprite;
	
	override public function new() 
	{
		super(AssetName.CAROUSSEL_CARD_ITEM_LOCKED);
		image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		text_lock = cast(SmartCheck.getChildByName(this, "Reason_locked"), TextSprite);
	}
	
	override public function init (pBuildingName:String):Void {
		super.init(pBuildingName);
		text_lock.text = UNLOCK_TEXT + UnlockManager.checkLevelNeeded(pBuildingName);
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