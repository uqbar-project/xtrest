[![Build Status](https://travis-ci.org/uqbar-project/xtrest.svg?branch=master)](https://travis-ci.org/uqbar-project/xtrest)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.uqbar/xtrest/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.uqbar/xtrest/)

# xtrest

XTend Rest Mini-Framework: create REST HTTP JSON API's with the power of [Xtend language](http://www.eclipse.org/xtend/).

It's based on Sven Efftinge's jettyxtension (https://github.com/svenefftinge/jettyxtension). But it extends
it in order to fully support all HTTP methods.

Originally it was designed in order to create just REST API's, but eventually it could evolve into a full MVC
"action-based" web frameworks, once template engines are included.

I will then get similar to [Padrino](http://www.padrinorb.com), [Sinatra](http://www.sinatrarb.com), [Play2](https://www.playframework.com), etc.

# REST JSON API Example

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
		XTRest.start(9000, LibrosController)
	}
	
}
```

To test it:

```bash
curl http://localhost:9000/libros
```

Should give you an output like the following:

```json
[
 {
	"id": 0,
	"titulo" : "Las venas abiertas de America Latina",
	"autor": "Eduardo Galeano"
 },
 {
 	"id":1,
 	"titulo" : "Guerra y Paz",
 	"autor":"Leon Tolstoi"}
 ,
 ...
]
```

## Multiple controllers

Since 1.0.0 version you can add define several controllers and use it when starting jetty server:

```xtend
class App {
	
	def static void main(String[] args) {
		XTRest.start(9000, TareasController, UsuariosController, AnyOtherController)
	}
	
}
```


# Sample Webapp with server-side templating

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
		XTRest.start(9000, ConversorController)
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


# Usage

You need to add the following maven dependency:

```xml
 <dependency>
	<groupId>org.uqbar</groupId>
	<artifactId>xtrest</artifactId>
  	<version>1.0.0</version>
 </dependency>
```

# What's new

You can see here a list of [issues fixed in 1.0.0 version](https://github.com/uqbar-project/xtrest/milestone/1) (released in August 2017)

- Now XTRest server supports a list of controllers (as many as you want)

- Controllers are validated: they should have an empty constructor

- JsonIgnoreProperties is no longer required for classes when serializing from JSON

- New conversion from JSON to a map, and also new conversion methods for integers, decimals and dates  

- Services with JSON responses are prettyfied

- Enhanced and internationalized html page when a service is not found

- Internationalization of error messages

- You can configure where is your application client located (eg: "src/main/webapp" or "src/main/resources")
	

# Documentation

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

# TODO

There's a list of things that are still not supported but we will implement soon:

* Filters
* Variable type conversions (only string supported. Also as it's not explicitely declared as a method param, there no place to declare the type. Proposed solution
"/libros/:(id|int)"
* Default values for parameters / variables 

