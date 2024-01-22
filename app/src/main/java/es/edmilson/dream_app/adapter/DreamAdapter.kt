package es.edmilson.dream_app.adapter

import android.database.Cursor
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import es.edmilson.dream_app.R

class DreamAdapter(var cursor: Cursor, val listener: DreamListener)
: RecyclerView.Adapter<DreamViewHolder<Any?>>() {
    interface DreamListener {
        fun onDreamClick(id: Long)
    }
    init {
        setHasStableIds(true)
    }
    override fun onCreateViewHolder(parent: ViewGroup, type: Int): DreamViewHolder<Any?> {
        val item = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_dream, parent, false)
        return DreamViewHolder(item, listener)
    }
    override fun onBindViewHolder(holder: DreamViewHolder<Any?>, position: Int) {
        cursor.moveToPosition(position)
        holder.bind(cursor)
    }
    fun changeCursor(c: Cursor) {
        this.cursor.close() // Cierra el cursor viejo
        this.cursor = c
        notifyDataSetChanged()
    }

    /*TODO: terminar
    @SuppressLint("Range")
    override fun getItemId(position: Int): Long {
        cursor.moveToPosition(position)
        return cursor.getLong(cursor.getColumnIndex(PersonaContract._ID))
    }
    */

    override fun getItemCount(): Int {
        return cursor.count
    }
}