package com.isartdigital.perle.game;
	
/**
 * ...
 * @author grenu
 */
class TextGenerator 
{
	
	/**
	 * instance unique de la classe TextGenerator
	 */
	private static var instance: TextGenerator;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TextGenerator {
		if (instance == null) instance = new TextGenerator();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function TraceTest():Void {
		// show test
		var situation:Array<String> = GetNewSituation();
		trace(situation[0]);
		trace("bad -> " + situation[1]);
		trace("good -> " + situation[2]);
	}
	
	/**
	 * Create new intern choice
	 * @return array of 3 texts [situation, badAnswer, goodAnswer]
	 */
	public static function GetNewSituation():Array<String>
	{
		var sentence:String = "";
		
		sentence += QuestDictionnary.intro[Std.random(QuestDictionnary.intro.length - 1)];
		sentence += QuestDictionnary.localisation[Std.random(QuestDictionnary.localisation.length - 1)];
		sentence += QuestDictionnary.intern;
		sentence += QuestDictionnary.internVerbs[Std.random(QuestDictionnary.internVerbs.length - 1)];
		sentence += QuestDictionnary.number[Std.random(QuestDictionnary.number.length - 1)];
		
		var subject:String = QuestDictionnary.subjects[Std.random(QuestDictionnary.subjects.length - 1)];
		var index:Int = 0;
		for (letter in QuestDictionnary.vowel) 
		{
			if (letter == subject.charAt(0)) {
				sentence += QuestDictionnary.preSubject[LetterType.VOYELLE];
				break;
			}
			else {
				if (index >= QuestDictionnary.vowel.length - 1) sentence += QuestDictionnary.preSubject[LetterType.CONSONNE];
			}
			
			index++;
		}
		sentence += subject;
		
		var random:Int = Math.round(Math.random()*10); 
		var actionType:ActionType = (random > 6) ? ActionType.GOOD : ActionType.BAD;
		sentence += QuestDictionnary.actions[actionType][Std.random(QuestDictionnary.actions[actionType].length - 1)];
		
		var secondSubject:String = QuestDictionnary.secondarySubjects[Std.random(QuestDictionnary.secondarySubjects.length - 1)];
		sentence += secondSubject;
		
		var hellAnswer:String = (actionType == ActionType.GOOD) ? "Tuer les " + subject : "Aider les " + subject;
		var edenAnswer:String = (actionType == ActionType.GOOD) ? "Aider les " + subject : "Tuer les " + subject;
		
		var txtArray:Array<String> = [sentence, hellAnswer, edenAnswer];
		
		return txtArray;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}

enum LetterType { VOYELLE; CONSONNE; }
enum ActionType { BAD; GOOD; }

/**
 * QuestDictionnary used for create choice dynamically 
 */
class QuestDictionnary
{
	public static var vowel:Array<String> = ["a", "e", "i", "o", "u", "y"];
	public static var preSubject:Map<LetterType, String> = [LetterType.CONSONNE => "de ", LetterType.VOYELLE => "d'"];
	
	public static var intern:String = "votre stagiaire ";
	
	public static var intro:Array<String> = [
		"A l'entrée d'",
		"Devant ",
		"Au bords d'",
		"Face à ",
		"A la sortie d'",
		"Au milieu d'",
		"Au coeur d'",
		"Dans ",
		"Au fond d'"
	];
	
	public static var localisation:Array<String> = [
		"un tunnel, ",
		"une grotte, ",
		"un lac, ",
		"un village, ",
		"une ferme, ",
		"un champ, ",
		"une forêt, ",
		"un bois, ",
		"une plaine, "
	];
	
	public static var internVerbs:Array<String> = [
		"rencontre ",
		"voit ",
		"apperçoit ",
		"remarque ",
		"entrevoit ",
		"discerne ",
		"distingue ",
		"observe ",
		"surprend ",
		"découvre "
	];
	
	public static var number:Array<String> = [
		"un groupe ",
		"une horde ",
		"une foule ",
		"une tripotée ",
		"un regroupement ",
		"une armée ",
		"un rassemblement ",
		"une petit groupe ",
		"une poignée "
	];
	
	public static var subjects:Array<String> = [
		"guerriers ",
		"paysans ",
		"marchands ",
		"esclaves ",
		"barbares ",
		"médecins ",
		"mort-vivants ",
		"trolls ",
		"orcs ",
		"gobelins "
	];
	
	public static var actions:Map<ActionType, Array<String>> = [
		ActionType.BAD => [
				"brutalisant ",
				"agressant " ,
				"torturant ",
				"combattant ",
				"frappant ",
				"pourchassant ",
				"attaquant " 
			],
		ActionType.GOOD => [
				"soignant ",
				"repoussant ",
				"aidant " 
			]
	];
	
	public static var secondarySubjects:Array<String> = [
		"des archéologues.",
		"des voyageurs.",
		"des touristes.",
		"un vagabond.",
		"des animaux.",
		"des trolls nains.",
		"des crocodiles.",
		"des enfants.",
		"des chasseurs.",
		"des milliciens."
	];
}
