package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartComponent{

	private var buildingAssetName:String;
	private var image:SmartComponent;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
		//SmartCheck.traceChildrens(this);
		image = cast(SmartCheck.getChildByName(this, "Item_Picture")); // todo : finir
	}
	
	public function init (pBuildingAssetName:String):Void {
		buildingAssetName = pBuildingAssetName;
		// image = pBuildingAssetName ....
		// text idem voir buyManager ?
		setImage();
	}
	
	public function start ():Void {
		interactive = true;
		on(MouseEventType.CLICK, onClick);
	}
	
	private function setImage ():Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(buildingAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();

	}
	
	private function onClick ():Void {
		trace("helosd");
		ConfirmBuyBuilding.getInstance().setBuildingAssetName(buildingAssetName);
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
	}
	
	override public function destroy():Void {
		removeListener(MouseEventType.CLICK, onClick);
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}