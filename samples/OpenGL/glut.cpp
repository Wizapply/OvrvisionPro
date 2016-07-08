#include <GL/glut.h>

/* OpenGL functions */
void resize(GLsizei, GLsizei);
void initializeGL(GLsizei, GLsizei);
void drawScene();

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
	initializeGL(WIDTH, HEIGHT);
	//glClearColor(0.0, 0.0, 1.0, 1.0);
}

void SWAPBUFFERS()
{
	glutSwapBuffers();
}

void keyboard(unsigned char key, int x, int y)
{
  switch (key) {
  case 'q':
  case 'Q':
    exit(0);
  default:
    break;
  }
}
int main(int argc, char *argv[])
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
	glutCreateWindow(argv[0]);
	glutDisplayFunc(display);
	glutKeyboardFunc(keyboard);
	init();
	glutMainLoop();
	return 0;
}
