package com.isartdigital.perle.ui;
import com.isartdigital.utils.Debug;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;

/**
 * 
 * @author ambroise
 */
class SmartCheck{

	// replace "getChildByName(" by "SmartCheck.getChildByName(this, " 
	
	/**
	 * This function replace << getChildByName("ButtonShop") >> and
	 * display a trace if == null
	 * 
	 * pContainer must be a descendant from Container (i typed it Dynamic to make that function
	 * more easy to use)
	 */
	public static function getChildByName (pContainer:Dynamic, pAssetName:String):DisplayObject {
		var lContainer:Container = cast(pContainer, Container);
		var lChild:DisplayObject = lContainer.getChildByName(pAssetName);
		
		if (lChild == null)
			Debug.error("[" + getClassName(pContainer) + "].getChildByName(\"" + pAssetName  + "\") == null");
		
		return lChild;
	}
	
	/**
	 * Usefull to get all children name when adding wireframes
	 * 
	 * pContainer must be a descendant from Container (i typed it Dynamic to make that function
	 * more easy to use)
	 */
	public static function traceChildrens (pContainer:Dynamic):Void {
		var lContainer:Container = cast(pContainer, Container);
		
		for (i in 0...lContainer.children.length)
			trace("[" + getClassName(pContainer) + "] >=> " +lContainer.children[i].name);
	}
	
	private static function getClassName (pContainer:Dynamic):String {
		return Type.typeof(pContainer).getParameters()[0].__name__;
		
	}
	
	public function new() {
		
	}
	
}