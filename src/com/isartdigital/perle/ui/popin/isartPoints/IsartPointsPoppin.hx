package com.isartdigital.perle.ui.popin.isartPoints;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;

	
/**
 * ...
 * @author Rafired
 */
class IsartPointsPoppin extends SmartPopinExtended 
{
	private var closeButton:SmartButton;
	private var continueButton:SmartButton;
	
	private var isartPoints:TextSprite;
	
	/**
	 * instance unique de la classe IsartPointsPoppin
	 */
	private static var instance: IsartPointsPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): IsartPointsPoppin {
		if (instance == null) instance = new IsartPointsPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.ISARTPOINTS_POPPIN);
		closeButton = cast(getChildByName(AssetName.ISARTPOINTS_POPPIN_CLOSE), SmartButton);
		continueButton = cast(getChildByName(AssetName.ISARTPOINTS_POPPIN_CONTINUE), SmartButton);
		isartPoints = cast(getChildByName(AssetName.ISARTPOINTS_POPPIN_REMAININGIP), TextSprite);
		
		isartPoints.text = "" + 42; //todo : @Ambroise mettre les IP restants
		Interactive.addListenerClick(closeButton, closeThisPoppin);
		Interactive.addListenerClick(continueButton, closeThisPoppin);
	}
	
	private function closeThisPoppin():Void {
		ShopPopin.getInstance().closeIsartPointsPoppin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(closeButton, closeThisPoppin);
		Interactive.removeListenerClick(continueButton, closeThisPoppin);
		instance = null;
	}

}