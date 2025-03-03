package fr.mines_douai.tp_jeu;

import android.animation.ObjectAnimator;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Random;

public class MainActivity extends AppCompatActivity {
    private FrameLayout gameLayout;
    private Handler handler = new Handler();
    private Random random = new Random();

    // Images d'asteroïdes
    private int[] asteroidImages = {
            R.drawable.asteroid1,
            R.drawable.asteroid2,
            R.drawable.asteroid3,
            R.drawable.asteroid4
    };

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        gameLayout = findViewById(R.id.gameLayout);

        startAsteroidSpawner();
    }

    private void startAsteroidSpawner(){
        handler.postDelayed(new Runnable() {
            @Override
            public void run(){
                spawnAsteroid();
                handler.postDelayed(this, 1000); // Toutes les secondes
            }
        }, 1000);
    }

    private void spawnAsteroid(){
        Log.d("DEBUG", "Astéroïde créé !");
        // Création d'un asteroïde
        ImageView asteroid = new ImageView(this);
        asteroid.setImageResource(asteroidImages[random.nextInt(asteroidImages.length)]);
        if (asteroid.getDrawable() == null) {
            Log.e("ERROR", "Image non trouvée !");
        }

        // Définition de la taille de l'astéroïde
        int size = random.nextInt(100) + 50;
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(size, size);

        // Définition de la position de X en aléatoire
        int startX = random.nextInt(gameLayout.getWidth() - size);
        params.leftMargin = startX;
        params.topMargin = -size;
        asteroid.setLayoutParams(params);
        Log.d("DEBUG", "Position X : " + startX);

        // Ajouter l'astéroïde au layout
        gameLayout.addView(asteroid);

        // Lancer la descente
        ObjectAnimator animator = ObjectAnimator.ofFloat(asteroid, "translationY", gameLayout.getHeight());
        animator.setDuration(3000); // temps de descente
        animator.start();

        // Supprimer l'astéroïde après l'animation
        animator.addListener(new android.animation.AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(android.animation.Animator animation) {
                gameLayout.removeView(asteroid);
            }
        });
    }
}