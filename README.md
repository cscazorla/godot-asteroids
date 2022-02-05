# Intro
Implementation of the classic Asteroids videogame using [Godot Engine](https://godotengine.org/) and [Kenny Space Shooter Redux](https://kenney.nl/assets/space-shooter-redux) resource assets pack. The goal of the game is to destroy as many asteroids as possible without crashing into an asteroid.

![Game](screenshots/main_game.png)

# Features
* Proper physics models dealing with gravity, acceleration, angular drag, thrust direction, colliders, etc. 
* Basic SFX (e.g. camera shaking when crashing into an asteroid)
* Power ups (e.g. health)

# Usage
You can play this game [here](https://asteroids.cscazorla.es/) or just download the files and open [index.html](html/index.html) in your browser.

# To do
* There is a bug with the health bar. When player's life is bigger than 100 points, it resets to zero.
* The amount of life reduced when crashed into an asteroid should depend on the player's velociy magnitude of the collision.
* When crashed into an asteroid the player should bounce back.
* Add a menu or welcome message with instructions.
* Pause the game when pressing "P"
* Currently when the player shots an asteroids it splits into 2 asteroids with the same size as the original asteroid:
  * They should be smaller.
  * The direction of the bullet hitting the asteroid should be taken into account when calculating the new direction of the asteroids
* Add new power ups: shield, teletransport, bomb.
* Add music & sounds.
* Add a dynamic background.

# License
Released under the [MIT License](http://www.opensource.org/licenses/mit-license.php).