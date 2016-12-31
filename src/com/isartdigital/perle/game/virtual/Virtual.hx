package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import pixi.core.display.Container;

interface HasVirtual {
	public function linkVirtual(pVirtual:Virtual):Void;
}

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
	 * If true graphic will never show up, no clipping. (used while moving a VBuilding)
	 * It does not desactivate() the virtual !
	 */
	public var ignore(default, null):Bool = false;
	
	/**
	 * instance linked to VCell when active
	 */
	public var graphic(default, null):Container;

	public function new () {}
	
	
	/**
	 * Should not be used, because the only one creating and destroying Buildings
	 * should be VCell (but just in case someone destroy() a Building while forgetting
	 * the VCell) (graphic is read only)
	 */
	public function removeLink ():Void {
		trace("function that should not be used !");
		graphic = null;
	}
	
	/*private function linkVirtual ():Void {
		cast(graphic, HasVirtual).linkVirtual(this);
	}*/
	
	/**
	 * Cell is visible and content will be displayed !
	 */
	public function activate ():Void {
		if (active)
			throw("Virtual is already active !");
		active = true;
		
		// look override in Childrens !	
	}
	
	/**
	 * Cell is not visible, content will be wiped out !
	 */
	public function desactivate ():Void {
		if (!active)
			throw("Virtual is already desactived !");
		
		active = false;
		removeGraphic();
	}
	
	/**
	 * Recyle the graphic if it has recycle method or destroy it.
	 */
	private function removeGraphic ():Void {
		if (graphic != null) {
			trace ("doit trace true la plupart du temps : " + Std.is(graphic, PoolingObject)); // todo vérification, puis suppression
			
			if (Std.is(graphic, PoolingObject))
				cast(graphic, PoolingObject).recycle();
			else
				graphic.destroy();
		}
		graphic = null;
	}
	
	
	public function destroy ():Void {
		if (active)
			desactivate();
	}
	
}