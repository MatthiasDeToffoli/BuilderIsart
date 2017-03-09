package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.ResourcesGeneratorDescription;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.managers.TimeManager.EventResoucreTick;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.sounds.SoundManager;
import eventemitter3.EventEmitter;
import haxe.Json;

 
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
		pMapT[GeneratorType.soft] = 0;

		pMapG[GeneratorType.hard] = new Array<Generator>();
		pMapT[GeneratorType.hard] = 0; //@ToDo Temporaire, juste pour avoir des ressources au début
		
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
	}
	
	/**
	 * load all element of the resources data
	 * @param resourcesDescriptionLoad the resources description which is load
	 * @author Ambroise && Matthias
	 */
	public static function initWithLoad(resourcesDescriptionLoad:ResourcesGeneratorDescription):Void{
		for (key in resourcesDescriptionLoad.totals.keys()) {
			if (Std.is(key, String)) {
				Debug.error("This value should be an Enum (update stringToEnum please) : " + key);
			}
		}
		for (i in 0...resourcesDescriptionLoad.arrayGenerator.length) {
			if (Std.is(resourcesDescriptionLoad.arrayGenerator[i].alignment, String) ||
				Std.is(resourcesDescriptionLoad.arrayGenerator[i].type, String)) {
				Debug.error(
					"This value should be an Enum (update stringToEnum please) : " + 
					resourcesDescriptionLoad.arrayGenerator[i].alignment + " " +
					resourcesDescriptionLoad.arrayGenerator[i].type
				);
			}
		}
		
		initWithoutSave();
		
		var myDesc:GeneratorDescription;
		var myGenerator:Generator;
		
		
		for (myDesc in resourcesDescriptionLoad.arrayGenerator) {
			myGenerator = { desc:myDesc };
			myResourcesData.generatorsMap[myDesc.type].push(myGenerator);
			TimeManager.addGenerator(myGenerator);
		}
		
		myResourcesData.level = resourcesDescriptionLoad.level;
		myResourcesData.totalsMap = resourcesDescriptionLoad.totals;
		maxExp = ExperienceManager.getMaxExp(resourcesDescriptionLoad.level);
		
		// setting level
		totalResourcesInfoArray[0].value = resourcesDescriptionLoad.level;
		
		var i:Int;
		for (i in 1...totalResourcesInfoArray.length) {
			// avoid putting null instead of 0 in value field
			// avoid having cast error
			// those fields are to be removed (said @MatthiasDeToffoli)
			if (totalResourcesInfoArray[i].type == GeneratorType.soulBad ||
				totalResourcesInfoArray[i].type == GeneratorType.soulGood)
				continue;
				
			totalResourcesInfoArray[i].value = myResourcesData.totalsMap[totalResourcesInfoArray[i].type];
			
			// adding maxExp field to GeneratorType.goodXp and GeneratorType.badXp
			if (i == 3 || i == 4) 
				totalResourcesInfoArray[i].max = maxExp;
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
	public static function updatePopulation(pPopulation:Population, pType:Alignment):Void{
		var i:Int, l:Int = allPopulations[pType].length;
		
		for (i in 0...l) {
			if (allPopulations[pType][i].buildingRef == pPopulation.buildingRef){
				allPopulations[pType][i] = pPopulation;
				return;
			}
		}
	}
	
	public static function removePopulation(pType:Alignment,pPopulation:Population):Void {
		allPopulations[pType].splice(allPopulations[pType].indexOf(pPopulation),1);
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
			myTotal.max = Std.int(myGenerator.desc.max);
		}
		
		return myTotal;
	}
	
	/**
	 * place a soul in a house
	 * @param	pType this help to choos where we want to place soul
	 */
	public static function judgePopulation(pType:Alignment):Bool{
		var lPopulation:Population, lGenerator:Generator;
		
		for (lGenerator in myResourcesData.generatorsMap[GeneratorType.soul])
			if(lGenerator.desc.quantity > 0)
				for (lPopulation in allPopulations[pType])
					if (lPopulation.max > lPopulation.quantity){
						lPopulation.quantity++;
						lGenerator.desc.quantity--;
						emitPopulationChangementEvent(lPopulation);
						generatorEvent.emit(GENERATOR_EVENT_NAME, { id:lGenerator.desc.id } );
						return true;
					}
		
		return false;
	}
	
	public static function emitPopulationChangementEvent(pPopulation:Population):Void {
		populationChangementEvent.emit(POPULATION_CHANGEMENT_EVENT_NAME, pPopulation);
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

	
	/**
	 * create a new generator
	 * @param pId the id of the generator to add
	 * @param pType the type of the generator to add
	 * @param pMax the max of the generator to add
	 * @param pAlignment (optional) the alignment of the generator to add
	 * @return the generator added
	 */
	public static function addResourcesGenerator(pId:Int, pType:GeneratorType, pMax:Float, pTime:Float, ?pAlignment:Alignment, ?isTribunal:Bool):Generator{
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
		
		if (isTribunal) myDesc.quantity = myDesc.max;
		
		if (pAlignment != null) myDesc.alignment = pAlignment;
		
		myGenerator = {desc:myDesc};
		myResourcesData.generatorsMap[pType].push(myGenerator);
		
		SaveManager.save();

		TimeManager.createTimeResource(pTime, myGenerator);
		ServerManagerBuilding.createGenerator(pId);
		return myGenerator;
		
	}
	
	/**
	 * update the value of the resourcesGenerator
	 * @param	pGenerator the generator to update
	 * @param	pMax the capacity of the generator
	 * @param isFullTime boolean said if we have to calcul a new time with pEnd or if we use this simply
	 * @return the generator which is update
	 */
	public static function UpdateResourcesGenerator(pGenerator:Generator, pMax:Float, pEnd:Float, isFullTime:Bool):Generator{
		pGenerator.desc.max = pMax;
		myResourcesData.generatorsMap[pGenerator.desc.type][myResourcesData.generatorsMap[pGenerator.desc.type].indexOf(pGenerator)] = pGenerator;
		TimeManager.updateTimeResource(pEnd, pGenerator.desc.id, isFullTime);
		return pGenerator;
	}
	
	/**
	 * replace a resourcesGenerator
	 * @param	pGenerator the generator to add
	 * @return the generator which is update
	 */
	public static function replaceResourcesGenerator(pGenerator:Generator):Void{
		var myArray:Array<Generator> = myResourcesData.generatorsMap[pGenerator.desc.type];
		var i:Int, l:Int = myArray.length;
		
			
		for (i in 0...l) {
			if (myArray[i].desc.id == pGenerator.desc.id){
				myResourcesData.generatorsMap[pGenerator.desc.type][i] = pGenerator;
				return;
			}
		}
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
	
	/**
	 * change the alignment of a generator
	 * @param pGenerator the generator target
	 * @param pAlignment the alignment wanted
	 */
	private static function changeAlignment(pGenerator:Generator, pAlignment:Alignment):Void {
		pGenerator.desc.alignment = pAlignment;
		save(pGenerator);
		
	}
	
	/**
	 * increase a generator's quantity link to the time
	 * @param data the object contain the generator and the time link
	 */
	private static function increaseResourcesWithTime(data:EventResoucreTick):Void{
		if (data != null){
			/*if (increaseResourcesWithPolation(Alignment.heaven, data)) return;
			if (increaseResourcesWithPolation(Alignment.hell, data)) return;*/ //times calcul with population so we use population 2 times
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
		if (data.generator == null) return false;	
		
		for (myPopulation in allPopulations[pType])
			if (myPopulation.buildingRef == data.generator.desc.id) {	
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
	public static function increaseResources(pGenerator:Generator, quantity:Float, ?force:Bool = false):Void{
		if (pGenerator == null) return;
		
		if (!force) pGenerator.desc.quantity = Math.min(pGenerator.desc.quantity + quantity, pGenerator.desc.max);
		else pGenerator.desc.quantity = pGenerator.desc.quantity + quantity;
		save(pGenerator);
		
		if (pGenerator.desc.quantity >= pGenerator.desc.max / 4) generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pGenerator.desc.id, forButton:true, active:true});
		else generatorEvent.emit(GENERATOR_EVENT_NAME, {id:pGenerator.desc.id});
		if(pGenerator.desc.type == GeneratorType.soul) soulArrivedEvent.emit(SOUL_ARRIVED_EVENT_NAME);
	}
	
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
	
	/**
	 * To shorten any value given in parameter (ex: 10 000 > 10k or 100 000 000 > 100M)
	 * @author COQUERELLE Killian
	 * @param pFLoat the value you want to shorten
	 * @return the value shortened
	 */
	public static function shortenValue (pFloat:Float):String {
		var suffix:String = "";
		if (pFloat >= 1000000) {
			pFloat /= 100000;
			pFloat = Math.floor(pFloat);
			pFloat /=10;
			suffix = "M";
		}
		else if (pFloat >= 10000) {
			pFloat /= 100;
			pFloat = Math.floor(pFloat);
			pFloat /= 10;
			suffix = "k";
		}
		/*else if (pFloat >= 1000) {
			var prefix:Float = pFloat/1000;
			prefix = Math.floor(prefix);
			suffix = Std.string(pFloat - prefix*1000);
			return Std.string(prefix + " " + suffix);
		}*/
		return Std.string(pFloat + suffix);
	}
	
	/**
	 * add a generator's quantity to the total coresponding and reset the quantity at 0
	 * @param pDesc the description of the generator target
	 * @return the description modified
	 */
	public static function takeResources(pDesc:GeneratorDescription, ?pMax:Float):GeneratorDescription {
		
		if (pDesc.type == GeneratorType.goodXp || pDesc.type == GeneratorType.badXp) takeXp(pDesc.quantity, pDesc.type);
		else{
			/*myResourcesData.totalsMap[pDesc.type] = pMax != null ? 
			Math.min(pMax, myResourcesData.totalsMap[pDesc.type] + pDesc.quantity) : 
			myResourcesData.totalsMap[pDesc.type] + pDesc.quantity;*/
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
		
		SoundManager.getSound("SOUND_XP").play();
		
		Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType,maxExp);
		Hud.getInstance().setXpGauge();
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
	
	public static function updateTotal(pType:GeneratorType, pQuantity:Float):Void {
		myResourcesData.totalsMap[pType] = pQuantity;
		
		if (pType == GeneratorType.goodXp || pType == GeneratorType.badXp){
			myResourcesData.totalsMap[pType]  = Math.min(myResourcesData.totalsMap[pType], maxExp);
			Hud.getInstance().setXpGauge();
			testLevelUp();
		} else {
			 Hud.getInstance().setAllTextValues(myResourcesData.totalsMap[pType], false, pType);
		}
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

	public static function setLevel(pLevel:Int):Void {
		myResourcesData.level = pLevel;
		Hud.getInstance().setAllTextValues(myResourcesData.level, true);
	}
	
}