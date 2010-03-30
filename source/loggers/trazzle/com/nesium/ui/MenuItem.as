//
//  MenuItem.as
//
//  Created by Marc Bauer on 2009-01-31.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.ui
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class MenuItem extends EventDispatcher
		implements IExternalizable
	{
	
		{registerClassAlias('SWFMenuItem', MenuItem);}
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private var m_title:String;
		private var m_submenu:Menu;
		private var m_selected:Boolean = false;
		
		
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var tag:int;
		public var representedObject:*;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function MenuItem() {}
		
		
		public function set title(aTitle:String):void
		{
			if (m_title == aTitle) return;
			m_title = aTitle;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get title():String
		{
			return m_title;
		}
		
		public function set submenu(aMenu:Menu):void
		{
			if (m_submenu) m_submenu.removeEventListener(Event.CHANGE, submenu_change);
			m_submenu = aMenu;
			m_submenu.addEventListener(Event.CHANGE, submenu_change);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get submenu():Menu
		{
			return m_submenu;
		}
		
		public function set selected(bFlag:Boolean):void
		{
			if (m_selected == bFlag) return;
			m_selected = bFlag;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selected():Boolean
		{
			return m_selected;
		}
		
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(m_title);
			output.writeObject(m_submenu);
			output.writeBoolean(m_selected);
		}
		
		public function readExternal(input:IDataInput):void {}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function submenu_change(e:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}