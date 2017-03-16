package com.isartdigital.perle.game.managers;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author de Toffoli Matthias
 */

typedef AdsData = {
	error:String,
	close:String
}

class AdsManager
{

	private static var callBack:String->Void;
	
	public static function playAd(pCallBack:String->Void, ?isPicture = false):Void {
		
		SoundManager.pauseLoop();
		callBack = pCallBack;
		
		if (isPicture) {
			Ads.getImage(stopAd);
		} else {
			Ads.getMovie(stopAd);
		}
	}
	
	private static function stopAd(pData:AdsData):Void {
		SoundManager.playLoop();
		if (pData == null) trace ("Erreur Service");
		else if (pData.error != null) Debug.error(pData.error);
		else callBack(pData.close);
	}
	
}