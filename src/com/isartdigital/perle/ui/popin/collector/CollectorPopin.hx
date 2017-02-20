package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class CollectorPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe CollectorPopin
	 */
	private static var instance: CollectorPopin;
	
	private var prodPanel:ProductionPanel;
	private var btnClose:SmartButton;
	private var timer:TimerInProd;
	private var myCollector:VCollector;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CollectorPopin {
		if (instance == null) instance = new CollectorPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.COLLECTOR_POPIN);
		
		myCollector = cast(BuildingHud.virtualBuilding, VCollector);
		
		btnClose = cast(SmartCheck.getChildByName(this, AssetName.BTN_CLOSE), SmartButton);
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, "_productionSpawner"), UISprite);
			
		if (myCollector.product) addTimer(spawner.position,myCollector);
		else addPanel(spawner.position);
		
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
		
		spawner.parent.removeChild(spawner);
		Interactive.addListenerClick(btnClose, onClose);
		
	}
	
	private function addPanel(pPos:Point):Void{
		prodPanel = new ProductionPanel();
		prodPanel.position = pPos;
		
		addChild(prodPanel);
	}
	
	public function getTimer():TimerInProd {
		return timer;
	}
	
	private function addTimer(pPos:Point, pCollector:VCollector):Void {
		timer = new TimerInProd(pCollector);
		timer.position = pPos;
		
		addChild(timer);
	}
	
	public function switchPanel():Void {
		if (prodPanel != null) {
			addTimer(prodPanel.position, myCollector);
			prodPanel.destroy();
			prodPanel = null;
		} else if(timer != null) {
			addPanel(timer.position);
			timer.destroy();
			timer = null;
		}
	}
	
	public function onClose(){
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		myCollector = null;
		instance = null;
		Interactive.removeListenerClick(btnClose, onClose);
		super.destroy();
	}

}