package com.isartdigital.perle.ui.hud.building.valuesChange;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ValueLost extends ValueChange
{

	public function new(pType:GeneratorType,pPrice:Float) 
	{
		signe = "-";
		super(AssetName.VALUES_LOST,pType,pPrice);
		
	}
	
}