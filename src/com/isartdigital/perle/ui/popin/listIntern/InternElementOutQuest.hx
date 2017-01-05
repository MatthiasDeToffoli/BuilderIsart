package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.TimeManager;
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
	private var idIntern:Int;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		
		picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		btnSend= cast(getChildByName(AssetName.BUTTON_SEND_OUT_QUEST), SmartButton);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
		internName.text = pDesc.name;
		
		idIntern = pDesc.id;
		
		picture.on(MouseEventType.CLICK, onPicture);
		btnSend.on(MouseEventType.CLICK, onSend);
		
	}
	
	private function onSend(){
		trace("send");
		var lLength:Int = QuestsManager.questsList.length;
		//Créer random quest ici
		for (i in 0...lLength){
			if (QuestsManager.questsList[i].refIntern == idIntern){
				TimeManager.createTimeQuest(QuestsManager.questsList[i]);
			}
		}
		//Todo: Temporaire! En attendant d'avoir plus de précision sur le wireframe
		//var lRandomEvent:Int = Math.round(Math.random() * 3 + 1);
		//var lQuest:Quest = new Quest(lRandomEvent);
		//QuestsManager.createQuest(lRandomEvent);
	}
	
	override public function destroy():Void 
	{
		btnSend.off(MouseEventType.CLICK, onSend);
		super.destroy();
	}
}