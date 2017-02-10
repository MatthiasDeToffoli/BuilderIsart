package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.events.KeyboardEventType;
import com.isartdigital.utils.localisation.Localisation;
import js.Browser;
import js.html.KeyboardEvent;

/**
 * ...
 * @author de Toffoli Matthias
 */
class GodMode
{

	private static var isGod:Bool;
	
	public static function awake():Void {
		isGod = false;
		Browser.window.addEventListener(KeyboardEventType.KEY_UP, onKeyDown);
	}
	
	private static function onKeyDown(pEvent:KeyboardEvent){
		if (!isGod) {
			if (pEvent.key == "g") {
				isGod = true;
				Browser.window.alert("God Mode Activate : \n tap 1 for levelup \n tap 2 for gain soft \n tap 3 for gain hard \n tap 4 for gain stone \n tap 5 for gain wood \n tap 6 to set langage in french \n tap 7 to set langage in english");	
			}
		}
		else {
			if (pEvent.key == "g") {
				isGod = false;
				Browser.window.alert("God Mode unactivate");
			}	
			else if (pEvent.key == '&' || pEvent.key == "1") ResourcesManager.levelUp();
			else if (pEvent.key == 'é' || pEvent.key == "2") ResourcesManager.gainResources(GeneratorType.soft, 20000);
			else if (pEvent.key == '"' || pEvent.key == "3") ResourcesManager.gainResources(GeneratorType.hard, 20000);
			else if (pEvent.key == "'" || pEvent.key == "4") ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, 20000);
			else if (pEvent.key == '(' || pEvent.key == "5") ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, 20000);	
			else if (pEvent.key == '-' || pEvent.key == "6") Localisation.traduction("fr");	
			else if (pEvent.key == 'è' || pEvent.key == "7") Localisation.traduction("en");	
		}
	}
}