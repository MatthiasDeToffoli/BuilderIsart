package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.popin.listIntern.SendButton;
import com.isartdigital.perle.ui.popin.listIntern.StressButton;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import js.Lib;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * the bloc when intern is not in quest
 * @author de Toffoli Matthias
 * @author Emeline Berenguier
 */
class InternElementOutQuest extends InternElement
{
	
	private var btnSend:SmartButton;
	private var btnMaxStress:SmartButton;
	private var internDatas:InternDescription;
	
	private var internSpeed:TextSprite;
	private var internStress:TextSprite;
	private var internEfficiency:TextSprite;
	private var sendCost:TextSprite;
	
	private var stressJauge:SmartComponent;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	private var stressGaugeMask:UISprite;
	private var stressGaugeBar:UISprite;
	
	private var speedIndics:Array<UISprite>;
	private var effIndics:Array<UISprite>;
	
	private var jaugeArray:Array<Array<UISprite>>;
	private static inline var QUEST_PRICE:Int = 500;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		internDatas = pDesc;
		
		getComponents();
		spawnButton(AssetName.SPAWNER_BUTTON_OUT_QUEST);
		setValues(pDesc);
	}

	private function getComponents():Void{
		//picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		stressJauge = cast(getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		speedJauge = cast(getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		stressGaugeMask = cast(SmartCheck.getChildByName(stressJauge, "jaugeStress_masque"), UISprite);
		stressGaugeBar = cast(SmartCheck.getChildByName(stressJauge, "_jaugeStres"), UISprite);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
		
		initStars();
	}
	
	private function initStars():Void {
		var speedIndics = new Array<UISprite>();
		var effIndics = new Array<UISprite>();
		
		for (i in 1...6) {
			speedIndics.push(cast(speedJauge.getChildByName("_jaugeSpeed_0" + i), UISprite));
			effIndics.push(cast(effJauge.getChildByName("_jaugeEfficiency_0" + i), UISprite));
		}
		
		for (i in 0...5) {
			if (internDatas.efficiency <= i) speedIndics[i].visible = false;
		}
		
		for (i in 0...5) {
			if (internDatas.speed <= i) effIndics[i].visible = false;
		}
	}
	
	private function setValues(pDesc:InternDescription):Void {
		if (pDesc.status != Intern.STATE_MAX_STRESS) {
			sendCost = cast(SmartCheck.getChildByName(btnSend, AssetName.INTERN_OUT_SEND_COST), TextSprite);
			sendCost.text = Std.string(QUEST_PRICE);
		}
		
		stressGaugeMask.scale.x = 0;
		stressGaugeBar.scale.x = 0;
		
		var iStress:Int = pDesc.stress;	
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
		
		internName.text = pDesc.name;
	}
	
	private function spawnButton(spawnerName:String):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		
		if (Intern.getIntern(internDatas.id).status == Intern.STATE_MAX_STRESS) {
			btnMaxStress = new StressButton(spawner.position);
			btnMaxStress.position = spawner.position;
			Interactive.addListenerClick(btnMaxStress, onStress);
			addChild(btnMaxStress);
		}		
		else {
			btnSend = new SendButton(spawner.position);
			btnSend.position = spawner.position;
			Interactive.addListenerClick(btnSend, onSend);
			addChild(btnSend);
			sendCost = cast(SmartCheck.getChildByName(btnSend, AssetName.INTERN_OUT_SEND_COST), TextSprite);
			Interactive.addListenerRewrite(btnSend, onHover);
		}
			
		var iStress:Int = internDatas.stress;
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
		spawner.visible = false;
	}
	
	public function onHover():Void {
		setValues(internDatas);
	}
	
	public function getSendPos():Point {
		return btnSend.position;
	}
	
	private function addListerners():Void{
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, updateQuestHud);
		//Interactive.addListenerClick(picture, onPicture);
	}
	
	/**
	 * destroy the spawner
	 * @param spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	private function onSend(){
		if (DialogueManager.ftueStepSendIntern) {
			Intern.getIntern(internDatas.id).stress = 0;
			DialogueManager.endOfaDialogue();
		}

		if (Intern.numberInternsInQuest() <= UnlockManager.getNumberPlaces()){
			SoundManager.getSound("SOUND_SEND_INTERN").play();
			sendInternInQuest();
		}
		
		if(!DialogueManager.ftueStepSendIntern || !DialogueManager.ftueStepMakeAllChoice || !DialogueManager.ftueStepMakeChoice)
			ResourcesManager.spendTotal(GeneratorType.soft, QUEST_PRICE);
		
		//For the actualisation of the switch outQuest/InQuest
		UIManager.getInstance().closeCurrentPopin();
		InternElementInQuest.canPushNewScreen = true;
		
		Interactive.removeListenerRewrite(btnSend, onHover);
	}
	
	private function onStress(){
		var lQuest = QuestsManager.getQuest(internDatas.id);
		
		UIManager.getInstance().closeCurrentPopin();
		MaxStressPopin.quest = lQuest;
		MaxStressPopin.intern = internDatas;
		UIManager.getInstance().openPopin(MaxStressPopin.getInstance());
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function sendInternInQuest():Void {
		if (ResourcesManager.getTotalForType(GeneratorType.soft) - QUEST_PRICE >= 0) {
			QuestsManager.createQuest(internDatas.id, QUEST_PRICE);
			
			quest = QuestsManager.getQuest(internDatas.id);
			internDatas.quest = quest;
			Intern.getIntern(internDatas.id).quest = internDatas.quest;
			Intern.getIntern(internDatas.id).status = Intern.STATE_RESTING;
			
			ChoiceManager.newChoice(internDatas.id);
			internDatas.idEvent = ChoiceManager.selectChoice(ChoiceManager.actualID).iD;
			TimeManager.createTimeQuest(quest);
		}
		else Browser.alert("You don't have enought money to do this.");
	}
	
	//For the HUD Popin actualisation
	private function updateQuestHud(pQuest:TimeQuestDescription):Void{
		UIManager.getInstance().closePopin(ListInternPopin.getInstance());
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}

	override public function destroy():Void 
	{
		if (btnMaxStress != null) Interactive.addListenerClick(btnMaxStress, onStress);
		if (btnSend != null) Interactive.removeListenerClick(btnSend, onSend);
		//Interactive.removeListenerClick(picture, onPicture);
	
		super.destroy();
	}
}