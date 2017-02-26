package com.isartdigital.perle.ui.contextual.sprites;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.ValueChangeManager;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.utils.sounds.SoundManager;

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
	
	override function onClick():Void 
	{
		ValueChangeManager.addTextGain(position, type, valueToAdd);
		
		type == GeneratorType.buildResourceFromHell ? SoundManager.getSound("SOUND_IRON").play() : SoundManager.getSound("SOUND_WOOD").play();
		
		ServerManagerBuilding.CollectorProdRecuperation(IdManager.searchVBuildingById(ref).tileDesc);
		super.onClick();
	}
	override function applyResourceGain():Void {
		ResourcesManager.gainResources(type, valueToAdd);
		
		TimeManager.removeProductionTIme(ref);
	}
	
}