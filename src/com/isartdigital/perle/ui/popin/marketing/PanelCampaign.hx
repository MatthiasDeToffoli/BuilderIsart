package com.isartdigital.perle.ui.popin.marketing;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.managers.AdsManager;
import com.isartdigital.perle.game.managers.AdsManager.AdsData;
import com.isartdigital.perle.game.managers.BlockAdAndInvitationManager;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.MarketingManager.Campaign;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.sounds.SoundManager;
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
		
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
		
		btnCampaigns = new Array<SmartButton>();
		
		addCampaignButton(AssetName.MARKETING_CAMPAIGN + AssetName.VIDEO, 0);
		
		var i:Int;
		
		for (i in 0...3) {
			addCampaignButton(AssetName.MARKETING_CAMPAIGN + (i + 1), i + 1);
			rewriteBtnText(i + 1);
		}
		
		if (!BlockAdAndInvitationManager.canI(Provenance.marketing)) btnCampaigns[0].alpha = 0.5; 
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
		var myClock:Clock = TimesInfo.getClock(TimesInfo.calculDateDiff(campaignWant.time.times,Date.fromTime(0).getTime()));
		
		var txt:TextSprite = cast(SmartCheck.getChildByName(interMc, AssetName.CAMPAIGN_BOOST_VALUE), TextSprite);
		txt.text = campaignWant.boost + "";
		
		txt = cast(SmartCheck.getChildByName(interMc, AssetName.CAMPAIGN_TIME_VALUE), TextSprite);
		txt.text =  " /" + myClock.day + ":" + myClock.hour + ":" + myClock.minute + ":" + myClock.seconde;
		
	}
	
	private function onClickVideo():Void {
		if (!BlockAdAndInvitationManager.canI(Provenance.marketing)) return;
		
		SoundManager.getSound("SOUND_NEUTRAL").play();
		AdsManager.playAd(callBackAd);
	}
	
	private function onCLickSmall():Void {
		rewriteSmall();
		SoundManager.getSound("SOUND_NEUTRAL").play();
		clickCampaign(CampaignType.small);
		
	}
	
	private function onClickMedium():Void {
		rewriteMedium();
		SoundManager.getSound("SOUND_NEUTRAL").play();
		clickCampaign(CampaignType.medium);
		
	}
	
	private function onClickLarge():Void {
		rewriteLarge();
		SoundManager.getSound("SOUND_NEUTRAL").play();
		clickCampaign(CampaignType.large);
		
	}
	
	private function clickCampaign(pType:CampaignType):Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
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
		txt.text = MarketingManager.getCampaignByIndice(i).price + "";
	}
	
	private function callBackAd ():Void {
		BlockAdAndInvitationManager.blockForOneDay(Provenance.marketing);
		clickCampaign(CampaignType.ad);
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