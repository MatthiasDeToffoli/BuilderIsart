package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author Alexis
 */
class VVicesBuilding extends VPreferenceBuilding
{

	public function new(pDescription:TileDescription) 
	{
		alignmentEffect = Alignment.hell;
		super(pDescription);
		
	}
	
}