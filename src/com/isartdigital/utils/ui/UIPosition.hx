package com.isartdigital.utils.ui;
import com.isartdigital.utils.system.DeviceCapabilities;
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
		var lBottomRight:Point = new Point (lScreen.x+lScreen.width,lScreen.y+lScreen.height);
		/*
		switch pPosition {
			case TOP    : case TOP_LEFT    : case TOP_RIGHT    : lTopLeft.y + pOffsetY;
			case BOTTOM : case BOTTOM_LEFT : case BOTTOM_RIGHT : case BOTTOM_CENTER : pTarget.y = lBottomRight.y - pOffsetY;
			case LEFT   : case TOP_LEFT    : case BOTTOM_LEFT  : pTarget.x = lTopLeft.x + pOffsetX;
			case RIGHT  : case TOP_RIGHT   : case BOTTOM_RIGHT : pTarget.x = lBottomRight.x - pOffsetX;
			case BOTTOM_CENTER :lBottomRight.x - lScreen.width / 2 - pOffsetX;
		}
		
		
		switch pPosition {
			case TOP    : case TOP_LEFT    : case TOP_RIGHT    :
				lTopLeft.y + pOffsetY;
			case BOTTOM : case BOTTOM_LEFT : case BOTTOM_RIGHT : case BOTTOM_CENTER : 
				pTarget.y = lBottomRight.y - pOffsetY;
			case LEFT   : case TOP_LEFT    : case BOTTOM_LEFT  :
				pTarget.x = lTopLeft.x + pOffsetX;
			case RIGHT  : case TOP_RIGHT   : case BOTTOM_RIGHT :
				pTarget.x = lBottomRight.x - pOffsetX;
			case BOTTOM_CENTER :
				lBottomRight.x - lScreen.width / 2 - pOffsetX;
		}
		
		
		if (pPosition == TOP || pPosition == TOP_LEFT || pPosition == TOP_RIGHT) pTarget.y = lTopLeft.y + pOffsetY;
		if (pPosition == BOTTOM || pPosition == BOTTOM_LEFT || pPosition == BOTTOM_RIGHT || pPosition == BOTTOM_CENTER) pTarget.y = lBottomRight.y - pOffsetY;
		if (pPosition == LEFT || pPosition == TOP_LEFT || pPosition == BOTTOM_LEFT) pTarget.x = lTopLeft.x + pOffsetX;
		if (pPosition == RIGHT || pPosition == TOP_RIGHT || pPosition == BOTTOM_RIGHT) pTarget.x = lBottomRight.x - pOffsetX;
		if (pPosition == BOTTOM_CENTER) pTarget.x = lBottomRight.x - lScreen.width / 2 - pOffsetX;
		
		
		
		if ([TOP, TOP_LEFT, TOP_RIGHT].indexOf(pPosition) != -1) pTarget.y = lTopLeft.y + pOffsetY;
		if ([BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT, BOTTOM_CENTER].indexOf(pPosition) != -1) pTarget.y = lBottomRight.y - pOffsetY;
		if ([LEFT, TOP_LEFT, BOTTOM_LEFT].indexOf(pPosition) != -1) pTarget.x = lTopLeft.x + pOffsetX;
		if ([RIGHT, TOP_RIGHT, BOTTOM_RIGHT].indexOf(pPosition) != -1) pTarget.x = lBottomRight.x - pOffsetX;
		if (pPosition == BOTTOM_CENTER) pTarget.x = lBottomRight.x - lScreen.width / 2 - pOffsetX;
		*/
		
		
		
		if ([TOP, TOP_LEFT, TOP_RIGHT].indexOf(pPosition) != -1) 
			pTarget.y = lTopLeft.y + pOffsetY;
		if ([BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT, BOTTOM_CENTER].indexOf(pPosition) != -1) 
			pTarget.y = lBottomRight.y - pOffsetY;
		if ([LEFT, TOP_LEFT, BOTTOM_LEFT].indexOf(pPosition) != -1) 
			pTarget.x = lTopLeft.x + pOffsetX;
		if ([RIGHT, TOP_RIGHT, BOTTOM_RIGHT].indexOf(pPosition) != -1) 
			pTarget.x = lBottomRight.x - pOffsetX;
		if (pPosition == BOTTOM_CENTER) 
			pTarget.x = lBottomRight.x - lScreen.width / 2 - pOffsetX;
		
		
		if (pPosition == FIT_WIDTH || pPosition == FIT_SCREEN) {
			pTarget.x = lTopLeft.x;
			untyped pTarget.width = lBottomRight.x - lTopLeft.x;
		}
		if (pPosition == FIT_HEIGHT || pPosition == FIT_SCREEN) {
			pTarget.y = lTopLeft.y;
			untyped pTarget.height = lBottomRight.y - lTopLeft.y;
		}

		
	}
	
}
