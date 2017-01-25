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

	public static function addListenerClick (pElement:DisplayObject, pCallBack:Void->Void, ?pContext:Dynamic, ?pCallback2:Void ->Void):Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP){			
			pElement.addListener(MouseEventType.CLICK, pCallBack, pContext);
			
			if (pCallback2 != null) {
				pElement.addListener(MouseEventType.MOUSE_DOWN, pCallback2);
				pElement.addListener(MouseEventType.MOUSE_OUT, pCallback2);
				pElement.addListener(MouseEventType.MOUSE_OVER, pCallback2);
				pElement.addListener(MouseEventType.MOUSE_UP, pCallback2);			
				pElement.addListener(MouseEventType.MOUSE_UP_OUTSIDE, pCallback2);			
				
			}
		}
		else
			pElement.addListener(TouchEventType.TAP, pCallBack, pContext);
	}
	
	public static function removeListenerClick (pElement:DisplayObject, pCallBack:Void->Void, ?pOnce:Dynamic, ?pCallback2:Void ->Void):Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP){
			
			pElement.removeListener(MouseEventType.CLICK, pCallBack, pOnce);
			
			if (pCallback2 != null) {
				pElement.removeListener(MouseEventType.MOUSE_DOWN, pCallback2);
				pElement.removeListener(MouseEventType.MOUSE_OUT, pCallback2);
				pElement.removeListener(MouseEventType.MOUSE_OVER, pCallback2);
				pElement.removeListener(MouseEventType.MOUSE_UP, pCallback2);
				pElement.removeListener(MouseEventType.MOUSE_UP_OUTSIDE, pCallback2);
			}
		}
		else
			pElement.removeListener(TouchEventType.TAP, pCallBack, pOnce);
	}
	
	public function new() {
		
	}
	
}