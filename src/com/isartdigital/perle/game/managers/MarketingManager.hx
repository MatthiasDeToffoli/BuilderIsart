package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.TimesInfo.TimesAndNumberDays;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;

typedef Campaign = {
	var time:TimesAndNumberDays;
	var boost:Int;
}

enum CampaignType {none; small; medium; large; }
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
	
	public static function awake():Void {
		
		numberAdMen = 0;
		currentCampaign = CampaignType.none;
		
		/*campaigns = [
			CampaignType.none => {
				time:0,
				boost:0
			},
			CampaignType.small => {
				time:30 * TimesInfo.SEC,
				boost:2
			},
			CampaignType.medium => {
				time: TimesInfo.MIN,
				boost:4
			},
			CampaignType.large => {
				time: TimesInfo.MIN,
				boost:6
			}
		];*/
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
		
		switch (i) {
			case 0:
				return campaigns[CampaignType.none];
				
			case 1:
				return campaigns[CampaignType.small];
				
			case 2:
				return campaigns[CampaignType.medium];
				
			case 3:
				return campaigns[CampaignType.large];
				
			default :
				return campaigns[CampaignType.none];
		}
		

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