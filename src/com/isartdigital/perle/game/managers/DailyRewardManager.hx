package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableDailyReward;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerFile;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.popin.DailyRewardPopin;

	
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
		
		if(!notToday) UIManager.getInstance().openPopin(DailyRewardPopin.getInstance());
	}
	
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
		
		trace("year :" + lYear);
		trace("month :" + lMonth);
		trace("day :" + lDay);
		var lDate:Date = new Date(lYear, lMonth, lDay, 0, 0, 0);
		trace("next date :" + lDate);
		return lDate;
	}
	
	public function resetDays():Void {
		ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.RESET_DAYS]);
	}
	
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
	
	private function setDailyReward():Void {
		var lDailyReward:TableDailyReward = GameConfig.getDailyRewardsByDay(daysOfConnexion);
		var lLevel:Int = ServerManager.successEvent.level;
		gold = lDailyReward.gold * lLevel;
		wood = lDailyReward.wood * lLevel;
		iron = lDailyReward.iron * lLevel;
		karma = lDailyReward.karma * lLevel;
	}
	
	public function getDailyRewards():Map<String,Int> {
		return ["gold" => gold, "wood" => wood, "iron" => iron, "karma" => karma];
	}
	
	public function giveDailyReward():Void {		
		if(gold != 0) ResourcesManager.gainResources(GeneratorType.soft, gold);
		if(wood != 0) ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, wood);
		if(iron != 0) ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, iron);
		if(karma != 0) ResourcesManager.gainResources(GeneratorType.hard, karma);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}