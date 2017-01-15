package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.BoostManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VPreferenceBuilding extends VBuilding
{

	var alignmentEffect:Alignment;
	
	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.neutral;
		super(pDescription);
		
		BoostManager.boostEvent.on(BoostManager.BOOST_EVENT_NAME, haveMoreBoost);
	}
	
	override function addGenerator():Void 
	{
		myMaxContains = 10000;
		myTime = 60000 / BoostManager.getBoost(alignmentEffect);
		super.addGenerator();
	}
	
	private function haveMoreBoost(?data:Dynamic):Void{
		myTime = 60000 / BoostManager.getBoost(alignmentEffect);
		ResourcesManager.UpdateResourcesGenerator(myGenerator, myMaxContains, myTime);
	}
	
	override public function destroy():Void 
	{
		BoostManager.boostEvent.off(BoostManager.BOOST_EVENT_NAME, haveMoreBoost);
		super.destroy();
	}
	
}