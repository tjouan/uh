#include "uh.h"


#define set_window(x) \
  UhWindow *window;\
  Data_Get_Struct(x, UhWindow, window);

#define DPY     window->dpy
#define WINDOW  window->id


VALUE window_focus(VALUE self) {
  set_window(self);

  XSetInputFocus(DPY, WINDOW, RevertToPointerRoot, CurrentTime);

  return Qnil;
}

VALUE window_icccm_wm_delete(VALUE self) {
  set_window(self);
  XEvent xev;

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
  set_window(self);
  Atom  *win_protocols;
  int   count;
  int   i;
  char  *atom_name;
  VALUE protocols = rb_ary_new();

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
  set_window(self);

  XKillClient(DPY, WINDOW);

  return Qnil;
}

VALUE window_map(VALUE self) {
  set_window(self);

  XMapWindow(DPY, WINDOW);

  return Qnil;
}

VALUE window_mask_set(VALUE self, VALUE mask) {
  set_window(self);
  XSetWindowAttributes attrs;

  attrs.event_mask = FIX2LONG(mask);
  XChangeWindowAttributes(DPY, WINDOW, CWEventMask, &attrs);

  return Qnil;
}

VALUE window_name(VALUE self) {
  set_window(self);
  char        *wxname;
  VALUE       wname;

  if (!XFetchName(DPY, WINDOW, &wxname))
    return Qnil;

  wname = rb_str_new_cstr(wxname);
  XFree(wxname);

  return wname;
}

VALUE window_override_redirect(VALUE self) {
  set_window(self);
  XWindowAttributes wa;

  if (!XGetWindowAttributes(DPY, WINDOW, &wa))
    return Qnil;

  return wa.override_redirect ? Qtrue : Qfalse;
}

VALUE window_raise(VALUE self) {
  set_window(self);

  XRaiseWindow(DPY, WINDOW);

  return Qnil;
}

VALUE window_unmap(VALUE self) {
  set_window(self);

  XUnmapWindow(DPY, WINDOW);

  return Qnil;
}

VALUE window_wclass(VALUE self) {
  set_window(self);
  XClassHint  ch;
  VALUE       wclass;

  if (!XGetClassHint(DPY, WINDOW, &ch))
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
  XConfigureWindow(DPY, WINDOW, mask, &wc);

  return Qnil;
}

VALUE window__configure_event(VALUE self, VALUE rx, VALUE ry, VALUE rw, VALUE rh) {
  set_window(self);
  XConfigureEvent ev;

  ev.type               = ConfigureNotify;
  ev.display            = DPY;
  ev.event              = WINDOW;
  ev.window             = WINDOW;
  ev.x                  = FIX2INT(rx);
  ev.y                  = FIX2INT(ry);
  ev.width              = FIX2INT(rw);
  ev.height             = FIX2INT(rh);
  ev.border_width       = 0;
  ev.above              = None;
  ev.override_redirect  = False;
  XSendEvent(DPY, WINDOW, False, StructureNotifyMask, (XEvent *)&ev);

  return Qnil;
}

VALUE window__create_sub(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h) {
  set_window(self);
  XSetWindowAttributes  wa;
  Window                sub_win;

  wa.override_redirect  = True;
  wa.background_pixmap  = ParentRelative;
  wa.event_mask         = ExposureMask;

  sub_win = XCreateWindow(DPY, WINDOW,
    FIX2INT(x), FIX2INT(y), FIX2INT(w), FIX2INT(h), 0,
    CopyFromParent, CopyFromParent, CopyFromParent,
    CWOverrideRedirect | CWBackPixmap | CWEventMask, &wa
  );

  return window_make(DPY, sub_win);
}

VALUE window__moveresize(VALUE self, VALUE x, VALUE y, VALUE width, VALUE height) {
  set_window(self);
  XWindowChanges wc;

  wc.x      = NUM2INT(x);
  wc.y      = NUM2INT(y);
  wc.width  = NUM2INT(width);
  wc.height = NUM2INT(height);
  XConfigureWindow(DPY, WINDOW, CWX | CWY | CWWidth | CWHeight, &wc);

  return Qnil;
}


int window_id(VALUE self) {
  set_window(self);

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
