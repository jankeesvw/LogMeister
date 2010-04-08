package com.nesium
{
	import flash.display.BitmapData;
	public function zz_beep():void{
		if (!initialized)
			initLogger();
		if (!logger)
			return;
		logger.beep();
	}
}

var logger : Object;
var initialized : Boolean;

import flash.utils.getDefinitionByName;
function initLogger() : void
{
	initialized = true;
	try
	{
		var loggerClass:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
		logger = loggerClass['instance']();
	}
	catch (e:Error) {}
}