//
//  BKOpenGLView.m
//  Repro3D
//
//  Created by Bryan Klimt on 12/29/12.
//  Copyright (c) 2012 Bryan Klimt. All rights reserved.
//

#import "BKOpenGLView.h"

#include <OpenGL/gl.h>
#include <OpenGL/glu.h>

@implementation BKOpenGLView

- (void)drawRect:(NSRect)dirtyRect {
  glClearColor(0.0, 0.0, 0.0, 0.0);

  // Set up the projection matrix.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
  gluPerspective(90.0f, 1.0, 1.0, 20);

  glClear(GL_COLOR_BUFFER_BIT);

  // Set up the camera.
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  gluLookAt(0.0, 0.0, 1.0,
            0.0, 0.0, 0.0,
            0.0, 1.0, 0.0);

  // Set up the a light centered horizontally.
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  float light1Position[] = { 0.0f, 2.0f, 0.0f, 1.0f };
  float light1Diffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
  glLightfv(GL_LIGHT0, GL_POSITION, light1Position);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, light1Diffuse);

  // Set up the material.
  float material1Diffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
  glMaterialfv(GL_FRONT, GL_DIFFUSE, material1Diffuse);

  // Transform such that we can draw in (-1, -1) to (1, 1) at z = 0.
  glTranslated(0, 0, -1);
  glScaled(2, 2, 1);

  // Draw two triangles, symmetric w.r.t. to the light and camera.
  glBegin(GL_TRIANGLES);
    glVertex3d(-1, -1,  0);
    glVertex3d( 0,  1,  0);
    glVertex3d(-1,  1,  0);
  glEnd();

  glScaled(1, 1, 5.0);  // This should be a no-op since 5 * 0 = 0.
  glBegin(GL_TRIANGLES);
    glVertex3d( 1, -1,  0);
    glVertex3d( 1,  1,  0);
    glVertex3d( 0,  1,  0);
  glEnd();

  glFlush();
  GLenum error = glGetError();
  if (error != GL_NO_ERROR) {
    NSLog(@"OpenGL error: %d", error);
  }
}

@end
