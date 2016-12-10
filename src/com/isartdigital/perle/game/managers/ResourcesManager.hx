package com.isartdigital.perle.game.managers;
import haxe.rtti.CType.Typedef;

/**
 * ...
 * @author de Toffoli Matthias
 */

 /*
  * @TODO gérer le local storage
  * @TODO voir si on gére le level up ici ou ailleur
  * */
 
 
 //{ ################# typedef #################
 //number = number actual of the instance, max = max which can have
 typedef Soft = {
	var number:Int;
	var max:Int;
 }
 //number = number actual of the instance, max = max which can have
 typedef Hard = {
	var number:Int;
	var max:Int;
 }
 //number = number actual of the instance, max = max which can have
 typedef GoodXp = {
	var number:Int;
	var max:Int;
 }
 //number = number actual of the instance, max = max which can have
 typedef BadXp = {
	var number:Int;
	var max:Int;
 }
 //number = number actual of the instance, max = max which can have
 typedef Soul = {
	 var number:Int;
	 var max:Int;
	 var alignment:String;
 }
 //number = number actual of the instance's stress, max = max which can have
 typedef Intern = {
	 var number:Int;
	 var max:Int;
	 var alignment:String;
 }
 //} endregion
 
class ResourcesManager
{
 
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//Array that represents the on going ressources of each buildings
	//{ ################# addCurrency #################
	private static var  softArray:Array<Soft> = new Array<Soft>();
	private static var  hardArray:Array<Hard> = new Array<Hard>();
	private static var  soulArray:Array<Soul> = new Array<Soul>();
	private static var  internArray:Array<Intern> = new Array<Intern>();
	private static var  goodXpArray:Array<GoodXp> = new Array<GoodXp>();
	private static var  badXpArray:Array<BadXp> = new Array<BadXp>();
	//} endregion
	
	/*
	 ####################
	 ####################
	 #################### 
	 */
	 
	 //Total value of some resources
	 //{ ################# total #################
	public static var totalSoft:Int = 0;
	public static var totalHard:Int = 0;
	public static var totalGoodXp:Int = 0;
	public static var totalBadXp:Int = 0;
	 //} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for add soft, hard currency, or xp in there own array
	//{ ################# addCurrency #################
	
	public static function addSoftCurrency(pMax:Int):Void{
		addCurrency(softArray, pMax);
	}
	
	public static function addHardCurrency( pMax:Int):Void {
		addCurrency(hardArray, pMax);
	}
	
	public static function addGoodXp(pMax:Int):Void {
		addCurrency(goodXpArray, pMax);
	}
	
	public static function addBadXp(pMax:Int):Void {
		addCurrency(badXpArray, pMax);
	}
	//current array = array of resources we want, pMax = max value to the resources which we want
	private static function addCurrency(currencyArray:Array<Dynamic>, pMax:Int):Void{
		
		currencyArray.push(
			{
				number: 0,
				max: pMax
			}
		);
		
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for add soul or intern in there own array
	//{ ################# addPeople #################
	
	
	public static function addSoul(pMax:Int, pAlignment:String):Void{
		addPeople(soulArray, pMax, pAlignment);
	}
	
	public static function addIntern(pMax:Int, pAlignment:String):Void{
		addPeople(internArray,  pMax, pAlignment);
	}
	
	private static function addPeople(peopleArray:Array<Dynamic>, pMax:Int, pAlignment:String):Void{
		peopleArray.push(
			{
				number:0,
				max:pMax,
				alignment:pAlignment
			}
		);
	}
	//} endregion
	
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for change alignment of soul or intern
	//{ ################# changeAlignment #################
	
	
	public static function changeSoulAlignment(pSoul:Soul, pAlignment:String):Void{
		changeAlignment(soulArray, soulArray.indexOf(pSoul), pAlignment);
	}
	
	public static function changeInternAlignment(pIntern:Intern, pAlignment:String):Void{
		changeAlignment(internArray, internArray.indexOf(pIntern), pAlignment);
	}
	
	private static function changeAlignment(peopleArray:Array<Dynamic>, indice:Int, pAlignment:String):Void{
		peopleArray[indice].alignment = pAlignment;
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for count a resource if her value is lower her max
	//{ ################# countResources #################
	public static function countSoftCurrency(pSoft:Soft):Void{
		countResources(softArray, softArray.indexOf(pSoft));
	}
	
	public static function countHardCurrency(pHard:Hard):Void{
		countResources(hardArray, hardArray.indexOf(pHard));
	}
	
	public static function countSoul(pSoul:Soul):Void{
		countResources(soulArray, soulArray.indexOf(pSoul));
	}
	
	public static function countIntern(pIntern:Intern):Void{
		countResources(internArray, internArray.indexOf(pIntern));
	}
	
	public static function countGoodXp(pIntern:Intern):Void{
		countResources(goodXpArray, internArray.indexOf(pIntern));
	}
	
	public static function countBadXp(pIntern:Intern):Void{
		countResources(badXpArray, internArray.indexOf(pIntern));
	}
	
	private static function countResources(resourcesArray:Array<Dynamic>, indice:Int):Void{
		
		if (resourcesArray[indice].number < resourcesArray[indice].max) resourcesArray[indice].number++;
		
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for remove a resource in is own array
	//{ ################# removeResources #################
	public static function removeSoftCurrency(pSoft:Soft):Void{
		removeResources(softArray, softArray.indexOf(pSoft));
	}
	
	public static function removeHardCurrency(pHard:Hard):Void{
		removeResources(hardArray, hardArray.indexOf(pHard));
	}
	
	public static function removeSoul(pSoul:Soul):Void{
		removeResources(soulArray, soulArray.indexOf(pSoul));
	}
	
	public static function removeIntern(pIntern:Intern):Void{
		removeResources(internArray, internArray.indexOf(pIntern));
	}
	
	public static function removeGoodXp(pIntern:Intern):Void{
		removeResources(goodXpArray, internArray.indexOf(pIntern));
	}
	
	public static function removeBadXp(pIntern:Intern):Void{
		removeResources(badXpArray, internArray.indexOf(pIntern));
	}
	
	private static function removeResources(resourcesArray:Array<Dynamic>, indice:Int):Void{
		
		resourcesArray.splice(indice, 1);
		
	}
	//} endregion
	

	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for use or add total resources
	//{ ################# totals function #################
	
	//{ ################# sum #################
	public static function takeBadXp(pBadXp:BadXp){
		takeResources(badXpArray, badXpArray.indexOf(pBadXp), totalBadXp);
	}
	
	public static function takeGoodXp(pGoodXp:GoodXp){
		takeResources(goodXpArray, goodXpArray.indexOf(pGoodXp), totalGoodXp);
	}
	
	public static function takeHard(pHard:Hard){
		takeResources(hardArray, hardArray.indexOf(pHard), totalHard);
	}
	
	public static function takeSoft(pSoft:Soft){
		takeResources(softArray, softArray.indexOf(pSoft), totalSoft);
	}
	
	private static function takeResources(resourcesArray:Array<Dynamic>, indice:Int, total:Int):Void{
		sumTotal(resourcesArray[indice].number, total);
	}
	public static function sumTotal(sumValue:Int, total:Int):Void{
		total += sumValue;
	}
	//} endregion
	
	//{ ################# spend and reinit#################
	public static function spendTotal(spendValue:Int, total:Int):Void{
		total -= spendValue;
	}
	
	public static function reinit():Void{
		totalBadXp = 0;
		totalGoodXp = 0;
	}
	//}endregion
	
	
	//} endregion
	
}