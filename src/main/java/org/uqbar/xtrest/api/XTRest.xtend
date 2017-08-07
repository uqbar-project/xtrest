package org.uqbar.xtrest.api

import java.util.ArrayList
import org.eclipse.jetty.server.Handler
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.ResourceHandler
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.xtrest.controller.ServiceNotFoundHandler
import org.uqbar.xtrest.exceptions.XTRestException
import org.uqbar.xtrest.i18n.Messages

/**
 * Main program class
 * This starts an embedded jetty webserver that will be
 * listening for requests and calling you controllers.
 */
class XTRest {
	private static val DEFAULT_RESOURCE_PATH = 'src/main/webapp'
 	
	@Accessors static String resourcePath = DEFAULT_RESOURCE_PATH 

	def static start(int port, Class<? extends Handler>... controllersClass) {
		if (controllersClass.isEmpty) {
			throw new XTRestException(Messages.getMessage(Messages.SERVER_NO_CONTROLLER_DEFINED))
		} 
		startInstance(port, controllersClass.map [ newInstance ])
	}
	
	def static startInstance(int port, Handler... controllers) {
		new Server(port) => [
			
			val resource_handler = new ResourceHandler => [
		        directoriesListed = true
		        welcomeFiles = #['index.html']
	    	    resourceBase = resourcePath
			]
			
			handler = new HandlerList => [
				setHandlers(new ArrayList<Handler> => [
					add(resource_handler)
					addAll(controllers)
					add(new ServiceNotFoundHandler(controllers.map [ it.class ]))
				])
			]
			
			start
			join
		]
	}
	
}