package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class RegionManager 
{
	
	/**
	 * instance unique de la classe RegionManager
	 */
	private static var instance: RegionManager;
	public static var worldMap: Map<Int,Map<Int,Region>>;
	private var buttonRegionContainer:Container;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): RegionManager {
		if (instance == null) instance = new RegionManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		buttonRegionContainer = new Container();
		GameStage.getInstance().getGameContainer().addChild(buttonRegionContainer);
	}
	
	//add buttons according to regions
	private function addButton(pX,pY){
		var myBtn:ButtonRegion = new ButtonRegion();
				myBtn.x = pX;
				myBtn.y = pY;
				
				buttonRegionContainer.addChild(myBtn);
	}
	
	//create a new world map if server don't have data, else load world map
	public static function initWorldMap(){
		//@TODO gérer le cas si dans localstorage !!!
		worldMap = new Map<Int,Map<Int,Region>>();
		//worldMap[Math.round(Ground.COL_X_LENGTH / 2 * Tile.TILE_WIDTH)][Math.round(Ground.ROW_Y_LENGTH / 2 * Tile.TILE_HEIGHT)] = test;
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}