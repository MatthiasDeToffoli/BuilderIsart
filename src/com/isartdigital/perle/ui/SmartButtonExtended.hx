package com.isartdigital.perle.ui;

import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.interaction.EventTarget;

/**
 * Rebuild btn at every state of the btn
 * To make it work you need to put isInit to true and override buildCard.
 * (look CarouselCard.hx for example)
 * @author ambroise
 */
class SmartButtonExtended extends SmartButton{

	/**
	 * Add it in the init function, or buildcard will never be called.
	 */
	private var isInit:Bool;
	
	public function new(pID:String=null) {
		super(pID);
		
	}
	
	override private function _mouseDown (pEvent:EventTarget = null): Void {
		super._mouseDown(pEvent);
		if (isInit) // i've tried using build function override, doesn't seem to work
			buildCard();
	}
	
	override private function _mouseOver (pEvent:EventTarget = null): Void {
		super._mouseOver(pEvent);
		if (isInit)
			buildCard();
	}
	
	override private function _mouseOut (pEvent:EventTarget = null): Void {
		super._mouseOut(pEvent);
		if (isInit)
			buildCard();
	}
	
	private function buildCard ():Void {}
	
}