package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

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
class Building extends Tile implements IZSortable
{
	public static var ASSETNAME_TO_MAPSIZE(default, never):Map<String, SizeOnMap> = [ //@TODO faire un json
		"Factory" => {width:3, height:3, footprint : 1},
		"House" => {width:2, height:2, footprint : 1},
		"Trees" => {width:1, height:1, footprint : 0},
		"Villa" => {width:3, height:3, footprint : 1},
		"Bat_Purgatory_colo_Principal" => {width:3, height:3, footprint : 1},
		"HeavenBuild2" => {width:3, height:3, footprint : 1},
		AssetName.DECO_HEAVEN_TREE_1 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HEAVEN_TREE_2 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HEAVEN_TREE_3 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HEAVEN_FOUNTAIN => {width:1, height:1, footprint : 0},
		AssetName.DECO_HEAVEN_ROCK => {width:1, height:1, footprint : 0},
		AssetName.DECO_HEAVEN_VERTUE => { width:1, height:1, footprint : 0 },
		
		AssetName.DECO_HELL_TREE_1 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HELL_TREE_2 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HELL_TREE_3 => {width:1, height:1, footprint : 0},
		AssetName.DECO_HELL_ROCK => { width:1, height:1, footprint : 0 },
		
		AssetName.BUILDING_HELL_BUILD_1 => {width:3, height:3, footprint : 1},
		AssetName.BUILDING_HELL_BUILD_2 => { width:3, height:3, footprint : 1 },
		
		
		AssetName.BUILDING_HEAVEN_BRIDGE => { width:1, height:1, footprint : 0 },
		AssetName.BUILDING_HEAVEN_BUILD_1 => { width:2, height:2, footprint : 1 },
		AssetName.BUILDING_HEAVEN_BUILD_2 => { width:2, height:2, footprint : 1 },
		
		
	];
	
	public static var list:Array<Building>;
	
	private static var container:Container;	
	
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;

	
	/**
	 * Initialisation of Building class, should be called after Ground class initialisation.
	 */
	public static function initClass():Void {
		container = new Container();
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
	
	
	public function new(?pAssetName:String) {
		super(pAssetName);	
	}
	
	// attention phantom n'herite pas de ceci !
	override public function start():Void {
		super.start();
		
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
	
	override public function recycle():Void {
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
		
		super.recycle();
	}
	
	override public function destroy():Void {
		// todo destroy incomplet ?
		// todo : suppri;er de behind and front du zsorting ?
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
		on(MouseEventType.CLICK, onClick);
	}
	
	private function onClick ():Void {
		cast(linkedVirtualCell, VBuilding).onClick();
	}
	
	//} endRegion
}