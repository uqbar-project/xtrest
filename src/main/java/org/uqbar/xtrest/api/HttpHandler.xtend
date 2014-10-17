package org.uqbar.xtrest.api

import java.io.IOException
import java.util.List
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Request
import org.eclipse.jetty.server.handler.AbstractHandler
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.Type
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import org.uqbar.xtrest.result.ResultFactory

@Active(HttpHandlerProcessor)
annotation HttpHandler {
}

annotation Get { String value }
annotation Delete { String value }

class HttpHandlerProcessor implements TransformationParticipant<MutableClassDeclaration> {
	static val verbs = #[Get, Delete]
	
	override doTransform(List<? extends MutableClassDeclaration> annotatedTargetElements, extension TransformationContext context) {
		for (clazz : annotatedTargetElements) {
			clazz.extendedClass = newTypeReference(ResultFactory)
			
			createHandlerMethod(clazz, context)
			addParametersToActionMethods(clazz, context)
		}
	}
	
	def addParametersToActionMethods(MutableClassDeclaration clazz, extension TransformationContext context) {
		
		clazz.httpMethods(context).forEach [
			getVariables(context).forEach [v| addParameter(v, string) ]
			addParameter('target', string)
			addParameter('baseRequest', newTypeReference(Request)) 
			addParameter('request', newTypeReference(HttpServletRequest)) 
			addParameter('response', newTypeReference(HttpServletResponse))
		]
	}
	
	protected def createHandlerMethod(MutableClassDeclaration clazz, extension TransformationContext context) {
		clazz.addMethod('handle') [
			returnType = primitiveVoid
			addParameter('target', string)
			addParameter('baseRequest', newTypeReference(Request)) 
			addParameter('request', newTypeReference(HttpServletRequest)) 
			addParameter('response', newTypeReference(HttpServletResponse))
			
			setExceptions(newTypeReference(IOException), newTypeReference(ServletException))
			
			body = ['''
				«FOR m : clazz.httpMethods(context)»
					{
						«toJavaCode(newTypeReference(Matcher))» matcher = 
							«toJavaCode(newTypeReference(Pattern))».compile("«m.getPattern(context)»").matcher(target);
						if (request.getMethod().equalsIgnoreCase("«m.httpAnnotation(context).simpleName»") && matcher.matches()) {
							// take parameters from request
							«val variables = m.getVariables(context) »
							«FOR p : m.httpParameters.filter[!variables.contains(simpleName)]»
								String «p.simpleName» = request.getParameter("«p.simpleName»");
							«ENDFOR»
							
							// take variables from url
							«var i = 0»
							«FOR v : variables»
								String «v» = matcher.group(«i=i+1»);
							«ENDFOR»
							
							
						    «toJavaCode(newTypeReference(Result))» result = «m.simpleName»(«m.httpParameters.filter[!variables.contains(simpleName)].map[simpleName + ', '].join»«variables.map[it+', '].join»target, baseRequest, request, response);
						    result.process(response);
						    
						    baseRequest.setHandled(true);
						}
					}
				«ENDFOR»
			''']
		]
	}
	
//	
	
	def httpMethods(MutableClassDeclaration clazz, extension TransformationContext context) {
		val verbAnnotations = verbs.map[findTypeGlobally]
		verbAnnotations.map[annotation |
			clazz.declaredMethods.filter [findAnnotation(annotation)?.getValue('value') != null]
		].flatten
	}
	
	static val ADDED_PARAMETER = #['target', 'baseRequest', 'request', 'response']
	
	def getHttpParameters(MutableMethodDeclaration m) {
		m.parameters.filter[ !ADDED_PARAMETER.contains(simpleName)]
	}
	
	private def getVariables(MutableMethodDeclaration m, extension TransformationContext context) {
		return m.getVariablesAndGroupedPattern(m.httpAnnotation(context)).value
	}
	
	private def getPattern(MutableMethodDeclaration m, extension TransformationContext context) {
		return m.getVariablesAndGroupedPattern(m.httpAnnotation(context)).key
	}
	
	def Type httpAnnotation(MutableMethodDeclaration m, extension TransformationContext context) {
		val verbAnnotations = verbs.map[findTypeGlobally]
		verbAnnotations.findFirst[m.findAnnotation(it) != null]
	}
	
	private def getVariablesAndGroupedPattern(MutableMethodDeclaration m, Type annotationType) {
		var pattern = m.findAnnotation(annotationType).getValue('value').toString
		createRegexp(pattern)
	}
	
	def createRegexp(String pattern) {
		val variableMatcher = Pattern.compile('(:\\w+)').matcher(pattern)
		val builder = new StringBuilder
		var i = 0
		val variables = newArrayList
		while (variableMatcher.find) {
			variables += variableMatcher.group.substring(1)
			builder.append(pattern.substring(i, variableMatcher.start).replace('/','\\\\/'))
			builder.append("(\\\\w+)")
			i = variableMatcher.end
		}
		if (i < pattern.length)
			builder.append(pattern.substring(i, pattern.length))
		return builder.toString -> variables
	}
	
}