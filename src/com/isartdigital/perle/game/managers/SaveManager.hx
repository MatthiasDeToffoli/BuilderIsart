package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.MarketingManager.CampaignType;
import com.isartdigital.perle.game.managers.ResourcesManager.ResourcesData;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.managers.server.ServerManagerLoad;
import com.isartdigital.perle.game.managers.server.ServerManagerReset;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.HudMissionButton;
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
	@:optional var isBuilt:Bool;
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
	@:optional var packId:Int;
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

typedef TimesForBlocked = {
	var shop:Float;
	var marketing:Float;
	var tribunal:Float;
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
	@:optional var timesForBlocked:TimesForBlocked;
	// add what you want to save.
}

/**
 * ...
 * @author tout le monde
 */
class SaveManager {
	private static inline var SAVE_NAME:String = "com_isartdigital_perle";
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
	
	public static function reinit () {
		ServerManagerReset.reset();
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
			var lRegions:Array<RegionDescription> = loadRegion();
			var lResources:ResourcesGeneratorDescription = loadResources(serverBuildingToTileDesc);
			var lTimeResources:Array<TimeDescription> = loadTimeResources(serverBuildingToTileDesc);
			var lTimeResourcesProd:Array<TimeDescription> = loadTimeResourcesProd(serverBuildingToTileDesc);
			var lTimeCampaign:CampaignDescription;
			var lPlayer:TablePlayer = ServerManagerLoad.getPlayer(); 
			var lFtue:Int = lPlayer.ftueProgress; 
			var lDeco:Int = lPlayer.decoMission;
			if(lPlayer.idCampaign > 0) lTimeCampaign = {
				end:ServerManagerLoad.getPlayer().endOfCampaign,
				type:MarketingManager.getCampaignByName(GameConfig.getBuildingPackById(lPlayer.idCampaign).name)
			};
			else lTimeCampaign = {
				end:0,
				type:CampaignType.none.getName()
			};
			
			var lTimesForBLocked:TimesForBlocked = loadTimesForBlocked();
			
			untyped currentSave = { 
				timesResource: lTimeResources,
				//timesQuest: getTimesQuest(),
				//timesConstruction: getTimesConstruction(),
				timesProduction: lTimeResourcesProd,
				timesCampaign: lTimeCampaign,
				//lastKnowTime:TimeManager.lastKnowTime,
				//stats: getStats(),
				//idHightest: IdManager.idHightest, // n'est plus utilisé
				region: lRegions,
				//ground: groundSave,
				building: lBuildings,
				resourcesData: lResources,
				ftueProgress : lFtue,
				//idPackBundleBuyed: currentSave != null ? (currentSave.idPackBundleBuyed != null ? currentSave.idPackBundleBuyed : []) : [],
				missionDecoration: lDeco,
				timesForBlocked : lTimesForBLocked
			};
			//i like to use the email from ServerManagerLoad, so why not keep the server load result ?
			//ServerManagerLoad.deleteServerSave(); 
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
	
	private static function loadTimesForBlocked():TimesForBlocked {
		var lPlayer:TablePlayer = ServerManagerLoad.getPlayer(); 
		
		return {
			shop: lPlayer.dateForSawAdInShop,
			marketing: lPlayer.dateForSawAdInMarketing,
			tribunal:lPlayer.dateForInvitedSoul
		}
	}
	
	private static function loadRegion():Array<RegionDescription>{
		var lAllRegions:Array<TableRegion> = ServerManagerLoad.getRegion();
		var lArray:Array<RegionDescription> = new Array<RegionDescription>();
		var lRegion:TableRegion;
		
		for (lRegion in lAllRegions) {
			lArray.push({
				firstTilePos:{
					x:Std.int(lRegion.fistTilePosX),
					y:Std.int(lRegion.fistTilePosY)
				},
				type:lRegion.type,
				x:Std.int(lRegion.positionX),
				y:Std.int(lRegion.positionY)
			});
		}
		
		return lArray;
	}
	
	private static function loadTimeResourcesProd (pBuildings:Map<TableBuilding, TileDescription>):Array<TimeDescription>{
		var lArray:Array<TimeDescription> = new Array<TimeDescription>();
		var config:TableBuilding;
		
		for (config in pBuildings.keys()) {
			var lGameConfig:TableTypeBuilding = GameConfig.getBuildingByID(config.iDTypeBuilding);
			
			if ((lGameConfig.name == BuildingName.HELL_COLLECTOR || lGameConfig.name == BuildingName.HEAVEN_COLLECTOR) && config.packId > 0) {
				lArray.push({
					refTile:pBuildings[config].id,
					progress:Date.now().getTime(),
					end:config.endForNextProduction,
					packId: config.packId,
					gain: lGameConfig.name == BuildingName.HELL_COLLECTOR ? 
						GameConfig.getBuildingPackById(config.packId).gainIron :
						GameConfig.getBuildingPackById(config.packId).gainWood
				});
			}
			
		}
		
		return lArray;
	}
	
	private static function loadTimeResources (pBuildings:Map<TableBuilding, TileDescription>):Array<TimeDescription>{
		var lArray:Array<TimeDescription> = new Array<TimeDescription>();
		var config:TableBuilding;
		
		for (config in pBuildings.keys()) {
			var lGameConfig:TableTypeBuilding = GameConfig.getBuildingByID(config.iDTypeBuilding);
			
			if ((lGameConfig.productionPerBuildingHeaven != null || lGameConfig.productionPerBuildingHell != null || lGameConfig.productionPerHour != null)
			&& (lGameConfig.name != BuildingName.HELL_COLLECTOR && lGameConfig.name != BuildingName.HEAVEN_COLLECTOR && lGameConfig.name != BuildingName.HEAVEN_MARKETING_DEPARTMENT)) {
				lArray.push({
					refTile:pBuildings[config].id,
					progress:Date.now().getTime(),
					end:config.endForNextProduction
				});
			}
			
		}
		
		return lArray;
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
			
			if ((lGameConfig.productionPerBuildingHeaven != null || lGameConfig.productionPerBuildingHell != null || lGameConfig.productionPerHour != null)
			&& (lGameConfig.name != BuildingName.HELL_COLLECTOR && lGameConfig.name != BuildingName.HEAVEN_COLLECTOR && lGameConfig.name != BuildingName.HEAVEN_MARKETING_DEPARTMENT)) {
				desc.arrayGenerator.push(buildingLoadGenerator(
					pBuildings[config],
					lGameConfig,
					config
				));	
			}
			
			
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
				currentPopulation: (lGameConfig.name == BuildingName.HELL_HOUSE || lGameConfig.name == BuildingName.HEAVEN_HOUSE) ? lBuilding[i].nbSoul:null,
				maxPopulation: (lGameConfig.name == BuildingName.HELL_HOUSE || lGameConfig.name == BuildingName.HEAVEN_HOUSE) ? lGameConfig.maxSoulsContained:null,
				isBuilt:lBuilding[i].isBuilt
				/*intern: ,*/ // todo : fill @Emeline, @Victor
				// todo ci-dessous :
				// nbResource
				// endForNextProduction
				// nbSoul
			});
			if (lGameConfig.name == BuildingName.STYX_PURGATORY)
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
			max: pGameConfig.name == BuildingName.STYX_PURGATORY ? pGameConfig.maxSoulsContained:pGameConfig.maxGoldContained,
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
			BlockAdAndInvitationManager.updateFromSave(currentSave.timesForBlocked);
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
}