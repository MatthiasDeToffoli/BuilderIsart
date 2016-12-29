package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * ...
 * @author de Toffoli Matthias
 */

  /**
  * the bloc when intern is not in quest
  */
class InternElementOutQuest extends InternElement
{
	
	private var btnSend:SmartButton;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super("ListOutQuest", pPos);
		
		picture = cast(getChildByName("OutQuest_Portrait"), SmartButton);
		btnSend= cast(getChildByName("Bouton_SendIntern_List"), SmartButton);
		
		internName = cast(getChildByName("_intern03_name05"), TextSprite);
		internName.text = pDesc.name;
		
		picture.on(MouseEventType.CLICK, onPicture);
		btnSend.on(MouseEventType.CLICK, onSend);
		
	}
	
	private function onSend(){
		trace("send");
	}
	
	override public function destroy():Void 
	{
		btnSend.off(MouseEventType.CLICK, onSend);
		super.destroy();
	}
}