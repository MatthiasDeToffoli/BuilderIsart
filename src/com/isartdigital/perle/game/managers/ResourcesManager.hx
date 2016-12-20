package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.ResourcesGeneratorDescription;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import haxe.rtti.CType.Typedef;

/**
 * ...
 * @author de Toffoli Matthias
 */

 /*
  * @TODO voir si on gére le level up ici ou ailleur
  * @TODO passer la classer en singleton et virer les static
  * */
 
 //{ ################# typedef #################
 
 //typedef for save contain all data resources
 typedef ResourcesData = {
	 //Array that represents the on going ressources of each buildings
	var  generatorsMap:Map<GeneratorType,Array<Generator>>;
	
	//Total value of some resources
	var totalsMap:Map<GeneratorType,Float>;
	
	//level
	var level:Int;
	
 }
 
 typedef Generator = {
	 var desc:GeneratorDescription;
 }
 //} endregion
 
class ResourcesManager
{
	
	/*
	 ####################
	 ####################
	 ####################
	 */
 
	//function and var rapport to data
	 //{ ################# data #################
	private static var myResourcesData:ResourcesData;
	
	public static function initWithoutSave():Void{
		
		var pMapG:Map<GeneratorType,Array<Generator>> = new Map<GeneratorType,Array<Generator>>();
		var pMapT:Map<GeneratorType,Float> = new Map<GeneratorType,Float>();
		var i:Int;
		
		pMapG[GeneratorType.soul] = new Array<Generator>();
		pMapT[GeneratorType.soul] = 0;
		
		pMapG[GeneratorType.soft] = new Array<Generator>();
		pMapT[GeneratorType.soft] = 0;
		
		pMapG[GeneratorType.hard] = new Array<Generator>();
		pMapT[GeneratorType.hard] = 0;
		
		pMapG[GeneratorType.badXp] = new Array<Generator>();
		pMapT[GeneratorType.badXp] = 0;
		
		pMapG[GeneratorType.goodXp] = new Array<Generator>();
		pMapT[GeneratorType.goodXp] = 0;
		
		pMapG[GeneratorType.intern] = new Array<Generator>();
		pMapT[GeneratorType.intern] = 0;
		
		pMapG[GeneratorType.buildResourceFromHell] = new Array<Generator>();
		pMapT[GeneratorType.buildResourceFromHell] = 0;
		
		pMapG[GeneratorType.buildResourceFromParadise] = new Array<Generator>();
		pMapT[GeneratorType.buildResourceFromParadise] = 0;

		myResourcesData = {
			generatorsMap: pMapG,
			totalsMap: pMapT,
			level: 0
		}
		
		TimeManager.eTimeGenerator.on(TimeManager.EVENT_RESOURCE_TICK, increaseResources);
	}
	
	public static function initWithLoad(resourcesDescriptionLoad:ResourcesGeneratorDescription):Void{

		initWithoutSave();
		
		var myDesc:GeneratorDescription;
		var myGenerator:Generator;
		var type:Dynamic;
		
		for (myDesc in resourcesDescriptionLoad.arrayGenerator){
			type = myDesc.type;
			myDesc.type = translateArrayToEnum(type[0]);
			myGenerator = {desc:myDesc};
			myResourcesData.generatorsMap[myDesc.type].push(myGenerator);
			TimeManager.addGenerator(myGenerator);
		}
		
		myResourcesData.totalsMap[GeneratorType.soft] = resourcesDescriptionLoad.totals[0];
		myResourcesData.totalsMap[GeneratorType.hard] = resourcesDescriptionLoad.totals[1];
		myResourcesData.totalsMap[GeneratorType.goodXp] = resourcesDescriptionLoad.totals[2];
		myResourcesData.totalsMap[GeneratorType.badXp] = resourcesDescriptionLoad.totals[3];
		myResourcesData.totalsMap[GeneratorType.soul] = resourcesDescriptionLoad.totals[4];
		myResourcesData.totalsMap[GeneratorType.intern] = resourcesDescriptionLoad.totals[5];
		myResourcesData.totalsMap[GeneratorType.buildResourceFromHell] = resourcesDescriptionLoad.totals[6];
		myResourcesData.totalsMap[GeneratorType.buildResourceFromParadise] = resourcesDescriptionLoad.totals[7];
		

	}
	
	//this function is necessary beceause save translate enum to array.....
	private static function translateArrayToEnum(pString:String):GeneratorType{
		switch pString {
			case "soft":
				return GeneratorType.soft;
				
			case "hard":
				return GeneratorType.hard;
				
			case "badXp":
				return GeneratorType.badXp;
			
			case "goodXp":
				return GeneratorType.goodXp;
				
			case "soul":
				return GeneratorType.soul;
				
			case "intern":
				return GeneratorType.intern;
				
			case "buildResourceFromHell":
			return GeneratorType.buildResourceFromHell;
			
			case "buildResourceFromParadise":
			return GeneratorType.buildResourceFromParadise;
				
			default:
				return null;
		}
	}
	
	
	public static function getResourcesData():ResourcesData{
		return myResourcesData;
	 
	}
	
	private static function save(pGenerator:Generator):Void{
		var myArray:Array<Generator> = myResourcesData.generatorsMap[pGenerator.desc.type];
		
		myArray[myArray.indexOf(pGenerator)] = pGenerator;
		myResourcesData.generatorsMap[pGenerator.desc.type] = myArray;
	
		SaveManager.save();
	}
	//}endregion

	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for add soft, hard currency, or xp in there own array
	//{ ################# addCurrency #################
	
	public static function addResourcesGenerator(pId:Int, pType:GeneratorType, pMax:Int, ?pAlignment:Alignment):Generator{
		
		var myDesc:GeneratorDescription = getGenerator(pId, pType), myGenerator:Generator;
		
		if (myDesc != null){
			
			return {desc:myDesc};
		}
		
		
		myDesc = {
			quantity: 0,
			max: pMax,
			id: pId,
			type:pType
		};
		
		
		if (pAlignment != null) myDesc.alignment = pAlignment;
		
		myGenerator = {desc:myDesc};
		myResourcesData.generatorsMap[pType].push(myGenerator);
		
		
		
		SaveManager.save();
		
		TimeManager.createTimeResource(1, myGenerator);
		
		return myGenerator;
		
	}
	
	//test if a generator with this id exist and return the generator
	public static function getGenerator(pId:Int, pType:GeneratorType):GeneratorDescription{
		var resourcesArray:Array<Generator> = myResourcesData.generatorsMap[pType];
		var lLength:Int = resourcesArray.length, i;
		
		for (i in 0...lLength) if (resourcesArray[i].desc.id == pId) return resourcesArray[i].desc;
		
		return null;
	}
	//} endregion
	
	
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for change alignment of soul or intern
	//{ ################# changeAlignment #################
	
	private static function changeAlignment(pGenerator:Generator, pAlignment:Alignment):Void {
		pGenerator.desc.alignment = pAlignment;
		save(pGenerator);
		
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for count a resource if her value is lower her max
	//{ ################# increaseResources #################
	
	private static function increaseResources(pGenerator:Generator):Void{
		
		pGenerator.desc.quantity = Math.min(pGenerator.desc.quantity + 1, pGenerator.desc.max);		
		save(pGenerator);
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for remove a resource in is own array
	//{ ################# removeGenerator #################

	
	public static function removeGenerator(pGenerator:Generator):Void{
		
		TimeManager.removeTimeResource(pGenerator.desc.id);
		
		var myArray:Array<Generator> = myResourcesData.generatorsMap[pGenerator.desc.type];
		
		myArray.splice(myArray.indexOf(pGenerator), 1);
		
		myResourcesData.generatorsMap[pGenerator.desc.type] = myArray;
		SaveManager.save();
	}
	//} endregion
	

	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for use or add total resources
	//{ ################# totals function #################
	
	//{ ################# sum #################
	
	public static function takeResources(pDesc:GeneratorDescription):GeneratorDescription {
		
		myResourcesData.totalsMap[pDesc.type] += pDesc.quantity;
		pDesc.quantity = 0;
		trace(myResourcesData.totalsMap[pDesc.type]);

		SaveManager.save();
		
		return pDesc;
	}

	//} endregion
	

	public static function spendTotal(pType:GeneratorType, spendValue:Int):Void{
		myResourcesData.totalsMap[pType] -= spendValue;
		SaveManager.save();
	}
	
	public static function levelUp():Void{
		myResourcesData.totalsMap[GeneratorType.badXp] = 0;
		myResourcesData.totalsMap[GeneratorType.goodXp]= 0;
		
		myResourcesData.level++;
		SaveManager.save();
	}

	
	
	//} endregion
	
}