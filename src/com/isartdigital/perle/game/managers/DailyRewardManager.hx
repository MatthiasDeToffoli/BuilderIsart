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
	
	private var lastDate:Date;
	private var newDate:Date;
	private var daysOfConnexion:Int;
	
	private var gold:Int;
	private var wood:Int;
	private var iron:Int;
	private var karma:Int;
	
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
	
	public function onConnexion():Void {
		getDates();
		testDailyConnexion();
		updateDates();
	}
	
	private function getDates():Void {
		lastDate = Date.fromTime(ServerManager.successEvent.dateLastConnexion);
		newDate = Date.now();
		daysOfConnexion = ServerManager.successEvent.daysOfConnexion;
		if (daysOfConnexion == 0) daysOfConnexion = 1;
	}
	
	public function testDailyConnexion():Void {
		
		if (!ifSameDates(lastDate,newDate)) {
			var nextDate = addOneDay(lastDate);
			
			if (ifSameDates(nextDate, newDate)) {
				lastDate = newDate;
				daysOfConnexion ++;
				if (daysOfConnexion > 7) daysOfConnexion = 1;
				trace (lastDate);
				trace (daysOfConnexion);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INCREMENT_DAYS]);
				giveDailyReward();
				//Récupérer le type de ressources gagnées en fonction du nombre de jour
				//ResourcesManager.gainResources();
				//UIManager.getInstance().openPopin(DailyRewardPopin.getInstance());
				trace("ONE MORE DAY !");
			}
			else {
				lastDate = newDate;
				daysOfConnexion = 1;
				trace (lastDate);
				trace (daysOfConnexion);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE]);
				ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.RESET_DAYS]);
				giveDailyReward();
				//Récupérer le type de ressources gagnées le premier jour
				//ResourcesManager.gainResources();
				//UIManager.getInstance().openPopin(DailyRewardPopin.getInstance());
				trace("YOU'VE BEEN UNLOGGED TOO MUCH TIME...");
			}
		}
		else trace("SAME DAY");
		
		UIManager.getInstance().openPopin(DailyRewardPopin.getInstance());
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
		
		var lDate:Date = new Date(lYear, lMonth, lDay, 0, 0, 0);
		trace("next date :" + lDate);
		return lDate;
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
	
	private function onSuccess(pObject:Dynamic):Void{
		trace("Success");
	}
	
	private function onFailed(pObject:Dynamic):Void {
		trace("Fail... ;______;");
	}
	
	private function updateDates():Void {
		var lParameters:Map<String, Dynamic> = [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.DATE_UPDATE, 
			"newDate" => lastDate, 
			"daysOfConnexion" => daysOfConnexion
		];
		ServerManager.callPhpFile(onSuccess, onFailed, ServerFile.MAIN_PHP, lParameters);
	}
	
	private function setDailyReward():Void {
		var lDailyReward:TableDailyReward = GameConfig.getDailyRewardsByDay(daysOfConnexion);
		var lLevel:Int = ServerManager.successEvent.level;
		gold = lDailyReward.gold * lLevel;
		wood = lDailyReward.wood * lLevel;
		iron = lDailyReward.iron * lLevel;
		karma = lDailyReward.karma * lLevel;
	}
	
	public function giveDailyReward():Void {
		setDailyReward();
		
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