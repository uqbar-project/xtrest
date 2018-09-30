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
	// ** 2xx -
	// ****************************
	
	// 200 OK
	def static ok() { result [ status = SC_OK ] }
	def static ok(String content) { ok >> body(content) }
	
	// 201 Created
	def static created() { result [ status = SC_CREATED ] }
	def static created(String content) { created >> body(content) }

	// 202 Accepted
	def static accepted() { result [ status = SC_ACCEPTED ] }
	def static accepted(String content) { accepted >> body(content) }

	// 204 No Content
	def static noContent() { result [ status = SC_NO_CONTENT ]}

	// ****************************
	// ** 4XX - 
	// ****************************
	
	// 400 Bad Request
	def static badRequest() { result [ status = SC_BAD_REQUEST ] }
	def static badRequest(String content) { badRequest >> body(content) }
	
	// 401 Unauthorized
	def static unauthorized() { result [ status = SC_UNAUTHORIZED ] }
	def static unauthorized(String content) { unauthorized >> body(content) }

	// 403 Forbidden
	def static forbidden() { result [ status = SC_FORBIDDEN ] }
	def static forbidden(String content) { forbidden >> body(content) }
	
	// 404 Not Found
	def static notFound() { result [ status = SC_NOT_FOUND ] }
	def static notFound(String content) { notFound >> body(content) }
	
	// 405 Method Not Allowed
	def static methodNotAllowed() { result [ status = SC_METHOD_NOT_ALLOWED ] }
	def static methodNotAllowed(String content) { methodNotAllowed >> body(content) }

	// ****************************
	// ** 5XX - 
	// ****************************
	
	// 500 Internal Server Error
	def static internalServerError() { result [ status = SC_INTERNAL_SERVER_ERROR ] }
	def static internalServerError(String content) { internalServerError >> [ writer.write(content) ] }
	
	// 501 Not Implemented
	def static notImplemented() { result [ status = SC_NOT_IMPLEMENTED ] }
	def static notImplemented(String content) { notImplemented >> [ writer.write(content) ] }

	// ****************************
	// ** Custom Codes
	// ****************************

	/**
	 * To use only when user needs to response with
	 * HTTP Code that is not yet implemented
	 */
	def static custom(String content, int code) {
		result [
			status = code
			body = content
		]
	}

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
			val reader = Resource.newResource(XTRest.getResourcePath + '/' + templatePath).readableByteChannel
			val template = Mustache.compiler.compile(Channels.newReader(reader, 'UTF-8'))
			template.execute(data, response.writer)
		]
	}
	
	def readBodyAsString(HttpServletRequest request) {
		// Read from request
		val buffer = new StringBuilder
		val reader = request.reader
		var line = reader.readLine
		while (line !== null) {
			buffer.append(line)
			line = reader.readLine
		}
		buffer.toString
	}
}
