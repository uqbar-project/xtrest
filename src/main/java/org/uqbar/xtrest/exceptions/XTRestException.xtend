package org.uqbar.xtrest.exceptions

import java.lang.RuntimeException

class XTRestException extends RuntimeException {
	
	new(String msg) {
		super(msg)
	}
	
	new(String msg, Throwable cause) {
		super(msg, cause)
	}
}