package org.uqbar.xtrest

import org.junit.Assert
import org.junit.Test
import org.uqbar.xtrest.api.ControllerAnnotationProcessor
import java.util.regex.Pattern

/**
 * @author jfernandes
 */
class UrlPatternTestCase extends Assert {
	var processor = new ControllerAnnotationProcessor()
	
	@Test
	def testSimpleUrlWithoutVariables() {
		var regexp = processor.createRegexp("/libros")
		assertEquals('/libros' -> #[], regexp)
		
		assertTrue(regexp.key.matches("/libros"))
	}
	
	@Test 
	def testOneVar() {
		var regexp = processor.createRegexp("/libros/:id")
		assertEquals('\\/libros\\/(\\w+)' -> #['id'], regexp)
		
		assertTrue(Pattern.compile("\\/libros\\/(\\w+)").matcher("/libros/2").matches)
	}
	
}