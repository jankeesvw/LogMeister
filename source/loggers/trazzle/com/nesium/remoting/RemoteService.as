//
//  RemoteService.as
//
//  Created by Marc Bauer on 2009-02-21.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting
{

	import com.nesium.remoting.DuplexGateway;
	import com.nesium.remoting.InvocationResult;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class RemoteService extends Proxy
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var name:String;
		
		
		
		//*****************************************************************************************
		//*                                  Protected Properties                                 *
		//*****************************************************************************************
		protected var m_gateway:DuplexGateway;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function RemoteService(gateway:DuplexGateway, aName:String)
		{
			name = aName;
			m_gateway = gateway;
		}
		
		
		flash_proxy override function callProperty(name:*, ...rest):*
		{
			return forwardInvocation(name, rest);
		}
		
		
		
		//*****************************************************************************************
		//*                                   Protected Methods                                   *
		//*****************************************************************************************
		protected function forwardInvocation(methodName:String, arguments:Array):InvocationResult
		{
			return m_gateway.invokeRemoteService(name, methodName, arguments);
		}
	}
}
