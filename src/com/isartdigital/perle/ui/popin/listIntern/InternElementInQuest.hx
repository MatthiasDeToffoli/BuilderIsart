package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
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
import pixi.core.math.Point;

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 */
class InternElementInQuest extends InternElement
{
	public static var elementInQuestList:Map<Int, InternElementInQuest> = new Map<Int, InternElementInQuest>();

		
	public static var canPushNewScreen:Bool = false;
	public var progressIndex:Int = 0;
	private var btnAccelerate:SmartButton;
	private var questTime:SmartComponent;
	public var heroCursor:UISprite;
	private var eventCursor1:UISprite;
	private var eventCursor2:UISprite;
	private var eventCursor3:UISprite;
	private var timeEvent:TextSprite;
	
	public static var eventCursorsArray:Array<UISprite>;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{		
		super(AssetName.INTERN_INFO_IN_QUEST, pPos);
		
		btnAccelerate = cast(getChildByName(AssetName.BUTTON_ACCELERATE_IN_QUEST), SmartButton);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_IN_QUEST), TextSprite);
		internName.text = pDesc.name;
		
		questTime = cast(getChildByName(AssetName.TIME_IN_QUEST), SmartComponent);
		heroCursor = cast(SmartCheck.getChildByName(questTime, "_listInQuest_hero"), UISprite);
		eventCursor1 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent01"), UISprite);
		eventCursor2 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent02"), UISprite);
		eventCursor3 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent03"), UISprite);
		
		eventCursorsArray = [eventCursor1, eventCursor2, eventCursor3];
		
		timeEvent = cast(SmartCheck.getChildByName(questTime, "_listInQuest_eventTime"), TextSprite);
		
		//heroCursor.position =  eventCursor1.position;
		//eventCursor2.alpha = 0.5;
		//timeEvent.text = "2 min 35";
		//SmartCheck.traceChildrens(questTime);
		//questTime.text = TimeManager.getTextTimeQuest(pDesc.quest.end) + "s";
		
		picture = cast(getChildByName(AssetName.PORTRAIT_IN_QUEST), SmartButton);
		
		Interactive.addListenerClick(btnAccelerate, onAccelerate);
		Interactive.addListenerClick(picture, onPicture);
		
		if (canPushNewScreen) {
			elementInQuestList[pDesc.id] = this;
			canPushNewScreen = false;
		}
	}
	
	private function onAccelerate(){
		trace("accelerate");
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnAccelerate, onAccelerate);
		Interactive.removeListenerClick(picture, onPicture);
		//for (i in 0...elementInQuestList.length){
			//elementInQuestList.splice(i, 1);
		//}
		super.destroy();
	}
	
}