package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class AnimationManager
{

	private static var buildingsToAnim:Array<Building>;
	
	
	public static function awake():Void {
		buildingsToAnim = new Array<Building>();
	}
	
	public static function manage(pElement:Building):Void {
		var lElement:Building;

		for (lElement in buildingsToAnim) {
			if (pElement == lElement) return;
		}
		buildingsToAnim.push(pElement);
	}
	
	public static function removeToManager(pElement:Building):Void{
		var i:Int, l:Int = buildingsToAnim.length;
		
		for (i in 0...l) {
			if (pElement == buildingsToAnim[i]) buildingsToAnim.splice(i, 1);
		}
	}
	
	public static function gameLoop():Void {
		var lElement:Building;
		
		for (lElement in buildingsToAnim) {
			lElement.onAnimationEnd();
		}

	}
	
}