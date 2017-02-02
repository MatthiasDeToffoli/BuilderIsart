package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.InternElement;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import pixi.core.display.DisplayObject;

	
/**
 * contain informations of all interns
 * @author de Toffoli Matthias
 */
class ListInternPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe InternPopin
	 */
	private static var instance: ListInternPopin;
	
	private var btnClose:SmartButton;
	private var btnLeft:SmartButton;
	private var btnRight:SmartButton;
	public var internDescriptionArray:Array<InternElement> = new Array<InternElement>();
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ListInternPopin {
		if (instance == null) instance = new ListInternPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.INTERN_LIST);
			
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
			btnClose = cast(getChildByName(AssetName.BTN_CLOSE), SmartButton);
			btnLeft = cast(getChildByName(AssetName.INTERN_LIST_LEFT), SmartButton);
			btnRight = cast(getChildByName(AssetName.INTERN_LIST_RIGHT), SmartButton);
			
			for (i in 0...AssetName.internListSpawners.length){
				if (i < Intern.internsListArray.length){
					spawnInternDescription(AssetName.internListSpawners[i], Intern.internsListArray[i]);
				}
				
				else destroySpawner(cast(getChildByName(AssetName.internListSpawners[i]), UISprite));
			}
			
			/*spawnInternDescription(AssetName.INTERN_LIST_SPAWNER0, {id:1, name:"Vic", isInQuest:true});
			spawnInternDescription(AssetName.INTERN_LIST_SPAWNER1, {id:2, name:"Meli", isInQuest:true});
			spawnInternDescription(AssetName.INTERN_LIST_SPAWNER2, {id:3, name:"Kiki", isInQuest:false});
		*/
		
		Interactive.addListenerClick(btnLeft, onLeft);
		Interactive.addListenerClick(btnRight, onRight);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	/**
	 * create a bloc contain intern description
	 * @param	spawnerName the name of the spawner
	 * @param	 the descritpion of the intern
	 */
	private function spawnInternDescription(spawnerName:String, pDesc:InternDescription):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		var blocDescription:InternElement = (pDesc.quest != null) ? new InternElementInQuest(spawner.position, pDesc): new InternElementOutQuest(spawner.position, pDesc);
		//var blocDescription:InternElement = new InternElementInQuest(spawner.position, pDesc);
		addChild(blocDescription);
		internDescriptionArray.push(blocDescription);
		destroySpawner(spawner);
	}
	
	/**
	 * destroy the spawner
	 * @param	spawner spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	private function onLeft(){
		trace("left");
	}
	
	private function onRight(){
		trace("right");
	}
	
	//@Matthias: je te la mets en public pour le feedback de l'envoi de quête, c'est temporaire
	public function onClose():Void {

		if (Choice.isVisible())
			return;
		
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnLeft, onLeft);
		Interactive.removeListenerClick(btnRight, onRight);
		Interactive.removeListenerClick(btnClose, onClose);
		
		var myInternDesc:InternDescription;
		for (myInternDesc in internDescriptionArray){
			myInternDesc.destroy();
			internDescriptionArray.shift();
		}
		instance = null;
		
		super.destroy();
	}

}