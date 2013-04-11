package;

import glfw3.GLFW;

class Sample02 {
    static function main() {
        GLFW.setErrorCallback(function (err:Int, msg:String) throw 'error ($err) :: $msg');
        GLFW.init();

        GLFW.windowHint(GLFW.CONTEXT_VERSION_MAJOR, 3);
        GLFW.windowHint(GLFW.CONTEXT_VERSION_MINOR, 3);
        GLFW.windowHint(GLFW.OPENGL_FORWARD_COMPAT, 1);
        GLFW.windowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE);
        GLFW.windowHint(GLFW.OPENGL_FORWARD_COMPAT, 1);

        var window = GLFW.createWindow(800, 600, "Use Arrow Keys!");
        GLFW.setKeyCallback(window, function (_, key:Int, state:Int) {
            if (state == GLFW.RELEASE) return;

            if (key == GLFW.KEY_LEFT) {
                var size = GLFW.getWindowSize(window);
                if (size.width > 6)
                    GLFW.setWindowSize(window, size.width-6, size.height);
            }
            else if (key == GLFW.KEY_RIGHT) {
                var size = GLFW.getWindowSize(window);
                GLFW.setWindowSize(window, size.width+6, size.height);
            }
        });

        while (!GLFW.windowShouldClose(window)) {
            GLFW.waitEvents();

            if (GLFW.getKey(window, GLFW.KEY_UP)) {
                var size = GLFW.getWindowSize(window);
                if (size.height > 1)
                    GLFW.setWindowSize(window, size.width, size.height-1);
            }
            if (GLFW.getKey(window, GLFW.KEY_DOWN)) {
                var size = GLFW.getWindowSize(window);
                GLFW.setWindowSize(window, size.width, size.height+1);
            }
        }

        GLFW.destroyWindow(window);
        GLFW.terminate();
    }
}
