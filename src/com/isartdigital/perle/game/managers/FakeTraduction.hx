package com.isartdigital.perle.game.managers;

/**
 * ...
 * @author ambroise
 */
class FakeTraduction{

	public static function assetNameNameToTrad (pAssetName:String):String { // todo : plus tard le buildingName
		var traduc:Map<String,String> = [
			AssetName.BUILDING_HEAVEN_HOUSE => "HEAVEN HOUSE",
			AssetName.BUILDING_HELL_HOUSE  => "HELL HOUSE",
			AssetName.BUILDING_HELL_BUILD_1  => "HELL HOUSE",
			AssetName.BUILDING_HELL_BUILD_2  => "HELL HOUSE",
			AssetName.BUILDING_HEAVEN_BUILD_1  => "HEAVEN HOUSE",
			AssetName.BUILDING_HEAVEN_BUILD_2  => "HEAVEN HOUSE",
			
			AssetName.LUMBERMIL_LEVEL1  => "LUMBERMIL",
			AssetName.QUARRY_LEVEL_1  => "QUARRY",
			//AssetName.BUILDING_HELL_BUILD_2  => "BUILDING_HELL_BUILD_2",
			//AssetName.BUILDING_HEAVEN_BUILD_1  => "BUILDING_HEAVEN_BUILD_1",
			AssetName.DECO_HEAVEN_VERTUE  => "VERTUE",
			
			AssetName.DECO_HELL_TREE_1  => "HELL TREE",
			AssetName.DECO_HEAVEN_TREE_1  => "HEAVEN TREE",
			AssetName.DECO_HEAVEN_FOUNTAIN  => "HEAVEN FOUNTAIN",
			AssetName.DECO_HEAVEN_TREE_2  => "HEAVEN TREE",
			
			AssetName.DECO_HEAVEN_TREE_3  => "HEAVEN TREE",
			AssetName.DECO_HEAVEN_ROCK  => "HEAVEN ROCK",
			AssetName.DECO_HELL_TREE_2  => "HELL TREE",
			AssetName.DECO_HELL_TREE_3  => "HELL TREE",
			
			AssetName.DECO_HELL_ROCK  => "HELL ROCK"
		];
		
		return traduc[pAssetName];
	}
	
	public function new() {
		
	}
	
}