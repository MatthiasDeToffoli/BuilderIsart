package com.isartdigital.perle.ui.popin.marketing;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class MarketingPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe MarketingPopin
	 */
	private static var instance: MarketingPopin;
	private var btnClose:SmartButton;
	private var panelCampaign:PanelCampaign;
	private var timer:TimerCampaign;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MarketingPopin {
		if (instance == null) instance = new MarketingPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.MARKETING_POPIN);
		
		//SmartCheck.traceChildrens(this);
		btnClose = cast(SmartCheck.getChildByName(this, AssetName.BTN_CLOSE), SmartButton);
		
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, "MarketingSpawner"), UISprite);
		if (MarketingManager.isInCampaign()) addTimer(spawner.position);
		else addPanel(spawner.position);
		spawner.parent.removeChild(spawner);
		spawner.destroy();
		
		TimeManager.eCampaign.on(TimeManager.EVENT_CAMPAIGN_FINE, switchPanel);
		Interactive.addListenerClick(btnClose,onClose);
	}
	
	private function addTimer(pPos:Point):Void {
		timer = new TimerCampaign();
		timer.position = pPos;
		addChild(timer);
	}
	
	private function addPanel(pPos:Point):Void {
		panelCampaign = new PanelCampaign();
		panelCampaign.position = pPos;
		addChild(panelCampaign);
	}
	
	private function onClose():Void {
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	public function switchPanel(?data:Dynamic):Void {
		if (panelCampaign != null) {
			addTimer(panelCampaign.position);
			panelCampaign.destroy();
			panelCampaign = null;
		} else if(timer != null) {
			addPanel(timer.position);
			timer.destroy();
			timer = null;
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		TimeManager.eCampaign.off(TimeManager.EVENT_CAMPAIGN_FINE, switchPanel);
		Interactive.removeListenerClick(btnClose, onClose);
		instance = null;
		super.destroy();
	}

}