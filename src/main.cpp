#include "LearnOpenGL/callbacks.hpp"

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>

constexpr unsigned int windowWidth = 1920;
constexpr unsigned int windowHeight = 1080;

int main() {
    if (!glfwInit()) {
        std::cerr << "failed to initialize glfw\n";
        return -1;
    }

    // window attributes
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_TRUE);
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    // window handle
    GLFWwindow *window = glfwCreateWindow(windowWidth, windowHeight, "LearnOpenGL", NULL, NULL);
    if (!window) {
        std::cerr << "failed to create glfw window\n";
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    // OpenGL function loader
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cerr << "failed to initialize glad\n";
        glfwTerminate();
        return -1;
    }

    // size of rendering window
    glViewport(0, 0, windowWidth, windowHeight);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    // render loop
    while (!glfwWindowShouldClose(window)) {
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwTerminate();
    return 0;
}