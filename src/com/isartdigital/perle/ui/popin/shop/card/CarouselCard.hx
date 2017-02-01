package com.isartdigital.perle.ui.popin.shop.card;
import com.greensock.easing.Back;
import com.greensock.TweenMax;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartButton { // n'est pas un smart btn ds le .fla...

	private static inline var TWEEN_DURATION:Float = 1;
	private static inline var TWEEN_START_SCALE:Float = 0.8;
	private static inline var TWEEN_BACK_PARAM_1:Float = 1.2;
	
	private var image:UISprite;
	
	private var isInit:Bool;
	
	public function new(pAsset:String) {
		super(pAsset);
		
		scale.x = TWEEN_START_SCALE;
		scale.y = TWEEN_START_SCALE;
	}
	
	/**
	 * Do what you want whit pName in descendant (héritage)
	 * @param	pName
	 */
	public function init (pName:String):Void {
		isInit = true;
		buildCard();
		//tweenPopin();
	}
	
	override private function _mouseDown (pEvent:EventTarget = null): Void {
		super._mouseDown(pEvent);
		if (isInit) // i've tried using build funciton override, doesn't seem to work
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
	
	/**
	 * Put scale to 1:1
	 */
	private function tweenPopin ():Void {
		TweenMax.to(scale, TWEEN_DURATION, {
			ease: untyped Back.easeOut.config(TWEEN_BACK_PARAM_1),
			x:1,
			y:1
		} );
	}
	
	override public function destroy():Void {
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}