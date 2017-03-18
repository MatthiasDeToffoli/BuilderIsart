package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.popin.Cancel_Video;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.sounds.SoundManager;


/**
 * data sends on callback ads functions
 * @author de Toffoli Matthias
 */
typedef AdsData = {
	error:String,
	close:String
}

/**
 * gestion of ads element
 * @author de Toffoli Matthias
 */
class AdsManager
{
	/**
	 * callback called when we finished to see a video
	 */
	private static var callBack:Void->Void;
	
	/**
	 * counter said if we play a picture ad
	 */
	private static var counter:Int;
	
	/**
	 * min level before started to increment the counter
	 */
	private static inline var LEVELBEFORESTARTCOUNT:Int = 3;
	
	/**
	 * max value counter can take
	 */
	private static inline var MAXCOUNTERVALUE:Int = 3;
	
	/**
	 * value for play a picture ad
	 */
	private static inline var COUNTERVALUEFORPLAYAD:Int = 2;
	
	/**
	 * string said if the ad is closed begore video finished
	 */
	public static inline var CLOSEVIDEONOTFINISH:String = 'cancel';
	
	/**
	 * string said if the ad is closed when video is finished
	 */
	public static inline var CLOSEVIDEOFINISH:String = 'close';
	
	/**
	 * error send when the ad not send a data
	 */
	public static inline var ERRORSERVICE:String = 'Erreur service : aucun objet envoyé dans la fonction callback voir AdsManager fonction stopAd';
	
	/**
	 * initialisation of the class
	 */
	public static function awake():Void {
		counter = 0;
	}
	
	/**
	 * lunch a ad
	 * @param	pCallBack the callback call after see the ad
	 * @param	isPicture = false a boolean said if it's a picture or a video
	 */
	public static function playAd(pCallBack:Void->Void, ?isPicture = false):Void {
		
		SoundManager.pauseLoop();
		callBack = pCallBack;
		
		if (isPicture) {
			Ads.getImage(stopAd);
		} else {
			Ads.getMovie(stopAd);
		}
	}
	
	/**
	 * increment the counter if it equal to COUNTERVALUEFORPLAYAD lunch a picture ad 
	 */
	public static function playAdPictureWithCounter():Void {
		if (ResourcesManager.getLevel() > LEVELBEFORESTARTCOUNT && counter < MAXCOUNTERVALUE) {
			counter++;
			
			if (counter == COUNTERVALUEFORPLAYAD) playAd(function(){}, true);
		}
	}
	
	/**
	 * callback called every time we play a ad
	 * @param	pData object returned by ad
	 */
	private static function stopAd(pData:AdsData):Void {
		SoundManager.playLoop();
		if (pData == null) trace (ERRORSERVICE);
		else if (pData.error != null) Debug.error(pData.error);
		else if (pData.close == CLOSEVIDEONOTFINISH) UIManager.getInstance().openPopin(Cancel_Video.getInstance());
		else if(pData.close == CLOSEVIDEOFINISH) callBack();
	}
	
}