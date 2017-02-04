package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 * @author Ambroise Rabier
 */
class CarouselCardLock extends CarouselCard implements ICardVariableBackground
{

	private static inline var UNLOCK_TEXT = "Level : ";
	private var buildingName:String;
	private var text_lock:TextSprite;
	private var background:UISprite;
	private var alignment:Alignment;
	
	override public function new() {
		super(AssetName.CAROUSSEL_CARD_LOCKED);
	}
	
	override public function init(pName:String):Void {
		buildingName = pName;
		alignment = GameConfig.getBuildingByName(buildingName).alignment;
		super.init(pName);
	}
	
	override function buildCard ():Void {
		super.buildCard();
		
		image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		text_lock = cast(SmartCheck.getChildByName(this, "Reason_locked"), TextSprite);
		setText();
		
		if (alignment != Alignment.neutral)
			setBackground();
	}
	
	private function setBackground(pStateDown:Bool=false):Void {
		
		if (background == null)
			background = cast(SmartCheck.getChildByName(this, AssetName.CARD_BACKGROUND_NEUTRAL_CONTAINER), UISprite);
		
		var lPos:Point = background.position;
		
		removeChild(background);
		background.destroy();
		background = new UISprite(getBackgroundAssetName(alignment));
		// if the original background Z-Index wasn't 0 it would be a problem
		addChildAt(background, 0);
		background.start();
	}
	
	// no state down for locked
	private function getBackgroundAssetName (pAlignment:Alignment, pStateDown:Bool=false):String {
		
		if (pAlignment == Alignment.heaven) {
			return pStateDown ? AssetName.CARD_BACKGROUND_HEAVEN_DOWN : AssetName.CARD_BACKGROUND_HEAVEN_UP;
		} else {
			return pStateDown ? AssetName.CARD_BACKGROUND_HELL_DOWN : AssetName.CARD_BACKGROUND_HELL_UP;
		}
	}
	
	private function setText ():Void {
		text_lock.text = UNLOCK_TEXT + UnlockManager.checkLevelNeeded(buildingName);
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}