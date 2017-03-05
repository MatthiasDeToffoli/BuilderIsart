package com.isartdigital.perle.ui.hud.dialogue;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.TextSprite;
import haxe.Timer;
import js.Lib;
import pixi.core.display.DisplayObject;

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
	private var onFinish:Void->Void;
	private var skipClickZone:DisplayObject;
	
	public function new () {
		
	}
	
	/**
	 * Can be called as any times as needed whitout destroying this object.
	 * @param	pTextSprite The TextSprite containing the text that need to be changed.
	 * @param	pText The full text that will be displayed.
	 * @param	pSkipClickZone If set, a click on this zone will show instantly the full text.
	 * @param	pOnFinish Called when the full text is visible. (whit or whitout skip)
	 */
	public function init (pTextSprite:TextSprite, pText:String, ?pSkipClickZone:DisplayObject = null, ?pOnFinish:Void->Void = null):Void {
		index = 0;
		additionnalTime = 0;
		textDisplay = pTextSprite;
		text = pText;
		textArray = text.split(" ");
		onFinish = pOnFinish;
		skipClickZone = pSkipClickZone;
	}
	
	public function start ():Void {
		timer = Timer.delay(customLoop,  INTERVAL + additionnalTime);
		Interactive.addListenerClick(skipClickZone, onClick);
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
		if (onFinish != null)
			onFinish();
	}

    public function onClick ():Void {
		Interactive.removeListenerClick(skipClickZone, onClick);
		skipClickZone = null;
        textDisplay.text = text;
		onFullTextVisible();
		textDisplay.text = text; // just making sure txt is full since asynchrone :s
    }
	
}



    

    