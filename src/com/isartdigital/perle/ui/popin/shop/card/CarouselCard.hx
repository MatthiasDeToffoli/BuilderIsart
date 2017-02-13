package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartButton { // n'est pas un smart btn ds le .fla...
	
	private var image:UISprite;
	
	private var isInit:Bool;
	
	public function new(pAsset:String) {
		super(pAsset);
	}
	
	/**
	 * Do what you want whit pName in descendant (héritage)
	 * @param	pName
	 */
	public function init (pName:String):Void {
		isInit = true;
		buildCard();
	}
	
	override private function _mouseDown (pEvent:EventTarget = null): Void {
		super._mouseDown(pEvent);
		if (isInit) // i've tried using build function override, doesn't seem to work
			buildCard();
	}
	
	override private function _mouseOver (pEvent:EventTarget = null): Void {
		super._mouseOver(pEvent);
		if (isInit)
			buildCard();
	}
	
	override private function _mouseOut (pEvent:EventTarget = null): Void {
		super._mouseOut(pEvent);
		if (isInit)
			buildCard();
	}
	
	private function buildCard ():Void {}
	
	// todo faire un tween sympa ?
	/*private function tweenPopin ():Void {
		TweenMax.to(scale, TWEEN_DURATION, {
			ease: untyped Back.easeOut.config(TWEEN_BACK_PARAM_1),
			x:1,
			y:1
		} );
	}*/

	private function closeShop ():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function changeIconSpawner (pSpriteName:String, pSpawner:UISprite):Void {
		var lSprite:UISprite = new UISprite(pSpriteName);
		lSprite.position = pSpawner.position;
		lSprite.scale = pSpawner.scale;
		addChild(lSprite);
		removeChild(pSpawner);
		pSpawner.destroy();
		pSpawner = lSprite;
	}
	
	private function addkToInt (pFloat:Float):String {
		return pFloat > 1000 ? Std.string(pFloat / 1000) + "k" : Std.string(pFloat);
	}
	
	
	override public function destroy():Void {
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}