package com.isartdigital.perle.game.managers;

/**
 * ...
 * @author ambroise
 */
class FakeTraduction{

	public static function assetNameNameToTrad (pBuildingName:String):String { // todo : plus tard le buildingName
		/*var traduc:Map<String,String> = [
			AssetName.BUILDING_HEAVEN_HOUSE => "HEAVEN HOUSE",
			AssetName.BUILDING_HELL_HOUSE  => "HELL HOUSE",
			
			AssetName.BUILDING_HELL_COLLECTOR_LEVEL1  => "LUMBERMIL",
			//AssetName.BUILDING_HELL_BUILD_2  => "BUILDING_HELL_BUILD_2",
			//AssetName.BUILDING_HEAVEN_BUILD_1  => "BUILDING_HEAVEN_BUILD_1",
			
			AssetName.DECO_HELL_TREE_1  => "HELL TREE",
			AssetName.DECO_HEAVEN_TREE_1  => "HEAVEN TREE",
			AssetName.DECO_HEAVEN_FOUNTAIN  => "HEAVEN FOUNTAIN",
			AssetName.DECO_HEAVEN_TREE_2  => "HEAVEN TREE",
			
			AssetName.DECO_HEAVEN_TREE_3  => "HEAVEN TREE",
			AssetName.DECO_HEAVEN_ROCK  => "HEAVEN ROCK",
			AssetName.DECO_HELL_TREE_2  => "HELL TREE",
			AssetName.DECO_HELL_TREE_3  => "HELL TREE",
			
			AssetName.DECO_HELL_ROCK  => "HELL ROCK",
			
			"Wood pack" => "Wood pack",
			"Iron pack" => "Iron pack",
			"Gold pack" => "Gold pack",
			"Karma pack" => "Karma pack"
		];*/
		
		/*if (traduc[pAssetName] != null) // hack temporaire car il faut tt remplacer par BuildingName
			return traduc[pAssetName];
		else*/
			return pBuildingName;
	}
	
	public function new() {
		
	}
	
}