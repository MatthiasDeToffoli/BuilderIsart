package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
/**
 * ...
 * @author ambroise
 */
class ShopCaroussel extends SmartComponent {
	
	private var buildingNameList(default, never):Array<String> = [ // todo : c'est bugué ...
		AssetName.BUILDING_HOUSE_HEAVEN,
		"Factory",
		"Factory",
		"Factory",
		
		AssetName.BUILDING_HOUSE_HEAVEN,
		AssetName.BUILDING_HOUSE_HEAVEN,
		AssetName.BUILDING_HOUSE_HELL,
		"Factory",
		
		AssetName.BUILDING_HOUSE_HELL,
		AssetName.BUILDING_HOUSE_HELL,
		AssetName.BUILDING_HOUSE_HELL,
		"Factory"/*,
		
		"Factory",
		AssetName.BUILDING_HOUSE_HELL,*/
	];

	private var cards:Array<CarouselCard>;
	
	private var tempArrowRight:SmartButton;
	private var tempArrowLeft:SmartButton; // todo : les deux aroow seront ensemblent
	
	private var maxCardsVisible:Int;
	private var cardsPositions:Array<Point>;
	private var buildingListIndex:Int = 0;

	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	public function new(pID:String = null) { 	
		super(pID);
		
		cards = new Array<CarouselCard>();
		cardsPositions = [];
		
		SmartCheck.traceChildrens(this);
		
		tempArrowLeft = cast(SmartCheck.getChildByName(this, "Button_ArrowLeft"), SmartButton); // temp
		tempArrowRight = cast(SmartCheck.getChildByName(this, "Button_ArrowRight"), SmartButton);
	}
	
	public function init ():Void {
		createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
		tempArrowLeft.on(MouseEventType.CLICK, onClickTempArrowLeft);
		tempArrowRight.on(MouseEventType.CLICK, onClickTempArrowRight);
	}
	
	public function scrollNext ():Void {
		if (buildingListIndex >= buildingNameList.length)
			buildingListIndex = 0;
		else
			buildingListIndex += maxCardsVisible;
			
		createCard(cardsPositions);
	}
	
	// todo : euh test ci-dessous si donne bien le bon résultat, si que trois à la fin alors doit afficher trois en 
		// passant dans l'autre sens.
		// ple but c'est de na pas changer constamment les batiment qui pop si nombre irrégulier,
		// ils restent sur la même page pr pas troubler.
			//buildingListIndex = buildingListIndex - maxCardsVisible - (buildingNameList.length % maxCardsVisible);
	public function scrollPrecedent ():Void {
		if ((buildingListIndex - maxCardsVisible) < 0)
			buildingListIndex = buildingNameList.length + buildingListIndex - maxCardsVisible;
		else
			buildingListIndex -= maxCardsVisible;
		
		createCard(cardsPositions);
	}
	
	private function onClickTempArrowLeft ():Void {
		scrollPrecedent();
	}
	
	private function onClickTempArrowRight ():Void {
		scrollNext();
	}
	
	// todo : automatisé le paramètre en prenant le nom spawner puis ce qu'il y a après
	// todo : utilsier des spawner
	private function getSpawnersAssetNames ():Array<String> {
		return [
			AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED,
			"Shop_Item_Locked_1",
			"Shop_Item_Locked_2",
			"Shop_Item_Locked_3",
		];
	}
	
	private function getSpawners (pAssetNames:Array<String>):Array<SmartComponent> {
		var lSpawners:Array<SmartComponent> = [];
		
		setMaxCard(pAssetNames.length);
		
		for (i in 0...pAssetNames.length) {
			lSpawners.push(cast(SmartCheck.getChildByName(this, pAssetNames[i]), SmartComponent));
		}
		
		return lSpawners;
	}
	
	private function setMaxCard (pMax:Int):Void {
		maxCardsVisible = pMax;
	}
	
	private function setCardsPosition (pPositions:Array<Point>):Void {
		cardsPositions = pPositions;
	}
	
	private function getSpawnersPosition (pSpawners:Array<SmartComponent>):Array<Point> {
		var lPositions:Array<Point> = [];
		
		for (i in 0...pSpawners.length) {
			var lPoint:Point = new Point();
			lPoint.copy(pSpawners[i].position);
			lPoint.x += 50; // todo : temp, pour que cela soit plus visible
			lPoint.y += 50;
			lPositions.push(lPoint);
		}
		
		setCardsPosition(lPositions);
		destroySpawners(pSpawners);
		
		return lPositions;
	}
	
	private function destroySpawners (pSpawners:Array<SmartComponent>):Void {
		for (i in pSpawners.length -1...0) {
			pSpawners[i].destroy();
		}
	}
	
	// todo : à faire, retiens le spositions pose intelligemment ? ou pas ? façon css ?
	private function createCard (pPositions:Array<Point>):Void {
		trace(buildingListIndex);
		if (cards.length != 0)
			destroyCards();
		
		for (i in 0...pPositions.length) {
			var j:Int = i + buildingListIndex;
			
			if (buildingNameList[j] == null)
				break;
			
			cards[i] = new CarouselCard();
			cards[i].position = pPositions[i];
			cards[i].init(buildingNameList[j]); // todo temp
			addChild(cards[i]);
			cards[i].start();
		}
	}
	
	private function destroyCards ():Void {
		for (i in cards.length-1...0) {
			cards[i].destroy();
			cards[i] = null;
		}
	}
	
	// todo : destroy les cards
	override public function destroy():Void {
		destroyCards();
		cards = null;
		
		super.destroy();
	}

}