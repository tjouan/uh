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

VALUE window_focus(VALUE self) {
  set_window(self);

  XSetInputFocus(window->dpy, window->id, RevertToPointerRoot, CurrentTime);

  return Qnil;
}

VALUE window_map(VALUE self) {
  set_window(self);

  XMapWindow(window->dpy, window->id);

  return Qnil;
}

VALUE window_name(VALUE self) {
  set_window(self);
  char        *wxname;
  VALUE       wname;

  if (!XFetchName(window->dpy, window->id, &wxname))
    return Qnil;

  wname = rb_str_new_cstr(wxname);
  XFree(wxname);

  return wname;
}

VALUE window_override_redirect(VALUE self) {
  set_window(self);
  XWindowAttributes wa;

  if (!XGetWindowAttributes(window->dpy, window->id, &wa))
    return Qnil;

  return wa.override_redirect ? Qtrue : Qfalse;
}

VALUE window_raise(VALUE self) {
  set_window(self);

  XRaiseWindow(window->dpy, window->id);

  return Qnil;
}

VALUE window_unmap(VALUE self) {
  set_window(self);

  XUnmapWindow(window->dpy, window->id);

  return Qnil;
}

VALUE window_wclass(VALUE self) {
  set_window(self);
  XClassHint  ch;
  VALUE       wclass;

  if (!XGetClassHint(window->dpy, window->id, &ch))
    return Qnil;

  wclass = rb_str_new_cstr(ch.res_class);
  XFree(ch.res_name);
  XFree(ch.res_class);

  return wclass;
}


VALUE window__moveresize(VALUE self, VALUE x, VALUE y, VALUE width, VALUE height) {
  set_window(self);
  XWindowChanges wc;

  wc.x      = NUM2INT(x);
  wc.y      = NUM2INT(y);
  wc.width  = NUM2INT(width);
  wc.height = NUM2INT(height);
  XConfigureWindow(window->dpy, window->id, CWX | CWY | CWWidth | CWHeight, &wc);

  return Qnil;
}


VALUE window_make(Display *display, Window window_id) {
  HoloWindow  *window;
  VALUE       obj;

  obj = Data_Make_Struct(cWindow, HoloWindow, 0, free, window);
  window->dpy = display;
  window->id  = window_id;

  rb_ivar_set(obj, rb_intern("@id"), LONG2NUM(window_id));

  return obj;
}
