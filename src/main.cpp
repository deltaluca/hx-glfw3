#define IMPLEMENT_API
#include "glfw.h"

extern "C" void hx_glfw3_entry() {
    glfw_allocateKinds();
}
DEFINE_ENTRY_POINT(hx_glfw3_entry);

