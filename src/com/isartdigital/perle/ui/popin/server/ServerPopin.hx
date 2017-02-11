package com.isartdigital.perle.ui.popin.server;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ServerPopin extends SmartPopinExtended
{
	
	private var text:TextSprite;

	public function new() 
	{
		super(AssetName.POPIN_SERVER);
		text = cast(getChildByName(AssetName.TEXT), TextSprite);
	}
	
}