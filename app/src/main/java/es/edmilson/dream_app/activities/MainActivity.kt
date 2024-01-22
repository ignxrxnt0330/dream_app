package es.edmilson.dream_app.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.floatingactionbutton.FloatingActionButton
import es.edmilson.dream_app.fragments.HomeFragment
import es.edmilson.dream_app.fragments.SearchFragment
import es.edmilson.dream_app.fragments.StatsFragment
import es.edmilson.dream_app.R

class MainActivity : AppCompatActivity() {
    lateinit var bottomNavView: BottomNavigationView
    lateinit var fab: FloatingActionButton
    lateinit var frame_layout: FrameLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        frame_layout = findViewById(R.id.frame_layout)

        cambiaFragment(HomeFragment())//    hace que cuando se abra la app el fragment sea el del home
        bottomNavView = findViewById(R.id.bottomNavigationView)
        bottomNavView.setOnItemSelectedListener{menuItem ->
            when(menuItem.itemId){
                R.id.home -> {
                var fragment = HomeFragment()
                    cambiaFragment(fragment)
                true
                }
                R.id.search -> {
                var fragment = SearchFragment()
                    cambiaFragment(fragment)
                true
                }
                R.id.stats -> {
                var fragment = StatsFragment()
                    cambiaFragment(fragment)
                true
                }
                else->false
            }
        }
        fab = findViewById(R.id.fab)
        fab.setOnClickListener {
            val intent = Intent(this, DreamForm::class.java)
            startActivity(intent)
        }
    }

    override fun onResume() {
        super.onResume()
        //  la clase supportFragmentManager tiene métodos que permiten ver el fragment actual del frame_layout
        when(supportFragmentManager.findFragmentById(R.id.frame_layout)){ //  comprueba el id del fragment que está mostrando el frame_layout
            //  findFragmentById devuelve un fragment, asi que creamos una instancia de cada uno en el switch para compararlos
            HomeFragment() -> {
                //  TODO: actualizar spinner / recyclerview
            }
            SearchFragment() -> {
                // TODO:   actualizar resultados
            }
            StatsFragment() -> {
                //  TODO: actualizar stats
            }
        }
    }

    fun cambiaFragment(fragment: Fragment){
        val transaction = supportFragmentManager.beginTransaction()     // comienza la transaccion
        transaction.replace(R.id.frame_layout, fragment)  // cambia el fragment actual por el que se le pasa
        transaction.commit()    // guarda los cambios
    }
}