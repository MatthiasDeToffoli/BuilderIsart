package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.Debug;
import haxe.Json;
import pixi.core.display.Container;

interface HasVirtual {
	public function linkVirtual(pVirtual:Virtual):Void;
}

/**
 * ...
 * @author ambroise
 */
class Virtual {
	
	public static var BUILDING_NAME_TO_VCLASS(default, never):Map<String, String> = [
		BuildingName.STYX_PURGATORY => "VTribunal",
		BuildingName.STYX_VICE_1 => "VVicesBuilding",
		BuildingName.STYX_VICE_2 => "VVicesBuilding",
		BuildingName.STYX_VIRTUE_1 => "VVirtuesBuilding",
		BuildingName.STYX_VIRTUE_2 => "VVirtuesBuilding",
		
		
		BuildingName.HEAVEN_HOUSE => "VHouseHeaven",
		BuildingName.HEAVEN_HOUSE_INTERNS => "VInternHouseHeaven", // todo
		BuildingName.HEAVEN_COLLECTOR => "VCollectorHeaven",
		BuildingName.HEAVEN_MARKETING_DEPARTMENT => "VMarketingHouse", //todo
		BuildingName.HEAVEN_DECO_GENERIC_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_BIGGER_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_CLOUD => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_LAKE=> "VDecoHeaven",
		BuildingName.HEAVEN_DECO_PARK=> "VDecoHeaven",
		
		
		BuildingName.HELL_HOUSE => "VHouseHell",
		BuildingName.HELL_HOUSE_INTERNS => "VInternHouseHell", // todo
		BuildingName.HELL_COLLECTOR => "VCollectorHell", // todo
		BuildingName.HELL_FACTORY => "VFactory",
		BuildingName.HELL_DECO_SMALL_CRYSTAL => "VDecoHell",
		BuildingName.HELL_DECO_BIGGER_CRYSTAL=> "VDecoHell",
		BuildingName.HELL_DECO_DEAD_HEAD => "VDecoHell",
		BuildingName.HELL_DECO_BONES => "VDecoHell",
		BuildingName.HELL_DECO_LAVA_SOURCE => "VDecoHell",
	];
	
	
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
			Debug.error("Virtual is already active !");
		active = true;
		
		// look override in Childrens !	
	}
	
	/**
	 * Cell is not visible, content will be wiped out !
	 */
	public function desactivate ():Void {
		// if another problem whit Virtual already desactived you can use that bellow.
		/*var rand:Float = Math.random() * 10000000;
		var test:VTile = null;
		if (Std.is(this, VTile)) {
			test = cast(this, VTile);
		}
		if (test != null)
			trace(test.tileDesc);
		trace(rand);
		if (!active) {
			Debug.warn("desactivated: but already dasctived");
			if (test != null)
				trace(test.tileDesc);
				trace(rand);
				trace(Type.typeof(this));
		}*/
		if (!active)
			Debug.error("Virtual is already desactived !");
		
		active = false;
		removeGraphic();
	}
	
	/**
	 * Recyle the graphic if it has recycle method or destroy it.
	 */
	private function removeGraphic ():Void {
		if (graphic != null) {
			if (Std.is(graphic, PoolingObject))
				cast(graphic, PoolingObject).recycle();
			else // todo : rendre l'hud contextual (son contenu) reclyclable
				graphic.destroy();
		}
		graphic = null;
	}
	
	
	public function destroy ():Void {
		if (active)
			desactivate();
	}
	
}