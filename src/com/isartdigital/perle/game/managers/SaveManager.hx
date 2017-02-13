package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.ResourcesManager.ResourcesData;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.Hud;
import haxe.Json;
import js.Browser;


//@:optional vous connaisiez ?

enum GeneratorType { soft; hard; goodXp; badXp; soul; soulGood; soulBad; intern; buildResourceFromHell; buildResourceFromParadise; isartPoint; }
enum Alignment {neutral; hell; heaven; }


typedef TileDescription = {
	var buildingName:String; // sûr ? pose problème si on change l'assetName non ?
	var id:Int;
	var regionX:Int;
	var regionY:Int;
	var mapX:Int;
	var mapY:Int;
	var level:Int;
	@:optional var currentPopulation:Int;
	@:optional var maxPopulation:Int;
	@:optional var timeDesc:TimeDescription;
	@:optional var isTribunal:Bool;
	@:optional var intern:InternDescription;
}

typedef RegionDescription = {
	var x:Int;
	var y:Int;
	var type:Alignment;
	var firstTilePos:Index;
}

typedef TimeDescription = {
	var refTile:Int; // l'id du bâtiment auquel il est associé
	var progress:Float; // stock date.now a chaque appelle de la loo
	var end:Float; // date de fin de construction
	@:optional var timeBoost:Float;
	@:optional var creationDate:Float;
	@:optional var gain:Int;
}

typedef CampaignDescription = {
	var end:Float;
	var type:String;
}

typedef TimeQuestDescription = {
	var refIntern:Int;
	var progress:Float;
	var steps:Array<Float>;
	var stepIndex:Int;
	var creation:Float;
	var end:Float;
}

//typedef AllTimeQuestDescription = {
	//var arrayQuests:Array<TimeQuestDescription>;
//}

typedef GeneratorDescription = {
	var type:GeneratorType;
	var quantity:Float;
	var max:Float;
	var id:Int;
	@:optional var alignment:Alignment;
	
}

// typedef for intern i use this for prepare the ui
typedef InternDescription = {
	var id:Int; 		// for link with quest i think
	var name:String;
	//var isInQuest:Bool;
	//var avatar: Sprite; //Todo: type à revoir
	var aligment:String; //Todo:type à changer?
	var status:String; //Depends of what he's doing
	var quest:TimeQuestDescription;	//Linked quest Todo: à enlever peut-être
	var price:Int; //Price of the intern
	//Stats of the intern
	var stress:Int;
	var speed:Int;
	var efficiency:Int;
	var unlockLevel:Int;
	var idEvent:Int;
	var portrait:String;
}

typedef ResourcesGeneratorDescription = {
	var arrayGenerator:Array<GeneratorDescription>;
	var totals:Array<Float>;
	var level:Int;
}
typedef ResourceDescription = {
	var refTile:Int;
}

/**
 * Usefull for everything that is used for statistics only.
 */
typedef Stats = {
	var gameStartTime:Float;
}

// On save des TileDescription, pas des Virtual !
typedef Save = {
	var version:String;
	var COL_X_LENGTH:Int;
	var ROW_Y_LENGTH:Int;
	var stats:Stats;
	var idHightest:Int;
	var region:Array<RegionDescription>;
	var ground:Array<TileDescription>;
	var building:Array<TileDescription>;
	var timesResource:Array<TimeDescription>;
	var timesQuest:Array<TimeQuestDescription>;
	var timesConstruction:Array<TimeDescription>;
	var timesProduction:Array<TimeDescription>;
	var timesCampaign:CampaignDescription;
	var lastKnowTime:Float;
	var resourcesData:ResourcesGeneratorDescription;
	var ftueProgress:Int;
	// add what you want to save.
}

/**
 * ...
 * @author tout le monde
 */
class SaveManager {
	private static inline var SAVE_NAME:String = "com_isartdigital_perle";
	private static inline var SAVE_VERSION:String = "1.1.3";
	public static var currentSave(default, null):Save;
	
	/**
	 * Save the buildings and grounds in a Json in local storage.
	 * Use virtualCell to make the save.
	 */
	public static function save():Void { // todo ajouter la possibilité de save qu'une partie pour perf
		var buildingSave:Array<TileDescription> = [];
		var groundSave:Array<TileDescription> = [];
		var regionSave:Array<RegionDescription> = [];
		var itemUnlock:Array<Array<Array<String>>> = [];
		
		
		// factoriser
		for (regionX in RegionManager.worldMap.keys()) {
			for (regionY in RegionManager.worldMap[regionX].keys()) {
				
				regionSave.push(RegionManager.worldMap[regionX][regionY].desc);
				
				for (x in RegionManager.worldMap[regionX][regionY].building.keys()) {
					for (y in RegionManager.worldMap[regionX][regionY].building[x].keys()) {
						buildingSave.push(RegionManager.worldMap[regionX][regionY].building[x][y].tileDesc);
					}
				}
					
				for (x in RegionManager.worldMap[regionX][regionY].ground.keys()) {
					for (y in RegionManager.worldMap[regionX][regionY].ground[x].keys()) {
						
						groundSave.push(RegionManager.worldMap[regionX][regionY].ground[x][y].tileDesc);
					}
				}
			}
		}
		
		// todo : dans le même ordre que les variables !
		currentSave = {
			timesResource: getTimesResource(),
			timesQuest: getTimesQuest(),
			timesConstruction: getTimesConstruction(),
			timesProduction: TimeManager.listProduction,
			timesCampaign: getCampaign(),
			lastKnowTime:TimeManager.lastKnowTime,
			stats: getStats(),
			idHightest: IdManager.idHightest,
			region: regionSave,
			ground: groundSave,
			building: buildingSave,
			resourcesData: saveResources(),
			COL_X_LENGTH: Ground.COL_X_LENGTH,
			ROW_Y_LENGTH: Ground.ROW_Y_LENGTH,
			version: SAVE_VERSION,
			ftueProgress : DialogueManager.dialogueSaved
		};
		setLocalStorage(currentSave);
	}
	
	private static function saveResources(): ResourcesGeneratorDescription{
		var data:ResourcesData = ResourcesManager.getResourcesData();
		var desc:ResourcesGeneratorDescription = {
			arrayGenerator:new Array<GeneratorDescription>(),
			totals:new Array<Float>(),
			level:data.level
		};
		
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.soft);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.hard);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.goodXp);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.badXp);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.soul);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.intern);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.buildResourceFromHell);
		desc.arrayGenerator = addGenerator(desc.arrayGenerator, data, GeneratorType.buildResourceFromParadise);
		
		//this order is verry importer if you find more clean tell me please ^^'
		desc.totals.push(data.totalsMap[GeneratorType.soft]);
		desc.totals.push(data.totalsMap[GeneratorType.hard]);
		desc.totals.push(data.totalsMap[GeneratorType.goodXp]);
		desc.totals.push(data.totalsMap[GeneratorType.badXp]);
		desc.totals.push(data.totalsMap[GeneratorType.soulGood]);
		desc.totals.push(data.totalsMap[GeneratorType.soulBad]);
		desc.totals.push(data.totalsMap[GeneratorType.intern]);
		desc.totals.push(data.totalsMap[GeneratorType.buildResourceFromHell]);
		desc.totals.push(data.totalsMap[GeneratorType.buildResourceFromParadise]);
		
		return desc;
		
	}
	
	public static function saveNewBuilding (pDescription:TileDescription):Void {
		ServerManager.addBuilding(pDescription);
	}
	
	public static function saveMoveBuilding (pOldDescription:TileDescription, pDescription:TileDescription):Void {
		ServerManager.moveBuilding(pOldDescription, pDescription);
	}
	
	public static function saveUpgradeBuilding (pDescription:TileDescription):Void {
		
	}
	
	public static function saveSellBuilding (pDescription:TileDescription):Void {
		
	}
	
	private static function addGenerator(pArray:Array<GeneratorDescription>, pData:ResourcesData, pType:GeneratorType):Array<GeneratorDescription>{
		var i:Int;
		
		for (i in 0...pData.generatorsMap[pType].length) pArray.push(pData.generatorsMap[pType][i].desc);
		
		return pArray;
	}
	
	// todo : réfléchir au perte de perf à utilsier le localstorage si souvent, négligeable ?
	public static function saveLastKnowTime(pTime:Float):Void {
		currentSave.lastKnowTime = pTime;
		setLocalStorage(currentSave);
	}
	
	// todo : permettre de sauvegarder plusieurs fois dans le localStorage différente élément
	// en plusieur fichiers quoi.
	private static function setLocalStorage(pCurrentSave:Save):Void {
		Browser.getLocalStorage().setItem(
			SAVE_NAME,
			Json.stringify(currentSave)
		);
	}
	
	public static function reinit(){
		Browser.getLocalStorage().clear();
		Browser.location.reload();
	}
	
	
	private static function getTimesResource ():Array<TimeDescription> { // todo : facotriser avec en bas
		return TimeManager.listResource.map(function (pElement){
			return pElement.desc;
		});
	}
	
	private static function getTimesQuest ():Array<TimeQuestDescription> {
		return TimeManager.listQuest.map(function (pElement){
			return pElement;
		});
	}
	
	private static function getTimesConstruction():Array<TimeDescription> {
		return TimeManager.listConstruction.map(function (pElement) {
			return pElement;
		});
	}
	
	private static function getCampaign():CampaignDescription {
		return {
			end: TimeManager.campaignTime,
			type: MarketingManager.getCurrentCampaignType().getName()
		};
	}
	
	private static function getStats ():Stats {
		if (currentSave == null || currentSave.stats == null)
			return {
				gameStartTime:TimeManager.gameStartTime
			};
		else
			return {
				gameStartTime: currentSave.stats.gameStartTime
			};
			
		return null;
	}
	
	/**
	 * UNUSED !
	 * Remove the Save from localStorage
	 */
	public static function destroy():Void {
		Browser.getLocalStorage().setItem(
			SAVE_NAME,
			Json.stringify(null)
		);
	}
	
	/**
	 * Return currentSave, load if null.
	 * @return
	 */
	private static function load():Save {
		//destroy(); // here if save reset needed (constantly)
		if (currentSave == null) {
			currentSave = Json.parse(
				Browser.getLocalStorage().getItem(SAVE_NAME)
			);
			
			if (currentSave != null) {
				
				if (currentSave.version != SAVE_VERSION) {
					destroy();
					currentSave = null;
				}
				else if  (currentSave.COL_X_LENGTH != Ground.COL_X_LENGTH ||
					currentSave.ROW_Y_LENGTH != Ground.ROW_Y_LENGTH)
					throw("DIFFERENT VALUE Ground.COL_X_LENGTH or Ground.ROW_Y_LENGTH !! (use destroy() in this function)");
			}
		}
		return currentSave;
	}
	
	public static function createFromSave():Void {
		load();
		if (currentSave != null) {
			TimeManager.buildFromSave(currentSave); // always begore ResourcesManager
			IdManager.buildFromSave(currentSave); 
			ResourcesManager.initWithLoad(currentSave.resourcesData); //always before regionmanager
			//QuestsManager.initWithSave(currentSave);
			RegionManager.buildFromSave(currentSave);
			VTile.buildFromSave(currentSave);
			TimeManager.startTimeLoop();
			Hud.getInstance().initGaugesWithSave();
			DialogueManager.dialogueSaved = currentSave.ftueProgress;
		}
		else
			createWhitoutSave();
	}
	
	private static function createWhitoutSave():Void {
		TimeManager.buildWhitoutSave(); // always begore ResourcesManager
		IdManager.buildWhitoutSave();
		ResourcesManager.initWithoutSave();
		RegionManager.buildWhitoutSave();
		VTile.buildWhitoutSave();
		TimeManager.startTimeLoop();
		SaveManager.save();
		Hud.getInstance().initGauges();
	}
	
	/**
	 * this function is necessary beceause save translate enum to array
	 * @param pArray:Dynamic
	 * @return Dynamic (the good enum)
	 */
	 //When you save a enum please refresh this function
	public static function translateArrayToEnum(pArray:Dynamic):Dynamic{
		
		if (pArray == null) return null;
		
		return stringToEnum(cast(pArray[0], String));
	}
	
	public static function stringToEnum (pString:String):Dynamic {
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
				
			case "soulGodd":
				return GeneratorType.soulGood;
				
			case "soulBad":
				return GeneratorType.soulBad;
				
			case "intern":
				return GeneratorType.intern;
				
			case "buildResourceFromHell":
				return GeneratorType.buildResourceFromHell;
			
			case "buildResourceFromParadise":
				return GeneratorType.buildResourceFromParadise;
			
			case "hell":
				return Alignment.hell;
			
			case "heaven":
				return Alignment.heaven;
			
			case "neutral":
				return Alignment.neutral;
			
				
			default:
				return null;
		}
	}
}