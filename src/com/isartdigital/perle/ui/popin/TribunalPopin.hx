package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;

	
/**
 * tribunal description and all action we can do with this
 * @author de Toffoli Matthias
 */
class TribunalPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe TribunalPopin
	 */
	private static var instance: TribunalPopin;
	private var btnClose:SmartButton;
	private var btnShop:SmartButton;
	private var btnIntern:SmartButton;
	private var btnHeaven:SmartButton;
	private var btnHell:SmartButton;
	private var btnUpgrade:SmartButton;
	private var tribunalLevel:TextSprite;
	private var timer:TextSprite;
	private var fateName:TextSprite;
	private var fateAdjective:TextSprite;
	private var upgradePrice:TextSprite;
	private var infoHeaven:TextSprite;
	private var infoHell:TextSprite;
	private var infoSoul:TextSprite;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TribunalPopin {
		if (instance == null) instance = new TribunalPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.PURGATORY_POPIN);
		
		var interMovieClip:Dynamic;
		
		btnClose = cast(getChildByName(AssetName.PURGATORY_POPIN_CANCEL), SmartButton);
		btnShop = cast(getChildByName(AssetName.PURGATORY_POPIN_SHOP), SmartButton);
		btnIntern = cast(getChildByName(AssetName.PURGATORY_POPIN_INTERN), SmartButton);
		btnHeaven = cast(getChildByName(AssetName.PURGATORY_POPIN_HEAVEN_BUTTON), SmartButton);
		btnHell = cast(getChildByName(AssetName.PURGATORY_POPIN_HELL_BUTTON), SmartButton);
		btnUpgrade = cast(getChildByName(AssetName.PURGATORY_POPIN_UPGRADE), SmartButton);

		upgradePrice = cast(btnUpgrade.getChildByName(AssetName.PURGATORY_POPIN_UPGRADE_PRICE), TextSprite);
		upgradePrice.text = 2000 + "$";
		
		tribunalLevel = cast(getChildByName(AssetName.PURGATORY_POPIN_LEVEL), TextSprite);
		tribunalLevel.text = "LEVEL " + 1;
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_TIMER_CONTAINER);
		timer = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_TIMER), TextSprite);
		timer.text = "0" + 0 + "h" + "0" + 0 + "m" + "0" + 0 + "s";
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_SOUL_INFO);
		fateName = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_NAME),TextSprite);
		fateName.text = "Ambroise";
		fateAdjective = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_SOUL_ADJ),TextSprite);
		fateAdjective.text = "Boss";
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HEAVEN_INFO);
		infoHeaven = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);
		infoHeaven.text = "0";
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_HELL_INFO);
		infoHell = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_INFO_BAR), TextSprite);	
		infoHell.text = "0";
		
		interMovieClip = getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_INFO);
		infoSoul = cast(interMovieClip.getChildByName(AssetName.PURGATORY_POPIN_ALL_SOULS_NUMBER), TextSprite);	
		infoSoul.text = "0";
			
		btnUpgrade.on(MouseEventType.MOUSE_OVER, rewriteUpgradeTxt);
		btnUpgrade.on(MouseEventType.MOUSE_OUT, rewriteUpgradeTxt);
		btnUpgrade.on(MouseEventType.MOUSE_DOWN, rewriteUpgradeTxt);
		btnClose.on(MouseEventType.CLICK, onClose);
		btnHeaven.on(MouseEventType.CLICK, onHeaven);
		btnHell.on(MouseEventType.CLICK, onHell);
		btnShop.on(MouseEventType.CLICK, onShop);
		btnIntern.on(MouseEventType.CLICK, onIntern);
		btnUpgrade.on(MouseEventType.CLICK, onUpgrade);
	}
	
	private function onClose() {
		UIManager.getInstance().closeCurrentPopin();	
		Hud.getInstance().show();
	}
	
	private function onShop(){
		UIManager.getInstance().closeCurrentPopin();	
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
	}
	
	private function onIntern() {
		UIManager.getInstance().closeCurrentPopin();	
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	private function onHeaven(){
		trace("heaven");
	}
	
	private function onHell(){
		trace("hell");
	}
	
	private function onUpgrade(){
		rewriteUpgradeTxt();
		trace("upgrade");
	}
	
	private function rewriteUpgradeTxt(){
		upgradePrice = cast(btnUpgrade.getChildByName("Cost"), TextSprite);
		upgradePrice.text = 2000 + "$";
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		
		btnClose.off(MouseEventType.CLICK, onClose);
		btnHeaven.off(MouseEventType.CLICK, onHeaven);
		btnHell.off(MouseEventType.CLICK, onHell);
		btnShop.off(MouseEventType.CLICK, onShop);
		btnIntern.off(MouseEventType.CLICK, onIntern);
		btnUpgrade.off(MouseEventType.CLICK, onUpgrade);
		
		instance = null;
		
		super.destroy();
	}

}