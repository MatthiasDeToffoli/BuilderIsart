package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.InternElement;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
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
	private var internDescriptionArray:Array<InternElement> = new Array<InternElement>();
	
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
			
			btnClose = cast(getChildByName(AssetName.INTERN_LIST_CANCEL), SmartButton);
			btnLeft = cast(getChildByName(AssetName.INTERN_LIST_LEFT), SmartButton);
			btnRight = cast(getChildByName(AssetName.INTERN_LIST_RIGHT), SmartButton);
			spawnInternDescription(AssetName.INTERN_LIST_SPAWNER0, {id:1, name:"Vic", isInQuest:true});
			spawnInternDescription(AssetName.INTERN_LIST_SPAWNER1, {id:2, name:"Meli", isInQuest:true});
			spawnInternDescription(AssetName.INTERN_LIST_SPAWNER2, {id:3, name:"Kiki", isInQuest:false});

			btnLeft.on(MouseEventType.CLICK, onLeft);
			btnRight.on(MouseEventType.CLICK, onRight);
			btnClose.on(MouseEventType.CLICK, onClose);
	}
	
	/**
	 * create a bloc contain intern description
	 * @param	spawnerName the name of the spawner
	 * @param	 the descritpion of the intern
	 */
	private function spawnInternDescription(spawnerName:String, pDesc:InternDescription):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		var blocDescription:InternElement = pDesc.isInQuest ? new InternElementInQuest(spawner.position, pDesc): new InternElementOutQuest(spawner.position, pDesc);
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
	
	private function onClose(){
		Hud.getInstance().show();
		destroy();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		var myElement:InternElement;
		
		for (myElement in internDescriptionArray) myElement.destroy();
		instance = null;
		parent.removeChild(this);
		super.destroy();
	}

}