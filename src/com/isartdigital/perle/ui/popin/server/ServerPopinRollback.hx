package com.isartdigital.perle.ui.popin.server;
import com.isartdigital.perle.utils.Interactive;

/**
 * ...
 * @author ambroise
 */
class ServerPopinRollback extends ServerPopin{

	public function new() {
		super();
		
	}
	
	public function init ():Void {
		interactive = true;
		Interactive.addListenerClick(this , onClick);
	}
	
	public function setText (pString:String, pErrorCode:Int):Void {
		text.text = pString + "\n" + "ErrorCode: " + pErrorCode;
	}
	
	private function onClick ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
}