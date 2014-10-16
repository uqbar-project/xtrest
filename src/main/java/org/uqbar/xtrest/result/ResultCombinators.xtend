package org.uqbar.xtrest.result

import javax.servlet.http.HttpServletResponse

/**
 * 
 * @author jfernandes
 */
class ResultCombinators {
	//an alias would be really appreaciated
	//	alias Result -> (HttpServletResponse)=>void

	def static (HttpServletResponse)=>void operator_doubleGreaterThan((HttpServletResponse)=>void one, (HttpServletResponse)=>void then) {
		[r| one.apply(r) ; then.apply(r) ]
	}
	
	// just for typing a closure without specifying the param type
	def static result((HttpServletResponse)=>void responseConfigurer) {
		responseConfigurer
	}
	
}