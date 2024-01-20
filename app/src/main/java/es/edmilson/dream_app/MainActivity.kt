package es.edmilson.dream_app

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {
    lateinit var bottomNavView: BottomNavigationView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        cambiaFragment(HomeFragment())
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
    }

    fun cambiaFragment(fragment: Fragment){
        val transaction = supportFragmentManager.beginTransaction()     // comienza la transaccion
        transaction.replace(R.id.frame_layout, fragment)  // cambia el fragment actual por el que se le pasa
        transaction.commit()    // guarda los cambios
    }
}