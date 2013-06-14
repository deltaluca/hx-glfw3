#include "glfw.h"
#include "utils.h"
#define CONST(N) PCONST(glfw, GLFW, N)

#define GLFWCALLBACK(N, G) \
    value hx_glfw_##N(value window, value cbfun) { \
        glfw##G((GLFWwindow*)val_data(window), bound_##N, cbfun); \
        return val_null; \
    } \
    DEFINE_PRIM(hx_glfw_##N, 1)

DECLARE_KIND(k_Monitor);
DECLARE_KIND(k_Window);
DEFINE_KIND(k_Monitor);
DEFINE_KIND(k_Window);

//
// glfwSetErrorCallback
//
extern "C" void bound_errorCallback(int error, const char* description, void* cb) {
    val_call2((value)cb, alloc<int>(error), alloc<string>(description));
}
value hx_glfw_setErrorCallback(value cb) {
    glfwSetErrorCallback(bound_errorCallback, cb);
    return val_null;
}
DEFINE_PRIM(hx_glfw_setErrorCallback, 1);

//
// glfwInit
// glfwTerminate
//
value hx_glfw_init() {
    glfwInit();
    return val_null;
}
value hx_glfw_terminate() {
    glfwTerminate();
    return val_null;
}
DEFINE_PRIM(hx_glfw_init,      0);
DEFINE_PRIM(hx_glfw_terminate, 0);


//
// glfwGetMonitors
// glfwGetPrimaryMonitor
//
value hx_glfw_getMonitors(value out) {
    int count;
    GLFWmonitor** monitors = glfwGetMonitors(&count);
    val_array_set_size(out, count);
    for (int i = 0; i < count; i++) {
        value v = alloc_abstract(k_Monitor, monitors[i]);
        val_array_set_i(out, i, v);
    }
    return val_null;
}
value hx_glfw_getPrimaryMonitor() {
    GLFWmonitor* ptr = glfwGetPrimaryMonitor();
    value v = alloc_abstract(k_Monitor, ptr);
    return v;
}
DEFINE_PRIM(hx_glfw_getMonitors,       1);
DEFINE_PRIM(hx_glfw_getPrimaryMonitor, 0);


//
// glfwMakeContextCurrent
// glfwGetCurrentContext
// glfwSwapBuffers
// glfwSwapInterval
//
value hx_glfw_makeContextCurrent(value v) {
    glfwMakeContextCurrent((GLFWwindow*)val_data(v));
    return val_null;
}
value hx_glfw_getCurrentContext() {
    GLFWwindow* ptr = glfwGetCurrentContext();
    return ptr == NULL ? val_null : alloc_abstract(k_Window, ptr);
}
value hx_glfw_swapBuffers(value v) {
    glfwSwapBuffers((GLFWwindow*)val_data(v));
    return val_null;
}
value hx_glfw_swapInterval(value interval) {
    glfwSwapInterval(val_get<int>(interval));
    return val_null;
}
DEFINE_PRIM(hx_glfw_makeContextCurrent, 1);
DEFINE_PRIM(hx_glfw_getCurrentContext,  0);
DEFINE_PRIM(hx_glfw_swapBuffers,        1);
DEFINE_PRIM(hx_glfw_swapInterval,       1);


//
// glfwCreateWindow
// glfwDestroyWindow
//
value hx_glfw_createWindow(value width, value height, value title, value monitor, value share) {
    GLFWwindow* ptr = glfwCreateWindow(val_get<int>(width), val_get<int>(height), val_get<string>(title), (GLFWmonitor*)val_data(monitor), (GLFWwindow*)val_data(share));
    value v = alloc_abstract(k_Window, ptr);
    return v;
}
value hx_glfw_destroyWindow(value v) {
    GLFWwindow* ptr = (GLFWwindow*)val_data(v);
    glfwDestroyWindow(ptr);
    return val_null;
}
DEFINE_PRIM(hx_glfw_createWindow,  5);
DEFINE_PRIM(hx_glfw_destroyWindow, 1);


//
// glfwDefaultWindowHints
// glfwWindowHint
//

value hx_glfw_defaultWindowHints() {
    glfwDefaultWindowHints();
    return val_null;
}
value hx_glfw_windowHint(value target, value hint) {
    glfwWindowHint(val_get<int>(target), val_get<int>(hint));
    return val_null;
}
DEFINE_PRIM(hx_glfw_defaultWindowHints, 0);
DEFINE_PRIM(hx_glfw_windowHint,         2);


//
// glfwGetWindowAttrib
//
value hx_glfw_getWindowAttrib(value v, value param) {
    return alloc<int>(glfwGetWindowAttrib((GLFWwindow*)val_data(v), val_get<int>(param)));
}
DEFINE_PRIM(hx_glfw_getWindowAttrib, 2);

//
//glfwGetWindowPos
//glfwGetWindowSize
//glfwSetWindowPos
//glfwSetWindowSize
//glfwSetWindowTitle
//
value hx_glfw_getWindowPos(value v, value size) {
    int* vals = val_array_int(size);
    glfwGetWindowPos((GLFWwindow*)val_data(v), vals, vals+1);
    return val_null;
}
value hx_glfw_getWindowSize(value v, value size) {
    int* vals = val_array_int(size);
    glfwGetWindowSize((GLFWwindow*)val_data(v), vals, vals+1);
    return val_null;
}
value hx_glfw_setWindowPos(value v, value x, value y) {
    glfwSetWindowPos((GLFWwindow*)val_data(v), val_get<int>(x), val_get<int>(y));
    return val_null;
}
value hx_glfw_setWindowSize(value v, value width, value height) {
    glfwSetWindowSize((GLFWwindow*)val_data(v), val_get<int>(width), val_get<int>(height));
    return val_null;
}
value hx_glfw_setWindowTitle(value v, value title) {
    glfwSetWindowTitle((GLFWwindow*)val_data(v), val_get<string>(title));
    return val_null;
}
DEFINE_PRIM(hx_glfw_getWindowPos,   2);
DEFINE_PRIM(hx_glfw_getWindowSize,  2);
DEFINE_PRIM(hx_glfw_setWindowPos,   3);
DEFINE_PRIM(hx_glfw_setWindowSize,  3);
DEFINE_PRIM(hx_glfw_setWindowTitle, 2);

//
// glfwHideWindow
// glfwShowWindow
// glfwIconifyWindow
// glfwRestoreWindow
//
value hx_glfw_hideWindow(value v) {
    glfwHideWindow((GLFWwindow*)val_data(v));
    return val_null;
}
value hx_glfw_showWindow(value v) {
    glfwShowWindow((GLFWwindow*)val_data(v));
    return val_null;
}
value hx_glfw_iconifyWindow(value v) {
    glfwIconifyWindow((GLFWwindow*)val_data(v));
    return val_null;
}
value hx_glfw_restoreWindow(value v) {
    glfwRestoreWindow((GLFWwindow*)val_data(v));
    return val_null;
}
DEFINE_PRIM(hx_glfw_hideWindow,    1);
DEFINE_PRIM(hx_glfw_showWindow,    1);
DEFINE_PRIM(hx_glfw_iconifyWindow, 1);
DEFINE_PRIM(hx_glfw_restoreWindow, 1);

//
// glfwWindowShouldClose
// glfwSetWindowShouldClose
//
value hx_glfw_windowShouldClose(value v) {
    return alloc<bool>(glfwWindowShouldClose((GLFWwindow*)val_data(v)));
}
value hx_glfw_setWindowShouldClose(value v, value val) {
    glfwSetWindowShouldClose((GLFWwindow*)val_data(v), val_get<bool>(val));
    return val_null;
}
DEFINE_PRIM(hx_glfw_windowShouldClose,    1);
DEFINE_PRIM(hx_glfw_setWindowShouldClose, 2);

//
// glfwPollEvents
// glfwWaitEvents
//
value hx_glfw_pollEvents() {
    glfwPollEvents();
    return val_null;
}
value hx_glfw_waitEvents() {
    glfwWaitEvents();
    return val_null;
}
DEFINE_PRIM(hx_glfw_pollEvents, 0);
DEFINE_PRIM(hx_glfw_waitEvents, 0);


//
// glfwSetWindowPosCallback
// glfwSetWindowSizeCallback
// glfwSetWindowRefreshCallback
// glfwSetWindowCloseCallback
// glfwSetWindowFocusCallback
// glfwSetWindowIconifyCallback
//
extern "C" void bound_setWindowPosCallback(GLFWwindow* v, int x, int y, void* cb) {
    val_call2((value)cb, alloc<int>(x), alloc<int>(y));
}
extern "C" void bound_setWindowSizeCallback(GLFWwindow* v, int width, int height, void* cb) {
    val_call2((value)cb, alloc<int>(width), alloc<int>(height));
}
extern "C" void bound_setWindowRefreshCallback(GLFWwindow* v, void* cb) {
    val_call0((value)cb);
}
extern "C" void bound_setWindowCloseCallback(GLFWwindow* v, void* cb) {
    val_call0((value)cb);
}
extern "C" void bound_setWindowFocusCallback(GLFWwindow* v, int focused, void* cb) {
    val_call1((value)cb, alloc<bool>(focused));
}
extern "C" void bound_setWindowIconifyCallback(GLFWwindow* v, int iconified, void* cb) {
    val_call1((value)cb, alloc<bool>(iconified));
}
GLFWCALLBACK(setWindowPosCallback,     SetWindowPosCallback);
GLFWCALLBACK(setWindowSizeCallback,    SetWindowSizeCallback);
GLFWCALLBACK(setWindowRefreshCallback, SetWindowRefreshCallback);
GLFWCALLBACK(setWindowCloseCallback,   SetWindowCloseCallback);
GLFWCALLBACK(setWindowFocusCallback,   SetWindowFocusCallback);
GLFWCALLBACK(setWindowIconifyCallback, SetWindowIconifyCallback);


//
// glfwGetKey
// glfwGetMouseButton
// glfwGetCursorPos
// glfwSetCursorPos
//
value hx_glfw_getKey(value v, value key) {
    return alloc<bool>(GLFW_PRESS == glfwGetKey((GLFWwindow*)val_data(v), val_get<int>(key)));
}
value hx_glfw_getMouseButton(value v, value button) {
    return alloc<bool>(GLFW_PRESS == glfwGetMouseButton((GLFWwindow*)val_data(v), val_get<int>(button)));
}
value hx_glfw_getCursorPos(value v, value pos) {
    double* vals = val_array_double(pos);
    glfwGetCursorPos((GLFWwindow*)val_data(v), vals, vals+1);
    return val_null;
}
value hx_glfw_setCursorPos(value v, value x, value y) {
    glfwSetCursorPos((GLFWwindow*)val_data(v), val_get<double>(x), val_get<double>(y));
    return val_null;
}
DEFINE_PRIM(hx_glfw_getKey,         2);
DEFINE_PRIM(hx_glfw_getMouseButton, 2);
DEFINE_PRIM(hx_glfw_getCursorPos,   2);
DEFINE_PRIM(hx_glfw_setCursorPos,   3);

//
// glfwSetKeyCallback
// glfwSetCharCallback
// glfwSetMouseButtonCallback
// glfwSetScrollCallback
// glfwSetCursorPosCallback
// glfwSetCursorEnterCallback
//
void bound_setKeyCallback(GLFWwindow* v, int key, int scancode, int action, int mods, void* cb) {
    value args[4];
    args[0] = alloc<int>(key);
    args[1] = alloc<int>(scancode);
    args[2] = alloc<int>(action);
    args[3] = alloc<int>(mods);
    val_callN((value)cb, args, 4);
}
void bound_setCharCallback(GLFWwindow* v, unsigned int character, void* cb) {
    val_call1((value)cb, alloc<int>(character));
}
void bound_setMouseButtonCallback(GLFWwindow* v, int button, int pressed, int mods, void* cb) {
    val_call3((value)cb, alloc<int>(button), alloc<bool>(pressed == GLFW_PRESS), alloc<int>(mods));
}
void bound_setScrollCallback(GLFWwindow* v, double x, double y, void* cb) {
    val_call2((value)cb, alloc<double>(x), alloc<double>(y));
}
void bound_setCursorPosCallback(GLFWwindow* v, double x, double y, void* cb) {
    val_call2((value)cb, alloc<double>(x), alloc<double>(y));
}
void bound_setCursorEnterCallback(GLFWwindow* v, int enter, void* cb) {
    val_call1((value)cb, alloc<bool>(enter));
}
GLFWCALLBACK(setKeyCallback, SetKeyCallback);
GLFWCALLBACK(setCharCallback, SetCharCallback);
GLFWCALLBACK(setMouseButtonCallback, SetMouseButtonCallback);
GLFWCALLBACK(setScrollCallback, SetScrollCallback);
GLFWCALLBACK(setCursorPosCallback, SetCursorPosCallback);
GLFWCALLBACK(setCursorEnterCallback, SetCursorEnterCallback);


//
// glfwGetTime
// glfwSetTime
//
value hx_glfw_getTime() {
    return alloc<double>(glfwGetTime());
}
value hx_glfw_setTime(value time) {
    glfwSetTime(val_get<double>(time));
    return val_null;
}
DEFINE_PRIM(hx_glfw_getTime, 0);
DEFINE_PRIM(hx_glfw_setTime, 1);

extern "C" void glfw_allocateKinds() {
    k_Window = alloc_kind();
    k_Monitor = alloc_kind();
}
