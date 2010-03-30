//
//  Menu.as
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
	
	public class Menu extends EventDispatcher
		implements IExternalizable
	{
		
		{registerClassAlias('SWFMenu', Menu);}
		
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private var m_menuItems:Array;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function Menu()
		{
			m_menuItems = [];
		}
		
		
		public function addItemWithTitle(title:String):MenuItem
		{
			var menuItem:MenuItem = new MenuItem();
			menuItem.title = title;
			addItem(menuItem);
			return menuItem;
		}
		
		public function insertItemAtIndex(item:MenuItem, index:int):void
		{
			m_menuItems.splice(index, 0, item);
			didAddItem(item);
		}
		
		public function insertItemWithTitleAtIndex(title:String, index:int):MenuItem
		{
			var menuItem:MenuItem = new MenuItem();
			menuItem.title = title;
			insertItemAtIndex(menuItem, index);
			didAddItem(menuItem);
			return menuItem;
		}
		
		public function addItem(item:MenuItem):void
		{
			m_menuItems.push(item);
			didAddItem(item);
		}
		
		public function removeItem(item:MenuItem):void
		{
			removeItemAtIndex(m_menuItems.indexOf(item));
			broadcastChange();
		}
		
		public function removeItemAtIndex(index:int):void
		{
			if (index < 0 || index >= m_menuItems.length) return;
			didRemoveItem(m_menuItems.splice(index, 1)[0]);
		}
		
		public function itemWithTag(tag:int):MenuItem
		{
			for each (var item:MenuItem in m_menuItems)
			{
				if (item.tag == tag) return item;
			}
			return null;
		}
		
		public function itemWithTitle(title:String):MenuItem
		{
			for each (var item:MenuItem in m_menuItems)
			{
				if (item.title == title) return item;
			}
			return null;
		}
		
		public function itemAtIndex(index:int):MenuItem
		{
			return m_menuItems[index];
		}
		
		public function numberOfItems():int
		{
			return m_menuItems.length;
		}
		
		public function itemArray():Array
		{
			return m_menuItems.concat();
		}
		
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(m_menuItems);
		}
		
		public function readExternal(input:IDataInput):void {}
		
		
		
		//*****************************************************************************************
		//*                                   Protected Methods                                   *
		//*****************************************************************************************
		protected function broadcastChange():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function didAddItem(item:MenuItem):void
		{
			item.addEventListener(Event.CHANGE, item_change);
			broadcastChange();
		}
		
		private function didRemoveItem(item:MenuItem):void
		{
			item.removeEventListener(Event.CHANGE, item_change);
			broadcastChange();
		}
		
		
		
		//*****************************************************************************************
		//*                                         Events                                        *
		//*****************************************************************************************
		private function item_change(e:Event):void
		{
			broadcastChange();
		}
	}
}