package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

/**
 * ...
 * @author Rafired
 */
class FootPrint extends Tile implements PoolingObject
{
	public static var container(default, null):Container;
	
	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
	override public function init():Void {
		//setState(DEFAULT_STATE);
	}
	
	public static function initClass():Void {
		container = new Container();
		GameStage.getInstance().getGameContainer().addChild(container);
	}
	
	/*public function setModFollow(pBuilding:Building) {
		lBuilding = pBuilding;
		doAction = doActionFollow;
	}
	
	public function doActionFollow() {
		this.position = lBuilding.position;
	}*/
}