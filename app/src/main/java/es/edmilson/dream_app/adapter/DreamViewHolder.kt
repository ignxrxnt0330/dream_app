package es.edmilson.dream_app.adapter

import androidx.recyclerview.widget.RecyclerView
import es.edmilson.dream_app.R
import android.view.View
import android.widget.TextView


class DreamViewHolder(val item: View, val listener: DreamListener)
: RecyclerView.ViewHolder(item) {
    val txtTitulo = item.findViewById<TextView>(R.id.txtTitulo)
    val txtFecha = item.findViewById<TextView>(R.id.txtFecha)
    val txtRating = item.findViewById<TextView>(R.id.txtRating)
    val txtTexto = item.findViewById<TextView>(R.id.txtTexto)
    init {
        item.setOnClickListener {
            listener.onDreamClick(itemId)
        }
    }

    /*TODO: terminar
    @SuppressLint("Range")
    fun bind(c: Cursor) {
        txtNombre.text = c.getString(c.getColumnIndex(DreamContract.NOMBRE))
        txtApellidos.text = c.getString(c.getColumnIndex(DreamContract.APELLIDOS))
    }

     */
}