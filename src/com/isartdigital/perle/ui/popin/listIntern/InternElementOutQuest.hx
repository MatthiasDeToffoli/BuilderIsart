package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * the bloc when intern is not in quest
 * @author de Toffoli Matthias
 */
class InternElementOutQuest extends InternElement
{
	
	private var btnSend:SmartButton;
	private var idIntern:Int;
	private var internDatas:InternDescription;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, updateQuestHud);
		picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		//btnSend= cast(getChildByName(AssetName.BUTTON_SEND_OUT_QUEST), SmartButton);
		spawnButton("_spawner_buttonStress_accelerate");
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
		internName.text = pDesc.name;
		
		internDatas = pDesc;
		idIntern = pDesc.id;
		
		Interactive.addListenerClick(picture, onPicture);
		//Interactive.addListenerClick(btnSend, onSend);
		
	}
	
	private function spawnButton(spawnerName:String):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		btnSend = new SendButton(spawner.position);
		//btnSend = new StressButton(spawner.position);
		btnSend.position = spawner.position;
		Interactive.addListenerClick(btnSend, onSend);
		
		addChild(btnSend);
		destroySpawner(spawner);
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
		var lLength:Int = QuestsManager.questsList.length;
		//var lRandomEvent:Int = Math.round(Math.random() * 3 + 1);
		var lQuest:TimeQuestDescription = QuestsManager.createQuest(idIntern);
		internDatas.quest = lQuest;
		TimeManager.createTimeQuest(lQuest);
		
		//For the actualisation of the switch outQuest/InQuest
		UIManager.getInstance().closeCurrentPopin();
		InternElementInQuest.canPushNewScreen = true;
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	//For the HUD Popin actualisation
	private function updateQuestHud(pQuest:TimeQuestDescription):Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}

	override public function destroy():Void 
	{
		Interactive.removeListenerClick(picture, onPicture);
		//Interactive.removeListenerClick(btnSend, onSend);
		super.destroy();
	}
}