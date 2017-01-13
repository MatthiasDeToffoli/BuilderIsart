package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.RegionManager.Region;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.RegionDescription;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Building.SizeOnMap;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.RegionBackground;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.game.virtual.VGround;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

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
 * manage all region
 * @author de Toffoli Matthias
 * @author Rabier Ambroise
 */
class RegionManager 
{
	private static var background:RegionBackground;
	
	/**
	 * the model map who contain all region
	 */
	public static var worldMap: Map<Int,Map<Int,Region>>;
	
	/**
	 * the same model than map but for buttonRegion
	 */
	public static var buttonMap: Map<Int,Map<Int,ButtonRegion>>;
	
	/**
	 * container of all background
	 */
	public static var bgContainer(default, null):Container;
	
	/**
	 * typedef which contain all data resources
	 */
	private static var buttonRegionContainer:Container;
	
	/**
	 * the base prace of region near water (save it into bdd)
	 */
	private static var basePriceNearWater:Float;
	/**
	 * the base prace of region far water (save it into bdd)
	 */
	private static var basePriceFarWater:Float;
	/**
	 * factor which be use for know the price of other region (save it into bdd)
	 */
	private static var priceFactor:Float;
	
	/**
	 * the xp we gain when we buy a region (a float for the type of the region which bought and a float for the other type)
	 */
	private static var baseXpGains:Map<String,Float>;
	/**
	 * factors which be use for know the xp gain (one for region near styx and one for region far styx)
	 */
	private static var xpFactors:Array<Float>;
	
	/**
	 * the number of region by type(save it into bdd)
	 */
	private static var mapNumbersRegion:Map<Alignment,Int>;
	
	/**
	 * use for know the xp gain
	 */
	private static inline var CURRENT_TYPE_REGION:String = "current";
	private static inline var OTHER_TYPE_REGION:String = "other";
	
	/**
	 * factors for place button arrond a region
	 */
	private static var factors:Array<Point> =
						[
							new Point(-1,0),
							new Point(1,0),
							new Point(0,-1),
							new Point(0,1)
						];
	
	
	/**
	 * init all element of this class
	 */
	public static function init():Void {
		buttonRegionContainer = new Container();
		bgContainer = new Container();
		// todo : gérer HUD contextuel et l'add au container hudcontextuel.
		GameStage.getInstance().getGameContainer().addChild(buttonRegionContainer);
		GameStage.getInstance().getGameContainer().addChildAt(bgContainer, 0);
		worldMap = new Map<Int,Map<Int,Region>>();
		buttonMap = new Map<Int,Map<Int,ButtonRegion>>();
		mapNumbersRegion = new Map<Alignment,Int>();
		baseXpGains = new Map<String,Float>();
		xpFactors = [1.5, 1.2];
		
		baseXpGains[CURRENT_TYPE_REGION] = 1500;
		baseXpGains[OTHER_TYPE_REGION] = 500;
		
		basePriceNearWater = 15000;
		basePriceFarWater = 10000;
		priceFactor = 1.2;
		
		mapNumbersRegion[Alignment.heaven] = -1;
		mapNumbersRegion[Alignment.hell] = -1;
		mapNumbersRegion[Alignment.neutral] = 0;
	}
	

	/**
	 * add buttons according to regions
	 * @param pPos position of the first tile of the region
	 * @param pWorldPos the position in the world map
	 * @param indice help to choos the factor we want
	 */
	private static function addButton(pPos:Point, pWorldPos:Point, indice:Int):Void{
		
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
	
	/**
	 * add a new region to the worldMap
	 * @param pNewRegion region to add
	 */
	private static function addToWorldMap (pNewRegion:Region):Void {
		
		mapNumbersRegion[pNewRegion.desc.type]++;
		
		if (worldMap[pNewRegion.desc.x] == null)
			worldMap[pNewRegion.desc.x] = new Map<Int,Region>();
		if (worldMap[pNewRegion.desc.x][pNewRegion.desc.y] != null)
			throw("region allready exist in worldMap !");
			
		worldMap[pNewRegion.desc.x][pNewRegion.desc.y] = pNewRegion;
		
		if (background != null)	{
			bgContainer.addChild(background);
			sortBackground();
		}
	}
	
	/**
	 * get the button container
	 * @return Container
	 */
	public static function getButtonContainer():Container{
		return buttonRegionContainer;
	}
	
	/**
	 * create a new data
	 */
	public static function buildWhitoutSave ():Void {
		worldMap[0] = new Map<Int,Region>();
		
		worldMap[0][0] = createRegionFromDesc({
			x:0,
			y:0,
			type:Alignment.neutral,
			firstTilePos:{x:0,y:0}
		});
		
		createNextBg({
			x:0,
			y:0,
			type:Alignment.neutral,
			firstTilePos: {x:0, y:0}
		});
		
		bgContainer.addChild(background);
		
		createRegion(Alignment.hell, new Point(Ground.COL_X_STYX_LENGTH, 0), {x:1, y:0});
		createRegion(Alignment.heaven, new Point( -Ground.COL_X_LENGTH, 0), {x: -1, y:0});
		
		VTribunal.getInstance();
	}
	
	
	/**
	 * load the data
	 * @param pSave
	 */
	public static function buildFromSave(pSave:Save):Void {
		var lLength:UInt = pSave.region.length;		
		
		for (i in 0...lLength) {
			pSave.region[i].type = SaveManager.translateArrayToEnum(pSave.region[i].type);
			addToWorldMap(createRegionFromDesc(pSave.region[i]));
		}
		
		for (i in 0...lLength) {		
			if (pSave.region[i].type != Alignment.neutral)
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
	
	/**
	 * Create a new region
	 * @param	pType the type of the region which will creat
	 * @param	pFirstTilePos the position of the first tile 
	 * @param	pWorldPos the position in the worldMap
	 */
	public static function createRegion (pType:Alignment, pFirstTilePos:Point, pWorldPos:Index):Void {
		
		//@TODO: delete when we will have the stick bg
		
		createNextBg({
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
		
		//VTile.buildInsideRegion(worldMap[pWorldPos.x][pWorldPos.y], true);
		
		SaveManager.save();
		
		if (Math.abs(pWorldPos.x) == 1) createStyxRegionIfDontExist(pWorldPos, Std.int(pFirstTilePos.y));
		
		if(pType != Alignment.neutral) addButton(
			pFirstTilePos,
			new Point(
				pWorldPos.x,
				pWorldPos.y
			),
			0
		);
	}
	
	/**
	 * test if we have money for by a new region
	 * @param	pWorldPos the position of the region we want buy
	 * @param	pType the type of the region we want buy
	 * @return if we can by the new region
	 */
	public static function haveMoneyForBuy(pWorldPos:Point, pType:Alignment):Bool {
		
		var basePrice:Float = Math.abs(pWorldPos.x) > 1 ? basePriceFarWater:basePriceNearWater;
		
		if (mapNumbersRegion[pType] > 0) basePrice *= priceFactor * mapNumbersRegion[pType];
		
		if (basePrice < ResourcesManager.getTotalForType(GeneratorType.soft)){
			ResourcesManager.spendTotal(GeneratorType.soft, Std.int(basePrice));
			addExp(pType, Std.int(Math.abs(pWorldPos.x) - 1), mapNumbersRegion[pType]);
			return true;
		}
		
		var errorMessage:String = "not enought money you must have " + (basePrice - ResourcesManager.getTotalForType(GeneratorType.soft)) + " in more";
		Debug.error(errorMessage);
		return false;
		
	}
	
	private static function addExp(pType:Alignment, pFactorIndice:Int, numberRegion:Float):Void{
		var lFactor = numberRegion > 0 ? xpFactors[pFactorIndice] * numberRegion:1;

		if (pType == Alignment.heaven){
			ResourcesManager.gainResources(GeneratorType.goodXp, baseXpGains[CURRENT_TYPE_REGION] * lFactor);
			ResourcesManager.gainResources(GeneratorType.badXp, baseXpGains[OTHER_TYPE_REGION] * lFactor);		
		} else {
			ResourcesManager.gainResources(GeneratorType.badXp, baseXpGains[CURRENT_TYPE_REGION] * lFactor);
			ResourcesManager.gainResources(GeneratorType.goodXp, baseXpGains[OTHER_TYPE_REGION] * lFactor);
		}
	}
	
	/**
	 * Create a styx region near another region
	 * @param	pWorldPos the position in the worldMap
	 * @param	pPosY position in y axes of the styx region
	 */
	private static function createStyxRegionIfDontExist(pWorldPos:Index, pPosY:Int):Void{
		if (worldMap[0][pWorldPos.y] != null) return;
			
		var posWorld:Index = {x:0, y:pWorldPos.y};
		createRegion(Alignment.neutral, new Point(0, pPosY), posWorld);
		
		addRegionButtonByStyx(posWorld, pPosY);
		
	}
	
	/**
	 * add a new button near a styx
	 * @param	pWorldPos the position in the worldMap
	 * @param	pPosY position in y axes of the styx region
	 */
	private static function addRegionButtonByStyx(pWorldPos:Index, pPosY:Int):Void{
		
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
		
	
	/**
	 * Return the background asset of the region type parameter
	 * @param regionType
	 * @return background asset name
	 */
	private static function getBgAssetname(pRegionType:Alignment): String {
		switch (pRegionType) 
		{
			case Alignment.hell: return AssetName.BACKGROUND_HELL;
			case Alignment.heaven: return AssetName.BACKGROUND_HEAVEN;
			case Alignment.neutral: return AssetName.BACKGROUND_STYX;
			default: trace(pRegionType + " - No background for this"); return null;
		}
	}
	
	/**s
	 * Change background to addchild
	 * @param regionDescription
	 */
	private static function createNextBg(pDesc:RegionDescription): Void {
		// note d'Ambroise : ok pr utiliser Movie() mais il donne pas le bon scale
		// ET PAS QUESTION DE RESCALE A LA VUE
		var bgSize:Index = pDesc.type == Alignment.neutral ? {x:Ground.COL_X_STYX_LENGTH, y:Ground.ROW_Y_STYX_LENGTH}:{x:Ground.COL_X_LENGTH, y:Ground.ROW_Y_LENGTH};
		background = new RegionBackground(getBgAssetname(pDesc.type),pDesc.firstTilePos,bgSize);
		background.init();
		background.start();
		background.position = IsoManager.modelToIsoView(VTile.indexToPoint(pDesc.firstTilePos));
	}
	
	
	/**
	 * 
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @return  pRegionPos
	 */ 
	public static function tilePosToRegion (pTilePos:Index):Index { 
		
		// todo: autre typedef ss footprint
		// todo : factoriser avec une map Region.REGION_TYPE_TO_SIZE
		var lRegionSize:SizeOnMap = { width:0, height:0, footprint:0 }; 
		var lRegionRect:Rectangle;
		
		
		// fait une collision point - rectangle, todo séparer la méthode de collision
		for (x in worldMap.keys()) {
			for (y in worldMap[x].keys()) {
				
				// pourrait être facotriser par une map si plus de taille de région différente. (comme size de building)
				lRegionSize.width = worldMap[x][y].desc.type == Alignment.neutral ? Ground.COL_X_STYX_LENGTH : Ground.COL_X_LENGTH;
				lRegionSize.height = worldMap[x][y].desc.type == Alignment.neutral ? Ground.ROW_Y_STYX_LENGTH : Ground.ROW_Y_LENGTH;
				
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
		
		createNextBg(newRegion.desc);
		
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
	
	/**
	 * Z-Sorting of Background container.
	 */
	public static function sortBackground():Void {
		bgContainer.children = IsoManager.sortTiles(bgContainer.children);
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