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
import pixi.core.math.Point;

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 */
class InternElementInQuest extends InternElement
{

	private var btnAccelerate:SmartButton;
	private var questTime:GameObject;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_IN_QUEST,pPos);
		SmartCheck.traceChildrens(this);
		btnAccelerate = cast(getChildByName(AssetName.BUTTON_ACCELERATE_IN_QUEST), SmartButton);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_IN_QUEST), TextSprite);
		internName.text = pDesc.name;
		
		questTime = cast(getChildByName("InQuest_ProgressionBar"), GameObject);
		SmartCheck.traceChildrens(questTime);
		//questTime.text = TimeManager.getTextTimeQuest(pDesc.quest.end) + "s";
		
		picture = cast(getChildByName(AssetName.PORTRAIT_IN_QUEST), SmartButton);
		
		Interactive.addListenerClick(btnAccelerate, onAccelerate);
		Interactive.addListenerClick(picture, onPicture);
	}
	
	private function onAccelerate(){
		trace("accelerate");
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnAccelerate, onAccelerate);
		Interactive.removeListenerClick(picture, onPicture);
		super.destroy();
	}
	
}