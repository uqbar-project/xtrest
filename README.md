[![Build Status](https://travis-ci.org/uqbar-project/xtrest.svg?branch=master)](https://travis-ci.org/uqbar-project/xtrest)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.uqbar/xtrest/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.uqbar/xtrest/)

xtrest
======

XTend Rest Mini-Framework: create REST HTTP JSON API's with the power of [Xtend language](http://www.eclipse.org/xtend/).

It's based on Sven Efftinge's jettyxtension (https://github.com/svenefftinge/jettyxtension). But it extends
it in order to fully support all HTTP methods.

Originally it was designed in order to create just REST API's, but eventually it could evolve into a full MVC
"action-based" web frameworks, once template engines are included.
I will then get similar to [Padrino](http://www.padrinorb.com), [Sinatra](http://www.sinatrarb.com), [Play2](https://www.playframework.com), etc.

REST JSON API Example
======

The following example controller implements a REST JSON webservice for books.

```xtend
/**
 * Ejemplo de controller REST/JSON en xtrest
 * 
 * @author jfernandes
 */
@Controller
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

To test it:

```bash
curl http://localhost:9000/libros
```

Should give you the following output:

```javascript
[{"id":0,"titulo":"Las venas abiertas de Am?rica Latina","autor":"Eduardo Galeano"},{"id":1,"titulo":"Guerra y Paz","autor":"Le?n Tolstoi"},{"id":2,"titulo":"Patas Arriba","autor":"Eduardo Galeano"},{"id":3,"titulo":"El f?tbol a sol y a sombra","autor":"Eduardo Galeano"},{"id":4,"titulo":"Historia del siglo XX","autor":"Eric Hobsbawm"},{"id":5,"titulo":"Ficciones","autor":"Jorge Luis Borges"},{"id":6,"titulo":"El Aleph","autor":"Jorge Luis Borges"},{"id":7,"titulo":"La invenci?n de Morel","autor":"Adolfo Bioy Casares"},{"id":8,"titulo":"Rayuela","autor":"Julio Cort?zar"},{"id":9,"titulo":"El bar?n rampante","autor":"Italo Calvino"},{"id":10,"titulo":"El vizconde demediado","autor":"Italo Calvino"},{"id":11,"titulo":"100 a?os de soledad","autor":"Gabriel Garc?a M?rquez"},{"id":12,"titulo":"Un d?a en la vida de Ivan Denisovich","autor":"Alexander Solyenitsin"},{"id":13,"titulo":"El d?a del arquero","autor":"Juan Sasturain"}]
```

Sample Webapp with server-side templating
=======

This example shows that xtrest can even be used for whole MVC "server-centered" apps, where
the server generates HTML using [JMustache](https://github.com/samskivert/jmustache) templating engine

```xtend
@Controller
class ConversorController {
	
	@Get("/conversor")
	def index() {
		val data = #{
			"millas" -> "0",
			"kilometros" -> "<< introducir millas >>"
		}
		
		render('conversor.html', data)
	}
	
	@Get("/convertir")
	def convertir(String millas) {
		render('conversor.html', #{
			"millas" -> millas,
			"kilometros" -> Integer.valueOf(millas) * 1.609344
		})
	}
	
	def static void main(String[] args) {
		XTRest.start(ConversorController, 9000)
	}
	
}
```

And then the template:

```html
<html>
<body>
<h2>Convertir</h2>
<form action="/convertir" method="get">
	<fieldset>
			<label for="titulo">Millas</label> 
			<input 
				required="true"
				name="millas" class="form-control" 
				placeholder="23"
				autofocus="autofocus" value="{{millas}}">

			<label for="kilometros">Kilometros</label>
			<p class="lead">{{kilometros}}</p>

		<button type="submit" class="btn btn-primary">Convertir</button>
	</fieldset>
</form>
```


Usage
=======

You need to add the following maven dependency:

```xml
 <dependency>
	<groupId>org.uqbar</groupId>
	<artifactId>xtrest</artifactId>
  	<version>0.1.4</version>
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
* View: Templating
* @Body parameter
* notfound page

TODO
======

There's a list of things that are still not supported but we will implement shortly:
* Filters
* Parameters type conversions (only strings supported right now)
* Variable type conversions (only string supported. Also as it's not explicitely declared as a method param, there no place to declare the type. Proposed solution
"/libros/:(id|int)"
* Handler logic to respond with a pretty HTML including the list of supported methods and URLs whenever you don't hit any. (like play2 does https://www.playframework.com/documentation/2.0/JavaRouting)
* Default values for parameters / variables 

 
