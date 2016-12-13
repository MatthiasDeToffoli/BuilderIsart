package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import haxe.Timer;

interface ZTimeBased 
{
	private function onTimeEnd ():Void;
}

typedef TimeElement = {
	var desc:TimeDescription; // desc will be saved, but if there is only desc i won't need it, lol
	var callBack:Void->Void;
	// todo : lien direct vers élément, variable en référence
}


/**
 * Control every TimeBased Mechanic (working constantly like a server)
 * @author ambroise
 */
class TimeManager {
	
	/**
	 * Update all timers and save every TIME_LOOP_DELAY.
	 */
	private static inline var TIME_LOOP_DELAY:Int = 10000;
	
	public static var gameStartTime(default, null):Float;
	public static var lastKnowTime(default, null):Float;
	
	public static var list(default, null):Array<TimeElement>;
	
	public static function initClass ():Void {
		list = new Array<TimeElement>();
	}
	
	public static function buildWhitoutSave ():Void {
		gameStartTime = Date.now().getTime();
		startTimeLoop();
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:Int = pSave.times.length;
		for (i in 0...lLength) {
			list.push({
				desc: pSave.times[i],
				callBack: null // todo à partir de .desc
			});
		}
		
		startTimeLoop();
	}
	
	private static function getElapsedTime (pLastKnowTime:Float, pTimeNow:Float):Float {
		return pTimeNow - pLastKnowTime;
	}
	
	private static function startTimeLoop ():Void {
		Timer.delay(timeLoop, TIME_LOOP_DELAY);
	}
	
	private static function timeLoop ():Void {
		lastKnowTime = Date.now().getTime();
		var elapsedTime:Float = getElapsedTime(SaveManager.currentSave.lastKnowTime, lastKnowTime);
		var lLength:Int = list.length;
		
		SaveManager.saveLastKnowTime(lastKnowTime);
		
		for (i in 0...lLength) {
			update(list[i], elapsedTime);
		}
	}
	
	/**
	 * Add Elapsed time to
	 * @param	pElement
	 * @param	pElapsedTime
	 */
	private static function update (pElement:TimeElement, pElapsedTime:Float):Void {
		pElement.desc.progress = Math.min(
			pElement.desc.progress + pElapsedTime/1000, // to have seconds
			pElement.desc.end
		);
		
		if (pElement.desc.progress == pElement.desc.end)
			pElement.callBack();
	}

	public function new() {
		
	}
	
}