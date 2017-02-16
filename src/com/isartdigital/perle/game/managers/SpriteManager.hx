package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import sys.db.Types.STimeStamp;

enum TypeSpawn { SMART_COMPONENT; SPRITE; }

/**
 * ...
 * @author grenu
 */
class SpriteManager
{
	
	/**
	 * Replace a spawner with wanted object
	 * @param	spawner
	 * @param	spriteName
	 * @param	parentContainer
	 * @param	pCast
	 * @param	lastChildren
	 * @param	clickable
	 * @return
	 */
	public static function spawnComponent(spawner:UISprite, spriteName:String, parentContainer:GameObject, pCast:TypeSpawn, ?clickable:Bool = false, ?zIndex:Int = null):Dynamic {
		var newComponent:Dynamic;
		var basePos:Point;
		
		switch (pCast) 
		{
			case TypeSpawn.SPRITE: newComponent = new UISprite(spriteName);
			case TypeSpawn.SMART_COMPONENT: newComponent = new SmartComponent(spriteName);
			default: return null;
		}
		
		newComponent.position = spawner.position.clone();
		parentContainer.removeChild(spawner);
		if (zIndex != null) parentContainer.addChildAt(newComponent, zIndex);
		else parentContainer.addChild(newComponent);
		spawner.destroy();
		
		if (clickable) newComponent.interactive = true;
		
		return newComponent;
	}
	
	/**
	 * Remove UISprite
	 * @param	sprite
	 * @param	pParent
	 */
	public static function removeFromScreen(sprite:UISprite, pParent:GameObject):Void {
		if (sprite.interactive = true) sprite.interactive = false;
		pParent.removeChild(sprite);
		sprite.destroy();
	}
	
}