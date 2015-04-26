#include "uh.h"


#define SET_WINDOW(x) \
  UhWindow *window;\
  Data_Get_Struct(x, UhWindow, window);

#define DPY     window->dpy
#define WINDOW  window->id


VALUE window_configure(VALUE self, VALUE rgeo) {
  XWindowChanges  wc;
  unsigned int    mask;
  SET_WINDOW(self);

  mask = CWX | CWY | CWWidth | CWHeight | CWBorderWidth | CWStackMode;
  wc.x            = FIX2INT(rb_funcall(rgeo, rb_intern("x"), 0));
  wc.y            = FIX2INT(rb_funcall(rgeo, rb_intern("y"), 0));
  wc.width        = FIX2INT(rb_funcall(rgeo, rb_intern("width"), 0));
  wc.height       = FIX2INT(rb_funcall(rgeo, rb_intern("height"), 0));
  wc.border_width = 0;
  wc.stack_mode   = Above;
  XConfigureWindow(DPY, WINDOW, mask, &wc);

  return self;
}

VALUE window_configure_event(VALUE self, VALUE rgeo) {
  XConfigureEvent ev;
  SET_WINDOW(self);

  ev.type               = ConfigureNotify;
  ev.display            = DPY;
  ev.event              = WINDOW;
  ev.window             = WINDOW;
  ev.x                  = FIX2INT(rb_funcall(rgeo, rb_intern("x"), 0));
  ev.y                  = FIX2INT(rb_funcall(rgeo, rb_intern("y"), 0));
  ev.width              = FIX2INT(rb_funcall(rgeo, rb_intern("width"), 0));
  ev.height             = FIX2INT(rb_funcall(rgeo, rb_intern("height"), 0));
  ev.border_width       = 0;
  ev.above              = None;
  ev.override_redirect  = False;
  XSendEvent(DPY, WINDOW, False, StructureNotifyMask, (XEvent *)&ev);

  return self;
}

VALUE window_create(VALUE self, VALUE rgeo) {
  Window win;
  SET_WINDOW(self);

  win = XCreateSimpleWindow(DPY, WINDOW,
    FIX2INT(rb_funcall(rgeo, rb_intern("x"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("y"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("width"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("height"), 0)),
    0, BlackPixel(DPY, SCREEN_DEFAULT), BlackPixel(DPY, SCREEN_DEFAULT)
  );

  return window_make(DPY, win);
}

VALUE window_create_sub(VALUE self, VALUE rgeo) {
  XSetWindowAttributes  wa;
  Window                sub_win;
  SET_WINDOW(self);

  wa.override_redirect  = True;
  wa.background_pixmap  = ParentRelative;
  wa.event_mask         = ExposureMask;

  sub_win = XCreateWindow(DPY, WINDOW,
    FIX2INT(rb_funcall(rgeo, rb_intern("x"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("y"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("width"), 0)),
    FIX2INT(rb_funcall(rgeo, rb_intern("height"), 0)),
    0, CopyFromParent, CopyFromParent, CopyFromParent,
    CWOverrideRedirect | CWBackPixmap | CWEventMask, &wa
  );

  return window_make(DPY, sub_win);
}

VALUE window_destroy(VALUE self) {
  SET_WINDOW(self);

  XDestroyWindow(DPY, WINDOW);

  return Qnil;
}

VALUE window_focus(VALUE self) {
  SET_WINDOW(self);

  XSetInputFocus(DPY, WINDOW, RevertToPointerRoot, CurrentTime);

  return self;
}

VALUE window_icccm_wm_delete(VALUE self) {
  XEvent xev;
  SET_WINDOW(self);

  xev.type = ClientMessage;
  xev.xclient.window = WINDOW;
  xev.xclient.message_type = XInternAtom(DPY, "WM_PROTOCOLS", False);
  xev.xclient.format = 32;
  xev.xclient.data.l[0] = XInternAtom(DPY, "WM_DELETE_WINDOW", False);
  xev.xclient.data.l[1] = CurrentTime;
  XSendEvent(DPY, WINDOW, False, NoEventMask, &xev);

  return Qnil;
}

VALUE window_icccm_wm_protocols(VALUE self) {
  Atom  *win_protocols;
  int   count;
  int   i;
  char  *atom_name;
  VALUE protocols;
  SET_WINDOW(self);
  protocols = rb_ary_new();

  if (XGetWMProtocols(DPY, WINDOW, &win_protocols, &count)) {
    for (i = 0; i < count; i++) {
      atom_name = XGetAtomName(DPY, win_protocols[i]);
      rb_ary_push(protocols, ID2SYM(rb_intern(atom_name)));
      XFree(atom_name);
    }
  }

  return protocols;
}

VALUE window_kill(VALUE self) {
  SET_WINDOW(self);

  XKillClient(DPY, WINDOW);

  return Qnil;
}

VALUE window_map(VALUE self) {
  SET_WINDOW(self);

  XMapWindow(DPY, WINDOW);

  return self;
}

VALUE window_mask(VALUE self) {
  XWindowAttributes wa;
  SET_WINDOW(self);

  if (!XGetWindowAttributes(DPY, WINDOW, &wa)) {
    rb_raise(rb_eArgError, "cannot get window attributes for `0x%08lx'", WINDOW);
  }

  return LONG2FIX(wa.your_event_mask);
}

VALUE window_mask_set(VALUE self, VALUE mask) {
  XSetWindowAttributes attrs;
  SET_WINDOW(self);

  attrs.event_mask = FIX2LONG(mask);
  XChangeWindowAttributes(DPY, WINDOW, CWEventMask, &attrs);

  return Qnil;
}

VALUE window_moveresize(VALUE self, VALUE rgeo) {
  XWindowChanges wc;
  SET_WINDOW(self);

  wc.x      = FIX2INT(rb_funcall(rgeo, rb_intern("x"), 0));
  wc.y      = FIX2INT(rb_funcall(rgeo, rb_intern("y"), 0));
  wc.width  = FIX2INT(rb_funcall(rgeo, rb_intern("width"), 0));
  wc.height = FIX2INT(rb_funcall(rgeo, rb_intern("height"), 0));
  XConfigureWindow(DPY, WINDOW, CWX | CWY | CWWidth | CWHeight, &wc);

  return self;
}

VALUE window_name(VALUE self) {
  char        *wxname;
  VALUE       wname;
  SET_WINDOW(self);

  if (!XFetchName(DPY, WINDOW, &wxname))
    return Qnil;

  wname = rb_str_new_cstr(wxname);
  XFree(wxname);

  return wname;
}

VALUE window_name_set(VALUE self, VALUE name) {
  SET_WINDOW(self);

  XStoreName(DPY, WINDOW, RSTRING_PTR(name));

  return Qnil;
}

VALUE window_override_redirect(VALUE self) {
  XWindowAttributes wa;
  SET_WINDOW(self);

  if (!XGetWindowAttributes(DPY, WINDOW, &wa))
    return Qnil;

  return wa.override_redirect ? Qtrue : Qfalse;
}

VALUE window_raise(VALUE self) {
  SET_WINDOW(self);

  XRaiseWindow(DPY, WINDOW);

  return self;
}

VALUE window_unmap(VALUE self) {
  SET_WINDOW(self);

  XUnmapWindow(DPY, WINDOW);

  return self;
}

VALUE window_wclass(VALUE self) {
  XClassHint  ch;
  VALUE       wclass;
  SET_WINDOW(self);

  if (!XGetClassHint(DPY, WINDOW, &ch))
    return Qnil;

  wclass = rb_str_new_cstr(ch.res_class);
  XFree(ch.res_name);
  XFree(ch.res_class);

  return wclass;
}


int window_id(VALUE self) {
  SET_WINDOW(self);

  return WINDOW;
}

VALUE window_make(Display *display, Window window_id) {
  UhWindow    *window;
  VALUE       obj;

  obj = Data_Make_Struct(cWindow, UhWindow, 0, free, window);
  window->dpy = display;
  window->id  = window_id;

  rb_ivar_set(obj, rb_intern("@id"), LONG2NUM(window_id));

  return obj;
}
