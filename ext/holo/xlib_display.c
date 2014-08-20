#include "holo.h"

/*
static void display_close(void *p) {
  XCloseDisplay(p);
}
*/


VALUE xlib_display_alloc(VALUE klass) {
  VALUE obj;
  Display *display;

  if (! (display = XOpenDisplay(NULL)))
    puts("FAIL");

  //obj = Data_Wrap_Struct(klass, 0, display_close, display);
  obj = Data_Wrap_Struct(klass, 0, 0, display);

  return obj;
}

VALUE xlib_display_close(VALUE self) {
  Display *display;

  Data_Get_Struct(self, Display, display);

  XCloseDisplay(display);

  return Qnil;
}
