package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
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
	private static var factors:Array<Point> =
						[
							new Point(-1,0),
							new Point(1,0),
							new Point(0,-1),
							new Point(0,1)
						];

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
	private static function addButton(pPos:Point, pWorldPos:Point, indice:Int){
		
		if (indice >= factors.length) return;
		
		var factor:Point = factors[indice];
		var worldPositionX:Int = Std.int(pWorldPos.x + factor.x);
		var worldPositionY:Int = Std.int(pWorldPos.y + factor.y);
	
		if (worldMap.exists(worldPositionX)){
			if (worldMap[worldPositionX].exists(worldPositionY)){
				addButton(pPos, pWorldPos, indice+ 1);
				return;
			}
		} 
		
		var newRegion:Region = {
			added:false,
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>()
		}
		var lCentre:Point = new Point(pPos.x + Ground.COL_X_LENGTH / 2, pPos.y + Ground.ROW_Y_LENGTH / 2);
		var myBtn:ButtonRegion = new ButtonRegion(
			new Point(
				lCentre.x - Ground.COL_X_LENGTH / 2 + Ground.ROW_Y_LENGTH * factor.x,
				lCentre.y - Ground.ROW_Y_LENGTH / 2 - Ground.ROW_Y_LENGTH * factor.y
			),
			new Point(worldPositionX,worldPositionY)
		);
		var lPos:Point = IsoManager.modelToIsoView(
							new Point(
								lCentre.x + Ground.COL_X_LENGTH * factor.x, 
								lCentre.y - Ground.ROW_Y_LENGTH * factor.y
								)
							);

							
		
		var lMap:Map<Int,Region> = worldMap.exists(worldPositionX) ? worldMap[worldPositionX]:new Map<Int,Region>();
		lMap[worldPositionY] = newRegion;
		worldMap[worldPositionX]  = lMap;
		myBtn.position = lPos;
		
		buttonRegionContainer.addChild(myBtn);
		
		addButton(pPos, pWorldPos, indice+ 1);
	}
	
	//create a new world map if server don't have data, else load world map
	public static function initWorldMap(){
		//@TODO gérer le cas si dans localstorage !!!
		worldMap = new Map<Int,Map<Int,Region>>();
		var pMap:Map<Int,Region> = new Map<Int,Region>();
		
		pMap[0] = VTile.currentRegion;
		worldMap[0] = pMap;

		addButton(new Point(0,0), new Point(0,0),0);
	}
	
	public static function createRegion(pPos:Point,pWorldPos:Point): Void{


		
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
			(j + pPos.y)
		);
		lGround.init();
		GameStage.getInstance().getGameContainer().addChild(lGround);
		lGround.start();

			}
		}
		
		worldMap[Std.int(pWorldPos.x)][Std.int(pWorldPos.y)].added = true;
		addButton(pPos,pWorldPos, 0);
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}