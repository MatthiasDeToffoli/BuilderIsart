package com.isartdigital.perle.ui.popin;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.InternElement;
import com.isartdigital.perle.ui.popin.listIntern.InternElementInQuest;
import com.isartdigital.perle.ui.popin.listIntern.InternElementOutQuest;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Emeline Berenguier
 */
class InternHousePopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe InternHousePopin
	 */
	private static var instance: InternHousePopin;
	
	private var btnClose:SmartButton;
	private var btnDismiss:SmartButton;
	private var questSpawner:UISprite;
	private var internName:TextSprite;
	private var internSide:TextSprite;
	private var internPortrait:UISprite;
	private var internsInQuest:SmartComponent;
	private var statsBg:SmartComponent;
	
	public var quest:TimeQuestDescription = null;
	private var intern:InternDescription = null;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): InternHousePopin {
		if (instance == null) instance = new InternHousePopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.INTERN_HOUSE_INFOS_POPIN);
		SmartCheck.traceChildrens(this);
		intern = Intern.internsListArray[0];
		getComponents();
		setValues();
		addListeners();
		//spawnQuest(intern);
		spawnQuest();
	}
	
	private function getComponents():Void{
		btnClose = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_CLOSE_BUTTON), SmartButton);
		btnDismiss = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_DISMISS_BUTTON), SmartButton);
		questSpawner = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_QUESTS_SPAWNER), UISprite);
		internName = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_INTERN_NAME), TextSprite);
		internSide = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_INTERN_SIDE), TextSprite);
		internPortrait = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_PORTRAIT), UISprite);
		statsBg = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_STATS), SmartComponent);
		internsInQuest = cast(getChildByName(AssetName.INTERN_HOUSE_INFOS_POPIN_INTERNS_IN_QUEST), SmartComponent);
		
	}
	
	private function setValues():Void{
		if (intern != null){
			internName.text = intern.name;
			internSide.text = intern.aligment;
		}
		
		else {
			internName.text = "No Intern";
			//ToDo: dry
			destroyElement(internSide);	
			destroyElement(statsBg);
			destroyElement(btnDismiss);
			destroyElement(internsInQuest);
		}

	}
	
	private function spawnQuest(pDesc:InternDescription = null):Void{
		if (pDesc != null){
			var blocDescription:InternElement = (pDesc.quest != null) ? new InternElementInQuest(questSpawner.position, pDesc): new InternElementOutQuest(questSpawner.position, pDesc);
			//var blocDescription:InternElement = new InternElementInQuest(spawner.position, pDesc);
			addChild(blocDescription);
			ListInternPopin.getInstance().internDescriptionArray.push(blocDescription);
		}

		destroySpawner(questSpawner);
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onClose():Void{
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * destroy the spawner
	 * @param	spawner spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	/**
	 * destroy an element of the popin
	 * @param pElement element to destroy
	 */
	private function destroyElement(pElement:Dynamic):Void{	
		pElement.parent.removeChild(pElement);
		pElement.destroy();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}