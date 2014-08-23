#include "holo.h"


VALUE display_alloc(VALUE klass) {
  HoloDisplay *display;

  return Data_Make_Struct(klass, HoloDisplay, 0, free, display);
}

VALUE display_init(VALUE self, VALUE rdisplay) {
  rb_iv_set(self, "@name", rdisplay);

  return self;
}

VALUE display_open(VALUE self) {
  set_display(self);
  VALUE name;

  name = rb_iv_get(self, "@name");

  if (!(DPY = XOpenDisplay(NIL_P(name) ? NULL : RSTRING_PTR(name)))) {
    rb_raise(eDisplayError, "Can't open display");
  }

  return self;
}

VALUE display_close(VALUE self) {
  set_display(self);

  if (DPY) {
    XCloseDisplay(DPY);
  }
  else {
    rb_raise(eDisplayError, "Can't close display");
  }

  return self;
}

VALUE display_next_event(VALUE self) {
  set_display(self);
  XEvent      *xev;
  VALUE       ev;

  xev = calloc(1, sizeof(*xev));
  XNextEvent(display->dpy, xev);
  ev = event_make(xev);

  return ev;
}

VALUE display_listen_events(VALUE self, VALUE mask) {
  set_display(self);

  XSelectInput(DPY, ROOT_DEFAULT, FIX2LONG(mask));

  return Qnil;
}

VALUE display_sync(VALUE self, VALUE discard) {
  set_display(self);

  XSync(display->dpy, RTEST(discard));

  return Qnil;
}

VALUE display_root_change_attributes(VALUE self, VALUE mask) {
  set_display(self);
  XSetWindowAttributes attr;

  attr.event_mask = FIX2LONG(mask);
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
