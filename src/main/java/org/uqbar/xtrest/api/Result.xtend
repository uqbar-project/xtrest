package org.uqbar.xtrest.api

import javax.servlet.http.HttpServletResponse

/**
 * The result for an http request.
 * Every controller's method must return one of this objects.
 * 
 * @author jfernandes
 */
interface Result {
	
	def void process(HttpServletResponse response)
	
}