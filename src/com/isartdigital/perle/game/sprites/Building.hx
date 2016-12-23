package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.contextual.ButtonProduction;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

typedef SizeOnMap = {
	var width:Int;
	var height:Int;
	var footprint:Float;
}

typedef RegionMap = {
	var regionFirstTile:Index;
	var region:Index;
	var map:Index;
}

/**
 * ...
 * @author ambroise
 */
class Building extends Tile implements IZSortable implements PoolingObject
{
	public static var ASSETNAME_TO_MAPSIZE(default, never):Map<String, SizeOnMap> = [
		"Factory" => {width:5, height:3, footprint : 1},
		"House" => {width:2, height:2, footprint : 1},
		"Trees" => {width:1, height:1, footprint : 0},
		"Villa" => {width:3, height:3, footprint : 1},
	];
	
	private static inline var FILTER_OPACITY:Float = 0.5;
	
	public static var list:Array<Building>;
	
	public static var currentSelectedBuilding:Building;
	private static var container:Container;
	private static var colorMatrix:ColorMatrixFilter;
	
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;
	
	private var regionMap:RegionMap;
	
	private var isMove:Bool = false;
	private var isFirstClickAfterMoved = false; //Flag to avoid the apparence of the building's hud when it's put after been removed
	private var vBuildingRef:VBuilding;
	
	/**
	 * Hack, ignore first unwanted click on building HUD button
	 * the building won't spawn bellow the button
	 */
	private static var firstClickSuck:Bool;
	
	private var precedentBesMapPos:Point = new Point(0, 0);
	
	/**
	 * Initialisation of Building class, should be called after Ground class initialisation.
	 */
	public static function initClass():Void {
		container = new Container();
		colorMatrix = new ColorMatrixFilter();
		colorMatrix.desaturate(false);
		container.position = Ground.container.position;
		GameStage.getInstance().getGameContainer().addChild(container);
		list = new Array<Building>();
	}
	
	/**
	 * Z-Sorting of Building container.
	 */
	public static function sortBuildings():Void {
		container.children = IsoManager.sortTiles(container.children);
	}
	
	/**
	 * Return true if user is making a new build.
	 * @return
	 */
	public static function hasCurrentBuilding():Bool {
		return currentSelectedBuilding != null;
	}
	
	/**
	 * Create a Building Tile, addchild it and start it.
	 * @param	pTileDesc
	 * @return
	 */
	public static function createBuilding(pTileDesc:TileDescription):Building {
		var lBuilding:Building = PoolingManager.getFromPool(pTileDesc.assetName);
		var regionFirstTilePos:Index = RegionManager.worldMap[pTileDesc.regionX][pTileDesc.regionY].desc.firstTilePos;
		
		lBuilding.positionTile( // todo : semblable a Ground.hx positionTile, factoriser ?
			pTileDesc.mapX + regionFirstTilePos.x, 
			pTileDesc.mapY + regionFirstTilePos.y
		);
		lBuilding.setMapColRow(
			{
				x:pTileDesc.mapX + regionFirstTilePos.x, 
				y:pTileDesc.mapY + regionFirstTilePos.y
			},
			ASSETNAME_TO_MAPSIZE[pTileDesc.assetName]
		);
		list.push(lBuilding);
		lBuilding.init();
		container.addChild(lBuilding);
		lBuilding.start(); // todo : start ailleurs pr éviter clic de trop ?
		
		return lBuilding;
	}
	
	public static function gameLoop():Void {
		if (currentSelectedBuilding != null)
			currentSelectedBuilding.doAction();
	}
	
	
	public function new(?pAssetName:String) {
		super(pAssetName);	
	}
	
	override public function start():Void {
		super.start();
		
		// in the start or event click will appear when you put a building !
		interactive = true;
		addListenerOnClick();
	}
	
	/**
	 * 
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @param	pMapSize (width and height)
	 */
	private function setMapColRow(pTilePos:Index, pMapSize:SizeOnMap):Void {
		colMax = pTilePos.x + pMapSize.width-1; // (0 en haut, 10 à droite)
		colMin = pTilePos.x;
		rowMax = pTilePos.y + pMapSize.height-1; // (0 en haut, 10 à gauche)
		rowMin = pTilePos.y;
	}
	
	/**
	 * Get the rounded position in map view
	 * Prefer using floor position when you can.
	 * @param	pPos
	 * @return
	 */
	private function getRoundMapPos(pPos:Point):Index {
		var lPoint:Point = IsoManager.isoViewToModel(pPos);
		return {
			x: cast(Math.round(lPoint.x), Int),
			y: cast(Math.round(lPoint.y), Int)
		};
	}
	
	override public function recycle():Void {
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
		removePhantomFilter();
		removeDesaturateFilter();
		removeBuildListeners();
		super.recycle();
	}
	
	override public function destroy():Void {
		// todo : verify all destroy methods
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
		removeBuildListeners();
		super.destroy();
	}
	
	public static function destroyStatic():Void {
		container.parent.removeChild(container);
		currentSelectedBuilding.destroy();
		currentSelectedBuilding = null;
		container = null;
		for (i in 0...list.length)
			list[i].destroy();
		list = null;
	}
	
	
	//{ ################# State_Phantom #################
		
	/**
	 * Create a Phantom Building
	 * @param	pAssetName
	*/ // todo : le onClick doit se trouve ds l'hud et la function createPhantombuilding ici
	public static function onClickHudBuilding(pAssetName:String):Void {
		if (currentSelectedBuilding == null)
			createPhantom(pAssetName);
		else if (currentSelectedBuilding.assetName != pAssetName) {
			removePhantom();
			createPhantom(pAssetName);
		}
		else if (currentSelectedBuilding.assetName == pAssetName)
			removePhantom();
	}
	
	private static function createPhantom(pAssetName:String):Void
	{
		firstClickSuck = true;
		currentSelectedBuilding = PoolingManager.getFromPool(pAssetName);
		currentSelectedBuilding.position = MouseManager.getInstance().positionInGame;
		container.addChild(currentSelectedBuilding);
		currentSelectedBuilding.init();
		currentSelectedBuilding.setModePhantom();
		FootPrint.createShadow();
	}
	
	private static function removePhantom():Void {
		FootPrint.removeShadow();
		currentSelectedBuilding.recycle();
		currentSelectedBuilding = null;
	}
	
	/**
	 * Listen to click or touch_end to build the building
	 */
	private function addBuildListeners():Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
			Browser.window.addEventListener(MouseEventType.CLICK, onMouseTouchClick);
		else
			Browser.window.addEventListener(TouchEventType.TOUCH_END, onMouseTouchClick);
	}
	
	private function removeBuildListeners():Void {
		Browser.window.removeEventListener(MouseEventType.CLICK, onMouseTouchClick);
		Browser.window.removeEventListener(TouchEventType.TOUCH_END, onMouseTouchClick);
	}
	
	// todo : renommer je crois qu'il les nomment différemment
	public function setModePhantom():Void {
		addPhantomFilter();
		doAction = doActionPhantom;
		addBuildListeners();
		setState(DEFAULT_STATE); // <-- pas intuitif ! todo sûr que nécessaire ?
	}
	
	/**
	 * Remove the building to change it position
	 * @param	pVBuilding the reference virtual initial tile, to destroy it from the region and save managers 
	 */
	public function setModeMove(pVBuilding:VBuilding):Void{
		isMove = true;
		isFirstClickAfterMoved = true;
		
		addPhantomFilter();
		vBuildingRef = pVBuilding;
		
		if (currentSelectedBuilding != null) currentSelectedBuilding = null;
		currentSelectedBuilding = this;
		
		FootPrint.createShadow();
		
		doAction = doActionPhantom;
		addBuildListeners();
		setState(DEFAULT_STATE); //Todo: à enlever?
	}
	/**
	 * Move the ground center of the building on the mouse pointer.
	 */
	private function doActionPhantom():Void {
		//deplacement en fonction de la position
		FootPrint.footPrint.position = new Point(currentSelectedBuilding.x + FootPrint.footPrintPoint.x, (currentSelectedBuilding.y + FootPrint.footPrintPoint.y)*2);
		
		var buildingGroundCenter:Point = getBuildingGroundCenter();
		var perfectMouseFollow:Point = new Point(
			MouseManager.getInstance().positionInGame.x + x - buildingGroundCenter.x,
			MouseManager.getInstance().positionInGame.y + y - buildingGroundCenter.y
		);
		var bestMapPos:Index = getRoundMapPos(perfectMouseFollow);
		
		position = IsoManager.modelToIsoView(new Point(
			bestMapPos.x,
			bestMapPos.y
		));
		
		// optimization to make less call to canBuiltHere();
		if (precedentBesMapPos.x != bestMapPos.x ||
			precedentBesMapPos.y != bestMapPos.y) {
			
			if (canBuildHere())
				removeDesaturateFilter();
			else
				addDesaturateFilter();
		}
		
		precedentBesMapPos.copy(new Point(
			bestMapPos.x,
			bestMapPos.y
		));
	}
	
	/**
	 * Get the center of the building from the map view (center on Ground)
	 * @return
	 */
	private function getBuildingGroundCenter():Point {
		var mapPos:Index = getRoundMapPos(position);
		
		return IsoManager.modelToIsoView(new Point(
			mapPos.x + ASSETNAME_TO_MAPSIZE[assetName].width / 2,
			mapPos.y + ASSETNAME_TO_MAPSIZE[assetName].height / 2
		));
	}
	
	private function onMouseTouchClick():Void {
		if (firstClickSuck) {
			firstClickSuck = false;
			return;
		}
		
		// todo : confirm build ? (êtes vous sûr de vouloir placer le bâtiment ici ? genre hud contextuel)
		if (canBuildHere())
			newBuild();
		else
			displayCantBuild(); // todo hud method ?
	}
	
	/**
	 * Verify that you can build on the specified space.
	 * @param	pRect
	 */
	private function canBuildHere():Bool {
		setMapColRow(getRoundMapPos(position), ASSETNAME_TO_MAPSIZE[assetName]);
		regionMap = getRegionMap();
		//trace(regionMap);
		// between region or region don't exist
		if (regionMap == null)
			return false;
		
		return buildingOnGround() && buildingCollideOther();
	}
	
	
	private function getRegionMap ():RegionMap {
		var lRegion:Index = RegionManager.tilePosToRegion({
			x:colMin,
			y:rowMin
		});
		var lRegionFirstTile:Index;
		
		// between region or region don't exist
		if (lRegion == null)
			return null;
		
		lRegionFirstTile = RegionManager.worldMap[lRegion.x][lRegion.y].desc.firstTilePos;
		
		return {
			regionFirstTile: lRegionFirstTile,
			region : lRegion,
			map : {
				x: colMin - lRegionFirstTile.x,
				y: rowMin - lRegionFirstTile.y
			}
		}
	}
	
	/**
	 * Verify that the building in fully in the region before building it. Check only 2/4 sides.
	 * @return
	 */
	private function buildingOnGround():Bool {
		
		var lRegionSize:SizeOnMap = { width:0, height:0, footprint:0 }; // todo: autre typedef ss footprint
		// todo : factoriser avec une map Region.REGION_TYPE_TO_SIZE
		lRegionSize.width = RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type == RegionType.styx ? Ground.COL_X_STYX_LENGTH : Ground.COL_X_LENGTH;
		lRegionSize.height = RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type == RegionType.styx ? Ground.ROW_Y_STYX_LENGTH : Ground.ROW_Y_LENGTH;
		
		return (regionMap.map.x + ASSETNAME_TO_MAPSIZE[assetName].width <= lRegionSize.width &&
				regionMap.map.y + ASSETNAME_TO_MAPSIZE[assetName].height <= lRegionSize.height);
		
		// todo : factoriser (return le if inversé)
		/*if (colMin < regionFirstTile.x || rowMin < regionFirstTile.y ||
			colMax >= regionFirstTile.x + Ground.COL_X_LENGTH ||
			rowMax >= regionFirstTile.y + Ground.ROW_Y_LENGTH)
			return false;
		return true;*/
	}
	
	/**
	 * verify that the building doesn't collapse another one.
	 * Use the TileDescription in Save instead of only instantiated (visible) buildings.
	 * @return
	 */
	private function buildingCollideOther():Bool {

		for (x in RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building.keys()) {
			for (y in RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building[x].keys()) {
				if (collisionRectDesc(RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building[x][y].tileDesc))
					return false;
			}
		}
		
		return true;
	}
	
	/**
	 * Test collision between instance and a TileDescription from Save
	 * Permit that uninstanciated (unshow) building still make collision !
	 */
	private function collisionRectDesc(pVirtual:TileDescription):Bool {
		var lPoint:Float; // todo @Alexis: lPoint correpond à quoi ?
		
		if (ASSETNAME_TO_MAPSIZE[pVirtual.assetName].footprint == 0 ||
			ASSETNAME_TO_MAPSIZE[currentSelectedBuilding.assetName].footprint == 0)
			lPoint = 0;
		else
			lPoint = ASSETNAME_TO_MAPSIZE[currentSelectedBuilding.assetName].footprint;

		// todo :  créer méthode de collision classique entre deux rect et donner ces valeurs ci-dessous en paramètres.
		return (regionMap.map.x < pVirtual.mapX + ASSETNAME_TO_MAPSIZE[pVirtual.assetName].width + lPoint &&
				regionMap.map.x + ASSETNAME_TO_MAPSIZE[assetName].width > pVirtual.mapX - lPoint &&
				regionMap.map.y < pVirtual.mapY + ASSETNAME_TO_MAPSIZE[pVirtual.assetName].height + lPoint &&
				regionMap.map.y + ASSETNAME_TO_MAPSIZE[assetName].height > pVirtual.mapY - lPoint );
	}
	
	
	/**
	 * User has added a new Building,
	 * Add a new VBuilding, update clipping and save.
	 * // pas de court-circuitage de VCell, pas non plus de création inversé (Building puis VCell)
	 */
	private function newBuild():Void {
		// todo :
		// Type.getClassName ? but path whit it ?
		// what do you do if the path change between version and not in save ?
		
		
		var tileDesc:TileDescription = {
			className:"Building", // todo : à revoir
			assetName:assetName,
			id:IdManager.newId(),
			regionX:regionMap.region.x,
			regionY:regionMap.region.y,
			mapX:regionMap.map.x,
			mapY:regionMap.map.y
		};
		var vBuilding:VBuilding = new VBuilding(tileDesc);
		vBuilding.activate(); // todo : petite opti en mettant le building en param de activate
		vBuilding = null; // todo : inutile ? :o
		
		removePhantom();
		
		//Note: tentative de supression de la vbuilding de la mémoire, pas fonctionnel mais ne fait rien buguer
		if (isMove) {
			if (vBuildingRef != null) RegionManager.removeToRegionBuilding(vBuildingRef);
			isMove = false;
		}
		
		SaveManager.save();
		sortBuildings();
		
		isMove = false;
	}
	
	/**
	 * todo : HUD method
	 */
	private function displayCantBuild():Void {
		trace("Can't Build Here !");
	}
	
	/**
	 * Reduce alpha
	 */
	private function addPhantomFilter():Void {
		alpha = FILTER_OPACITY;
	}
	
	private function removePhantomFilter():Void {
		alpha = 1.0;
	}
	
	/**
	 * Building become grey !
	 */
	private function addDesaturateFilter():Void {
		if (filters == null)
			filters = [colorMatrix];
	}
	
	private function removeDesaturateFilter():Void {
		filters = null;
	}

	//} endRegion
	
	
	//{ ################# HudContextual #################
	
	private function addListenerOnClick ():Void {
		on(MouseEventType.CLICK, onClick);
	}
	
	private function onClick ():Void {
		// note à Emeline : todo décommente la ligne ci-dessous et continue le travail
		//HudContextual.createOnBuilding(cast(linkedVirtualCell, VBuilding));
		if (isFirstClickAfterMoved) isFirstClickAfterMoved = false; //Avoid the poping of the building's hud when it's clicked for the first time
		else {
			// todo : s'arranger pr ne pas avoir à cast ?
			cast(linkedVirtualCell, VBuilding).onClick();
		}
	}
	
	//} endRegion
}