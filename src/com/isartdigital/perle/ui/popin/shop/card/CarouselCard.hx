package com.isartdigital.perle.ui.popin.shop.card;
import com.greensock.easing.Back;
import com.greensock.TweenMax;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.math.Point;
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
	
	/**
	 * Put scale to 1:1
	 */
	private function tweenPopin ():Void {
		/*TweenMax.to(scale, TWEEN_DURATION, {
			ease: untyped Back.easeOut.config(TWEEN_BACK_PARAM_1),
			x:1,
			y:1
		} );*/
	}
	
	// inutile, si pas de problème compil, supprimer.
	/*private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		
		lImage.init();
		lImage.width = image.width;
		lImage.height = image.height;
		image.addChild(lImage);
		lImage.x = 0;
		lImage.y = 0;
		lImage.start();
		
	}*/
	
	private function changeIconSpawner (pSpriteName:String, pSpawner:UISprite):Void {
		var lSprite:UISprite = new UISprite(pSpriteName);
		lSprite.position = pSpawner.position;
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