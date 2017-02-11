package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.popin.listIntern.SendButton;
import com.isartdigital.perle.ui.popin.listIntern.StressButton;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
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
	private var quest:TimeQuestDescription;
	
	private var internSpeed:TextSprite;
	private var internStress:TextSprite;
	private var internEfficiency:TextSprite;
	private var sendCost:TextSprite;
	
	private var stressJauge:SmartComponent;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	
	private var jaugeArray:Array<Array<UISprite>>;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		
		getComponents();
		setValues(pDesc);
		
		internDatas = pDesc;
		
		spawnButton(AssetName.SPAWNER_BUTTON_OUT_QUEST);
	}

	private function getComponents():Void{
		picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		sendCost = cast(getChildByName(AssetName.INTERN_OUT_SEND_COST), TextSprite);
		
		//internStress = cast(getChildByName(AssetName.INTERN_STRESS_TXT), TextSprite);
		//internSpeed = cast(getChildByName(AssetName.INTERN_SPEED_TXT), TextSprite);
		//internEfficiency = cast(getChildByName(AssetName.INTERN_OUT_EFF_TXT), TextSprite);
		
		stressJauge = cast(getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		speedJauge = cast(getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
	}
	
	private function setValues(pDesc:InternDescription):Void{
		sendCost.text = Std.string(pDesc.price);
		//internStress.text = Std.string(Intern.TXT_STRESS);
		//internSpeed.text = Std.string(Intern.TXT_SPEED);
		//internEfficiency.text = Std.string(Intern.TXT_EFFICIENCY);
		
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
			}
		
		var iEff:Int =  6 - internDatas.efficiency;
		for (i in 1...iEff)
			cast(effJauge.getChildAt(i), UISprite).visible = false;
			
		var iSpeed:Int = 6 - internDatas.speed;
		for (i in 1...iSpeed)
			cast(speedJauge.getChildAt(i), UISprite).visible = false;
			
		var iStress:Int = 6 - Math.floor(internDatas.stress / 20);
		for (i in 1...iStress)
			cast(stressJauge.getChildAt(i), UISprite).visible = false;
	}
	
	private function addListerners():Void{
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, updateQuestHud);
		Interactive.addListenerClick(picture, onPicture);
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
		trace("send");
		if (DialogueManager.ftueStepSendIntern)
			DialogueManager.endOfaDialogue();
		
		//var lLength:Int = QuestsManager.questsList.length;
		quest = QuestsManager.createQuest(internDatas.id);
		
		internDatas.quest = quest;
		ChoiceManager.newChoice(internDatas.id);
		internDatas.idEvent = ChoiceManager.selectChoice(ChoiceManager.actualID).iD;
		TimeManager.createTimeQuest(quest);
		
		ResourcesManager.spendTotal(GeneratorType.soft, internDatas.price);
		
		//For the actualisation of the switch outQuest/InQuest
		UIManager.getInstance().closeCurrentPopin();
		InternElementInQuest.canPushNewScreen = true;
		
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	private function onStress(){
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(MaxStressPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(MaxStressPopin.getInstance());
	}
	
	//For the HUD Popin actualisation
	private function updateQuestHud(pQuest:TimeQuestDescription):Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}

	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnSend, onSend);
		Interactive.removeListenerClick(picture, onPicture);
		super.destroy();
	}
}