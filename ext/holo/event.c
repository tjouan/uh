#include "holo.h"


#define set_xev(x) \
  XEvent *xev;\
  Data_Get_Struct(self, XEvent, xev);


void event_make_configure_request(VALUE self);
void event_make_destroy_notify(VALUE self);
void event_make_expose(VALUE self);
void event_make_key_press(VALUE self);
void event_make_map_request(VALUE self);
void event_make_property_notify(VALUE self);
void event_make_unmap_notify(VALUE self);


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  xev = calloc(1, sizeof(*xev));

  return Data_Wrap_Struct(klass, 0, free, xev);
}

VALUE event_window(VALUE self) {
  set_xev(self);
  HoloWindow  *window;
  VALUE       obj;

  obj = Data_Make_Struct(cWindow, HoloWindow, 0, free, window);
  window->dpy     = xev->xany.display;
  window->window  = xev->xany.window;

  return obj;
}


VALUE event_make(XEvent *xev) {
  typedef struct {
    int   type;
    VALUE klass;
    void  (*function)(VALUE self);
  } EvClass;
  EvClass ev_classes[] = {
    {ConfigureRequest,  cConfigureRequest,  event_make_configure_request},
    {DestroyNotify,     cDestroyNotify,     event_make_destroy_notify},
    {Expose,            cExpose,            event_make_expose},
    {KeyPress,          cKeyPress,          event_make_key_press},
    {MapRequest,        cMapRequest,        event_make_map_request},
    {PropertyNotify,    cPropertyNotify,    event_make_property_notify},
    {UnmapNotify,       cUnmapNotify,       event_make_unmap_notify}
  };
  int   i;
  VALUE event;

  for (i = 0; i < (sizeof ev_classes / sizeof ev_classes[0]); i++) {
    if (ev_classes[i].type == xev->type) {
      event = Data_Wrap_Struct(ev_classes[i].klass, 0, free, xev);
      ev_classes[i].function(event);

      return event;
    }
  }

  return Data_Wrap_Struct(cEvent, 0, free, xev);
}

void event_make_configure_request(VALUE self) {
  set_xev(self);

  rb_ivar_set(self, rb_intern("@window_id"), INT2NUM(xev->xconfigurerequest.window));
}

void event_make_destroy_notify(VALUE self) {
  set_xev(self);
}

void event_make_expose(VALUE self) {
  set_xev(self);
}

void event_make_key_press(VALUE self) {
  set_xev(self);
  KeySym ks;

  ks = XkbKeycodeToKeysym(xev->xany.display, xev->xkey.keycode, 0, 0);
  if (ks == NoSymbol)
    return;

  rb_ivar_set(self, rb_intern("@key"), ID2SYM(rb_intern(XKeysymToString(ks))));
}

void event_make_map_request(VALUE self) {
  set_xev(self);

  rb_ivar_set(self, rb_intern("@window_id"), INT2NUM(xev->xconfigurerequest.window));
}

void event_make_property_notify(VALUE self) {
  set_xev(self);
}

void event_make_unmap_notify(VALUE self) {
  set_xev(self);
}
