package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author Alexis
 */
class VVirtuesBuilding extends VAltar
{

	public function new(pDescription:TileDescription) 
	{
		alignmentEffect = Alignment.heaven;
		hellBonus = -1;
		heavenBonus = 8;
		super(pDescription);
		
	}
	
}