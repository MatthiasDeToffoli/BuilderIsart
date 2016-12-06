package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

typedef SizeOnMap = {
	var width:Int;
	var height:Int;
}

/**
 * ...
 * @author ambroise
 */
class Building extends Tile implements IZSortable implements PoolingObject
{
	public static var ASSETNAME_TO_MAPSIZE(default, never):Map<String, SizeOnMap> = [
		"Factory" => {width:5, height:3},
		"House" => {width:2, height:2},
		"Trees" => {width:1, height:1},
		"Villa" => {width:3, height:3},
	];
	private static inline var FILTER_OPACITY:Float = 0.5;
	
	public static var list:Array<Building>;
	
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;

	private static var currentSelectedBuilding:Building;
	private static var container:Container;
	private static var colorMatrix:ColorMatrixFilter;
	
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
		
		lBuilding.positionTile(
			pTileDesc.mapX, 
			pTileDesc.mapY
		);
		lBuilding.setMapColRow(
			new Point(pTileDesc.mapX, pTileDesc.mapY),
			ASSETNAME_TO_MAPSIZE[pTileDesc.assetName]
		);
		list.push(lBuilding);
		lBuilding.init();
		container.addChild(lBuilding);
		lBuilding.start();
		return lBuilding;
	}
	
	public static function gameLoop():Void {
		if (currentSelectedBuilding != null)
			currentSelectedBuilding.doAction();
	}
	
	
	public function new(?pAssetName:String) {
		super(pAssetName);
	}
	
	private function setMapColRow(pMapPos:Point, pMapSize:SizeOnMap):Void {
		colMax = cast(pMapPos.x + pMapSize.width-1, UInt); // (0 en haut, 10 à droite)
		colMin = cast(pMapPos.x, UInt);
		rowMax = cast(pMapPos.y + pMapSize.height-1, UInt); // (0 en haut, 10 à gauche)
		rowMin = cast(pMapPos.y, UInt);
	} 
	
	/**
	 * Get the rounded position in map view
	 * Prefer using floor position when you can.
	 * @param	pPos
	 * @return
	 */
	private function getRoundMapPos(pPos:Point):Point {
		var lPoint:Point = IsoManager.isoViewToModel(pPos);
		lPoint.x = Math.round(lPoint.x);
		lPoint.y = Math.round(lPoint.y);
		return lPoint;
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
	 */
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
	
	private static function createPhantom(pAssetName:String):Void {
		firstClickSuck = true;
		currentSelectedBuilding = PoolingManager.getFromPool(pAssetName);
		currentSelectedBuilding.position = MouseManager.getInstance().positionInGame;
		container.addChild(currentSelectedBuilding);
		currentSelectedBuilding.init();
		currentSelectedBuilding.setModePhantom();
	}
	
	private static function removePhantom():Void {
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
	 * Move the ground center of the building on the mouse pointer.
	 */
	private function doActionPhantom():Void {
		var buildingGroundCenter:Point = getBuildingGroundCenter();
		var perfectMouseFollow:Point = new Point(
			MouseManager.getInstance().positionInGame.x + x - buildingGroundCenter.x,
			MouseManager.getInstance().positionInGame.y + y - buildingGroundCenter.y
		);
		var bestMapPos:Point = getRoundMapPos(perfectMouseFollow);
		
		position = IsoManager.modelToIsoView(bestMapPos);
		
		// optimization to make less call to canBuilHere();
		if (precedentBesMapPos.x != bestMapPos.x ||
			precedentBesMapPos.y != bestMapPos.y) {
			
			if (canBuildHere())
				removeDesaturateFilter();
			else
				addDesaturateFilter();
		}
		
		precedentBesMapPos.copy(bestMapPos);
	}
	
	/**
	 * Get the center of the building from the map view (center on Ground)
	 * @return
	 */
	private function getBuildingGroundCenter():Point {
		var mapPos:Point = getRoundMapPos(position);
		
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
		
		// todo : confirm build ?
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
		return buildingOnGround() && buildingCollideOther();
	}
	
	/**
	 * Verify that the building in fully on Ground before building it.
	 * @return
	 */
	private function buildingOnGround():Bool {
		//trace(untyped rowMin); // -1
		//trace(rowMin < 0); // false
		// thx Haxe !
		// (UInt suck)
		
		// todo : factoriser
		if (colMin < 0 || rowMin < 0 ||
			colMax >= Ground.COL_X_LENGTH ||
			rowMax >= Ground.ROW_Y_LENGTH)
			return false;
		return true;
	}
	
	/**
	 * verify that the building doesn't collapse another one.
	 * Use the TileDescription in Save instead of only instantiated (visible) buildings.
	 * @return
	 */
	private function buildingCollideOther():Bool {
		/*for (i in 0... SaveManager.currentSave.building.length) {
			if (collisionRectDesc(SaveManager.currentSave.building[i]))
				return false;
		}*/
		
		for (x in VTile.currentRegion.building.keys()) {
			for (y in VTile.currentRegion.building[x].keys()) {
				if (collisionRectDesc(VTile.currentRegion.building[x][y].tileDesc))
					return false;
			}
		}
		
		return true;
	}
	
	/**
	 * UNUSED
	 * return true if collision between instanciated buildings.
	 * use colMin, colMax, rowMin, rowMax
	 * @param	rect2:Building
	 */
	private function collisionRect(rect2:Building):Bool {
		return (colMin < rect2.colMax+1 &&
				colMax+1 > rect2.colMin &&
				rowMin < rect2.rowMax+1 &&
				rowMax+1 > rect2.rowMin);
	};
	
	/**
	 * Test collision between instance and a TileDescription from Save
	 * Permit that uninstanciated (unshow) building still make collision !
	 */
	private function collisionRectDesc(pVirtual:TileDescription):Bool {
		return (colMin < pVirtual.mapX + ASSETNAME_TO_MAPSIZE[pVirtual.assetName].width &&
				colMax+1 > pVirtual.mapX &&
				rowMin < pVirtual.mapY + ASSETNAME_TO_MAPSIZE[pVirtual.assetName].height &&
				rowMax+1 > pVirtual.mapY);
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
			className:"Building",
			assetName:assetName,
			mapX:colMin,
			mapY:rowMin
		};
		var vBuilding:VBuilding = new VBuilding(tileDesc);
		vBuilding.activate(); // or won't show until clipping ! "ClippingManager.update();" useless here
		vBuilding = null;
		
		removePhantom();
		SaveManager.save();
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

	//} endregion 
}