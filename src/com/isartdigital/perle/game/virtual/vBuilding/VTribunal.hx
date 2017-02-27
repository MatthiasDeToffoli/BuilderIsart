package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.contextual.sprites.PurgatorySoulCounter;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.localisation.Localisation;
import eventemitter3.EventEmitter;
import pixi.core.math.Point;


typedef SoulDescription = {
	var name:String;
	var adjective:String;
	var age:Int;
	var alignement:Int;
	var sexe:Int;
}
	
/**
 * a sigleton represanting the tribunal (non graphic)
 * @author de Toffoli Matthias
 */
class VTribunal extends VBuildingUpgrade 
{
	
	/**
	 * instance unique de la classe VTribunal
	 */
	private static var instance: VTribunal;
	public var soulToJudge:SoulDescription;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (?pDesc:TileDescription): VTribunal {
		if (instance == null) instance = new VTribunal(pDesc);
		return instance;
	}
	
	private var BASETIMEWITHOUTBOOST(default, never):Int = 40 * TimesInfo.MIN;
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pDesc:TileDescription) 
	{
		UpgradeAssetsList = [AssetName.BUILDING_STYX_PURGATORY, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2, AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3];
		var lDesc:TileDescription;
		
		alignementBuilding = Alignment.neutral;

		if (pDesc == null){
			lDesc = {
				buildingName:BuildingName.STYX_PURGATORY,
				id:IdManager.newId(),
				regionX:0,
				regionY:0,
				mapX:0,
				mapY: Math.floor((Ground.ROW_Y_STYX_LENGTH / 2) - 1),
				level:1,
				isTribunal: true
			};
		} else {
			lDesc = pDesc;
		}
		
		
		super(lDesc);
		addGenerator();
		setCameraPos(); // @TODO : ici bof car cette classe n'a pas de rapport avec la camera
		findSoul();
		
		
	}
	
	public function findSoul():Void {
		if (myGenerator.desc.quantity == 0) soulToJudge = {name:"", adjective:"", age:1, alignement:1, sexe:1};
		else {
			var i:Int = Math.floor(Math.random() * GameConfig.countSoulName());
			var j:Int = Math.floor(Math.random() * GameConfig.countSoulAdj());
			
			soulToJudge = {
				name: GameConfig.getSoulName(i).en,
				adjective: GameConfig.getSoulAdjective(j).en,
				age: GameConfig.getSoulName(i).age,
				alignement: GameConfig.getSoulAdjective(j).alignement,
				sexe: GameConfig.getSoulName(i).sexe,
			}
		}
	}
	
	public function updateSoulToJudge(pName:String):Void {
		soulToJudge.name = pName;
		soulToJudge.adjective = "Friendly";
		soulToJudge.age = 1;
		soulToJudge.alignement = 1;
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
	
	override public function onClick(pPos:Point):Void 
	{
		Hud.getInstance().onClickTribunal();
	}
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}

	override function addGenerator():Void {
		super.addGenerator();
		
	}
	
	/**
	 * update the time of production
	 * @param	denominator the number to divise the time
	 */
	public function updateGenerator(denominator:Float):Void {
		var  typeBuilding:TableTypeBuilding = GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level);
		myTime = calculTimeProd(typeBuilding) / denominator;
		myGenerator = ResourcesManager.UpdateResourcesGenerator(myGenerator, getMaxContains(typeBuilding), myTime);
	}
	
	override function getMaxContains(?pTypeBuilding:TableTypeBuilding):Int 
	{
		return pTypeBuilding.maxSoulsContained;
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