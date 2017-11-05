package org.uqbar.xtrest.controller

import org.eclipse.jetty.server.handler.AbstractHandler
import org.eclipse.jetty.server.Request
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.io.IOException
import javax.servlet.ServletException

class CORSHandler extends AbstractHandler {
    override void handle(String target, Request request,HttpServletRequest servletRequest, HttpServletResponse response) throws IOException, ServletException {
        response.addHeader("Access-Control-Allow-Origin", "*")
        if(servletRequest.method == "OPTIONS"){ // CORS Preflight, see: https://developer.mozilla.org/en-US/docs/Glossary/Preflight_request
            response.addHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS")
            response.addHeader("Access-Control-Max-Age", "86400")
            response.addHeader("Access-Control-Allow-Headers", "origin, content-type, accept")
      	    response.setStatus(200)
            request.setHandled(true)
        }
    }
}
