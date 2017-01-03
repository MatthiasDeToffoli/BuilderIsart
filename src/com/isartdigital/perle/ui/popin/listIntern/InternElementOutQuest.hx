package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * the bloc when intern is not in quest
 * @author de Toffoli Matthias
 */
class InternElementOutQuest extends InternElement
{
	
	private var btnSend:SmartButton;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		
		picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		btnSend= cast(getChildByName(AssetName.BUTTON_SEND_OUT_QUEST), SmartButton);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
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