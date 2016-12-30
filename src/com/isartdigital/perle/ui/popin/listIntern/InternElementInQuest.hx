package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.popin.InternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 */
class InternElementInQuest extends InternElement
{

	private var btnAccelerate:SmartButton;
	private var questTime:TextSprite;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super("ListInQuest",pPos);
			
		btnAccelerate = cast(getChildByName("Bouton_InternSend_Clip"), SmartButton);
		
		internName = cast(getChildByName("InQuest_name"), TextSprite);
		internName.text = pDesc.name;
		
		questTime = cast(getChildByName("InQuest_time"), TextSprite);
		questTime.text = 98 +  "h";
		
		picture = cast(getChildByName("InQuest_Portrait"), SmartButton);
		
		btnAccelerate.on(MouseEventType.CLICK, onAccelerate);
		picture.on(MouseEventType.CLICK, onPicture);
	}
	
	private function onAccelerate(){
		trace("accelerate");
	}
	
	override public function destroy():Void 
	{
		btnAccelerate.off(MouseEventType.CLICK, onAccelerate);
		super.destroy();
	}
	
}