package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import eventemitter3.EventEmitter;
import js.Browser;
import js.html.TouchEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionManager;

	
/**
 * Class used to get mouse or touch global position
 * and to move the camera.
 * @author ambroise
 */
class MouseManager {
	private static var instance: MouseManager;
	
	// todo, move new Point into init, because if MouseManager get destroyed...
	
	/**
	 * Return the global mouse position when gameLoop is running.
	 */
	public var position(default, null):Point = new Point(0, 0);
	
	/**
	 * Return the local mouse position of the gameContainer when gameLoop is running.
	 */
	public var positionInGame(default, null):Point = new Point(0, 0);
	
	/**
	 * True if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
	 */
	public var desktop(default, null):Bool = false;
	public var touchGlobalPos(default, null):Point = new Point(0, 0);
	
	private var mouseTouchDown:Bool = false;
	private var precedentMousePos:Point = new Point();
	private var precedentFrame:Bool = false;
	
	/**
	 * Needed for Touch, or you will be teleported one the same point
	 * on screen when you start touch.
	 */
	private var oneFrameHack:Bool = false;
	
	public static function getInstance (): MouseManager {
		if (instance == null) instance = new MouseManager();
		return instance;
	}

	private function new() {
		init(); // todo, get out of new
	}
	
	public function getLocalMouseMapPos():Point {
		return IsoManager.isoViewToModel(
			getLocalPos(Ground.container)
		);
	}
	
	/**
	 * todo : remove ?
	 * @param	pContainer:whit a toLocal() method
	 * @return local mouse position
	 */
	private function getLocalPos(pContainer:Container):Point {
		return pContainer.toLocal(position);
	}
	
	private function init():Void {
		desktop = DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP;
		
		//if (desktop) {
			Browser.window.addEventListener(MouseEventType.MOUSE_UP, onMouseTouchUp);
			Browser.window.addEventListener(MouseEventType.MOUSE_OUT, onMouseTouchUp);
			Browser.window.addEventListener(MouseEventType.MOUSE_DOWN, onMouseDown);
		/*}
		else {*/
			Browser.window.addEventListener(TouchEventType.TOUCH_END, onMouseTouchUp);
			Browser.window.addEventListener(TouchEventType.TOUCH_START, onTouchDown);
			Browser.window.addEventListener(TouchEventType.TOUCH_MOVE, onTouchMove);
		//}
	}
	
	public function gameLoop():Void {
		
		blockOpeningHUDBuilt();
		
		if (desktop)
			position = getMouseGlobalPos();
		else
			position = touchGlobalPos;
		
		positionInGame = getLocalPos(GameStage.getInstance().getGameContainer());
		
		if (mouseTouchDown)
			moveGameContainer(positionInGame);
	}
	
	public static inline var MAX_DURATION_FOR_SHORT_CLICK:Int = 220; // milliseconds
	private var mouseDownDuration:Int = 0; // milliseconds
	
	/**
	 * Bloc the opening of HudBuilt (contextual hud) on the buildings if the click is long enough.
	 */
	private function blockOpeningHUDBuilt ():Void {
		
		if (mouseTouchDown)
			mouseDownDuration += Main.FRAME_INTERVAL;
		else {
			// if making no interference whit other code using isClickable then put to true
			if (!Building.isClickable)
				Building.isClickable = true;
			mouseDownDuration = 0;
		}
		
		// if long click (probably moving camera) and no interference then put to false
		if (mouseDownDuration > MAX_DURATION_FOR_SHORT_CLICK && Building.isClickable)
			Building.isClickable = false;
	}
	
	/**
	 * not used, don't forget global pos is updated in gameLoop, not immediately.
	 * @return
	 */
	public function getImmediateTouchGlobalPos ():Point {
		return touchGlobalPos;
	}
	
	/**
	 * Permit to move the Map whit the Mouse or Touch, won't move is someone is building.
	 * @param	pMouseLocalPos
	 */
	private function moveGameContainer(pMouseLocalPos:Point):Void {
		if (oneFrameHack)
			oneFrameHack = false;
		else {
			var lSoustract:Point = soustractPoint(pMouseLocalPos, precedentMousePos);
			if (lSoustract.x != 0 || lSoustract.y != 0)
				CameraManager.move(lSoustract.x, lSoustract.y);
		}
		
		updatePrecedentMousePos();
	}
	
	private function updatePrecedentMousePos():Void {
		precedentMousePos.copy(getLocalPos(GameStage.getInstance().getGameContainer()));
	}
	
	// todo : n'agit pas si sur HUD
	/*if (!Std.is(pEvent.target, Hud))m inutile ce truc :|
	return; ?*/
	private function onMouseDown(pEvent:Dynamic):Void {
		mouseTouchDown = true;
		precedentMousePos.copy(positionInGame);
	}
	
	private function onTouchDown(pEvent:TouchEvent):Void {
		// don't rely only en TouchEvent.MOVE to get globalPos !
		touchGlobalPos.set(pEvent.touches[0].pageX, pEvent.touches[0].pageY);
		mouseTouchDown = true;
		precedentMousePos.copy(positionInGame);
		oneFrameHack = true;
	}
	
	private function onMouseTouchUp (): Void {
		mouseTouchDown = false;
	}
	
	// could be a instance method and used like "myPoint.soustract(anotherPoint);"
	// that would avoid making a new Point !	
	private function soustractPoint(pPoint1:Point, pPoint2:Point):Point {
		return new Point(pPoint1.x - pPoint2.x, pPoint1.y - pPoint2.y);
	}
	
	private function getMouseGlobalPos():Point {
		return cast(Main.getInstance().renderer.plugins.interaction, InteractionManager).mouse.global;
	}
	
	private function onTouchMove(pEvent:TouchEvent):Void {
		touchGlobalPos.set(pEvent.touches[0].pageX, pEvent.touches[0].pageY);
	}
	
	/*private function mouseOutGame():Bool {
		var lLimitLeftL:Float = cameraCenter.x - Main.getInstance().renderer.width;
		var lLimitRightR:Float = cameraCenter.x + Main.getInstance().renderer.width;
		var lLimitTopT:Float = cameraCenter.y - Main.getInstance().renderer.height;
		var lLimitBottomB:Float = cameraCenter.y + Main.getInstance().renderer.height;
	}*/
	
	// todo : make it work whit pause !
	// todo whit positionInGame too !
	/*public function get_position():Point {
	 * 	if ((Hud || GameManager).pause)
	 * 		return getMouseGlobalPos();
	 * 	else
			return position;
	}*/
	
	public function destroy (): Void {
		Browser.window.removeEventListener(MouseEventType.MOUSE_UP, onMouseTouchUp);
		Browser.window.removeEventListener(MouseEventType.MOUSE_OUT, onMouseTouchUp);
		Browser.window.removeEventListener(MouseEventType.MOUSE_DOWN, onMouseDown);
		
		Browser.window.removeEventListener(TouchEventType.TOUCH_END, onMouseTouchUp);
		Browser.window.removeEventListener(TouchEventType.TOUCH_START, onTouchDown);
		Browser.window.removeEventListener(TouchEventType.TOUCH_MOVE, onTouchMove);
		
		instance = null;
	}

}