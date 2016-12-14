package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.RegionManager.Region;
import com.isartdigital.perle.game.managers.SaveManager.RegionDescription;
import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VGround;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.flump.Movie;

typedef Region = {
	var desc:RegionDescription;
	// (var "bâtiment déplacé")
	// idem hud contextuel
	// bizarre de le mettre ici à mon avis
	/*var floor3;
	var floor2;
	var floor1;*/
	var building:Map<Int, Map<Int, VBuilding>>;
	var ground:Map<Int, Map<Int, VGround>>;
	var background: String;
}

/**
 * ...
 * @author de Toffoli Matthias & Rabier Ambroise
 */
class RegionManager 
{
	private static var background:Movie;
	public static var worldMap: Map<Int,Map<Int,Region>>;
	public static var buttonMap: Map<Int,Map<Int,ButtonRegion>>;
	private static var buttonRegionContainer:Container;
	private static var factors:Array<Point> =
						[
							new Point(-1,0),
							new Point(1,0),
							new Point(0,-1),
							new Point(0,1)
						];
	
	
	public static function init():Void {
		buttonRegionContainer = new Container();
		// todo : gérer HUD contextuel et l'add au container hudcontextuel.
		GameStage.getInstance().getGameContainer().addChild(buttonRegionContainer);
		worldMap = new Map<Int,Map<Int,Region>>();
		buttonMap = new Map<Int,Map<Int,ButtonRegion>>();
	}
	
	//add buttons according to regions
	private static function addButton(pPos:Point, pWorldPos:Point, indice:Int){
		
		if (indice >= factors.length) return;
		
		var factor:Point = factors[indice];
		var worldPositionX:Int = Std.int(pWorldPos.x + factor.x);
		var worldPositionY:Int = Std.int(pWorldPos.y - factor.y);
		
		
		if (worldMap.exists(worldPositionX)){
			if (worldMap[worldPositionX].exists(worldPositionY)){
				addButton(pPos, pWorldPos, indice+ 1);
				return;
			}
		} 

		var lCentre:Point = new Point(pPos.x + Ground.COL_X_LENGTH / 2, pPos.y + Ground.ROW_Y_LENGTH / 2);
		var myBtn:ButtonRegion = new ButtonRegion(
			new Point(
				lCentre.x - Ground.COL_X_LENGTH / 2 + Ground.ROW_Y_LENGTH * factor.x,
				lCentre.y - Ground.ROW_Y_LENGTH / 2 - Ground.ROW_Y_LENGTH * factor.y
			),
			new Point(worldPositionX, worldPositionY)
		);
		var lPos:Point = IsoManager.modelToIsoView(
							new Point(
								lCentre.x + Ground.COL_X_LENGTH * factor.x, 
								lCentre.y - Ground.ROW_Y_LENGTH * factor.y
								)
							);
		
		myBtn.position = lPos;
		
		
		if (buttonMap[worldPositionX] == null)
			buttonMap[worldPositionX] = new Map<Int,ButtonRegion>();
		if (buttonMap[worldPositionX][worldPositionY] == null){
			
			buttonMap[worldPositionX][worldPositionY] = myBtn;
			buttonRegionContainer.addChild(myBtn);
		}
			
		
		
		addButton(pPos, pWorldPos, indice+ 1);
	}
	
	private static function addToWorldMap (pNewRegion:Region):Void {
		if (worldMap[pNewRegion.desc.x] == null)
			worldMap[pNewRegion.desc.x] = new Map<Int,Region>();
		if (worldMap[pNewRegion.desc.x][pNewRegion.desc.y] != null)
			throw("region allready exist in worldMap !");
			
		worldMap[pNewRegion.desc.x][pNewRegion.desc.y] = pNewRegion;
		
		background = new Movie(pNewRegion.background);
		background.scale.set(1.7);
		GameStage.getInstance().getGameContainer().addChildAt(background, 0);
	}
	
	public static function getButtonContainer():Container{
		return buttonRegionContainer;
	}
	
	public static function buildWhitoutSave ():Void {
		worldMap[0] = new Map<Int,Region>();
		
		worldMap[0][0] = createRegionFromDesc({
			x:0,
			y:0,
			type:RegionType.styx,
			firstTilePos:{x:0,y:0}
		});
		
		createRegion(RegionType.eden, new Point(Ground.COL_X_STYX_LENGTH, 0), {x:1, y:0});
		createRegion(RegionType.eden, new Point(-Ground.COL_X_LENGTH, 0), {x:-1, y:0});
		
		/*background = new Movie(worldMap[0][0].background);
		background.scale.set(1.7);
		GameStage.getInstance().getGameContainer().addChildAt(background, 0);
		
		addButton(new Point(0, 0), new Point(0, 0), 0);*/
	}

	public static function buildFromSave(pSave:Save):Void {
		var lLength:UInt = pSave.region.length;
		
		for (i in 0...lLength) {
			
			addToWorldMap(createRegionFromDesc(pSave.region[i]));
		}
		
		for (i in 0...lLength) {
			
			var tempFirstTilePos:Index = regionPosToFirstTile( {
				x:pSave.region[i].x,
				y:pSave.region[i].y
			});
			
			addButton(
				new Point(
					tempFirstTilePos.x,
					tempFirstTilePos.y
				),
				new Point(
					pSave.region[i].x,
					pSave.region[i].y
				),
				0
			);
		}		
		
	}
	
	
	public static function createRegion (pType:RegionType, pFirstTilePos:Point, pWorldPos:Index):Void {
		addToWorldMap({
			desc: {
				x:pWorldPos.x,
				y:pWorldPos.y,
				type:pType,
				firstTilePos: {x:Std.int(pFirstTilePos.x),y:Std.int(pFirstTilePos.y)}
			},
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>(),
			background: "BgHell",
			
		});
		
		background.position = IsoManager.modelToIsoView(pFirstTilePos);
		VTile.buildInsideRegion(worldMap[pWorldPos.x][pWorldPos.y], true);
		
		SaveManager.save();
		
		addButton(
			pFirstTilePos,
			new Point(
				pWorldPos.x,
				pWorldPos.y
			),
			0
		);
	}
	
	/**
	 * 
	 * @param	pRegionPos 
	 * @return  pFirstTilePos (TilePosition like if they were only one big region)
	 */
	public static function regionPosToFirstTile (pRegionPos:Index):Index {
		// todo vérifier qu'il prends bien en compte correctement le décalage !
		return {
			x: pRegionPos.x * Ground.COL_X_LENGTH + pRegionPos.x * Ground.OFFSET_REGION,
			y: pRegionPos.y * Ground.ROW_Y_LENGTH + pRegionPos.y * Ground.OFFSET_REGION
		};
	}
	
	/**
	 * Do a Math floor custom and return the region of the Tile
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @return  pRegionPos
	 */ 
	public static function tilePosToRegion (pTilePos:Index):Index { 
		var firstTilePos:Index = getRegionFirstTile(pTilePos);
		// TODO : prendre en compte décalage
		return {
			x: cast(firstTilePos.x / Ground.COL_X_LENGTH, Int),
			y: cast(firstTilePos.y / Ground.ROW_Y_LENGTH, Int)
		};
	}
	
	/**
	 * 
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @return first Tile of the Region
	 */
	public static function getRegionFirstTile (pTilePos:Index):Index {
		// TODO : prendre en compte décalage
		return {
			x: ClippingManager.customFloor(pTilePos.x, Ground.COL_X_LENGTH),
			y: ClippingManager.customFloor(pTilePos.y, Ground.ROW_Y_LENGTH)
		};
	}
	
	/**
	 * Create region from regionDescription
	 * @param	pRegionDesc
	 * @return
	 */
	public static function createRegionFromDesc(pRegionDesc:RegionDescription):Region {		
		return { 
			desc: pRegionDesc,
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>(),
			background: "BgHell"
		};	
	}
	
	public static function addToRegionGround (pElement:VGround):Void {

		worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY]  = 
			addToRegionTile(
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY], 
							pElement, 
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY].ground
							);
		
	}
	
	public static function addToRegionBuilding (pElement:VBuilding):Void {
		
		worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY]  = 
			addToRegionTile(
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY], 
							pElement,
							null,
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY].building
							);
	}
	
	//add a tile to a region (building or ground)
	private static function addToRegionTile(pRegion:Region, pElement:VTile, arrayGround:Map<Int, Map<Int, VGround>>, ?arrayBuilding:Map<Int, Map<Int, VBuilding>>):Region{
		
		// todo : gérer le cas ou region n'existe pas ds le tableau ? erreur 
		
		var isGround:Bool = Std.is(pElement, VGround);

		if (isGround){

			if (arrayGround == null)
				arrayGround = new Map<Int, Map<Int, VGround>>();
			if (arrayGround[pElement.tileDesc.mapX] == null)
				arrayGround[pElement.tileDesc.mapX] = new Map<Int, VGround>();
		
		arrayGround[pElement.tileDesc.mapX][pElement.tileDesc.mapY] =  cast(pElement,VGround);
		pRegion.ground = arrayGround;
		
		} else {
			
			if (arrayBuilding == null)
				arrayBuilding = new Map<Int, Map<Int, VBuilding>>();
			if (arrayBuilding[pElement.tileDesc.mapX] == null)
				arrayBuilding[pElement.tileDesc.mapX] = new Map<Int, VBuilding>();
				
			if (arrayBuilding[pElement.tileDesc.mapX][pElement.tileDesc.mapY] != null)
			throw("there is already a building on this tile !");
		
		arrayBuilding[pElement.tileDesc.mapX][pElement.tileDesc.mapY] =  cast(pElement,VBuilding);
		pRegion.building = arrayBuilding;
		}
		
		
		return pRegion;
		
		
	}
}