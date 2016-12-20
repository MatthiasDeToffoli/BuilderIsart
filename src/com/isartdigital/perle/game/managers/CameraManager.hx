package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.iso.IsoManager;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class CameraManager 
{
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
	 * Center the Camera on the center of the Ground tiles.
	 * (a better method than 
	 * GameStage.getInstance().getGameContainer().y -= Ground.container.height / 2)
	 */
	
	public static function placeCamera(pPos:Point):Void{
		
		target.x -= IsoManager.modelToIsoView(pPos).x;
		target.y -= IsoManager.modelToIsoView(pPos).y;

	}
	
	/**
	 * Add pSpeed to move the Camera,
	 * @param	pSpeed
	 */
	public static function move(pSpeed:Point):Void {
		target.x += pSpeed.x;
		target.y += pSpeed.y;
		checkClippingNeed(pSpeed);
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