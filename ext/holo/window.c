#include "holo.h"


#define set_window(x) \
  HoloWindow *window;\
  Data_Get_Struct(x, HoloWindow, window);


VALUE window_focus(VALUE self) {
  set_window(self);

  XSetInputFocus(window->dpy, window->id, RevertToPointerRoot, CurrentTime);

  return Qnil;
}

VALUE window_kill(VALUE self) {
  set_window(self);

  XKillClient(window->dpy, window->id);

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


VALUE window__configure(VALUE self, VALUE rx, VALUE ry, VALUE rw, VALUE rh) {
  set_window(self);
  XWindowChanges  wc;
  unsigned int    mask;

  mask = CWX | CWY | CWWidth | CWHeight | CWBorderWidth | CWStackMode;
  wc.x            = FIX2INT(rx);
  wc.y            = FIX2INT(ry);
  wc.width        = FIX2INT(rw);
  wc.height       = FIX2INT(rh);
  wc.border_width = 0;
  wc.stack_mode   = Above;
  XConfigureWindow(window->dpy, window->id, mask, &wc);

  return Qnil;
}

VALUE window__create_sub(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h) {
  set_window(self);
  XSetWindowAttributes  wa;
  Window                sub_win;

  wa.override_redirect  = True;
  wa.background_pixmap  = ParentRelative;
  wa.event_mask         = ExposureMask;

  sub_win = XCreateWindow(window->dpy, window->id,
    FIX2INT(x), FIX2INT(y), FIX2INT(w), FIX2INT(h), 0,
    CopyFromParent, CopyFromParent, CopyFromParent,
    CWOverrideRedirect | CWBackPixmap | CWEventMask, &wa
  );

  return window_make(window->dpy, sub_win);
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
