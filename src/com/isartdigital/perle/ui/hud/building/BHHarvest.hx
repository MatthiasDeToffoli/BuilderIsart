package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.Browser;
import pixi.flump.Movie;

/**
 * 
 * @author Emeline Berenguier
 */
class BHHarvest extends BHBuilt{
	
	private static var instance:BHHarvest;
 
 
 
	public static function getInstance (): BHHarvest {
		if (instance == null) instance = new BHHarvest();
		return instance;
	} 
	 
	private function new() {
		super("BuiltContext");
	}
	 
	override public function setMoveAndDestroy():Void 
	{
	  if(Std.is(BuildingHud.virtualBuilding,VTribunal)){
	   btnMove.alpha = 0.5;
	   btnDestroy.alpha = 0.5;
	  } else{
	  super.setMoveAndDestroy();
		}
	}
	 
	 override public function destroy():Void {
	  instance = null;
	  super.destroy();
	 }
}