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
		BuildingName.HELL_DECO_SMALL_CRYSTAL,
		BuildingName.HEAVEN_DECO_BIGGER_TREE,
		BuildingName.HELL_DECO_BIGGER_CRYSTAL,
		
		BuildingName.HEAVEN_DECO_CLOUD,
		BuildingName.HELL_DECO_DEAD_HEAD,
		BuildingName.HEAVEN_DECO_LAKE,
		BuildingName.HELL_DECO_LAVA_SOURCE,
		
		BuildingName.HEAVEN_DECO_PARK,
		BuildingName.HELL_DECO_BONES,
		
	];
	
	public static function isInArray(pAssetName:String):Bool {
		for (i in 0...NAME_LIST.length)
			if (pAssetName == NAME_LIST[i])
				return true;
		return false;
	}
	
	public function new() {
		super();
	}
	
	override function getCardToShowOverride ():Array<String> {
		return NAME_LIST;
	}
	
}