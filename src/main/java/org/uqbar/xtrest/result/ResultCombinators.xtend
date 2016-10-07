package org.uqbar.xtrest.result

import javax.servlet.http.HttpServletResponse
import org.uqbar.xtrest.api.Result

/**
 * Utilities to combine different Result objects.
 * 
 * @author jfernandes
 */
class ResultCombinators {

	def static Result operator_doubleGreaterThan(Result one, Result then) {
		[r|one.process(r); then.process(r)]
	}

	/**
	 * Adapts a closure into the Result interface.
	 *
	 * @param responseConfigurer the configurer
	 * @return an instance of Result
	 */
	def static result((HttpServletResponse)=>void responseConfigurer) {
		new Result() {
			override process(HttpServletResponse response) {
				responseConfigurer.apply(response)
			}
		}
	}

}
