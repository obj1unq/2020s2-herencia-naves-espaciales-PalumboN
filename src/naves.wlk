// Método Lookup -> Algoritmo que define qué método de ejecuta ante un mensaje
// 1) Busco el método en el objeto, si no lo encuentro
// 2) Busco el método en la clase de la cual se instanció, si no lo encuentro
// 3) Busco en su superclase inmediata (repetir hasta el final)
// -  Si no lo encuentra, tira error de "El objeto no entiende el mensaje"
class Nave {
	
	var property velocidad = 0
	
	method propulsar() {
		self.aumentarVelocidad(20000)
	}
	
	method prepararseParaViajar() {
		self.aumentarVelocidad(15000)		
	}
	
	method aumentarVelocidad(aumento) {
		velocidad = (velocidad + aumento).min(300000)		
	}
	
	// Template method
	// Lógica común para todas las subclases
	// Una parte de esa lógica es específica (no hay comportamiento común)
	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method recibirAmenaza() // No tiene cuerpo, es ABSTRACTO
}

// La subclase (NaveDeCarga) hereda todo el comportamiento (métodos y atributos) 
// definidos en la superclase (Nave)
// Esto implica que los objetos instanciados a partir de esta clase tendran el comportamiento 
// definido por la jerarquía (la clase de la cual se instancia y todas las superclases de ella) 
class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
}

class NaveDeResiduos inherits NaveDeCarga {
	var property selladoAlVacio = false
	
	override method recibirAmenaza() {
		velocidad = 0
	}
	
	override method prepararseParaViajar() {
		super() // hacer lo que hace el método sobreescrito (el de la superclase)
		selladoAlVacio = true
	}
}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
		
	override method prepararseParaViajar() {
		super() // hacer lo que hace el método sobreescrito (el de la superclase)
		modo.preparar(self)
	}

}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	
	method preparar(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	method preparar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}

}

