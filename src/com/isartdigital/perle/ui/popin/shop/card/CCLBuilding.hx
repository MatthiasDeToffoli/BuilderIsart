package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.BuildingName;

/**
 * ...
 * @author ambroise
 */
class CCLBuilding extends CarouselCardLock{

	public function new() {
		super();
	}
	
	override function buildCard():Void {
		super.buildCard();
		SmartPopinExtended.setImage(image, BuildingName.getAssetName(buildingName));
	}
	
}