//
//  AMFActionMessage.as
//
//  Created by Marc Bauer on 2009-02-20.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting.types
{

	import flash.net.ObjectEncoding;
	
	public class AMFActionMessage
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var encoding:uint = ObjectEncoding.AMF3;
		public var headers:Array;
		public var bodies:Array;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function AMFActionMessage() 
		{
			headers = [];
			bodies = [];
		}
		
		
		public function toString():String
		{
			return '[AMFActionMessage] headers: ' + headers + ', bodies: ' + bodies;
		}
	}
}
