#include "holo.h"

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
  HoloDisplay *display;
  VALUE name;

  Data_Get_Struct(self, HoloDisplay, display);
  name = rb_iv_get(self, "@name");

  if (!(display->dpy = XOpenDisplay(NIL_P(name) ? NULL : RSTRING_PTR(name)))) {
    rb_raise(eHoloDisplayError, "Can't open display");
  }

  return self;
}

VALUE display_close(VALUE self) {
  HoloDisplay *display;

  Data_Get_Struct(self, HoloDisplay, display);

  if (display->dpy) {
    XCloseDisplay(display->dpy);
  }
  else {
    rb_raise(eHoloDisplayError, "Can't close display");
  }

  return self;
}

VALUE display_next_event(VALUE self) {
  HoloDisplay *display;
  XEvent      xev;

  Data_Get_Struct(self, HoloDisplay, display);

  XNextEvent(display->dpy, &xev);

  return INT2FIX(xev.type);
}

VALUE display_listen_events(VALUE self) {
  HoloDisplay *display;

  Data_Get_Struct(self, HoloDisplay, display);

  XSelectInput(display->dpy, DefaultRootWindow(display->dpy), SubstructureRedirectMask);

  return Qnil;
}
