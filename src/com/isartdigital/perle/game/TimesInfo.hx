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

	public static inline var SEC:Int = 1000;
	public static inline var MIN:Int = 60 * SEC;
	public static inline var HOU:Int = 60 * MIN;
	
	public static function getClock(pTime:Float):Clock {
		var currentHou:Int = Math.floor(pTime / HOU);
		var currentMin:Int = Math.floor((pTime - currentHou * HOU) / MIN);
		var currentSec:Int = Math.floor((pTime - currentMin * MIN) / SEC);
		
		return {
			houre: currentHou < 10 ? "0" + currentHou:"" + currentHou,
			minute:currentMin < 10 ? "0" + currentMin:"" + currentMin,
			seconde:currentSec < 10 ? "0" + currentSec:"" + currentSec
		}
	}
	
	
}