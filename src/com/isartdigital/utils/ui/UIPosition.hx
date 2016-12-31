package com.isartdigital.utils.ui;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * Classe utilitaire permettant de gérer le repositionnement des élements d'interface dans l'écran
 * @author Mathieu ANTHOINE
 */

class UIPosition 
{
	public static inline var LEFT:String="left";
	public static inline var RIGHT:String="right";
	public static inline var TOP:String="top";
	public static inline var BOTTOM:String="bottom";
	public static inline var TOP_LEFT:String="topLeft";
	public static inline var TOP_RIGHT:String="topRight";
	public static inline var BOTTOM_LEFT:String="bottomLeft";
	public static inline var BOTTOM_RIGHT:String="bottomRight";
	public static inline var BOTTOM_CENTER:String="bottomCenter";
	public static inline var TOP_CENTER:String="topCenter";
	
	public static inline var FIT_WIDTH:String="fitWidth";
	public static inline var FIT_HEIGHT:String="fitHeight";
	public static inline var FIT_SCREEN:String = "fitScreen";
	
	private function new() {}
	

	public static function checkAlignExist (pAlign:String):Void {
		
		switch (pAlign) {
			case LEFT: return null;
			case RIGHT: return null;
			case TOP: return null;
			case BOTTOM: return null;
			case TOP_LEFT: return null;
			case TOP_RIGHT: return null;
			case BOTTOM_LEFT: return null;
			case BOTTOM_RIGHT: return null;
			case BOTTOM_CENTER: return null;
			case TOP_CENTER: return null;
			case FIT_WIDTH: return null;
			case FIT_HEIGHT: return null;
			case FIT_SCREEN: return null;
			default:
				Debug.error("UIPosition \"" + pAlign + "\" doesn't exist !");
		}
		
		
	}
	
	/**
	* 
	* @param	pTarget DisplayObject à positionner
	* @param	pPosition type de positionnement
	* @param	pOffsetX décalage en X (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	* @param	pOffsetY décalage en Y (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	*/
	static public function setPosition (pTarget:DisplayObject, pPosition:String, pOffsetX:Float = 0, pOffsetY:Float = 0): Void {
				
		var lScreen:Rectangle = DeviceCapabilities.getScreenRect(pTarget.parent);
		
		var lTopLeft:Point = new Point (lScreen.x, lScreen.y);
		var lBottomRight:Point = new Point (lScreen.x + lScreen.width, lScreen.y + lScreen.height);
		
		moveTarget(
			{
				topLeft:lTopLeft,
				bottomRight:lBottomRight
			}, 
			pTarget, pPosition, pOffsetX, pOffsetY
		);
	}
	
	/**
	 * graphic.getBound().position must egal pTarget.parent.position
	 * That's why I use alignTopLeft() on the HudContextual instance.
	 * @param	pParentBounds
	 * @param	pTarget
	 * @param	pPosition
	 * @param	pOffsetX
	 * @param	pOffsetY
	 */
	public static function setPositionContextualUI (pParent:Container, pTarget:DisplayObject, pPosition:String, pOffsetX:Float = 0, pOffsetY:Float = 0):Void {
		
		// todo : pourquoi getBound().width donne une width différentes sur le tribunal ??? (plus large)
		moveTarget(
			{
				topLeft:new Point (0, 0),
				bottomRight:new Point (0 + pParent.width, 0 + pParent.height)
			},
			pTarget, pPosition, pOffsetX, pOffsetY
		);
	}
	
	private static function moveTarget (pParentRect:EasyRectangle, pTarget:DisplayObject, pPosition:String, pOffsetX:Float = 0, pOffsetY:Float = 0):Void {
		
		var lWidth:Float = pParentRect.bottomRight.x - pParentRect.topLeft.x;
		var lHeight:Float = pParentRect.bottomRight.y - pParentRect.topLeft.y;
		
		if ([TOP, TOP_LEFT, TOP_RIGHT, TOP_CENTER].indexOf(pPosition) != -1)
			pTarget.y = pParentRect.topLeft.y + pOffsetY;
		if ([BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT, BOTTOM_CENTER].indexOf(pPosition) != -1)
			pTarget.y = pParentRect.bottomRight.y - pOffsetY;
		if ([LEFT, TOP_LEFT, BOTTOM_LEFT].indexOf(pPosition) != -1)
			pTarget.x = pParentRect.topLeft.x + pOffsetX;
		if ([RIGHT, TOP_RIGHT, BOTTOM_RIGHT].indexOf(pPosition) != -1)
			pTarget.x = pParentRect.bottomRight.x - pOffsetX;
		if ([TOP_CENTER, BOTTOM_CENTER].indexOf(pPosition) != -1)
			pTarget.x = pParentRect.bottomRight.x - lWidth / 2 - pOffsetX;
		
		
		if (pPosition == FIT_WIDTH || pPosition == FIT_SCREEN) {
			pTarget.x = pParentRect.topLeft.x;
			untyped pTarget.width = lWidth;
		}
		if (pPosition == FIT_HEIGHT || pPosition == FIT_SCREEN) {
			pTarget.y = pParentRect.topLeft.y;
			untyped pTarget.height = lHeight;
		}
	}
	
}
