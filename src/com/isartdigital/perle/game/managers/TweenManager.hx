package com.isartdigital.perle.game.managers;
import com.greensock.easing.Back;
import com.greensock.easing.Elastic;
import com.greensock.TweenMax;
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