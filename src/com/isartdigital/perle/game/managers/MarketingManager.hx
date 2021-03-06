package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypePack;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.TimesInfo.TimesAndNumberDays;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;

typedef Campaign = {
	var name:String;
	var price:Int;
	var time:TimesAndNumberDays;
	var boost:Int;
}

enum CampaignType {none; ad; small; medium; large; }
/**
 * ...
 * @author de Toffoli Matthias
 */
class MarketingManager
{
	/**
	 * number of VMarketing house
	 */
	private static var marketingProd:Float;
	private static var numberAdMen:Int;
	private static var campaigns:Map<CampaignType,Campaign>;
	private static var currentCampaign:CampaignType;
	private static inline var NUMBERADMENFACTOR:Int = 2;
	private static var arrayCampaignType:Array<CampaignType> = [CampaignType.ad, CampaignType.small, CampaignType.medium, CampaignType.large];
	public static var tribunalIsCreated:Bool;
	
	public static function awake():Void {
		
		numberAdMen = 0;
		currentCampaign = CampaignType.none;
		var lArray:Array<TableTypePack> = GameConfig.getBuildingPack(GeneratorType.soul);
		campaigns = [
			CampaignType.none => {
				name:"",
				price:0,
				time:{
					times:0,
					days:0
				},
				boost:0
			}
		];
		
		var i:Int, l:Int = arrayCampaignType.length;
		var diff:TimesAndNumberDays;
		
		for (i in 0...l) {
			diff = TimesInfo.calculDateDiff(Date.fromString(lArray[i].time).getTime(), Date.fromTime(0).getTime());
			
			campaigns[arrayCampaignType[i]] = {
				name:lArray[i].name,
				price:lArray[i].costKarma == null ? 0:lArray[i].costKarma,
				time: {
					times: TimesInfo.getTimeInMilliSecondFromTimeStamp(diff.times),
					days:diff.days
				},
				boost:lArray[i].gainFluxSouls
			}
		}
		
		tribunalIsCreated = false;
		marketingProd = GameConfig.getBuildingByName('Marketing Department', 1).productionPerHour;
	}
	
	public static function getCampaignByName(pName:String):String {
		var i:Int, l:Int = arrayCampaignType.length;
		
		for (i in 0...l)	
			if (campaigns[arrayCampaignType[i]].name == pName)
				return arrayCampaignType[i].getName();
			
		return CampaignType.none.getName();
	}
	
	public static function setCurrentCampaign(pName:String):Void {
		switch(pName) {
			case "ad" :
				currentCampaign = CampaignType.ad;
				
			case "small" :
				currentCampaign = CampaignType.small;
				
			case "medium" :
				currentCampaign = CampaignType.medium;
				
			case "large" :
				currentCampaign = CampaignType.large;
				
			default :
				currentCampaign = CampaignType.none;
		}
	}
	
	public static function setTribunalCreated():Void {
		tribunalIsCreated = true;
		updateTribunal();
	}
	
	public static function increaseNumberAdMen():Void {
		numberAdMen++;
		if(tribunalIsCreated) updateTribunal();
	}
	
	public static function decreaseNumberAdMen():Void {
		numberAdMen--;
		if(tribunalIsCreated) updateTribunal();
	}
	
	public static function setCampaign(pType:CampaignType):Void {
		currentCampaign = pType;
		TimeManager.setCampaignTime(campaigns[currentCampaign].time.times);
		ResourcesManager.spendTotal(GeneratorType.hard, campaigns[currentCampaign].price);
		if (currentCampaign != CampaignType.none) ServerManagerBuilding.startCampaign(campaigns[currentCampaign].name);
		updateTribunal();
	}
	
	public static function getCampaignByIndice(i:Int):Campaign {
		
		return campaigns[arrayCampaignType[i]];
		

	}
	
	public static function getCurrentCampaign():Campaign {
		return campaigns[currentCampaign];
	}
	
	public static function getCurrentCampaignType():CampaignType {
		return currentCampaign;
	}
	
	public static function isInCampaign():Bool {
		return !(currentCampaign == CampaignType.none);
	}
	
	public static function getProdBoost():Float {
		
		var sum1:Float = numberAdMen * marketingProd;

		var sum2:Float = campaigns[currentCampaign].boost; 
		return sum1 + sum2;
	}
	
	private static function updateTribunal():Void {
		VTribunal.getInstance().updateGenerator(); 
	}
	
}