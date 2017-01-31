package com.isartdigital.perle.ui.popin.marketing;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.MarketingManager.Campaign;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class PanelCampaign extends SmartComponent
{

	private var btnCampaigns:Array<SmartButton>;
	
	public function new() 
	{
		super(AssetName.MARKETING_PANEL_CAMPAIGN);
		
		btnCampaigns = new Array<SmartButton>();
		
		addCampaignButton(AssetName.MARKETING_CAMPAIGN + AssetName.VIDEO, 0);
		
		var i:Int;
		
		for (i in 0...3) {
			addCampaignButton(AssetName.MARKETING_CAMPAIGN + (i + 1), i + 1);
			rewriteBtnText(i + 1);
		}
		//SmartCheck.traceChildrens(this);
		
		addButtonsListener(btnCampaigns[0], onClickVideo);
		addButtonsListener(btnCampaigns[1], onCLickSmall,rewriteSmall);
		addButtonsListener(btnCampaigns[2], onClickMedium,rewriteMedium);
		addButtonsListener(btnCampaigns[3], onClickLarge,rewriteLarge);
		
		
	}
	
	private function addButtonsListener(btn:SmartButton, callBackClick:Void -> Void, ?callBackRewrite:Void -> Void):Void {
		Interactive.addListenerClick(btn, callBackClick);
		if (callBackRewrite != null) Interactive.addListenerRewrite(btn, callBackRewrite);
	}
	
	private function removeButtonsListener(btn:SmartButton, callBackClick:Void -> Void, ?callBackRewrite:Void -> Void):Void {
		Interactive.removeListenerClick(btn, callBackClick);
		if (callBackRewrite != null) Interactive.removeListenerRewrite(btn, callBackRewrite);
	}
	
	private function addCampaignButton(pName:String,indice:Int):Void {
		var interMc:SmartComponent = cast(SmartCheck.getChildByName(this, pName), SmartComponent);
		
		btnCampaigns.push(cast(SmartCheck.getChildByName(interMc, indice == 0 ? AssetName.VIDEO_BTN:AssetName.CAMPAIGN_BTN), SmartButton));
		
		var campaignWant:Campaign = MarketingManager.getCampaignByIndice(indice);
		var myClock:Clock = TimesInfo.getClock(campaignWant.time);
		
		var txt:TextSprite = cast(SmartCheck.getChildByName(interMc, AssetName.CAMPAIGN_BOOST_VALUE), TextSprite);
		txt.text = campaignWant.boost + "";
		
		txt = cast(SmartCheck.getChildByName(interMc, AssetName.CAMPAIGN_TIME_VALUE), TextSprite);
		txt.text =  " /" + myClock.minute + ":" + myClock.seconde;
		
	}
	
	private function onClickVideo():Void {
		Ads.getMovie(callBackAd);
	}
	
	private function onCLickSmall():Void {
		rewriteSmall();
		clickCampaign(CampaignType.small);
		
	}
	
	private function onClickMedium():Void {
		rewriteMedium();
		clickCampaign(CampaignType.medium);
		
	}
	
	private function onClickLarge():Void {
		rewriteLarge();
		clickCampaign(CampaignType.large);
		
	}
	
	private function clickCampaign(pType:CampaignType):Void {
		MarketingManager.setCampaign(pType);
		MarketingPopin.getInstance().switchPanel();
	}
	
	private function rewriteSmall():Void {
		rewriteBtnText(1);
	}
	
	private function rewriteMedium():Void {
		rewriteBtnText(2);
	}
	
	private function rewriteLarge():Void {
		rewriteBtnText(3);
	}
	
	private function rewriteBtnText(i:Int):Void {
		var txt:TextSprite = cast(SmartCheck.getChildByName(btnCampaigns[i], "Text"), TextSprite);
		txt.text = 0 + "";
	}
	
	private function callBackAd (pData:Dynamic):Void {
		if (pData == null) trace ("Erreur Service");
		else if (pData.error != null) trace (pData.error);
		else trace(pData);
	}

	override public function destroy():Void 
	{
		removeButtonsListener(btnCampaigns[0], onClickVideo);
		removeButtonsListener(btnCampaigns[1], onCLickSmall,rewriteSmall);
		removeButtonsListener(btnCampaigns[2], onClickMedium,rewriteMedium);
		removeButtonsListener(btnCampaigns[3], onClickLarge,rewriteLarge);
		btnCampaigns = null;
		parent.removeChild(this);
		
		super.destroy();
	}
	
}