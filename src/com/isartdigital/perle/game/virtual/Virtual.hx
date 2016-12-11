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
	
	public var tileDesc:TileDescription; // todo : mettre ds Vtile...
	/*public var tileDesc(get, null) :TileDescription;
	public function get_tileDesc ():TileDescription {
		// todo : met à jour TileDesc si besoin.
		// todo : devrait tjrs être à jour de toute façon!
		// utiliser que pour Save en principe.
		return tileDesc;
	}*/ // bug avec la save... problème du à Haxe ?
	
	/**
	 * instance linked to VCell when active
	 */
	private var myInstance:Dynamic;

	public function new (pDescription:TileDescription) {
		tileDesc = pDescription;
	}
	

	
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