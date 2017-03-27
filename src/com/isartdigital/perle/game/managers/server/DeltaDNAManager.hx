package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.server.deltaDNA.UIAction;
import com.isartdigital.perle.game.managers.server.deltaDNA.UILocation;
import com.isartdigital.perle.game.managers.server.deltaDNA.UIType;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessConnexion;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import js.html.Event;


enum TransactionType { boughtBuilding; skippedTimer; shopPackBought; hiredIntern; internshipStarted; choiceMade; 
extendedRegions; soldBuilding; boughtDecoration; soldDecoration;  internStressReset; gachaAttained; soulDistribution; }

/**
 * Evrything about DeltaDNA :)
 * function description come from the description of the event in DeltaDNA.
 * @author ambroise
 */
class DeltaDNAManager{

	private static var isReady:Bool;
	
	private static var startGame:Date;
	
	// ##############################################################
    // INIT, GAME_STARTED, NEW_PLAYER, CLIENT_DEVICE, GAME_ENDED
    // ##############################################################
	
	public static function sendConnexionEvents (pEvent:EventSuccessConnexion):Void {
		if (!Main.DELTA_DNA) {
			Debug.warn("DeltaDNA desactived.");
			return;
		}
		
		DeltaDNA.init(
			Config.DELTA_DNA_KEY_DEV, 
			Config.DELTA_DNA_KEY_LIVE,
			Config.DELTA_DNA_URL_COLLECT,
			Config.DELTA_DNA_URL_ENGAGE,
			pEvent.ID,
			pEvent.ID + "_" + Date.now().getTime()
		);
		
		if (pEvent.isNewPlayer)
			DeltaDNA.addEvent(DeltaDNA.NEW_PLAYER, getMinimumFields());
		
		DeltaDNA.addEvent(DeltaDNA.GAME_STARTED, getMinimumFields());
		DeltaDNA.addEvent(DeltaDNA.CLIENT_DEVICE);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		
		isReady = true;
	}
	
	public static function listenToCloseGame ():Void {
		if (DeviceCapabilities.isCocoonJS)
			untyped Browser.window.Cocoon.App.on("suspended", onUnload); // todo : test.
		else
			Browser.window.onbeforeunload = onUnload;
	}
	
	private static function onUnload (pEvent:Event = null):String {
		DeltaDNA.addEvent(DeltaDNA.GAME_ENDED, getMinimumFields());
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		return null;
	}
	
	public static function init ():Void {
		startGame = Date.now();
	}
	
	
	// ##############################################################
    // FTUE, and all others events
    // ##############################################################
	
	private static var stepFTUETStartTimeStamp:Float=0;
	
	/**
	 * Tracking Ftue steps
	 * @param	pStepIndex
	 */
	public static function sendStepFTUE (pStepIndex:Int):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		if (stepFTUETStartTimeStamp == 0) {
			stepFTUETStartTimeStamp = Date.now().getTime();
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.FTUE_STEP, 
			addFields({
				index:pStepIndex,
				// How much time was spent on that step ?
				timeSpent: Math.round(Date.now().getTime() - stepFTUETStartTimeStamp)
			}, false)
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		
		stepFTUETStartTimeStamp = Date.now().getTime();
	}
	
	/**
	 * Whenever a player buys, sells or exchanges goods like real currency, virtual currencies or items
	 * @param	pTransactionType
	 * @param	pIdPack
	 * @param	pTypePrice
	 * @param	pPrice
	 */
	public static function sendTransaction (pTransactionType:TransactionType, pIdPack:Int, pTypePrice:GeneratorType, pPrice:Float):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.TRANSACTION, 
			untyped addFields({
				transactionID: Facebook.uid + "_" + Date.now().toString() + "_" + Std.string(Math.random() * 100000),
				transactionType: pTransactionType.getName(),
				productReceived: pIdPack,
				productReceivedAmount: 1,
				productSpent: pTypePrice.getName(),
				productsSpent: { }, // required but completely useless
				productsReceived: {}, // same, plan de tagguage *******
				// some item have prices in more then one currencie, so this is not accurate ! (we decided it only take gold when multiple prices)
				productSpendAmount: pPrice // float
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * When the player collects soft from buildings
	 * @param	pBuildingID
	 * @param	pTypeBuildingID
	 * @param	pResouceType
	 * @param	pAmount
	 */
	public static function sendCollect (pBuildingID:Int, pTypeBuildingID:Int, pResouceType:GeneratorType, pAmount:Int):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.COLLECT,
			untyped addFields({
				productReceived: pResouceType,
				productReceivedAmount: pAmount,
				buildingID: pBuildingID,
				buildingTypeID: pTypeBuildingID
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * A choice is made by a player during an Internship event
	 * @param	pInternConfigID
	 * @param	pChoiceConfigID
	 */
	public static function sendIntershipChoice (pInternConfigID:Int, pChoiceConfigID:Int):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.INTERSHIP_CHOICE, 
			untyped addFields({
				internID: pInternConfigID,
				choiceID: pChoiceConfigID
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * The uiInteraction event should be recorded when the player interacts with parts of the interface,
	 * specifically as they press buttons or links to view specific features and navigate around.
	 * This event is used to track user journeys around the interface to help determine if parts of the interface or features are not obvious enough
	 * When a button or link to a specific feature exists in multiple locations it can be valuable to track the location of the button that was used.
	 * @param	pUIAction UIAction is the action taken on the User Interface object.
	 * @param	pUILocation UILocation is the position in the game where the User Interface object is.
	 * @param	pUIName UIName is the name that defines the interaction.
	 * @param	pUIType UIType is the type of User Interface object.
	 */
	public static function sendUIInteraction (pUIAction:UIAction, pUILocation:UILocation, pUIName:String, pUIType:UIType):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.UI_INTERACTION, 
			untyped addFields({
				// WTF majuscules...
				UIAction: pUIAction.toString(),
				UILocation: pUILocation.toString(),
				UIName: pUIName,
				UIType: pUIType.toString(),
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * The social tracks behaviour that is social and allows an indication of the amount of social activity a user is undertaking.
	 * @param	pFriendName Name of the person invited by the player
	 */
	public static function sendSocial (pFriendName:String):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.SOCIAL, 
			addFields({
				friendInvited:pFriendName
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * Add minum fields to the event, and if wanted and base fields too
	 * @param	pCustomFields
	 * @param	pBaseEvents
	 * @return the merged object
	 */
	private static function addFields (pCustomFields:Dynamic, pBaseEvents:Bool = true):Dynamic {
		if (pBaseEvents)
			return untyped Object.assign(
				getMinimumFields(),
				Object.assign(
					getBaseFields(), 
					pCustomFields
				)
			);
		else
			return untyped Object.assign(
				getMinimumFields(),
				pCustomFields
			);
	}
	
	/**
	 * 
	 * @return Fields that should be on every event
	 */
	private static function getMinimumFields ():Dynamic {
		return {
			clientVersion: Config.version,
			dataVersion: Config.version,
			gameTime: Date.now().getTime() - startGame.getTime(),
			userStartDate: startGame.toString()
		}
	}
	
	/**
	 * 
	 * @return Fields taht shoulb be on most of the event (see "Plan de taggage")
	 */
	private static function getBaseFields ():Dynamic {
		return {
			playerLevel: ResourcesManager.getLevel(),
			playerXPHell: ResourcesManager.getTotalForType(GeneratorType.badXp),
			playerXPHeaven: ResourcesManager.getTotalForType(GeneratorType.goodXp),
			playerGold: ResourcesManager.getTotalForType(GeneratorType.soft),
			playerKarma: ResourcesManager.getTotalForType(GeneratorType.hard),
			playerWood: ResourcesManager.getTotalForType(GeneratorType.buildResourceFromParadise),
			playerIron: ResourcesManager.getTotalForType(GeneratorType.buildResourceFromHell),
			playerInterns: Intern.internsListArray.map(function(p:InternDescription) {
				return p.id;
			}).join(","),
			playerNeutralSouls: ResourcesManager.getTotalForType(GeneratorType.soul),
			playerHellSouls: ResourcesManager.getTotalForType(GeneratorType.soulBad),
			playerHeavenSouls: ResourcesManager.getTotalForType(GeneratorType.soulGood)
		};
	}
	
}