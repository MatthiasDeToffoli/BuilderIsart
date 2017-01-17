package com.isartdigital.perle.game;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author ambroise
 */
class BuildingName {
	
	// must be the same in DataBase, using :
	// https://docs.google.com/spreadsheets/d/17B04Xh_cVsphxShcZkTF5gaAnVa44Kt6XaD52CrBSg4/edit#gid=510099668
	public static inline var STYX_PURGATORY:String = "Purgatory";
	public static inline var STYX_VICE:String = "Altar Vice";
	public static inline var STYX_VIRTUE:String = "Altar Virtue";
	public static inline var STYX_MARKET:String = "Market";
	
	
	public static inline var HEAVEN_HOUSE:String = "Heaven House"; 
	public static inline var HEAVEN_COLLECTOR:String = "Heaven Collector Lumber Mill";
	public static inline var HEAVEN_MARKETING_DEPARTMENT:String = "Marketing Department";
	public static inline var HEAVEN_DECO_GENERIC_TREE:String = "Generic Tree";
	public static inline var HEAVEN_DECO_BIGGER_TREE:String = "Bigger Tree";
	public static inline var HEAVEN_DECO_PRETTY_TREE:String = "Pretty Tree";
	public static inline var HEAVEN_DECO_AWESOME_TREE:String = "Awesome Tree";
	public static inline var HEAVEN_DECO_BUILDING:String = "Heaven Building";
	public static inline var HEAVEN_DECO_GORGEOUS_BUILDING:String = "Heaven Gorgeous Building";
	
	
	public static inline var HELL_HOUSE:String = "Hell House";
	public static inline var HELL_COLLECTOR:String = "Hell Collector Iron Mines";
	public static inline var HELL_FACTORY:String = "Factory";
	public static inline var HELL_DECO_GENERIC_ROCK:String = "Generic Rock";
	public static inline var HELL_DECO_BIGGER_ROCK:String = "Bigger Rock";
	public static inline var HELL_DECO_PRETTY_ROCK:String = "Pretty Rock";
	public static inline var HELL_DECO_AWESOME_ROCK:String = "Awesome Rock";
	public static inline var HELL_DECO_BUILDING:String = "Hell Building";
	public static inline var HELL_DECO_GORGEOUS_BUILDING:String = "Hell Gorgeous Building";
	
	
	public static inline var HOUSE_INTERNS:String = "Intern Building"; 
	
	
	// ASSETNAME_TO_VCLASS à changer pr BUILDING_NAME_TO_VCLASS (après alpha plutot)
	// ajouter le buildingName comme ceci dans les Vclass: var myBuildingName:String;
	// dans le super() faire: myBuildingName = BuildingName.HEAVEN_HOUSE;
	// oui on remarquera que cela peut sembler redondans avec le nom de class.
	
	// Pour tout ce qui touche de la config cela diparaitrera avec la BDD donc osef.
	
	// du coup dans TileDescription yaura plus assetName ou className
	// mais seulement BuildingName
	
	// ainsi à partir du tableau ci-dessous il pourra déterminer quel est sont graphique correspondant
	// et au stade d'évolution du batimeent correspondant.
	
	// dans traduciton : assetNameNameToTrad à changer pr buildingNameToTrad
	
	public static function getAssetName (pBuildingName:String, pLevel:Int = 0):String {
		if (BUILDING_NAME_TO_ASSETNAMES[pBuildingName] == null ||
			BUILDING_NAME_TO_ASSETNAMES[pBuildingName][pLevel] == null)
			Debug.error("AssetName for BuildingName : '"+pBuildingName+"' not found, for level : "+pLevel);
		
		return BUILDING_NAME_TO_ASSETNAMES[pBuildingName][pLevel];
	}
	
	
	public static var BUILDING_NAME_TO_ASSETNAMES(default, never):Map<String, Array<String>> = [
		HEAVEN_HOUSE 					=> [AssetName.BUILDING_HEAVEN_HOUSE, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3],
		HEAVEN_COLLECTOR 				=> [AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL1, AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL2],
		HEAVEN_MARKETING_DEPARTMENT 	=> [AssetName.BUILDING_HEAVEN_HOUSE],
		HEAVEN_DECO_GENERIC_TREE 		=> [AssetName.DECO_HEAVEN_TREE_1],
		HEAVEN_DECO_BIGGER_TREE 		=> [AssetName.DECO_HEAVEN_TREE_2],
		HEAVEN_DECO_PRETTY_TREE 		=> [AssetName.DECO_HEAVEN_TREE_3],
		HEAVEN_DECO_AWESOME_TREE 		=> [AssetName.DECO_HEAVEN_TREE_3],
		HEAVEN_DECO_BUILDING 			=> [AssetName.BUILDING_HEAVEN_HOUSE],
		HEAVEN_DECO_GORGEOUS_BUILDING 	=> [AssetName.BUILDING_HEAVEN_HOUSE],
		
		HELL_HOUSE 						=> [AssetName.BUILDING_HELL_HOUSE, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3],
		HELL_COLLECTOR 					=> [AssetName.BUILDING_HELL_COLLECTOR_LEVEL1],
		HELL_FACTORY 					=> [AssetName.BUILDING_HELL_HOUSE],
		HELL_DECO_GENERIC_ROCK 			=> [AssetName.DECO_HELL_ROCK],
		HELL_DECO_BIGGER_ROCK 			=> [AssetName.DECO_HELL_ROCK],
		HELL_DECO_PRETTY_ROCK 			=> [AssetName.DECO_HELL_ROCK],
		HELL_DECO_AWESOME_ROCK 			=> [AssetName.DECO_HELL_ROCK],
		HELL_DECO_BUILDING 				=> [AssetName.BUILDING_HELL_HOUSE],
		HELL_DECO_GORGEOUS_BUILDING 	=> [AssetName.BUILDING_HELL_HOUSE],
		
		STYX_PURGATORY					=> [AssetName.BUILDING_STYX_PURGATORY],
		STYX_VICE 						=> [AssetName.BUILDING_STYX_VIRTUE],
		STYX_VIRTUE 					=> [AssetName.BUILDING_STYX_VIRTUE],
		STYX_MARKET 					=> [AssetName.BUILDING_HELL_HOUSE],
		
		HOUSE_INTERNS 					=> [AssetName.BUILDING_HELL_HOUSE],
		
	];
}