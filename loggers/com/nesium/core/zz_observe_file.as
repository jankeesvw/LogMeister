package com.nesium.core
{
	import com.nesium.lib.com.nesium.logging.TrazzleLogger;
	public function zz_observe_file(path : String, listener : Function, remove : Boolean = false) : void
	{
		try
		{
			var logger : Class = TrazzleLogger as Class;
			logger['instance']( ).observeFile( path, listener, remove );
		}
catch (e : Error) 
		{
		}
	}
}