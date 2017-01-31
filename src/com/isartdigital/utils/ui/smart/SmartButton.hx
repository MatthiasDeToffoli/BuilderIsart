package com.isartdigital.utils.ui.smart;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Mathieu Anthoine
 */
class SmartButton extends SmartComponent
{

	private var box:DisplayObject;
	
	public function new(pID:String=null) 
	{
		super(pID);
		modal = false;
		interactive = true;
		buttonMode = true;
		
		on(MouseEventType.MOUSE_OVER, _mouseOver);
		on(MouseEventType.MOUSE_DOWN, _mouseDown);
		on(MouseEventType.CLICK, _click);
		on(MouseEventType.MOUSE_OUT, _mouseOut);
		on(MouseEventType.MOUSE_UP_OUTSIDE, _mouseOut);
		
		on(TouchEventType.TOUCH_START, _mouseDown);
		on(TouchEventType.TAP, _click);
		on(TouchEventType.TOUCH_END, _mouseOut);
		on(TouchEventType.TOUCH_END_OUTSIDE, _mouseOut);
		
	}
	
	public function registerClick (pCallBack:EventTarget->Void):Void {
		on(MouseEventType.CLICK, pCallBack);
		on(TouchEventType.TAP, pCallBack);
	}
	
	public function unregisterClick (pCallBack:EventTarget->Void):Void {
		off(MouseEventType.CLICK, pCallBack);
		off(TouchEventType.TAP, pCallBack);
	}
	
	override public function build(pFrame:Int = 0):Void 
	{
		super.build(3);		
		hitArea = getBounds().clone();
		_mouseOut();
	}
	
	private function clear(): Void {
		while (children.length > 0) removeChildAt(0);
	}
	
	private function _click (pEvent:EventTarget=null): Void {
		_mouseOut();
	}	
	
	private function _mouseDown (pEvent:EventTarget=null): Void {
		clear();
		super.build(2);
	}
	
	private function _mouseOver (pEvent:EventTarget=null): Void {
		clear();
		super.build(1);
	}
	
	private function _mouseOut (pEvent:EventTarget=null): Void {
		clear();
		super.build();
	}
	
	override public function destroy ():Void {
		off(MouseEventType.MOUSE_OVER, _mouseOver);
		off(MouseEventType.MOUSE_DOWN, _mouseDown);
		off(MouseEventType.CLICK, _click);
		off(MouseEventType.MOUSE_OUT, _mouseOut);
		off(MouseEventType.MOUSE_UP_OUTSIDE, _mouseOut);
		
		off(TouchEventType.TOUCH_START, _mouseDown);
		off(TouchEventType.TAP, _click);
		off(TouchEventType.TOUCH_END, _mouseOut);
		off(TouchEventType.TOUCH_END_OUTSIDE, _mouseOut);

		super.destroy();
	}
	
}