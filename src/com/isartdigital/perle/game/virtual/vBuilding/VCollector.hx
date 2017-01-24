package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollector extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		
	}
	
	override function setHaveRecolter():Void 
	{
		myGenerator = {desc:ResourcesManager.getGenerator(tileDesc.id, myGeneratorType)};
		
		if (myGenerator != null) super.setHaveRecolter();
		else haveRecolter = false;
	}
	
	override function addGenerator():Void 
	{
		if(haveRecolter) super.addGenerator();
	}
	
	override function addHudContextual():Void 
	{
		if(haveRecolter) super.addHudContextual();
	}
	public function startProduction(pTime:Float, pMax:Int){
		myTime = pTime;
		myMaxContains = pMax;
		haveRecolter = true;
		addGenerator();
		addHudContextual();
	}
	
	public function fineProduction(){
		ResourcesManager.removeGenerator(myGenerator);
		myVContextualHud.destroy();
		haveRecolter = false;
	}
	
	
}