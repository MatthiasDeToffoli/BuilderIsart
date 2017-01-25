package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

typedef SizeOnMap = {
	var width:Int;
	var height:Int;
	var footprint:Int;
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
class Building extends Tile implements IZSortable
{
	/*public static var BUILDING_NAME_TO_MAPSIZE(default, never):Map<String, SizeOnMap> = [ //@TODO obtenir de bdd
		BuildingName.STYX_PURGATORY => {width:3, height:3, footprint : 1},
		BuildingName.STYX_VICE => {width:3, height:1, footprint : 1},
		BuildingName.STYX_VIRTUE => {width:3, height:2, footprint : 1},
		BuildingName.STYX_MARKET => { width:2, height:3, footprint : 1 },
		
		
		BuildingName.HEAVEN_HOUSE => {width:2, height:2, footprint : 1},
		BuildingName.HEAVEN_COLLECTOR => {width:2, height:3, footprint : 1},
		BuildingName.HEAVEN_MARKETING_DEPARTMENT => {width:3, height:1, footprint : 1},
		BuildingName.HEAVEN_DECO_GENERIC_TREE => {width:1, height:1, footprint : 1},
		BuildingName.HEAVEN_DECO_BIGGER_TREE => {width:1, height:1, footprint : 1},
		BuildingName.HEAVEN_DECO_PRETTY_TREE => {width:1, height:1, footprint : 1},
		BuildingName.HEAVEN_DECO_AWESOME_TREE => {width:1, height:1, footprint : 1},
		BuildingName.HEAVEN_DECO_BUILDING => {width:2, height:2, footprint : 1},
		BuildingName.HEAVEN_DECO_GORGEOUS_BUILDING => { width:2, height:2, footprint : 1 },
		
		
		BuildingName.HELL_HOUSE => {width:1, height:2, footprint : 1},
		BuildingName.HELL_COLLECTOR => {width:3, height:2, footprint : 1},
		BuildingName.HELL_FACTORY => {width:1, height:3, footprint : 1},
		BuildingName.HELL_DECO_GENERIC_ROCK => {width:1, height:1, footprint : 1},
		BuildingName.HELL_DECO_BIGGER_ROCK => {width:1, height:1, footprint : 1},
		BuildingName.HELL_DECO_PRETTY_ROCK => {width:1, height:1, footprint : 1},
		BuildingName.HELL_DECO_AWESOME_ROCK => {width:1, height:1, footprint : 1},
		BuildingName.HELL_DECO_BUILDING => {width:2, height:2, footprint : 1},
		BuildingName.HELL_DECO_GORGEOUS_BUILDING => { width:2, height:2, footprint : 1 },
		
		
		BuildingName.HOUSE_INTERNS => {width:2, height:2, footprint : 1},
	];*/
	
	public static var list:Array<Building>;
	
	private static var container:Container;	
	private static var uiContainer:Container;	
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;
	
	public static var isClickable:Bool = true;

	
	/**
	 * Initialisation of Building class, should be called after Ground class initialisation.
	 */
	public static function initClass():Void {
		container = new Container();
		uiContainer = new Container();
		container.position = Ground.container.position;
		uiContainer.position = container.position;
		GameStage.getInstance().getBuildContainer().addChild(container);
		GameStage.getInstance().getGameContainer().addChild(uiContainer);
		list = new Array<Building>();
	}
	
	// todo : optimisé (réduire) l'appelle à la function GameConfig.getBuildingByName (à travers getSizeOnMap)
	public static function getSizeOnMap (pBuildingName:String):SizeOnMap {
		return {
			width: GameConfig.getBuildingByName(pBuildingName).width,
			height: GameConfig.getBuildingByName(pBuildingName).height,
			footprint: GameConfig.getBuildingByName(pBuildingName).footPrint
		}
	}
	
	/**
	 * Z-Sorting of Building container.
	 */
	public static function sortBuildings():Void {
		container.children = IsoManager.sortTiles(container.children);
	}
	
	public static function getBuildingHudContainer():Container{
		return uiContainer;
	}
	
	public static function getBuildingContainer():Container{
		return container;
	}
	/**
	 * Create a Building Tile, addchild it and start it.
	 * @param	pTileDesc
	 * @return
	 */
	public static function createBuilding(pTileDesc:TileDescription):Building {
		var lBuilding:Building = PoolingManager.getFromPool(BuildingName.getAssetName(pTileDesc.buildingName, pTileDesc.level));
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
			Building.getSizeOnMap(pTileDesc.buildingName)
		);
		list.push(lBuilding);
		lBuilding.init();
		container.addChild(lBuilding);
		lBuilding.start(); // todo : start ailleurs pr éviter clic de trop ?
		
		return lBuilding;
	}
	
	
	public function new(?pAssetName:String) {
		super(pAssetName);	
	}
	
	// attention phantom n'herite pas de ceci !
	override public function start():Void {
		super.start();
		
		interactive = true;
		buttonMode = true;
		
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
	
	override public function recycle():Void {
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
		
		super.recycle();
	}
	
	override public function destroy():Void {
		// todo destroy incomplet ?
		// todo : suppri;er de behind and front du zsorting ?
		Interactive.removeListenerClick(this, onClick);
		off(MouseEventType.MOUSE_OVER, changeCursor);
		
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
			
		super.destroy();
	}
	
	public static function destroyStatic():Void {
		container.parent.removeChild(container);
		container = null;
		for (i in 0...list.length)
			list[i].destroy();
		list = null;
	}	
	
	//{ ################# HudContextual #################
	
	private function addListenerOnClick ():Void {
		Interactive.addListenerClick(this, onClick);
		on(MouseEventType.MOUSE_OVER, changeCursor);
		
	}
	
	private function onClick ():Void {
		if (isClickable) cast(linkedVirtualCell, VBuilding).onClick(position);
	}
	
	private function changeCursor():Void{
		if (isClickable) defaultCursor = "pointer";
		
		else defaultCursor = "default";
	}
	//} endRegion
}