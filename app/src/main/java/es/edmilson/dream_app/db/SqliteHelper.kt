package es.edmilson.dream_app.db

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import es.edmilson.dream_app.Dream

class SqliteHelper(context: Context)
    : SQLiteOpenHelper(context, NAME, null, VERSION) {
    companion object {
        private const val NAME = "dreams.db"
        private const val VERSION = 1
    }

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL(
            "CREATE TABLE " + DreamContract.TABLE_NAME + " (" +
                    DreamContract._ID + " INTEGER PRIMARY KEY, " +
                    DreamContract.TITULO + " TEXT NOT NULL, " +
                    DreamContract.TEXTO + " TEXT NOT NULL, " +
                    DreamContract.FECHA + " TEXT NOT NULL, " +// la fecha como string porque sqlite no soporta date
                    DreamContract.TAGS + " TEXT , " +
                    DreamContract.PERSONAS + " TEXT , " +
                    DreamContract.RATING + " INTEGER );"
        )
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        TODO("Not yet implemented")
    }

    fun insertDream(dream: Dream): Boolean{
        val db = writableDatabase
        val values = ContentValues()
        values.put(DreamContract.TITULO,dream.titulo)

        val id = db.insert(DreamContract.TABLE_NAME,null,values)
        if(id<0){
            return false
        }
        dream.id=id
        return true
    }

    fun getDreams(): List<Dream>{
        val db = readableDatabase
        val c = db.query(
            DreamContract.TABLE_NAME,
            null, // Lista de columnas
            null, // WHERE
            null, // Parámetros WHERE
            null, // GROUP BY
            null, // HAVING
            null // ORDER BY
        )
        while (c.moveToNext()) {
            val titulo = c.getString(c.getColumnIndex(DreamContract.TITULO))

        }

    }

}