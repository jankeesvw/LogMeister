/*
 *	LogMeister for ActionScript 3.0
 *	Copyright © 2011 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/base42/LogMeister
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *	
 *	Logmeister version 1.7
 *	
 */
package logmeister.connectors {
	import flash.system.Capabilities;

	internal class AbstractConnector {

		protected var _firstLineNumber : uint = 5;

		protected function getSender() : String {
			
			if(!Capabilities.isDebugger) return "";
			
			var senderCompleteErrorLine : String = new Error().getStackTrace().split("\n")[_firstLineNumber];
			try {
				
				var os : String = Capabilities.os;

				var s : String;
				var reg : RegExp;
				var sender : Array;
				if (os.indexOf("Win") == 0) {
					// windows
					reg = new RegExp(/\s([\w\/]*\(\))\[[\w.:\\]+\\(\w*\.as):(\d+)\]/gi);
					sender = reg.exec(senderCompleteErrorLine);
					s = sender[1] + "@" + sender[2] + ":" + sender[3] ;
				} else { 
					// mac
					reg = new RegExp(/[\[|\/]([\w.:]+)?:(\d+)\]/gi);
					sender = reg.exec(senderCompleteErrorLine);
					s = sender[1] + ":" + sender[2];
				}
								
				if(s.indexOf("NaN") == -1) {
					return s; // add -verbose-stacktracing=true to the compiler settings
				} else {
					return senderCompleteErrorLine;
				}
			} catch (e : Error) {
				return senderCompleteErrorLine;
			}
			return "Error getting sender";
		}
	}
}