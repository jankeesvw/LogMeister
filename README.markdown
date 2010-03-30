# Why LogMeister

There are several Loggers used by Flash developers I created a wrapper which you can use for the most common loggers. You connect to loggers with a ‘connector’. All 3rth party code of the loggers is included in this package, so if you want to try another logger, you just need to change one line of code.

# Included loggers

* Trazzle (1.2 and 1.5)
* Sosmax
* Flash (regular trace)
* Alcon logger
* Monster Debugger
* Server (php server to be open sourced)
* Yalog

# Usage

## Adding loggers

First you need to add one or multiple Loggers to your application, to connect to a logger LogMeister uses Connectors. Every connector has it's own features below is an example usage of all included connectors:

<pre>
import logmeister.LogMeister;
import logmeister.connectors.*;

LogMeister.addLogger(new TrazzleConnector(stage, "Application Name"));
LogMeister.addLogger(new SosMaxConnector());
LogMeister.addLogger(new MonsterDebuggerConnector(stage));
LogMeister.addLogger(new YalogConnector());
LogMeister.addLogger(new FlashConnector());
</pre>

As you can see Trazzle and the MonsterDebugger need the stage as a reference.

## Logging

If you want to send a log to all your active loggers pick one of the following functions. (You don't need to import anything!!)

<pre>
critical('critical');
debug('debug');
error('error');
fatal('fatal');
info('info');
notice('notice');
status('status');
warn('warn');
trace('regular trace');
</pre>

# Creating your own connector

Creating a custom connector for your own logger is not hard, as an example I added the FlashLogger below. The FlashLogger sends regular traces.

<pre>
package logmeister.connectors {

	public class FlashConnector extends LogMeisterConnector implements ILogMeisterConnector {

		public function init() : void {
		}

		public function sendDebug(...args) : void {
			trace("debug    : " + args + " " + getSender());
		}

		public function sendInfo(...args) : void {
			trace("info     : " + args + " " + getSender());
		}

		public function sendNotice(...args) : void {
			trace("notice   : " + args + " " + getSender());
		}

		public function sendWarn(...args) : void {
			trace("warn     : " + args + " " + getSender());
		}

		public function sendError(...args) : void {
			trace("error    : " + args + " " + getSender());
		}

		public function sendFatal(...args) : void {
			trace("fatal    : " + args + " " + getSender());
		}

		public function sendCritical(...args) : void {
			trace("critical : " + args + " " + getSender());
		}

		public function sendStatus(...args) : void {
			trace("status   : " + args + " " + getSender());
		}
	}
}
</pre>