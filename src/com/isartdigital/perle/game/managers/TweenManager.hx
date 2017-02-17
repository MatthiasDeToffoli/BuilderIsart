package com.isartdigital.perle.game.managers;
import com.greensock.easing.Back;
import com.greensock.easing.Elastic;
import com.greensock.TweenMax;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;

/**
 * Every tween for juicyness gonna be here
 * @author ambroise
 */
class TweenManager {
	
	private static inline var SCALE_GROW_DURATION:Float = 0.5;
	private static inline var SCALE_GROW_START_SCALE:Float = 0.8;
	private static inline var SCALE_GROW_BACK_PARAM_1:Float = 1.2;
	
	private static inline var POS_UP_DURATION:Float = 2;
	private static inline var POS_UP_PARAM:Float = 0.1;
	
	private static inline var POSITION_ELASTIC_ATTRACT_DURATION:Float = 1.3; // seconds
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_1:Float = 1;
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_2:Float = 0.75;
	
	/**
	 * Start from a lower scale then put scale to 1:1
	 */
	public static function scaleGrow (pDisplayObject:DisplayObject):Void {
		pDisplayObject.scale.x = SCALE_GROW_START_SCALE;
		pDisplayObject.scale.y = SCALE_GROW_START_SCALE;
		
		TweenMax.to(pDisplayObject.scale, SCALE_GROW_DURATION, {
			ease: untyped Back.easeOut.config(SCALE_GROW_BACK_PARAM_1),
			x:1,
			y:1
		} );
	}
	
	/**
	 * Start from a lower pos then put pos to 0:0 of the object
	 */
	public static function upperToRealPos (pDisplayObject:DisplayObject):Void {
		var lPos:Point = pDisplayObject.position;
		var uperPos:Point;
		uperPos = new Point(lPos.x, -GameStage.getInstance().getFtueContainer().toLocal(new Point(0,0), GameStage.getInstance()).y);
		//pDisplayObject.position = uperPos;
		
		/*TweenMax.to(pDisplayObject.position, POS_UP_DURATION, {
			ease: untyped Back.easeOut.config(POS_UP_PARAM),
			x:lPos.x,
			y:lPos.y
		} );*/
	}
	
	/**
	 * Start from the right or left pos then put pos to 0:0 of the object
	 */
	public static function rigthLeftToRealPos (pDisplayObject:DisplayObject, ?pRight:Bool):Void {
		var lPos:Point = pDisplayObject.position;
		var rightFalsePos:Point;
		pRight ? rightFalsePos = new Point(-Browser.window.innerWidth, lPos.y) : rightFalsePos = new Point(Browser.window.innerWidth, lPos.y);
		pDisplayObject.position = rightFalsePos;
		
		TweenMax.to(pDisplayObject.position, POS_UP_DURATION, {
			ease: untyped Back.easeOut.config(POS_UP_PARAM),
			x:lPos.x,
			y:lPos.y
		} );
	}
	
	
	/**
	 * Used for buttonProduction.
	 * /!\ Carreful an OFFSET of -pDisplayObject.height/2 is ADDED.
	 * @param	pDisplayObject
	 * @param	pTarget
	 * @param	pChangeContainer
	 * @param	pCallBack
	 */
	public static function positionElasticAttract (pDisplayObject:Container, pTarget:Point, ?pChangeContainer:Container, ?pCallBack:Void -> Void):Void {
		if (pChangeContainer != null) {
			var lNewPos:Point = pChangeContainer.toLocal(pDisplayObject.position, pDisplayObject.parent);
			pChangeContainer.addChild(pDisplayObject);
			pDisplayObject.position = lNewPos;
		}
		
		TweenMax.to(pDisplayObject, POSITION_ELASTIC_ATTRACT_DURATION, { 
			onComplete:pCallBack,
			ease: untyped Elastic.easeOut.config(POSITION_ELASTIC_ATTRACT_PARAM_1, POSITION_ELASTIC_ATTRACT_PARAM_2),
			x:pTarget.x,
			y:pTarget.y - pDisplayObject.height / 2
		} );
	}
	
}