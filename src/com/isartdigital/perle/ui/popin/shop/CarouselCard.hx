package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartButton {

	private var image:UISprite;
	private var buildingName:String;
	
	public function new(pAsset:String) {
		super(pAsset);
	}
	
	public function init (pBuildingName:String):Void {
		buildingName = pBuildingName;			
	}
	
	public function start ():Void {
		/*interactive = true;
		on(MouseEventType.CLICK, onClick);*/
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
}