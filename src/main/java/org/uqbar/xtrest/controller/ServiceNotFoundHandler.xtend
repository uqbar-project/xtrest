package org.uqbar.xtrest.controller

import java.io.IOException
import java.lang.annotation.Annotation
import java.lang.reflect.Method
import java.util.List
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Request
import org.eclipse.jetty.server.handler.HandlerWrapper
import org.eclipse.xtend.lib.annotations.Data
import org.uqbar.xtrest.api.ControllerAnnotationProcessor
import org.uqbar.xtrest.api.annotation.Delete
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.i18n.Messages

class ServiceNotFoundHandler extends HandlerWrapper {

	List<Class> controllers
	
	new(List<Class> controllers) {
		this.controllers = controllers
	}

	override handle(String target, Request baseRequest, HttpServletRequest request,
		HttpServletResponse response) throws IOException, ServletException {
		baseRequest.handled = true
		response.writer.write(
			'''
				<html>
					<head>
						<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
						<title>XTRest Server message</title>
					    <style>
					      body {
					        font-family: Roboto, serif;
					        font-size: 14px;
					      }
					      
							table {
							    width: 80%;
						        border-collapse: collapse;
							}
							
							th {
							    background-color: #045FB4;
							    color: white;
							}
							
							th, td {
							    height: 2rem;
							    padding: 15px;
							    text-align: left;
						        border-bottom: 1px solid #ddd;
							}
							
							table, th {
							    border: 1px solid black;
							}
							
							tr:hover {background-color: #A9D0F5}
							
							tr:nth-child(even) {background-color: #f2f2f2}
					    </style>
					</head> 
				<body>
					<h1>XTRest - «Messages.getMessage(Messages.SERVICE_NOT_FOUND_MAIN_TITLE)»<h1>
					<hr>
					<h2>«Messages.getMessage(Messages.SERVICE_NOT_FOUND_SUPPORTED_RESOURCES)»</h2>
					
					<table>
						<thead>
							<tr>
								<th>«Messages.getMessage(Messages.SERVICE_NOT_FOUND_TH_VERB)»</th>
								<th>«Messages.getMessage(Messages.SERVICE_NOT_FOUND_TH_URL)»</th>
							</tr>
						</thead>
						<tbody>
			'''
		)

		httpMethods.forEach [ m |
			response.writer.write(
				'''
					<tr>
						<td>«m?.verb»</td>
						<td>«m?.value»</td>
					</tr>
				'''
			)
		]
		
		response.writer.write(
		'''
			</tbody>
		</table>
		</body>
		''')

		response.setStatus(404)
		baseRequest.setHandled(true)

	}
	
	def httpMethods() {
		controllers.map [ ctrl | 
			ctrl
				.methods
				.filter [ method | method.httpRest ]
		].flatten
		.map [ method | method.httpRestAnnotation ]
	}
	
	def httpRestAnnotation(Method m) {
		val verb = m.annotations.filter [
			ControllerAnnotationProcessor.verbs.contains(it.annotationType)
		]?.head
		if (verb === null) return null
		new HttpAnnotation(verb.annotationType?.simpleName, verb.value)
	}
	
	def httpRest(Method method) {
		ControllerAnnotationProcessor.verbs.exists [ verb | method.isAnnotationPresent(verb) ]
	}
	
	def static dispatch getValue(Annotation annotation) { "" }
	def static dispatch getValue(Get get) {	get.value }
	def static dispatch getValue(Put put) {	put.value }
	def static dispatch getValue(Post post) { post.value }
	def static dispatch getValue(Delete delete) { delete.value }
}


@Data
class HttpAnnotation {
	String verb
	String value
}