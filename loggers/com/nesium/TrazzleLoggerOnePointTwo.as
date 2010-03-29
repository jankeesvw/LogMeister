package com.nesium 
{
	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.net.XMLSocket;	import flash.system.Security;	import flash.utils.getTimer;		public class TrazzleLoggerOnePointTwo extends EventDispatcher
	{
		
		
		/***************************************************************************
		*							private properties							   *
		***************************************************************************/
		private static const k_host:String = 'localhost';
		private static const k_port:Number = 3456;
		private static const k_version:Number = 1.0;
		private static var g_instance:TrazzleLoggerOnePointTwo;
		private static var g_buffer:Array;
		private static var g_socket:XMLSocket;
		private static var g_connecting:Boolean = false;
		private static var g_signatureSent:Boolean = false;
		
		
		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function TrazzleLoggerOnePointTwo() 
		{
			g_socket = new XMLSocket();
		}
		
		
		public function log(msg:String):void
		{
			send(msg);
		}
		
		public function socket():XMLSocket
		{
			return g_socket;
		}
		
		public function sendRawMessage(msg:String):void
		{
			if (!g_socket.connected)
			{
				if (!g_buffer)
				{
					g_buffer = [];
				}
				g_buffer.push(msg);
				connect();
				return;
			}
			
			if (!g_signatureSent)
			{
				sendSignature();
			}
			
			g_socket.send(msg + '\n');
		}
		
		public static function instance():TrazzleLoggerOnePointTwo
		{
			if (!g_instance)
			{
				g_instance = new TrazzleLoggerOnePointTwo();
			}
			return g_instance;
		}
		
		
		
		/***************************************************************************
		*							private methods								   *
		***************************************************************************/
		private function send(message:String, stackIndex:uint=0):void
		{
			var stacktrace:StackTrace = new StackTrace();
			var logMessage:LogMessageVO = new LogMessageVO(message, stacktrace, stackIndex + 7);
			sendRawMessage(logMessage.toString());
		}
		
		private function sendSignature():void
		{
			var startTime:String = (new Date().getTime() - getTimer()).toString();
			var xml:XML = <signature language="as3" starttime={startTime}/>;
			g_socket.send(xml.toXMLString());
			g_signatureSent = true;
		}
		
		private function connect():void
		{
			if (g_socket.connected || g_connecting)
			{
				return;
			}
			Security.loadPolicyFile('xmlsocket://' + k_host + ':' + k_port);
			g_connecting = true;
			g_socket.addEventListener(Event.CONNECT, socket_didConnect);
			g_socket.addEventListener(IOErrorEvent.IO_ERROR, socket_ioError);
			g_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityError);
			g_socket.connect(k_host, k_port);
		}

		private function flushBuffer():void
		{
			var i:uint = 0;
			for (; i < g_buffer.length; i++)
			{
				var msg:String = g_buffer[i] as String;
				sendRawMessage(msg);
			}
			g_buffer = null;
		}
		
		private function socket_didConnect(e:Event):void
		{
			g_connecting = false;
			flushBuffer();
		}
		
		private function socket_ioError(e:IOErrorEvent):void
		{
			// trace('Could not connect to Trazzle. Make sure Trazzle is running.');
		}
		
		private function socket_securityError(e:SecurityErrorEvent):void
		{
		//	trace('Could not connect to Trazzle because of an SecurityError. Actually this shouldn\'t happen');
		}
	}
}
import flash.utils.getTimer;
internal class LogMessageVO
{
	
	/***************************************************************************
	*							public properties							   *
	***************************************************************************/
	public var message:String;
	public var encodeHTML:Boolean = true;
	public var stacktrace:StackTrace;
	public var levelName:String;
	public var ts:String;
	public var stackIndex:uint;
	private static var g_levels:Object =
	{
		d:'debug',
		i:'info',
		n:'notice',
		w:'warning',
		e:'error',
		c:'critical',
		f:'fatal'
	};
	
	
	
	/***************************************************************************
	*							public methods								   *
	***************************************************************************/
	public function LogMessageVO(aMessage:String, aStacktrace:StackTrace, 
		aStackIndex:uint)
	{
		levelName = '';
		if (aMessage.charAt(0) == '#')
		{
			aMessage = aMessage.substr(1);
			encodeHTML = false;
		}
		if (aMessage.charAt(1) == ' ')
		{
			levelName = g_levels[aMessage.charAt(0)] || '';
			aMessage = aMessage.substr(2);
		}
		ts = getTimer().toString();
		message = aMessage;
		stacktrace = aStacktrace;
		stackIndex = aStackIndex;
	}
	
	
	public function toString():String
	{
		var xml:XML = 
			<log level={levelName} line="0" ts={ts} class="unknown"
				method="unknown" file="unknown" encodehtml={encodeHTML}>
				<message>{cdata(message)}</message>
				<stacktrace language="as3" index={stackIndex} ignoreToIndex={stackIndex}>
					{cdata(stacktrace.toString())}
				</stacktrace>
			</log>;
		return xml.toXMLString();
	}
	
	protected function cdata(str:String):XML
	{
	    return new XML("<![CDATA[" + str + "]]>");
	}
}



internal class StackTrace
{

	/***************************************************************************
	*							private properties							   *
	***************************************************************************/
	private var m_stackTrace:String;
	
	
	
	/***************************************************************************
	*							public methods								   *
	***************************************************************************/
	public function StackTrace()
	{
		try
		{
			throw new Error();
		}
		catch (error:Error)
		{
			m_stackTrace = error.getStackTrace();
		}
	}
	
	public function toString():String
	{
		return m_stackTrace;
	}
}