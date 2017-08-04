package org.uqbar.xtrest.api

import org.eclipse.jetty.server.Handler
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.ResourceHandler
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Main program class
 * This starts an embedded jetty webserver that will be
 * listening for requests and calling you controllers.
 */
class XTRest {
	private static val DEFAULT_RESOURCE_PATH = 'src/main/webapp'
 	
	@Accessors static String resourcePath = DEFAULT_RESOURCE_PATH 

	def static start(Class<? extends Handler> controllerClass, int port) {
		startInstance(controllerClass.newInstance, port)
	}
	
	def static startInstance(Handler controller, int port) {
		new Server(port) => [
			
			val resource_handler = new ResourceHandler => [
		        directoriesListed = true
		        welcomeFiles = #['index.html']
	    	    resourceBase = resourcePath
			]
			
			handler = new HandlerList => [
				setHandlers(#[resource_handler, controller])
			]
			start
			join
		]
	}
	
}