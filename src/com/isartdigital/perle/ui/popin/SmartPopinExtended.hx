package com.isartdigital.perle.ui.popin;

import com.greensock.TweenMax;
import com.isartdigital.utils.ui.smart.SmartPopin;

/**
 * ...
 * @author ambroise
 */
class SmartPopinExtended extends SmartPopin{

	private static inline var TWEEN_DURATION:Float = 0.5;
	private static inline var TWEEN_START_SCALE:Float = 0.8;
	private static inline var TWEEN_BACK_PARAM_1:Float = 1.2;
	
	public function new(pID:String=null) {
		super(pID);
		
	}
	
	override public function build(pFrame:Int = 0):Void {
		super.build(pFrame);
		tweenPopin();
	}
	
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