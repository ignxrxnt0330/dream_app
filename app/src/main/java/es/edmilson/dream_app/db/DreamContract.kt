package es.edmilson.dream_app.db

import android.provider.BaseColumns

object DreamContract: BaseColumns {
    const val TABLE_NAME = "dreams"
    const val _ID = BaseColumns._ID
    const val TITULO = "titulo"
    const val TEXTO = "texto"
    const val FECHA = "fecha"
    const val TAGS = "tags"
    const val PERSONAS = "personas"
    const val RATING = "rating"
}