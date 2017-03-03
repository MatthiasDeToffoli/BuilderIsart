package com.isartdigital.perle.ui.hud.dialogue;
import com.isartdigital.utils.ui.smart.TextSprite;
import haxe.Timer;
import js.Lib;

/**
 * ...
 * @author ambroise
 */
class DialoguePoppinText {
	
	
	
	private static inline var INTERVAL:Int = 50;
	/**
	 * Char where there is additionnal wait time.
	 * Pause char don't stack if more then one in first word, the higtest is taken.
	 */
	private var PAUSE_CHAR(default, never):Map<String, Int> = [
        "." => 700,
        "," => 350
    ];
	
	public var isFullTextVisible:Bool = false;
	private var text:String;
	private var textArray:Array<String>;
	private var currentText:String = "";
	private var index:Int;
	private var additionnalTime :Int;
	private var timer:Timer;
	private var textDisplay:TextSprite;
	
	public function new () {
		
	}
	
	public function init (pTextSprite:TextSprite, pText:String):Void {
		index = 0;
		additionnalTime = 0;
		textDisplay = pTextSprite;
		text = pText;
		textArray = text.split(" ");
	}
	
	public function start ():Void {
		timer = Timer.delay(customLoop,  INTERVAL + additionnalTime);
	}
	
	private function customLoop ():Void {
        if (index >= textArray.length) {
			onFullTextVisible();
            return;
        }
        updateText();
        updateTimer();
    }
	
	private function updateTimer ():Void {
		timer = Timer.delay(customLoop,  INTERVAL + additionnalTime);
        additionnalTime = 0;
	}
	
	private function updateText ():Void {
		for (char in PAUSE_CHAR.keys()) {
			if (textArray[index].indexOf(char) != -1)
				additionnalTime = PAUSE_CHAR[char];
        }
		
        currentText = currentText + textArray[index++] + " ";
        textDisplay.text = currentText;
	}
	
	private function onFullTextVisible ():Void {
		isFullTextVisible = true;
		timer.stop();
	}

    public function onClick ():Void {
		timer.stop();
        textDisplay.text = text;
    }
	
}



    

    