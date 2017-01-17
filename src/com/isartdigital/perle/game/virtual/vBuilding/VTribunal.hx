package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.ui.contextual.sprites.PurgatorySoulCounter;
import pixi.core.math.Point;

	
/**
 * a sigleton represanting the tribunal (non graphic)
 * @author de Toffoli Matthias
 */
class VTribunal extends VBuilding 
{
	
	/**
	 * instance unique de la classe VTribunal
	 */
	private static var instance: VTribunal;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (?pDesc:TileDescription): VTribunal {
		if (instance == null) instance = new VTribunal(pDesc);
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pDesc:TileDescription) 
	{
		var lDesc:TileDescription;
		
		alignementBuilding = Alignment.neutral;

		if (pDesc == null){
			lDesc = {
				buildingName:BuildingName.STYX_PURGATORY,
				id:IdManager.newId(),
				regionX:0,
				regionY:0,
				mapX:0,
				//center to the styx - the size of tribunal
				mapY: Math.floor((Ground.ROW_Y_STYX_LENGTH / 2) - 3),
				isTribunal: true
			};
		} else {
			lDesc = pDesc;
		}
		
		
		super(lDesc);
		setCameraPos(); // @TODO : ici bof car cette classe n'a pas de rapport avec la camera
		
		
	}
	
	override public function updateGeneratorInfo(?data:Dynamic) 
	{
		myGenerator.desc = ResourcesManager.getGenerator(tileDesc.id, myGeneratorType);
		PurgatorySoulCounter.getInstance().setText({current:myGenerator.desc.quantity, max:myGenerator.desc.max});
	}
	override public function activate():Void 
	{
		super.activate();
		PurgatorySoulCounter.getInstance().setText({current:myGenerator.desc.quantity, max:myGenerator.desc.max});
	}
	
	
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}

	override function addGenerator():Void {
		myTime = 60000 * 40; //40 minutes
		myGeneratorType = GeneratorType.soul;
		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, myGeneratorType, myMaxContains, myTime, Alignment.neutral, true);
		
	}
	
	/**
	 * when the boat drive souls
	 * @param quantity quantity of souls drive by the boat
	 */
	public function getByBoat(quantity:Int):Void{
		ResourcesManager.increaseResources(myGenerator, quantity);
	}
	
	/**
	 * set the position to the camera
	 */
	public function setCameraPos():Void{
		
		CameraManager.placeCamera(new Point(1, tileDesc.mapY + 1));
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}