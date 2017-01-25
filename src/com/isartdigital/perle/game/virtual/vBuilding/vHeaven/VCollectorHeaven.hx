package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */


class VCollectorHeaven extends VCollector
{

	
	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.heaven;
		super(pDescription);
		
	}
	
	override function addGenerator():Void 
	{
		myGeneratorType = GeneratorType.buildResourceFromParadise;
		super.addGenerator();
		
		myPacks = [
			{
				cost:1,
				time:30000,
				quantity:3
			},
			{
				cost:2,
				time:35000,
				quantity:10
			},
			{
				cost:3,
				time:40000,
				quantity:100
			},
			{
				cost:1,
				time:30000,
				quantity:3
			},
			{
				cost:2,
				time:35000,
				quantity:10
			},
			{
				cost:3,
				time:40000,
				quantity:100
			}
		];
	}
	
}