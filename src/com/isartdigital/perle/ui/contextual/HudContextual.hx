package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.Virtual.HasVirtual;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.UIPosition;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * Only element that is clippable but not Poolable // todo or not ?
 * @author ambroise
 */
class HudContextual extends Container implements HasVirtual{

	private static var container:Container;
	
	private var myVHudContextual:VHudContextual;
	
	public static function initClass ():Void {
		container = new Container();
	}
	
	// not at the same time as initClass
	public static function addContainer ():Void {
		GameStage.getInstance().getBuildContainer().addChild(container);
	}
	
	public function new() {
		super();
	}
	
	public function linkVirtual(pVirtual:Virtual):Void {
		myVHudContextual = cast(pVirtual, VHudContextual);
	}
	
	public function init ():Void {
		alignTopLeft();
		container.addChild(this); // ds start() ?
	}
	
	// todo : revoir cette function pour qu'elle puisse ajouter autre chose que btnProd
	public function addComponentBtnProd (pComponent:SmartComponent):Void {
		UIPosition.setPositionContextualUI(
			myVHudContextual.myVBuilding.graphic,
			pComponent,
			UIPosition.TOP_CENTER,
			0,
			-pComponent.height/2
		);
		
		addChild(pComponent);
	}
	
	
	private function alignTopLeft ():Void {
		//trace(myVHudContextual.myVBuilding.graphic.getBounds(myVHudContextual.myVBuilding.graphic.parent.worldTransform));
		/*trace(myVHudContextual.myVBuilding.graphic.getLocalBounds());
		trace(myVHudContextual.myVBuilding.graphic.pivot);*/
		//trace(myVHudContextual.myVBuilding.graphic.parent.getBounds(myVHudContextual.myVBuilding.graphic.worldTransform));
		//untyped trace(myVHudContextual.myVBuilding.graphic.anchor);
		//trace(myVHudContextual.myVBuilding.graphic.position);
		//untyped trace(myVHudContextual.myVBuilding.graphic.anim.position);
		
		
		// ne jamais faire appelle à getBounds() à nouveau, c'est wtf, il m'envoit des valeurs fantaisiste
		// si je fait un getBounds après un getLocalBounds c'est pareil il me renvoit la valeur de getLocalBounds
		// pixi.js please...
		//if (myVHudContextual.hackTrueBounds == null)
			//myVHudContextual.hackTrueBounds = new Point(myVHudContextual.myVBuilding.graphic.getBounds().x, myVHudContextual.myVBuilding.graphic.getBounds().y);
			
		// soluce : getBounds trop foireux.
		
		var lLocalBounds:Rectangle = myVHudContextual.myVBuilding.getGraphicLocalBoundsAtFirstFrame().clone();
	
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
			
		var lRect:Point = myVHudContextual.myVBuilding.graphic.position;
		x = lRect.x + lAnchor.x;
		y = lRect.y + lAnchor.y;
	}
	
	override public function destroy():Void {
		myVHudContextual = null;
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
	
	
}