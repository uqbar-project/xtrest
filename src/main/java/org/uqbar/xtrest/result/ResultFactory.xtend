package org.uqbar.xtrest.result

import static extension org.uqbar.xtrest.result.ResultCombinators.*
import static javax.servlet.http.HttpServletResponse.*
import org.eclipse.jetty.server.handler.AbstractHandler

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
}