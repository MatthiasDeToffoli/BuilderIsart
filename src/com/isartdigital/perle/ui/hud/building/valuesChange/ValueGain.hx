package com.isartdigital.perle.ui.hud.building.valuesChange;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ValueGain extends ValueChange
{

	public function new(pType:GeneratorType,pGain:Float) 
	{
		signe = "+";
		super(AssetName.VALUES_GAIN, pType,pGain);
		
	}
	
}