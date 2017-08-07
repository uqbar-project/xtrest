package org.uqbar.xtrest.json

import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.math.BigDecimal
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException
import java.util.Map

/**
 * Provides JSON utility methods
 * as facade to json libraries.
 * 
 * Also implements them as extension methods
 * so they can be used nicely in your controller class.
 * 
 * @author jfernandes
 * @author dodain - added extension method to retrieve value of certain properties
 * 
 */
class JSONUtils {
	val mapper = new ObjectMapper() => [
		configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
		configure(SerializationFeature.INDENT_OUTPUT, true)
	]
	
	def toJson(Object obj) {
		mapper.writeValueAsString(obj)
	}
	
	def <T> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
	}
	
	def Map<String, String> getProperties(String json) {
		mapper.readValue(json, new TypeReference<Map<String, String>>() {})
	}

	def String getPropertyValue(String json, String property) {
		json.properties.get(property)
	}

	def Integer getPropertyAsInteger(String json, String property) {
		var Integer result = null
		try {
			result = new Integer(getPropertyValue(json, property))
		} catch (NumberFormatException e) {
		}
		result
	}
	
	def BigDecimal getPropertyAsDecimal(String json, String property) {
		var BigDecimal result = null
		try {
			result = new BigDecimal(getPropertyValue(json, property))
		} catch (NumberFormatException e) {
		}
		result
	}
	
	def LocalDate getPropertyAsDate(String json, String property) {
		getPropertyAsDate(json, property, "dd/MM/yyyy")	
	}
	
	def LocalDate getPropertyAsDate(String json, String property, String dateFormat) {
		var LocalDate result = null
		try {
			result = LocalDate.parse(getPropertyValue(json, property), DateTimeFormatter.ofPattern(dateFormat))
		} catch (DateTimeParseException e) {
		}
		result
	}
	
}