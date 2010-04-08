//
//  InvocationResult.as
//
//  Created by Marc Bauer on 2009-02-21.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class InvocationResult extends EventDispatcher
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public var serviceName:String;
		public var methodName:String;
		public var arguments:Array;
		public var invocationIndex:int;
		
		public var result:*;
		public var status:String;
		
		public var context:*;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function InvocationResult(aServiceName:String, aMethodName:String, args:Array, index:int)
		{
			serviceName = aServiceName;
			methodName = aMethodName;
			arguments = args;
			invocationIndex = index;
		}
		
		public function invocationDidReceiveResponse():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function toString():String{
			return '[InvocationResult] serviceName: ' + serviceName + ' methodName: ' + methodName + 
				' arguments: ' + arguments + ' invocationIndex: ' + invocationIndex + ' result: ' + 
				result + ' status: ' + status + ' context: ' + context;
		}
	}
}
