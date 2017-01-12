package com.isartdigital.perle.game;

/**
 * ...
 * @author ambroise
 */
class BuildingName {

	public static inline var HEAVEN_HOUSE = "Heaven_House"; // doit êter pareil en BDD
	public static inline var HELL_HOUSE = "Hell_House"; // doit êter pareil en BDD
	
	
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
	
	
	public static var BUILDING_NAME_TO_ASSETNAMES(default, never):Map<String, Array<String>> = [
		HEAVEN_HOUSE => [AssetName.BUILDING_HEAVEN_HOUSE, AssetName.BUILDING_HEAVEN_BUILD_2] // ds le cas ou heavenhouse possède une upgrade
		HELL_HOUSE => [AssetName.BUILDING_HELL_HOUSE]
	];
}