package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.ResourcesManager.ResourcesData;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import haxe.Json;
import js.Browser;

typedef TileDescription = {
	var className:String;
	var assetName:String;
	var id:Int;
	var refTimer:Int;
	var refResource:Int;
	var regionX:Int;
	var regionY:Int;
	var mapX:Int;
	var mapY:Int;
}

typedef RegionDescription = {
	var added:Bool; // todo: ce serais top de ne pas avoir à regarder si added ou pas !
	var x:Int;
	var y:Int;
	/*var backgroundAssetName;*/
}

typedef TimeDescription = {
	var refTile:Int;
	var progress:Float;
	var end:Float;
}

typedef ResourceDescription = {
	var refTile:Int;
}

/**
 * Usefull for everything that is used for statistics only.
 */
typedef Stats = {
	var gameStartTime:Float;
}

// On save des TileDescription, pas des Virtual !
typedef Save = {
	var COL_X_LENGTH:Int;
	var ROW_Y_LENGTH:Int;
	var stats:Stats;
	var idHightest:Int;
	var region:Array<RegionDescription>;
	var ground:Array<TileDescription>;
	var building:Array<TileDescription>;
	var times:Array<TimeDescription>;
	var lastKnowTime:Float;
	var resourcesData:ResourcesData;
	// add what you want to save.
}

/**
 * ...
 * @author ambroise
 */
class SaveManager {
	private static inline var SAVE_NAME:String = "com_isartdigital_perle";
	public static var currentSave(default, null):Save;
	
	/**
	 * Save the buildings and grounds in a Json in local storage.
	 * Use virtualCell to make the save.
	 */
	public static function save():Void { // todo ajouter la possibilité de save qu'une partie pour perf
		var buildingSave:Array<TileDescription> = [];
		var groundSave:Array<TileDescription> = [];
		var regionSave:Array<RegionDescription> = [];
		
		// factoriser
		for (regionX in RegionManager.worldMap.keys()) {
			for (regionY in RegionManager.worldMap[regionX].keys()) {
				if (!RegionManager.worldMap[regionX][regionY].desc.added) // todo : à enlever
					continue;
					
				regionSave.push(RegionManager.worldMap[regionX][regionY].desc);
				
				for (x in RegionManager.worldMap[regionX][regionY].building.keys()) {
					for (y in RegionManager.worldMap[regionX][regionY].building[x].keys()) {
						buildingSave.push(RegionManager.worldMap[regionX][regionY].building[x][y].tileDesc);
					}
				}
					
				for (x in RegionManager.worldMap[regionX][regionY].ground.keys()) {
					for (y in RegionManager.worldMap[regionX][regionY].ground[x].keys()) {
						
						groundSave.push(RegionManager.worldMap[regionX][regionY].ground[x][y].tileDesc);
					}
				}
			}
		}
		
		// todo : dans le même ordre que les variables !
		currentSave = {
			times: getTimes(),
			lastKnowTime:TimeManager.lastKnowTime,
			stats: getStats(),
			idHightest: IdManager.idHightest,
			region: regionSave,
			ground: groundSave,
			building: buildingSave,
			resourcesData: ResourcesManager.getResourcesData(),
			COL_X_LENGTH: Ground.COL_X_LENGTH,
			ROW_Y_LENGTH: Ground.ROW_Y_LENGTH
		};
		
		setLocalStorage(currentSave);
	}
	
	// todo : réfléchir au perte de perf à utilsier le localstorage si souvent, négligeable ?
	public static function saveLastKnowTime(pTime:Float):Void {
		currentSave.lastKnowTime = pTime;
		setLocalStorage(currentSave);
	}
	
	private static function setLocalStorage(pCurrentSave:Save):Void {
		Browser.getLocalStorage().setItem(
			SAVE_NAME,
			Json.stringify(currentSave)
		);
	}
	
	private static function getTimes ():Array<TimeDescription> {
		return TimeManager.list.map(function (pElement){
			return pElement.desc;
		});
	}
	
	private static function getStats ():Stats {
		if (currentSave == null || currentSave.stats == null)
			return {
				gameStartTime:TimeManager.gameStartTime
			};
		else
			return {
				gameStartTime: currentSave.stats.gameStartTime
			};
			
		return null;
	}
	
	/**
	 * UNUSED !
	 * Remove the Save from localStorage
	 */
	public static function destroy():Void {
		Browser.getLocalStorage().setItem(
			SAVE_NAME,
			Json.stringify(null)
		);
	}
	
	/**
	 * Return currentSave, load if null.
	 * @return
	 */
	private static function load():Save {
		//destroy(); // here if save reset needed
		if (currentSave == null) {
			currentSave = Json.parse(
				Browser.getLocalStorage().getItem(SAVE_NAME)
			);
			
			if (currentSave != null) {
				if (currentSave.COL_X_LENGTH != Ground.COL_X_LENGTH ||
					currentSave.ROW_Y_LENGTH != Ground.ROW_Y_LENGTH)
					throw("DIFFERENT VALUE Ground.COL_X_LENGTH or Ground.ROW_Y_LENGTH !! (use destroy() in this function)");
			}
		}
		return currentSave;
	}
	
	public static function createFromSave():Void {
		load();
		if (currentSave != null) {
			TimeManager.buildFromSave(currentSave);
			IdManager.buildFromSave(currentSave);
			RegionManager.buildFromSave(currentSave);
			VTile.buildFromSave(currentSave);
			ResourcesManager.initWithLoad(currentSave.resourcesData);
		}
		else
			createWhitoutSave();
	}
	
	private static function createWhitoutSave():Void {
		TimeManager.buildWhitoutSave();
		IdManager.buildWhitoutSave();
		RegionManager.buildWhitoutSave();
		VTile.buildWhitoutSave();
		ResourcesManager.initWithoutSave();
		SaveManager.save();
	}
}