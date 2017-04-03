package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableDailyReward;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerFile;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.popin.DailyRewardPopin;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Popin;

	
/**
 * ...
 * @author COQUERELLE Killian
 */
class DailyRewardManager 
{
	
	/**
	 * instance unique de la classe DailyRewardManager
	 */
	private static var instance: DailyRewardManager;
	
	private var inscriptionDate:Date;
	private var lastDate:Date;
	private var newDate:Date;
	public var daysOfConnexion:Int;
	public var isFirstDay:Int;
	
	private var gold:Int;
	private var wood:Int;
	private var iron:Int;
	private var karma:Int;
	private var notToday:Bool = false;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DailyRewardManager {
		if (instance == null) instance = new DailyRewardManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function testDailyConnexion():Void {
		getFirstDay();
		getDates();
		testDates();
	}
	
	public function getFirstDay():Void {
		isFirstDay = ServerManager.successEvent.isFirstDay;
	}
	
	/**
	 * Get from the server/set the different dates
	 */
	private function getDates():Void {
		trace(isFirstDay);
		inscriptionDate = Date.fromTime(ServerManager.successEvent.dateInscription);
		if (isFirstDay == 1) {
			lastDate = Date.now();
		}
		else{
			lastDate = Date.fromTime(ServerManager.successEvent.dateLastConnexion);
		}
		trace(lastDate);
		newDate = Date.now();
		daysOfConnexion = ServerManager.successEvent.daysOfConnexion;
		
	}
	
	/**
	 * Make different tests to know if we can get daily rewards and set some variables
	 */
	public function testDates():Void {
		
		if (isFirstDay == 1) {
			trace("First Daaaaaaaay");
			ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
			ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.IS_FIRST_DAY_UPDATE]);
			notToday = true;
			trace("blop");
		}
		else if (ifSameDates(inscriptionDate, newDate)) {
			trace ("First day : " + daysOfConnexion);
			ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
			notToday = true;
		}
		else if (!ifSameDates(lastDate,newDate)) {
			var nextDate = addOneDay(lastDate);
			
			if (ifSameDates(nextDate, newDate)) {
				lastDate = newDate;
				daysOfConnexion ++;
				if (daysOfConnexion > 7) daysOfConnexion = 1;
				trace ("Last date : " + lastDate);
				trace ("Days of connexion : " + daysOfConnexion);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INCREMENT_DAYS]);
				setDailyReward();
				trace("ONE MORE DAY !");
			}
			else {
				lastDate = newDate;
				daysOfConnexion = 1;
				trace ("Last date : " + lastDate);
				trace ("Days of connexion : " + daysOfConnexion);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.RESET_DAYS]);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INCREMENT_DAYS]);
				setDailyReward();
				trace("YOU'VE BEEN UNLOGGED TOO MUCH TIME...");
			}
		}
		else {
			notToday = true;
			trace("SAME DAY :" + notToday);
		}
		
		if(!notToday) openDailyPopin();
	}
	
	/**
	 * Add one day to date and do the necessary changes if we have to change the month
	 */
	private function addOneDay(pDate:Date):Date {
		var lYear:Int = pDate.getFullYear();
		var lMonth:Int = pDate.getMonth();
		var lDay:Int = pDate.getDate() + 1;
		if (lDay > 31) {
			lDay = 1;
			lMonth += 1;
			if (lMonth > 11) {
				lMonth = 0;
				lYear += 1;
			}
		}
		
		var lDate:Date = new Date(lYear, lMonth, lDay, 0, 0, 0);
		return lDate;
	}
	
	/**
	 * Reset the numbers of successive days of connexion on the server
	 */
	public function resetDays():Void {
		ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.RESET_DAYS]);
	}
	
	/**
	 * Test if 2 dates are the same
	 * @return true or false
	 */
	private function ifSameDates(pDate1:Date, pDate2:Date):Bool {
		var lDateYear1:Int = pDate1.getFullYear();
		var lDateMonth1:Int = pDate1.getMonth();
		var lDateDay1:Int = pDate1.getDate();
		
		var lDateYear2:Int = pDate2.getFullYear();
		var lDateMonth2:Int = pDate2.getMonth();
		var lDateDay2:Int = pDate2.getDate();
		
		if (lDateYear1 == lDateYear2 && lDateMonth1 == lDateMonth2 && lDateDay1 == lDateDay2) return true;
		else return false;
	}
	
	public function onSuccess(pObject:Dynamic):Void{
		trace("Success");
	}
	
	public function onFailed(pObject:Dynamic):Void {
		trace("Fail... ;______;");
	}
	
	/**
	 * Set the daily rewards with the values got from the server
	 */
	private function setDailyReward():Void {
		var lDailyReward:TableDailyReward = GameConfig.getDailyRewardsByDay(daysOfConnexion);
		var lLevel:Int = ServerManager.successEvent.level;
		gold = lDailyReward.gold * lLevel;
		wood = lDailyReward.wood * lLevel;
		iron = lDailyReward.iron * lLevel;
		karma = lDailyReward.karma * lLevel;
	}
	
	/**
	 * @return an array with the different daily rewards end their values
	 */
	public function getDailyRewards():Map<String,Int> {
		return ["gold" => gold, "wood" => wood, "iron" => iron, "karma" => karma];
	}
	
	/**
	 * Give you some presents once a day
	 */
	public function giveDailyReward():Void {		
		if(gold != 0) ResourcesManager.gainResources(GeneratorType.soft, gold);
		if(wood != 0) ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, wood);
		if(iron != 0) ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, iron);
		if(karma != 0) ResourcesManager.gainResources(GeneratorType.hard, karma);
	}
	
	private function openDailyPopin():Void {
		var lDailyPopin : SmartPopinExtended = DailyRewardPopin.getInstance();
		UIManager.getInstance().popins.push(lDailyPopin);
		GameStage.getInstance().getDailyPopinContainer().addChild(lDailyPopin);
		lDailyPopin.open();
	}
	
	public function closeDailyPopin (): Void {
		if (UIManager.getInstance().popins.length == 0) return;
		var lCurrent:Popin = UIManager.getInstance().popins.pop();
		lCurrent.interactive = false;
		GameStage.getInstance().getDailyPopinContainer().removeChild(lCurrent);
		lCurrent.close();
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}