package glfw3;

class NativeBinding {
    @:allow(glfw3)
    var nativeObject:Dynamic;

    @:allow(glfw3)
    function new(x:Dynamic) {
        nativeObject = x;
    }

    @:allow(glfw3)
    inline static function generic(x:Null<Dynamic>):Null<NativeBinding> {
        return if (x == null) null else new NativeBinding(x);
    }

    @:allow(glfw3)
    static inline function native(object:Null<NativeBinding>):Null<Dynamic> {
        return if (object == null) null else object.nativeObject;
    }

    @:allow(glfw3)
    static inline function mapNative<T:NativeBinding>(objects:Null<Array<Null<T>>>):Null<Array<Null<Dynamic>>> {
        if (objects == null) return null;
        else {
            var ret = [];
            for (o in objects) ret.push(native(o));
            return ret;
        }
    }
}
