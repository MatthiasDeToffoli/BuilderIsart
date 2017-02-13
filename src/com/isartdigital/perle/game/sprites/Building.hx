package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.managers.AnimationManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.SmartCheck;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.GameStage;
import haxe.io.Float32Array.Float32ArrayData;
//import js.html.RequestCredentials;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.flump.Movie;

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
	public static var isClickable:Bool = true;
	public static var list:Array<Building>;
	
	private static var container:Container;	
	private static var uiContainer:Container;	
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;
	public var isoBox:Graphics;
	public var myDesc:TileDescription;
	private var numberFrame:Int;
	private var animation:Movie;

	
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
	public static function getSizeOnMap (pBuildingName:String, ?plevel:Int = 0):SizeOnMap {
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
	public static function createBuilding(pTileDesc:TileDescription, state:VBuildingState):Building {
		
		
		var lBuilding:Building = PoolingManager.getFromPool(BuildingName.getAssetName(pTileDesc.buildingName, pTileDesc.level));
		var regionFirstTilePos:Index = RegionManager.worldMap[pTileDesc.regionX][pTileDesc.regionY].desc.firstTilePos;
		
		lBuilding.myDesc = pTileDesc;
		lBuilding.positionTile( // todo : semblable a Ground.hx positionTile, factoriser ?
			pTileDesc.mapX + regionFirstTilePos.x, 
			pTileDesc.mapY + regionFirstTilePos.y
		);
		lBuilding.setMapColRow(
			{
				x:pTileDesc.mapX + regionFirstTilePos.x, 
				y:pTileDesc.mapY + regionFirstTilePos.y
			},
			Building.getSizeOnMap(pTileDesc.buildingName,pTileDesc.level)
		);
		list.push(lBuilding);
		lBuilding.init();
		container.addChild(lBuilding);
		
		lBuilding.start(); // todo : start ailleurs pr éviter clic de trop ?
		
		if (state == VBuildingState.isBuilding || state == VBuildingState.isUpgrading) lBuilding.setStateConstruction();

		return lBuilding;
	}
	

	
	public function new(?pAssetName:String) {
		super(pAssetName);	
	}
	
	override public function init():Void {
		super.init();
		addIsoBox();
	}
	
	// Merci François pour l'info ;), tellement plus simple de façon dynamique.
	private function addIsoBox ():Void {
		var lLocalBounds:Rectangle = getLocalBounds();
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
		var myGraphic:Graphics = new Graphics();
		var lLocalLeftFromModelToView:Float = -Tile.TILE_WIDTH / 2 * GameConfig.getBuildingByName(getBuildingName()).height;
		var lLocalRightFromModelToView:Float = Tile.TILE_WIDTH / 2 * GameConfig.getBuildingByName(getBuildingName()).width;
		
		myGraphic.beginFill(0xFF00FF, 0);
		
		myGraphic.drawRect(
			lLocalLeftFromModelToView,
			lAnchor.y,
			lLocalRightFromModelToView - lLocalLeftFromModelToView,
			height
		);
		myGraphic.endFill();
		
		isoBox = myGraphic;
		addChild(isoBox);
	}
	
	private function getBuildingName():String {
		return myDesc.buildingName;
	}
	
	private function getIsoBoxWidth ():Float {
		return GameConfig.getBuildingByName(myDesc.buildingName).width * Tile.TILE_WIDTH; // c en model pas en view !
	}
	
	//private function getLeftCornerX ():Point {
		//return new Point(
			//return Tile.TILE_WIDTH / 2 * GameConfig.getBuildingByName(myDesc.buildingName).height;/*,
			//GameConfig.getBuildingByName(myDesc.buildingName).height * Tile.TILE_HEIGHT - Tile.TILE_HEIGHT / 2 
		//);*/
	//}
	
	
	public function setStateConstruction():Void {
		setState(DEFAULT_STATE);
	}
	
	public function setStateEndConstruction():Void {
		setState(DEFAULT_STATE);
	}
	
	public function onAnimationEnd():Void {

		if (animation.currentFrame == animation.totalFrames - 1) {
			cast(linkedVirtualCell, VBuilding).reShow();
		}
		
	}
	
	public function setAnimation():Void {
		animation = cast(anim, Movie).getChildMovie(AssetName.ANIMATION);
		animation.gotoAndPlay(0);
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
		
		AnimationManager.removeToManager(this);
		animation = null;
		super.recycle();
	}
	
	override public function destroy():Void {
		// todo destroy incomplet ?
		// todo : suppri;er de behind and front du zsorting ?
		Interactive.removeListenerClick(this, onClick);
		off(MouseEventType.MOUSE_OVER, changeCursor);
		AnimationManager.removeToManager(this);
		animation = null;
		
		
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