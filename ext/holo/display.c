#include "holo.h"


VALUE rdisplay_error_handler;

int display_x_error_handler(Display *dpy, XErrorEvent *e);


VALUE display_s_on_error(VALUE klass, VALUE handler) {
  rdisplay_error_handler = handler;

  return Qnil;
}


VALUE display_alloc(VALUE klass) {
  HoloDisplay *display;

  return Data_Make_Struct(klass, HoloDisplay, 0, free, display);
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

VALUE display_color_by_name(VALUE self, VALUE rcolor) {
  set_display(self);
  Colormap  map;
  XColor    color;

  map = DefaultColormap(DPY, DefaultScreen(DPY));

  if (!XAllocNamedColor(DPY, map, RSTRING_PTR(rcolor), &color, &color))
    rb_raise(rb_eArgError, "Invalid color name `%s'", RSTRING_PTR(rcolor));

  return color_make(color.pixel);
}

VALUE display_create_pixmap(VALUE self, VALUE width, VALUE height) {
  set_display(self);
  Pixmap pixmap;

  pixmap = XCreatePixmap(DPY, ROOT_DEFAULT, FIX2INT(width), FIX2INT(height),
    DefaultDepth(DPY, DefaultScreen(DPY))
  );

  return pixmap_make(DPY, pixmap, width, height);
}

VALUE display_each_event(VALUE self) {
  set_display(self);
  XEvent xev;

  while (1) {
    XNextEvent(DPY, &xev);
    rb_yield(event_make(&xev));
  }

  return Qnil;
}

VALUE display_grab_key(VALUE self, VALUE key, VALUE modifier) {
  set_display(self);
  KeySym      ks;
  KeyCode     kc;

  ks = XStringToKeysym(RSTRING_PTR(key));
  if (ks == NoSymbol)
    rb_raise(rb_eArgError, "Invalid KeySym %s", RSTRING_PTR(key));

  kc = XKeysymToKeycode(DPY, ks);
  if (kc == 0)
    rb_raise(rb_eArgError, "KeySym XK_%s has no KeyCode", RSTRING_PTR(key));

  XGrabKey(DPY, kc, FIX2INT(modifier), ROOT_DEFAULT, True,
    GrabModeAsync, GrabModeAsync);

  return Qnil;
}

VALUE display_listen_events(VALUE self, VALUE mask) {
  set_display(self);

  XSelectInput(DPY, ROOT_DEFAULT, FIX2LONG(mask));

  return Qnil;
}

VALUE display_open(VALUE self) {
  set_display(self);

  if (!(DPY = XOpenDisplay(NULL))) {
    rb_raise(eDisplayError, "Can't open display");
  }

  rdisplay_error_handler = Qnil;
  XSetErrorHandler(display_x_error_handler);

  return self;
}

VALUE display_query_font(VALUE self) {
  set_display(self);
  XFontStruct *xfs;
  VALUE       font;

  if (!(xfs = XQueryFont(DPY,
      XGContextFromGC(DefaultGC(DPY, DefaultScreen(DPY))))))
    return Qnil;

  font = font_make(xfs->ascent, xfs->descent);
  XFreeFontInfo(NULL, xfs, 1);

  return font;
}

VALUE display_root(VALUE self) {
  set_display(self);

  return window_make(DPY, ROOT_DEFAULT);
}

VALUE display_screens(VALUE self) {
  set_display(self);
  XineramaScreenInfo  *xsi;
  int                 n;
  VALUE               screens = rb_ary_new();
  VALUE               args[5];

  if (XineramaIsActive(DPY)) {
    xsi = XineramaQueryScreens(DPY, &n);

    for (int i = 0; i < n; i++) {
      args[0] = INT2FIX(i);
      args[1] = INT2FIX(xsi[i].x_org);
      args[2] = INT2FIX(xsi[i].y_org);
      args[3] = INT2FIX(xsi[i].width);
      args[4] = INT2FIX(xsi[i].height);

      rb_ary_push(screens, rb_class_new_instance(5, args, cScreen));
    }
  }
  else {
    args[0] = INT2FIX(DefaultScreen(DPY));
    args[1] = INT2FIX(0);
    args[2] = INT2FIX(0);
    args[3] = INT2FIX(XDisplayWidth(DPY, DefaultScreen(DPY)));
    args[4] = INT2FIX(XDisplayHeight(DPY, DefaultScreen(DPY)));

    rb_ary_push(screens, rb_class_new_instance(5, args, cScreen));
  }

  return screens;
}

VALUE display_sync(VALUE self, VALUE discard) {
  set_display(self);

  XSync(display->dpy, RTEST(discard));

  return Qnil;
}


int display_x_error_handler(Display *dpy, XErrorEvent *e) {
  char msg[80];
  char req[80];
  char nb[80];

  XGetErrorText(dpy, e->error_code, msg, sizeof msg);
  sprintf(nb, "%d", e->request_code);
  XGetErrorDatabaseText(dpy, "XRequest", nb, "<unknown>", req, sizeof req);

  rb_funcall(rdisplay_error_handler, rb_intern("call"), 3,
    rb_str_new_cstr(req),
    LONG2NUM(e->resourceid),
    rb_str_new_cstr(msg)
  );

  return 0;
}
