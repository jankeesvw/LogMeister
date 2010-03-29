package com.nesium.core
{
	public function zz_beep() : void
	{
		if (!initialized)
initLogger( );
		if (!logger)
return;
		logger.beep( );
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