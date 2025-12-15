package objects.particles;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

class SnowEmitter extends FlxTypedEmitter<FlxParticle> {
    public function new(X:Float, Y:Float, Size:Int) {
        super(X, Y, Size);
        width = FlxG.width+FlxG.width/2;
        launchMode = SQUARE;
        velocity.set(-80, 80, -5, 120);
        lifespan.set(0);
        for (i in 0...Math.ceil(Size / 4)) {
            var p:FlxParticle = new FlxParticle();
            p.makeGraphic(1, 1);
            add(p);
            var p:FlxParticle = new FlxParticle();
            p.makeGraphic(2, 2);
            add(p);
            var p:FlxParticle = new FlxParticle();
            p.makeGraphic(3, 3);
            add(p);
            var p:FlxParticle = new FlxParticle();
            p.makeGraphic(4, 4);
            add(p);
        }
    }
}