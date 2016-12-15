package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

/**
 * 
 * @author ambroise
 */
class Ground extends Tile implements PoolingObject 
{
	/**
	 * Offset separating each region.
	 */
	public static inline var OFFSET_REGION:Int = 0;
	
	/**
	 * Ground Map in X length (DONT LOAD SAVE WHIT DIFFERENT VALUE)
	 */
	public static inline var COL_X_LENGTH:Int = 12;
	public static inline var COL_X_STYX_LENGTH:Int = 3;
	
	/**
	 * Ground Map in Y length (DONT LOAD SAVE WHIT DIFFERENT VALUE)
	 */
	public static inline var ROW_Y_LENGTH:Int = 12;
	
	/**
	 * Used onMouseOver
	 */
	private static inline var FILTER_BRIGHTNESS:Float = 1.3;
	
	public static var container(default, null):Container;
	public static var bgContainer(default, null):Container;
	
	
	public var mapX:Int;
	public var mapY:Int;
	
	private static var previousCell:Ground;
	private static var colorMatrix:ColorMatrixFilter;
	private static var mapArray:Map<Int,Map<Int, Ground>>;
	
	
	public static function initClass():Void {
		mapArray = new Map<Int,Map<Int, Ground>>();
		
		container = new Container();
		bgContainer = new Container();
		
		colorMatrix = new ColorMatrixFilter();
		colorMatrix.brightness(FILTER_BRIGHTNESS, false);
		
		GameStage.getInstance().getGameContainer().addChildAt(bgContainer, 0);
		GameStage.getInstance().getGameContainer().addChild(container);
		
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
			Browser.window.addEventListener(MouseEventType.MOUSE_MOVE, hoverGround);
	}
	
	public static function hoverGround(pEvent:MouseEvent) {
		lightCell(MouseManager.getInstance().getLocalMouseMapPos());
	}
	
	/**
	 * Create a Ground Tile, addChild and start it.
	 * @param	pTileDesc
	 * @return
	 */
	public static function createGround(pTileDesc:TileDescription):Ground {
		var lGround:Ground = PoolingManager.getFromPool(pTileDesc.assetName);
		
		
		var regionFirstTilePos:Index = RegionManager.worldMap[pTileDesc.regionX][pTileDesc.regionY].desc.firstTilePos;
		
		
		addToGroundMap( // todo : factoriser fc..
			pTileDesc.mapX + regionFirstTilePos.x, 
			pTileDesc.mapY + regionFirstTilePos.y,
			lGround
		);
		lGround.positionTile(
			pTileDesc.mapX + regionFirstTilePos.x, 
			pTileDesc.mapY + regionFirstTilePos.y
		);
		lGround.init();
		container.addChild(lGround);
		lGround.start();
		// to see bg integration
		lGround.alpha = 0.2;
		return lGround;
	}
	
	private static function addToGroundMap (pX:Int, pY:Int, pGround:Ground):Void {
		if (mapArray[pX] == null)
			mapArray[pX] = new Map<Int, Ground>();
			
		mapArray[pX][pY] = pGround;
	}
	
	/**
	 * Apply the filter to the ground, and remvoe filter from precedent ground.
	 * @param	pPoint
	 */
	private static function lightCell(pPoint:Point):Void {
		var lGround:Ground = null;
		
		if (mapArray[Math.floor(pPoint.x)] != null &&
			mapArray[Math.floor(pPoint.x)][Math.floor(pPoint.y)] != null)
			lGround = mapArray[Math.floor(pPoint.x)][Math.floor(pPoint.y)];
		
		if (lGround != null) {
			if (previousCell == null ||
				(lGround.x != previousCell.x || lGround.y != previousCell.y)) {
				lGround.addFilterCell();
				
				if (previousCell != null)
					previousCell.removeFilterCell();
					
				previousCell = lGround;	
			}
		} else {
			if (previousCell != null)
				previousCell.removeFilterCell();
				
			previousCell = null;
		}
	} 
	
	public function new(?pAssetName:String) {
		super(pAssetName);
	}
	
	/**
	 * Enlight Cell when mouseOver
	 */
	private function addFilterCell():Void {
		if (filters == null)
			filters = [colorMatrix];
	}
	
	private function removeFilterCell():Void {
		filters = null;
	}
	
	override function positionTile(pGridX:Int, pGridY:Int):Void {
		super.positionTile(pGridX, pGridY);
		mapX = pGridX;
		mapY = pGridY;
	}
	
	public function givePositionIso(pX:Float, pY:Float ){
		positionTile(Std.int(pX), Std.int(pY));
	}
	
	override public function recycle():Void {
		/*if (mapArray[mapX] == null ||
			mapArray[mapX] == null)
			throw("");*/ //todo
			
		mapArray[mapX][mapY] = null;
		super.recycle();
	}
	
	override public function destroy():Void {
		mapArray[mapX][mapY] = null;
		super.destroy();
	}
	
	// todo: destroyStatic ? jamais appelé pr l'instant :o !
	public static function destroyStatic():Void {
		Browser.window.removeEventListener(MouseEventType.MOUSE_MOVE, Ground.hoverGround);
		previousCell = null;
		mapArray = null;
		colorMatrix = null;
	}
	
}