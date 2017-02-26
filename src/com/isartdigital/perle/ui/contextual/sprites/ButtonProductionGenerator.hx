package com.isartdigital.perle.ui.contextual.sprites;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.ValueChangeManager;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;

/**
 * Button class for all kind of Resources generator link to a building
 * @author de Toffoli Matthias
 */
class ButtonProductionGenerator extends ButtonProduction
{
	
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;

	public function new(pType:GeneratorType) {
		super(pType);
		
	}
	
	override function applyResourceGain():Void {
		myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
	}
	
	override function onClick():Void 
	{
		ValueChangeManager.addTextGain(position, myGeneratorDesc.type, myGeneratorDesc.quantity);
		SoundManager.getSound("SOUND_GOLD").play(); //The Generator button generates only gold
		ServerManagerBuilding.RecoltGenerator(IdManager.searchVBuildingById(myGeneratorDesc.id).tileDesc);
		super.onClick();
	}
	
	/**
	 * use for alpha fellback change size of the button
	 */
	public function setScale():Void{
		myGeneratorDesc = ResourcesManager.getGenerator(myGeneratorDesc.id, myGeneratorDesc.type);
		
		var ratio:Float = myGeneratorDesc.quantity / (myGeneratorDesc.max);
		scale = new Point(ratio,ratio);
	}
	/**
	 * take the generator description
	 * @param	pDesc the generator description
	 */
	public function setMyGeneratorDescription(pDesc:GeneratorDescription):Void {
		myGeneratorDesc = pDesc;
	}
	
	override public function destroy():Void 
	{
		myGeneratorDesc = null;
		super.destroy();
	}
	
}