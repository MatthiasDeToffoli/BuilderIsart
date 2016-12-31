package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.ResourcesManager.ResourcesData;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.ftue.FtueUI;
import haxe.Json;
import js.Browser;


//@:optional vous connaisiez ?

enum RegionType {hell; eden; styx; }
enum GeneratorType {soft; hard; goodXp; badXp; soul; soulGood; soulBad; intern; buildResourceFromHell; buildResourceFromParadise; }
enum Alignment {neutral; demon; angel; }


typedef TileDescription = {
	var className:String;
	var assetName:String;
	var id:Int;
	var regionX:Int;
	var regionY:Int;
	var mapX:Int;
	var mapY:Int;
	@:optional var isTribunal:Bool;
}

typedef RegionDescription = {
	var x:Int;
	var y:Int;
	var type:RegionType;
	var firstTilePos:Index;
}

typedef TimeDescription = {
	var refTile:Int; // l'id du bâtiment auquel il est associé
	var progress:Float; // de 0 à end pour une barre de progression
	var end:Float; // millisecondes
}

typedef TimeQuestDescription = {
	var refIntern:Int;
	var progress:Float;
	var steps:Array<Float>;
	var stepIndex:Int;
	var end:Float;
}

typedef GeneratorDescription = {
	var type:GeneratorType;
	var quantity:Float;
	var max:Int;
	var id:Int;
	@:optional var alignment:Alignment;
	
}

// typedef for intern i use this for prepare the ui
typedef InternDescription = {
	var id:Int; // for link with quest i think
	var name:String;
	var isInQuest:Bool; // @ TODO delete i think we can check this with the link at quest manager
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
	var lastKnowTime:Float;
	var resourcesData:ResourcesGeneratorDescription;
	var ftueProgress:Int;
	var itemUnlocked:Array<String>;
	// add what you want to save.
}

/**
 * ...
 * @author ambroise
 */
class SaveManager {
	private static inline var SAVE_NAME:String = "com_isartdigital_perle";
	private static inline var SAVE_VERSION:String = "1.0.1";
	public static var currentSave(default, null):Save;
	
	/**
	 * Save the buildings and grounds in a Json in local storage.
	 * Use virtualCell to make the save.
	 */
	public static function save():Void { // todo ajouter la possibilité de save qu'une partie pour perf
		var buildingSave:Array<TileDescription> = [];
		var groundSave:Array<TileDescription> = [];
		var regionSave:Array<RegionDescription> = [];
		var itemUnlock:Array<String> = [];
		
		itemUnlock = UnlockManager.itemUnlocked;
		
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
			ftueProgress : FtueUI.actualDialogue,
			itemUnlocked : itemUnlock
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
	
	private static function getTimesResource ():Array<TimeDescription> { // todo : facotriser avec en bas
		return TimeManager.listResource.map(function (pElement){
			return pElement.desc;
		});
	}
	
	private static function getTimesQuest ():Array<TimeQuestDescription> {
		return TimeManager.listQuest.map(function (pElement){
			return pElement.desc;
		});
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
			RegionManager.buildFromSave(currentSave);
			VTile.buildFromSave(currentSave);
			TimeManager.startTimeLoop();
			FtueManager.dialogueSaved = currentSave.ftueProgress;
			UnlockManager.isAlreadySaved = true;
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
	}
	
	/**
	 * this function is necessary beceause save translate enum to array
	 * @param pArray:Dynamic
	 * @return Dynamic (the good enum)
	 */
	 //When you save a enum please refresh this function
	public static function translateArrayToEnum(pArray:Dynamic):Dynamic{
		
		if (pArray == null) return null;
		switch pArray[0] {
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
			return RegionType.hell;
			
			case "eden":
			return RegionType.eden;
			
			case "styx":
			return RegionType.styx;
			
			case "neutral":
			return Alignment.neutral;
			
			case "demon":
			return Alignment.demon;
			
			case "angel":
			return Alignment.angel;
				
			default:
				return null;
		}
	}
}