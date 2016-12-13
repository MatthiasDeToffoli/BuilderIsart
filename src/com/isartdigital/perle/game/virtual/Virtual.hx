package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;

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
	public var graphic(default, null):FlumpStateGraphic;

	public function new () {}
	
	
	/**
	 * Should not be used, because the only one creating and destroying Buildings
	 * should be VCell (but just in case someone destroy() a Building while forgetting
	 * the VCell)
	 */
	public function removeLink ():Void {
		trace("function that should not be used is used !");
		graphic = null;
	}
	
	private function linkVirtual ():Void {
		untyped graphic.linkVirtualCell(this); // todo, créer héritage ?
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
		if (graphic != null)
			untyped graphic.recycle(); // todo : dépend si est dans pooling...
		graphic = null;
	}
	
	// destroy : ATTENTION au lien vers une VTile dans Menu_BatimentConstruit...
	
}