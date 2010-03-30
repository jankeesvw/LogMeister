//
//  StatusBar.as
//
//  Created by Marc Bauer on 2009-01-31.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.ui
{

	import com.nesium.logging.TrazzleLogger;
	import com.nesium.ui.Menu;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.registerClassAlias;
	
	public class StatusBar extends Menu
	{
		
		{registerClassAlias('SWFMenu', StatusBar);}
		
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private static var g_instance:StatusBar;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function StatusBar() 
		{
			TrazzleLogger.instance().gateway().registerServiceWithName(this, 'MenuService');
		}
		
		public static function systemStatusBar():StatusBar
		{
			if (!g_instance)
				g_instance = new StatusBar();
			return g_instance;
		}
		
		public function performClickOnMenuItemWithIndexPath(path:Array):void
		{
			dispatchClickEventFromItemAtIndex(path);
		}
		
		
		
		//*****************************************************************************************
		//*                                   Protected Methods                                   *
		//*****************************************************************************************
		override protected function broadcastChange():void
		{
			if (!TrazzleLogger.instance().stage())
			{
				TrazzleLogger.throwNotInitedError();
				return;
			}
			TrazzleLogger.instance().stage().addEventListener(Event.ENTER_FRAME, stage_enterFrame);
		}
		
		protected function dispatchClickEventFromItemAtIndex(indexes:Array):void
		{
			var menuItem:MenuItem;
			var menu:Menu = this;
			for (var i:int = 0; i < indexes.length; i++)
			{
				var index:int = parseInt(indexes[i]);
				menuItem = menu.itemAtIndex(index);
				menu = menuItem.submenu;
			}
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, false);
			menuItem.dispatchEvent(event);
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function stage_enterFrame(e:Event):void
		{
			TrazzleLogger.instance().gateway().invokeRemoteService('MenuService', 'setMenu', this);
			TrazzleLogger.instance().stage().removeEventListener(Event.ENTER_FRAME, stage_enterFrame);
		}
	}
}