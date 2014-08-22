#include "holo.h"

#define set_display(x) \
  HoloDisplay *display;\
  Data_Get_Struct(self, HoloDisplay, display);

#define DPY           display->dpy
#define ROOT_DEFAULT  DefaultRootWindow(DPY)

static void display_free(HoloDisplay *display) {
  free(display);
}


VALUE display_alloc(VALUE klass) {
  VALUE obj;
  HoloDisplay *display;

  obj = Data_Make_Struct(klass, HoloDisplay, 0, display_free, display);

  return obj;
}

VALUE display_init(int ac, VALUE *av, VALUE self) {
  VALUE name;

  rb_scan_args(ac, av, "01", &name);

  if (NIL_P(name)) {
    name = Qnil;
  }

  rb_iv_set(self, "@name", name);

  return self;
}

VALUE display_open(VALUE self) {
  set_display(self);
  VALUE name;

  name = rb_iv_get(self, "@name");

  if (!(DPY = XOpenDisplay(NIL_P(name) ? NULL : RSTRING_PTR(name)))) {
    rb_raise(eHoloDisplayError, "Can't open display");
  }

  return self;
}

VALUE display_close(VALUE self) {
  set_display(self);

  if (DPY) {
    XCloseDisplay(DPY);
  }
  else {
    rb_raise(eHoloDisplayError, "Can't close display");
  }

  return self;
}

VALUE display_next_event(VALUE self) {
  set_display(self);
  XEvent      xev;

  XNextEvent(display->dpy, &xev);

  return INT2FIX(xev.type);
}

VALUE display_listen_events(VALUE self) {
  set_display(self);

  XSelectInput(DPY, ROOT_DEFAULT, SubstructureRedirectMask);

  return Qnil;
}

VALUE display_sync(VALUE self) {
  set_display(self);

  XSync(display->dpy, False);

  return Qnil;
}

VALUE display_change_window_attributes(VALUE self) {
  set_display(self);
  XSetWindowAttributes  attr;

  attr.event_mask = PropertyChangeMask | SubstructureRedirectMask |
    SubstructureNotifyMask | StructureNotifyMask;
  XChangeWindowAttributes(DPY, ROOT_DEFAULT, CWEventMask, &attr);

  return Qnil;
}

VALUE display_grab_key(VALUE self, VALUE key) {
  set_display(self);
  KeySym      ks;
  KeyCode     kc;

  key = rb_id2str(SYM2ID(key));

  ks = XStringToKeysym(RSTRING_PTR(key));
  if (ks == NoSymbol)
    rb_raise(rb_eArgError, "Invalid KeySym %s", RSTRING_PTR(key));

  kc = XKeysymToKeycode(DPY, ks);
  if (kc == 0)
    rb_raise(rb_eArgError, "KeySym XK_%s has no KeyCode", RSTRING_PTR(key));

  XGrabKey(DPY, kc, Mod1Mask, ROOT_DEFAULT, True, GrabModeAsync, GrabModeAsync);

  return Qnil;
}
