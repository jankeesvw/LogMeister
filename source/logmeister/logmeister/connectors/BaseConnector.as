/*
 *	LogMeister for ActionScript 3.0
 *	Copyright © 2010 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/base42/LogMeister
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the LogMeister nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	LogMeister is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	LogMeister is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with LogMeister.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	Version 1.5
 *	
 */
package logmeister.connectors {
	import flash.system.Capabilities;

	internal class BaseConnector {

		protected var _firstLineNumber : uint = 5;

		protected function getSender() : String {
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