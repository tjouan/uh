#include "uh.h"


#define SET_DISPLAY(x) \
  UhDisplay *display;\
  Data_Get_Struct(x, UhDisplay, display);

#define DPY display->dpy


VALUE rdisplay_error_handler = Qnil;

int display_x_error_handler(Display *dpy, XErrorEvent *e);


VALUE display_s_on_error(VALUE klass) {
  if (!rb_block_given_p()) {
    rb_raise(rb_eArgError, "no block given");
  }

  rdisplay_error_handler = rb_block_proc();
  rb_global_variable(&rdisplay_error_handler);

  return Qnil;
}


VALUE display_alloc(VALUE klass) {
  UhDisplay *display;

  return Data_Make_Struct(klass, UhDisplay, 0, free, display);
}


VALUE display_close(VALUE self) {
  SET_DISPLAY(self);

  if (DPY) {
    XCloseDisplay(DPY);
    DPY = NULL;
  }
  else {
    rb_raise(eDisplayError, "cannot close display");
  }

  return self;
}

VALUE display_create_pixmap(VALUE self, VALUE rwidth, VALUE rheight) {
  Pixmap pixmap;
  SET_DISPLAY(self);

  rb_funcall(self, rb_intern("check!"), 0);
  pixmap = XCreatePixmap(DPY, ROOT_DEFAULT, FIX2INT(rwidth), FIX2INT(rheight),
    DefaultDepth(DPY, SCREEN_DEFAULT)
  );

  return pixmap_make(DPY, pixmap, rwidth, rheight);
}

VALUE display_fileno(VALUE self) {
  SET_DISPLAY(self);

  rb_funcall(self, rb_intern("check!"), 0);

  return INT2FIX(XConnectionNumber(DPY));
}

VALUE display_flush(VALUE self) {
  SET_DISPLAY(self);

  return INT2FIX(XFlush(DPY));
}

VALUE display_each_event(VALUE self) {
  XEvent xev;
  SET_DISPLAY(self);

  while (1) {
    XNextEvent(DPY, &xev);
    rb_yield(event_make(&xev));
  }

  return Qnil;
}

VALUE display_grab_key(VALUE self, VALUE rkey, VALUE rmodifier) {
  KeySym      ks;
  KeyCode     kc;
  SET_DISPLAY(self);

  StringValue(rkey);
  ks = XStringToKeysym(RSTRING_PTR(rkey));
  if (ks == NoSymbol)
    rb_raise(eArgumentError, "invalid KeySym %s", RSTRING_PTR(rkey));

  kc = XKeysymToKeycode(DPY, ks);
  if (kc == 0)
    rb_raise(eArgumentError, "keysym XK_%s has no keycode", RSTRING_PTR(rkey));

  XGrabKey(DPY, kc, FIX2INT(rmodifier), ROOT_DEFAULT, True,
    GrabModeAsync, GrabModeAsync);

  return Qnil;
}

VALUE display_listen_events(int argc, VALUE *argv, VALUE self) {
  VALUE   arg1;
  VALUE   arg2;
  Window  window;
  long    mask;
  SET_DISPLAY(self);

  if (rb_scan_args(argc, argv, "11", &arg1, &arg2) == 2) {
    window = window_id(arg1);
    mask   = FIX2LONG(arg2);
  }
  else {
    window = ROOT_DEFAULT;
    mask   = FIX2LONG(arg1);
  }

  XSelectInput(DPY, window, mask);

  return Qnil;
}

VALUE display_next_event(VALUE self) {
  XEvent xev;
  SET_DISPLAY(self);

  XNextEvent(DPY, &xev);

  return event_make(&xev);
}

VALUE display_open(VALUE self) {
  SET_DISPLAY(self);

  if (!(DPY = XOpenDisplay(NULL))) {
    rb_raise(eDisplayError, "cannot open display");
  }

  XSetErrorHandler(display_x_error_handler);

  return self;
}

VALUE display_opened_p(VALUE self) {
  SET_DISPLAY(self);

  return DPY ? Qtrue : Qfalse;
}

VALUE display_pending(VALUE self) {
  SET_DISPLAY(self);

  return INT2FIX(XPending(DPY));
}

VALUE display_query_font(VALUE self) {
  XFontStruct *xfs;
  VALUE       font;
  SET_DISPLAY(self);

  if (!(xfs = XQueryFont(DPY,
      XGContextFromGC(DefaultGC(DPY, SCREEN_DEFAULT)))))
    return Qnil;

  font = font_make(xfs->max_bounds.width, xfs->ascent, xfs->descent);
  XFreeFontInfo(NULL, xfs, 1);

  return font;
}

VALUE display_root(VALUE self) {
  SET_DISPLAY(self);

  return window_make(DPY, ROOT_DEFAULT);
}

VALUE display_screens(VALUE self) {
  XineramaScreenInfo  *xsi;
  int                 n;
  VALUE               screens = rb_ary_new();
  VALUE               args[5];
  SET_DISPLAY(self);

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
    args[0] = INT2FIX(SCREEN_DEFAULT);
    args[1] = INT2FIX(0);
    args[2] = INT2FIX(0);
    args[3] = INT2FIX(XDisplayWidth(DPY, SCREEN_DEFAULT));
    args[4] = INT2FIX(XDisplayHeight(DPY, SCREEN_DEFAULT));

    rb_ary_push(screens, rb_class_new_instance(5, args, cScreen));
  }

  return screens;
}

VALUE display_sync(VALUE self, VALUE rdiscard) {
  SET_DISPLAY(self);

  XSync(display->dpy, RTEST(rdiscard));

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
