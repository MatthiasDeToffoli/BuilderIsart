package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.BlockAdAndInvitationManager.Provenance;
import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerFile;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding.EventSuccessAddBuilding;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding.EventSuccessMoveBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VAltar;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.popin.accelerate.SpeedUpPopin;
import com.isartdigital.utils.Debug;
import haxe.Json;


typedef EventSuccessAddBuilding = {
	@:optional var errorID:Int;
	@:optional var startConstruction:Int;
	@:optional var endConstruction:Int;
	var iDClientBuilding:Int;
}

typedef EventSuccessMoveBuilding = {
	@:optional var errorID:Int;
	@:optional var oldX:Int;
	@:optional var oldY:Int;
	@:optional var oldRegionX:Int;
	@:optional var oldRegionY:Int;
	@:optional var iDClientBuilding:Int;
}

typedef EventSuccessSellBuilding = {
	@:optional var errorID:Int;
}

typedef EventSuccessUpgradeBuilding = {
	@:optional var errorID:Int;
	@:optional var startConstruction:Int;
	@:optional var endConstruction:Int;
	var iDClientBuilding:Int;
}

/**
 * ...
 * @author ambroise
 */
class ServerManagerBuilding{

	/**
	 * Add a building in database.
	 * IDClientBuilding is used to identify the building at server callback.
	 * StartContruction and EndScontruction are defined by the server.
	 * @param	pDescription
	 */
	public static function addBuilding (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessAddBuilding, onErrorAddBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_ADD,
			"IDClientBuilding" => pDescription.id,
			"IDTypeBuilding" => GameConfig.getBuildingByName(pDescription.buildingName).iD,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorAddBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on addBuilding : " + pObject);
	}
	
	
	private static function onSuccessAddBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessAddBuilding = Json.parse(pObject);

			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteBuilding(lEvent.iDClientBuilding);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}
			else 
				SynchroManager.syncTimeOfBuilding(lEvent);
			
			
		} else {
			Debug.error("Success php on addBuilding but event format is invalid ! : " + pObject);
		}
		
	}
	
	public static function addFirstPortal (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessAddFirstPortal, onErrorAddFirstPortal, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.FIRST_PORTAL_ADD,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorAddFirstPortal (pObject:Dynamic):Void {
		Debug.error("Error php on addFirstPortal : " + pObject);
	}
	
	
	private static function onSuccessAddFirstPortal (pObject:Dynamic):Void {
		
		if (pObject.charAt(0) == "{") {
			var lEvent:Dynamic = Json.parse(pObject);

			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteBuilding(lEvent.IDClientBuilding);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}
			else if (lEvent.error){
				RollBackManager.deleteBuilding(lEvent.IDClientBuilding); //id null ? Oo
				Debug.error(lEvent.message);
			}
			
			
		} else {
			Debug.error("Success php on addFirstportal but event format is invalid ! : " + pObject);
		}
	}
	
	public static function moveBuilding (pOldDescription:TileDescription, pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessMoveBuilding, onErrorMoveBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_MOVE,
			"IDClientBuilding" => pDescription.id,
			"OldRegionX" => pOldDescription.regionX,
			"OldRegionY" => pOldDescription.regionY,
			"OldX" => pOldDescription.mapX,
			"OldY" => pOldDescription.mapY,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorMoveBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on moveBuilding : " + pObject);
	}
	
	private static function onSuccessMoveBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessMoveBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				if (lFieldError == ErrorManager.BUILDING_CANNOT_MOVE_DONT_EXIST)
					RollBackManager.deleteBuilding(lEvent.iDClientBuilding);
				else	
					RollBackManager.cancelMoveBuilding(lEvent);
				
				ErrorManager.openPopin(lFieldError);
			}
			
		} /*else {
			Debug.error("Success php on moveBuilding but event format is invalid ! : " + pObject);
		}*/
		
	}
	
	public static function upgradeBuilding (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessUpgradeBuilding, onErrorUpgradeBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_UPGRADE,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	// todo : enlever tout les "building" ds les noms des fc
	private static function onErrorUpgradeBuilding (pObject:Dynamic):Void { 
		Debug.error("Error php on upgradeBuilding : " + pObject);
	}
	
	private static function onSuccessUpgradeBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessUpgradeBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				//if (lFieldError == ErrorManager.BUILDING_CANNOT_SELL_DONT_EXIST) // todo
					// todo : synchronisation. // soit faire ajax pr synchro, soit dans callback ici
				
				ErrorManager.openPopin(lFieldError);
			}
			else
				SynchroManager.syncTimeOfBuilding(lEvent);
			
		} 
		else
			Debug.error("Success php on sellBuilding but event format is invalid ! : " + pObject);
	}
	
	public static function sellBuilding (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessSellBuilding, onErrorSellBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_SELL,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorSellBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on sellBuilding : " + pObject);
	}
	
	private static function onSuccessSellBuilding (pObject:Dynamic):Void {
		
		checkNumberMarketingHouse();
		BoostManager.boostBuildingEvent.emit(BoostManager.BUILDING_OFF_EVENT_NAME);

		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessSellBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				//if (lFieldError == ErrorManager.BUILDING_CANNOT_SELL_DONT_EXIST)
					// todo : synchronisation. // soit faire ajax pr synchro, soit dans callback ici
				
				ErrorManager.openPopin(lFieldError);
			}
			
		} /*else {
			Debug.error("Success php on sellBuilding but event format is invalid ! : " + pObject);
		}*/ // return nothing if success right now.
	}
	
	public static function updatePopulation(pDescription:TileDescription, quantity:Int):Void {
		ServerManager.callPhpFile(onSuccessUpdatePopulation, onErrorUpdatePopulation, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.UPDATE_POPULATION,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"NbSoul" => quantity,
			"tribuX" => VTribunal.getInstance().tileDesc.mapX,
			"tribuY" => VTribunal.getInstance().tileDesc.mapY,
			"tribuRegionX" => VTribunal.getInstance().tileDesc.regionX,
			"tribuRegionY" => VTribunal.getInstance().tileDesc.regionY,
			"IdClient" => pDescription.id
			
		]);
	}
	
	private static function onSuccessUpdatePopulation(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				trace('good' + Date.fromTime(data.EndForNextProduction),data.EndForNextProduction );
				var lGenerator:Generator = IdManager.searchVBuildingById(data.IdClient).getGenerator();
				ResourcesManager.UpdateResourcesGenerator(lGenerator, lGenerator.desc.max, data.EndForNextProduction,true);
				cast(IdManager.searchVBuildingById(data.IdClient), VHouse).updatePopulation(data.NbSoul);
				VTribunal.getInstance().myGenerator.desc.quantity = data.NbResource;
				ResourcesManager.replaceResourcesGenerator(VTribunal.getInstance().myGenerator);
			}
		}
	}
	
	private static function onErrorUpdatePopulation(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function createGenerator(pId:Int):Void {
		var lDescription:TileDescription = IdManager.searchVBuildingById(pId).tileDesc;
		ServerManager.callPhpFile(onSuccessCreateGenerator, onErrorCreateGenerator, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.CREATE_GENERATOR,
			"X" => lDescription.mapX,
			"Y" => lDescription.mapY,
			"RegionX" => lDescription.regionX,
			"RegionY" => lDescription.regionY
		]);
	}
	
	//use this with security for know if we always have the building....
	private static function onSuccessCreateGenerator(pObject:Dynamic):Void {
		//trace(pObject);
	}
	
	private static function onErrorCreateGenerator(pObject:Dynamic):Void {
		// commenté pour le bien de l'humanité.
		//Debug.error(pObject);
	}
	
	public static function updateGenerator(pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessUpdateGenerator, onErrorUpdateGenerator, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.UPDATE_GENERATOR,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	//use this with security for know if we always have the building....
	private static function onSuccessUpdateGenerator(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				var lGenerator:Generator = IdManager.searchVBuildingById(data.IDClientBuilding).getGenerator();
				lGenerator.desc.quantity = data.nbResource == 0 ? 0:Std.parseInt(data.nbResource);
				IdManager.searchVBuildingById(data.IDClientBuilding).myGenerator = ResourcesManager.UpdateResourcesGenerator(lGenerator, data.max, data.end,true);
			}
		}
	}
	
	private static function onErrorUpdateGenerator(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function checkForIncreaseAltarNbBuilding(pDescription:TileDescription):Void {
		
		ServerManager.callPhpFile( onSuccessCheckForIncreaseUpdateAltarNbBuilding, onErrorCheckForIncreaseAltarNbBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.CHECK_ALTAR_ZONE,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	//use this with security for know if we always have the building....
	private static function onSuccessCheckForIncreaseUpdateAltarNbBuilding(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				TimeManager.updateTimeResource(data.EndForNextProduction, data.IDClientBuilding, true);
				cast(IdManager.searchVBuildingById(data.IDClientBuilding), VAltar).updateNbHellAndHeaven(data.NbBuildingHell, data.NbBuildingHeaven);
			}
		}
	}
	
	private static function onErrorCheckForIncreaseAltarNbBuilding(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function checkNumberMarketingHouse():Void {
		ServerManager.callPhpFile( onSuccessCheckNumberMarketingHouse, onErrorCheckNumberMarketingHouse, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.CHECK_MARKETING_HOUSE
			]);
	}
	
	private static function onSuccessCheckNumberMarketingHouse(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			}
		}
	}
	
	private static function onErrorCheckNumberMarketingHouse(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function startCampaign(pName:String):Void {
		ServerManager.callPhpFile( onSuccessStartCampaign, onErrorStartCampaign, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.START_CAMPAIGN,
			"Name" => pName
		]);
	}
	
	private static function onSuccessStartCampaign(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				TimeManager.synchroCampaignTime(data.time);
			}
			
			if (data.timeBlock > 0) BlockAdAndInvitationManager.setTime(Provenance.marketing, data.timeBlock);
			ResourcesManager.updateTotal(GeneratorType.hard, data.hard == 0 ? 0:Std.parseFloat(data.hard));
		}
	}
	
	private static function onErrorStartCampaign(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	
	public static function endConstruction(pGoodXp:Float, pBadXp:Float):Void {
		trace(pGoodXp, pBadXp);
		ServerManager.callPhpFile(onSuccessEndConstruction, onErrorEndConstruction, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.END_BUILDING, "goodXp" => pGoodXp, "badXp" =>pBadXp]);
	}
	
	private static function onSuccessEndConstruction (pObject:String):Void {
		trace(pObject);
	}
	
	private static function onErrorEndConstruction (object:Dynamic):Void {
		Debug.error("Error php : " + object);
	}
	
	public static function startCollectorProd(pDescription:TileDescription, pName:String):Void {
		ServerManager.callPhpFile( onSuccessStartCollectorProd, onErrorStartCollectorProd, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.START_COLLECTOR_PROD,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY,
			"Name" => pName
		]);
	}
	
	private static function onSuccessStartCollectorProd(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				TimeManager.synchroProductionTime(data.IDClientBuilding,data.time);
			}
			
			ResourcesManager.updateTotal(GeneratorType.soft, data.soft == 0 ? 0:Std.parseFloat(data.soft));
		}
	}
	
	private static function onErrorStartCollectorProd(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function CollectorProdRecuperation(pDescription:TileDescription):Void {
		ServerManager.callPhpFile( onSuccessCollectorProdRecuperation, onErrorCollectorProdRecuperation, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.COLLECTOR_RECUP,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onSuccessCollectorProdRecuperation(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				ResourcesManager.setLevel(Std.parseInt(data.level));
				ResourcesManager.updateTotal(GeneratorType.badXp, data.badXp == 0 ? 0:Std.parseFloat(data.badXp));
				ResourcesManager.updateTotal(GeneratorType.goodXp, data.goodXp == 0 ? 0:Std.parseFloat(data.goodXp));
				ResourcesManager.updateTotal(GeneratorType.buildResourceFromHell, data.resourcesFromHell == 0 ? 0:Std.parseFloat(data.resourcesFromHell));
				ResourcesManager.updateTotal(GeneratorType.buildResourceFromParadise, data.resourcesFromHeaven == 0 ? 0:Std.parseFloat(data.resourcesFromHeaven));
			}
			
		}
	}
	
	private static function onErrorCollectorProdRecuperation(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function RecoltGenerator(pDescription:TileDescription):Void {
		ServerManager.callPhpFile( onSuccessRecoltGenerator, onErrorRecoltGenerator, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.GENERATOR_RECUP,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onSuccessRecoltGenerator(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			} else {
				ResourcesManager.updateTotal(GeneratorType.soft, data.resource == 0 ? 0:Std.parseFloat(data.resource));			
			}
			
		}
	}
	
	private static function onErrorRecoltGenerator(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function BoostBuilding(pDesc:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessBoost, onErrorBoost, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_BOOST,
			"RegionX" => pDesc.regionX,
			"RegionY" => pDesc.regionY,
			"X" => pDesc.mapX,
			"Y" => pDesc.mapY,
			"progress" => pDesc.timeDesc.progress,
			"endTime" => pDesc.timeDesc.end
		]);
	}
	
	private static function onSuccessBoost(object:Dynamic):Void {
		if (object.charAt(0) == "{") {
			var lEvent:EventSuccessMoveBuilding = Json.parse(object);
			if (Reflect.hasField(lEvent, "errorID")) {
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}					
		} else {
			if (cast(object, String) == "done") SpeedUpPopin.getInstance().validBoost(); 
		}
	}
	
	private static function onErrorBoost(object:Dynamic):Void {
		Debug.error(object);
	}
	
	public static function BoostCollector(pDesc:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessBoostCollector, onErrorBoostCollector, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.COLLECTOR_BOOST,
			"RegionX" => pDesc.regionX,
			"RegionY" => pDesc.regionY,
			"X" => pDesc.mapX,
			"Y" => pDesc.mapY
		]);
	}
	
	private static function onSuccessBoostCollector(pObject:Dynamic):Void {
		/*if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			}
			
		}*/
	}
	
	private static function onErrorBoostCollector(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function upgradeFine(pDesc:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessUpgradeFine, onErrorUpgradeFine, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.UPGRADE_FINE,
			"RegionX" => pDesc.regionX,
			"RegionY" => pDesc.regionY,
			"X" => pDesc.mapX,
			"Y" => pDesc.mapY
		]);
	}
	
	private static function onSuccessUpgradeFine(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			}
			
		}
	}
	
	private static function onErrorUpgradeFine(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
	
	public static function addSoul(pDesc:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessAddSoul, onErrorAddSoul, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.ADD_SOUL,
			"RegionX" => pDesc.regionX,
			"RegionY" => pDesc.regionY,
			"X" => pDesc.mapX,
			"Y" => pDesc.mapY
		]);
	}
	
	private static function onSuccessAddSoul(pObject:Dynamic):Void {
		if (pObject.charAt(0) != "{" || pObject.charAt(pObject.length - 1) != '}') {
			Debug.error("error php : \n\n " + pObject);
		} else {
			var data:Dynamic = Json.parse(pObject);
			
			if (data.error) {
				Debug.error(data.message);
			}
			
			BlockAdAndInvitationManager.setTime(Provenance.tribunal, data.time);
			
		}
	}
	
	private static function onErrorAddSoul(pObject:Dynamic):Void {
		Debug.error(pObject);
	}
}