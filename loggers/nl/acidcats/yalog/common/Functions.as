/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


package nl.acidcats.yalog.common {

	public class Functions {
		// Used channels
		public static var CHANNEL:String = "_yala";
		public static var CHANNEL_PING:String = "_yalog";
		
		public static var MAX_CHANNEL_COUNT:Number = 10;
		
		// Command functions (from Yala to Yalog)
		public static var FUNC_PONG:String = "pong";	// ()

		// Log functions (from Yalog to Yala)
		public static var FUNC_PING:String = "ping";	// ()
		public static var FUNC_WRITELOG:String = "writelog";	// (inMessage:MessageData)
	}		
}