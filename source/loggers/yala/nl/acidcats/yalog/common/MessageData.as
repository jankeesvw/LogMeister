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

	public class MessageData {
		public var text:String;			// the message
		public var level:Number;		// the level of importance
		public var time:Number;			// the time of dispatch
		public var sender:String;		// name of sender
		public var channelID:Number;	// id of the channel 
		
		public function MessageData (inText:String, inLevel:Number, inTime:Number = Number.NaN, inSender:String = null) {
			text = inText;
			level = inLevel;
			time = inTime;
			sender = inSender;
		}
		
		public function toString() : String {
			var s:String = "";
			if (!isNaN(time)) s += time + "\t";
			s += Levels.NAMES[level] + ": " + text;
			if (sender != null) s += " -- " + sender;
			
			return s;
		}
	}
}