package org.uqbar.xtrest

import java.math.BigDecimal
import java.time.LocalDate
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.junit.Assert
import org.junit.Test
import org.uqbar.xtrest.json.JSONUtils

@Accessors
class Person {
	String name
	int age
}

class JSONUtilTest {

	val jenniferCapriati = new Person => [
		name = "Jennifer Capriati"
		age = 41	
	]
	
	String jsonPerson = '''
	{
		"name": "Jennifer Capriati",
		"age": 41,
		"birth": "29/03/1976",
		"amount": 541.44
	}
	'''
	
	extension JSONUtils = new JSONUtils
	
	@Test
	def void mapOfProperties() {
		val Map<String, String> properties = jsonPerson.properties	
		Assert.assertEquals("Jennifer Capriati", properties.get("name"))
		Assert.assertEquals("41", properties.get("age"))		
	}	

	@Test
	def void getPropertyString() {
		Assert.assertEquals("Jennifer Capriati", jsonPerson.getPropertyValue("name"))		
	}	

	@Test
	def void getPropertyInt() {
		Assert.assertEquals(41, jsonPerson.getPropertyAsInteger("age"))		
	}

	@Test
	def void getPropertyDecimal() {
		Assert.assertEquals(new BigDecimal("541.44"), jsonPerson.getPropertyAsDecimal("amount"))		
	}
	
	@Test
	def void getPropertyDate() {
		Assert.assertEquals(LocalDate.of(1976,3,29), jsonPerson.getPropertyAsDate("birth"))		
	}

	@Test
	def void convertingToJsonAndBackToObject() {
		val jenniferConverted = jenniferCapriati.toJson.fromJson(Person)
		Assert.assertEquals(jenniferConverted.name, jenniferCapriati.name)
		Assert.assertEquals(jenniferConverted.age, jenniferCapriati.age)
	}
	
	@Test
	def void convertingToJsonWithIgnoredProperties() {
		val jenniferJSON = jsonPerson.fromJson(Person)
		Assert.assertEquals(jenniferJSON.name, "Jennifer Capriati")		
	}	
}