package com.isartdigital.utils.localisation;
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

	private static var allSprites:Map<String, Dynamic> = new Map<String, String>();
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
		for (label in Reflect.fields(pLocalization)){
			var langage:Dynamic = Reflect.field(pLocalization, label);
			allTraductions[label] = langage.en;
		}
	}
	
	/**
	 * Return the values for the label asked
	 * @param	pLabel
	 * @return the french or english translation
	 */
	public static function getText(pLabel:String):String{
		if (allTraductions[pLabel] == null) {
			Debug.error("This label doesn't exist!");
			return "null";
		}
		else return allTraductions[pLabel];
	}
	
	/**
	 * Function whitch switchs the langage
	 * @param pLangage: la langue qu'on souhaite avoir
	 */
	
	public static function traduction(?pLangage:String = "en"):Void {
		
		for (label in Reflect.fields(localization)){
			var langage:Dynamic = Reflect.field(localization, label);
			if (pLangage == "fr") allTraductions[label] = langage.fr;
			else allTraductions[label] = langage.en;
		}
	}

}
