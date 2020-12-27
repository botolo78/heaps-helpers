import haxe.Json;
import h2d.Bitmap;
import hxd.Res;
import hxd.Window;
import utils.*;
import h2d.Font;
import ecs.*;
import level.*;

class Main extends hxd.App {
    public var paused : Bool = false;
    public static var UpdateList = new List<GameObject>();

    static function main() {
        new Main();
    }

    override function init() {
        hxd.Res.initEmbed();
        Window.getInstance().addEventTarget(OnEvent);

        var font : Font = hxd.res.DefaultFont.get();
        var tf = new h2d.Text(font);
        tf.text = "Testing";
        s2d.addChild(tf);

        var map : { layers: Array<{ data: Array<Int> }> } = Json.parse(Res.mymap.entry.getText());

        var t = Res.tileset.toTile();
        var th = 32;
        var tw = 32;

        var tileset = [
            for (y in 0...Std.int(t.height/th))
                for (x in 0 ...Std.int(t.width/tw))
                    t.sub(x * tw, y * th, tw, th)

        ];
        
        var layerNumber = 0;

        for (layer in map.layers) {
            var i : Int = 0;
            for (tile in layer.data) {
                if (tile==0) {
                    i++;
                    continue;
                }
                else {
                    var bmp : Bitmap = new Bitmap(tileset[tile - 1]);
                    bmp.setPosition(Std.int(i % 20) * tw, Std.int(i / 20) * th);
                    s2d.addChild(bmp);
                    i++;
                }
            }

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