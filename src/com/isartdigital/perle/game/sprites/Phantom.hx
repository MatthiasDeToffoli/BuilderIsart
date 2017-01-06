package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.sprites.Building.RegionMap;
import com.isartdigital.perle.game.sprites.Building.SizeOnMap;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

/**
 * Only graphic class, doesn't have any logical part (no VPhantom)
 * @author ambroise
 */
class Phantom extends Building {
	
	
	private static inline var FILTER_OPACITY:Float = 0.5;
	
	private static var colorMatrix:ColorMatrixFilter;
	private static var instance:Phantom;
	private static var container:Container;
	
	private var linkedVBuilding:VBuilding;
	private var mouseDown:Bool;
	private var regionMap:RegionMap;
	private var precedentBesMapPos:Point = new Point(0, 0);
	
	public static function initClass ():Void {
		container = new Container();
		colorMatrix = new ColorMatrixFilter();
		colorMatrix.desaturate(false);
		GameStage.getInstance().getGameContainer().addChild(container);
	}
	
	public static function gameLoop():Void {
		if (instance != null)
			instance.doAction();
	}
	
	public static function onClickShop (pAssetName:String):Void {
		createPhantom(pAssetName);
	}
	
	/**
	 * When VBuilding want to move.
	 * @param	pAssetName
	 * @param	pVBuilding
	 */
	public static function onClickMove (pAssetName:String, pVBuilding:VBuilding):Void {
		createPhantom(pAssetName);
		instance.linkedVBuilding = pVBuilding;
		instance.position = pVBuilding.graphic.position;
		trace(instance.linkedVBuilding);
		trace("alignement : " + instance.linkedVBuilding.alignementBuilding);
	}
	
	public static function onClickCancelBuild ():Void {
		instance.destroy();
	}
	
	public static function onClickCancelMove ():Void {
		instance.destroy();
	}
	
	public static function onClickConfirmBuild ():Void {
		instance.confirmBuild();
	}
	public static function onClickConfirmMove ():Void {
		instance.confirmMove();
	}
	
	private static function createPhantom (pAssetName:String):Void {
		if (instance != null && instance.assetName == pAssetName)
			return;
		else if (instance != null && instance.assetName != pAssetName)
			throw("instance must be destroyed before creating another phantom");
		
		
		instance = new Phantom(pAssetName);//PoolingManager.getFromPool(pAssetName, Phantom); assetName correspond à Building...
		// todo : revoir Pooling ?s
		instance.init();
		container.addChild(instance);
		FootPrint.createShadow(instance);
		instance.start();
	}
	

	// todo : le onClick doit se trouve ds l'hud et la function createPhantombuilding ici
	/*public static function onClickHudBuilding(pAssetName:String):Void {
		if (currentSelectedBuilding == null)
			createPhantom(pAssetName);
		else if (assetName != pAssetName) {
			removePhantom();
			createPhantom(pAssetName);
		}
		else if (assetName == pAssetName)
			removePhantom();
	}*/
	
	public function new(?pAssetName:String) {
		super(pAssetName);
	}
	
	override public function init():Void {
		super.init();
		if (position.x == 0 && position.y == 0)
			position = CameraManager.getCameraCenter();
	}
	
	override public function start():Void {
		setModePhantom();
		interactive = true;
		addBuildListeners();
	}
	
	
	/**
	 * Listen to click or touch_end to build the building
	 */
	private function addBuildListeners():Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) {
			on(MouseEventType.MOUSE_DOWN, onMouseDown2);
			on(MouseEventType.MOUSE_UP, onMouseUp2);
		}
		else {
			on(TouchEventType.TOUCH_START, onMouseDown2);
			on(TouchEventType.TOUCH_END, onMouseUp2); // todo : touch_end outside c'est ?
		}
	}
	
	private function removeBuildListeners():Void {
		removeListener(MouseEventType.MOUSE_DOWN, onMouseDown);
		removeListener(MouseEventType.MOUSE_UP, onMouseUp);
		removeListener(TouchEventType.TOUCH_START, onMouseDown);
		removeListener(TouchEventType.TOUCH_END, onMouseUp);
		
	}
	
	// todo : renommer je crois qu'il les nomment différemment
	private function setModePhantom():Void {
		addPhantomFilter();
		doAction = doActionPhantom;
		addBuildListeners();
		setState(DEFAULT_STATE); // <-- pas intuitif ! todo sûr que nécessaire ?
		//FootPrint.createShadow();
	}
	
	/**
	 * Move the ground center of the building on the mouse pointer.
	 */
	private function doActionPhantom():Void {
		// si click sur batiment et reste enfoncé, touch and hold
		if (mouseDown)
			movePhantomOnMouse();

	}
	
	private function movePhantomOnMouse ():Void {
		FootPrint.doActionShadow();
		
		/*FootPrint.footPrint.position = new Point( // todo : une frame de retard ? mettre à la fin de cette fc ?
			currentSelectedBuilding.x + footPrintPoint.x,
			(currentSelectedBuilding.y + footPrintPoint.y) * 2
		);*/
		
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
			mapPos.x + Building.ASSETNAME_TO_MAPSIZE[assetName].width / 2,
			mapPos.y + Building.ASSETNAME_TO_MAPSIZE[assetName].height / 2
		));
	}
	
	private function confirmBuild ():Void {
		if (canBuildHere()) {
			newBuild();
		} else {
			displayCantBuild();
		}
	}
			
	private function confirmMove ():Void {
		if (canBuildHere()) {
			
			linkedVBuilding.move(regionMap);
			Hud.getInstance().changeBuildingHud(BuildingHudType.HARVEST, linkedVBuilding); 
			destroy();
			applyChange();
			
		} else
			displayCantBuild(); // todo hud method ?
	}
	
	// todo : creation a partir de building create en static ?
	private function newBuild():Void {
		
		if (BuyManager.buy(assetName)) {
			var tileDesc:TileDescription = {
				className:"Building", // todo : à revoir, enlever ? (problème semblable au pb du pooling) (House pour hell et heaven ?) (non, car casse le pooling)
				assetName:assetName,
				id:IdManager.newId(),
				regionX:regionMap.region.x,
				regionY:regionMap.region.y,
				mapX:regionMap.map.x,
				mapY:regionMap.map.y
			};

			var vBuilding:VBuilding = new VBuilding(tileDesc);
			vBuilding.activate();
			Hud.getInstance().changeBuildingHud(BuildingHudType.HARVEST, vBuilding); // todo : mettre contruction
			destroy();
			
			
			applyChange();
		} else {
			displayCantBuy();
		}
	}
	
	private function applyChange ():Void {
		SaveManager.save();
		Building.sortBuildings();
	}
	
	/**
	 * Verify that you can build on the specified space.
	 * @param	pRect
	 */
	private function canBuildHere():Bool {
		setMapColRow(getRoundMapPos(position), Building.ASSETNAME_TO_MAPSIZE[assetName]);
		regionMap = getRegionMap();
		
		if (instance.linkedVBuilding.alignementBuilding == VBuilding.ALIGNEMENT_ALL)
			return buildingOnGround() && buildingCollideOther();
			
		// between region or region don't exist
		if (regionMap == null || RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type.getName() != instance.linkedVBuilding.alignementBuilding)
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
		
		return (regionMap.map.x + Building.ASSETNAME_TO_MAPSIZE[assetName].width <= lRegionSize.width &&
				regionMap.map.y + Building.ASSETNAME_TO_MAPSIZE[assetName].height <= lRegionSize.height);
	}
	
	/**
	 * verify that the building doesn't collapse another one.
	 * Use the TileDescription in Save instead of only instantiated (visible) buildings.
	 * @return
	 */
	private function buildingCollideOther():Bool {

		for (x in RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building.keys()) {
			for (y in RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building[x].keys()) {
				
				// ignore currently moving building
				// i prefer not to remove it from the worldMap
				// because if someone savee() while the building is moving
				// the player will loose that building ! :(
				if (RegionManager.worldMap[regionMap.region.x][regionMap.region.y].building[x][y].currentState == VBuildingState.isMoving)
					continue;
				
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
		
		if (Building.ASSETNAME_TO_MAPSIZE[pVirtual.assetName].footprint == 0 ||
			Building.ASSETNAME_TO_MAPSIZE[assetName].footprint == 0)
			lPoint = 0;
		else
			lPoint = Building.ASSETNAME_TO_MAPSIZE[assetName].footprint;

		// todo :  créer méthode de collision classique entre deux rect et donner ces valeurs ci-dessous en paramètres.
		return (regionMap.map.x < pVirtual.mapX + Building.ASSETNAME_TO_MAPSIZE[pVirtual.assetName].width + lPoint &&
				regionMap.map.x + Building.ASSETNAME_TO_MAPSIZE[assetName].width > pVirtual.mapX - lPoint &&
				regionMap.map.y < pVirtual.mapY + Building.ASSETNAME_TO_MAPSIZE[pVirtual.assetName].height + lPoint &&
				regionMap.map.y + Building.ASSETNAME_TO_MAPSIZE[assetName].height > pVirtual.mapY - lPoint );
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
	
	/**
	 * Return true if user is making a new build.
	 * @return
	 */
	public static function isMoving():Bool {
		return instance != null && instance.mouseDown;
	}
	
	// Interation Manager being annoying becaus he has a unusable OnMouseDown Property !
	function onMouseDown2 ():Void {
		mouseDown = true;
	}
	
	function onMouseUp2 ():Void {
		mouseDown = false;
	}
	
	//todo : HUD method
	private function displayCantBuild ():Void {
		BHMoving.getInstance().cantBuildHere();
	}
	
	private function displayCantBuy ():Void {
		Debug.error("tentative de pose de bâtiment, mais currencie insuffisante");
		trace("comment ce-ci peut-il arriver ?");
	}
	
	
	
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
	
	// revoir pooling met assetName différent class :s
	/*override public function recycle():Void {
		linkedVBuilding = null;
		instance = null;
		removePhantomFilter();
		removeDesaturateFilter();
		removeBuildListeners();
		
		super.recycle();
	}*/
	
	override public function destroy():Void {
		FootPrint.removeShadow();
		linkedVBuilding = null;
		instance = null;
		removePhantomFilter();
		removeDesaturateFilter();
		removeBuildListeners();
		
		super.destroy();
	}
	
	
}