package com.isartdigital.perle.game.virtual.vBuilding.vHell;

<<<<<<< 774273307833011e81638589beb481ed2213014a
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
=======
>>>>>>> Building in region a bit changed, no more constants
import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouseHell extends VInternHouse
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
		

	}
	
}