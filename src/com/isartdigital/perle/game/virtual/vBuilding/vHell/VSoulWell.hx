package com.isartdigital.perle.game.virtual.vBuilding.vHell;

<<<<<<< 774273307833011e81638589beb481ed2213014a
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
=======
>>>>>>> Building in region a bit changed, no more constants
import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.virtual.vBuilding.VGoldGeneratorBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VSoulWell extends VGoldGeneratorBuilding
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
<<<<<<< 774273307833011e81638589beb481ed2213014a
		alignementBuilding = Alignment.hell;
=======
		alignementBuilding = RegionType.hell;
>>>>>>> Building in region a bit changed, no more constants
	}
	
}