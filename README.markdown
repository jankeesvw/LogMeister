# Why I created LogMeister

There are several Loggers used by Flash developers, some like logger A and others like B. I switch between loggers from time to time. I like Trazzle because it's lightning fast and I use MonsterDebugger because is really extensive. 

I needed a easy way to switch between loggers. That's why I created LogMeister. LogMeister is a wrapper which you can use for every loggers (I have used in the last years).

You connect to loggers with a ‘connector’. All 3rth party code of loggers is included in this package. So switching between loggers is as easy as adding one line of code. Getting all loggers out of your project is as easy as removing all connectors. Another thing is all code is in one swc file which makes it super maintainable.

# Included loggers

By default 6 loggers are included. These are the loggers I happen to use over the last years. It's really easy to add another logger skip to the ‘Creating your own connector’ section if you want to know how.

Included loggers:

* Firebug (NEW!)
* Trazzle
* Sosmax
* Flash (regular traces)
* Monster Debugger
* Yalog
* Server (to be open sourced)

# Usage

## Adding loggers

First you need to add one, or multiple Connectors to LogMeister.

Below you can see how to add all loggers (not recommended).

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