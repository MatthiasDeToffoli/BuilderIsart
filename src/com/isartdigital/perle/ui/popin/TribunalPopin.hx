package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
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
	private var fateAdjective:TextSprite;
	private var infoHeaven:TextSprite;
	private var infoHell:TextSprite;
	private var infoSoul:TextSprite;
	private var btnInviteSoul:SmartButton;
	private var cardSoul:UISprite;
	private var canMoovCard:Bool;
	private var baseCardRot:Float;
	private var baseMousePos:Point;
	private var baseCardPos:Point;
	private  var MOUSE_DIFF_MAX(null,never):Int = 200;
	private var DIFF_MAX(null,never):Int = 80;
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
		
		SoundManager.getSound("SOUND_OPEN_MENU_PURG").play();
		
		btnClose = cast(getChildByName(AssetName.PURGATORY_POPIN_CANCEL), SmartButton);
		//btnShop = cast(getChildByName(AssetName.PURGATORY_POPIN_SHOP), SmartButton);
		//btnIntern = cast(getChildByName(AssetName.PURGATORY_POPIN_INTERN), SmartButton);
		btnUpgrade = cast(getChildByName(AssetName.PURGATORY_POPIN_UPGRADE), SmartButton);
		//SmartCheck.traceChildrens(this);

		btnInviteSoul = cast(getChildByName(AssetName.PURGATORY_POPIN_INVITE_BUTTON), SmartButton);
		
		tribunalLevel = cast(getChildByName(AssetName.PURGATORY_POPIN_LEVEL), TextSprite);
		tribunalLevel.text = "LEVEL " + VTribunal.getInstance().tileDesc.level;
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_TIMER_CONTAINER);
		timer = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_TIMER), TextSprite);
		timer.text = "0" + 0 + "h" + "0" + 0 + "m" + "0" + 0 + "s";
		
		interMovieClip = cast(getChildByName(AssetName.PURGATORY_POPIN_SOUL_INFO),SmartComponent);
		fateName = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_NAME),TextSprite);
		fateName.text = VTribunal.getInstance().soulToJudge.name;
		fateAdjective = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_ADJ),TextSprite);
		fateAdjective.text = VTribunal.getInstance().soulToJudge.adjective;
		
		cardSoul = cast(getChildByName(AssetName.PURGATORY_POPIN_CARD), UISprite);
		baseCardRot = cardSoul.rotation;
		cardSoul.interactive = true;
		cardSoul.buttonMode = true;

		cardSoul.on(MouseEventType.MOUSE_DOWN, onMouseDownOnCard);
		cardSoul.on(MouseEventType.MOUSE_MOVE, onFollowMouse);
		cardSoul.on(MouseEventType.MOUSE_UP_OUTSIDE, onMouseUpOnCard);
		cardSoul.on(MouseEventType.MOUSE_UP, onMouseUpOnCard);
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HEAVEN_INFO);
		infoHeaven = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HELL_INFO);
		infoHell = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);	
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_INFO);
		infoSoul = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_NUMBER), TextSprite);	
		
		changeSoulTextInfo();
			
		Interactive.addListenerClick(btnInviteSoul, onInviteSoul);
		
		if (VTribunal.getInstance().canUpgrade()){
			Interactive.addListenerRewrite(btnUpgrade, rewriteUpgradeTxt);
			Interactive.addListenerClick(btnUpgrade, onUpgrade);
			rewriteUpgradeTxt();
		} else {
			btnUpgrade.parent.removeChild(btnUpgrade);
			btnUpgrade.destroy();
		}
		
		
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
		return cardSoul.position;
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
	
	private function onInviteSoul():Void {
		if (DialogueManager.ftueStepSlideCard)
			return;
			
		Facebook.ui ({
			method: 'apprequests',
			message:"Clique sur jouer, tu vas adorer :)"
		}, onRequest);
		
		SoundManager.getSound("SOUND_NEUTRAL").play();
		//Facebook.api(Facebook.uid+"/permissions",onHavePermission);
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
		if (!ResourcesManager.judgePopulation(Alignment.heaven)) return;
		
		SoundManager.getSound("SOUND_CHOICE_HEAVEN").play();
		changeSoulTextInfo();
		changeSoulText();
	}
	
	private function onHell() {
		if (DialogueManager.ftueStepSlideCard) {
			if (counterForFtue++ >= 1)
			DialogueManager.endOfaDialogue(null, true);
		}
		if (!ResourcesManager.judgePopulation(Alignment.hell)) return;
		SoundManager.getSound("SOUND_CHOICE_HELL").play();
		changeSoulTextInfo();
		changeSoulText();
		
	}
	
	private function changeSoulText(?pSoulNameFound:Bool):Void {
		if(!pSoulNameFound ||pSoulNameFound == null) VTribunal.getInstance().findSoul();
		fateName.text = VTribunal.getInstance().soulToJudge.name;
		fateAdjective.text = VTribunal.getInstance().soulToJudge.adjective;
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
		//Interactive.removeListenerClick(btnShop, onShop);
		//Interactive.removeListenerClick(btnIntern, onIntern);
		if (VTribunal.getInstance().canUpgrade()) Interactive.removeListenerClick(btnUpgrade, onUpgrade);
		
		instance = null;
		
		super.destroy();
	}

}