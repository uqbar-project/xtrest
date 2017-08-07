package org.uqbar.xtrest

import org.junit.Rule
import org.junit.Test
import org.junit.rules.ExpectedException
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.exceptions.XTRestException
import org.uqbar.xtrest.i18n.Messages

class ServerTest {
	
	@Rule
	public ExpectedException expectedException = ExpectedException.none
	
	@Test
	def void serverWithNoController() {
		expectedException.expectMessage(Messages.getMessage(Messages.SERVER_NO_CONTROLLER_DEFINED))
		expectedException.expect(XTRestException)
		XTRest.start(9000)
	}
	
}


