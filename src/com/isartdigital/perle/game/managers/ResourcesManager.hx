package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ResourcesManager.GeneratorGoodXp;
import com.isartdigital.perle.game.managers.ResourcesManager.GeneratorSoft;
import haxe.rtti.CType.Typedef;

/**
 * ...
 * @author de Toffoli Matthias
 */

 /*
  * @TODO voir si on gére le level up ici ou ailleur
  * @TODO rajouter des @optional sur les param pour mieux factoriser le code
  * @TODO rajouter des enum pour les alignements
  * */
 
 enum Alignment{neutral; hell; paradise; }
 //{ ################# typedef #################
 
 //typedef for save contain all data resources
 typedef ResourcesData = {
	 //Array that represents the on going ressources of each buildings
	var  generatorSoftArray:Array<GeneratorSoft>;
	var  generatorHardArray:Array<GeneratorHard>;
	var  generatorSoulArray:Array<GeneratorSoul>;
	var  internArray:Array<Intern>;
	var  generatorGoodXpArray:Array<GeneratorGoodXp>;
	var  generatorBadXpArray:Array<GeneratorBadXp>;
	
	//Total value of some resources
	var totalSoft:Int;
	var totalHard:Int;
	var totalGoodXp:Int;
	var totalBadXp:Int;
	
 }
 //quantity = quantity actual of the instance, max = max which can have
 typedef GeneratorSoft = {
	var quantity:Int;
	var max:Int;
	var id:Int;
 }
 //quantity = quantity actual of the instance, max = max which can have
 typedef GeneratorHard = {
	var quantity:Int;
	var max:Int;
	var id:Int;
 }
 //quantity = quantity actual of the instance, max = max which can have
 typedef GeneratorGoodXp = {
	var quantity:Int;
	var max:Int;
	var id:Int;
 }
 //quantity = quantity actual of the instance, max = max which can have
 typedef GeneratorBadXp = {
	var quantity:Int;
	var max:Int;
	var id:Int;
 }
 //quantity = quantity actual of the instance, max = max which can have
 typedef GeneratorSoul = {
	 var quantity:Int;
	 var max:Int;
	@:optional var alignment:Alignment;
	 var id:Int;
 }
 //quantity = quantity actual of the instance's stress, max = max which can have
 typedef Intern = {
	 var quantity:Int;
	 var max:Int;
	@:optional var alignment:Alignment;
	 var id:Int;
 }
 //} endregion
 
class ResourcesManager
{
	/*
	 ####################
	 ####################
	 ####################
	 */
 
	//initialisation of data + get
	 //{ ################# data #################
	private static var myResourcesData:ResourcesData;
	
	public static function initWithoutSave():Void{

	myResourcesData = {

			generatorSoftArray:new Array<GeneratorSoft>(),
			generatorHardArray:new Array<GeneratorHard>(),
			generatorSoulArray:new Array<GeneratorSoul>(),
			internArray:new Array<Intern>(),
			generatorGoodXpArray:new Array<GeneratorGoodXp>(),
			generatorBadXpArray:new Array<GeneratorBadXp>(),

			totalSoft:0,
			totalHard:0,
			totalGoodXp:0,
			totalBadXp:0

		}
	}
	
	public static function initWithLoad(resourcesDataLoad:ResourcesData):Void{
		myResourcesData = resourcesDataLoad;
	}
	
	public static function getResourcesData():ResourcesData{
		return myResourcesData;
	 
	}
	//}endregion
	
	

	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for add soft, hard currency, or xp in there own array
	//{ ################# addCurrency #################
	
	public static function addSoftGenerator(pId:Int, pMax:Int):GeneratorSoft{
		var myGenerator:GeneratorSoft = testHaveThisGenerator(pId, myResourcesData.generatorSoftArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.generatorSoftArray, pMax);
		return myResourcesData.generatorSoftArray[myResourcesData.generatorSoftArray.length - 1];
	}
	
	public static function addHardGenerator(pId:Int, pMax:Int):GeneratorHard {
		
		var myGenerator:GeneratorHard = testHaveThisGenerator(pId, myResourcesData.generatorHardArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.generatorHardArray, pMax);
		return myResourcesData.generatorHardArray[myResourcesData.generatorHardArray.length - 1];
	}
	
	public static function addGoodXpGenerator(pId:Int, pMax:Int):GeneratorGoodXp {
		
		var myGenerator:GeneratorGoodXp = testHaveThisGenerator(pId, myResourcesData.generatorGoodXpArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.generatorGoodXpArray, pMax);
		return myResourcesData.generatorGoodXpArray[myResourcesData.generatorGoodXpArray.length - 1];
	}
	
	public static function addBadXpGenerator(pId:Int, pMax:Int):GeneratorBadXp {
		
		var myGenerator:GeneratorBadXp = testHaveThisGenerator(pId, myResourcesData.generatorBadXpArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.generatorBadXpArray, pMax);
		return myResourcesData.generatorBadXpArray[myResourcesData.generatorBadXpArray.length - 1];
	}
	
	public static function addSoulGenerator(pId:Int, pMax:Int, pAlignment:Alignment):GeneratorSoul{
		
		var myGenerator:GeneratorSoul = testHaveThisGenerator(pId, myResourcesData.generatorSoulArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.generatorSoulArray, pMax);
		myResourcesData.generatorSoulArray[myResourcesData.generatorSoulArray.length - 1].alignment = pAlignment;
		SaveManager.save();
		return myResourcesData.generatorSoulArray[myResourcesData.generatorSoulArray.length - 1];
	}
	
	public static function addIntern(pId:Int, pMax:Int, pAlignment:Alignment):Intern{
		
		var myGenerator:Intern = testHaveThisGenerator(pId, myResourcesData.internArray);
		
		if (myGenerator != null) return myGenerator;
		
		addResourcesGenerator(pId, myResourcesData.internArray,  pMax);
		myResourcesData.internArray[myResourcesData.internArray.length - 1].alignment = pAlignment;
		SaveManager.save();
		return myResourcesData.internArray[myResourcesData.internArray.length - 1];
	}
	
	//current array = array of resources we want, pMax = max value to the resources which we want
	private static function addResourcesGenerator(pId:Int, currencyArray:Array<Dynamic>, pMax:Int):Void{
		
		currencyArray.push({
				quantity: 0,
				max: pMax,
				id: pId
			}
		);
		
		SaveManager.save();
		
	}
	
	
	//} endregion
	

	//test if a generator with this id exist and return the generator
	private static function testHaveThisGenerator(pId:Int, resourcesArray:Array<Dynamic>):Dynamic{
		var lLength:Int = resourcesArray.length - 1, i;
		
		for (i in 0...lLength) if (resourcesArray[i].id == pId) return resourcesArray[i];
		
		return null;
	}
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for change alignment of soul or intern
	//{ ################# changeAlignment #################
	
	
	public static function changeSoulAlignment(pSoul:GeneratorSoul, pAlignment:Alignment):Void {
		changeAlignment(myResourcesData.generatorSoulArray, myResourcesData.generatorSoulArray.indexOf(pSoul), pAlignment);
	}
	
	public static function changeInternAlignment(pIntern:Intern, pAlignment:Alignment):Void {
		changeAlignment(myResourcesData.internArray, myResourcesData.internArray.indexOf(pIntern), pAlignment);
	}
	
	private static function changeAlignment(peopleArray:Array<Dynamic>, indice:Int, pAlignment:Alignment):Void {
		peopleArray[indice].alignment = pAlignment;
	
		SaveManager.save();
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for count a resource if her value is lower her max
	//{ ################# countResources #################
	public static function increaseSoftCurrency(pSoftGenerator:GeneratorSoft):Void{
		increaseResources(myResourcesData.generatorSoftArray, myResourcesData.generatorSoftArray.indexOf(pSoftGenerator));
	}
	
	public static function increaseHardCurrency(pHardGenerator:GeneratorHard):Void{
		increaseResources(myResourcesData.generatorHardArray, myResourcesData.generatorHardArray.indexOf(pHardGenerator));
	}
	
	public static function increaseSoul(pSoulGenerator:GeneratorSoul):Void{
		increaseResources(myResourcesData.generatorSoulArray, myResourcesData.generatorSoulArray.indexOf(pSoulGenerator));
	}
	
	public static function increaseInternStress(pIntern:Intern):Void{
		increaseResources(myResourcesData.internArray, myResourcesData.internArray.indexOf(pIntern));
	}
	
	public static function increaseGoodXp(pGoodXpGenerator:GeneratorGoodXp):Void{
		increaseResources(myResourcesData.generatorGoodXpArray, myResourcesData.generatorGoodXpArray.indexOf(pGoodXpGenerator));
	}
	
	public static function increaseBadXp(pBadXpGenerator:GeneratorBadXp):Void{
		increaseResources(myResourcesData.generatorBadXpArray, myResourcesData.generatorBadXpArray.indexOf(pBadXpGenerator));
	}
	
	private static function increaseResources(resourcesArray:Array<Dynamic>, indice:Int):Void{
		
		resourcesArray[indice].quantity = Math.min(resourcesArray[indice].quantity + 1,resourcesArray[indice].max);
		SaveManager.save();
	}
	//} endregion
	
	/*
	 ####################
	 ####################
	 ####################
	 */
	 
	//functions for remove a resource in is own array
	//{ ################# removeGenerator #################
	public static function removeSoftGenerator(pSoftGenerator:GeneratorSoft):Void{
		removeGenerator(myResourcesData.generatorSoftArray, myResourcesData.generatorSoftArray.indexOf(pSoftGenerator));
	}
	
	public static function removeHardGenerator(pHardGenerator:GeneratorHard):Void{
		removeGenerator(myResourcesData.generatorHardArray, myResourcesData.generatorHardArray.indexOf(pHardGenerator));
	}
	
	public static function removeSoulGenerator(pSoulGenerator:GeneratorSoul):Void{
		removeGenerator(myResourcesData.generatorSoulArray, myResourcesData.generatorSoulArray.indexOf(pSoulGenerator));
	}
	
	public static function removeIntern(pIntern:Intern):Void{
		removeGenerator(myResourcesData.internArray, myResourcesData.internArray.indexOf(pIntern));
	}
	
	public static function removeGoodXp(pGoodXpGenerator:GeneratorGoodXp):Void{
		removeGenerator(myResourcesData.generatorGoodXpArray, myResourcesData.generatorGoodXpArray.indexOf(pGoodXpGenerator));
	}
	
	public static function removeBadXp(pBadXpGenerator:GeneratorBadXp):Void{
		removeGenerator(myResourcesData.generatorBadXpArray, myResourcesData.generatorBadXpArray.indexOf(pBadXpGenerator));
	}
	
	private static function removeGenerator(resourcesArray:Array<Dynamic>, indice:Int):Void{
		
		resourcesArray.splice(indice, 1);
		SaveManager.save();
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
	public static function takeBadXp(pBadXp:GeneratorBadXp){
		takeResources(myResourcesData.generatorBadXpArray, myResourcesData.generatorBadXpArray.indexOf(pBadXp), myResourcesData.totalBadXp);
	}
	
	public static function takeGoodXp(pGoodXp:GeneratorGoodXp){
		takeResources(myResourcesData.generatorGoodXpArray, myResourcesData.generatorGoodXpArray.indexOf(pGoodXp), myResourcesData.totalGoodXp);
	}
	
	public static function takeHard(pHard:GeneratorHard){
		takeResources(myResourcesData.generatorHardArray, myResourcesData.generatorHardArray.indexOf(pHard), myResourcesData.totalHard);
	}
	
	public static function takeSoft(pSoft:GeneratorSoft){
		takeResources(myResourcesData.generatorSoftArray, myResourcesData.generatorSoftArray.indexOf(pSoft), myResourcesData.totalSoft);
	}
	
	private static function takeResources(resourcesArray:Array<Dynamic>, indice:Int, total:Int):Void{
		sumTotal(resourcesArray[indice].quantity, total);
		reset(resourcesArray, indice);
		SaveManager.save();
	}
	public static function sumTotal(sumValue:Int, total:Int):Void{
		total += sumValue;
		
	}
	//} endregion
	
	//{ ################# spend and reinit#################
	public static function spendTotal(spendValue:Int, total:Int):Void{
		total -= spendValue;
		SaveManager.save();
	}
	
	public static function reset(resourcesArray:Array<Dynamic>, indice:Int){
		resourcesArray[indice].quantity = 0;
	}
	public static function reinit():Void{
		myResourcesData.totalBadXp = 0;
		myResourcesData.totalGoodXp = 0;
	}
	//}endregion
	
	
	//} endregion
	
}