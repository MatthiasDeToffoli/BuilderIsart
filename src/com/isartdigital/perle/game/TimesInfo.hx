package com.isartdigital.perle.game;

typedef Clock = {
	var day:String;
	var hour:String;
	var minute :String;
	var seconde:String;
}

typedef TimesAndNumberDays = {
	var days:Int;
	var times:Float;
}
/**
 * ...
 * @author de Toffoli Matthias
 */
class TimesInfo
{

	public static inline var ZERO:Int = 0;
	public static inline var TEN:Int = 10;
	public static inline var SIXTY:Int = 60;
	public static inline var TWENTYFOUR:Int = 24;
	public static inline var THIRTYONE:Int = 31;
	
	public static inline var DECSEC:Int = 100;
	public static inline var SEC:Int = 10 * DECSEC;
	public static inline var MIN:Int = SIXTY * SEC;
	public static inline var HOU:Int = SIXTY * MIN;
	public static inline var DAY:Int = TWENTYFOUR * HOU;
	
	public static function getClock(pTime:TimesAndNumberDays):Clock {		
		
		var lDate:Date = Date.fromTime(pTime.times);
		trace(lDate.getHours());
	
		return {
			day: pTime.days + "",
			hour: lDate.getHours() < TEN ? "0" + lDate.getHours() : "" + lDate.getHours(),
			minute:lDate.getMinutes() < TEN ? "0" + lDate.getMinutes() : "" + lDate.getMinutes(),
			seconde:lDate.getSeconds() < TEN ? "0" + lDate.getSeconds() : "" + lDate.getSeconds()
		}
	}
	
	public static function getTimeInMilliSecondFromTimeStamp(pTime:Float):Float {
		return getTimeInMilliSecondFromDate(Date.fromTime(pTime));
	}
	public static function getTimeInMilliSecondFromDate(pDate:Date):Float {
		return (pDate.getDay()) * DAY + (pDate.getHours()) * HOU + pDate.getMinutes() * MIN + pDate.getSeconds() * SEC;
	}
	
	/**
	 * calcul difference between two date without GMT
	 * @param	pTime1 first date getTime
	 * @param	pTime2 second date getTime
	 * @return the getTIme of the difference
	 */
	public static function calculDateDiff(pTime1:Float, pTime2:Float):TimesAndNumberDays {
		var date1:Date = Date.fromTime(pTime1), date2:Date = Date.fromTime(pTime2), now:Date = Date.now();
		trace(date1.getDate(), date2.getDate());
		var lDays:Int = date1.getDate() - date2.getDate();
		var hours:Int = date1.getHours() - date2.getHours();		
		var minutes:Int = date1.getMinutes() - date2.getMinutes();
		var secondes:Int = date1.getSeconds() - date2.getSeconds();
		
		if (secondes < ZERO) {
			secondes = SIXTY + secondes;
			minutes--;
		}
		if (minutes < ZERO) {
			minutes = SIXTY + minutes;
			hours--;
		}
		
		if (hours < ZERO){
			hours = TWENTYFOUR + hours;
			lDays--;
		}
		
		if (lDays < ZERO) {
			lDays = THIRTYONE + lDays;
		}
		trace(lDays, hours, minutes, secondes);
		return {
			times:new Date(date1.getFullYear(), date1.getMonth(), date1.getDay(), hours, minutes, secondes).getTime(),
			days: lDays
		}
		
	}
	
	
}