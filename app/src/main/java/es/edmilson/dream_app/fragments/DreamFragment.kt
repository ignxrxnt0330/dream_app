package es.edmilson.dream_app.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import es.edmilson.dream_app.R
class DreamFragment(idItem: Long) : DialogFragment() {
    //TODO: hacer un método que haga fetch de la bd y muestre todo
     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_dream, container, false)
    }

}