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
	public static inline var STYX_VICE_1:String = "Altar Vice 1";
	public static inline var STYX_VICE_2:String = "Altar Vice 2";
	public static inline var STYX_VICE_3:String = "Altar Vice 3";
	public static inline var STYX_VIRTUE_1:String = "Altar Virtue 1";
	public static inline var STYX_VIRTUE_2:String = "Altar Virtue 2";
	public static inline var STYX_VIRTUE_3:String = "Altar Virtue 3";
	public static inline var STYX_DECO_BUILDING:String = "Styx Nice Building";
	public static inline var STYX_DECO_GORGEOUS_BUILDING:String = "Styx Gorgeous Building";
	
	
	public static inline var HEAVEN_HOUSE:String = "Heaven House"; 
	public static inline var HEAVEN_HOUSE_INTERNS:String = "Intern Building Heaven";
	public static inline var HEAVEN_COLLECTOR:String = "Heaven Collector Lumber Mill";
	public static inline var HEAVEN_MARKETING_DEPARTMENT:String = "Marketing Department";
	public static inline var HEAVEN_DECO_GENERIC_TREE:String = "Generic Tree";
	public static inline var HEAVEN_DECO_BIGGER_TREE:String = "Bigger Tree";
	public static inline var HEAVEN_DECO_CLOUD:String = "Cloud";
	public static inline var HEAVEN_DECO_LAKE:String = "Lake";
	public static inline var HEAVEN_DECO_PARK:String = "Park";
	
	
	public static inline var HELL_HOUSE:String = "Hell House";
	public static inline var HELL_HOUSE_INTERNS:String = "Intern Building Hell";
	public static inline var HELL_COLLECTOR:String = "Hell Collector Iron Mines";
	public static inline var HELL_FACTORY:String = "Factory";
	public static inline var HELL_DECO_SMALL_CRYSTAL:String = "Small Crystal";
	public static inline var HELL_DECO_BIGGER_CRYSTAL:String = "Bigger Crystal";
	public static inline var HELL_DECO_DEAD_HEAD:String = "Dead Head";
	public static inline var HELL_DECO_BONES:String = "Bones";
	public static inline var HELL_DECO_LAVA_SOURCE:String = "Lava Source";
	
	
	 
	 
	
	
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
	
	public static function getAssetName (pBuildingName:String, pLevel:Int = 0,?suffix:String = ""):String {
		if (BUILDING_NAME_TO_ASSETNAMES[pBuildingName] == null ||
			BUILDING_NAME_TO_ASSETNAMES[pBuildingName][pLevel] == null)
			Debug.error("AssetName for BuildingName : '"+pBuildingName+"' not found, for level : "+pLevel);
		
		return BUILDING_NAME_TO_ASSETNAMES[pBuildingName][pLevel] + suffix;
	}
	
	
	public static var BUILDING_NAME_TO_ASSETNAMES(default, never):Map<String, Array<String>> = [
		HEAVEN_HOUSE 					=> [AssetName.BUILDING_HEAVEN_HOUSE, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3],
		HEAVEN_HOUSE_INTERNS			=> [AssetName.BUILDING_INTERN_HEAVEN_HOUSE],
		HEAVEN_COLLECTOR 				=> [AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL1, AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL2],
		HEAVEN_MARKETING_DEPARTMENT 	=> [AssetName.MARKETING_HOUSE],
		HEAVEN_DECO_GENERIC_TREE 		=> [AssetName.DECO_HEAVEN_TREE_1],
		HEAVEN_DECO_BIGGER_TREE 		=> [AssetName.DECO_HEAVEN_TREE_2],
		HEAVEN_DECO_CLOUD		 		=> [AssetName.DECO_HEAVEN_CLOUD],
		HEAVEN_DECO_LAKE		 		=> [AssetName.DECO_HEAVEN_LAKE],
		HEAVEN_DECO_PARK	 			=> [AssetName.DECO_HEAVEN_PARK],
		
		HELL_HOUSE 						=> [AssetName.BUILDING_HELL_HOUSE, AssetName.BUILDING_HELL_HOUSE_LEVEL2, AssetName.BUILDING_HELL_HOUSE_LEVEL3],
		HELL_HOUSE_INTERNS				=> [AssetName.BUILDING_INTERN_HELL_HOUSE],
		HELL_COLLECTOR 					=> [AssetName.BUILDING_HELL_COLLECTOR_LEVEL1, AssetName.BUILDING_HELL_COLLECTOR_LEVEL2],
		HELL_FACTORY 					=> [AssetName.BUILDING_FACTORY],
		HELL_DECO_SMALL_CRYSTAL 		=> [AssetName.DECO_HELL_CRYSTAL_SMALL],
		HELL_DECO_BIGGER_CRYSTAL		=> [AssetName.DECO_HELL_CRYSTAL_BIG],
		HELL_DECO_DEAD_HEAD 			=> [AssetName.DECO_HELL_DEAD_HEAD],
		HELL_DECO_BONES		 			=> [AssetName.DECO_HELL_BONES],
		HELL_DECO_LAVA_SOURCE 			=> [AssetName.DECO_HELL_LAVA],
		
		STYX_PURGATORY					=> [AssetName.BUILDING_STYX_PURGATORY, AssetName.BUILDING_STYX_PURGATORY_LEVEL2, AssetName.BUILDING_STYX_PURGATORY_LEVEL3],
		STYX_VICE_1 					=> [AssetName.BUILDING_STYX_VIRTUE],
		STYX_VICE_2 					=> [AssetName.BUILDING_STYX_VIRTUE],
		STYX_VICE_3 					=> [AssetName.BUILDING_STYX_VIRTUE],
		STYX_VIRTUE_1 					=> [AssetName.BUILDING_STYX_VICE1],
		STYX_VIRTUE_2 					=> [AssetName.BUILDING_STYX_VICE2],
		STYX_VIRTUE_3 					=> [AssetName.BUILDING_STYX_VICE1],
	];
}