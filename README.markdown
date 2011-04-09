# Philosophy behind LogMeister

There are several Loggers used by Flash developers, some like Trazzle and others like the MonsterDebugger. I switch between loggers from time to time. I like Trazzle because it's super fast and I use MonsterDebugger because is really extensive. Therefor I needed an easy way to switch between loggers. That's why I created LogMeister. LogMeister is a simple logger wrapper which you can use for every loggers (I have used in the last four years).

You connect to loggers with a ‘connector’. All 3rth party code of loggers is included in this package, so switching loggers is as easy as adding one line of code. Getting all loggers out of your project is as easy as removing all connectors. And logmeister is packaged in one swc file which makes it easy to use.

## Included loggers

By default 8 loggers are included. These are the loggers I happen to use over the last years. It's really easy to add another logger skip to the ‘Creating your own connector’ section if you want to know how.

Included loggers:

* Firebug
* Flash (regular traces)
* Monster Debugger v2
* Monster Debugger v3 (NEW!)
* Server (to be open sourced)
* Sosmax
* Trazzle
* Yalog

## Usage

### Adding loggers

First you need to add one or multiple connectors to LogMeister.

Below you can see how to add all loggers (not recommended).

<pre>
import logmeister.LogMeister;
import logmeister.connectors.*;

LogMeister.addLogger(new TrazzleConnector(stage, "Application Name"));
LogMeister.addLogger(new SosMaxConnector());
LogMeister.addLogger(new MonsterDebuggerConnector(stage));
LogMeister.addLogger(new MonsterDebuggerV2Connector(stage));
LogMeister.addLogger(new YalogConnector());
LogMeister.addLogger(new FlashConnector());
LogMeister.addLogger(new FirebugConnector());
</pre>

As you can see Trazzle and the MonsterDebugger need the stage as a reference.

### Logging

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

Creating a custom connector for your own logger is not hard, as an example I created a CustomLogger below, this logger outputs 'traces'

<pre>
package logmeister.connectors {

	public class CustomConnector extends AbstractConnector implements ILogMeisterConnector {

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