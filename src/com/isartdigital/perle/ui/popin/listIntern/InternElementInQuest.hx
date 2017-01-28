package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.popin.InternPopin;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.UIComponent;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 * @author Emeline Berenguier
 */
class InternElementInQuest extends InternElement
{
	//public static var elementInQuestList:Map<Int, InternElementInQuest> = new Map<Int, InternElementInQuest>();
		
	public static var canPushNewScreen:Bool = false;
	//private var progressIndex:Int = 0;
	private var btnAccelerate:SmartButton;
	private var btnResolve:SmartButton;
	private var questTime:SmartComponent;
	private var heroCursor:UISprite;
	private var heroCursorStartPosition:Point;
	private var eventCursor1:UISprite;
	private var eventCursor2:UISprite;
	private var eventCursor3:UISprite;
	private var timeEvent:TextSprite;
	private var questGauge:SmartComponent;
	private var questGaugeLenght:Float;
	private var quest:TimeQuestDescription;
	private var newEvent:Bool = false;
	public var loop:Timer;
	
	//private var questInProgress:TimeQuestDescription;
	
	public static var eventCursorsArray:Array<UISprite>;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{		
		super(AssetName.INTERN_INFO_IN_QUEST, pPos);
				
		getComponents();
		
		eventCursorsArray = [eventCursor1, eventCursor2, eventCursor3];
		
		setOnSpawn(pDesc);
		spawnButton("Bouton_InternSend_Clip");
		addListeners();
	}
	
	private function getComponents():Void{
		internName = cast(getChildByName(AssetName.INTERN_NAME_IN_QUEST), TextSprite);
		
		questTime = cast(getChildByName(AssetName.TIME_IN_QUEST), SmartComponent);
		heroCursor = cast(SmartCheck.getChildByName(questTime, "_listInQuest_hero"), UISprite);
		heroCursorStartPosition = cast(SmartCheck.getChildByName(questTime, "_listInQuest_hero"), UISprite).position.clone();
		
		eventCursor1 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent01"), UISprite);
		eventCursor2 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent02"), UISprite);
		eventCursor3 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent03"), UISprite);
		
		timeEvent = cast(SmartCheck.getChildByName(questTime, "_listInQuest_eventTime"), TextSprite);
		picture = cast(getChildByName(AssetName.PORTRAIT_IN_QUEST), SmartButton);
		questGauge = cast(getChildByName("InQuest_ProgressionBar"), SmartComponent);
	}
	
	private function setOnSpawn(pDesc:InternDescription):Void{
		loop = Timer.delay(progressLoop, 10);
		loop.run = progressLoop;
		
		internName.text = pDesc.name;
		quest = pDesc.quest;
		
		questGaugeLenght = (questGauge.position.x / 1.75) - heroCursorStartPosition.x;
		
		for (i in 0...eventCursorsArray.length){
			eventCursorsArray[i].position.x = ((questGaugeLenght * quest.steps[i]) / quest.end) + heroCursorStartPosition.x;
		}
		
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_QUEST_STEP, changeButtons);
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_CHOICE_DONE, changeButtons);
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_QUEST_END, endQuest);
		
		timeEvent.text = TimeManager.getTextTimeQuest(pDesc.quest.end) + "s";
	}
	
	private function spawnButton(spawnerName:String):Void{
		trace(Intern.getIntern(quest.refIntern).status);
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		var lButton:SmartButton = null;
		
		//if (!newEvent){
		if (Intern.getIntern(quest.refIntern).status == Intern.STATE_RESTING){
			lButton = new AccelerateButton(spawner.position);
			Interactive.addListenerClick(lButton, onAccelerate);	
		}
		
		//else if (newEvent){
		else if (Intern.getIntern(quest.refIntern).status == Intern.STATE_WAITING){
			lButton = new ResolveButton(spawner.position);
			Interactive.addListenerClick(lButton, onResolve);	
		}
		
		else trace ("just an else");
		
		lButton.position = spawner.position;
		addChild(lButton);
		
		//destroySpawner(spawner); //@Todo: provisoire, en attente de mieux
	}
	
	private function addListeners():Void{
		//Interactive.addListenerClick(btnAccelerate, onAccelerate);
		Interactive.addListenerClick(picture, onPicture);
	}
	
	private function onAccelerate(){
		ResourcesManager.spendTotal(GeneratorType.hard, 2);
		if (!TimeManager.increaseQuestProgress(quest)) trace("quest end!");
	}
	
	private function onResolve(){
		trace("resolve");
		QuestsManager.choice(quest);
	}
	
	private function progressLoop():Void {
		
		if (heroCursor.position != null){
			updateEventCursors();
			timeEvent.text = TimeManager.getTextTimeQuest(quest.steps[quest.stepIndex] - quest.progress) + "s";
			updateCursorPosition();
			//updateButtons();
		}
		
		else {
			loop.stop();
		}
	}
	
	private function updateEventCursors():Void{
		
		for (i in 0...eventCursorsArray.length){
			if (i != quest.stepIndex) eventCursorsArray[i].alpha = 0.5;
			else eventCursorsArray[i].alpha = 1;
		}
	}
	
	private function updateCursorPosition():Void{
		if (quest.stepIndex != 3) {
			heroCursor.position.x = Math.min(((questGaugeLenght * quest.progress) / quest.end) + heroCursorStartPosition.x, ((questGaugeLenght * quest.steps[quest.stepIndex]) / quest.end) + heroCursorStartPosition.x);
		}
			
		else {
			eventCursor3.alpha = 1;
			heroCursor.position.x = ((questGaugeLenght * quest.steps[2]) / quest.end) + heroCursorStartPosition.x;
			timeEvent.text =  "00:00 s";
		}
	}
	
	private function changeButtons(?pQuest:TimeQuestDescription):Void{
		trace("change");
		//For the actualisation of the switch buttonResolve/Acelerate/Stress
		UIManager.getInstance().closeCurrentPopin();
		InternElementInQuest.canPushNewScreen = true;
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	private function reputButtons(pEvent:EventTarget):Void{
		newEvent = false;
	}
	
	/**
	 * Precaution function
	 * @param	pQuest
	 */
	private function endQuest(pQuest:TimeQuestDescription):Void{
		loop.stop();
	}
	
	
	/**
	 * destroy the spawner
	 * @param spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	override public function destroy():Void 
	{
		//Interactive.removeListenerClick(btnAccelerate, onAccelerate);
		Interactive.removeListenerClick(picture, onPicture);

		super.destroy();
	}
	
}