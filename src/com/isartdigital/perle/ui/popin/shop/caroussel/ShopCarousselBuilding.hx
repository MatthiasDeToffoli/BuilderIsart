package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselDecoBuilding;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselBuilding extends ShopCarousselDecoBuilding{

	private static var NAME_LIST(default, never):Array<String> = [
	
		BuildingName.HELL_HOUSE,
		BuildingName.HEAVEN_HOUSE,
		
		BuildingName.STYX_VICE_1,
		BuildingName.STYX_VICE_2,
		BuildingName.STYX_VIRTUE_1,
		BuildingName.STYX_VIRTUE_2,
		
		BuildingName.HEAVEN_HOUSE_INTERNS,
		BuildingName.HEAVEN_COLLECTOR,
		BuildingName.HEAVEN_MARKETING_DEPARTMENT,
		
		BuildingName.HELL_COLLECTOR,
		BuildingName.HELL_FACTORY,		
		BuildingName.HELL_HOUSE_INTERNS,
	];
	
	public function new() {
		super();
	}
	
	override function getCardToShowOverride ():Array<String> {
		return NAME_LIST;
	}
}