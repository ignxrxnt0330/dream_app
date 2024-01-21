package es.edmilson.dream_app

import java.time.LocalDate

class Dream(titulo: String, texto: String, fecha: LocalDate) {
    var id: Long = 0L
    var titulo: String = ""
    var texto: String = ""
    var fecha: LocalDate = LocalDate.now()
    var tags: MutableList<String>? = null
    var personas: MutableList<String>? = null
    var rating: Int? = 0
}