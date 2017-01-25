package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollectorHell extends VCollector
{
	

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
		
		myPacks = [
			{
				cost:5,
				time:50000,
				quantity:5
			},
			{
				cost:7,
				time:40000,
				quantity:20
			},
			{
				cost:400,
				time:300000,
				quantity:300
			},
			{
				cost:450,
				time:400000,
				quantity:500
			},
			{
				cost:5,
				time:50000,
				quantity:5
			},
			{
				cost:7,
				time:40000,
				quantity:20
			},
			{
				cost:400,
				time:300000,
				quantity:300
			},
			{
				cost:450,
				time:400000,
				quantity:500
			}
		];
		
		
	}
	
	override function addGenerator():Void 
	{
		myGeneratorType = GeneratorType.buildResourceFromHell;
		super.addGenerator();
	}
}