package org.uqbar.xtrest.api

import org.eclipse.jetty.server.handler.AbstractHandler
import org.eclipse.jetty.server.Request
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.io.IOException
import javax.servlet.ServletException

/**
 * Adapts a controller against jetty expected 
 * HttpHandler interface
 * 
 * @author jfernandes
 */
class XTRestHandler extends AbstractHandler {
	
	override handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		
	}
	
}