package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * ...
 * @author ambroise
 */
class BHConstruction extends BuildingHud{

	private static var instance:BHConstruction;
	
	public static function getInstance (): BHConstruction {
		if (instance == null) instance = new BHConstruction();
		return instance;
	}	
	
	private function new() {
		super("BuildingContext");
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}