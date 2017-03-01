package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Json;
import js.html.TouchEvent;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

	
/**
 * tribunal description and all action we can do with this
 * @author de Toffoli Matthias
 */
class TribunalPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe TribunalPopin
	 */
	private static var instance: TribunalPopin;
	//FTUE
	private static var counterForFtue:Int = 0;
	
	//Tribunal
	private var btnClose:SmartButton;
	//private var btnShop:SmartButton;
	//private var btnIntern:SmartButton;
	//private var btnHeaven:SmartButton;
	//private var btnHell:SmartButton;
	private var btnUpgrade:SmartButton;
	private var tribunalLevel:TextSprite;
	private var timer:TextSprite;
	private var fateName:TextSprite;
	private var fateNameFR:TextSprite;
	private var interMovieClipFR:SmartComponent;
	private var fateAdjective:TextSprite;
	private var fateAdjectiveFR:TextSprite;
	private var infoHeaven:TextSprite;
	private var infoHell:TextSprite;
	private var infoSoul:TextSprite;
	private var title:SmartComponent;
	private var soulCard:SmartComponent;
	private var tribunalTitleEnglish:UISprite;
	private var tribunalTitleFrench:UISprite;
	private var btnInviteSoul:SmartButton;
	private var cardSoul:SmartComponent;
	private var canMoovCard:Bool;
	private var baseCardRot:Float;
	private var baseMousePos:Point;
	private var baseCardPos:Point;
	private var MOUSE_DIFF_MAX(null,never):Int = 200;
	private var DIFF_MAX(null, never):Int = 80;
	
	private var sendToText:TextSprite;
	private var sendToText2:TextSprite;
	private var sendToTextHell:TextSprite;
	private var sendToTextHeaven:TextSprite;
	
	private var soulEvilGirl1:UISprite;
	private var soulEvilGirl2:UISprite;
	private var soulEvilGirl3:UISprite;
	
	private var soulEvilBoy1:UISprite;
	private var soulEvilBoy2:UISprite;
	private var soulEvilBoy3:UISprite;
	
	private var soulGoodGirl1:UISprite;
	private var soulGoodGirl2:UISprite;
	private var soulGoodGirl3:UISprite;
	
	private var soulGoodBoy1:UISprite;
	private var soulGoodBoy2:UISprite;
	private var soulGoodBoy3:UISprite;
	
	private var fbText:TextSprite;
	
	public static var doTween:Bool = false;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TribunalPopin {
		if (instance == null) instance = new TribunalPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null){
		Hud.isHide = false;
		Hud.getInstance().hide();
		super(AssetName.PURGATORY_POPIN);
		canMoovCard = false;
		name = componentName;
		var interMovieClip:Dynamic;
		counterForFtue = 0;
		doTween = false;
		SoundManager.getSound("SOUND_OPEN_MENU_PURG").play();
		
		btnClose = cast(getChildByName(AssetName.PURGATORY_POPIN_CANCEL), SmartButton);
		//btnShop = cast(getChildByName(AssetName.PURGATORY_POPIN_SHOP), SmartButton);
		//btnIntern = cast(getChildByName(AssetName.PURGATORY_POPIN_INTERN), SmartButton);
		btnUpgrade = cast(getChildByName(AssetName.PURGATORY_POPIN_UPGRADE), SmartButton);
		//SmartCheck.traceChildrens(this);

		btnInviteSoul = cast(getChildByName(AssetName.PURGATORY_POPIN_INVITE_BUTTON), SmartButton);
		fbText = cast(btnInviteSoul.getChildByName("Text"), TextSprite);
		fbText.text = Localisation.getText("LABEL_FACEBOOK_BUTTON");
		
		title = cast(getChildByName("PurgatoryTitle_MC"), SmartComponent);
		tribunalTitleEnglish = cast(title.getChildByName("_png_purgatoryTitle"), UISprite);
		tribunalTitleFrench = cast(title.getChildByName("_purgatoireTitle"), UISprite);
		
		//As we must display only the good translation and remove the other, we can't use the label system for the translation
		Localisation.actualLanguage == "en" ? tribunalTitleFrench.visible = false : tribunalTitleEnglish.visible = false;
		
		tribunalLevel = cast(getChildByName(AssetName.PURGATORY_POPIN_LEVEL), TextSprite);
		tribunalLevel.text = Localisation.getText("LABEL_BUILDINGLEVEL")+ " " + VTribunal.getInstance().tileDesc.level;
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_TIMER_CONTAINER);
		timer = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_TIMER), TextSprite);
		timer.text = "0" + 0 + "h" + "0" + 0 + "m" + "0" + 0 + "s";
		
		sendToText = cast(getChildByName("_sendTo_txt"), TextSprite);
		sendToText2 = cast(getChildByName("_sendTo2_txt"), TextSprite);
		sendToTextHell = cast(getChildByName("_sendTo_Hell_txt"), TextSprite);
		sendToTextHeaven = cast(getChildByName("_sendTo_Heaven_txt"), TextSprite);
		
		sendToText.text = Localisation.getText("LABEL_TRIBUNALPOPIN_SEND_TO");
		sendToText2.text = Localisation.getText("LABEL_TRIBUNALPOPIN_SEND_TO");
		sendToTextHell.text = Localisation.getText("LABEL_TRIBUNALPOPIN_HELL");
		sendToTextHeaven.text = Localisation.getText("LABEL_TRIBUNALPOPIN_HEAVEN");
		
		soulCard = cast(getChildByName(AssetName.PURGATORY_POPIN_SOUL_CARD), SmartComponent);
		cardSoul = cast(soulCard.getChildByName(AssetName.PURGATORY_POPIN_CARD), SmartComponent);
		
		interMovieClip = cast(cardSoul.getChildByName(AssetName.PURGATORY_POPIN_SOUL_INFO), SmartComponent);
		interMovieClipFR = cast(cardSoul.getChildByName(AssetName.PURGATORY_POPIN_SOUL_INFO_FR), SmartComponent);
		fateName = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_NAME), TextSprite);
		fateNameFR = cast(interMovieClipFR.getChildByName(AssetName.PURGATORY_POPIN_SOUL_NAME), TextSprite);
		
		interMovieClip.visible = false;
		interMovieClipFR.visible = false;
		Localisation.getLanguage() == "en" ? interMovieClip.visible = true : interMovieClipFR.visible = true;
		fateName.text = Localisation.getText(VTribunal.getInstance().soulToJudge.name);
		fateNameFR.text = Localisation.getText(VTribunal.getInstance().soulToJudge.name);
		fateAdjective = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_ADJ),TextSprite);
		fateAdjectiveFR = cast(interMovieClipFR.getChildByName(AssetName.PURGATORY_POPIN_SOUL_ADJ),TextSprite);
		fateAdjective.text = Localisation.getText(VTribunal.getInstance().soulToJudge.adjective);
		fateAdjectiveFR.text = Localisation.getText(VTribunal.getInstance().soulToJudge.adjective);
		
		baseCardRot = cardSoul.rotation;
		cardSoul.interactive = true;
		cardSoul.buttonMode = true;
		
		soulEvilBoy1= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_BOY_1), UISprite);
		soulEvilBoy2= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_BOY_2), UISprite);
		soulEvilBoy3= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_BOY_3), UISprite);
		soulEvilGirl1= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_GIRL_1), UISprite);
		soulEvilGirl2= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_GIRL_2), UISprite);
		soulEvilGirl3= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_EVIL_GIRL_3), UISprite);
		soulGoodBoy1= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_BOY_1), UISprite);
		soulGoodBoy2= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_BOY_2), UISprite);
		soulGoodBoy3= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_BOY_3), UISprite);
		soulGoodGirl1= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_GIRL_1), UISprite);
		soulGoodGirl2= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_GIRL_2), UISprite);
		soulGoodGirl3= cast(cardSoul.getChildByName(AssetName.PURGATORY_CARD_GOOD_GIRL_3), UISprite);

		cardSoul.on(TouchEventType.TOUCH_START, onMouseDownOnCard);
		cardSoul.on(MouseEventType.MOUSE_DOWN, onMouseDownOnCard);
		
		cardSoul.on(MouseEventType.MOUSE_MOVE, onFollowMouse);
		cardSoul.on(TouchEventType.TOUCH_MOVE, onFollowMouse);
		cardSoul.on(MouseEventType.MOUSE_UP_OUTSIDE, onMouseUpOnCard);
		cardSoul.on(TouchEventType.TOUCH_END, onMouseUpOnCard);
		cardSoul.on(MouseEventType.MOUSE_UP, onMouseUpOnCard);
		cardSoul.on(TouchEventType.TOUCH_END_OUTSIDE, onMouseUpOnCard);
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HEAVEN_INFO);
		infoHeaven = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HELL_INFO);
		infoHell = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);	
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_INFO);
		infoSoul = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_NUMBER), TextSprite);	
		
		changeSoulTextInfo();
			
		Interactive.addListenerClick(btnInviteSoul, onInviteSoul);
		Interactive.addListenerRewrite(btnInviteSoul, setText);
		
		if (VTribunal.getInstance().canUpgrade()){
			Interactive.addListenerRewrite(btnUpgrade, rewriteUpgradeTxt);
			Interactive.addListenerClick(btnUpgrade, onUpgrade);
			rewriteUpgradeTxt();
		} else {
			btnUpgrade.parent.removeChild(btnUpgrade);
			btnUpgrade.destroy();
		}
		
		setPicture(VTribunal.getInstance().soulToJudge.age,VTribunal.getInstance().soulToJudge.alignement);
		
		Interactive.addListenerClick(btnClose, onClose);
		//Interactive.addListenerClick(btnShop, onShop);
		//Interactive.addListenerClick(btnIntern, onIntern);
		
		ResourcesManager.soulArrivedEvent.on(ResourcesManager.SOUL_ARRIVED_EVENT_NAME, onSoulArrivedEvent);
		if (DialogueManager.ftueStepOpenPurgatory && !DialogueManager.ftueStepSlideCard) {
			DialogueManager.dialogueSaved ++;
			registerForFTUE();
		}
	}
	
	public function getCardPos():Point {
		return soulCard.position;
	}
	
	
	//pAge : 1 Child 2 Adult 3 Old
	//pAlignement : 1 Heaven 2 Hell 3 Random
	//pSexe : 1 men 2 women
	private function setPicture(pAge:Int, pAlignement:Int) {
		setPictureFalse();
		if (pAge == null || pAlignement == null)
			return;
		var pSexe:Int = VTribunal.getInstance().soulToJudge.sexe;
		
		if (pAlignement == 3 || pAlignement == 0) {
			var lAlignement:Int = Math.floor(Math.random() * 2) +1;
			pAlignement = lAlignement;
		}
		
		switch(pAge) {
			case 1 : {
				if (pAlignement == 1) {
					if (pSexe == 1) {
						soulGoodBoy1.visible = true;
					}
					else if (pSexe == 2) {
						soulGoodGirl1.visible = true;
					}
				}
				else if (pAlignement == 2) {
					if (pSexe == 1) {
						soulEvilBoy1.visible = true;
					}
					else if (pSexe == 2) {
						soulEvilGirl1.visible = true;
					}
				}
			}
			case 2 : {
				if (pAlignement == 1) {
					if (pSexe == 1) {
						soulGoodBoy2.visible = true;
					}
					else if (pSexe == 2) {
						soulGoodGirl2.visible = true;
					}
				}
				else if (pAlignement == 2) {
					if (pSexe == 1) {
						soulEvilBoy2.visible = true;
					}
					else if (pSexe == 2) {
						soulEvilGirl2.visible = true;
					}
				}
			}
			case 3 : {
				if (pAlignement == 1) {
					if (pSexe == 1) {
						soulGoodBoy3.visible = true;
					}
					else if (pSexe == 2) {
						soulGoodGirl3.visible = true;
					}
				}
				else if (pAlignement == 2) {
					if (pSexe == 1) {
						soulEvilBoy3.visible = true;
					}
					else if (pSexe == 2) {
						soulEvilGirl3.visible = true;
					}
				}
			}
		}
	}
	
	private function setPictureFalse():Void {
		soulEvilBoy1.visible = false;
		soulEvilBoy2.visible = false;
		soulEvilBoy3.visible = false;
		soulEvilGirl1.visible = false;
		soulEvilGirl2.visible = false;
		soulEvilGirl3.visible = false;
		soulGoodBoy1.visible = false;
		soulGoodBoy2.visible = false;
		soulGoodBoy3.visible = false;
		soulGoodGirl1.visible = false;
		soulGoodGirl2.visible = false;
		soulGoodGirl3.visible = false;
	}
	
	private function onMouseDownOnCard(mouseEvent:EventTarget):Void {
		canMoovCard = true;
		baseMousePos = mouseEvent.data.global.clone();
		baseCardPos = cardSoul.position.clone();
	}
	
	private  function onMouseUpOnCard(mouseEvent:EventTarget):Void {
		canMoovCard = false;
		
		var diff:Float = mouseEvent.data.global.x - baseMousePos.x;
		
		if (diff > 0) {
			if (cardSoul.rotation > baseCardRot + Math.PI / 32) onHell();
		}
		else if (diff < 0) {
			if (cardSoul.rotation < baseCardRot - Math.PI / 32) onHeaven();
		}
		
	}
	
	private function reset():Void {
		doTween = false;
		cardSoul.interactive = true;
		cardSoul.alpha = 1;
		
		resetPos();
		changeSoulTextInfo();
		changeSoulText();
	}
	
	private function resetPos():Void {
		cardSoul.rotation = baseCardRot;
		cardSoul.position = baseCardPos;
	}
	
	private function onFollowMouse(mouseEvent:EventTarget):Void {
		if (!canMoovCard) return;
		var diff:Float = mouseEvent.data.global.x - baseMousePos.x;
		
		if (diff > 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			cardSoul.rotation = baseCardRot + diff / DIFF_MAX * Math.PI / 32;
			cardSoul.position.set(baseCardPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), baseCardPos.y);
			
		}
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			cardSoul.rotation = baseCardRot + diff / DIFF_MAX * Math.PI / 32;
			cardSoul.position.set(baseCardPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), baseCardPos.y);
		}
	}
	
	private function setText():Void{
		fbText = cast(btnInviteSoul.getChildByName("Text"), TextSprite);
		fbText.text = Localisation.getText("LABEL_FACEBOOK_BUTTON");
	}
	
	private function onInviteSoul():Void {
		if (DialogueManager.ftueStepSlideCard)
			return;
			
		Facebook.ui ({
			method: 'apprequests',
			message: Localisation.getText("LABEL_FACEBOOK_SHARE")
		}, onRequest);
		
		SoundManager.getSound("SOUND_NEUTRAL").play();
		//Facebook.api(Facebook.uid+"/permissions",onHavePermission);
		//Facebook.api(Facebook.uid+"?fields=email", onEmail);
	}
	
	private function onRequest(pObject:Dynamic):Void {
		
		if (pObject == null) Debug.error("erreur facebook");
		else if (pObject.error != null) Debug.error(pObject.error);
		else {
			Facebook.api(pObject.to[0], onFriendInfo);
		}
	}
	
	private function onFriendInfo(response:Dynamic):Void {
		setTribunalSoulToJudge(response.name);
	}
	
	private function setTribunalSoulToJudge(pName:String):Void {
		VTribunal.getInstance().updateSoulToJudge(pName);
		changeSoulText(true);
	}
	
	private function registerForFTUE ():Void {
		for (i in 0...children.length) {
			if (Std.is(children[i],SmartButton)) DialogueManager.register(children[i],true,true);
		}
	}
	
	private function onClose() {
		if (DialogueManager.ftueStepSlideCard)
			return;
			
		if (DialogueManager.ftueClosePurgatory)
			DialogueManager.endOfaDialogue(true);
			
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		UIManager.getInstance().closeCurrentPopin();	
		Hud.getInstance().show();
	}
	
	private function onShop(){
		UIManager.getInstance().closeCurrentPopin();	
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		ShopPopin.getInstance().init(ShopTab.Building);
	}
	
	private function onIntern() {
		UIManager.getInstance().closeCurrentPopin();	
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	private function onHeaven() {
		if (DialogueManager.ftueStepSlideCard) {
			DialogueManager.counterForFtueHeaven ++;
			if (counterForFtue++ >= 1)
			DialogueManager.endOfaDialogue(null, true);
		}
		if (!ResourcesManager.judgePopulation(Alignment.heaven)) {
			
			if (!doTween)
				resetPos();
			return;
		}
		else 
			TweenManager.lowerAlpha(cardSoul,reset);
		
		
		SoundManager.getSound("SOUND_CHOICE_HEAVEN").play();
	}
	
	private function onHell() {
		if (DialogueManager.ftueStepSlideCard) {
			if (counterForFtue++ >= 1)
			DialogueManager.endOfaDialogue(null, true);
		}
		if (!ResourcesManager.judgePopulation(Alignment.hell)) {
				
			if (!doTween)
				resetPos();
			return;
		}
		else 
			TweenManager.lowerAlpha(cardSoul,reset);
		
			
		SoundManager.getSound("SOUND_CHOICE_HELL").play();
	}
	
	private function changeSoulText(?pSoulNameFound:Bool):Void {
		if (!pSoulNameFound || pSoulNameFound == null) VTribunal.getInstance().findSoul();
		
		fateNameFR.text = Localisation.getText(VTribunal.getInstance().soulToJudge.name);
		fateName.text = Localisation.getText(VTribunal.getInstance().soulToJudge.name);
		fateAdjective.text = Localisation.getText(VTribunal.getInstance().soulToJudge.adjective);
		fateAdjectiveFR.text = Localisation.getText(VTribunal.getInstance().soulToJudge.adjective);
		
		setPicture(VTribunal.getInstance().soulToJudge.age,VTribunal.getInstance().soulToJudge.alignement);
	}
	
	private function changeSoulTextInfo():Void{
		
		var myTotalPopulation:TotalPopulations = ResourcesManager.getTotalAllPopulations();
		var myNeutralPopulation:Population = ResourcesManager.getTotalNeutralPopulation();
		
		infoHeaven.text = myTotalPopulation.heaven.quantity + "/" + myTotalPopulation.heaven.max;
		infoHell.text = myTotalPopulation.hell.quantity + "/" + myTotalPopulation.hell.max;
		infoSoul.text = myNeutralPopulation.quantity + "/" + myNeutralPopulation.max;
		
	}
	
	private function onSoulArrivedEvent(pParam:Dynamic):Void{
		changeSoulTextInfo();
	}
	
	private function onUpgrade():Void {
		if (DialogueManager.ftueStepSlideCard)
			return;
		rewriteUpgradeTxt();
		var tribunalConfig:TableTypeBuilding = GameConfig.getBuildingByName(VTribunal.getInstance().tileDesc.buildingName, VTribunal.getInstance().tileDesc.level + 1);
		
		if (ResourcesManager.getTotalForType(GeneratorType.soft) - tribunalConfig.costGold >= 0 &&
		ResourcesManager.getTotalForType(GeneratorType.buildResourceFromHell) - tribunalConfig.costIron >= 0 &&
		ResourcesManager.getTotalForType(GeneratorType.buildResourceFromParadise) - tribunalConfig.costWood >= 0) {
			ResourcesManager.spendTotal(GeneratorType.soft, tribunalConfig.costGold);	
			ResourcesManager.spendTotal(GeneratorType.buildResourceFromHell, tribunalConfig.costIron);	
			ResourcesManager.spendTotal(GeneratorType.buildResourceFromParadise, tribunalConfig.costWood);
			VTribunal.getInstance().onClickUpgrade();
			onClose();
			
			SoundManager.getSound("SOUND_NEUTRAL").play();
		}
	}
	
	private function rewriteUpgradeTxt(){
		var upgradePrice:TextSprite = cast(btnUpgrade.getChildByName(AssetName.PURGATORY_POPIN_UPGRADE_PRICE_SOFT), TextSprite);
		var tribunalConfig:TableTypeBuilding = GameConfig.getBuildingByName(VTribunal.getInstance().tileDesc.buildingName, VTribunal.getInstance().tileDesc.level + 1); 
		upgradePrice.text = ResourcesManager.shortenValue(tribunalConfig.costGold);
		
		upgradePrice = cast(btnUpgrade.getChildByName(AssetName.PURGATORY_POPIN_UPGRADE_PRICE_STONE), TextSprite);
		upgradePrice.text = ResourcesManager.shortenValue(tribunalConfig.costIron);
		
		upgradePrice = cast(btnUpgrade.getChildByName(AssetName.PURGATORY_POPIN_UPGRADE_PRICE_WOOD), TextSprite);
		upgradePrice.text = ResourcesManager.shortenValue(tribunalConfig.costWood);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		
		Interactive.removeListenerClick(btnClose, onClose);
		Interactive.removeListenerClick(btnInviteSoul, onInviteSoul);
		Interactive.removeListenerRewrite(btnInviteSoul, setText);
		//Interactive.removeListenerClick(btnShop, onShop);
		//Interactive.removeListenerClick(btnIntern, onIntern);
		if (VTribunal.getInstance().canUpgrade()) Interactive.removeListenerClick(btnUpgrade, onUpgrade);
		
		instance = null;
		
		super.destroy();
	}

}