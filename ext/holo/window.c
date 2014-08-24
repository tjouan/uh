#include "holo.h"


#define set_window(x) \
  HoloWindow *window;\
  Data_Get_Struct(x, HoloWindow, window);


VALUE window_s_configure(VALUE klass, VALUE rdisplay, VALUE window_id) {
  set_display(rdisplay);
  XWindowChanges  wc;
  unsigned int    mask;

  mask = CWX | CWY | CWWidth | CWHeight | CWBorderWidth | CWStackMode;
  wc.x            = 0;
  wc.y            = 0;
  wc.width        = 484;
  wc.height       = 100;
  wc.border_width = 0;
  wc.stack_mode   = Above;
  XConfigureWindow(DPY, NUM2LONG(window_id), mask, &wc);

  return Qnil;
}

VALUE window_map(VALUE self) {
  set_window(self);

  XMapWindow(window->dpy, window->id);

  return Qnil;
}

VALUE window__moveresize(VALUE self, VALUE x, VALUE y, VALUE width, VALUE height) {
  set_window(self);
  XWindowChanges wc;

  wc.x      = NUM2INT(x);
  wc.y      = NUM2INT(y);
  wc.width  = NUM2INT(width);
  wc.height = NUM2INT(height);
  XConfigureWindow(window->dpy, window->id, CWX | CWY |CWWidth | CWHeight, &wc);

  return Qnil;
}
