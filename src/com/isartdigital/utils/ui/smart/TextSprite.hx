package com.isartdigital.utils.ui.smart;

import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.text.Text;
import pixi.core.text.Text.TextStyle;

typedef UITextStyle = {
	var x: Float;
	var y: Float;
	var width: Float;
	var height: Float;
	var align: String;
	var font: String;
	var color: String;
	var text:String;
	var wordWrap:Int;
	var verticalAlign:String;
}

/**
 * ...
 * @author Mathieu Anthoine
 */
class TextSprite extends Container
{

	/**
	 * assigner la méthode de parsing des textes pour localiser comme traiter des flags personnalisés
	 */
	public static var parseText:String->String;
	
	public function new(pData:UITextStyle) {
		super();
		
		var lStyle:TextStyle = {
			font: StringTools.replace(pData.font,"*",""),
			fill: pData.color,
			align: pData.align,
			wordWrap: pData.wordWrap == 1,
			wordWrapWidth: pData.width
		}	
		
		var lTxt:Text = new Text(parseText(StringTools.replace(pData.text,"</BR>","\r")), lStyle);
		if (pData.align == "center") lTxt.anchor.x = 0.5;
		else if (pData.align == "right") lTxt.anchor.x = 1;
		
		if (pData.verticalAlign == "top") lTxt.anchor.y = 0;
		if (pData.verticalAlign == "bottom") lTxt.anchor.y = 1;
		else lTxt.anchor.y = 0.5;
		
		
		if (Config.debug) {
			var lGraph:Graphics = new Graphics();
			lGraph.beginFill(0xFFFF00);
			lGraph.drawRect(pData.x, pData.y, pData.width, pData.height);
			lGraph.endFill();
			lGraph.alpha = 0.5;
			addChild(lGraph);
		}
		
		addChild(lTxt);		
		
	}
	
	private static function defaultParseText (pTxt:String):String {
		return pTxt;
	}
	
}