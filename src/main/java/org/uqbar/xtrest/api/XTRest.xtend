package org.uqbar.xtrest.api

import org.eclipse.jetty.server.Handler
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.ResourceHandler

/**
 * Main program class
 * This starts an embedded jetty webserver that will be
 * listening for requests and calling you controllers.
 */
class XTRest {
	public static val RESOURCE_BASE = 'src/main/webapp'
	
	def static start(Class<? extends Handler> controller, int port) {
		new Server(port) => [
			
			val resource_handler = new ResourceHandler => [
		        directoriesListed = true
		        welcomeFiles = #['index.html']
	    	    resourceBase = RESOURCE_BASE
			]
			
			handler = new HandlerList => [
				setHandlers(#[resource_handler, controller.newInstance])
			]
//			handler = controller.newInstance
			start
			join
		]
	}
	
}