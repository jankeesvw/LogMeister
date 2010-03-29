package com.nesium.core
{
	import com.nesium.lib.com.nesium.logging.TrazzleLogger;
	public function zz_inspect(obj : *) : void
	{
		try
		{
			var logger : Class = TrazzleLogger as Class;
			logger['instance']( ).inspectObject( obj );
		}
catch (e : Error) 
		{
		}
	}
}