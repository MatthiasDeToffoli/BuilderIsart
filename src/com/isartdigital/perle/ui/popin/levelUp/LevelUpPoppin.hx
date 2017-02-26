package com.isartdigital.perle.ui.popin.levelUp;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.FocusManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Alexis
 */
class LevelUpPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe LevelUpPoppin
	 */
	private static var instance: LevelUpPoppin;
	
	private static var level:TextSprite;
	//private static var typeUnlock:TextSprite;
	private static var txtNew:TextSprite;
	private static var nameUnlock:TextSprite;
	//private static var description:TextSprite;
	//private static var congrats:TextSprite;
	private static var txtNext:TextSprite;
	private static var img:UISprite;
	private static var imgImage:FlumpStateGraphic;
	private var btnNext:SmartButton;
	private var bgLvl:SmartComponent;
	private var unlock:SmartComponent;
	private var currentImage:UIMovie;
	
	private static var imgArray:Array<UIMovie>;
	private var shopGraphic:UISprite;
	
	private var allRewardsTook:Bool = false;
	private var canDoJuicyWithTheseElement:Bool = false;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelUpPoppin {
		if (instance == null) instance = new LevelUpPoppin();
		return instance;
	}
	
	private function setPopin(pName:String, pLevel:Int):Void {
		//todo : rajouter la description, level type du batiment
		level.text = "" + ResourcesManager.getLevel();
		
		currentImage = SmartPopinExtended.setImage(img, BuildingName.getAssetName(pName, pLevel)); 
		imgArray.push(currentImage);
		//txtNew.text = Localisation.allTraductions["LABEL_LEVEL_UP_NEW"];
		txtNext.text = Localisation.getText("LABEL_LEVEL_UP_NEXT");
		//congrats.text = Localisation.allTraductions["LABEL_LEVEL_UP_CONGRATS"];
		
		//setImage(BuildingName.getAssetName(UnlockManager.unlockedItem[0].name, UnlockManager.unlockedItem[0].level)); 
		//setImage(BuildingName.getAssetName(UnlockManager.unlockedItem[0].name)); 
		//todo @Ambroise : setImage en fonction du level comme la ligne 56 commentée (elle ne marche pas car elle detecte les decoration au level 1)		
		
		canDoJuicyWithTheseElement = true;
		nameUnlock.text = Localisation.getText(pName);
		//description.text = UnlockManager.itemUnlockedForPoppin[0][0][4];
	}
	
	public function getImgCenter():Point {
		return img.position;
	}
	
	private function onClickNext():Void {
		juicyEffect();
		shopGraphic.visible = true;
		if (UnlockManager.unlockedItem.length != 0) {
			var lUnlockedItem:TableTypeBuilding = UnlockManager.unlockedItem.shift();
				
			setPopin(
				lUnlockedItem.name,
				lUnlockedItem.level
			);
		}
		else if (!allRewardsTook) {
			setGoldsIcon();
		}
		else
			Timer.delay(closeLevelUpPoppin, 200);
	}
	
	private function setText():Void{
		txtNext = cast(SmartCheck.getChildByName(btnNext, AssetName.LEVELUP_POPPIN_NEXT_TEXT), TextSprite);
		txtNext.text = Localisation.getText("LABEL_LEVEL_UP_NEXT");
	}
	
	private function setGoldsIcon() {
		allRewardsTook = true;
		
		canDoJuicyWithTheseElement = false;
		level.text = "" + ResourcesManager.getLevel();
		var lLevel:Float = ResourcesManager.getLevel();
		var level:Int = cast(lLevel - 2, Int);
		var lSprite:UISprite = SmartPopinExtended.setImageUiSprite(img, "_goldPack5_portrait"); 
		nameUnlock.text = "" + GameConfig.getLevelRewardsConfig()[level].gold;
		UnlockManager.giveLevelReward();
	}
	
	private function closeLevelUpPoppin() {
		if (DialogueManager.ftueCloseUnlockedItem)
			DialogueManager.endOfaDialogue();
			
		Hud.getInstance().btnShop.interactive = true;
		Hud.getInstance().show();
		UIManager.getInstance().closePopin(this);
		UnlockManager.checkIfNeedToCreateDialogue();
		UnlockManager.checkIfNeedPub();
	}
	
	private function juicyEffect():Void {
		if (!canDoJuicyWithTheseElement) {
			
			shopGraphic.visible = false;
			return;
		}
		TweenManager.positionAndRescal(
			currentImage,
			shopGraphic.position,
			this,
			destroyAfterEffect,
			shopGraphic
		);
	}
	
	private function destroyAfterEffect():Void {
		/*if (imgArray.length != 0) {
			var lImg:UIMovie = imgArray[0];
			imgArray.splice(0, 1);
			lImg.parent.removeChild(lImg);
			lImg.destroy();
			//if (imgArray.length == 0)
		}*/
		
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.LEVELUP_POPPIN);
		setWireframe();
		imgArray = [];
		if (UnlockManager.unlockedItem[0] != null) {
			
			allRewardsTook = false;
			canDoJuicyWithTheseElement = true;
			setPopin(
				UnlockManager.unlockedItem[0].name,
				UnlockManager.unlockedItem[0].level
			);
			UnlockManager.unlockedItem.splice(0,1);	
		}
		else {
			allRewardsTook = true;
			setGoldsIcon();
		}
		
		shopGraphic = new UISprite("_shopButton_HUD_up");
		shopGraphic.position = Hud.getInstance().getShopIconPos();
		addChild(shopGraphic);
		shopGraphic.visible = false;
		SoundManager.getSound("SOUND_LEVELUP").play();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		bgLvl = cast(getChildByName(AssetName.LEVELUP_POPPIN_LEVELBG), SmartComponent);
		unlock = cast(getChildByName(AssetName.LEVELUP_POPPIN_UNLOCK), SmartComponent);
		
		level = cast(SmartCheck.getChildByName(bgLvl, AssetName.LEVELUP_POPPIN_LEVEL), TextSprite);
		nameUnlock = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_NAME), TextSprite);
		//description = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_DESCRIPTION), TextSprite);
		//typeUnlock = cast(getChildByName(AssetName.LEVELUP_POPPIN_TYPE), TextSprite);
		
		//congrats = cast(getChildByName(AssetName.LEVELUP_POPPIN_CONGRATS), TextSprite);
		//txtNew = cast(getChildByName(AssetName.LEVELUP_POPPIN_TEXT_NEW), TextSprite);
		
		img = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_IMG), UISprite);
		
		btnNext = cast(getChildByName(AssetName.LEVELUP_POPPIN_BUTTON), SmartButton);
		
		txtNext = cast(SmartCheck.getChildByName(btnNext, AssetName.LEVELUP_POPPIN_NEXT_TEXT), TextSprite);
		Interactive.addListenerClick(btnNext, onClickNext);
		Interactive.addListenerRewrite(btnNext, setText);
		//SmartCheck.traceChildrens(btnNext);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnNext, onClickNext);
		Interactive.removeListenerRewrite(btnNext, setText);
		
		instance = null;
	}

}