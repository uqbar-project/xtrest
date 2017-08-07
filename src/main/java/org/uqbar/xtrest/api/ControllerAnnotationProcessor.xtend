package org.uqbar.xtrest.api

import java.io.IOException
import java.util.List
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Request
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.Type
import org.uqbar.xtrest.api.annotation.Delete
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.result.ResultFactory
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Put
import org.eclipse.xtend.lib.macro.declaration.MutableParameterDeclaration
import org.uqbar.xtrest.api.annotation.Body

/**
 * The annotation processor for @link Controller.
 * Like a macro, it participates in the java code construction,
 * so it can generate code.
 * 
 * Basically it makes your class extends jetty's @link AbstractHandler
 * So it generates the #handle method which will have an "if-then" block
 * for each action method (annotated with @Get, @Post, etc).
 * 
 * For each of them it generates something like
 * 
 * <pre>
 * <code>
 * if (annotation.pattern.matches(url) {@literal &&} request.isVerb(annotation.verb) {
 * 		this.xxxxx(url, baseRequest, request, response)
 * }
 * </code>
 * </pre>
 * 
 * Where "xxx" is the name of the original method.
 * 
 * So, notice that it changes your original method, introducing parameters.
 * 
 * <h3>URL variables</h3>
 * 
 * In case the pattern defines variables, then it will introduce them as method parameters
 * Example:
 * 
 * <pre>
 * <code>
 * 	{@literal @}Get("/books/:id")
 *  def getBook()
 * </code>
 * </pre>
 * 
 * Will actually be transformed to a method
 * <pre>
 * <code>
 *   public Result getBook(String id, String url, Request baseRequest, HttpServletRequest request, HttpServletResponse response)
 * </code>
 * </pre>
 *
 * <h3>HTTP Parameters</h3>
 * 
 * In case you need to handle incoming HTTP parameters then you just need
 * to declare them as method parameters. They will be kept in the generated method.
 * <pre>
 * <code>
 * 	{@literal @}Get("/books")
 *  def getBook(String id)
 * </code>
 * </pre>
 * 
 * Will have the same effect as the previous example.
 * 
 * @author jfernandes
 */
class ControllerAnnotationProcessor implements TransformationParticipant<MutableClassDeclaration> {
	public static val verbs = #[Get, Post, Delete, Put]
	
	override doTransform(List<? extends MutableClassDeclaration> annotatedTargetElements, extension TransformationContext context) {
		for (clazz : annotatedTargetElements) {
			clazz.extendedClass = newTypeReference(ResultFactory)
			
			createHandlerMethod(clazz, context)
			addParametersToActionMethods(clazz, context)
			
			// TODO : Armar un handler que lo que haga sea esto, mandar un generatePageNotFound en base a todos los handlers anteriores
			//generatePageNotFound(clazz, context)
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
							«IF p.isBodyParameter(context) »
							String «p.simpleName» = readBodyAsString(request);
							«ELSE»
							String «p.simpleName» = request.getParameter("«p.simpleName»");
							«ENDIF»
						«ENDFOR»
						
						// take variables from url
						«var i = 0»
						«FOR v : variables»
							String «v» = matcher.group(«i=i+1»);
						«ENDFOR»
						
						
					    «toJavaCode(newTypeReference(Result))» result = «m.simpleName»(«m.httpParameters.filter[!variables.contains(simpleName)].map[simpleName + ', '].join»«variables.map[it+', '].join»target, baseRequest, request, response);
					    result.process(response);
					    
						response.addHeader("Access-Control-Allow-Origin", "*");
					    baseRequest.setHandled(true);
					    return;
					}
				}
				«ENDFOR»
				//this.pageNotFound(baseRequest, request, response);
			''']
		]
	}
	
	def boolean isBodyParameter(MutableParameterDeclaration param, extension TransformationContext context) {
		param.findAnnotation(findTypeGlobally(Body)) != null
	}
	
	// ***************************************************
	// ** Utility methods for interpreting annotations
	// ***************************************************	
	
	def httpMethods(MutableClassDeclaration clazz, extension TransformationContext context) {
		val verbAnnotations = verbs.map[findTypeGlobally]
		verbAnnotations.map[annotation |
			clazz.declaredMethods.filter [findAnnotation(annotation)?.getValue('value') != null]
		].flatten
	}
	
	private def getUrl(MutableMethodDeclaration m, extension TransformationContext context) {
		m.findAnnotation(m.httpAnnotation(context)).getValue('value').toString
	}
	
	static val ADDED_PARAMETER = #['target', 'baseRequest', 'request', 'response']
	
	def getHttpParameters(MutableMethodDeclaration m) {
		m.parameters.filter[ !ADDED_PARAMETER.contains(simpleName) ]
	}

	private def getPattern(MutableMethodDeclaration m, extension TransformationContext context) {
		m.getVariablesAndGroupedPattern(context).key
	}
	
	private def getVariables(MutableMethodDeclaration m, extension TransformationContext context) {
		m.getVariablesAndGroupedPattern(context).value
	}
	
	def Type httpAnnotation(MutableMethodDeclaration m, extension TransformationContext context) {
		val verbAnnotations = verbs.map[findTypeGlobally]
		verbAnnotations.findFirst[m.findAnnotation(it) != null]
	}
	
	private def getVariablesAndGroupedPattern(MutableMethodDeclaration m, extension TransformationContext context) {
		createRegexp(m.getUrl(context))
	}
	
	def createRegexp(String pattern) {
		val variableMatcher = Pattern.compile('(:\\w+)').matcher(pattern)
		val builder = new StringBuilder
		var i = 0
		val variables = newArrayList
		while (variableMatcher.find) {
			variables += variableMatcher.group.substring(1)
			builder.append(pattern.substring(i, variableMatcher.start)) //.replace('/','\\/'))
			builder.append("(\\\\w+)")
			i = variableMatcher.end
		}
		if (i < pattern.length)
			builder.append(pattern.substring(i, pattern.length))
		return builder.toString -> variables
	}
	
}