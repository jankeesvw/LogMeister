package com.nesium.core
{
	import com.nesium.lib.com.nesium.logging.TrazzleLogger;

	import flash.display.Stage;
	public function zz_init(theStage : Stage, title : String) : void
	{
		try
		{
			var logger : Class = TrazzleLogger as Class;
			logger['instance']( ).setParams( theStage, title );
		}catch (e : Error) 
		{
		}
	}
}