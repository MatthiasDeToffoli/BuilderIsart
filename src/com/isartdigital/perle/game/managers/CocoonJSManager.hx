package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Config;
import js.Browser;

/**
 * Interface to CocoonJs API
 * http://cocoonio.github.io/cocoon-canvasplus/dist/doc/js/Cocoon.App.html#toc18
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