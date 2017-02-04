package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * The shop card building change his background depending on his alignment
 * @author ambroise
 */
interface ICardVariableBackground {
	private var background:UISprite;
	private var alignment:Alignment;
	private function setBackground(pStateDown:Bool = false):Void;
	private function getBackgroundAssetName (pAlignment:Alignment, pStateDown:Bool = false):String;
	
	/*
	 * add :
	 * 
	 >  if (alignment != Alignment.neutral)
	 >		setBackground();
	 * 
	 * in buildCard() function.
	 * and a :
	 * 
	 > private var isMouseDown:Bool;
	 * 
	 * is used for CarouselCardUnlock to not have to change to much the heritage tree
	 * instead of adding a 
	 *
	 > pStateDown:Bool
	   
	 * parameter in buildCard function in CarouselCard class.
	 */
}