package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartButton {

	private var image:UISprite;
	private var buildingName:String;
	private var isInit:Bool;
	
	public function new(pAsset:String) {
		super(pAsset);
	}
	
	public function init (pBuildingName:String):Void {
		buildingName = pBuildingName;
		isInit = true;
		buildCard();
	}
	
	/*override public function build(pFrame:Int = 0):Void {
		super.build(pFrame);
		trace("buildsecond");
		
	}*/
	
	override private function _mouseDown (pEvent:EventTarget = null): Void {
		super._mouseDown(pEvent);
		if (isInit) // i've tried using build funciton override, doesn't seem to work
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
	
	public function start ():Void {
		/*interactive = true;
		on(MouseEventType.CLICK, onClick);*/
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		
		lImage.init();
		lImage.width = image.width;
		lImage.height = image.height;
		image.addChild(lImage);
		lImage.x = 0;
		lImage.y = 0;
		lImage.start();
		
		
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
}