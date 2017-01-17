package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.Debug;
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
		BuildingName.STYX_VICE => "VVirtuesBuilding",
		BuildingName.STYX_VIRTUE => "VVirtuesBuilding",
		BuildingName.STYX_MARKET => "VHouseHell", //todo: mauvaise VClass
		
		
		BuildingName.HEAVEN_HOUSE => "VHouseHeaven",
		BuildingName.HEAVEN_COLLECTOR => "VLumbermill",
		BuildingName.HEAVEN_MARKETING_DEPARTMENT => "VHouseHell", //todo
		BuildingName.HEAVEN_DECO_GENERIC_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_BIGGER_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_PRETTY_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_AWESOME_TREE => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_BUILDING => "VDecoHeaven",
		BuildingName.HEAVEN_DECO_GORGEOUS_BUILDING => "VDecoHeaven",
		
		
		BuildingName.HELL_HOUSE => "VHouseHell",
		BuildingName.HELL_COLLECTOR => "VHouseHell", // todo
		BuildingName.HELL_FACTORY => "VQuarry",
		BuildingName.HELL_DECO_GENERIC_ROCK => "VDecoHell",
		BuildingName.HELL_DECO_BIGGER_ROCK => "VDecoHell",
		BuildingName.HELL_DECO_PRETTY_ROCK => "VDecoHell",
		BuildingName.HELL_DECO_AWESOME_ROCK => "VDecoHell",
		BuildingName.HELL_DECO_BUILDING => "VDecoHell",
		BuildingName.HELL_DECO_GORGEOUS_BUILDING => "VDecoHell",
		
		
		BuildingName.HOUSE_INTERNS => "VHouseHell", // todo
	];
	
	public static var BUILDING_NAME_TO_ALIGNEMENT(default, never):Map<String, Alignment> = [
	
		BuildingName.STYX_PURGATORY => Alignment.neutral,
		BuildingName.STYX_VICE => Alignment.neutral,
		BuildingName.STYX_VIRTUE => Alignment.neutral,
		BuildingName.STYX_MARKET => Alignment.neutral,
		
		
		BuildingName.HEAVEN_HOUSE => Alignment.heaven,
		BuildingName.HEAVEN_COLLECTOR => Alignment.heaven,
		BuildingName.HEAVEN_MARKETING_DEPARTMENT => Alignment.heaven,
		BuildingName.HEAVEN_DECO_GENERIC_TREE => Alignment.heaven,
		BuildingName.HEAVEN_DECO_BIGGER_TREE => Alignment.heaven,
		BuildingName.HEAVEN_DECO_PRETTY_TREE => Alignment.heaven,
		BuildingName.HEAVEN_DECO_AWESOME_TREE => Alignment.heaven,
		BuildingName.HEAVEN_DECO_BUILDING => Alignment.heaven,
		BuildingName.HEAVEN_DECO_GORGEOUS_BUILDING => Alignment.heaven,
		
		
		BuildingName.HELL_HOUSE => Alignment.hell,
		BuildingName.HELL_COLLECTOR => Alignment.hell,
		BuildingName.HELL_FACTORY => Alignment.hell,
		BuildingName.HELL_DECO_GENERIC_ROCK => Alignment.hell,
		BuildingName.HELL_DECO_BIGGER_ROCK => Alignment.hell,
		BuildingName.HELL_DECO_PRETTY_ROCK => Alignment.hell,
		BuildingName.HELL_DECO_AWESOME_ROCK => Alignment.hell,
		BuildingName.HELL_DECO_BUILDING => Alignment.hell,
		BuildingName.HELL_DECO_GORGEOUS_BUILDING => Alignment.hell,
		
		
		BuildingName.HOUSE_INTERNS => null,
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