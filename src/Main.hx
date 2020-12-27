import haxe.Json;
import h2d.Bitmap;
import hxd.Res;
import hxd.Window;
import utils.*;
import h2d.Font;
import ecs.*;
import level.*;

typedef TiledJson = {
    var width: Int;
    var height: Int;
    var tileheight: Int;
    var tilewidth: Int;
    var layers: Array<{ data: Array<Int> }>;
}

class Main extends hxd.App {
    public var paused : Bool = false;
    public static var UpdateList = new List<GameObject>();

    static function main() {
        new Main();
    }

    override function init() {
        hxd.Res.initEmbed();
        Window.getInstance().addEventTarget(OnEvent);

        // Render title screen (temp)
        var font : Font = hxd.res.DefaultFont.get();
        var tf = new h2d.Text(font);
        tf.text = "Testing";
        s2d.addChild(tf);

        
        // Parse Tiled json map
        var json = Json.parse(Res.mymap.entry.getText());
        var map : TiledJson = json;
        var th = map.tileheight;
        var tw = map.tilewidth;


       // Select tileset
       var t = Res.tileset.toTile();

        // Split tileset in tiles
        var tileset = [
            for (y in 0...Std.int(t.height/th))
                for (x in 0 ...Std.int(t.width/tw))
                    t.sub(x * tw, y * th, tw, th)
        ];


        // Render layers
        var layerNumber = 0;

        for (layer in map.layers) {
            var i : Int = 0;
            for (tile in layer.data) {
                // Skip unused tiles
                if (tile==0) {
                    i++;
                    continue;
                }
                // Render tiles
                else {
                    var bmp : Bitmap = new Bitmap(tileset[tile - 1]);
                    bmp.setPosition(Std.int(i % map.width) * tw, Std.int(i / map.height) * th);
                    s2d.addChild(bmp);
                    i++;
                }
            }

            // Next layer
            layerNumber++;
        }
    }

    override function update(dt:Float) {
        for(gameObject in UpdateList){
            gameObject.update(dt);
        }
        ColliderSystem.CheckCollide();
    }
    
    public function OnEvent(event : hxd.Event){
        switch(event.kind) {
            case EMove: MouseMoveEvent(event);
            case EPush: MouseClickEvent(event);
            case _:
        }
    }
    public function MouseMoveEvent(event : hxd.Event){
        //event.relX, event.relY
    }
    
    public function MouseClickEvent(event : hxd.Event){
        
    }
}