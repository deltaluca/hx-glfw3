Haxe-c++ bindings for GLFW 3.0 (https://github.com/deltaluca/glfw) [stable-fork]

The library is not 100% bound, with support listed below together with any slight API changes for Haxe.

Pull requests happily taken!

Dependencies
--

* glfw 3.0 built as shared library.
* haxe 3.x
* hxcpp

GLFW 3.0
--

C *#define* constants are found as static Int's of ```GLFW```.

eg: ```GLFW_RED_BITS``` -> ```GLFW.RED_BITS : Int```

##### Clipboard Support
* ~~```glfwSetClipboardString```~~
* ~~```glfwGetClipboardString```~~

(Consider waneck/systools for clipboard support and more)

##### Context Handling
* ```GLFW.makeContextCurrent : Window -> Void```
* ```GLFW.getCurrentContext : Void -> Window```
* ```GLFW.swapBuffers : Window -> Void```
* ```GLFW.swapInterval : Int -> Void```
* ~~```glfwExtensionSupported```~~
* ~~```glfwGetProcAddress```~~

##### Error Handing
* ```GLFW.setErrorCallback : Null<Int -> String -> Void> -> Void```

##### Gamma Ramp Support
* ~~```glfwSetGamma```~~
* ~~```glfwGetGammaRamp```~~
* ~~```glfwSetGammaRamp```~~

##### Initialisation and Version Information
* ```GLFW.init : Void->Void```
* ```GLFW.terminate : Void->Void```
* ~~```glfwGetVersion```~~
* ~~```glfwGetVersionString```~~

##### Input Handling
* ~~```glfwGetInputMode```~~
* ~~```glfwSetInputMode```~~
* ```GLFW.getKey : Window -> key:Int -> pressed:Bool```
* ```GLFW.getMouseButton : Window -> button:Int -> pressed:Bool```
* ```GLFW.getCursorPos : Window -> {x:Float, y:Float}```
* ```GLFW.setCursorPos : Window -> x:Float -> y:Float -> Void```
* ```GLFW.setKeyCallback : Window -> Null<Window -> key:Int -> state:Int -> modifier:Int -> Void> -> Void```
* ```GLFW.setCharCallback : Window -> Null<Window -> char:Int -> Void> -> Void```
* ```GLFW.setMouseButtonCallback : Window -> Null<Window -> button:Int -> pressed:Bool -> Void> -> Void```
* ```GLFW.setCursorPosCallback : Window -> Null<Window -> x:Float -> y:Float -> Void> -> Void```
* ```GLFW.setCusorEnterCallback : Window -> Null<Window -> enter:Bool -> Void> -> Void```
* ```GLFW.setScrollCallback : Window -> Null<Window -> offsetX:Float -> offsetY:Float -> Void> -> Void```
* ~~```glfwGetJoystickParam```~~
* ~~```glfwGetJoystickAxes```~~
* ~~```glfwGetJoystickButtons```~~
* ~~```glfwGetJoystickName```~~

##### Monitor Handling
* ```GLFW.getMonitors : Void -> Array<Monitor>```
* ```GLFW.getPrimaryMonitor : Void -> Monitor```
* ~~```glfwGetMonitorPos```~~
* ~~```glfwGetMonitorPhysicalSize```~~
* ~~```glfwGetMonitorName```~~
* ~~```glfwSetMonitorCallback```~~
* ~~```glfwGetVideoModes```~~
* ~~```glfwGetVideoMode```~~

##### Native Access
* ~~```glfwGetWin32Window```~~
* ~~```glfwGetWGLContext```~~
* ~~```glfwGetCocoaWindow```~~
* ~~```glfwGetNSGLContext```~~
* ~~```glfwGetX11Display```~~
* ~~```glfwGetX11Window```~~
* ~~```glfwGetX11Context```~~
* ~~```glfwGetEGLDisplay```~~
* ~~```glfwGetEGLContext```~~
* ~~```glfwGetEGLSurface```~~

##### Time Input
* ```GLFW.getTime : Void -> Float```
* ```GLFW.setTime : Float -> Void```

##### Window Handling
* ```GLFW.defaultWindowHints : Void -> Void```
* ```GLFW.windowHint : target:Int -> hint:Int```
* ```GLFW.createWindow : width:Int -> height:Int -> title:String -> ?monitor:Monitor -> ?share:Window -> Window```
* ```GLFW.destroyWindow : Window -> Void```
* ```GLFW.windowShouldClose : Window -> Bool```
* ```GLFW.setWindowShouldClose : Window -> Bool -> Void```
* ```GLFW.setWindowTitle : Window -> String -> Void```
* ```GLFW.getWindowPos : Window -> {x:Int, y:Int}```
* ```GLFW.setWindowPos : Window -> x:Int -> y:Int -> Void```
* ```GLFW.getWindowSize : Window -> {width:Int, height:Int}```
* ```GLFW.setWindowSize : Window -> width:Int -> height:Int -> Void```
* ```GLFW.iconifyWindow : Window -> Void```
* ```GLFW.restoreWindow : Window -> Void```
* ```GLFW.showWindow : Window -> Void```
* ```GLFW.hideWindow : Window -> Void```
* ~~```glfwGetWindowMonitor```~~
* ```GLFW.getWindowParam : Window -> param:Int -> Int```
* ~~```glfwSetWindowUserPointer```~~
* ~~```glfwGetWindowUserPointer```~~
* ```GLFW.setWindowPosCallback : Window -> Null<Window -> x:Int -> y:Int -> Void> -> Void```
* ```GLFW.setWindowSizeCallback : Window -> Null<Window -> width:Int -> height:Int -> Void> -> Void```
* ```GLFW.setWindowCloseCallback : Window -> Null<Window -> Void> -> Void```
* ```GLFW.setWindowRefreshCallback : Window -> Null<Window -> Void> -> Void```
* ```GLFW.setWindowFocusCallback : Window -> Null<Window -> focus:Bool -> Void> -> Void```
* ```GLFW.setWindowIconifyCallback : Window -> Null<Window -> iconified:Bool -> Void> -> Void```
* ```GLFW.pollEvents : Void -> Void```
* ```GLFW.waitEvents : Void -> Void```
