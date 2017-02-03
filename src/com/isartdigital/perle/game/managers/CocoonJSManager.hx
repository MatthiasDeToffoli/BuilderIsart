package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Config;
import js.Browser;

/**
 * ...
 * @author ambroise
 */
class CocoonJSManager{

	public static function awake ():Void {
		untyped Browser.window.Cocoon.App.on("memorywarning", function() {
			
			if (Config.debug) // temporaire
				Browser.window.alert("memory problem detected (function from cocoonJs)");
		});
	}
	
}