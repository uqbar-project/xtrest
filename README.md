xtrest
======

XTend Rest Mini-Framework: create REST HTTP JSON API's with the power of Xtend language.

It's based on Sven Efftinge's jettyxtension (https://github.com/svenefftinge/jettyxtension). But it extends
it in order to fully support all HTTP methods.

Originally it was designed in order to create just REST API's, but eventually it could evolve into a full MVC
"action-based" web frameworks, once template engines are included.
I will then get similar to Sinatra, Padrino, Play, etc.

Example
======

```xtend
/**
 * Ejemplo de controller REST/JSON en xtrest
 * 
 * @author jfernandes
 */
@HttpHandler
class LibrosController {
	extension JSONUtils = new JSONUtils
	
	@Get("/libros")
	def libros() {
		response.contentType = "application/json"
    	val libros = Biblioteca.instance.todasLasInstancias
		ok(libros.toJson)
	}
	
	@Get('/libros/:id')
	def libro() {
		response.contentType = "application/json"
		val iId = Integer.valueOf(id)
    	try {
    		ok(Biblioteca.instance.getLibro(iId).toJson)
    	}
    	catch (UserException e) {
    		notFound("No existe libro con id '" + id + "'");
    	}
    }
    
    @Delete('/libros/:id')
    def eliminarLibro() {
    	try {
    		val iId = Integer.valueOf(id)
    		Biblioteca.instance.eliminarLibro(iId)
    		ok("{ status : 'ok' }");
    	}
    	catch (UserException e) {
    		return notFound("No existe libro con id '" + id + "'");
    	}
    }
	
	def static void main(String[] args) {
		XTRest.start(LibrosController, 9000)
	}
	
}
```

Usage
=======

You need to add the following maven repository:

```xml
 <repositories>
        <repository>
            <id>uqbar-wiki.org-releases</id>
            <name>uqbar-wiki.org-releases</name>
            <url>http://uqbar-wiki.org/mvn/releases</url>
        </repository>
        <repository>
            <snapshots/>
            <id>uqbar-wiki.org-snapshots</id>
            <name>uqbar-wiki.org-snapshots</name>
            <url>http://uqbar-wiki.org/mvn/snapshots</url>
        </repository>
 </repositories>
```

And the this dependency:

```xml
 <dependency>
	<groupId>org.uqbar-project</groupId>
	<artifactId>xtrest</artifactId>
  	<version>0.0.1-SNAPSHOT</version>
 </dependency>
```


Documentation
=======

// TODO:
* HttpHandler
* Http Methods as annotations: Get, Delete
* URL Variables
* Parameters
* Results
* Directly using the request / response / session.
* Filters
* JSON

TODO
======

There's a list of things that are still not supported but we will implement shortly:
* Other http methods: Post, Put
* Filters
 
