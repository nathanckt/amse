package fr.mines_douai.tp_jeu;

import android.animation.ObjectAnimator;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Random;

public class MainActivity extends AppCompatActivity {
    private FrameLayout gameLayout;
    private Handler handler = new Handler();
    private Random random = new Random();

    private int[] asteroidImages = {
            R.drawable.asteroid1,
            R.drawable.asteroid2,
            R.drawable.asteroid3,
            R.drawable.asteroid4
    };

    private ImageView spaceship;
    private ImageView joystick;
    private float joystickInputX = 0;
    private float joystickInputY = 0;
    private float spaceshipX;
    private float spaceshipY;
    private float speed = 10;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        gameLayout = findViewById(R.id.gameLayout);
        spaceship = findViewById(R.id.spaceship);
        joystick = findViewById(R.id.joystick);

        spaceshipX = spaceship.getX();
        spaceshipY = spaceship.getY();

        joystick.setOnTouchListener((v, event) -> {
            float centerX = joystick.getWidth() / 2f;
            float centerY = joystick.getHeight() / 2f;
            float touchX = event.getX();
            float touchY = event.getY();

            joystickInputX = (touchX - centerX) / centerX;
            joystickInputY = (touchY - centerY) / centerY;

            joystickInputX = Math.max(-1, Math.min(1, joystickInputX));
            joystickInputY = Math.max(-1, Math.min(1, joystickInputY));

            if (event.getAction() == MotionEvent.ACTION_UP) {
                joystickInputX = 0;
                joystickInputY = 0;
                v.performClick();
            }
            return true;
        });

        startGameLoop();
        startAsteroidSpawner();
    }

    private void startGameLoop() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                updateSpaceshipPosition();
                checkCollisions();
                handler.postDelayed(this, 16);
            }
        }, 16);
    }

    private void updateSpaceshipPosition() {
        spaceshipX += joystickInputX * speed;
        spaceshipY += joystickInputY * speed;

        spaceshipX = Math.max(0, Math.min(gameLayout.getWidth() - spaceship.getWidth(), spaceshipX));
        spaceshipY = Math.max(0, Math.min(gameLayout.getHeight() - spaceship.getHeight(), spaceshipY));

        spaceship.setX(spaceshipX);
        spaceship.setY(spaceshipY);
    }

    private void startAsteroidSpawner() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                spawnAsteroid();
                handler.postDelayed(this, 1000);
            }
        }, 1000);
    }

    private void spawnAsteroid() {
        ImageView asteroid = new ImageView(this);
        asteroid.setImageResource(asteroidImages[random.nextInt(asteroidImages.length)]);
        int size = random.nextInt(100) + 50;
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(size, size);
        int startX = random.nextInt(gameLayout.getWidth() - size);
        params.leftMargin = startX;
        params.topMargin = -size;
        asteroid.setLayoutParams(params);
        gameLayout.addView(asteroid);

        ObjectAnimator animator = ObjectAnimator.ofFloat(asteroid, "translationY", gameLayout.getHeight());
        animator.setDuration(3000);
        animator.start();

        animator.addListener(new android.animation.AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(android.animation.Animator animation) {
                gameLayout.removeView(asteroid);
            }
        });
    }

    private void checkCollisions() {
        for (int i = 0; i < gameLayout.getChildCount(); i++) {
            View view = gameLayout.getChildAt(i);
            if (view instanceof ImageView && view != spaceship) {
                if (checkCollision((ImageView) view)) {
                    Log.d("Collision", "Collision détectée !");
                }
            }
        }
    }

    private boolean checkCollision(ImageView asteroid) {
        Rect spaceshipRect = new Rect((int) spaceship.getX(), (int) spaceship.getY(),
                (int) (spaceship.getX() + spaceship.getWidth()),
                (int) (spaceship.getY() + spaceship.getHeight()));
        Rect asteroidRect = new Rect((int) asteroid.getX(), (int) asteroid.getY(),
                (int) (asteroid.getX() + asteroid.getWidth()),
                (int) (asteroid.getY() + asteroid.getHeight()));

        return spaceshipRect.intersect(asteroidRect);
    }
}
