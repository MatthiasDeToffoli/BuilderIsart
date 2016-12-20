package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.managers.RegionManager.Region;
import com.isartdigital.perle.game.managers.SaveManager.RegionDescription;
import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Building.SizeOnMap;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VGround;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.game.virtual.VTribunal;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
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
		
		if ((pWorldPos.x < 0 && factor.x == 1) || (pWorldPos.x > 0 && factor.x == -1)){
			addButton(pPos, pWorldPos, indice+ 1);
			return;
		}
		
		var worldPositionX:Int = Std.int(pWorldPos.x + factor.x);
		var worldPositionY:Int = Std.int(pWorldPos.y - factor.y);
		
		if (
			(pWorldPos.x < 0 && factor.x == 1) || 
			(pWorldPos.x > 0 && factor.x == -1) || 
			(Math.abs(worldPositionX) > 2)
			){
			addButton(pPos, pWorldPos, indice+ 1);
			return;
		}
		
		
		if (worldMap.exists(worldPositionX)){
			if (worldMap[worldPositionX].exists(worldPositionY)){
				addButton(pPos, pWorldPos, indice+ 1);
				return;
			}
		} 

		var lCentre:Point = new Point(pPos.x + Ground.COL_X_LENGTH / 2, pPos.y + Ground.ROW_Y_LENGTH / 2);
		var myBtn:ButtonRegion = new ButtonRegion(
			new Point(
				lCentre.x  + factor.x - Ground.COL_X_LENGTH / 2 + Ground.COL_X_LENGTH * factor.x,
				lCentre.y - Ground.ROW_Y_LENGTH / 2 - Ground.ROW_Y_LENGTH * factor.y - factor.y
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
		
		if (background != null)	{
			Ground.bgContainer.addChild(background);			
		}
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
		
		createRegion(RegionType.hell, new Point(Ground.COL_X_STYX_LENGTH, 0), {x:1, y:0});
		createRegion(RegionType.eden, new Point( -Ground.COL_X_LENGTH, 0), {x: -1, y:0});
		
		VTribunal.getInstance();
	}

	public static function buildFromSave(pSave:Save):Void {
		var lLength:UInt = pSave.region.length;		
		
		for (i in 0...lLength) {
			addToWorldMap(createRegionFromDesc(pSave.region[i]));
		}
		
		for (i in 0...lLength) {
			
			/*var tempFirstTilePos:Index = regionPosToFirstTile( {
				x:pSave.region[i].x,
				y:pSave.region[i].y
			});*/ // todo @Matthias: oublie ?
			
			addButton(
				new Point(
					pSave.region[i].firstTilePos.x,
					pSave.region[i].firstTilePos.y
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
		
		//@TODO: delete when we will have the stick bg
		if(pType != RegionType.styx) createNextBg({
			x:pWorldPos.x,
			y:pWorldPos.y,
			type:pType,
			firstTilePos: {x:Std.int(pFirstTilePos.x),y:Std.int(pFirstTilePos.y)}
		});
			
		addToWorldMap({
			desc: {
				x:pWorldPos.x,
				y:pWorldPos.y,
				type:pType,
				firstTilePos: {x:Std.int(pFirstTilePos.x),y:Std.int(pFirstTilePos.y)}
			},
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>(),
			background: getBgAssetname(pType)		
		});
		
		VTile.buildInsideRegion(worldMap[pWorldPos.x][pWorldPos.y], true);
		
		SaveManager.save();
		
		if (Math.abs(pWorldPos.x) == 1) createStyxRegionIfDontExist(pWorldPos, Std.int(pFirstTilePos.y));
		
		if(pType != RegionType.styx) addButton(
			pFirstTilePos,
			new Point(
				pWorldPos.x,
				pWorldPos.y
			),
			0
		);
	}
	
	private static function createStyxRegionIfDontExist(pWorldPos:Index, pPosY:Int){
		if (worldMap[0][pWorldPos.y] != null) return;
			
		var posWorld:Index = {x:0, y:pWorldPos.y};
		createRegion(RegionType.styx, new Point(0, pPosY), posWorld);
		
		addRegionButtonByStyx(posWorld, pPosY);
		
	}
	
	private static function addRegionButtonByStyx(pWorldPos:Index, pPosY:Int){
		
		var myBtn:ButtonRegion, btnWorldPos:Index;
		
		if (!worldMap[-1].exists(pWorldPos.y))
			if (!buttonMap[-1].exists(pWorldPos.y)){
				btnWorldPos = { x:-1, y:pWorldPos.y};
				myBtn = createButtonRegion(btnWorldPos, pPosY, -Ground.COL_X_LENGTH,0);
				buttonRegionContainer.addChild(myBtn);
			}
			
		if (!worldMap[1].exists(pWorldPos.y))
			if (!buttonMap[1].exists(pWorldPos.y)){
				btnWorldPos = { x:1, y:pWorldPos.y};
				myBtn = createButtonRegion(btnWorldPos, pPosY, Ground.COL_X_STYX_LENGTH, (Ground.COL_X_STYX_LENGTH + Ground.COL_X_LENGTH)/2.0);
				buttonRegionContainer.addChild(myBtn);
			}
	}
	
	private static function createButtonRegion(pWorldPos:Index,pPosY:Int,pPosX:Float, buttonDecal:Float):ButtonRegion{
		var myBtn = new ButtonRegion(new Point( pPosX, pPosY), VTile.indexToPoint(pWorldPos));
		myBtn.position = IsoManager.modelToIsoView(new Point( pPosX / 2.0 + buttonDecal, pPosY + Ground.ROW_Y_LENGTH/2.0));
		buttonMap[pWorldPos.x][pWorldPos.y] = myBtn;
		return myBtn;
	}
		
		/*createRegion(RegionType.hell, new Point(Ground.COL_X_STYX_LENGTH, 0), {x:1, y:0});
		createRegion(RegionType.eden, new Point(-Ground.COL_X_LENGTH, 0), {x:-1, y:0});*/
	
	/**
	 * Return the background asset of the region type parameter
	 * @param regionType
	 * @return background asset name
	 */
	private static function getBgAssetname(pRegionType:RegionType): String {
		switch (pRegionType) 
		{
			case RegionType.hell: return "HBg";
			case RegionType.eden: return "PBg";
			case RegionType.styx: return "SBg";
			default: trace(pRegionType + " - No background for this"); return null;
		}
	}
	
	/**
	 * Change background to addchild
	 * @param regionDescription
	 */
	private static function createNextBg(pDesc:RegionDescription): Void {
		background = new Movie(getBgAssetname(pDesc.type));
		background.scale.set(1.7);
		background.position = IsoManager.modelToIsoView(new Point(pDesc.firstTilePos.x, pDesc.firstTilePos.y));
	}
	
	/**
	 * 
	 * @param	pRegionPos 
	 * @return  pFirstTilePos (TilePosition like if they were only one big region)
	 */
	/*public static function regionPosToFirstTile (pRegionPos:Index):Index {
		// Ground.COL_X_STYX_LENGTH - Ground.OFFSET_REGION because region is glued to the styx.
		var heavenOffSet:Int = pRegionPos.x < 0 ? Ground.COL_X_STYX_LENGTH - Ground.OFFSET_REGION : 0;
		
		return {
			x: pRegionPos.x * Ground.COL_X_LENGTH + pRegionPos.x * Ground.OFFSET_REGION - heavenOffSet,
			y: pRegionPos.y * Ground.ROW_Y_LENGTH + pRegionPos.y * Ground.OFFSET_REGION
		};
		
		//return worldMap[pRegionPos.x][pRegionPos.y].desc.firstTilePos; x: -12 pour heaven wtf ?
	}*/
	
	
	/**
	 * 
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @return  pRegionPos
	 */ 
	public static function tilePosToRegion (pTilePos:Index):Index { 
		/*var firstTilePos:Index = getRegionFirstTile(pTilePos);
		// TODO : prendre en compte décalage
		return {
			x: cast(firstTilePos.x / Ground.COL_X_LENGTH, Int),
			y: cast(firstTilePos.y / Ground.ROW_Y_LENGTH, Int)
		};*/
		// todo: autre typedef ss footprint
		// todo : factoriser avec une map Region.REGION_TYPE_TO_SIZE
		var lRegionSize:SizeOnMap = { width:0, height:0, footprint:0 }; 
		var lRegionRect:Rectangle;
		
		
		// fait une collision point - rectangle, todo séparer la méthode de collision
		for (x in worldMap.keys()) {
			for (y in worldMap[x].keys()) {
				
				// pourrait être facotriser par une map si plus de taille de région différente. (comme size de building)
				lRegionSize.width = worldMap[x][y].desc.type == RegionType.styx ? Ground.COL_X_STYX_LENGTH : Ground.COL_X_LENGTH;
				lRegionSize.height = worldMap[x][y].desc.type == RegionType.styx ? Ground.ROW_Y_STYX_LENGTH : Ground.ROW_Y_LENGTH;
				
				//trace(lRegionSize);
				
				lRegionRect = new Rectangle(
					worldMap[x][y].desc.firstTilePos.x,
					worldMap[x][y].desc.firstTilePos.y,
					lRegionSize.width,
					lRegionSize.height
				);
				
				if (isInsideRegion(lRegionRect, pTilePos)) {
					return {
						x:x,
						y:y
					}
				}
				
			}
		}
		
		return null;
	}
	
	// todo : description de méthode
	private static function isInsideRegion (pRegionRect:Rectangle, pIndex:Index):Bool {
		return (pIndex.x >= pRegionRect.x &&
				pIndex.x  < pRegionRect.x + pRegionRect.width &&
				pIndex.y >= pRegionRect.y &&
				pIndex.y  < pRegionRect.y + pRegionRect.height);
	}
	
	/**
	 * Create region from regionDescription
	 * @param	pRegionDesc
	 * @return
	 */
	public static function createRegionFromDesc(pRegionDesc:RegionDescription):Region {		
		var newRegion:Region = { 
			desc: pRegionDesc,
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>(),
			background: getBgAssetname(pRegionDesc.type)
		};
		
		if (newRegion.background != "SBg") createNextBg(newRegion.desc);
		
		return newRegion;
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
		
		arrayBuilding[pElement.tileDesc.mapX][pElement.tileDesc.mapY] =  cast(pElement, VBuilding);
		
		pRegion.building = arrayBuilding;
		}
		
		
		return pRegion;
		
		
	}
	
	//Todo: not used but working
	//For remove a specific VBuilding from the region manager
	public static function removeToRegionBuilding (pElement:VBuilding):Void {
		
		worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY]  = 
			removeToRegionTile(
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY], 
							pElement,
							null,
							worldMap[pElement.tileDesc.regionX][pElement.tileDesc.regionY].building
							);
	}
	
	//Todo: idem 
	private static function removeToRegionTile(pRegion:Region, pElement:VTile,arrayGround:Map<Int, Map<Int, VGround>>, ?arrayBuilding:Map<Int, Map<Int, VBuilding>>):Region{
		arrayBuilding[pElement.tileDesc.mapX].remove(pElement.tileDesc.mapY);
		pRegion.building = arrayBuilding;
		
		
		return pRegion;
		
		
	}
	
	
}