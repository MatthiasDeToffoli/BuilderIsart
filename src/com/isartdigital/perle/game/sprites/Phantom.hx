package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.BuildingLimitManager;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.sprites.Building.RegionMap;
import com.isartdigital.perle.game.sprites.Building.SizeOnMap;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.game.virtual.vBuilding.vHell.VHouseHell;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import eventemitter3.EventEmitter;
import haxe.Json;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.filters.color.ColorMatrixFilter;


typedef EventExceeding = {
	var phantomPosition:Point;
	var exceedingTile:Array<Index>;
}

/**
 * Only graphic class, doesn't have any logical part (no VPhantom)
 * No Pooling on this class !
 * @author ambroise
 */
class Phantom extends Building {
	
	public static inline var EVENT_CANT_BUILD:String = "Phantom_Cant_Build";
	private static inline var FILTER_OPACITY:Float = 0.5;
	private static inline var MAX_DURATION_FOR_CLICK:Int = 500;// milliseconds
	
	public static var eExceedingTiles:EventEmitter;
	private static var exceedingTile:Array<Index>;
	private static var colorMatrix:ColorMatrixFilter;
	private static var instance:Phantom;
	private static var container:Container;
	private static var alignementBuilding:Alignment;
	public var buildingName:String;
	private var mouseDown:Bool;
	private var regionMap:RegionMap;
	private var precedentBesMapPos:Point = new Point(0, 0);
	private var vBuilding:VBuilding;
	private var mouseDownDuration:Int = 0;// milliseconds
	private var touchUpdateNeeded:Bool;
	
	public static function initClass ():Void {
		container = new Container();
		colorMatrix = new ColorMatrixFilter();
		colorMatrix.desaturate(false);
		GameStage.getInstance().getBuildContainer().addChild(container);
		eExceedingTiles = new EventEmitter();
		exceedingTile = [];
	}
	
	public static function gameLoop():Void {
		if (instance != null)
			instance.doAction();
	}
	
	public static function onClickShop (pBuildingName:String):Void {
		alignementBuilding = GameConfig.getBuildingByName(pBuildingName).alignment;//Virtual.BUILDING_NAME_TO_ALIGNEMENT[pBuildingName];  
		createPhantom(pBuildingName);
	}
	
	/**
	 * When VBuilding want to move.
	 * @param	pAssetName
	 * @param	pVBuilding
	 */
	public static function onClickMove (pBuildingName:String, pVBuilding:VBuilding):Void {
		alignementBuilding = GameConfig.getBuildingByName(pBuildingName).alignment;//Virtual.BUILDING_NAME_TO_ALIGNEMENT[pBuildingName];
		createPhantom(pBuildingName);
		instance.vBuilding = pVBuilding;
		instance.position = pVBuilding.graphic.position;
	}
	
	public static function onClickCancelBuild ():Void {
		instance.destroy();
	}
	
	public static function onClickCancelMove ():Void {
		instance.destroy();
	}
	
	private function onClickConfirm ():Void {
		if (BuildingHud.virtualBuilding == null)
			Phantom.onClickConfirmBuild();
		else
			BuildingHud.virtualBuilding.onClickConfirm();
	}
	
	public static function onClickConfirmBuild ():Void {
		instance.confirmBuild();
	}
	
	public static function onClickConfirmMove ():Void {
		if (instance == null)
			Debug.error("instance is null in Phantom.hx, this has to be debug, @Vicktor : and not necessarely by doing 'if (instance != null)'");
		if (instance != null) instance.confirmMove();
	}
	
	/**
	 * Create a Building whitout any VBuilding that is used when moving building or creating a new building.
	 * @param	pBuildingName
	 */
	private static function createPhantom (pBuildingName:String):Void {
		if (instance != null && instance.assetName == BuildingName.getAssetName(pBuildingName))
			return;
		else if (instance != null && instance.assetName != BuildingName.getAssetName(pBuildingName))
			Debug.error("instance must be destroyed before creating another phantom");
		
		Hud.getInstance().hide();
		Building.isClickable = false;
		instance = new Phantom(BuildingName.getAssetName(pBuildingName));//PoolingManager.getFromPool(pAssetName, Phantom); assetName correspond à Building...
		instance.setBuildingName(pBuildingName);
		instance.init();
		container.addChild(instance);
		FootPrint.createShadow(instance);
		instance.start();
	}
	
	public function new(?pAssetName:String) {
		super(pAssetName);
	}
	
	public function setBuildingName (pBuildingName:String):Void {
		buildingName = pBuildingName;
	}
	
	override public function init():Void {
		super.init();
		initPosition();
	}
	
	/**
	 * put the building in the center of camera
	 */
	private function initPosition ():Void {
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
		on(MouseEventType.MOUSE_DOWN, onMouseDown2);
		on(MouseEventType.MOUSE_UP, onMouseUp2);
		on(MouseEventType.MOUSE_MOVE, movePhantomOnMouse);
		
		// TouchEventType.TAP doesn't work either
		// and at last, don't add on(TouchEventType.TOUCH_START, onMouseDown2); 
		// or you can build the building whitout confirmation (like on pc)
		// Browser.window.addEventListener(TouchEventType.TOUCH_END, onTouchStartGlobal);
		GameStage.getInstance().getGameContainer().interactive = true;
		GameStage.getInstance().getGameContainer().on(TouchEventType.TAP, onTouchStartGlobal);
	}
	
	private function removeBuildListeners():Void {
		removeListener(MouseEventType.MOUSE_DOWN, onMouseDown2);
		removeListener(MouseEventType.MOUSE_UP, onMouseUp2);
		removeListener(MouseEventType.MOUSE_MOVE, movePhantomOnMouse);
		GameStage.getInstance().getGameContainer().removeListener(TouchEventType.TAP, onTouchStartGlobal);
	}
	
	private function onTouchStartGlobal (p:Dynamic):Void {
		touchUpdateNeeded = true;
	}
	
	/**
	 * Register the length of a click
	 */
	private function doActionClickBuild ():Void {
		
		if (mouseDown)
			mouseDownDuration += Main.FRAME_INTERVAL;
		else if (mouseDownDuration != 0) {
			validateClickBuild();
			mouseDownDuration = 0;
		}
		else
			mouseDownDuration = 0;
	}
	
	/**
	 * Validate the click to make a new build if the click is short enough
	 */
	private function validateClickBuild ():Void {
		if (mouseDownDuration > 0 && 
			mouseDownDuration <  MAX_DURATION_FOR_CLICK)
			onClickConfirm();
	}
	
	// todo : renommer je crois qu'il les nomment différemment
	private function setModePhantom():Void {
		addPhantomFilter();
		doAction = doActionPhantom;
		addBuildListeners();
		setState(DEFAULT_STATE); // <-- pas intuitif ! todo sûr que nécessaire ?
	}
	
	/**
	 * Move the ground center of the building on the mouse pointer.
	 */
	private function doActionPhantom():Void {
		// si click sur batiment et reste enfoncé, touch and hold
		/*if (mouseDown)
			movePhantomOnMouse();*/
			
		doActionClickBuild();
		
		if (touchUpdateNeeded) {
			touchUpdateNeeded = false;
			movePhantomOnMouse();
		}
	}
	
	private function movePhantomOnMouse ():Void {
		
		/*FootPrint.footPrint.position = new Point( // todo : une frame de retard ? mettre à la fin de cette fc ?
			currentSelectedBuilding.x + footPrintPoint.x,
			(currentSelectedBuilding.y + footPrintPoint.y) * 2
		);*/
		
		var buildingGroundCenter:Point = getBuildingGroundCenter();
		var perfectMouseFollow:Point = new Point(
			MouseManager.getInstance().positionInGame.x + x - buildingGroundCenter.x,
			MouseManager.getInstance().positionInGame.y + y - buildingGroundCenter.y
		);
		
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) {
			perfectMouseFollow.y -= instance.height / 2;
		}
		
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
				
			emitExceeding();
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
			mapPos.x + Building.getSizeOnMap(buildingName).width / 2,
			mapPos.y + Building.getSizeOnMap(buildingName).height / 2
		));
	}
	
	private function confirmBuild ():Void {
		if (canBuildHere()) {
			newBuild();
			Building.isClickable = true;
		} else {
			displayCantBuild();
		}
	}
			
	private function confirmMove ():Void {
		if (canBuildHere()) {
			
			// deepCopy.
			var lOldDesc:TileDescription = Json.parse(Json.stringify(vBuilding.tileDesc));
			
			vBuilding.move(regionMap);
			Hud.getInstance().changeBuildingHud(BuildingHudType.HARVEST, vBuilding); 
			trace("movePhantom " + Building.isClickable);
			Building.isClickable = true;
			destroy();
			
			SaveManager.saveMoveBuilding(lOldDesc, vBuilding.tileDesc);
			applyChange();
			
		} else
			displayCantBuild(); // todo hud method ?
	}
	
	// todo : creation a partir de building create en static ?
	private function newBuild():Void {
		
		if (BuyManager.canBuy(buildingName)) {
			BuyManager.buy(buildingName);
			var newId = IdManager.newId();
			var tTime:Float = Date.now().getTime();
			var tileDesc:TileDescription = {
				buildingName:buildingName,
				id:newId,
				regionX:regionMap.region.x,
				regionY:regionMap.region.y,
				mapX:regionMap.map.x,
				mapY:regionMap.map.y,
				level:1,
				timeDesc: { refTile:newId,  end: tTime + 20000, progress: 0, creationDate: tTime }
			};
			
			vBuilding = Type.createInstance(Type.resolveClass(Main.getInstance().getPath(Virtual.BUILDING_NAME_TO_VCLASS[buildingName])), [tileDesc]);
			
			vBuilding.activate();
			Hud.getInstance().changeBuildingHud(BuildingHudType.CONSTRUCTION, vBuilding);
			
			if (DialogueManager.ftueStepPutBuilding)
				DialogueManager.endOfaDialogue();
			
			vBuilding.addExp();
			destroy();
			
			
			SaveManager.saveNewBuilding(tileDesc);
			applyChange();	
		} else {
			displayCantBuy();
		}
		
	}
	
	/*private function addExp():Void {
		//todo pas une valeur en dur : 100
		if (alignementBuilding == null || alignementBuilding == Alignment.neutral) {
			ResourcesManager.takeXp(100, GeneratorType.badXp);
			ResourcesManager.takeXp(100, GeneratorType.goodXp);
		}
		else if (alignementBuilding == Alignment.hell)
			ResourcesManager.takeXp(100, GeneratorType.badXp);
		else if (alignementBuilding == Alignment.heaven)
			ResourcesManager.takeXp(100, GeneratorType.goodXp);
			
	}*/
	
	public static function firstBuildForFtue():Void {
		var newId = IdManager.newId();
		var tTime:Float = Date.now().getTime();
		var lBuilding:VBuilding;
		var lBuildinName:String = "Hell House";
		var tileDesc:TileDescription = {
			buildingName:lBuildinName,
			id:newId,
			regionX:1,
			regionY:0,
			mapX:0,
			mapY:0,
			level:0,
			timeDesc: { refTile:newId,  end: tTime + 0, progress: 0, creationDate: tTime }
		};
		
		lBuilding = Type.createInstance(Type.resolveClass(Main.getInstance().getPath(Virtual.BUILDING_NAME_TO_VCLASS[lBuildinName])), [tileDesc]);
		
		lBuilding.activate();
		
		
		SaveManager.save();
		Building.sortBuildings();
		
		cast(lBuilding, VHouseHell).addForFtue();
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
		
		
		setMapColRow(getRoundMapPos(position), Building.getSizeOnMap(buildingName));
		regionMap = getRegionMap();
		
		if (alignementBuilding == null) {
			Debug.error("should not be null in my opinion, i am right ? (this line should never happen, contact Ambroise)");
			return buildingOnGround() && buildingCollideOther(); 
		}
		
		// todo: se concerter avec gd sur ce qu'on veut faire, car compte tenu
		// de la conclusion ci-bas, pour garder de la cohérence on devrait peut-être
		// enlever les case rouge dans le cas d'un dépassement bas ou droite !
		// nice to have : pour avoir les cases en rouges lorsque le batiment est hors région, il faudrait
		// que regionMap ne soit pas null
		// pr cela tilePosToRegion ne doit pas utilser de double boucle à traver le worldRegion
		// mais tout faire par calcul
		// et renvoit la position dans la région ou la batiment se trouve, si cette région n'existe pas il
		// ajoute le bool : "regionExist:Bool = false" dans le retour.
		// et c'est probablement pas tout, car à partir de là il faut déterminer l'écart à avec la/les 
		// régions les plus proches.
		// en fait, ya une solution, c'est dans la fc tilePosToRegion, il faut pas utiliser isInsideRegion seulement
		// mais aussi faire une collision rect-rect
		
		
		// between region/region don't exist OR wrong alignment OR can't have more of this building in this region
		if (regionMap == null || RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type != alignementBuilding || passBuildingLimit()) {
			setExceedingToAll();
			return false;
		}
		
		return buildingOnGround() && buildingCollideOther();
	}
	
	private function passBuildingLimit():Bool {
		return !BuildingLimitManager.canIPastThisBuildingInThisRegion(regionMap.region.x, regionMap.region.y, buildingName) || !BuildingLimitManager.canIPastThisBuilding(buildingName);
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
		lRegionSize.width = RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type == Alignment.neutral ? Ground.COL_X_STYX_LENGTH : Ground.COL_X_LENGTH;
		lRegionSize.height = RegionManager.worldMap[regionMap.region.x][regionMap.region.y].desc.type == Alignment.neutral ? Ground.ROW_Y_STYX_LENGTH : Ground.ROW_Y_LENGTH;
		
		setExceedBuildingOnGround(lRegionSize);
		
		return (regionMap.map.x + Building.getSizeOnMap(buildingName).width <= lRegionSize.width &&
				regionMap.map.y + Building.getSizeOnMap(buildingName).height <= lRegionSize.height);
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
		var lCombinedFootprint:Int; // todo @Alexis: lPoint correpond à quoi ?
		
		/*if (Building.getSizeOnMap(pVirtual.buildingName).footprint == 0 ||
			Building.getSizeOnMap(buildingName].footprint == 0)
			lCombinedFootprint = 0;
		else
			lCombinedFootprint = Building.getSizeOnMap(buildingName).footprint;*/
		// todo : vérifier que tt fonctionne bien
		// avec le truc d'avant, ds le cas ou pVirtual à un footprint de 2 et buildingName de 1,
		// on garderait qu'un footprint de 1.
		lCombinedFootprint = cast(Math.min(
			Building.getSizeOnMap(pVirtual.buildingName).footprint,
			Building.getSizeOnMap(buildingName).footprint
		), Int);
		
		
		setExceedCollisionRectDesc(lCombinedFootprint, pVirtual);
		
		//lPoint = Building.getSizeOnMap(buildingName).footprint;
		
		// todo :  créer méthode de collision classique entre deux rect et donner ces valeurs ci-dessous en paramètres.
		return (regionMap.map.x < pVirtual.mapX + Building.getSizeOnMap(pVirtual.buildingName).width + lCombinedFootprint &&
				regionMap.map.x + Building.getSizeOnMap(buildingName).width > pVirtual.mapX - lCombinedFootprint &&
				regionMap.map.y < pVirtual.mapY + Building.getSizeOnMap(pVirtual.buildingName).height + lCombinedFootprint &&
				regionMap.map.y + Building.getSizeOnMap(buildingName).height > pVirtual.mapY - lCombinedFootprint );
	}
	
	private function setExceedCollisionRectDesc (pCombinedFootprint:Float, pVirtual:TileDescription):Array<Index> {
		var lExceeding:Array<Index> = [];
		
		var lStartBuilding:Index = { 
			x: -Building.getSizeOnMap(buildingName).footprint,
			y: -Building.getSizeOnMap(buildingName).footprint
		};
		var lEndBuilding:Index = { 
			x: Building.getSizeOnMap(buildingName).footprint + Building.getSizeOnMap(buildingName).width,
			y: Building.getSizeOnMap(buildingName).footprint + Building.getSizeOnMap(buildingName).height
		};
		
		// for every building cell excluding footprint
		for (lX in lStartBuilding.x...lEndBuilding.x) {
			for (lY in lStartBuilding.y...lEndBuilding.y) {
				
				var collide:Bool = collisionPointRect( {
					x:lX + regionMap.map.x,
					y:lY + regionMap.map.y
				}, new Rectangle(
					pVirtual.mapX - pCombinedFootprint,
					pVirtual.mapY - pCombinedFootprint,
					Building.getSizeOnMap(pVirtual.buildingName).width + pCombinedFootprint,
					Building.getSizeOnMap(pVirtual.buildingName).height + pCombinedFootprint
				));
				
				if (collide)
					lExceeding.push({
						x:lX,
						y:lY
					});
			}
		}
		
		exceedingTile = exceedingTile.concat(lExceeding);
		
		//trace("setExceedCollisionRectDesc");
		//trace(Json.stringify(lExceeding));
		return lExceeding;
	}
	
	private function setExceedBuildingOnGround (plRegionSize:SizeOnMap):Array<Index> {
		var lExceeding:Array<Index> = [];
		
		var lStartBuilding:Index = { 
			x: 0,//-Building.getSizeOnMap(buildingName).footprint,
			y: 0//-Building.getSizeOnMap(buildingName).footprint
		};
		var lEndBuilding:Index = { 
			x: /*Building.getSizeOnMap(buildingName).footprint + */Building.getSizeOnMap(buildingName).width,
			y: /*Building.getSizeOnMap(buildingName).footprint + */Building.getSizeOnMap(buildingName).height
		};
		
		
		// for every building cell excluding footprint
		for (lX in lStartBuilding.x...lEndBuilding.x) {
			for (lY in lStartBuilding.y...lEndBuilding.y) {
				
				//exceed from bottom or right
				if (lX + regionMap.map.x >= plRegionSize.width ||
					lY + regionMap.map.y >= plRegionSize.height)
					lExceeding.push({
						x:lX,
						y:lY
					});
			}
		}
		//trace("setExceedBuildingOnGround");
		//trace(Json.stringify(lExceeding));
		
		exceedingTile = exceedingTile.concat(lExceeding);
		
		exceedingTile.concat(lExceeding);
		return lExceeding;
	}
	
	/**
	 * The full space under the building is marked not valid to build.
	 */
	private function setExceedingToAll ():Void {
		var lAllExceeding:Array<Index> = [];
		
		for (lX in -Building.getSizeOnMap(buildingName).footprint...Building.getSizeOnMap(buildingName).width+1) {
			for (lY in -Building.getSizeOnMap(buildingName).footprint...Building.getSizeOnMap(buildingName).height+1) {
				lAllExceeding.push({
					x:lX,
					y:lY
				});
			}
		}
		
		exceedingTile = exceedingTile.concat(lAllExceeding);
	}
	
	/**
	 * Emit an array of Point corresponding to invalid tiles, that are blocking construction of the building.
	 * Emitted one time at each mouseMove only.
	 */
	private function emitExceeding ():Void {
		//FootPrint.setPositionFootPrintAssets(this);
		eExceedingTiles.emit(EVENT_CANT_BUILD, {
			phantomPosition: instance.position,
			exceedingTile:exceedingTile
		});
		exceedingTile = [];
	}
	
	private function collisionPointRect (pPoint:Index, pRect:Rectangle):Bool {
		if (    pPoint.x > pRect.x
			&&  pPoint.x < pRect.x + pRect.width
			&&  pPoint.y > pRect.y
			&&  pPoint.y < pRect.y + pRect.height) {
			return true;
		}
		return false;
	};
	
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
	public static function isSet ():Bool {
		return instance != null;
	}
	
	// Interation Manager being annoying becaus he has a unusable OnMouseDown function !
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
		Hud.getInstance().show();
		FootPrint.removeShadow();
		vBuilding = null;
		instance = null;
		removePhantomFilter();
		removeDesaturateFilter();
		removeBuildListeners();
		
		super.destroy();
	}
	
	
}