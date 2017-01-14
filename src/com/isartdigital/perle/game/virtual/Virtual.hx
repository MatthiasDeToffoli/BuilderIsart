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
	
	public static var ASSETNAME_TO_VCLASS(default, never):Map<String, String> = [
		AssetName.BUILDING_PURGATORY => "VTribunal",
		AssetName.DECO_HEAVEN_TREE_1 => "VDecoHeaven", // todo : c'est bien des building ??
		AssetName.DECO_HEAVEN_TREE_2 => "VDecoHeaven",
		AssetName.DECO_HEAVEN_TREE_3 => "VDecoHeaven",
		AssetName.DECO_HEAVEN_FOUNTAIN => "VDecoHeaven",
		AssetName.DECO_HEAVEN_ROCK => "VDecoHeaven",
		AssetName.DECO_HEAVEN_VERTUE => "VVirtuesBuilding",
		AssetName.DECO_HELL_TREE_1 => "VDecoHell",
		AssetName.DECO_HELL_TREE_2 => "VDecoHell",
		AssetName.DECO_HELL_TREE_3 => "VDecoHell",
		AssetName.DECO_HELL_ROCK => "VDecoHell",
		
		AssetName.BUILDING_HEAVEN_BRIDGE => "VUrbanHouse",
		AssetName.BUILDING_HEAVEN_HOUSE => "VHouseHeaven",
		AssetName.BUILDING_HEAVEN_BUILD_1 => "VHouseHeaven",
		AssetName.BUILDING_HEAVEN_BUILD_2 => "VHouseHeaven",
		AssetName.LUMBERMIL_LEVEL1 => "VLumbermill",
		AssetName.LUMBERMIL_LEVEL2 => "VLumbermill",
		AssetName.BUILDING_HELL_HOUSE => "VHouseHell",
		AssetName.BUILDING_HELL_BUILD_1 => "VHouseHell",
		AssetName.BUILDING_HELL_BUILD_2 => "VHouseHell",
		AssetName.QUARRY_LEVEL_1 => "VQuarry",
	];
	
	public static var ASSETNAME_TO_ALIGNEMENT(default, never):Map<String, Alignment> = [	
		AssetName.BUILDING_PURGATORY => Alignment.neutral,
		AssetName.DECO_HEAVEN_TREE_1 => Alignment.heaven, // todo : c'est bien des building ??
		AssetName.DECO_HEAVEN_TREE_2 => Alignment.heaven,
		AssetName.DECO_HEAVEN_TREE_3 => Alignment.heaven,
		AssetName.DECO_HEAVEN_FOUNTAIN => Alignment.heaven,
		AssetName.DECO_HEAVEN_ROCK => Alignment.heaven,
		AssetName.DECO_HEAVEN_VERTUE => Alignment.neutral,
		AssetName.DECO_HELL_TREE_1 => Alignment.hell,
		AssetName.DECO_HELL_TREE_2 => Alignment.hell,
		AssetName.DECO_HELL_TREE_3 => Alignment.hell,
		AssetName.DECO_HELL_ROCK => Alignment.hell,
		
		AssetName.BUILDING_HEAVEN_BRIDGE => Alignment.neutral,
		AssetName.BUILDING_HEAVEN_HOUSE => Alignment.heaven,
		AssetName.BUILDING_HEAVEN_BUILD_1 => Alignment.heaven,
		AssetName.BUILDING_HEAVEN_BUILD_2 => Alignment.heaven,
		AssetName.LUMBERMIL_LEVEL1 => Alignment.heaven,
		AssetName.LUMBERMIL_LEVEL2 => Alignment.heaven,
		AssetName.BUILDING_HELL_HOUSE => Alignment.hell,
		AssetName.BUILDING_HELL_BUILD_1 => Alignment.hell,
		AssetName.BUILDING_HELL_BUILD_2 => Alignment.hell,
		AssetName.QUARRY_LEVEL_1=> Alignment.hell,
		
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