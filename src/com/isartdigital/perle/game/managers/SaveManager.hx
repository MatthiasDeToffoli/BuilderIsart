package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import com.isartdigital.perle.game.managers.ResourcesManager.ResourcesData;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.managers.server.ServerManagerLoad;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.HudMissionButton;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.Debug;
import haxe.Json;
import js.Browser;

//@:optional vous connaisiez ?

enum GeneratorType { soft; hard; goodXp; badXp; soul; soulGood; soulBad; intern; buildResourceFromHell; buildResourceFromParadise; isartPoint; }
enum Alignment {neutral; hell; heaven; }


typedef TileDescription = {
	var buildingName:String;
	var id:Int; // this is NOT a database id.
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
	var startTime:Float;
	var steps:Array<Float>;
	var stepIndex:Int;
	var progress:Float;
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
	var totals:Map<GeneratorType, Float>;
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
	var stats:Stats;
	var idHightest:Int;
	var region:Array<RegionDescription>;
	var ground:Array<TileDescription>;
	var building:Array<TileDescription>;
	var timesResource:Array<TimeDescription>;
	var timesConstruction:Array<TimeDescription>;
	var timesProduction:Array<TimeDescription>;
	var timesCampaign:CampaignDescription;
	var lastKnowTime:Float;
	var resourcesData:ResourcesGeneratorDescription;
	var ftueProgress:Int;
	var idPackBundleBuyed:Array<Int>;
	var missionDecoration:Int;
	// add what you want to save.
}

/**
 * ...
 * @author tout le monde
 */
class SaveManager {
	private static inline var SAVE_NAME:String = "com_isartdigital_perle";
	private static inline var SAVE_VERSION:String = "1.1.2";
	public static var currentSave(default, null):Save;
	
	/**
	 * Usefull to keep the good serverBuilding index whit the good TileDesc
	 * when calling loadBuilding()
	 * Avoid me from making loadBuilding() return a Map<TableBuilding, TileDescription>
	 * destroyed after loading
	 */
	private static var serverBuildingToTileDesc:Map<TableBuilding, TileDescription>;
	
	
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
			timesConstruction: getTimesConstruction(),
			timesProduction: TimeManager.listProduction,
			timesCampaign: getCampaign(),
			lastKnowTime:TimeManager.lastKnowTime,
			stats: getStats(),
			idHightest: IdManager.idHightest,
			region: regionSave,
			ground: groundSave,
			building: buildingSave,
			resourcesData: null, // now is server only
			ftueProgress : DialogueManager.dialogueSaved,
			idPackBundleBuyed: currentSave != null ? (currentSave.idPackBundleBuyed != null ? currentSave.idPackBundleBuyed : []) : [],
			missionDecoration: HudMissionButton.numberOfDecorationCreated
		};
		setLocalStorage(currentSave);
	}
	
	public static function saveLockBundle (pIDBundleBlocked:Int):Void {
		// see if the id can be blocked, i f yes block it by saving it.
		for (i in 0...GameConfig.getShopPackOneTimeOffer().length) {
			if (GameConfig.getShopPackOneTimeOffer()[i].iD == pIDBundleBlocked) {
				if (currentSave.idPackBundleBuyed == null)
					currentSave.idPackBundleBuyed = [];
				
				if (currentSave.idPackBundleBuyed.indexOf(pIDBundleBlocked) == -1) {
					currentSave.idPackBundleBuyed.push(pIDBundleBlocked);
					setLocalStorage(currentSave);
				} else {
					Debug.error("You just buyed a bundle that shouldn't be showing up !");
				}
			}
		}
	}
	
	public static function isBundleLocked (pIDBundleBlocked:Int):Bool {
		if (currentSave.idPackBundleBuyed == null)
			currentSave.idPackBundleBuyed = [];
		
		return SaveManager.currentSave.idPackBundleBuyed.indexOf(pIDBundleBlocked) != -1;
	}
	
	public static function saveNewBuilding (pDescription:TileDescription):Void {
		ServerManagerBuilding.addBuilding(pDescription);
	}
	
	public static function saveMoveBuilding (pOldDescription:TileDescription, pDescription:TileDescription):Void {
		ServerManagerBuilding.moveBuilding(pOldDescription, pDescription);
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
		if (currentSave == null) {
			
			// untyped because i'm not filling all required fields
			// will be merge whit localStorage, so don't panic
			serverBuildingToTileDesc = new Map<TableBuilding, TileDescription>();
			
			var lBuildings:Array<TileDescription> = loadBuilding();
			var lResources:ResourcesGeneratorDescription = loadResources(serverBuildingToTileDesc);
			var lPlayer:TablePlayer = 
			
			untyped currentSave = { 
				//timesResource: getTimesResource(),
				//timesQuest: getTimesQuest(),
				//timesConstruction: getTimesConstruction(),
				//timesProduction: TimeManager.listProduction,
				//timesCampaign: getCampaign(),
				//lastKnowTime:TimeManager.lastKnowTime,
				//stats: getStats(),
				//idHightest: IdManager.idHightest, // n'est plus utilisé
				//region: regionSave,
				//ground: groundSave,
				building: lBuildings,
				resourcesData: lResources,
				//version: SAVE_VERSION,
				//ftueProgress : DialogueManager.dialogueSaved,
				//idPackBundleBuyed: currentSave != null ? (currentSave.idPackBundleBuyed != null ? currentSave.idPackBundleBuyed : []) : []
			};
			ServerManagerLoad.deleteServerSave();
			serverBuildingToTileDesc = null;
			
			//todo : temporary, it's fill's the missing value from localSave
			// game should be tested whitout later, to be sure everything is saved in server.
			currentSave = untyped Object.assign(
				Json.parse(
					Browser.getLocalStorage().getItem(SAVE_NAME)
				),
				currentSave
			);
		}
		
		return currentSave;
	}
	
	private static function loadResources (pBuildings:Map<TableBuilding, TileDescription>):ResourcesGeneratorDescription {
		var desc:ResourcesGeneratorDescription = {
			arrayGenerator:new Array<GeneratorDescription>(),
			totals:new Map<GeneratorType, Float>(),
			level:ServerManagerLoad.getPlayer().level
		};
		var lTotals:Array<TableResources> = ServerManagerLoad.getResources();
		
		for (config in pBuildings.keys()) {
			var lGameConfig:TableTypeBuilding = GameConfig.getBuildingByID(config.iDTypeBuilding);
			desc.arrayGenerator.push(buildingLoadGenerator(
				pBuildings[config],
				lGameConfig,
				config
			));
			
		}
		
		for (i in 0...lTotals.length) {
			desc.totals[lTotals[i].type] = lTotals[i].quantity;
		}
		
		return desc;
	}

	
	private static function loadBuilding ():Array<TileDescription> {
		var result:Array<TileDescription> = [];
		var lBuilding:Array<TableBuilding> = ServerManagerLoad.getBuilding();
		
		if (lBuilding == null)
			Debug.error("No Building saved on server !");
		
		
		for (i in 0...lBuilding.length) {
			var lGameConfig:TableTypeBuilding = GameConfig.getBuildingByID(lBuilding[i].iDTypeBuilding);
			result.unshift({ 
				buildingName: lGameConfig.name,
				id: IdManager.newId(),
				regionX: lBuilding[i].regionX,
				regionY: lBuilding[i].regionY,
				mapX: lBuilding[i].x,
				mapY: lBuilding[i].y,
				level: lGameConfig.level,
				currentPopulation: lBuilding[i].nbSoul,
				maxPopulation: lGameConfig.maxSoulsContained
				/*intern: ,*/ // todo : fill @Emeline, @Victor
				// todo ci-dessous :
				// nbResource
				// endForNextProduction
				// nbSoul
			});
			if (lGameConfig.name == "Purgatory")
				result[0].isTribunal = true;
			if (lBuilding[i].endConstruction > Date.now().getTime())
				result[0].timeDesc = { 
					refTile: result[0].id,
					progress: Date.now().getTime(),
					end: lBuilding[i].endConstruction,
					creationDate: lBuilding[i].startConstruction 
				}; // marche pas trop car code WTF
				
			serverBuildingToTileDesc[lBuilding[i]] = result[0];
			
		}
		return result;
	}
	
	private static function buildingLoadGenerator (pTileDesc:TileDescription, pGameConfig:TableTypeBuilding, pServerData:TableBuilding):GeneratorDescription {
		return {
			id: pTileDesc.id,
			type: pGameConfig.productionResource,
			quantity: pServerData.nbResource,
			max: pGameConfig.maxGoldContained,
			//pServerData.endForNextProduction, // keep that in mind
			alignment: pGameConfig.alignment
		};
	}
	
	public static function createFromSave():Void {
		if (Browser.getLocalStorage().getItem(SAVE_NAME) != null) {
			load();
			
			TimeManager.buildFromSave(currentSave); // always begore ResourcesManager
			ResourcesManager.initWithLoad(currentSave.resourcesData); //always before regionmanager
			//QuestsManager.initWithSave(currentSave);
			RegionManager.buildFromSave(currentSave);
			VTile.buildFromSave(currentSave);
			TimeManager.startTimeLoop();
			Hud.getInstance().initGaugesWithSave();
			DialogueManager.dialogueSaved = currentSave.ftueProgress;
			HudMissionButton.numberOfDecorationCreated = currentSave.missionDecoration;
		}
		else
			createWhitoutSave();
	}
	
	private static function createWhitoutSave():Void {
		TimeManager.buildWhitoutSave(); // always begore ResourcesManager
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
	 // todo : delete this function and the one bellow stringToEum when Region is loaded from server
	public static function translateArrayToEnum(pArray:Dynamic):Dynamic{
		
		if (pArray == null) return null;
		
		return stringToEnum(cast(pArray[0], String));
	}
	
	private static function stringToEnum (pString:String):Dynamic {
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