package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypePack;
import com.isartdigital.perle.game.TimesInfo.TimesAndNumberDays;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;

typedef Campaign = {
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
	private static var numberAdMen:Int;
	private static var campaigns:Map<CampaignType,Campaign>;
	private static var currentCampaign:CampaignType;
	private static inline var NUMBERADMENFACTOR:Int = 2;
	private static var arrayCampaignType:Array<CampaignType> = [CampaignType.ad, CampaignType.small, CampaignType.medium, CampaignType.large];
	
	public static function awake():Void {
		
		numberAdMen = 0;
		currentCampaign = CampaignType.none;
		var lArray:Array<TableTypePack> = GameConfig.getBuildingPack(GeneratorType.soul);
		campaigns = [
			CampaignType.none => {
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
				price:lArray[i].costKarma == null ? 0:lArray[i].costKarma,
				time: {
					times: TimesInfo.getTimeInMilliSecondFromTimeStamp(diff.times),
					days:diff.days
				},
				boost:lArray[i].gainFluxSouls
			}
		}
	}
	
	public static function increaseNumberAdMen():Void {
		numberAdMen++;
		updateTribunal();
	}
	
	public static function decreaseNumberAdMen():Void {
		numberAdMen--;
		updateTribunal();
	}
	
	public static function setCampaign(pType:CampaignType):Void {
		currentCampaign = pType;
		TimeManager.setCampaignTime(campaigns[currentCampaign].time.times);
		updateTribunal();
	}
	
	public static function getCampaignByIndice(i:Int):Campaign {
		
		return campaigns[arrayCampaignType[i]];
		

	}
	
	public static function getCurrentCampaign():Campaign {
		return campaigns[currentCampaign];
	}
	
	public static function isInCampaign():Bool {
		return !(currentCampaign == CampaignType.none);
	}
	
	private static function updateTribunal():Void {
		//trace(1 + (NUMBERADMENFACTOR + campaigns[currentCampaign].boost) * numberAdMen);
		VTribunal.getInstance().updateGenerator(1 + (NUMBERADMENFACTOR + campaigns[currentCampaign].boost) * numberAdMen); 
	}
	
}