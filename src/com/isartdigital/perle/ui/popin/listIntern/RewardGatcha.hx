package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager.EventRewardDesc;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.server.ServerManagerChoice;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.ui.popin.choice.Choice.ChoiceType;
import com.isartdigital.perle.ui.popin.choice.Choice.RewardType;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
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
	private var btnRewardTxt:TextSprite;
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
		rewardTitle = cast(getChildByName("_rewardGatcha_text"), TextSprite);
		rewardTitle.text = Localisation.getText("LABEL_GACHA_REWARD_TEXT");
		rewardIcon = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_ICON), UISprite);
		btnReward = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_BUTTON), SmartButton);
		btnRewardTxt = cast(btnReward.getChildByName("buttonSendText"), TextSprite);
		btnRewardTxt.text = Localisation.getText("LABEL_GATCHA_POPIN_CONTINUE_BUTTON");
		rewardValue = cast(getChildByName(AssetName.REWARD_GATCHA_POPIN_VALUE), TextSprite);
	
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnReward, onTake);
		Interactive.addListenerRewrite(btnReward, setText);
	}
	
	private function onTake():Void{
		UIManager.getInstance().closePopin(GatchaPopin.getInstance());
		SoundManager.getSound("SOUND_NEUTRAL").play();		
		QuestsManager.finishQuest(quest);
	}
	
	private function setText():Void{
		btnRewardTxt = cast(btnReward.getChildByName("buttonSendText"), TextSprite);
		btnRewardTxt.text = Localisation.getText("LABEL_GATCHA_POPIN_CONTINUE_BUTTON");
	}
	
	/**
	 * Give a random reward
	 */
	private function getRandomRewards():Void{
		var lRandom:Float = Math.random() * 10;
		
		var gold:Int = 0;
		var hard:Int = 0;
		var wood:Int = 0;
		var iron:Int = 0;
		var soul:Int = 0;
		
		if (lRandom <= 1) {
			SpriteManager.spawnComponent(rewardIcon, AssetName.getCurrencyAssetName(RewardType.karma), this, TypeSpawn.SPRITE);
			ResourcesManager.gainResources(GeneratorType.hard, HARD_WON);
			hard = HARD_WON;
			SoundManager.getSound("SOUND_KARMA").play();
			rewardValue.text = HARD_WON + "";
		}
		else if (1 < lRandom && lRandom <= 3){
			SpriteManager.spawnComponent(rewardIcon, AssetName.getCurrencyAssetName(RewardType.gold), this, TypeSpawn.SPRITE);
			ResourcesManager.gainResources(GeneratorType.soft, GOLD_WON);
			gold = GOLD_WON;
			SoundManager.getSound("SOUND_GOLD").play();
			rewardValue.text = GOLD_WON + "";
		}
		else if (3 < lRandom && lRandom <= 5){
			SpriteManager.spawnComponent(rewardIcon, AssetName.getCurrencyAssetName(RewardType.soul), this, TypeSpawn.SPRITE);
			ResourcesManager.gainResources(GeneratorType.soul, SOUL_WON);
			soul = SOUL_WON;
			rewardValue.text = SOUL_WON + "";
		}
		else if (5 < lRandom && lRandom <= 7.5){
			SpriteManager.spawnComponent(rewardIcon, AssetName.getCurrencyAssetName(RewardType.iron), this, TypeSpawn.SPRITE);
			ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, STEEL_WON);
			iron = STEEL_WON;
			SoundManager.getSound("SOUND_IRON").play();
			rewardValue.text = STEEL_WON + "";
		}
		else{
			SpriteManager.spawnComponent(rewardIcon, AssetName.getCurrencyAssetName(RewardType.wood), this, TypeSpawn.SPRITE);
			ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, WOOD_WON);
			wood = WOOD_WON;
			SoundManager.getSound("SOUND_WOOD").play();
			rewardValue.text = WOOD_WON + "";
		}
		
		var reward:EventRewardDesc = {
			gold : gold,
			karma : gold,
			wood : wood,
			iron : iron,
			soul : soul
		};
		
		ServerManagerChoice.applyReward(reward, ChoiceType.NONE);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(btnReward, onTake);
		Interactive.removeListenerRewrite(btnReward, setText);
	}

}