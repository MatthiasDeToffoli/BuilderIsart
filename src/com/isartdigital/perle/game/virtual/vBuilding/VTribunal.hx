package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import pixi.core.math.Point;

	
/**
 * ...
 * @author de Toffoli Matthias
 */

 /**
  * a sigleton represanting the tribunal (non graphic)
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

		if (pDesc == null){
			lDesc = {
				className:"Villa",
				assetName:"Villa",
				id:IdManager.newId(),
				regionX:0,
				regionY:0,
				mapX:0,
				//center to the styx - the size of tribunal // hey Styx_Y length == 13 donc
				// 6.5 - 3 == 3.5 ; tu voulais pas plutôt faire 6.5 - 3/2 == 5 ?
				mapY: Math.floor((Ground.ROW_Y_STYX_LENGTH / 2) - 3),
				isTribunal: true
			};
		} else {
			lDesc = pDesc;
		}
		
		
		super(lDesc);
		setCameraPos(); // @TODO : ici bof car cette classe n'a pas de rapport avec la camera
	}
	
	// @Matthias : sinon tu créais deux fois un générator puisque qu'il y avait
	// un addREsourceGenerator dans le new() du VBuilding également
	// ce message s'auto-détruit après votre lecture
	override function addGenerator():Void {
		myGeneratorType = GeneratorType.soul;
		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, myGeneratorType, 10, Alignment.neutral);
		//prodBtn = new ButtonProduction("ButtonGold"); c'est gérer autrement maintenant
		//setCameraPos(); idem qui plu haut
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