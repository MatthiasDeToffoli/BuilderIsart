package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VCell;
import pixi.core.math.Point;

/**
 * An easier pixi.Rectangle
 */
typedef EasyRectangle = {
	var topLeft:Point;
	var bottomRight:Point;
}

/**
 * Cells inside this Reactangle will be activated or desactivated.
 */
typedef MapClippingRect = {
	var left:Int;
	var right:Int;
	var top:Int;
	var bottom:Int;
}

typedef CommonSide = {
	var left:Bool;
	var right:Bool;
	var top:Bool;
	var bottom:Bool;
}

/**
 * ...
 * @author ambroise
 */
class ClippingManager 
{
	/**
	 * usefull to understand how large the clipping is.
	 */
	private static var cheat_do_clipping_start_only(default, never):Bool = false;
	
	/**
	 * Should be high enough to not see any clipping on side.
	 */ // todo : optimize for building, whitout building problem use 2 as value
	private static inline var CLIPPING_MARGIN_V:Int = 12;
	
	/**
	 * Should be high enough to not see any clipping on side.
	 */ // todo : optimize for building, whitout building problem use 10 as value
	private static inline var CLIPPING_MARGIN_H:Int = 18;
	
	private static var cameraMapRect:EasyRectangle;
	private static var currentCameraClipRect:MapClippingRect;
	private static var precedentCameraClipRect:MapClippingRect;
	private static var commonCameraClipRect:MapClippingRect;
	
	public function new() {
		
	}
	
	// avoir colonne entrée sortie et agir que sur celle-ci, que qd mvt camera !
	public static function update():Void {
		setCameraMapClipRect();
		
		currentCameraClipRect = {
			left:cast(cameraMapRect.topLeft.x - CLIPPING_MARGIN_H, Int),
			right:cast(cameraMapRect.bottomRight.x + CLIPPING_MARGIN_H, Int),
			top:cast(cameraMapRect.topLeft.y - CLIPPING_MARGIN_V, Int),
			bottom:cast(cameraMapRect.bottomRight.y + CLIPPING_MARGIN_V, Int)
		};
		
		if (precedentCameraClipRect == null)
			activateCells(currentCameraClipRect);
		else {
			commonCameraClipRect = getCommonArea(
				currentCameraClipRect, 
				precedentCameraClipRect
			);
			if (!cheat_do_clipping_start_only) {
				optimizedClipping(desactivateCells, precedentCameraClipRect, commonCameraClipRect);
				optimizedClipping(activateCells, currentCameraClipRect, commonCameraClipRect);
			}
		}
		
		Building.sortBuildings();
		
		precedentCameraClipRect = currentCameraClipRect;
	}
	
	/**
	 * Activate Cells in pClippingRect area
	 * @param	pClippingRect
	 */
	private static function activateCells(pClippingRect:MapClippingRect):Void {
		//trace(pClippingRect); usefull to see the optimized clipping
		for (lClassArray in VCell.list) {
			for (x in pClippingRect.left...pClippingRect.right) {
				for (y in pClippingRect.top...pClippingRect.bottom) {
					if (lClassArray[x] != null &&
						lClassArray[x][y] != null &&
						!lClassArray[x][y].active)
						lClassArray[x][y].activate();
				}
			}
		}
	}
	
	/**
	 * Desactivate Cells in pClippingRect area
	 * @param	pClippingRect
	 */
	private static function desactivateCells(pClippingRect:MapClippingRect):Void {
		for (lClassArray in VCell.list) {
			for (x in pClippingRect.left...pClippingRect.right) {
				for (y in pClippingRect.top...pClippingRect.bottom) {
					if (lClassArray[x] != null &&
						lClassArray[x][y] != null &&
						lClassArray[x][y].active)
						lClassArray[x][y].desactivate();
				}
			}
		}
	}
	
	/**
	 * Compare two ClippingRect, and determine the difference between these two.
	 * two rectangle (or only one) merge from this, and we can iterate trhough them to activate or desactivate
	 * (i like to do a drawing)
	 * @param	pClippingRect
	 * @param	pClippingRectIgnore
	 */
	private static function optimizedClipping(pFunction:MapClippingRect->Void ,pClipRect:MapClippingRect, pClipRectIgnore:MapClippingRect):Void {
		var commonSides:CommonSide = getCommonSides(pClipRect, pClipRectIgnore);
		
		// unless zoomIn or zoomOut, only two or one pFunction would be called
		if (commonSides.top && !commonSides.bottom)
			pFunction({
				left: pClipRect.left,
				right: pClipRect.right,
				top: pClipRectIgnore.bottom,
				bottom: pClipRect.bottom
			});
		if (commonSides.bottom && !commonSides.top)
			pFunction({
				left: pClipRect.left,
				right: pClipRect.right,
				top: pClipRect.top,
				bottom: pClipRectIgnore.top
			});
		if (commonSides.left && !commonSides.right)
			pFunction({
				left: pClipRectIgnore.right,
				right: pClipRect.right,
				top: pClipRect.top,
				bottom: pClipRect.bottom
			});
		if (commonSides.right && !commonSides.left)
			pFunction({
				left: pClipRect.left,
				right: pClipRectIgnore.left,
				top: pClipRect.top,
				bottom: pClipRect.bottom
			});
	}
	
	/**
	 * pClipRectIgnore is smaller and fully inside pClipRect,
	 * we want to know which side do they have in common
	 * @param	pClipRect
	 * @param	pClipRectIgnore
	 * @return
	 */
	private static function getCommonSides(pClipRect:MapClippingRect, pClipRectIgnore:MapClippingRect):CommonSide {
		return {
			top: pClipRect.top == pClipRectIgnore.top,
			bottom: pClipRect.bottom == pClipRectIgnore.bottom,
			left: pClipRect.left == pClipRectIgnore.left,
			right: pClipRect.right == pClipRectIgnore.right
		};
	}
	
	/**
	 * return a MapClippingRect that is the common between two MapClippingRect,
	 * it is the area that has cells that don't need to be activate or desactivate
	 * @param	p1ClipRect
	 * @param	p2ClipRect
	 * @return
	 */
	private static function getCommonArea(p1ClipRect:MapClippingRect, p2ClipRect:MapClippingRect):MapClippingRect {
		return {
			left:p1ClipRect.left > p2ClipRect.left ? p1ClipRect.left : p2ClipRect.left,
			right:p1ClipRect.right < p2ClipRect.right ? p1ClipRect.right : p2ClipRect.right,
			top:p1ClipRect.top > p2ClipRect.top ? p1ClipRect.top : p2ClipRect.top,
			bottom:p1ClipRect.bottom < p2ClipRect.bottom ? p1ClipRect.bottom : p2ClipRect.bottom
		};
	}
	
	/**
	 * Return the position of a Tile in the ClippingMapArray
	 * Used by VCell at new
	 * Actually anything between cells is not supported !!!
	 * @param	pPoint
	 * @return
	 */
	public static function posToClippingMap(pPoint:Point):Point {
		if (Math.round(pPoint.x) != pPoint.x ||
			Math.round(pPoint.y) != pPoint.y)
			throw ("Position x,y est un chiffre à virgule, n'est pas une Tile ? pas supporté pr l'instant !");
		
		return new Point (
			cast(pPoint.x / (Tile.TILE_HEIGHT/4), Int),
			cast(pPoint.y / (Tile.TILE_WIDTH/4), Int)
		);
	}
	
	/**
	 * Set the current Camera Clipping Rectangle
	 */
	private static function setCameraMapClipRect():Void {
		var lCameraRect:EasyRectangle = CameraManager.getCameraRect();
		
		lCameraRect.topLeft.x = customFloor(lCameraRect.topLeft.x, Tile.TILE_WIDTH);
		lCameraRect.topLeft.y = customFloor(lCameraRect.topLeft.y, Tile.TILE_HEIGHT);
		lCameraRect.bottomRight.x = customCeil(lCameraRect.bottomRight.x, Tile.TILE_WIDTH);
		lCameraRect.bottomRight.y = customCeil(lCameraRect.bottomRight.y, Tile.TILE_HEIGHT);
		
		cameraMapRect = {
			topLeft: posToClippingMap(lCameraRect.topLeft),
			bottomRight: posToClippingMap(lCameraRect.bottomRight)
		};
	}
	
	private static function customFloor(pNumber:Float, pFloorFactor:Int = 1):Int {
		return pFloorFactor * Math.floor(pNumber / pFloorFactor);
	}
	
	private static function customCeil(pNumber:Float, pCeilFactor:Int = 1):Int {
		return pCeilFactor * Math.ceil(pNumber / pCeilFactor);
	}
}