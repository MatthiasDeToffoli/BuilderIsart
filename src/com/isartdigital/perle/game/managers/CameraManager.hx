package com.isartdigital.perle.game.managers;
import com.greensock.core.Animation;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.hud.Hud;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
/**
 * ...
 * @author ambroise
 * @author killian
 */
class CameraManager 
{
	private static var defaultPos:Point;
	private static inline var REGION_WIDTH:Float = Ground.COL_X_LENGTH * Tile.TILE_WIDTH;
	private static inline var REGION_HEIGHT:Float = Ground.ROW_Y_LENGTH * Tile.TILE_HEIGHT;
	private static inline var REGION_STYX_WIDTH:Float = (Ground.COL_X_STYX_LENGTH - Ground.ROW_Y_STYX_LENGTH) * Tile.TILE_HEIGHT;
	private static inline var REGION_STYX_HEIGHT:Float = (Ground.COL_X_STYX_LENGTH - Ground.ROW_Y_STYX_LENGTH) * Tile.TILE_HEIGHT;
	
	/*public static inline var DEFAULT_SPEED:Float = 12;
	public static inline var DEFAULT_OFFSET_LOCAL:Float = 100;
	
	
	private static var test:Int = 0;*/
	
	/**
	 * cheat usefull if you don't want clipping to be updated when Camera move.
	 */
	private static var cheat_no_clipping(default, never):Bool = false;
	
	/**
	 * Will be GameStage.getInstance().getGameContainer()
	 */
	private static var target:Container;
	
	/**
	 * variable used to know when a clipping update is needed
	 */
	private static var xDistMoved:Float;
	
	/**
	 * variable used to know when a clipping update is needed
	 */
	private static var yDistMoved:Float;
	
	private static var killTweenRef: Void -> Animation;
	private static var lastTargetPosition:Point;
	/**
	 * Zone (model not isoView) in wich the camera can move.
	 */
	private static var currentCameraPlayZone:Rectangle;
	
	/**
	 * place the camera
	 * @param pPos position to subastract at the camera
	 * @author Matthias
	 */
	public static function placeCamera (pPos:Point):Void{
		target.x -= IsoManager.modelToIsoView(pPos).x;
		target.y -= IsoManager.modelToIsoView(pPos).y;
	}
	
	public static function smoothCamera ():Void {
		if (Hud.isHide && !Phantom.isSet())
			return;
		
		lastTargetPosition = target.position.clone();
		if (TweenManager.magnitude(MouseManager.getInstance().lastSpeedKnow) != 0)
			killTweenRef = TweenManager.linearSlow(target, MouseManager.getInstance().lastSpeedKnow, onSmoothUpdate);
	}
	
	private static function onSmoothUpdate ():Void {
		var lSpeed:Point = new Point (
			target.position.x - lastTargetPosition.x,
			target.position.y - lastTargetPosition.y
		);
		checkClippingNeed(lSpeed);
		lastTargetPosition = target.position.clone();
		
		var lCorrection:Point = checkMaxDistanceCamera(new Point(0, 0));
		if (lCorrection.x != 0 || lCorrection.y != 0) {
			target.position.x += lCorrection.x;
			target.position.y += lCorrection.y;
		}
	}
	
	public static function killSmooth ():Void {
		if (killTweenRef != null) {
			killTweenRef();
			killTweenRef = null;
		}
	}
	
	/**
	 * Add pSpeed to move the Camera,
	 * @param	pSpeed
	 * @author Ambroise
	 */
	public static function move (pSpeed:Point):Void {
		if (Hud.isHide && !Phantom.isSet())
			return;
		if (DialogueManager.cameraHaveToMove) {
			DialogueManager.waitTime(3000);	
			DialogueManager.cameraHaveToMove = false;
		}
		
		var lSpeed:Point = pSpeed.clone();
		// that's only half working, wtf ?
		target.position = getNextPosition(
			target.position, 
			checkMaxDistanceCamera(lSpeed)
		);
		// i don't understand why i have to call this function twice,
		// the update of target.position must be in cause.
		target.position = getNextPosition(
			target.position,
			checkMaxDistanceCamera(new Point(0, 0))
		);
		// the best would be to calculate the good position and then apply it,
		// instead of applying a correction to the speed.
		
		checkClippingNeed(lSpeed);
	}
	
	private static function getNextPosition (pPosition:Point, pSpeed:Point):Point {
		// this make a copy of the point or reference will be updated !
		return new Point(
			pPosition.x + pSpeed.x,
			pPosition.y + pSpeed.y
		);
	}
	
	private static function getNextPositionCenter (pSpeed:Point):Point {
		var lCenter:Point = getCameraCenter();
		lCenter.x += pSpeed.x;
		lCenter.y += pSpeed.y;
		return lCenter;
	}
	
	public static function updateCameraPlayZone ():Void {
		currentCameraPlayZone = getCameraPlayZone();
	}
	
	/**
	 * Get the zone in wich the camera can move. corresponding to a rectangle
	 * from the lowest to the hightest region in Y.
	 * and width = 4 regions + space between region + styx
	 * @return Camera play zone
	 */
	private static function getCameraPlayZone ():Rectangle {
		var lFirstRegionFirstTilePos:Index = RegionManager.worldMap[0][0].desc.firstTilePos;
		// if there is only one Styx, firstTilePos is RegionManager.worldMap[0][0].desc.firstTilePos
		var lFirstTileTop:Index = getFirstTileTop();
		// if there is only one Styx, lFirstTilePosStyxBottom == 0,styx.width
		var lFirstTileBottom:Index = getFirstTileBottom();
		// will determine how much you can put the camera away from styx in a perpendicular line.
		// don't forget to add STYX_WIDTH when going in hells region
		// -1 because the first region around styx is glued to styx.
		var lDistanceXStyxToFarestRegion:Int = Ground.COL_X_LENGTH * RegionManager.MAX_REGIONS_X + RegionManager.OFFSET_REGION * RegionManager.MAX_REGIONS_X-1;
		
		return new Rectangle(
			lFirstRegionFirstTilePos.x - lDistanceXStyxToFarestRegion,
			lFirstTileTop.y,
			lFirstRegionFirstTilePos.x + lDistanceXStyxToFarestRegion * 2 + Ground.COL_X_STYX_LENGTH,
			lFirstTileBottom.y - lFirstTileTop.y
		);
	}
	
	private static function checkMaxDistanceCamera (pSpeed:Point):Point {
		var lSpeed:Point = new Point();
		lSpeed.copy(pSpeed);
		
		var lCameraModelPosition:Point = IsoManager.isoViewToModel(getNextPositionCenter(lSpeed));
		
		// security
		if (currentCameraPlayZone == null)
			updateCameraPlayZone();
		
		var lCorrectionToStayInPlayZone:Point = collisionPointRect(
			lCameraModelPosition,
			currentCameraPlayZone
		);
		
		var lCorrectionIsoView:Point = IsoManager.modelToIsoView(lCorrectionToStayInPlayZone);
		lSpeed.x -= lCorrectionIsoView.x;
		lSpeed.y -= lCorrectionIsoView.y;
		// return a speed, if you return a position be sure to return the position not from center.
		return lSpeed;
	}
	
	/**
	 * originaly just a rect point collision function, i just added a correction point
	 * that is returned.
	 * @param	lPoint
	 * @param	lRect
	 * @return correction value to add to stay in the rectangle
	 */
	private static function collisionPointRect (lPoint:Point, lRect:Rectangle):Point {
		var lCorrection:Point = new Point(0, 0);
		
		if (lPoint.x < lRect.x)
			lCorrection.x +=  lRect.x - lPoint.x;
		else if (lPoint.x > lRect.x + lRect.width)
			lCorrection.x += lRect.x + lRect.width - lPoint.x;
		if (lPoint.y < lRect.y)
			lCorrection.y += lRect.y - lPoint.y;
		else if (lPoint.y > lRect.y + lRect.height)
			lCorrection.y += lRect.y + lRect.height - lPoint.y;
		
		return lCorrection;
	};
	
	private static function getFirstTileTop ():Index {
		var lLowestY:Int = 0;
		var lAssociatedX:Int = 0;
		for (regionX in RegionManager.worldMap.keys()) {
			for (regionY in RegionManager.worldMap[regionX].keys()) {
				if (lLowestY > regionY) {
					lLowestY = regionY;
					lAssociatedX = regionX;
				}
			}
		}
		return RegionManager.worldMap[lAssociatedX][lLowestY].desc.firstTilePos;
	}
	
	private static function getFirstTileBottom ():Index {
		var lHightestY:Int = 0;
		var lAssociatedX:Int = 0;
		for (regionX in RegionManager.worldMap.keys()) {
			for (regionY in RegionManager.worldMap[regionX].keys()) {
				if (lHightestY < regionY) {
					lHightestY = regionY;
					lAssociatedX = regionX;
				}
			}
		}
		
		return {
			x: RegionManager.worldMap[lAssociatedX][lHightestY].desc.firstTilePos.x,
			y: RegionManager.worldMap[lAssociatedX][lHightestY].desc.firstTilePos.y + Ground.ROW_Y_STYX_LENGTH
		}
	}
	
	// todo : function moveTo
	
	/**
	 * Get the center of the screen (renderer) and return the local point in target (gameContainer).
	 * @return
	 */
	public static function getCameraCenter():Point {
		return target.toLocal(new Point(
			Main.getInstance().renderer.width/2,
			Main.getInstance().renderer.height/2
		));
	}
	
	/**
	 * return the local Rectangle of the Camera in target (gameContainer)
	 * I choose an EasyRectangle instead of pixi.Rectangle
	 * @return
	 */
	public static function getCameraRect():EasyRectangle {
		return {
			topLeft: target.toLocal(new Point(0, 0)),
			bottomRight: target.toLocal(new Point(
				Main.getInstance().renderer.width,
				Main.getInstance().renderer.height
			))
		};
	}
	
	/**
	 * Set the target, (gameContainer)
	 * @param	pContainer
	 */
	public static function setTarget(pContainer:Container):Void {
		target = pContainer;
		reset();
	}
	
	private static function reset():Void {
		xDistMoved = 0;
		yDistMoved = 0;
	}
	
	private static function checkClippingNeed(pSpeed:Point):Void {
		if (cheat_no_clipping)
			return;
		
		var doUpdate:Bool = false;
		
		xDistMoved += pSpeed.x;
		yDistMoved += pSpeed.y;
		if (Math.abs(xDistMoved) > Tile.TILE_WIDTH) {
			xDistMoved = 0;
			doUpdate = true;
		}
		if (Math.abs(yDistMoved) > Tile.TILE_HEIGHT) {
			yDistMoved = 0;
			doUpdate = true;
		}
			
		if (doUpdate)
			ClippingManager.update();
	}
	

	
}