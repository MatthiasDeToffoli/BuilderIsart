package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.utils.loader.GameLoader;


typedef TableTypeBuilding = { // voir structure bdd
	
}

/**
 * ...
 * @author ambroise
 */
class GameConfig {

	private static var config:Dynamic;

	public static inline var BUILDING:String = "TypeBuilding";
	// todo : etc
	
	// todo : transformer les string en enum ? ou juste faire getName() sur nos enum ?
	
	
	
	public static function awake ():Void {
		config = GameLoader.getContent(Main.GAME_CONFIG);
	}
	
	public static function getBuilding ():Array<TableTypeBuilding> {
		// if config[""] == false alors table non existante
		return null; // todo 
	}
	
	public function new() {
		
	}
	
}