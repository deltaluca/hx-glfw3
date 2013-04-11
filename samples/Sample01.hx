package;

import glfw3.GLFW;

class Sample01 {
    static function main() {
        GLFW.setErrorCallback(function (err:Int, msg:String) throw 'error ($err) :: $msg');
        GLFW.init();

        GLFW.windowHint(GLFW.CONTEXT_VERSION_MAJOR, 3);
        GLFW.windowHint(GLFW.CONTEXT_VERSION_MINOR, 3);
        GLFW.windowHint(GLFW.OPENGL_FORWARD_COMPAT, 1);
        GLFW.windowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE);
        GLFW.windowHint(GLFW.OPENGL_FORWARD_COMPAT, 1);

        var window = GLFW.createWindow(800, 600, "Hello World!");

        while (!GLFW.windowShouldClose(window)) {
            GLFW.waitEvents();
        }

        GLFW.destroyWindow(window);
        GLFW.terminate();
    }
}
