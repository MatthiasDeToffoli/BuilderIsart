package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.popin.InternPopin;
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

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 */
class InternElementInQuest extends InternElement
{
	//public static var elementInQuestList:Map<Int, InternElementInQuest> = new Map<Int, InternElementInQuest>();
		
	public static var canPushNewScreen:Bool = false;
	public var progressIndex:Int = 0;
	private var btnAccelerate:SmartButton;
	private var questTime:SmartComponent;
	public var heroCursor:UISprite;
	public var heroCursor2:UISprite;
	public var heroCursorStartPosition:Point;
	private var eventCursor1:UISprite;
	private var eventCursor2:UISprite;
	private var eventCursor3:UISprite;
	private var timeEvent:TextSprite;
	private var questGauge:SmartComponent;
	private var questGaugeLenght:Float;
	private var quest:TimeQuestDescription;
	private var intern:InternDescription;
	public var loop:Timer;
	
	public static var eventCursorsArray:Array<UISprite>;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{		
		super(AssetName.INTERN_INFO_IN_QUEST, pPos);
				
		getComponents();
		
		eventCursorsArray = [eventCursor1, eventCursor2, eventCursor3];
		
		setOnSpawn(pDesc);
		addListeners();
	}
	
	private function getComponents():Void{
		btnAccelerate = cast(getChildByName(AssetName.BUTTON_ACCELERATE_IN_QUEST), SmartButton);
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
		loop = Timer.delay(progressCursorLoop, 10);
		loop.run = progressCursorLoop;
		
		internName.text = pDesc.name;
		quest = pDesc.quest;
		intern = pDesc;
		
		questGaugeLenght = (questGauge.position.x / 1.75) - heroCursorStartPosition.x;
		
		for (i in 0...eventCursorsArray.length){
			eventCursorsArray[i].position.x = ((questGaugeLenght * quest.steps[i]) / quest.end) + heroCursorStartPosition.x;
		}
		
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_CONSTRUCT_END, endQuest);
		
		timeEvent.text = TimeManager.getTextTimeQuest(pDesc.quest.end) + "s";
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnAccelerate, onAccelerate);
		Interactive.addListenerClick(picture, onPicture);
	}
	
	private function onAccelerate(){
		trace("accelerate");
	}
	
	private function progressCursorLoop():Void {
		if (heroCursor.position != null){
			
			for (i in 0...eventCursorsArray.length){
				if (i != quest.stepIndex) eventCursorsArray[i].alpha = 0.5;
				else eventCursorsArray[i].alpha = 1;
			}
			
			timeEvent.text = TimeManager.getTextTimeQuest(quest.end - quest.progress) + "s";
			heroCursor.position.x = Math.min(((questGaugeLenght * quest.progress) / quest.end) + heroCursorStartPosition.x, ((questGaugeLenght * quest.steps[quest.stepIndex]) / quest.end) + heroCursorStartPosition.x);
		}
		
		else {
			trace("null");
			loop.stop();
		}
	}
	
	/**
	 * Precaution function
	 * @param	pQuest
	 */
	private function endQuest(pQuest:TimeQuestDescription):Void{
		loop.stop();
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnAccelerate, onAccelerate);
		Interactive.removeListenerClick(picture, onPicture);

		super.destroy();
	}
	
}