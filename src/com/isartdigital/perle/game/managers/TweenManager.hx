package com.isartdigital.perle.game.managers;
import com.greensock.core.Animation;
import com.greensock.easing.Back;
import com.greensock.easing.Elastic;
import com.greensock.easing.Power1;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.UISprite;
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
	private static inline var SCALE_GROW_DURATION_FTUE:Float = 1;
	private static inline var SCALE_GROW_START_SCALE:Float = 0.8;
	private static inline var SCALE_GROW_START_SCALE_FTUE:Float = 0.5;
	private static inline var SCALE_GROW_BACK_PARAM_1:Float = 1.2;
	private static inline var SCALE_GROW_BACK_PARAM_1_FTUE:Float = 1.2;
	
	private static inline var LOWER_ALPHA_DURATION:Float = 0.5;
	private static inline var POS_UP_DURATION:Float = 0.7;
	private static inline var POS_UP_PARAM:Float = 0.1;
	
	private static inline var POSITION_ELASTIC_ATTRACT_DURATION:Float = 1.3; // seconds
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_1:Float = 1;
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_2:Float = 0.75;
	
	//For UnlockPoppin
	private static inline var POSITION_ELASTIC_ATTRACT_DURATION_UNLOCK:Float = 0.5; // seconds
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_1_UNLOCK:Float = 0.2;
	private static inline var POSITION_ELASTIC_ATTRACT_PARAM_2_UNLOCK:Float = 0.05;
	private static inline var SCALE_GROW_DURATION_UNLOCK:Float = 0.7;
	private static inline var RESCALE_UNLOCK:Float = 0.1;
	private static inline var RESCALE_UNLOCK_DURATION:Float = 0.5;
	private static inline var RESCALE_UNLOCK_PARAM:Float = 0.4;
	private static inline var RESCALE_UNLOCK_PLUS:Float = 1.3;
	private static inline var RESCALE_UNLOCK_DURATION_PLUS:Float = 0.2;
	
	
	/**
	 * Start from a lower scale then put scale to 1:1
	 */
	public static function scaleGrow (pDisplayObject:DisplayObject, ?pFtue:Bool):Void {
		var lScale:Float = SCALE_GROW_START_SCALE;
		var lTime:Float = SCALE_GROW_DURATION;
		var lScaleParam:Float = SCALE_GROW_BACK_PARAM_1;
		if (pFtue) {
			lScale = SCALE_GROW_START_SCALE_FTUE;
			lTime = SCALE_GROW_DURATION_FTUE;
			lScaleParam = SCALE_GROW_BACK_PARAM_1_FTUE;
		}
		pDisplayObject.scale.x = lScale;
		pDisplayObject.scale.y = lScale;
		
		TweenMax.to(pDisplayObject.scale, lTime, {
			ease: untyped Back.easeOut.config(lScaleParam),
			x:1,
			y:1
		} );
	}
	
	public static function scaleReduce (pDisplayObject:DisplayObject,?pCallBack:Void -> Void):Void {
		TweenMax.to(pDisplayObject.scale, SCALE_GROW_DURATION, {
			onComplete:pCallBack,
			ease: untyped Back.easeOut.config(SCALE_GROW_BACK_PARAM_1),
			x:SCALE_GROW_START_SCALE,
			y:SCALE_GROW_START_SCALE
		} );
	}
	
	/**
	 * Start from a lower pos then put pos to 0:0 of the object
	 */
	public static function upperToRealPos (pDisplayObject:DisplayObject):Void {
		var lPos:Point = pDisplayObject.position;
		var uperPos:Point;
		uperPos = new Point(lPos.x, -GameStage.getInstance().getFtueContainer().toLocal(new Point(0,0), GameStage.getInstance()).y/4);
		pDisplayObject.position = uperPos;
		
		TweenMax.to(pDisplayObject.position, POS_UP_DURATION, {
			ease: untyped Back.easeOut.config(POS_UP_PARAM),
			x:lPos.x,
			y:lPos.y
		} );
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
	
	
	public static function lowerAlpha (pDisplayObject:DisplayObject, ?pCallBack:Void -> Void):Void {
		TribunalPopin.doTween = true;
		pDisplayObject.interactive = false;
		TweenMax.to(pDisplayObject, LOWER_ALPHA_DURATION, {
			onComplete:pCallBack,
			ease: untyped Back.easeOut.config(POS_UP_PARAM),
			alpha:0
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
	public static function positionElasticAttract (pDisplayObject:Container, pTarget:Point, ?pChangeContainer:Container, ?pCallBack:Void -> Void, ?pUnlock:Bool):Void {
		var lDuration:Float = POSITION_ELASTIC_ATTRACT_DURATION;
		var lParam1:Float = POSITION_ELASTIC_ATTRACT_PARAM_1;
		var lParam2:Float = POSITION_ELASTIC_ATTRACT_PARAM_2;
		var lPosFinalY:Float = pTarget.y - pDisplayObject.height / 2;
		
		if (pUnlock) {
			lDuration = POSITION_ELASTIC_ATTRACT_DURATION_UNLOCK;
			lParam1 = POSITION_ELASTIC_ATTRACT_PARAM_1_UNLOCK;
			lParam1 = POSITION_ELASTIC_ATTRACT_PARAM_2_UNLOCK;
			lPosFinalY = pTarget.y;
		}
		
		if (pChangeContainer != null) {
			var lNewPos:Point = pChangeContainer.toLocal(pDisplayObject.position, pDisplayObject.parent);
			pChangeContainer.addChild(pDisplayObject);
			pDisplayObject.position = lNewPos;
		}
		
		if (pDisplayObject != null)
		TweenMax.to(pDisplayObject, lDuration, { 
			onComplete:pCallBack,
			ease: untyped Elastic.easeOut.config(lParam1, lParam2),
			x:pTarget.x,
			y:lPosFinalY
		} );
	}
	
	public static function positionAndRescal(pDisplayObject:Container, pTarget:Point, ?pChangeContainer:Container, ?pCallBack:Void -> Void, ?pIcone:UISprite):Void {
		if (pChangeContainer != null) {
			var lNewPos:Point = pChangeContainer.toLocal(pDisplayObject.position, pDisplayObject.parent);
			pChangeContainer.addChild(pDisplayObject);
			pDisplayObject.position = lNewPos;
		}
		
		new TimelineMax().to(pDisplayObject, POSITION_ELASTIC_ATTRACT_DURATION_UNLOCK, {
			x: pTarget.x, 
			y: pTarget.y 
		}).to(pDisplayObject.scale, RESCALE_UNLOCK_DURATION, { 
			onComplete:pCallBack,
			ease: untyped Back.easeOut.config(RESCALE_UNLOCK_PARAM),
			x: RESCALE_UNLOCK, 
			y: RESCALE_UNLOCK 
		}, "+=0.001").to(pIcone.scale, RESCALE_UNLOCK_DURATION_PLUS, { 
			x: RESCALE_UNLOCK_PLUS, 
			y: RESCALE_UNLOCK_PLUS 
		}, "-=0.5").to(pIcone.scale, RESCALE_UNLOCK_DURATION_PLUS, { 
			x: 1, 
			y: 1
		}, "-=0.01");
	}
	
	// used on camera after a move
	/**
	 * Factor that can extend smooth duration.
	 * Factor that is mutltiplied by the speed (in px by frame) to add additionnal time (in second)
	 * (only the last frame is counted before mouseUp)
	 * For example: a speed of 100px/frame would extend duration by one second whit 0.01 as setting
	 */
	private static inline var LINEAR_SLOW_DURATION_FACTOR:Float = 0.01;
	/**
	 * Factor that can make the linear slow go futher.
	 * It is multiplied by the speed and then added to the target position
	 * to obtain the end position of the tween.
	 * Example : a speed (px/frame) of 100, will make the object tween over 3000px whit 30 as setting.
	 */
	private static inline var LINEAR_SLOW_DISTANCE_FACTOR:Float = 30;
	private static inline var LINEAR_SLOW_MAX_DURATION:Float = 5;
	private static inline var LINEAR_SLOW_MIN_DURATION:Float = 1;
	
	/**
	 * 
	 * @param	pDisplayObject
	 * @param	pSpeed
	 * @return	killFunction
	 */
	public static function linearSlow (pDisplayObject:Container, pSpeed:Point, pOnUpdate:Void->Void):Void -> Animation {
		var myTween:TweenMax = TweenMax.to(
			pDisplayObject,
			Math.min(
				Math.max(
					LINEAR_SLOW_MIN_DURATION, 
					LINEAR_SLOW_DURATION_FACTOR * magnitude(pSpeed)
				),
				LINEAR_SLOW_MAX_DURATION
			),
			{
				onUpdate:pOnUpdate,
				ease: Power1.easeOut,
				x:pDisplayObject.x + pSpeed.x * LINEAR_SLOW_DISTANCE_FACTOR,
				y:pDisplayObject.y + pSpeed.y * LINEAR_SLOW_DISTANCE_FACTOR
			}
		);
		// difficulty to find the good type that correspond to myTween.kill
		return untyped myTween.kill;
	}
	
	public static function magnitude (pPoint:Point) {
		return Math.sqrt(pPoint.x * pPoint.x + pPoint.y * pPoint.y);
	}
	
	public static function normalize (pPoint:Point) {
		var length:Float = magnitude(pPoint);
		if (length == 0)
			return pPoint;
		pPoint.x /= length;
		pPoint.y /= length;
		return pPoint;
	}
}