package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
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
	 * Ground Map in X length (DONT LOAD SAVE WHIT DIFFERENT VALUE)
	 */
	public static inline var COL_X_LENGTH:Int = 14;
	
	/**
	 * Ground Map in Y length (DONT LOAD SAVE WHIT DIFFERENT VALUE)
	 */
	public static inline var ROW_Y_LENGTH:Int = 14;
	
	/**
	 * Used onMouseOver
	 */
	private static inline var FILTER_BRIGHTNESS:Float = 1.3;
	
	public static var container(default, null):Container;
	public static var mapArray:Array<Array<Ground>> = [for (x in 0...COL_X_LENGTH) []];
	
	public var mapX:Int;
	public var mapY:Int;
	
	private static var previousCell:Ground;
	private static var colorMatrix:ColorMatrixFilter;
	
	
	public static function initClass():Void {
		container = new Container();
		colorMatrix = new ColorMatrixFilter();
		colorMatrix.brightness(FILTER_BRIGHTNESS, false);
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
		mapArray[pTileDesc.mapX][pTileDesc.mapY] = lGround;
		lGround.positionTile(
			pTileDesc.mapX, 
			pTileDesc.mapY
		);
		lGround.init();
		container.addChild(lGround);
		lGround.start();
		return lGround;
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