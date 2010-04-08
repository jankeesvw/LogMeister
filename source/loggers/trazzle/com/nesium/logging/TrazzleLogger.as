package com.nesium.logging {
	import com.nesium.remoting.DuplexGateway;

	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getTimer;

	public class TrazzleLogger extends EventDispatcher
	{
		
		//*****************************************************************************************
		//*                                   Public Properties                                   *
		//*****************************************************************************************
		public static var g_baseStackIndex:uint = 3;
		
		
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private static const k_host:String = 'localhost';
		private static const k_port:Number = 3457;
		private static const k_version:Number = 1;
		private static const k_marketingVersion:String = '1.5.1';
		
		private static var g_instance:TrazzleLogger;
		private static var g_gateway:DuplexGateway;
		private static var g_stage:Stage;
		private static var g_notInitedErrorThrown:Boolean = false;
		private static var g_lastFrames:int;
		private static var g_lastTimeStamp:Number;
		private static var g_monitorTimer:Timer;
		private static var g_fileObservers:Object;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function TrazzleLogger()
		{
			g_gateway = new DuplexGateway(k_host, k_port);
			g_gateway.registerServiceWithName(this, 'FileObservingService');
			g_gateway.connectToRemote();
			g_fileObservers = {};
		}
		
		
		public function setParams(theStage:Stage, title:String):void
		{
			if (g_stage) return;
			g_stage = theStage;
			var objCopy:ByteArray = new ByteArray();
			objCopy.writeObject(theStage.loaderInfo.parameters);
			objCopy.position = 0;
			var params:Object = objCopy.readObject();
			params.swfURL = theStage.loaderInfo.url;
			params.applicationName = title;
			params.version = k_version;
			params.marketingVersion = k_marketingVersion;
			g_gateway.invokeRemoteService('CoreService', 'setConnectionParams', params);
		}
		
		public function stage():Stage
		{
			return g_stage;
		}
		
		public function log(msg:String, stackIndex:uint=0):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			send(msg, stackIndex);
		}
		
		public function beep():void{
			if (!g_stage){
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('LoggingService', 'beep');
		}
		
		public function logBitmapData(bmp:BitmapData):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('LoggingService', 'logBMP_width_height', 
				bmp.getPixels(new Rectangle(0, 0, bmp.width, bmp.height)), bmp.width, bmp.height);
		}
		
		public function addI18NKeyToFile(key:String, file:String):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('LoggingService', 'addI18NKey_toFile', key, file);
		}
		
		public function startPerformanceMonitoring():void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			if (g_monitorTimer) return;
			g_lastTimeStamp = getTimer();
			g_lastFrames = 0;
			g_monitorTimer = new Timer(500);
			g_monitorTimer.addEventListener(TimerEvent.TIMER, monitorTimer_tick);
			g_monitorTimer.start();
			g_stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
			g_gateway.invokeRemoteService('MonitoringService', 'startMonitoring', g_stage.frameRate);
		}
		
		public function observeFile(path:String, callback:Function, remove:Boolean=false):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			var observers:Array = g_fileObservers[path];
			var index:int;
			if (observers && (index = observers.indexOf(callback)) != -1)
			{
				if (remove)
				{
					observers.splice(index, 1);
					if (observers.length == 0)
					{
						g_gateway.invokeRemoteService('FileObservingService', 'stopObservingFile', 
							path);
						g_fileObservers[path] = null;
					}
				}
			}
			else if (!remove)
			{
				observers = g_fileObservers[path] = [];
				observers.push(callback);
				g_gateway.invokeRemoteService('FileObservingService', 'startObservingFile', path);
			}
		}
		
		public function stopPerformanceMonitoring():void
		{
			if (!g_monitorTimer) return;
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_monitorTimer.stop();
			g_monitorTimer.removeEventListener(TimerEvent.TIMER, monitorTimer_tick);
			g_monitorTimer = null;
			g_stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrame);
			g_gateway.invokeRemoteService('MonitoringService', 'stopMonitoring');
		}
		
		public function inspectObject(obj:*):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('InspectionService', 'inspectObject_metadata', obj, 
				describeType(obj));
		}
		
		public function gateway():DuplexGateway
		{
			return g_gateway;
		}
		
		public static function instance():TrazzleLogger
		{
			if (!g_instance) 
				g_instance = new TrazzleLogger();
			return g_instance;
		}
		
		public static function throwNotInitedError():void
		{
			if (g_notInitedErrorThrown) return;
			g_notInitedErrorThrown = true;
			throw new Error('TrazzleLogger not inited. Please make sure to call zz_init before ' + 
				'using any logger methods!');
		}
		
		
		
		//*****************************************************************************************
		//*                                    Internal Methods                                   *
		//*****************************************************************************************
		zz function fileDidChange(path:String):void
		{
			var observers:Array = g_fileObservers[path];
			if (!observers) return;
			for each (var observer:Function in observers)
				observer.apply(null, [path]);
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function send(message:String, stackIndex:uint=0):void
		{
			var logMessage:LogMessageVO = new LogMessageVO(message, new Error().getStackTrace(), 
				stackIndex + g_baseStackIndex);
			g_gateway.invokeRemoteService('LoggingService', 'log', logMessage);
		}
		
		
		
		//*****************************************************************************************
		//*                                         Events                                        *
		//*****************************************************************************************
		private function stage_enterFrame(e:Event):void
		{
			g_lastFrames++;
		}
		
		private function monitorTimer_tick(e:TimerEvent):void
		{
			var now:Number = getTimer();
			var fps:Number = g_lastFrames / (getTimer() - g_lastTimeStamp) * 1000;
			g_lastFrames = 0;
			g_lastTimeStamp = now;
			g_gateway.invokeRemoteService('MonitoringService', 'trackFPS_memoryUse_timestamp', 
				fps, System.totalMemory, now);
		}
	}
}

import flash.net.registerClassAlias;
import flash.utils.getTimer;


internal class LogMessageVO
{
	
	{registerClassAlias('FlashLogMessage', LogMessageVO);}
	
	
	//*****************************************************************************************
	//*                                   Public Properties                                   *
	//*****************************************************************************************
	public var message:String;
	public var encodeHTML:Boolean = true;
	public var stacktrace:String;
	public var levelName:String;
	public var timestamp:Number;
	public var stackIndex:uint;
	
	
	
	//*****************************************************************************************
	//*                                   Private Properties                                  *
	//*****************************************************************************************
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
	
	
	
	//*****************************************************************************************
	//*                                     Public Methods                                    *
	//*****************************************************************************************
	public function LogMessageVO(aMessage:String, aStacktrace:String, aStackIndex:uint)
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
		timestamp = getTimer();
		message = aMessage;
		stacktrace = aStacktrace;
		stackIndex = aStackIndex;
	}
}