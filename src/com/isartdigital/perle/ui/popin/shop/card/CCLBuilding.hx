package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

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