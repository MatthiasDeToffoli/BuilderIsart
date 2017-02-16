package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.managers.RegionManager.Region;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.math.Point;
/**
 * ...
 * @author ambroise
 */
class CameraManager 
{
	private static var defaultPos:Point;
	private static inline var REGION_WIDTH:Float = Ground.COL_X_LENGTH * Tile.TILE_WIDTH;
	private static inline var REGION_HEIGHT:Float = Ground.ROW_Y_LENGTH * Tile.TILE_HEIGHT;
	private static inline var REGION_STYX_WIDTH:Float = (Ground.COL_X_STYX_LENGTH - Ground.ROW_Y_STYX_LENGTH) * Tile.TILE_HEIGHT;
	private static inline var REGION_STYX_HEIGHT:Float = (Ground.COL_X_STYX_LENGTH - Ground.ROW_Y_STYX_LENGTH) * Tile.TILE_HEIGHT;
	
	public static inline var DEFAULT_SPEED:Float = 12;
	public static inline var DEFAULT_OFFSET_LOCAL:Float = 100;
	
	
	private static var test:Int = 0;
	
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
	 */
	public static function placeCamera(pPos:Point):Void{
		
		target.x -= IsoManager.modelToIsoView(pPos).x;
		target.y -= IsoManager.modelToIsoView(pPos).y;
		
		var bgUnder:FlumpStateGraphic = new FlumpStateGraphic(AssetName.BACKGROUND_UNDER);
		bgUnder.init();
		GameStage.getInstance().getUnderBackgroundContainer().addChild(bgUnder);

	}
	
	/**
	 * Add pSpeed to move the Camera,
	 * @param	pSpeed
	 */
	public static function move(pSpeedX:Float, pSpeedY:Float):Void {
		if (Hud.isHide && !Phantom.isSet())
			return;
		if (DialogueManager.cameraHaveToMove) {
			DialogueManager.waitTime(3000);	
			DialogueManager.cameraHaveToMove = false;
		}
		var lRegionCenters = getRegionCenters();
		var lIndexRef:Int = 0;
		
		if (lRegionCenters.length > 1) {
			var lPointRef:Float = distancePToP(getCameraCenter(), lRegionCenters[0]);
			
			for (i in 0...lRegionCenters.length) {
				var lPoint:Float = distancePToP(getCameraCenter(), lRegionCenters[i]);
				if (lPoint < lPointRef) {
					lPointRef = lPoint;
					lIndexRef = i;
				}
			}
		}

		
		defaultPos = lRegionCenters[lIndexRef];
		
		target.x += pSpeedX;
		target.y += pSpeedY;
		
		var lCurrentPosCamera:Point = getCameraCenter();
		
		if (lCurrentPosCamera.x > defaultPos.x + REGION_WIDTH/2 + Tile.TILE_WIDTH*2) target.x -= pSpeedX;
		if (lCurrentPosCamera.x < defaultPos.x - REGION_WIDTH/2 - Tile.TILE_WIDTH*2) target.x -= pSpeedX;
		if (lCurrentPosCamera.y > defaultPos.y + REGION_HEIGHT/2 + Tile.TILE_HEIGHT*2) target.y -= pSpeedY;
		if (lCurrentPosCamera.y < defaultPos.y - REGION_HEIGHT / 2 - Tile.TILE_HEIGHT * 2) target.y -= pSpeedY;
		
		var lSpeed:Point = new Point(pSpeedX, pSpeedY);
		
		checkClippingNeed(lSpeed);
	}
	
	public static function scrollOnLimitsScreen(pMouseLocalPos:Point) {
		var cameraCenter:Point = getCameraCenter();
		
		var lLimitLeftR:Float = cameraCenter.x - Main.getInstance().renderer.width + DEFAULT_OFFSET_LOCAL;
		var lLimitLeftL:Float = cameraCenter.x - Main.getInstance().renderer.width;
		var lLimitRightL:Float = cameraCenter.x + Main.getInstance().renderer.width - DEFAULT_OFFSET_LOCAL;
		var lLimitRightR:Float = cameraCenter.x + Main.getInstance().renderer.width;
		
		var lLimitTopB:Float = cameraCenter.y - Main.getInstance().renderer.height + DEFAULT_OFFSET_LOCAL;
		var lLimitTopT:Float = cameraCenter.y - Main.getInstance().renderer.height;
		var lLimitBottomT:Float = cameraCenter.y + Main.getInstance().renderer.height - DEFAULT_OFFSET_LOCAL;
		var lLimitBottomB:Float = cameraCenter.y + Main.getInstance().renderer.height;
		
		if(pMouseLocalPos.x < lLimitLeftR && pMouseLocalPos.x > lLimitLeftL) move(DEFAULT_SPEED, 0);
		if(pMouseLocalPos.x > lLimitRightL && pMouseLocalPos.x < lLimitRightR) move(-DEFAULT_SPEED, 0);
		if(pMouseLocalPos.y < lLimitTopB && pMouseLocalPos.y > lLimitTopT) move(0, DEFAULT_SPEED);
		if(pMouseLocalPos.y > lLimitBottomT && pMouseLocalPos.y < lLimitBottomB) move(0, -DEFAULT_SPEED);
	}
	
	private static function distancePToP(pP1:Point, pP2:Point):Float {
		return Math.sqrt((pP2.x - pP1.x) * (pP2.x - pP1.x) + (pP2.y - pP1.y) * (pP2.y - pP1.y));
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
	
	private static function getRegionCenters():Array<Point> {
		var lMap:Map<Int,Map<Int,Region>> = RegionManager.worldMap;
		var lRegionCenters:Array<Point> = [];
		
		for (row in lMap.keys()) {
			for (region in lMap[row].keys()) {
				var lPoint:Point = getCameraCenter();
				if (hitTestRegion(lPoint,lMap[row][region])) {
					//trace("true");
					var lPos:Point = IsoManager.modelToIsoView(new Point(lMap[row][region].desc.firstTilePos.x, lMap[row][region].desc.firstTilePos.y));
					
					if (lMap[row][region].desc.type == Alignment.neutral) {
						lRegionCenters.push(new Point(lPos.x + Tile.TILE_WIDTH * (Ground.COL_X_STYX_LENGTH / 2 - REGION_STYX_WIDTH / 2), 
																				  lPos.y + (REGION_STYX_HEIGHT) / 2));
					}
					else {
						lRegionCenters.push(new Point(lPos.x, lPos.y + (REGION_HEIGHT) / 2)); 
					}
					
				}
			}
		}
		
		return lRegionCenters;
		
	}
	
	private static function extendLimits(pRegion:Region, pPoint:Point):Bool {
		return true;
	}
	
	private static function hitTestRegion(pPoint:Point,pRegion:Region):Bool {
		var lPX:Float = pPoint.x;
		var lPY:Float = pPoint.y;
		
		var lWidth:Float = REGION_WIDTH + Tile.TILE_WIDTH * 2;
		var lHeight:Float = REGION_HEIGHT + Tile.TILE_HEIGHT * 2;
		var lWidthStyx:Float = REGION_STYX_WIDTH + Tile.TILE_WIDTH * 2;
		var lHeightStyx:Float = REGION_STYX_HEIGHT + Tile.TILE_HEIGHT * 2;
		
		var lWidthTest:Float;
		var lHeightTest:Float;
		
		var lPosRegion:Point = IsoManager.modelToIsoView(new Point(pRegion.desc.firstTilePos.x, pRegion.desc.firstTilePos.y));
		
		var lX:Float;
		var lY:Float;
		
		if (pRegion.desc.type == Alignment.neutral) {
			 
			lX = lPosRegion.x + Tile.TILE_WIDTH * (Ground.COL_X_STYX_LENGTH / 2 - REGION_STYX_WIDTH / 2);
		}
		else {
			lWidthTest = lWidth; 
			lHeightTest = lHeight; 
			lX = lPosRegion.x;
		}
		
		lWidthTest = lWidth; 
		lHeightTest = lHeight;
		
		if (lPX >= lX - lWidthTest/2 - Tile.TILE_WIDTH*2 && lPX <= lX + lWidthTest/2 + Tile.TILE_WIDTH*2)
		{
			lY =lPosRegion.y - Tile.TILE_HEIGHT * 2;
			if (lPY >= lY && lPY <= lY + lHeightTest + Tile.TILE_HEIGHT * 4) return true;
		}
		
		return false;
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