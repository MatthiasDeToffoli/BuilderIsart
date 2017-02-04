package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Alexis
 */
class CarouselCardUnlock extends CarouselCard implements ICardVariableBackground
{
	private var buildingName:String;
	private var background:UISprite;
	private var isMouseDown:Bool;
	private var alignment:Alignment;
	
	override public function new(pID:String=null) {
		super(pID);
	}
	
	override public function init (pBuildingName:String):Void {
		buildingName = pBuildingName;
		alignment = GameConfig.getBuildingByName(buildingName).alignment;
		super.init(pBuildingName);
		
	}
	
	override function buildCard():Void {
		super.buildCard();
		if (!BuyManager.canBuy(buildingName))
			alpha = 0.5;
			
		if (alignment != Alignment.neutral)
			setBackground();
	}
	
	override function _mouseDown(pEvent:EventTarget = null):Void {
		isMouseDown = true;
		super._mouseDown(pEvent);
		isMouseDown = false;
	}
	
	private function setName (pAssetName:String):Void {}
	
	override private function _click (pEvent:EventTarget = null):Void {
		if (alpha == 0.5)
			return;
		super._click(pEvent);
		closeShop();
	}
	
	private function setBackground(pStateDown:Bool = false):Void {
		// todo : nice to have : optimize
		// maybe can be optimized by changing the images inside
		// background UISprite
		
		// destroying my custom background
		if (background != null) {
			background.destroy();
			background = null;
		}
		
		
		// getting the newly created background
		if (background == null)
			background = cast(SmartCheck.getChildByName(this, AssetName.CARD_BACKGROUND_NEUTRAL_CONTAINER), UISprite);
		
		var lPos:Point = background.position;
		
		// destroying the old one and addchild my custom.
		removeChild(background);
		background.destroy();
		background = new UISprite(getBackgroundAssetName(alignment, isMouseDown));
		// if the original background Z-Index wasn't 0 it would be a problem
		addChildAt(background, 0);
		background.start();
	}
	
	private function getBackgroundAssetName (pAlignment:Alignment, pStateDown:Bool=false):String {
		
		if (pAlignment == Alignment.heaven) {
			return pStateDown ? AssetName.CARD_BACKGROUND_HEAVEN_DOWN : AssetName.CARD_BACKGROUND_HEAVEN_UP;
		} else {
			return pStateDown ? AssetName.CARD_BACKGROUND_HELL_DOWN : AssetName.CARD_BACKGROUND_HELL_UP;
		}
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