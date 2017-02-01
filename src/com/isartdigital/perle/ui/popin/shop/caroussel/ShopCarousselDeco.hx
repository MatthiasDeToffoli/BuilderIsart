package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.BuildingName;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselDeco extends ShopCarousselDecoBuilding{

	private static var NAME_LIST(default, never):Array<String> = [
		BuildingName.HEAVEN_DECO_GENERIC_TREE,
		BuildingName.HEAVEN_DECO_BIGGER_TREE,
		BuildingName.HEAVEN_DECO_PRETTY_TREE,
		BuildingName.HEAVEN_DECO_AWESOME_TREE,
		BuildingName.HEAVEN_DECO_BUILDING,
		BuildingName.HEAVEN_DECO_GORGEOUS_BUILDING,
		
		BuildingName.HELL_DECO_SMALL_CRYSTAL,
		BuildingName.HELL_DECO_BIGGER_CRYSTAL,
		BuildingName.HELL_DECO_DEAD_HEAD,
		BuildingName.HELL_DECO_BONES,
		BuildingName.HELL_DECO_LAVA_SOURCE,
		BuildingName.HELL_DECO_GORGEOUS_BUILDING,
	];
	
	public function new() {
		super();
	}
	
	override function getCardToShow():Array<String> {
		return NAME_LIST;
	}
	
}