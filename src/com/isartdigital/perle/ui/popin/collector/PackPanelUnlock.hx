package com.isartdigital.perle.ui.popin.collector;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.managers.AdsManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class PackPanelUnlock extends PackPanel
{
	var btnLunch:SmartButton;
	
	public function new(i:Int) 
	{
		super(AssetName.PACK_COLLECTOR_PANEL, i);
		
		
		
		btnLunch = cast(SmartCheck.getChildByName(this, AssetName.PANEL_COLLECTOR_BUTTON), SmartButton);
		
		rewrite();
		
		Interactive.addListenerClick(btnLunch, onClick);
		Interactive.addListenerRewrite(btnLunch, rewrite);
		
		
	}
	
	private function onClick(){
		rewrite();
		SoundManager.getSound("SOUND_WOOD_PROD").play();
		vBuildingLink.startProduction(pack);
		CollectorPopin.getInstance().switchPanel();
		AdsManager.playAdPictureWithCounter();
	}
	
	private function rewrite(){
		var btnText:TextSprite = cast(SmartCheck.getChildByName(btnLunch, AssetName.PANEL_COLLECTOR_BUTTON_TEXT), TextSprite);
		btnText.text = "" + pack.cost;
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnLunch, onClick);
		Interactive.removeListenerRewrite(btnLunch, rewrite);
		
		super.destroy();
	}
	
}