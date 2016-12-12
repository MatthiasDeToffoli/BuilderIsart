package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;

/**
 * ...
 * @author ambroise
 */
class Virtual {
	
	/**
	 * active is true if the instance represented by Virtual should be visible on screen
	 */
	public var active(default, null):Bool = false;
	
	/**
	 * instance linked to VCell when active
	 */
	private var myInstance:Dynamic;

	public function new () {}
	
	
	/**
	 * Should not be used, because the only one creating and destroying Buildings
	 * should be VCell (but just in case someone destroy() a Building while forgetting
	 * the VCell)
	 */
	public function removeLink ():Void {
		trace("function that should not be used is used !");
		myInstance = null;
	}
	
	private function linkVirtual ():Void {
		myInstance.linkVirtualCell(this);
	}
	
	/**
	 * Cell is visible and content will be displayed !
	 */
	public function activate ():Void {
		if (active)
			throw("VCell is already active !");
		active = true;
		
		// look override in Childrens !	
	}
	
	/**
	 * Cell is not visible, content will be wiped out !
	 */
	public function desactivate ():Void {
		if (!active)
			throw("VCell is already unactive !");
			
		active = false;
		myInstance.recycle();
		myInstance = null;
	}
	
}