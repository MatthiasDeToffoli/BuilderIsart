package com.isartdigital.perle.game.managers;

/**
 * ...
 * @author ambroise
 */
class FakeTraduction{

	public static function assetNameNameToTrad (pAssetName:String):String { // todo : plus tard le buildingName
		var traduc:Map<String,String> = [
			AssetName.BUILDING_HEAVEN_HOUSE => "BUILDING_HEAVEN_HOUSE",
			AssetName.BUILDING_HELL_HOUSE  => "BUILDING_HELL_HOUSE",
			AssetName.BUILDING_HELL_BUILD_1  => "BUILDING_HELL_BUILD_1",
			AssetName.BUILDING_HEAVEN_BUILD_2  => "BUILDING_HEAVEN_BUILD_2",
			
			AssetName.LUMBERMIL_LEVEL1  => "LUMBERMIL_LEVEL1",
			AssetName.BUILDING_HELL_BUILD_2  => "BUILDING_HELL_BUILD_2",
			AssetName.BUILDING_HEAVEN_BUILD_1  => "BUILDING_HEAVEN_BUILD_1",
			AssetName.DECO_HEAVEN_VERTUE  => "DECO_HEAVEN_VERTUE",
			
			AssetName.DECO_HELL_TREE_1  => "DECO_HELL_TREE_1",
			AssetName.DECO_HEAVEN_TREE_1  => "DECO_HEAVEN_TREE_1",
			AssetName.DECO_HEAVEN_FOUNTAIN  => "DECO_HEAVEN_FOUNTAIN",
			AssetName.DECO_HEAVEN_TREE_2  => "DECO_HEAVEN_TREE_2",
			
			AssetName.DECO_HEAVEN_TREE_3  => "DECO_HEAVEN_TREE_3",
			AssetName.DECO_HEAVEN_ROCK  => "DECO_HEAVEN_ROCK",
			AssetName.DECO_HELL_TREE_2  => "DECO_HELL_TREE_2",
			AssetName.DECO_HELL_TREE_3  => "DECO_HELL_TREE_3",
			
			AssetName.DECO_HELL_ROCK  => "DECO_HELL_ROCK"
		];
		
		return traduc[pAssetName];
	}
	
	public function new() {
		
	}
	
}