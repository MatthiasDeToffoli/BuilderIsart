package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import haxe.Json;
import js.Browser;

typedef TileDescription = {
	var className:String;
	var assetName:String;
	var mapX:Int;
	var mapY:Int;
}

typedef Save = {
	var COL_X_LENGTH:Int;
	var ROW_Y_LENGTH:Int;
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
	public static function save():Void {
		var buildingSave:Array<TileDescription> = [];
		var groundSave:Array<TileDescription> = [];
		var buildingLength:UInt = Building.list.length;
		
		// DeepCopy for tileDesc ?
		for (lClassName in VTile.list.keys()) {
			for (x in VTile.list[lClassName].keys()) {
				for (y in VTile.list[lClassName][x].keys()) {
					if (lClassName == "Building")
						buildingSave.push(VTile.list[lClassName][x][y].tileDesc);
					if (lClassName == "Ground")
						groundSave.push(VTile.list[lClassName][x][y].tileDesc);
				}
			}
		}
		
		currentSave = {
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
	public static function load():Save {
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
}