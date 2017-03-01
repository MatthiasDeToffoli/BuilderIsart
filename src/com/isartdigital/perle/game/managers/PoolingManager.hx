package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author ambroise
 */
class PoolingManager {

	/**
	 * The pool will be fileld whit these instance at game start.
	 * Aucune raison de mettre un JSON, seul un codeur va modifié ces valeurs
	 * de toute façon.
	 */
	private static var INSTANCE_TO_SPAWN(default, never):Map<String, UInt> = [
		AssetName.BUILDING_HELL_HOUSE => 2,
		"Ground" => 400,
		"Road_h" => 1,
		"Road_c" => 1,
		"Road_br" => 1,
		"Road_tl" => 1,
		"Road_v" => 1,
		"FootPrint" => 20,
		AssetName.BUILDING_STYX_PURGATORY => 1
	];
	// todo : remplir
	private static var ASSETNAME_TO_CLASS(default, never):Map<String, String> = [
		AssetName.BUILDING_STYX_PURGATORY => "Tribunal",
		AssetName.BUILDING_STYX_PURGATORY_LEVEL2 => "Tribunal",
		AssetName.BUILDING_STYX_PURGATORY_LEVEL3=> "Tribunal",
		AssetName.BUILDING_STYX_VIRTUE_1 => "VirtuesBuilding",
		AssetName.BUILDING_STYX_VIRTUE_2 => "VirtuesBuilding",
		AssetName.BUILDING_STYX_VICE_1 => "VicesBuilding",
		AssetName.BUILDING_STYX_VICE_2 => "VicesBuilding",
		
	
		AssetName.BUILDING_HEAVEN_HOUSE => "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE + AssetName.CONSTRUCT => "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE + AssetName.CONSTRUCT + AssetName.ANIM=> "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2 => "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2 + AssetName.CONSTRUCT => "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2 + AssetName.CONSTRUCT + AssetName.ANIM=> "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3 => "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3 + AssetName.CONSTRUCT=> "HouseHeaven",
		AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3 + AssetName.CONSTRUCT + AssetName.ANIM=> "HouseHeaven",
		AssetName.BUILDING_HEAVEN_BRIDGE => "Building",
		AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL1 => "CollectorHeaven",
		AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL2 => "CollectorHeaven",
		AssetName.MARKETING_HOUSE => "MarketingHouse",
		AssetName.BUILDING_INTERN_HEAVEN_HOUSE => "InternHouseHeaven",
		
		
		AssetName.BUILDING_HELL_HOUSE => "HouseHell",
		AssetName.BUILDING_HELL_HOUSE_LEVEL2 => "HouseHell",
		AssetName.BUILDING_HELL_HOUSE_LEVEL3 => "HouseHell",
		AssetName.BUILDING_HELL_COLLECTOR_LEVEL1 => "CollectorHell",
		AssetName.BUILDING_HELL_COLLECTOR_LEVEL2 => "CollectorHell",
	    AssetName.BUILDING_INTERN_HELL_HOUSE => "InternHouseHell",
		AssetName.BUILDING_FACTORY => 'Factory',
		
		AssetName.DECO_HEAVEN_TREE_1 => "DecoHeaven",
		AssetName.DECO_HEAVEN_TREE_2 => "DecoHeaven",
		AssetName.DECO_HEAVEN_CLOUD => "DecoHeaven",
		AssetName.DECO_HEAVEN_LAKE => "DecoHeaven",
		AssetName.DECO_HEAVEN_PARK=> "DecoHeaven",
		
		
		AssetName.DECO_HELL_BONES => "DecoHell",
		AssetName.DECO_HELL_DEAD_HEAD => "DecoHell",
		AssetName.DECO_HELL_CRYSTAL_SMALL => "DecoHell",
		AssetName.DECO_HELL_CRYSTAL_BIG => "DecoHell",
		AssetName.DECO_HELL_LAVA => "DecoHell",
		
		"Ground" => "Ground",
		"Road_h" => "Ground",
		"Road_c" => "Ground",
		"Road_br" => "Ground",
		"Road_tl" => "Ground",
		"Road_v" => "Ground",
		"FootPrint" => "FootPrintAsset",
	];
	
	// todo : faire un tableau plus évolué pour gérer les cas de même class différent assetName, genre j'ai des House.hx avec un différent assetName, mais je veux chopper le bon
	// soit je le fais en gèrant bien mon tableau, soit je fais une vérification de l'assetName après avoir choisit la bonne class.
	// non tu veux dire même assetName différent class ? (possible cela ?) 
	private static var poolList:Map<String, Array<PoolingObject>> = new Map<String, Array<PoolingObject>>();

	public function new() {
		
	}
	
	public static function init():Void {
		for (lAssetName in INSTANCE_TO_SPAWN.keys()) {
			for (i in 0...INSTANCE_TO_SPAWN[lAssetName]) {
				createToPool(lAssetName);
			}
		}
	}
	
	/**
	 * Return a instance from pool, or create it.
	 * @param	lAssetName
	 * @return
	 */
	public static function getFromPool(lAssetName:String):Dynamic {
		//trace("get " + lAssetName + " " + poolList[lAssetName].length);
		if (poolList[lAssetName] == null) {
			trace("missing " + lAssetName+" in poolArray");
			poolList[lAssetName] = new Array<PoolingObject>();
		}
		
		return poolList[lAssetName].length == 0 ? 
			   createInstance(lAssetName) :
			   poolList[lAssetName].shift();
	}
	
	/**
	 * Add to pool an instance that is not needed anymore.
	 * @param	pInstance
	 * @param	lAssetName
	 */
	public static function addToPool(pInstance:Dynamic, lAssetName:String):Void {
		if (poolList[lAssetName] == null)
			throw(lAssetName + " doesn't exist in pool !");
		
		poolList[lAssetName].push(pInstance);
		
		//trace("add " + lAssetName + " " + poolList[lAssetName].length);
	}
	
	/**
	 * private createToPool at start.
	 * @param	lAssetName
	 */
	private static function createToPool(lAssetName:String):Void {
		if (poolList[lAssetName] == null)
			poolList[lAssetName] = new Array<PoolingObject>();
			
		poolList[lAssetName].push(createInstance(lAssetName));
	}
	
	/**
	 * Create an instance from choosen ClassName (whitout path)
	 * (look getPath method in Main)
	 * @param	lAssetName
	 * @return
	 */
	private static function createInstance(lAssetName:String):Dynamic {
		var lClassName:String = ASSETNAME_TO_CLASS[lAssetName];
		if (lClassName == null)
			Debug.error("Class for assetName : -- "+lAssetName+" -- wasn't found ! Check ASSETNAME_TO_CLASS");
			
			
		return Type.createInstance(Type.resolveClass(
			Main.getInstance().getPath(lClassName)
		), [lAssetName]); // todo : enlever paramètre, car on utilisera plus de Building.hx tout court
	}
	
	public static function destroy():Void {
		for (lAssetName in poolList.keys()) {
			for (i in 0...poolList[lAssetName].length) {
				poolList[lAssetName][i].destroy();
			}
		}
		
		poolList = null;
	}
	
	
	
}