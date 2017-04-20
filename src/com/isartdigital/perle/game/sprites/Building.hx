package com.isartdigital.perle.game.sprites;

import com.greensock.core.Animation;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.managers.AnimationManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.html.Rect;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.flump.Movie;
import pixi.interaction.EventTarget;

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
	public var isoBox:Graphics;
	public var isoRect:Rectangle;
	public var colMin:Int;
	public var colMax:Int;
	public var rowMin:Int;
	public var rowMax:Int;
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;
	public var myDesc:TileDescription;
	private var numberFrame:Int;
	private var animation:Movie;
	/**
	 * Used when user is selecting building. To do a better selection.
	 */
	private var groundCollisionBox:Rectangle;
	
	
	/**
	 * Initialisation of Building class, should be called after Ground class initialisation.
	 */
	public static function initClass():Void {
		container = new Container();
		uiContainer = new Container();
		container.position = Ground.container.position;
		uiContainer.position = container.position;
		GameStage.getInstance().getBuildContainer().addChild(container);
		GameStage.getInstance().getGameContainer().addChildAt(uiContainer,GameStage.getInstance().getGameContainer().children.length - 1);
		list = new Array<Building>();
		
		listenToClick(); // put this somewhere else ?
	}
	
	public static function listenToClick ():Void {
		container.interactive = true;
		Interactive.addListenerClick(container, onClickBuildingContainer);
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
		
		if (state == VBuildingState.isBuilding || state == VBuildingState.isUpgrading) 
			lBuilding.setStateConstruction();
		
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
		// optimization
		if (isoBox != null)
			return;
		
		var lLocalBounds:Rectangle = getLocalBounds().clone();
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
		var myGraphic:Graphics = new Graphics();
		var lLocalLeftFromModelToView:Float = -Tile.TILE_WIDTH / 2 * GameConfig.getBuildingByName(getBuildingName()).height;
		var lLocalRightFromModelToView:Float = Tile.TILE_WIDTH / 2 * GameConfig.getBuildingByName(getBuildingName()).width;
		
		myGraphic.beginFill(0xFF00FF, Config.debug && Config.data.boxAlpha != null ? Config.data.boxAlpha:0);
		
		myGraphic.drawRect(
			lLocalLeftFromModelToView,
			lAnchor.y,
			lLocalRightFromModelToView - lLocalLeftFromModelToView,
			height
		);
		myGraphic.endFill();
		
		isoBox = myGraphic;
		isoRect = new Rectangle(
			lLocalLeftFromModelToView,
			lAnchor.y,
			lLocalRightFromModelToView - lLocalLeftFromModelToView,
			height
		);
		addChild(isoBox);
	}
	
	private function getBuildingName():String {
		return myDesc.buildingName;
	}
	
	private function getIsoBoxWidth ():Float {
		return GameConfig.getBuildingByName(myDesc.buildingName).width * Tile.TILE_WIDTH; // c en model pas en view !
	}
	
	public function setStateConstruction():Void {
		if (myDesc.buildingName == BuildingName.STYX_VIRTUE_1 || myDesc.buildingName == BuildingName.STYX_VIRTUE_2 || myDesc.buildingName == BuildingName.STYX_VICE_1 || myDesc.buildingName == BuildingName.STYX_VICE_2)
			return;
			
		
		setState(AssetName.CONSTRUCT);
	}
	
	public function setStateEndConstruction():Void {
		if (myDesc.buildingName == BuildingName.STYX_VIRTUE_1 || myDesc.buildingName == BuildingName.STYX_VIRTUE_2 || myDesc.buildingName == BuildingName.STYX_VICE_1 || myDesc.buildingName == BuildingName.STYX_VICE_2)
			return;
			
		setState(AssetName.CONSTRUCT + AssetName.ANIM);
		setAnimation();
		AnimationManager.manage(this);
	}
	
	public function onAnimationEnd():Void {
		cast(linkedVirtualCell, VBuilding).reShow();
		trace("onAnimationEnd");
	}
	
	public function isAnimationEnd ():Bool {
		return animation.currentFrame == animation.totalFrames - 1;
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
		
		//Interactive.removeListenerClick(this, cast(onClick));
		off(MouseEventType.MOUSE_OVER, changeCursor);
		off(MouseEventType.MOUSE_OUT, showDefaultCursor);
		AnimationManager.removeToManager(this);
		animation = null;
		super.recycle();
	}
	
	override public function destroy():Void {
		// todo destroy incomplet ?
		// todo : suppri;er de behind and front du zsorting ?
		isoBox.destroy();
		isoBox = null;
		//Interactive.removeListenerClick(this, cast(onClick));
		off(MouseEventType.MOUSE_OVER, changeCursor);
		off(MouseEventType.MOUSE_OUT, showDefaultCursor);
		AnimationManager.removeToManager(this);
		animation = null;
		
		if (list.indexOf(this) != -1)
			list.splice(list.indexOf(this), 1);
			
		super.destroy();
	}
	
	public static function destroyStatic():Void {
		Interactive.removeListenerClick(container, onClickBuildingContainer);
		container.parent.removeChild(container);
		container = null;
		for (i in 0...list.length)
			list[i].destroy();
		list = null;
	}	
	
	//{ ################# HudContextual #################
	
	private function addListenerOnClick ():Void {
		//untyped Interactive.addListenerClick(this, cast(onClick));
		on(MouseEventType.MOUSE_OVER, changeCursor);
		on(MouseEventType.MOUSE_OUT, showDefaultCursor);
		
	}
	
	private function onClick ():Void {
		if (isClickable)
			cast(linkedVirtualCell, VBuilding).onClick(position);
	}
	
	private function changeCursor ():Void {
		if (isClickable)
			GameStage.getInstance().defaultCursor = "url(assets/finguer_little_up.png),auto";
		else 
			GameStage.getInstance().defaultCursor = "url(assets/Pointer_little.png),auto";
	}
	
	private function showDefaultCursor():Void {
		GameStage.getInstance().defaultCursor = "url(assets/Pointer_little.png),auto";
	}
	
	public static function onClickBuildingContainer ():Void {
		// var lGlobal:Point = pEventTarget.data.global.clone(); (not the same on touch i think)
		var lPosition:Point = DeviceCapabilities.isCocoonJS ? MouseManager.getInstance().touchGlobalPos : MouseManager.getInstance().position;
		//lPosition = container.toLocal(lPosition);
		var lIndexesCollisions:Array<Int> = [];
		var lLength = container.children.length;
		
		for (i in 0...lLength) {
			// verify graphic collision boxes
			if (CollisionManager.hitTestPoint(container.children[i], lPosition)) {
				//lIndexesCollisions.push(i);
				cast(container.children[i], Building).onClick();
				return;
			}
		}
		// verify ground collision boxes if multiple collisions whti precedent
		/* deluxe version, wip, p for pause because i have no time for this.
		if (lIndexesCollisions.length == 1) {
			cast(container.children[lIndexesCollisions[0]], Building).onClick();
		} else {
			trace("booonusss");
			trace(lIndexesCollisions.length);
			for (j in 0...lIndexesCollisions.length) {
				// verify ground collision
				if (cast(container.children[j], Building).groundIsClicked(lPosition)) {
					cast(container.children[j], Building).onClick();
					return;
				}
			}
		}*/
		// if multiple but no groundBox collision, choose the first in z-index.
		
	}
	
	private function groundIsClicked (pGlobal:Point):Bool {
		var lLocal:Point = container.toLocal(pGlobal);
		var lLocalModel:Point = IsoManager.isoViewToModel(lLocal);
		//if (groundCollisionBox == null)
			groundCollisionBox = new Rectangle(
				colMin,
				rowMin,
				Building.getSizeOnMap(myDesc.buildingName,myDesc.level).width,
				Building.getSizeOnMap(myDesc.buildingName,myDesc.level).height
			);
		var collide:Bool = collisionPointRect2(
			lLocalModel,
			groundCollisionBox
		);
		// graphic verification is good
		/*var myGraphic:Graphics = new Graphics();
		myGraphic.beginFill(0xFF00FF, 0.3);
		
		var laa:Point = IsoManager.modelToIsoView(new Point(groundCollisionBox.x, groundCollisionBox.y));
		var laa2:Point = IsoManager.modelToIsoView(new Point(
			groundCollisionBox.x + groundCollisionBox.width,
			groundCollisionBox.y + groundCollisionBox.height
		));
		var laa3:Point = IsoManager.modelToIsoView(new Point(
			groundCollisionBox.x,
			groundCollisionBox.y + groundCollisionBox.height
		));
		var laa4:Point = IsoManager.modelToIsoView(new Point(
			groundCollisionBox.x + groundCollisionBox.width,
			groundCollisionBox.y
		));
		
		myGraphic.drawPolygon([
			laa.x, laa.y,
			laa3.x, laa3.y,
			laa2.x, laa2.y,
			laa4.x, laa4.y
		]);*/
		/*myGraphic.drawRect(
			laa.x,
			laa.y,
			Building.getSizeOnMap(myDesc.buildingName,myDesc.level).width * Tile.TILE_WIDTH,
			Building.getSizeOnMap(myDesc.buildingName,myDesc.level).height * Tile.TILE_HEIGHT
		);*/
		//myGraphic.endFill();
		//container.parent.addChild(myGraphic);
		return collide;
	}
	
	private static function collisionPointRect2 (pPoint:Point, pRect:Rectangle):Bool {
		return !(pPoint.x < pRect.x ||
				pPoint.x > pRect.x + pRect.width ||
				pPoint.y < pRect.y ||
				pPoint.y > pRect.y + pRect.height);
	}
	
	//} endRegion
}