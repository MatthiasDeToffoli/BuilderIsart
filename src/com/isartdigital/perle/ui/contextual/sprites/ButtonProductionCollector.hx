package com.isartdigital.perle.ui.contextual.sprites;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.TimeManager;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ButtonProductionCollector extends ButtonProduction
{

	private var valueToAdd:Float;
	private var ref:Int;
	private var type:GeneratorType;
	
	public function new(pType:GeneratorType, val:Int, pRef:Int) {
		super(pType);
		valueToAdd = val;
		type = pType;
		ref = pRef;
	}
	
	override function applyResourceGain():Void {
		ResourcesManager.gainResources(type, valueToAdd);
		TimeManager.removeProductionTIme(ref);
	}
	
}