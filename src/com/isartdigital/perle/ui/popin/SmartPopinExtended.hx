package com.isartdigital.perle.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UIMovie;
import dat.controllers.Controller;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author ambroise
 */
class SmartPopinExtended extends SmartPopin{

	private static inline var TWEEN_DURATION:Float = 0.5;
	private static inline var TWEEN_START_SCALE:Float = 0.8;
	private static inline var TWEEN_BACK_PARAM_1:Float = 1.2;
	
	/**
	 * Fit and create an image into pContainer
	 * @param	pContainer
	 * @param	pAssetName
	 */
	public static function setImage (pContainer:Container, pAssetName:String):Void {
		var lImage:UIMovie = new UIMovie(pAssetName);
		
		reScaleImage(lImage, pContainer); // before adding anything inside or size will change
		pContainer.addChild(lImage); // needed before getLocalBounds
		
		var lLocalBounds:Rectangle = lImage.getLocalBounds();
		var topLeft:Point = new Point(
			lLocalBounds.x,
			lLocalBounds.y
		);
		var trueCenter:Point = new Point(
			topLeft.x + lLocalBounds.width / 2,
			topLeft.y + lLocalBounds.height / 2
		);
		trueCenter = pContainer.toLocal(trueCenter, lImage);
		
		lImage.x -= trueCenter.x;
		lImage.y -= trueCenter.y;
		
		lImage.start();
	}
	
	private static function reScaleImage(pChange:Container, pToModel:Container):Void {
		var lRatio:Float;
		if (pChange.width > pChange.height)
			lRatio = pToModel.width / pChange.width;
		else
			lRatio = pToModel.height / pChange.height;
		
		pChange.scale.x = lRatio;
		pChange.scale.y = lRatio;
	}
	
	public function new(pID:String=null) {
		super(pID);
		
	}
	
	override public function build(pFrame:Int = 0):Void {
		super.build(pFrame);
		tweenPopin();
	}
	
	// todo : héritage onClickExit onClose, avec Hud show et hide
	
	/**
	 * Put scale to 1:1
	 */
	private function tweenPopin ():Void {
		scale.x = TWEEN_START_SCALE;
		scale.y = TWEEN_START_SCALE;
		
		TweenMax.to(scale, TWEEN_DURATION, {
			ease: untyped Back.easeOut.config(TWEEN_BACK_PARAM_1),
			x:1,
			y:1
		} );
	}
}