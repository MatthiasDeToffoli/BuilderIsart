package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import js.Browser;
import pixi.core.graphics.Graphics;

typedef EventParallax = {
	var x:Float;
	var y:Float;
	var index:Int;
}

/**
 * ...
 * @author ambroise
 */
class ParallaxManager {

	private static inline var EVENT_PARALLAX = "parallax";
	private static var instance:ParallaxManager;
	private var layers:Array<Graphics>;
	
	public static function getInstance (): ParallaxManager {
		if (instance == null) instance = new ParallaxManager();
		return instance;
	}
	
	public function new () {
		
	}
	
	public function init ():Void {
		if (untyped Browser.window.eventParallax != null)
			untyped Browser.window.eventParallax.on(EVENT_PARALLAX, onSetPosition);
		else
			Debug.warn("window.eventParallax not set !");
			
		/*layers = [
			createDebug(),
			createDebug(),
			createDebug(),
			createDebug(),
			createDebug()
		]; */
	}
	
	private function onSetPosition (pEvent:EventParallax):Void {
		//trace(pEvent);
		/*if (layers[pEvent.index] != null) {
			layers[pEvent.index].x = pEvent.x;
			layers[pEvent.index].y = pEvent.y;
		} else {
			Debug.warn("Parallax: Missing layer.");
		}*/
	}
	
	private function createDebug ():Graphics {
		var myGraphic:Graphics = new Graphics();
		myGraphic.beginFill(0xFA00AF, 1);
		
		myGraphic.drawRect(
			0,
			0,
			100,
			100
		);
		myGraphic.endFill();
		
		GameStage.getInstance().getHudContainer().addChild(myGraphic);
		return myGraphic;
	}
	
	public function destroy (): Void {
		untyped Browser.window.eventParallax.off(EVENT_PARALLAX, onSetPosition);
		instance = null;
	}
}