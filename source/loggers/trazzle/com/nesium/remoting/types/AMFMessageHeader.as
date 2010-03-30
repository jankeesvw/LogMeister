//
//  AMFMessageHeader.as
//
//  Created by Marc Bauer on 2009-02-20.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting.types
{
	
	public class AMFMessageHeader
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var name:String;
		public var mustUnderstand:Boolean;
		public var data:*;
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function AMFMessageHeader() {}
		
		
		public function toString():String
		{
			return '[AMFMessageHeader] name: ' + name + ', mustUnderstand: ' + mustUnderstand + 
				', data: ' + data;
		}
	}
}