package org.uqbar.xtrest.json

import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Provides JSON utility methods
 * as facade to json libraries.
 * 
 * Also implements them as extension methods
 * so they can be used nicely in your controller class.
 * 
 * @author jfernandes
 */
class JSONUtils {
	ObjectMapper mapper = new ObjectMapper();
	
	def toJson(Object obj) {
		mapper.writeValueAsString(obj)
	}
	
	def <T> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
	}
	
}