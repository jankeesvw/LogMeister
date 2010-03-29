package com.nesium.core
{
	import com.nesium.lib.com.nesium.logging.TrazzleLogger;


	public function logf(format : String, ...rest) : void
	{
		try
		{
			var logger : Class = TrazzleLogger as Class;
			var printf : Function = printf as Function;
			logger['instance']( ).log( printf.apply( null, [ format ].concat( rest ) ) );
		}
catch (e : Error) 
		{
		}
	}
}