package org.uqbar.xtrest.result

import com.samskivert.mustache.Mustache
import java.nio.channels.Channels
import javax.servlet.http.HttpServletRequest
import org.eclipse.jetty.server.handler.AbstractHandler
import org.eclipse.jetty.util.resource.Resource
import org.uqbar.xtrest.api.XTRest

import static javax.servlet.http.HttpServletResponse.*

import static extension org.uqbar.xtrest.result.ResultCombinators.*

/**
 * Utility methods for creating HTTP Result objects.
 * 
 * @author jfernandes
 */
abstract class ResultFactory extends AbstractHandler {
	
	// ****************************
	// ** 200 OK
	// ****************************
	
	def static ok() { result [ status = SC_OK ] }
	def static ok(String content) { ok >> body(content) }
	
	// ****************************
	// ** 4XX - 
	// ****************************
	
	def static badRequest() { result [ status = SC_BAD_REQUEST ] }
	def static badRequest(String content) { badRequest >> body(content) }
	
	def static forbidden() { result [ status = SC_FORBIDDEN ] }
	def static forbidden(String content) { forbidden >> body(content) }
	
	def static notFound() { result [ status = SC_NOT_FOUND ] }
	def static notFound(String content) { notFound >> body(content) }
	
	// ****************************
	// ** 5XX - 
	// ****************************
	
	def static internalServerError() { result [ status = SC_INTERNAL_SERVER_ERROR ] }
	def static internalServerError(String content) { internalServerError >> [ writer.write(content) ] }
	
	// ****************************
	// ** General
	// ****************************
	
	def static body(String content) { result [ writer.write(content) ] }
	
	def static header(String name, String value) { result [ setHeader(name, value) ] }
	
	
	// ****************************
	// ** View (templating)
	// ****************************	
	
	def static render(String templatePath, Object data) {
		// eventually we should have pluggable template engines
		// being able to support differents
		ok >> [response | 
			val reader = Resource.newResource(XTRest.RESOURCE_BASE + '/' + templatePath).readableByteChannel
			val template = Mustache.compiler.compile(Channels.newReader(reader, 'UTF-8'))
			template.execute(data, response.writer)
		]
	}
	
	def readBodyAsString(HttpServletRequest request) {
		// Read from request
    	val buffer = new StringBuilder
    	val reader = request.reader
    	var line = reader.readLine
    	while (line != null) {
        	buffer.append(line)
        	line = reader.readLine
    	}
    	buffer.toString
	}
}