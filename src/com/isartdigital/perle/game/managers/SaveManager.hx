package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import haxe.Json;
import js.Browser;

typedef TileDescription = {
	var className:String;
	var assetName:String;
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

// On save des TileDescription, pas des Virtual !
typedef Save = {
	var COL_X_LENGTH:Int;
	var ROW_Y_LENGTH:Int;
	var region:Array<RegionDescription>;
	var ground:Array<TileDescription>;
	var building:Array<TileDescription>;
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
		
		currentSave = {
			region:regionSave,
			ground:groundSave,
			building:buildingSave,
			COL_X_LENGTH: Ground.COL_X_LENGTH,
			ROW_Y_LENGTH: Ground.ROW_Y_LENGTH
		};
		
		Browser.getLocalStorage().setItem(
			SAVE_NAME,
			Json.stringify(currentSave)
		);
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
			RegionManager.buildFromSave(currentSave);
			VTile.buildFromSave(currentSave);
		}
		else
			createWhitoutSave();
	}
	
	private static function createWhitoutSave():Void {
		RegionManager.buildWhitoutSave();
		VTile.buildWhitoutSave();
		SaveManager.save();
	}
}