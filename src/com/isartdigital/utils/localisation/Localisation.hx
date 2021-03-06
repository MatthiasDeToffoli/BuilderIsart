package com.isartdigital.utils.localisation;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.loader.GameLoader;
import haxe.xml.Fast;

/**
 * Class for the traductions
 * @author Emeline Berenguier
 */
class Localisation
{	
	private static var instance:Localisation;
	
	private static var localization:Dynamic;
	
	private static var allTraductions:Map<String, String> = new Map<String, String>();	//Tableau associatif pour stocker toutes les traductions
	
	public static var actualLanguage:String = "en";
	
	public static var userLanguage:String = ENGLISH_FB; //Set a basic value
	
	public static inline var FRENCH_FB:String = "fr_FR";
	public static inline var ENGLISH_FB:String = "en_GB";
	
	 /**
     * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
     * @return instance unique
     */
    public static function getInstance (): Localisation {
        if (instance == null) instance = new Localisation();
        return instance;
    }
   
	
	public function new() 
	{
		
	}
	
	public static function init(pLocalization:Dynamic):Void{
		localization = pLocalization;
		userLanguage == FRENCH_FB ? actualLanguage = "fr" : actualLanguage = "en";
		
		for (label in Reflect.fields(pLocalization)){
			var langage:Dynamic = Reflect.field(pLocalization, label);
			userLanguage == FRENCH_FB ? allTraductions[label] = langage.fr : allTraductions[label] = langage.en;
		}
	}
	
	public static function setUserLanguage():Void{
		Facebook.api(Facebook.uid+"?fields=locale", onLanguage);
	}
	
	private static function onLanguage(pResponse:Dynamic):Void{
		trace(pResponse.locale);
		if (pResponse != null) userLanguage = pResponse.locale;
	}
	
	/**
	 * Return the values for the label asked
	 * @param	pLabel
	 * @return the french or english translation
	 */
	public static function getText(pLabel:String):String{
		if (allTraductions[pLabel] == null) {
			Debug.error("This label doesn't exist!");
			return pLabel;
		}
		else return allTraductions[pLabel];
	}
	
	/**
	 * Function whitch switchs the langage
	 * @param pLangage: la langue qu'on souhaite avoir
	 */
	
	public static function traduction(?pLangage:String = "en"):Void {
		actualLanguage = pLangage;
		
		for (label in Reflect.fields(localization)){
			var langage:Dynamic = Reflect.field(localization, label);
			if (pLangage == "fr") allTraductions[label] = langage.fr;
			else allTraductions[label] = langage.en;
		}
	}
	
	public static function getLanguage():String {
		return actualLanguage;
	}

}
