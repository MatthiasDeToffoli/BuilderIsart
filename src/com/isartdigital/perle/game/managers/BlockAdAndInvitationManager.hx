package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.TimesForBlocked;
import com.isartdigital.utils.Debug;


/**
 * enum said the which call the function 
 */
enum Provenance {tribunal; shop; marketing; }
/**
 * manage the blocage of ads movie and invite soul
 * @author de Toffoli Matthias
 */
class BlockAdAndInvitationManager
{

	/**
	 * time before we can invite a soul
	 */
	private static var timeForInviteSoul:Float;
	
	/**
	 * time before we can see an ad in shop
	 */
	private static var timeForStartAdInShop:Float;
	
	/**
	 * time before we can see an ad in marketing
	 */
	private static var timeForStartAdInMarketing:Float;
	
	/**
	 * initialisation of the class
	 */
	public static function awake() {
		timeForInviteSoul = 0;
		timeForStartAdInMarketing = 0;
		timeForStartAdInShop = 0;
	}
	
	public static function updateFromSave(pTimesForBlocked:TimesForBlocked):Void {
		timeForInviteSoul = pTimesForBlocked.tribunal == null ? 0:pTimesForBlocked.tribunal;
		timeForStartAdInMarketing = pTimesForBlocked.marketing == null ? 0:pTimesForBlocked.marketing;
		timeForStartAdInShop = pTimesForBlocked.shop == null ? 0:pTimesForBlocked.shop;
	}
	
	/**
	 * said if an element is blocked in function of the provenance
	 * @param	pProvenance said which call the function
	 * @return true if it's not block false else
	 */
	public static function canI(pProvenance:Provenance):Bool {
		switch(pProvenance) {
			case Provenance.marketing:
				return Date.now().getTime() > timeForStartAdInMarketing;
				
			case Provenance.shop:
				return Date.now().getTime() > timeForStartAdInShop;
				
			case Provenance.tribunal:
				return Date.now().getTime() > timeForInviteSoul;
				
			default:
				Debug.warn('provenance not know');
				return true;
		}		
	}
	
	/**
	 * set a time on the good block timer
	 * @param	pProvenance said which call the function
	 * @param	pTime the time to set
	 */
	public static function setTime(pProvenance:Provenance, pTime:Float):Void {
		switch(pProvenance) {
			case Provenance.marketing:
				timeForStartAdInMarketing = pTime;
				
			case Provenance.shop:
				timeForStartAdInShop = pTime;
				
			case Provenance.tribunal:
				timeForInviteSoul = pTime;
				
			default:
				Debug.warn('provenance not know');
		}		
	}
	
	/**
	 * block an element for one day
	 * @param	pProvenance pProvenance said which call the function
	 */
	public static function blockForOneDay(pProvenance:Provenance):Void {
		setTime(pProvenance, Date.now().getTime() + TimesInfo.DAY);	
	}
	
}