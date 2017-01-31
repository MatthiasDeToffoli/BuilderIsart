package com.isartdigital.perle.utils;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.html.EventTarget;
import pixi.core.display.DisplayObject;

/**
 * ...
 * @author ambroise
 */
class Interactive{

	public static function addListenerClick (pElement:DisplayObject, pCallBack:Void->Void, ?pContext:Dynamic):Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP){			
			pElement.addListener(MouseEventType.CLICK, pCallBack, pContext);
		}
		else
			pElement.addListener(TouchEventType.TAP, pCallBack, pContext);
	}
	
	public static function addListenerRewrite(pElement:DisplayObject, pCallback:Void->Void):Void {
		pElement.addListener(MouseEventType.MOUSE_DOWN, pCallback);
		pElement.addListener(MouseEventType.MOUSE_OUT, pCallback);
		pElement.addListener(MouseEventType.MOUSE_OVER, pCallback);
		pElement.addListener(MouseEventType.MOUSE_UP, pCallback);			
		pElement.addListener(MouseEventType.MOUSE_UP_OUTSIDE, pCallback);	
	}
	
	public static function removeListenerClick (pElement:DisplayObject, pCallBack:Void->Void, ?pOnce:Dynamic):Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP){
			
			pElement.removeListener(MouseEventType.CLICK, pCallBack, pOnce);
		}
		else
			pElement.removeListener(TouchEventType.TAP, pCallBack, pOnce);
	}
	
	public static function removeListenerRewrite(pElement:DisplayObject, pCallback:Void->Void):Void{
		pElement.removeListener(MouseEventType.MOUSE_DOWN, pCallback);
		pElement.removeListener(MouseEventType.MOUSE_OUT, pCallback);
		pElement.removeListener(MouseEventType.MOUSE_OVER, pCallback);
		pElement.removeListener(MouseEventType.MOUSE_UP, pCallback);
		pElement.removeListener(MouseEventType.MOUSE_UP_OUTSIDE, pCallback);
	}
	
	public function new() {
		
	}
	
}