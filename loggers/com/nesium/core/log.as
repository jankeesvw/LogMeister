package com.nesium.core
{
	import flash.display.BitmapData;
	
	public function log(...rest) : void
	{
		if (!initialized)
initLogger( );
		if (!logger)
return;
		if (rest.length == 1 && rest[0] is BitmapData)
logger.logBitmapData( rest[0] );
else
logger.log( rest.toString( ) );
	}
}

import com.nesium.lib.com.nesium.logging.TrazzleLogger;
 
var logger : Object;
var initialized : Boolean;

function initLogger() : void
{
	initialized = true;
	try
	{
		var loggerClass : Class = TrazzleLogger as Class;
		logger = loggerClass['instance']( );
	}
catch (e : Error) 
	{
	}
}