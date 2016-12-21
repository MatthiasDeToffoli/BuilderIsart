package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.ResourcesGeneratorDescription;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import eventemitter3.EventEmitter;
import haxe.rtti.CType.Typedef;

/**
 * ...
 * @author de Toffoli Matthias
 */

 /**
  * manage all resources, generator and levels
  */
 
 //{ ################# typedef #################
 
 /**
  * typedef which contain all data resources
  */
 typedef ResourcesData = {
	 //Array that represents the on going ressources of each buildings
	var  generatorsMap:Map<GeneratorType,Array<Generator>>;
	
	//Total value of some resources
	var totalsMap:Map<GeneratorType,Float>;
	
	//level
	var level:Int;
	
 }
 
 /**
  * typedef which contain Generator informations
  */
 typedef Generator = {
	 var desc:GeneratorDescription;
 }
 //} endregion
 
class ResourcesManager
{
	/**
	 * Event call when a quantity is increase or when we took element
	 */
	public static var generatorEvent:EventEmitter = new EventEmitter();
	/**
	 * name of the event
	 */
	public static inline var GENERATOR_EVENT_NAME:String = "GENERATOR";
	
	/*
	 ####################
	 ####################
	 ####################
	 */
 
	//function and var rapport to data
	 //{ ################# data #################
	 /**
	  * data local to the class
	  */
	private static var myResourcesData:ResourcesData;
	
	/**
	 * init all element of the resources data
	 */
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
		
		TimeManager.eTimeGenerator.on(TimeManager.EVENT_RESOURCE_TICK, increaseResourcesByOne);
	}
	
	/**
	 * load all element of the resources data
	 * @param resourcesDescriptionLoad the resources description which is load
	 */
	public static function initWithLoad(resourcesDescriptionLoad:ResourcesGeneratorDescription):Void{

		initWithoutSave();
		
		var myDesc:GeneratorDescription;
		var myGenerator:Generator;
		
		for (myDesc in resourcesDescriptionLoad.arrayGenerator){
			myDesc.type = SaveManager.translateArrayToEnum(myDesc.type);
			myDesc.alignment = SaveManager.translateArrayToEnum(myDesc.alignment);
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
	
	/**
	 * say if the generator give is not empty
	 * @param pDesc the description of generator which we want test
	 * @return if the generator is empty or not
	 */
	public static function GeneratorIsNotEmpty(pDesc:GeneratorDescription):Bool{
		return pDesc.quantity > 0;
	}
	
	/**
	 * give the resources dara
	 * @return ResourcesData
	 */
	public static function getResourcesData():ResourcesData{
		return myResourcesData;
	 
	}
	
	/**
	 * actualise and save the data
	 * @param pGenerator the generator we want save
	 */
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
	
	/**
	 * create a new generator
	 * @param pId the id of the generator to add
	 * @param pType the type of the generator to add
	 * @param pMax the max of the generator to add
	 * @param pAlignment (optional) the alignment of the generator to add
	 * @return the generator added
	 */
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
	
	/**
	 * test if a generator with this id exist and return the generator
	 * @param pId the id of the generator tested
	 * @param pType the type of the generator tested
	 * @return null if don't find the generator else the description of the generator
	 */
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
	
	/**
	 * change the alignment of a generator
	 * @param pGenerator the generator target
	 * @param pAlignment the alignment wanted
	 */
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
	
	/**
	 * increase a generator's quantity by one
	 * @param pGenerator the generator target
	 */
	private static function increaseResourcesByOne(pGenerator:Generator):Void{
		if(pGenerator != null) increaseResources(pGenerator, 1);
	}
	
	/**
	 * increase a generator's quantity by a value
	 * @param pGenerator the generator target
	 * @param quantity the quantity to add
	 */
	public static function increaseResources(pGenerator:Generator, quantity:Float):Void{	
		pGenerator.desc.quantity = Math.min(pGenerator.desc.quantity + quantity, pGenerator.desc.max);		
		save(pGenerator);
		generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pGenerator.desc.id, active:true});
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for remove a resource in is own array
	//{ ################# removeGenerator #################

	/**
	 * remove a generator
	 * @param pGenerator generator target
	 */
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
	/**
	 * add a generator's quantity to the total coresponding and reset the quantity at 0
	 * @param pDesc the description of the generator target
	 * @return the description modified
	 */
	public static function takeResources(pDesc:GeneratorDescription):GeneratorDescription {
		
		myResourcesData.totalsMap[pDesc.type] += pDesc.quantity;
		pDesc.quantity = 0;
		trace(myResourcesData.totalsMap[pDesc.type]);

		SaveManager.save();
		generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pDesc.id, active:false});
		return pDesc;
	}
	
	
	/**
	 * spend a certain value of a total coresponding
	 * @param pType the type of the total we want spend
	 * @param spendValue the value we want spend
	 */
	public static function spendTotal(pType:GeneratorType, spendValue:Int):Void{
		myResourcesData.totalsMap[pType] -= spendValue;
		SaveManager.save();
	}
	
	/**
	 * increase level and reset good and bad xp
	 */
	public static function levelUp():Void{
		myResourcesData.totalsMap[GeneratorType.badXp] = 0;
		myResourcesData.totalsMap[GeneratorType.goodXp]= 0;
		
		myResourcesData.level++;
		SaveManager.save();
	}

	
	
	//} endregion
	
}