#include <GL/glut.h>

/* OpenGL functions */
GLvoid resize(GLsizei, GLsizei);
GLvoid initializeGL(GLsizei, GLsizei);
GLvoid drawScene(GLvoid);

#define WIDTH	800
#define HEIGHT	600 

void display(void)
{
	drawScene(); // Draw OpenGL
	//glClear(GL_COLOR_BUFFER_BIT);
	//glFlush();
}

void init(void)
{
	initializeGL(WIDTHm HEIGHT);
	//glClearColor(0.0, 0.0, 1.0, 1.0);
}

int main(int argc, char *argv[])
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGBA);
	glutCreateWindow(argv[0]);
	glutDisplayFunc(display);
	init();
	glutMainLoop();
	return 0;
}