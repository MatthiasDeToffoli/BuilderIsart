package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.managers.RegionManager.Region;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.sprites.BackgroundUnder;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import haxe.Timer;
import js.Browser;
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
	
	/**
	 * place the camera
	 * @param pPos position to subastract at the camera
	 * @author Matthias
	 */
	public static function placeCamera(pPos:Point):Void{
		target.x -= IsoManager.modelToIsoView(pPos).x;
		target.y -= IsoManager.modelToIsoView(pPos).y;
	}
	
	/**
	 * Add pSpeed to move the Camera,
	 * @param	pSpeed
	 * @author Ambroise
	 */
	public static function move(pSpeedX:Float, pSpeedY:Float):Void {
		if (Hud.isHide && !Phantom.isSet())
			return;
		if (DialogueManager.cameraHaveToMove) {
			DialogueManager.waitTime(3000);	
			DialogueManager.cameraHaveToMove = false;
		}
		
		var lSpeed:Point = new Point(pSpeedX, pSpeedY);
		lSpeed = checkMaxDistanceCamera(lSpeed);
		//trace(lSpeed);
		target.position = getNextPosition(target.position, lSpeed);
		
		
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
	
	// todo : ok je peux glisser sur les bords
	// todo : ne pas trembler sur les bords
	// todo : ne pas limiter au styx mais aux régions
	
	private static function checkMaxDistanceCamera (pSpeed:Point):Point {
		var lSpeed:Point = new Point();
		lSpeed.copy(pSpeed);
		// if there is only one Styx, firstTilePos is RegionManager.worldMap[0][0].desc.firstTilePos
		var lFirstTileStyxTop:Index = getFirstTileTop();
		// if there is only one Styx, lFirstTilePosStyxBottom == 0,styx.width
		var lFirstTileStyxBottom:Index = getFirstTileBottom();
		// will determine how much you can put the camera away from styx in a perpendicular line.
		// not completely accurate since it take the left side of the styx
		var lDistanceXStyxToFarestRegion:Int = Ground.COL_X_LENGTH * 2 + Ground.OFFSET_REGION * 1; // todo : change 2 by constant (number région same type you can build for a styx)
		var lCameraModelPosition:Point = IsoManager.isoViewToModel(getNextPositionCenter(pSpeed));
		trace("START");
		//trace(lFirstTileStyxTop);
		//trace(lFirstTileStyxBottom);
		//trace(lDistanceXStyxToFarestRegion);
		//trace(lNextPosition);
		//trace(lCameraModelPosition);
		var lCorrectionToStayInPlayZone:Point = collisionPointRect(
			lCameraModelPosition,
			new Rectangle(
				lFirstTileStyxTop.x - lDistanceXStyxToFarestRegion,
				lFirstTileStyxTop.y,
				lFirstTileStyxTop.x + lDistanceXStyxToFarestRegion * 2 + Ground.COL_X_STYX_LENGTH,
				lFirstTileStyxBottom.y - lFirstTileStyxTop.y
			)
		);
		// return a speed, if you return a position be sure to return the position whit the toCenter correction
		var lCorrectionIsoView:Point = IsoManager.modelToIsoView(lCorrectionToStayInPlayZone);
		trace(lCorrectionIsoView);
		lSpeed.x -= lCorrectionIsoView.x;
		lSpeed.y -= lCorrectionIsoView.y;
		return lSpeed;
	}
	
	/**
	 * 
	 * @param	lPoint
	 * @param	lRect
	 * @return correction value to add to stay in the rectangle
	 */
	private static function collisionPointRect (lPoint:Point, lRect:Rectangle):Point {
		var lCorrection:Point = new Point(0, 0);
		
		if (lPoint.x < lRect.x)
			lCorrection.x +=  lRect.x - lPoint.x;
		if (lPoint.x > lRect.x + lRect.width)
			lCorrection.x += lRect.x + lRect.width - lPoint.x;
		if (lPoint.y < lRect.y)
			lCorrection.y += lRect.y - lPoint.y;
		if (lPoint.y > lRect.y + lRect.height)
			lCorrection.y += lRect.y + lRect.height - lPoint.y;
		
		return lCorrection;
		/*return (lPoint.x > lRect.x
			&&  lPoint.x < lRect.x + lRect.width
			&&  lPoint.y > lRect.y
			&&  lPoint.y < lRect.y + lRect.height);*/
	};
	
	private static function getFirstTileBottom ():Index {
		var lHightestY:Int = 0;
		for (y in RegionManager.worldMap[0].keys()) {
			lHightestY = lHightestY >= y ? lHightestY : y;
		}
		return {
			x: RegionManager.worldMap[0][lHightestY].desc.firstTilePos.x,
			y: RegionManager.worldMap[0][lHightestY].desc.firstTilePos.y + Ground.ROW_Y_STYX_LENGTH
		}
	}
	
	private static function getFirstTileTop ():Index {
		var lLowestY:Int = 0;
		for (y in RegionManager.worldMap[0].keys()) {
			lLowestY = lLowestY <= y ? lLowestY : y;
		}
		return RegionManager.worldMap[0][lLowestY].desc.firstTilePos;
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
	
	public function new() {
		
	}
	
}