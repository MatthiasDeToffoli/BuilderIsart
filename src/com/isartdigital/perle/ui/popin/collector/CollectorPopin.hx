package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class CollectorPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe CollectorPopin
	 */
	private static var instance: CollectorPopin;
	
	private var prodPanel:ProductionPanel;
	private var btnClose:SmartButton;
	private var timer:TimerInProd;
	
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
		
		var myCollector:VCollector = cast(BuildingHud.virtualBuilding, VCollector);
		
		btnClose = cast(SmartCheck.getChildByName(this, "ButtonClose"), SmartButton);
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, "_productionSpawner"), UISprite);
			
		if (myCollector.product) addTimer(spawner,myCollector);
		else addPanel(spawner);
		
		spawner.parent.removeChild(spawner);
		Interactive.addListenerClick(btnClose, onClose);
		
	}
	
	private function addPanel(spawner:UISprite):Void{
		prodPanel = new ProductionPanel();
		prodPanel.position = spawner.position;
		
		addChild(prodPanel);
	}
	
	private function addTimer(spawner:UISprite, pCollector:VCollector):Void {
		timer = new TimerInProd(pCollector);
		timer.position = spawner.position;
		
		addChild(timer);
	}
	public function onClose(){
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(btnClose, onClose);
		super.destroy();
	}

}