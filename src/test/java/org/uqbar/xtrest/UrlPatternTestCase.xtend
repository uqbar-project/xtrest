package org.uqbar.xtrest

import org.junit.Assert
import org.junit.Test
import org.uqbar.xtrest.api.HttpHandlerProcessor

/**
 * @author jfernandes
 */
class UrlPatternTestCase extends Assert {
	var processor = new HttpHandlerProcessor()
	
	@Test
	def testSimpleUrlWithoutVariables() {
		var regexp = processor.createRegexp("/libros")
		assertEquals('/libros' -> #[], regexp)
		
		assertTrue(regexp.key.matches("/libros"))
	}
	
	@Test 
	def testOneVar() {
		var regexp = processor.createRegexp("/libros/:id")
		assertEquals('\\\\/libros\\\\/(\\\\w+)' -> #['id'], regexp)
		
		assertTrue(regexp.key.matches("/libros/2"))
	}
	
}