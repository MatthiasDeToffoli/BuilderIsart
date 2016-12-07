package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VGround;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
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
	private static var buttonRegionContainer:Container;

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
	private static function addButton(pPos:Point){
		var myBtn:ButtonRegion = new ButtonRegion(pPos);
		var lPos:Point = IsoManager.modelToIsoView(new Point(pPos.x / 2, pPos.y / 2));

				myBtn.position = lPos;
				
				buttonRegionContainer.addChild(myBtn);
	}
	
	//create a new world map if server don't have data, else load world map
	public static function initWorldMap(){
		//@TODO gérer le cas si dans localstorage !!!
		worldMap = new Map<Int,Map<Int,Region>>();
		var pMap:Map<Int,Region> = new Map<Int,Region>();
		
		pMap[0] = VTile.currentRegion;
		worldMap[0] = pMap;

		addButton(new Point(-Ground.COL_X_LENGTH ,Ground.ROW_Y_LENGTH));
	}
	
	public static function createRegion(pPos:Point){
		trace(pPos);
		
		for (i in 0...Ground.COL_X_LENGTH) {	
			for (j in 0...Ground.ROW_Y_LENGTH) {
				
				/*var tileDesc:TileDescription = {
					className:"Ground",
					assetName: "Ground",
					mapX:Std.int(i + pPos.x),
					mapY:Std.int(j + pPos.y)
				};*/
				
		var lGround:Ground = PoolingManager.getFromPool("Ground");
		lGround.givePositionIso(
			(i + pPos.x), 
			(j + pPos.y) - Ground.ROW_Y_LENGTH
		);
		lGround.init();
		GameStage.getInstance().getGameContainer().addChild(lGround);
		lGround.start();

			}
		}
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}