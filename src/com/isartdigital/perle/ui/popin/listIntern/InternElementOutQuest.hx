package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
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
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
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
	private var btnMaxStress:SmartButton;
	private var idIntern:Int;
	private var internDatas:InternDescription;
	private var quest:TimeQuestDescription;
	
	private var internSpeed:TextSprite;
	private var internStress:TextSprite;
	private var internEfficiency:TextSprite;
	private var sendCost:TextSprite;
	
	private var jaugeArray:Array<Array<UISprite>>;

	public function new(pPos:Point, pDesc:InternDescription) 
	{
		super(AssetName.INTERN_INFO_OUT_QUEST, pPos);
		
		picture = cast(getChildByName(AssetName.PORTRAIT_OUT_QUEST), SmartButton);
		
		sendCost = cast(getChildByName("sendCost"), TextSprite);
		sendCost.text = Std.string(pDesc.price);
		
		internStress = cast(getChildByName("_interns_stress"), TextSprite);
		internSpeed = cast(getChildByName("_intern_speed"), TextSprite);
		internEfficiency = cast(getChildByName("_txt_efficiency03"), TextSprite);
		internStress.text = Std.string(pDesc.stress);
		internSpeed.text = Std.string(pDesc.speed);
		internEfficiency.text = Std.string(pDesc.efficiency);
		
		internName = cast(getChildByName(AssetName.INTERN_NAME_OUT_QUEST), TextSprite);
		internName.text = pDesc.name;
		
		internDatas = pDesc;
		idIntern = pDesc.id;
		
		spawnButton(AssetName.SPAWNER_BUTTON_OUT_QUEST);
	}
	
	private function spawnButton(spawnerName:String):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		
		//if (idIntern != null){ //Todo: faire un switch
		//switch (Intern.getIntern(idIntern).status){
			//case Intern.STATE_RESTING : {
				//btnSend = new SendButton(spawner.position);
				//btnSend.position = spawner.position;
				//Interactive.addListenerClick(btnSend, onSend);
				//addChild(btnSend);
			//}
			//if (Intern.getIntern(idIntern).status == Intern.STATE_RESTING){
				//btnSend = new SendButton(spawner.position);
				//btnSend.position = spawner.position;
				//Interactive.addListenerClick(btnSend, onSend);
				//addChild(btnSend);
		if (Intern.getIntern(idIntern).status == Intern.STATE_MAX_STRESS){
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
			//}	
			//if (Intern.getIntern(idIntern).status == Intern.STATE_MAX_STRESS){
				//btnMaxStress = new StressButton(spawner.position);
				//btnMaxStress.position = spawner.position;
				//Interactive.addListenerClick(btnMaxStress, onStress);
				//addChild(btnMaxStress);
			//}		
		
		destroySpawner(spawner);
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
		//var lLength:Int = QuestsManager.questsList.length;
		quest = QuestsManager.createQuest(idIntern);
		
		internDatas.quest = quest;
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