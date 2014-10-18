package org.uqbar.xtrest.api.annotation

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active
import org.uqbar.xtrest.api.ControllerAnnotationProcessor
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy

/**
 * Marks a given class as being an HTTP controller.
 * Controllers are objects whose methods handle http requests.
 * 
 * XtRest knows which method to call for a given request
 * also based on method's annotations.
 * 
 * There's an annotation for each HTTP verb (or method): 
 * 
 * @link Get
 * @link Post
 * @link Put
 * @link Delete
 * 
 * @author jfernandes
 */
@Active(ControllerAnnotationProcessor)
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
annotation Controller { 
	
}

// *****************************************
// ** Method annotations for http verbs
// *****************************************

@Target(ElementType.METHOD)
annotation Get { String value }

@Target(ElementType.METHOD)
annotation Post { String value }

@Target(ElementType.PARAMETER)
annotation Body {}

@Target(ElementType.METHOD)
annotation Put { String value }

@Target(ElementType.METHOD)
annotation Delete { String value }

// TODO
// PUT

