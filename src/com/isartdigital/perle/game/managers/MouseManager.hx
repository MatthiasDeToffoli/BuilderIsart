package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.utils.system.DeviceCapabilities;
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
		
		if (desktop) {
			Browser.window.addEventListener(MouseEventType.MOUSE_UP, onMouseTouchUp);
			Browser.window.addEventListener(MouseEventType.MOUSE_DOWN, onMouseDown);
		}
		else {
			Browser.window.addEventListener(TouchEventType.TOUCH_END, onMouseTouchUp);
			Browser.window.addEventListener(TouchEventType.TOUCH_START, onTouchDown);
			Browser.window.addEventListener(TouchEventType.TOUCH_MOVE, onTouchMove);
		}
	}
	
	public function gameLoop():Void {
		if (desktop)
			position = getMouseGlobalPos();
		else
			position = touchGlobalPos;
		
		positionInGame = getLocalPos(GameStage.getInstance().getGameContainer());

		if (mouseTouchDown)
			moveGameContainer(positionInGame);
			
		else 
			scrollOnLimitsScreen(positionInGame);
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
		
		precedentMousePos.copy(getLocalPos(GameStage.getInstance().getGameContainer()));
	}
	
	private function scrollOnLimitsScreen(pMouseLocalPos:Point) {
		var cameraCenter:Point = CameraManager.getCameraCenter();
		
		var lLimitLeftR:Float = cameraCenter.x - Main.getInstance().renderer.width + CameraManager.DEFAULT_OFFSET_LOCAL;
		var lLimitLeftL:Float = cameraCenter.x - Main.getInstance().renderer.width;
		var lLimitRightL:Float = cameraCenter.x + Main.getInstance().renderer.width - CameraManager.DEFAULT_OFFSET_LOCAL;
		var lLimitRightR:Float = cameraCenter.x + Main.getInstance().renderer.width;
		
		var lLimitTopB:Float = cameraCenter.y - Main.getInstance().renderer.height + CameraManager.DEFAULT_OFFSET_LOCAL;
		var lLimitTopT:Float = cameraCenter.y - Main.getInstance().renderer.height;
		var lLimitBottomT:Float = cameraCenter.y + Main.getInstance().renderer.height - CameraManager.DEFAULT_OFFSET_LOCAL;
		var lLimitBottomB:Float = cameraCenter.y + Main.getInstance().renderer.height;
		
		if(pMouseLocalPos.x < lLimitLeftR && pMouseLocalPos.x > lLimitLeftL) CameraManager.move(CameraManager.DEFAULT_SPEED, 0);
		if(pMouseLocalPos.x > lLimitRightL && pMouseLocalPos.x < lLimitRightR) CameraManager.move(-CameraManager.DEFAULT_SPEED, 0);
		if(pMouseLocalPos.y < lLimitTopB && pMouseLocalPos.y > lLimitTopT) CameraManager.move(0, CameraManager.DEFAULT_SPEED);
		if(pMouseLocalPos.y > lLimitBottomT && pMouseLocalPos.y < lLimitBottomB) CameraManager.move(0, -CameraManager.DEFAULT_SPEED);
		
		
		precedentMousePos.copy(getLocalPos(GameStage.getInstance().getGameContainer()));
	}
	
	// todo : n'agit pas si sur HUD
	/*if (!Std.is(pEvent.target, Hud))m inutile ce truc :|
	return; ?*/
	private function onMouseDown(pEvent:Dynamic):Void {
		if (!Phantom.isMoving()) {
			mouseTouchDown = true;
			precedentMousePos.copy(positionInGame);
		}
	}
	
	private function onTouchDown(pEvent:TouchEvent):Void {
		// don't rely only en TouchEvent.MOVE to get globalPos !
		if (!Phantom.isMoving()) {
			touchGlobalPos.set(pEvent.touches[0].pageX, pEvent.touches[0].pageY);
			mouseTouchDown = true;
			precedentMousePos.copy(positionInGame);
			oneFrameHack = true;
		}
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
		Browser.window.removeEventListener(MouseEventType.MOUSE_DOWN, onMouseDown);
		
		Browser.window.removeEventListener(TouchEventType.TOUCH_END, onMouseTouchUp);
		Browser.window.removeEventListener(TouchEventType.TOUCH_START, onTouchDown);
		Browser.window.removeEventListener(TouchEventType.TOUCH_MOVE, onTouchMove);
		
		instance = null;
	}

}