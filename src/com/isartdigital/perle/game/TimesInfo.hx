package com.isartdigital.perle.game;

typedef Clock = {
	var houre:String;
	var minute :String;
	var seconde:String;
}
/**
 * ...
 * @author de Toffoli Matthias
 */
class TimesInfo
{

	public static inline var DECSEC:Int = 100;
	public static inline var SEC:Int = 10 * DECSEC;
	public static inline var MIN:Int = 60 * SEC;
	public static inline var HOU:Int = 60 * MIN;
	
	public static function getClock(pTime:Float):Clock {		
		
		var lDate:Date = Date.fromTime(pTime);
	
		return {
			houre: lDate.getHours() < 10 ? "0" + lDate.getHours() : "" + lDate.getHours(),
			minute:lDate.getMinutes() < 10 ? "0" + lDate.getMinutes() : "" + lDate.getMinutes(),
			seconde:lDate.getSeconds() < 10 ? "0" + lDate.getSeconds() : "" + lDate.getSeconds()
		}
	}
	
	/**
	 * calcul difference between two date without GMT
	 * @param	pTime1 first date getTime
	 * @param	pTime2 second date getTime
	 * @return the getTIme of the difference
	 */
	public static function calculDateDiff(pTime1:Float, pTime2:Float):Float {
		var date1:Date = Date.fromTime(pTime1), date2:Date = Date.fromTime(pTime2), now:Date = Date.now();
		
		var houres:Int = date1.getHours() - date2.getHours();		
		var minutes:Int = date1.getMinutes() - date2.getMinutes();
		var secondes:Int = date1.getSeconds() - date2.getSeconds();
		if (secondes < 0) {
			secondes = 60 + secondes;
			minutes--;
		}
		if (minutes < 0) {
			minutes = 60 + minutes;
			houres--;
		}
		
		if (houres < 0)
			houres = 24 + houres;
			
		return new Date(now.getFullYear(), now.getMonth(), now.getDay(), houres, minutes, secondes).getTime();
		
	}
	
	
}