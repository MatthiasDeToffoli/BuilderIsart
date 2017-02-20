package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TextGenerator.QuestDictionnary;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.ui.popin.choice.Choice.RewardType;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * Give the player a random ressouce reward
 * @author Emeline Berenguier
 */
class RewardGatcha extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe RewardGatcha
	 */
	private static var instance: RewardGatcha;
	
	private var rewardIcon:UISprite;
	private var btnReward:SmartButton;
	private var rewardValue:TextSprite;
	private var rewardTitle:TextSprite;
	
	private static var quest:TimeQuestDescription;
	
	private static inline var GOLD_WON:Int = 1000;
	private static inline var HARD_WON:Int = 10;
	private static inline var WOOD_WON:Int = 600;
	private static inline var STEEL_WON:Int = 750;
	private static inline var SOUL_WON:Int = 20;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): RewardGatcha {
		if (instance == null) instance = new RewardGatcha();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.REWARD_GATCHA_POPIN);
		getComponents();
		addListeners();
		getRandomRewards();
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
	}
	
	public static function spawn(pQuest:TimeQuestDescription):Void{
		quest = pQuest;
	}
	
	private function getComponents():Void{
		rewardIcon = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_ICON), UISprite);
		btnReward = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_BUTTON), SmartButton);
		rewardValue = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_VALUE), TextSprite);
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnReward, onTake);
	}
	
	private function onTake():Void{
		SoundManager.getSound("SOUND_NEUTRAL").play();
		ResourcesManager.gainResources(GeneratorType.soft, GOLD_WON);
		QuestsManager.finishQuest(quest);
	}
	
	/**
	 * Give a random reward
	 */
	private function getRandomRewards():Void{
		var lRandom:Float = Math.random() * 10;
		
		if (lRandom <= 1) {
			rewardIcon.addChild(new UISprite(AssetName.getCurrencyAssetName(RewardType.karma)));
			ResourcesManager.gainResources(GeneratorType.hard, HARD_WON);
			SoundManager.getSound("SOUND_KARMA").play();
			rewardValue.text = HARD_WON + "";
		}
		else if (1 < lRandom && lRandom <= 3){
			rewardIcon.addChild(new UISprite(AssetName.getCurrencyAssetName(RewardType.gold)));
			ResourcesManager.gainResources(GeneratorType.soft, GOLD_WON);
			SoundManager.getSound("SOUND_GOLD").play();
			rewardValue.text = GOLD_WON + "";
		}
		else if (3 < lRandom && lRandom <= 5){
			rewardIcon.addChild(new UISprite(AssetName.getCurrencyAssetName(RewardType.soul)));
			ResourcesManager.gainResources(GeneratorType.soul, SOUL_WON);
			rewardValue.text = SOUL_WON + "";
		}
		else if (5 < lRandom && lRandom <= 7.5){
			rewardIcon.addChild(new UISprite(AssetName.getCurrencyAssetName(RewardType.iron)));
			ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, STEEL_WON);
			SoundManager.getSound("SOUND_IRON").play();
			rewardValue.text = STEEL_WON + "";
		}
		
		else{
			rewardIcon.addChild(new UISprite(AssetName.getCurrencyAssetName(RewardType.wood)));
			ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, WOOD_WON);
			SoundManager.getSound("SOUND_WOOD").play();
			rewardValue.text = WOOD_WON + "";
		}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(btnReward, onTake);
	}

}