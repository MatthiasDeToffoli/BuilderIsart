package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
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
extendedRegions; soldBuilding; boughtDecoration; internStressReset; gachaAttained; }

/**
 * Evrything about DeltaDNA :)
 * function description come from the description of the event in DeltaDNA.
 * @author ambroise
 */
class DeltaDNAManager{

	private static var isReady:Bool;
	
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
			DeltaDNA.addEvent(DeltaDNA.NEW_PLAYER);
		
		DeltaDNA.addEvent(DeltaDNA.GAME_STARTED);
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
		DeltaDNA.addEvent(DeltaDNA.GAME_ENDED);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		return null;
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
		
		DeltaDNA.addEvent(DeltaDNAEventCustom.FTUE_STEP, {
			index:pStepIndex,
			// How much time was spent on that step ?
			timeSpent: Math.round(Date.now().getTime() - stepFTUETStartTimeStamp)
		});
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
			untyped Object.assign(getBaseEvent(), {
				transactionID: Facebook.uid + "_" + Date.now().toString() + "_" + Std.string(Math.random() * 100000),
				transactionType: pTransactionType,
				productReceived: pIdPack,
				productReceivedAmount: 1,
				productSpend: pTypePrice.getName(), // WTF je ne le vois pas dans deltaDNA
				// some item have prices in more then one currencie, so this is not accurate !
				productSpendAmount: Math.round(pPrice) // WTF is INT but isartPoint can be float
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * When the player collects soft from buildings
	 * @param	pTypeBuildingID
	 * @param	pAmount
	 */
	public static function sendCollect (pTypeBuildingID:Int, pAmount:Int):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.COLLECT, 
			untyped Object.assign(getBaseEvent(), {
				productReceived: Std.string(pTypeBuildingID), // WTF quel id ? celle du building ? doublon avec product ID, voir leo_gd
				productReceivedAmount: pAmount,
				productID: Std.string(pTypeBuildingID) // WTF too
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/**
	 * A choice is made by a player during an Internship event
	 * @param	pProductID
	 * @param	pChoiceID ID of the Choice the player has made during the Event
	 */
	public static function sendIntershipChoice (pProductID:Int, pChoiceID:Int):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.INTERSHIP_CHOICE, 
			untyped Object.assign(getBaseEvent(), {
				productID: pProductID, // WTF, the same as choiceID ?
				choiceID: pChoiceID
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
	public static function sendUIInteraction (pUIAction:String, pUILocation:String, pUIName:String, pUIType:String):Void {
		if (!isReady) {
			if (Main.DELTA_DNA)
				Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(
			DeltaDNAEventCustom.UI_INTERACTION, 
			untyped Object.assign(getBaseEvent(), {
				// WTF majuscules...
				UIAction: pUIAction, // Close, OpenDescription, ChangeTab, etc, ENUM
				UILocation: pUILocation, // WTF, genre UIPosition.BOTTOM ? ENUM
				UIName: pUIName, // titlecard, shop, pugatory ? ENUM
				UIType: pUIType, // popin, hud, etc ? ENUM
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
			untyped Object.assign(getBaseEvent(), {
				friendInvited:pFriendName
			})
		);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	
	private static function getBaseEvent ():Dynamic {
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
	
	/*public static function sendTimeSkip (pTimeSkipped:Int, pKarmaSpent:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.TIME_SKIP, {
			timeWaited:pTimeSkipped,
			karmaSpent:pKarmaSpent
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	
	/*public static function sendKarmaResourceBuy (pTimeSkipped:Int, pKarmaSpent:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.TIME_SKIP, {
			amount:pTimeSkipped,
			skipKarmaSpent:pKarmaSpent
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	/*
	public static function sendGainXp (pType:GeneratorType, pAmount:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.GAIN_XP, {
			type:pType.getName(),
			amount:pAmount
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	public static function sendLevelUp ():Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.LEVEL_UP, {
			currentLevel:ResourcesManager.getLevel()
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	/*ambroise-rabier [6:45 PM] 
yo

[6:46]  
1/
a l'event transaction (edited)

[6:46]  
le champs : productSpend

[6:46]  
est manquant ds deltaDNA

[6:47]  
le champs productSpendAmount est un int alros qu'il devrait être un float (oui car si c'est des euros ya des centimes)

[6:47]  
2/
dans l'event collect
productReceived semble être un doublon de productID (edited)

[6:48]  
et je ne sais pas quel ID mettre ? l'id du bâtiment ? l'id du type du bâtiment ? autre chose ?

[6:49]  
3/
dans l'évent internshipChoice
le champs productID semble être un doublon de choiceID

[6:50]  
4/
dans l'event UIinteraction :
tu as mis des majuscules aux paramètres (bon encore cela tant pis cela fonctionnera quand même)
Tes quatres paramètres je ne sais pas quoi mettre dedans. (pas exactement)

ambroise-rabier [6:51 PM] 
added this Haxe snippet
				UIAction: pUIAction, // Close, OpenDescription, ChangeTab, etc, ENUM
				UILocation: pUILocation, // WTF, genre UIPosition.BOTTOM ? ENUM
				UIName: pUIName, // titlecard, shop, pugatory ? ENUM
				UIType: pUIType, // popin, hud, etc ? ENUM
Add Comment

ambroise-rabier [6:52 PM] 
j'ai pensé à cela, mais pour ce dernier event il manque bcp de précision :confused:.

[6:52]  
Si tu peux répondre à ces questions ce serait bien. merci.

[6:56]  
Je voudrais pas perdre ton travail et supprimer des trucs utiles car je ne les ais pas compris :wink: (edited)

leo_gd [8:43 PM] 
Yo,
Je vais commencer par le plus facile

[8:44]  
4) Aucune idée de ce qu'il faut mettre, c'est le prof qui a insisté pour qu'on ait ça

ambroise-rabier [8:44 PM] 
yo

leo_gd [8:44 PM] 
3) si ça te semble pertinent tu peux le supprimer

[8:45]  
2) Ca dépend de la transaction, je ferai une liste quand j'aurai le temps demain (je suis pris ce soir)

[8:45]  
1) Je corrigerai ça demain, quand j'aurai le temps

ambroise-rabier [8:49 PM] 
2) Ca dépend de la transaction, je ferai une liste quand j'aurai le temps demain (je suis pris ce soir)
alors, on est d'accords on parle de l'event collect (quand tu récup de l'argent des buildings), c'est ce que tu appelles transaction ?

Ahh, pour l'event collect, pardon

[8:50]  
Je suppose que ma reflexion c'était productID = bâtiment et productReceived = ressource (edited)
*/
}