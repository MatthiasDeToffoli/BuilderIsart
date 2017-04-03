package com.isartdigital.perle.ui.popin;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DailyRewardManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

	
/**
 * ...
 * @author COQUERELLE Killian
 */
class DailyRewardPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe DailyRewardPopin
	 */
	private static var instance: DailyRewardPopin;
	
	private var btnClose:SmartButton;
	private var btnGain:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DailyRewardPopin {
		if (instance == null) instance = new DailyRewardPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.DAILYREWARDS_POPPIN);
		setButtonsAndAddListeners();
		setDay();
		setValues();
		setTexts();
	}
	
	/**
	 * Set the buttons and their listeners
	 */
	private function setButtonsAndAddListeners():Void{
		
		btnClose = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_CLOSE), SmartButton);
		btnGain = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_GAIN_BUTTON), SmartButton);
		
		Interactive.addListenerClick(btnClose, onGain);
		Interactive.addListenerClick(btnGain, onGain);
		Interactive.addListenerRewrite(btnGain, setTextBtn);
	}
	
	/**
	 * Shows how many successive days we have been connected
	 */
	private function setDay():Void {
		var lDayNumber:Int = DailyRewardManager.getInstance().daysOfConnexion;
		for (i in 1...8) {
			if (i != lDayNumber) {
				var lDay:SmartComponent = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_DAY + i), SmartComponent);
				var lDayCurrent:Dynamic = SmartCheck.getChildByName(lDay, AssetName.DAILYREWARD_POPIN_DAY + i + AssetName.DAILYREWARD_POPIN_CURRENT);
				var lDaySmall:Dynamic = SmartCheck.getChildByName(lDay, AssetName.DAILYREWARD_POPIN_DAY_SMALL + i + AssetName.DAILYREWARD_POPIN_TEXT_SMALL);
				var lBgSmall:Dynamic = SmartCheck.getChildByName(lDay, AssetName.DAILYREWARD_POPIN_DAY_BG_SMALL);
				lDayCurrent.visible = false;
				lDaySmall.visible = true;
				lBgSmall.visible = true;
			}
		}
	}
	
	/**
	 * Set the different text of the popin in fr/en
	 */
	private function setTexts():Void {
		var lDayNumber:Int = DailyRewardManager.getInstance().daysOfConnexion;
		var lDay:SmartComponent = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_DAY + lDayNumber), SmartComponent);
		var lDayCurrent:Dynamic = SmartCheck.getChildByName(lDay, AssetName.DAILYREWARD_POPIN_DAY + lDayNumber + AssetName.DAILYREWARD_POPIN_CURRENT);
		var lDayText:TextSprite = cast(SmartCheck.getChildByName(lDayCurrent, AssetName.DAILYREWARD_POPIN_TEXT_DAY), TextSprite);
		lDayText.text = Localisation.getText(AssetName.DAILYREWARD_POPIN_TEXT_DAY_LABEL + lDayNumber);
		
		var lDRText:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_TEXT), TextSprite);
		lDRText.text = Localisation.getText("LABEL_DAILYREWARDS_TEXT");
		
		var lBtnGainText:TextSprite = cast(btnGain.getChildByName(AssetName.DAILYREWARD_POPIN_GAIN_BUTTON_TEXT), TextSprite);
		lBtnGainText.text = Localisation.getText("LABEL_DAILYREWARDS_GAIN_BTN");
	}
	
	/**
	 * Set the different values of the daily rewards depending of the array returned
	 */
	private function setValues():Void {
		var lDailyRewards:Map<String,Int> = DailyRewardManager.getInstance().getDailyRewards();
		var lGold:String = ResourcesManager.shortenValue(lDailyRewards["gold"]);
		var lWood:String = ResourcesManager.shortenValue(lDailyRewards["wood"]);
		var lIron:String = ResourcesManager.shortenValue(lDailyRewards["iron"]);
		var lKarma:String = ResourcesManager.shortenValue(lDailyRewards["karma"]);
		
		var lGoldText:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_GOLD), TextSprite);
		var lWoodText:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_WOOD), TextSprite);
		var lIronText:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_IRON), TextSprite);
		var lKarmaText:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.DAILYREWARD_POPIN_KARMA), TextSprite);
		
		lGoldText.text = lGold;
		lWoodText.text = lWood;
		lIronText.text = lIron;
		lKarmaText.text = lKarma;
	}
	
	private function setTextBtn():Void {
		var lBtnGainText:TextSprite = cast(btnGain.getChildByName(AssetName.DAILYREWARD_POPIN_GAIN_BUTTON_TEXT), TextSprite);
		lBtnGainText.text = Localisation.getText("LABEL_DAILYREWARDS_GAIN_BTN");
	}
	
	private function onClose() {
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		DailyRewardManager.getInstance().closeDailyPopin();
	}
	
	private function onGain() {
		DailyRewardManager.getInstance().giveDailyReward();
		onClose();
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(btnClose, onGain);
		Interactive.removeListenerClick(btnGain, onGain);
	}

}