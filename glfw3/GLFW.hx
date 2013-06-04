package glfw3;

import #if cpp cpp #else neko #end.Lib;
import glfw3.Macros;

abstract Window(NativeBinding) to NativeBinding {
    @:allow(glfw3)
    function new(x:Dynamic) this = new NativeBinding(x);

    @:allow(glfw3)
    public static inline function cvt(x:Dynamic):Window return new Window(x);

    @:op(A==B) public static inline function eq(a:Window, b:Window):Bool return untyped a.nativeObject == b.nativeObject;
    @:op(A!=B) public static inline function ne(a:Window, b:Window):Bool return untyped a.nativeObject != b.nativeObject;
}

abstract Monitor(NativeBinding) to NativeBinding {
    @:allow(glfw3)
    function new(x:Dynamic) this = new NativeBinding(x);

    @:allow(glfw3)
    public static inline function cvt(x:Dynamic):Monitor return new Monitor(x);

    @:op(A==B) public static inline function eq(a:Monitor, b:Monitor):Bool return untyped a.nativeObject == b.nativeObject;
    @:op(A!=B) public static inline function ne(a:Monitor, b:Monitor):Bool return untyped a.nativeObject != b.nativeObject;
}

class GLFW implements GLProcs {
    @:allow(glfw3)
    static inline function load(n:String, p:Int):Dynamic
        return Lib.load("glfw3","hx_glfw_"+n, p);


    @:GLProc function setErrorCallback(cb:Null<Int->String->Void>):Void;

    public static inline var NOT_INITIALIZED      =0x00070001;
    public static inline var NO_CURRENT_CONTEXT   =0x00070002;
    public static inline var INVALID_ENUM         =0x00070003;
    public static inline var INVALID_VALUE        =0x00070004;
    public static inline var OUT_OF_MEMORY        =0x00070005;
    public static inline var API_UNAVAILABLE      =0x00070006;
    public static inline var VERSION_UNAVAILABLE  =0x00070007;
    public static inline var PLATFORM_ERROR       =0x00070008;
    public static inline var FORMAT_UNAVAILABLE   =0x00070009;

    @:GLProc function init():Void;
    @:GLProc function terminate():Void;

    @:GLProc function getMonitors():Array<Monitor> {
        var out:Array<Monitor> = [];
        load("getMonitors", 1)(out);
        return out;
    }
    @:GLProc function getPrimaryMonitor():Monitor;

    @:GLProc function makeContextCurrent(window:Window):Void;
    @:GLProc function getCurrentContext():Null<Window>;
    @:GLProc function swapBuffers(window:Window):Void;
    @:GLProc function swapInterval(interval:Int):Void;

    @:GLProc function createWindow(width:Int, height:Int, title:String, ?monitor:Null<Monitor>, ?share:Null<Window>):Window;
    @:GLProc function destroyWindow(window:Window):Void;

    public static inline var CONTEXT_REVISION       = 0x00020004;
    public static inline var RED_BITS               = 0x00021000;
    public static inline var GREEN_BITS             = 0x00021001;
    public static inline var BLUE_BITS              = 0x00021002;
    public static inline var ALPHA_BITS             = 0x00021003;
    public static inline var DEPTH_BITS             = 0x00021004;
    public static inline var STENCIL_BITS           = 0x00021005;
    public static inline var ACCUM_RED_BITS         = 0x00021006;
    public static inline var ACCUM_GREEN_BITS       = 0x00021007;
    public static inline var ACCUM_BLUE_BITS        = 0x00021008;
    public static inline var ACCUM_ALPHA_BITS       = 0x00021009;
    public static inline var AUX_BUFFERS            = 0x0002100A;
    public static inline var STEREO                 = 0x0002100B;
    public static inline var SAMPLES                = 0x0002100C;
    public static inline var SRGB_CAPABLE           = 0x0002100D;

    @:GLProc function defaultWindowHints():Void;
    @:GLProc function windowHint(target:Int, hint:Int):Void;

    public static inline var FOCUSED                = 0x00020001;
    public static inline var ICONIFIED              = 0x00020002;
    public static inline var RESIZABLE              = 0x00022007;
    public static inline var VISIBLE                = 0x00022008;
    public static inline var DECORATED              = 0x00022009;

    public static inline var CLIENT_API             = 0x00022000;
    public static inline var CONTEXT_VERSION_MAJOR  = 0x00022001;
    public static inline var CONTEXT_VERSION_MINOR  = 0x00022002;
    public static inline var CONTEXT_ROBUSTNESS     = 0x00022003;
    public static inline var OPENGL_FORWARD_COMPAT  = 0x00022004;
    public static inline var OPENGL_DEBUG_CONTEXT   = 0x00022005;
    public static inline var OPENGL_PROFILE         = 0x00022006;

    public static inline var OPENGL_API             = 0x00000001;
    public static inline var OPENGL_ES_API          = 0x00000002;

    public static inline var NO_ROBUSTNESS          = 0x00000000;
    public static inline var NO_RESET_NOTIFICATION  = 0x00000001;
    public static inline var LOSE_CONTEXT_ON_RESET  = 0x00000002;

    public static inline var OPENGL_NO_PROFILE      = 0x00000000;
    public static inline var OPENGL_CORE_PROFILE    = 0x00000001;
    public static inline var OPENGL_COMPAT_PROFILE  = 0x00000002;

    @:GLProc function getWindowParam(window:Window, param:Int):Int;

    @:GLProc function getWindowPos(window:Window):{x:Int, y:Int} {
        var vals = [0,0];
        load("getWindowPos", 2)(NativeBinding.native(window), vals);
        return {x:vals[0], y:vals[1]};
    }
    @:GLProc function getWindowSize(window:Window):{width:Int, height:Int} {
        var vals = [0,0];
        load("getWindowSize", 2)(NativeBinding.native(window), vals);
        return {width:vals[0], height:vals[1]};
    }
    @:GLProc function setWindowPos(window:Window, x:Int, y:Int):Void;
    @:GLProc function setWindowSize(window:Window, width:Int, height:Int):Void;
    @:GLProc function setWindowTitle(window:Window, title:String):Void;

    @:GLProc function hideWindow(window:Window):Void;
    @:GLProc function showWindow(window:Window):Void;
    @:GLProc function iconifyWindow(window:Window):Void;
    @:GLProc function restoreWindow(window:Window):Void;

    @:GLProc function windowShouldClose(window:Window):Bool;
    @:GLProc function setWindowShouldClose(window:Window, value:Bool):Void;

    @:GLProc function pollEvents():Void;
    @:GLProc function waitEvents():Void;

    static inline function wrap0(w:Window, cb:Null<Window->Void>):Null<Void->Void>
        return if (cb == null) null else function () cb(w);
    static inline function wrap1<A>(w:Window, cb:Null<Window->A->Void>):Null<A->Void>
        return if (cb == null) null else function (a:A) cb(w, a);
    static inline function wrap2<A,B>(w:Window, cb:Null<Window->A->B->Void>):Null<A->B->Void>
        return if (cb == null) null else function (a:A, b:B) cb(w, a, b);
    static inline function wrap3<A,B,C>(w:Window, cb:Null<Window->A->B->C->Void>):Null<A->B->C->Void>
        return if (cb == null) null else function (a:A, b:B, c:C) cb(w, a, b, c);

    @:GLProc function setWindowPosCallback(window:Window, cb:Null<Window->Int->Int->Void>):Void
        load("setWindowPosCallback", 2)(NativeBinding.native(window), wrap2(window, cb));
    @:GLProc function setWindowSizeCallback(window:Window, cb:Null<Window->Int->Int->Void>):Void
        load("setWindowSizeCallback", 2)(NativeBinding.native(window), wrap2(window, cb));
    @:GLProc function setWindowRefreshCallback(window:Window, cb:Null<Window->Void>):Void
        load("setWindowRefreshCallback", 2)(NativeBinding.native(window), wrap0(window, cb));
    @:GLProc function setWindowCloseCallback(window:Window, cb:Null<Window->Void>):Void
        load("setWindowCloseCallback", 2)(NativeBinding.native(window), wrap0(window, cb));
    @:GLProc function setWindowFocusCallback(window:Window, cb:Null<Window->Bool->Void>):Void
        load("setWindowFocusCallback", 2)(NativeBinding.native(window), wrap1(window, cb));
    @:GLProc function setWindowIconifyCallback(window:Window, cb:Null<Window->Bool->Void>):Void
        load("setWindowIconifyCallback", 2)(NativeBinding.native(window), wrap1(window, cb));


    // change in API, return true if GL_PRESS for key.
    @:GLProc function getKey(window:Window, key:Int):Bool;
    @:GLProc function getMouseButton(window:Window, button:Int):Bool;
    @:GLProc function getCursorPos(window:Window):{x:Float, y:Float} {
        var vals = [0.0,0.0];
        load("getCursorPos", 2)(NativeBinding.native(window), vals);
        return {x:vals[0], y:vals[1]};
    }
    @:GLProc function setCursorPos(window:Window, x:Float, y:Float):Void;

    @:GLProc function setKeyCallback(window:Window, cb:Null<Window->Int->Int->Int->Void>):Void
        load("setKeyCallback", 2)(NativeBinding.native(window), wrap3(window, cb));
    @:GLProc function setCharCallback(window:Window, cb:Null<Window->Int->Void>):Void
        load("setCharCallback", 2)(NativeBinding.native(window), wrap1(window, cb));
    @:GLProc function setMouseButtonCallback(window:Window, cb:Null<Window->Int->Bool->Int->Void>):Void
        load("setMouseButtonCallback", 2)(NativeBinding.native(window), wrap3(window, cb));
    @:GLProc function setScrollCallback(window:Window, cb:Null<Window->Float->Float->Void>):Void
        load("setScrollCallback", 2)(NativeBinding.native(window), wrap2(window, cb));
    @:GLProc function setCursorPosCallback(window:Window, cb:Null<Window->Float->Float->Void>):Void
        load("setCursorPosCallback", 2)(NativeBinding.native(window), wrap2(window, cb));
    @:GLProc function setCursorEnterCallback(window:Window, cb:Null<Window->Bool->Void>):Void
        load("setCursorEnterCallback", 2)(NativeBinding.native(window), wrap1(window, cb));

    @:GLProc function getTime():Float;
    @:GLProc function setTime(time:Float):Void;

    public static inline var RELEASE = 0;
    public static inline var PRESS   = 1;
    public static inline var REPEAT  = 2;

    public static inline var SPACE         = 32;
    public static inline var APOSTROPHE    = 39;
    public static inline var COMMA         = 44;
    public static inline var MINUS         = 45;
    public static inline var PERIOD        = 46;
    public static inline var SLASH         = 47;
    public static inline var ZERO          = 48;
    public static inline var ONE           = 49;
    public static inline var TW0           = 50;
    public static inline var THREE         = 51;
    public static inline var FOUR          = 52;
    public static inline var FIVE          = 53;
    public static inline var SIX           = 54;
    public static inline var SEVEN         = 55;
    public static inline var EIGHT         = 56;
    public static inline var NINE          = 57;
    public static inline var SEMICOLON     = 59;
    public static inline var EQUALS        = 61;
    public static inline var A             = 65;
    public static inline var B             = 66;
    public static inline var C             = 67;
    public static inline var D             = 68;
    public static inline var E             = 69;
    public static inline var F             = 70;
    public static inline var G             = 71;
    public static inline var H             = 72;
    public static inline var I             = 73;
    public static inline var J             = 74;
    public static inline var K             = 75;
    public static inline var L             = 76;
    public static inline var M             = 77;
    public static inline var N             = 78;
    public static inline var O             = 79;
    public static inline var P             = 80;
    public static inline var Q             = 81;
    public static inline var R             = 82;
    public static inline var S             = 83;
    public static inline var T             = 84;
    public static inline var U             = 85;
    public static inline var V             = 86;
    public static inline var W             = 87;
    public static inline var X             = 88;
    public static inline var Y             = 89;
    public static inline var Z             = 90;
    public static inline var LEFT_BRACKET  = 91;
    public static inline var BACKSLASH     = 92;
    public static inline var RIGHT_BRACKET = 93;
    public static inline var GRAVE         = 96;
    public static inline var WORLD_1       = 161;
    public static inline var WORLD_2       = 162;
    public static inline var ESCAPE        = 256;
    public static inline var ENTER         = 257;
    public static inline var TAB           = 258;
    public static inline var BACKSPACE     = 259;
    public static inline var INSERT        = 260;
    public static inline var DELETE        = 261;
    public static inline var RIGHT         = 262;
    public static inline var LEFT          = 263;
    public static inline var DOWN          = 264;
    public static inline var UP            = 265;
    public static inline var PAGE_UP       = 266;
    public static inline var PAGE_DOWN     = 267;
    public static inline var HOME          = 268;
    public static inline var END           = 269;
    public static inline var CAPS_LOCK     = 280;
    public static inline var SCROLL_LOCK   = 281;
    public static inline var NUM_LOCK      = 282;
    public static inline var PRINT_SCREEN  = 283;
    public static inline var PAUSE         = 284;
    public static inline var F1            = 290;
    public static inline var F2            = 291;
    public static inline var F3            = 292;
    public static inline var F4            = 293;
    public static inline var F5            = 294;
    public static inline var F6            = 295;
    public static inline var F7            = 296;
    public static inline var F8            = 297;
    public static inline var F9            = 298;
    public static inline var F10           = 299;
    public static inline var F11           = 300;
    public static inline var F12           = 301;
    public static inline var F13           = 302;
    public static inline var F14           = 303;
    public static inline var F15           = 304;
    public static inline var F16           = 305;
    public static inline var F17           = 306;
    public static inline var F18           = 307;
    public static inline var F19           = 308;
    public static inline var F20           = 309;
    public static inline var F21           = 310;
    public static inline var F22           = 311;
    public static inline var F23           = 312;
    public static inline var F24           = 313;
    public static inline var F25           = 314;
    public static inline var KP_0          = 320;
    public static inline var KP_1          = 321;
    public static inline var KP_2          = 322;
    public static inline var KP_3          = 323;
    public static inline var KP_4          = 324;
    public static inline var KP_5          = 325;
    public static inline var KP_6          = 326;
    public static inline var KP_7          = 327;
    public static inline var KP_8          = 328;
    public static inline var KP_9          = 329;
    public static inline var KP_DECIMAL    = 330;
    public static inline var KP_DIVIDE     = 331;
    public static inline var KP_MULTIPLY   = 332;
    public static inline var KP_SUBTRACT   = 333;
    public static inline var KP_ADD        = 334;
    public static inline var KP_ENTER      = 335;
    public static inline var KP_EQUALS     = 336;
    public static inline var LEFT_SHIFT    = 340;
    public static inline var LEFT_CONTROL  = 341;
    public static inline var LEFT_ALT      = 342;
    public static inline var LEFT_SUPER    = 343;
    public static inline var RIGHT_SHIFT   = 344;
    public static inline var RIGHT_CONTROL = 345;
    public static inline var RIGHT_ALT     = 346;
    public static inline var RIGHT_SUPER   = 347;
    public static inline var MENU          = 348;

    public static inline var MOUSE_BUTTON_1       = 0;
    public static inline var MOUSE_BUTTON_2       = 1;
    public static inline var MOUSE_BUTTON_3       = 2;
    public static inline var MOUSE_BUTTON_4       = 3;
    public static inline var MOUSE_BUTTON_5       = 4;
    public static inline var MOUSE_BUTTON_6       = 5;
    public static inline var MOUSE_BUTTON_7       = 6;
    public static inline var MOUSE_BUTTON_8       = 7;
    public static inline var MOUSE_BUTTON_LAST    = MOUSE_BUTTON_8;
    public static inline var MOUSE_BUTTON_LEFT    = MOUSE_BUTTON_1;
    public static inline var MOUSE_BUTTON_RIGHT   = MOUSE_BUTTON_2;
    public static inline var MOUSE_BUTTON_MIDDLE  = MOUSE_BUTTON_3;

    public static inline var MOD_SHIFT    = 0x0001;
    public static inline var MOD_CONTROL  = 0x0002;
    public static inline var MOD_ALT      = 0x0004;
    public static inline var MOD_SUPER    = 0x0008;

}
