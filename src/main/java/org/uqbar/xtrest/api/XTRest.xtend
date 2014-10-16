package org.uqbar.xtrest.api

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.Handler

/**
 * Main program class
 * This starts an embedded jetty webserver that will be
 * listening for requests and calling you controllers.
 */
class XTRest {
	
	def static start(Class<? extends Handler> controller, int port) {
		new Server(port) => [
			handler = controller.newInstance
			start
			join
		]
	}
	
}