//
//  AMFMessageBody.as
//
//  Created by Marc Bauer on 2009-02-20.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting.types
{
	
	public class AMFMessageBody
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var targetURI:String;
		public var responseURI:String = 'null';
		public var data:*;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function AMFMessageBody() {}
		
		
		public function toString():String
		{
			return '[AMFMessageBody] targetURI: ' + targetURI + ', responseURI: ' + responseURI + 
				', data: ' + data;
		}
	}
}