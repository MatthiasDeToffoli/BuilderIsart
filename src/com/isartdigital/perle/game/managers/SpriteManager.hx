package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * ...
 * @author grenu
 */
class SpriteManager
{

	/**
	 * Replace UISprite with another UISprite
	 * @param	baseImage UISprite to replace
	 * @param	spriteName assetname of wanted UISprite
	 * @param	parentContainer parent container
	 * @param	clickable active interactivity
	 * @return
	 */
	public static function createNewImage(baseImage:UISprite, spriteName:String, parentContainer:GameObject, ?clickable:Bool=false):UISprite {
		var newImage:UISprite;
		var basePos:Point;
		
		basePos = baseImage.position.clone();
		parentContainer.removeChild(baseImage);
		
		newImage = new UISprite(spriteName);
		newImage.position = basePos;
		
		parentContainer.addChild(newImage);
		baseImage.destroy();
		
		if (clickable) newImage.interactive = true;
		
		return newImage;
	}
	
}