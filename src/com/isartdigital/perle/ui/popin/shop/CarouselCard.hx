package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartComponent{

	private var buildingAssetName:String;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
	}
	
	public function init (pBuildingAssetName:String):Void {
		buildingAssetName = pBuildingAssetName;
		// image = pBuildingAssetName ....
		// text idem voir buyManager ?
	}
	
	public function start ():Void {
		interactive = true;
		on(MouseEventType.CLICK, onClick);
	}
	
	private function onClick ():Void {
		trace("helosd");
		ConfirmBuyBuilding.getInstance().setBuildingAssetName(buildingAssetName);
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
	}
	
}