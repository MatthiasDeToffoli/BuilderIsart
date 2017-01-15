package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.ResourcesGeneratorDescription;
import com.isartdigital.perle.game.managers.TimeManager.EventResoucreTick;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import com.isartdigital.perle.ui.hud.Hud;
import eventemitter3.EventEmitter;

 
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
 
 
 typedef Population = {
	@:optional var buildingRef:Int;
	 var quantity:Int;
	 var max:Int;
 }
 
 /**
  * Information send to actualise ui view
  */
 typedef TotalResourcesEventParam = {
	 var value:Float;
	 var isLevel:Bool;
	 @:optional var max:Float;
	 @:optional var type:GeneratorType;
 }
 
 /**
  * the total of all populations
  */
 typedef TotalPopulations = {
	 var heaven:Population;
	 var hell:Population;
 }
 
 /**
  * typedef which contain Generator informations
  */
 typedef Generator = {
	 var desc:GeneratorDescription;
 }
 //} endregion
 
 /**
 * manage all resources, generator and levels
 * @author de Toffoli Matthias
 */
class ResourcesManager
{
	/**
	 * Event call when a quantity is increase or when we took element
	 */
	public static var generatorEvent:EventEmitter;
	public static var totalResourcesEvent:EventEmitter;
	public static var populationChangementEvent:EventEmitter;
	public static var soulArrivedEvent:EventEmitter;
	/**
	 * name of the event
	 */
	public static inline var GENERATOR_EVENT_NAME:String = "GENERATOR";
	public static inline var TOTAL_RESOURCES_EVENT_NAME:String = "TOTAL RESOURCES";
	public static inline var POPULATION_CHANGEMENT_EVENT_NAME:String = "POPULATION";
	public static inline var SOUL_ARRIVED_EVENT_NAME:String = "SOUL_ARRIVED";
	
	private static var maxExp:Float;
	
	private static var allPopulations:Map<Alignment,Array<Population>>;
	
	
	/**
	 * 
	 */
	private static var totalResourcesInfoArray:Array<TotalResourcesEventParam>;
	
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
	 * initialise variable
	 */
	public static function awake():Void{
		generatorEvent = new EventEmitter();
		totalResourcesEvent = new EventEmitter();
		populationChangementEvent = new EventEmitter();
		soulArrivedEvent = new EventEmitter();
		totalResourcesInfoArray = [
		{value: 1, isLevel: true},
		{value: 0, isLevel: false, type: GeneratorType.soft },
		{value: 0, isLevel: false, type: GeneratorType.hard},
		{value: 0, isLevel: false, type: GeneratorType.goodXp},
		{value: 0, isLevel: false, type: GeneratorType.badXp},
		{value: 0, isLevel: false, type: GeneratorType.soulGood},
		{value: 0, isLevel: false, type: GeneratorType.soulBad},
		{value: 0, isLevel: false, type: GeneratorType.buildResourceFromHell},
		{value: 0, isLevel: false, type: GeneratorType.buildResourceFromParadise},
		];
		
		allPopulations = new Map<Alignment,Array<Population>>();
		
		allPopulations[Alignment.heaven] = new Array<Population>();
		allPopulations[Alignment.hell] = new Array<Population>();
	}
	/**
	 * init all element of the resources data
	 */
	public static function initWithoutSave():Void{
		
		var pMapG:Map<GeneratorType,Array<Generator>> = new Map<GeneratorType,Array<Generator>>();
		var pMapT:Map<GeneratorType,Float> = new Map<GeneratorType,Float>();
		var i:Int;
		
		pMapG[GeneratorType.soul] = new Array<Generator>();
		pMapT[GeneratorType.soulGood] = 0;
		pMapT[GeneratorType.soulBad] = 0;
		
		pMapG[GeneratorType.soft] = new Array<Generator>();
		pMapT[GeneratorType.soft] = 20000;

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
			level: 1
		}
		
		maxExp = ExperienceManager.getMaxExp(1);
		
		totalResourcesInfoArray[3].max = maxExp;
		totalResourcesInfoArray[4].max = maxExp;
		
		totalResourcesEvent.emit(TOTAL_RESOURCES_EVENT_NAME, totalResourcesInfoArray);
		TimeManager.eTimeGenerator.on(TimeManager.EVENT_RESOURCE_TICK, increaseResourcesWithTime);
		
		//todo : a enlever apres alpha je pense, c'est pour avoir des ressources au debut
		Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[GeneratorType.soft], false, GeneratorType.soft);
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
		
		var totals:Array<Float> = resourcesDescriptionLoad.totals;
		myResourcesData.level = resourcesDescriptionLoad.level;
		myResourcesData.totalsMap[GeneratorType.soft] = totals[0];
		myResourcesData.totalsMap[GeneratorType.hard] = totals[1];
		myResourcesData.totalsMap[GeneratorType.goodXp] = totals[2];
		myResourcesData.totalsMap[GeneratorType.badXp] = totals[3];
		myResourcesData.totalsMap[GeneratorType.soulGood] = totals[4];
		myResourcesData.totalsMap[GeneratorType.soulBad] = totals[5];
		myResourcesData.totalsMap[GeneratorType.intern] = totals[6];
		myResourcesData.totalsMap[GeneratorType.buildResourceFromHell] = totals[7];
		myResourcesData.totalsMap[GeneratorType.buildResourceFromParadise] = totals[8];
		
		maxExp = ExperienceManager.getMaxExp(resourcesDescriptionLoad.level);
		
		var i:Int;

		for (i in 0...totalResourcesInfoArray.length){
			if (i == 0) totalResourcesInfoArray[i].value = resourcesDescriptionLoad.level;
			else if (i < 7) totalResourcesInfoArray[i].value = totals[i - 1];
			else totalResourcesInfoArray[i].value = totals[i];
			
			if (i == 3 || i == 4) totalResourcesInfoArray[i].max = maxExp;
		}
		
		totalResourcesEvent.emit(TOTAL_RESOURCES_EVENT_NAME, totalResourcesInfoArray);
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
	
	public static function getTotalForType (pType:GeneratorType):Float {
		return myResourcesData.totalsMap[pType];
	}
	
	/**
	 * get the current level
	 * @return the level
	 */
	public static function getLevel():Float{
		return myResourcesData.level;
	}
	
	/**
	 * add a new population in a building
	 * @param	pQuantity the number of soul building has
	 * @param	pMax the max of soul building can has
	 * @param	pType the type of building
	 * @param	pRef the id of building
	 * @return
	 */
	public static function addPopulation(pQuantity:Int, pMax:Int, pType:Alignment, pRef:Int):Population{
		var newPopulation = {quantity:pQuantity, max:pMax, buildingRef:pRef};
		allPopulations[pType].push(newPopulation);

		return newPopulation;
		
	}
	
	/**
	 * update a population information
	 * @param	pPopulation the population we want update
	 * @param	pType the type of building
	 */
	public static function updatePopulation(pPopulation:Population,pType:Alignment):Void{
		allPopulations[pType][allPopulations[pType].indexOf(pPopulation)] = pPopulation;
	}
	

	
	/**
	 * give the total of soul we have (and the total we can have
	 * @return all soul we have (except neutral) and all we can have
	 */
	public static function getTotalAllPopulations():TotalPopulations{
		var myTotalAllPopulation:TotalPopulations = {heaven:{quantity:0,max:0},hell:{quantity:0,max:0}};
		
		myTotalAllPopulation.heaven = getTotalPopuLation(Alignment.heaven);
		myTotalAllPopulation.hell = getTotalPopuLation(Alignment.hell);
		
		return myTotalAllPopulation;
	}
	
	/**
	 * give the total of hell or heaven
	 * @param	pType the type we want
	 * @return the population of this type
	 */
	private static function getTotalPopuLation(pType:Alignment):Population{
		var myTotal:Population = {quantity:0, max:0};
		var myPop:Population;
		
		for (myPop in allPopulations[pType]){
			myTotal.max += myPop.max;
			myTotal.quantity += myPop.quantity;
		}
		
		return myTotal;
	}
	
	/**
	 * give all population we can have and we have which not placed in a house
	 * @return population not placed in a house
	 */
	public static function getTotalNeutralPopulation():Population{
		
		var myGenerator:Generator;
		var myTotal:Population = {quantity:0, max:0};
		
		for (myGenerator in myResourcesData.generatorsMap[GeneratorType.soul]){
			myTotal.quantity += Std.int(myGenerator.desc.quantity);
			myTotal.max = myGenerator.desc.max;
		}
		
		return myTotal;
	}
	
	/**
	 * place a soul in a house
	 * @param	pType this help to choos where we want to place soul
	 */
	public static function judgePopulation(pType:Alignment):Void{
		var lPopulation:Population, lGenerator:Generator;
		
		for (lGenerator in myResourcesData.generatorsMap[GeneratorType.soul])
			if(lGenerator.desc.quantity > 0)
				for (lPopulation in allPopulations[pType])
					if (lPopulation.max > lPopulation.quantity){
						lPopulation.quantity++;
						lGenerator.desc.quantity--;
						populationChangementEvent.emit(POPULATION_CHANGEMENT_EVENT_NAME, lPopulation);
						generatorEvent.emit(GENERATOR_EVENT_NAME, {id:lGenerator.desc.id});
					}
		
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
		
		TimeManager.createTimeResource(6000, myGenerator); // 1 minutes
		
		return myGenerator;
		
	}
	
	/**
	 * update the value of the resourcesGenerator
	 * @param	pGenerator the generator to update
	 * @param	pMax the capacity of the generator
	 * @return the generator which is update
	 */
	public static function UpdateResourcesGenerator(pGenerator:Generator, pMax:Int,pEnd:Float):Generator{
		pGenerator.desc.max = pMax;
		myResourcesData.generatorsMap[pGenerator.desc.type][myResourcesData.generatorsMap[pGenerator.desc.type].indexOf(pGenerator)] = pGenerator;
		TimeManager.updateTimeResource(pEnd, pGenerator);
		return pGenerator;
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

		for (i in 0...lLength){
			if (resourcesArray[i].desc.id == pId) return resourcesArray[i].desc;
		}
		
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
	 * increase a generator's quantity link to the time
	 * @param data the object contain the generator and the time link
	 */
	private static function increaseResourcesWithTime(data:EventResoucreTick):Void{
		if (data != null){
			if (increaseResourcesWithPolation(Alignment.heaven, data)) return;
			if (increaseResourcesWithPolation(Alignment.hell, data)) return;
			increaseResources(data.generator, data.tickNumber);
		}
		
	}	
		 
	 /**
	  * check if the building have a population and change value of gain in function of that
	  * @param	pType the type of building we want check
	  * @param	data data the object contain the generator and the time link
	  * @return if the fonction found a population link to this generator
	  */
	private static function increaseResourcesWithPolation(pType:Alignment, data:EventResoucreTick):Bool{
		var myPopulation:Population;
			
		for (myPopulation in allPopulations[pType])
			if (myPopulation.buildingRef == data.generator.desc.id){
				increaseResources(data.generator, data.tickNumber * myPopulation.quantity);
				return true;
			}
			
		return false;
	}
	
	/**
	 * increase a generator's quantity by a value
	 * @param pGenerator the generator target
	 * @param quantity the quantity to add
	 */
	public static function increaseResources(pGenerator:Generator, quantity:Float):Void{
		pGenerator.desc.quantity = Math.min(pGenerator.desc.quantity + quantity, pGenerator.desc.max);		
		save(pGenerator);
		
		if (pGenerator.desc.quantity >= pGenerator.desc.max / 2) generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pGenerator.desc.id, forButton:true, active:true});
		else generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pGenerator.desc.id});
		if(pGenerator.desc.type == GeneratorType.soul) soulArrivedEvent.emit(SOUL_ARRIVED_EVENT_NAME);
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
	public static function takeResources(pDesc:GeneratorDescription, ?pMax:Float):GeneratorDescription {
		
		if (pDesc.type == GeneratorType.goodXp || pDesc.type == GeneratorType.badXp) takeXp(pDesc.quantity, pDesc.type);
		else{
			myResourcesData.totalsMap[pDesc.type] = pMax != null ? 
			Math.min(pMax, myResourcesData.totalsMap[pDesc.type] + pDesc.quantity) : 
			myResourcesData.totalsMap[pDesc.type] + pDesc.quantity;
			Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pDesc.type], false, pDesc.type);
		}
			
		pDesc.quantity = 0;
		

		SaveManager.save();
		generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pDesc.id, active:false, forButton:true});
		return pDesc;
	}
	
	/**
	 * add a generator's quantity to the total xp coresponding if quantity lower than maxExp (if two xp are full call levelUp)
	 * @param	quantity the quantity to add
	 * @param	pType the type of xp
	 */
	public static function takeXp(quantity:Float, pType:GeneratorType):Void{
		myResourcesData.totalsMap[pType] = Math.min(myResourcesData.totalsMap[pType] + quantity, maxExp);
		
		Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType,maxExp);
		Hud.getInstance().setXpGauge(pType, quantity);
		testLevelUp();
		SaveManager.save();
	}
	
	/**
	 * add a quantity to the total coresponding
	 * @param	pType the type of the total resources we want to increase
	 * @param	quantity the quantity to add
	 */
	public static function gainResources(pType:GeneratorType, quantity:Float):Void{
		
		myResourcesData.totalsMap[pType] += quantity;

		
		if (pType == GeneratorType.goodXp || pType == GeneratorType.badXp){
			myResourcesData.totalsMap[pType]  = Math.min(myResourcesData.totalsMap[pType], maxExp);
			Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType,maxExp);
			testLevelUp();
		} else {
			 Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType);
		}
		
		SaveManager.save();
	}
	
	/**
	 * test if we level up
	 */
	private static function testLevelUp():Void{
		if (myResourcesData.totalsMap[GeneratorType.badXp] == maxExp && myResourcesData.totalsMap[GeneratorType.goodXp] == maxExp){
			Hud.getInstance().initGauges();
			levelUp();
		}
	}
	
	
	/**
	 * spend a certain value of a total coresponding
	 * @param pType the type of the total we want spend
	 * @param spendValue the value we want spend
	 */
	public static function spendTotal(pType:GeneratorType, spendValue:Int):Void{
		myResourcesData.totalsMap[pType] -= spendValue;
		
		Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType);
		
		SaveManager.save();
	}
	
	/**
	 * increase level and reset good and bad xp
	 */
	public static function levelUp():Void{
		myResourcesData.totalsMap[GeneratorType.badXp] = 0;
		myResourcesData.totalsMap[GeneratorType.goodXp]= 0;
		
		myResourcesData.level++;
		maxExp = ExperienceManager.getMaxExp(myResourcesData.level);
		UnlockManager.unlockItem();
		Hud.getInstance().setAllTextValues(0, false, GeneratorType.badXp,maxExp);
		Hud.getInstance().setAllTextValues(0, false, GeneratorType.goodXp,maxExp);
		Hud.getInstance().setAllTextValues(myResourcesData.level, true);
		
		SaveManager.save();
	}

	
	
	//} endregion
	
}