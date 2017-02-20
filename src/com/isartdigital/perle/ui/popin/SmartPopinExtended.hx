package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UIMovie;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author ambroise
 */
class SmartPopinExtended extends SmartPopin{
	
	/**
	 * Fit and create an image into pContainer
	 * @param	pContainer
	 * @param	pAssetName
	 */
	public static function setImage (pContainer:Container, pAssetName:String):UIMovie { // todo : prq static ici ? faire classe utilitaire ou hériatge ds les règles de l'art ?
		var lImage:UIMovie = new UIMovie(pAssetName);
		
		reScaleImage(lImage, pContainer); // before adding anything inside or size will change
		pContainer.addChild(lImage); // needed before getLocalBounds
		
		var lLocalBounds:Rectangle = lImage.getLocalBounds();
		var topLeft:Point = new Point(
			lLocalBounds.x,
			lLocalBounds.y
		);
		var trueCenter:Point = new Point(
			topLeft.x + lLocalBounds.width / 2,
			topLeft.y + lLocalBounds.height / 2
		);
		trueCenter = pContainer.toLocal(trueCenter, lImage);
		
		lImage.x -= trueCenter.x;
		lImage.y -= trueCenter.y;
		
		lImage.start();
		
		return lImage;
	}
	
	/**
	 * Apply a scale to pChange.
	 * So pChange width and height correspond to pToModel width and height
	 * Doesn't change the ratio.
	 * @param	pChange
	 * @param	pToModel
	 */
	private static function reScaleImage(pChange:Container, pToModel:Container):Void {
		var lRatio:Float;
		if (pChange.width > pChange.height)
			lRatio = pToModel.width / pChange.width;
		else
			lRatio = pToModel.height / pChange.height;
		
		pChange.scale.x = lRatio;
		pChange.scale.y = lRatio;
	}
	
	public function new(pID:String=null) {
		super(pID);
		
	}
	
	override public function build(pFrame:Int = 0):Void {
		super.build(pFrame);
		TweenManager.scaleGrow(this);
	}
	
	/*override public function close():Void 
	{
		TweenManager.scaleReduce(this,closeAfterTween);
		
	}
	
	private function closeAfterTween():Void {
		super.close();
	}*/
	
	// todo : héritage : combiné => onClickExit && onClose, évité de répété Hud.show et Hud.hide
	

}