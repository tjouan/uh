#include "holo.h"


#define set_xev(x) \
  XEvent *xev;\
  Data_Get_Struct(x, XEvent, xev);


VALUE event_make_event(VALUE klass, XEvent *xev);
void event_make_configure_request(VALUE self);
void event_make_destroy_notify(VALUE self);
void event_make_expose(VALUE self);
void event_make_key_press(VALUE self);
void event_make_map_request(VALUE self);
void event_make_property_notify(VALUE self);
void event_make_unmap_notify(VALUE self);


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  return Data_Make_Struct(klass, XEvent, 0, free, xev);
}

VALUE event_window(VALUE self) {
  set_xev(self);
  HoloWindow  *window;
  VALUE       obj;

  obj = Qnil;
  if (xev->type == ConfigureRequest ||
      xev->type == MapRequest) {
    obj = Data_Make_Struct(cWindow, HoloWindow, 0, free, window);
    window->dpy = xev->xany.display;
    switch (xev->type) {
      case ConfigureRequest:
        window->id = xev->xconfigurerequest.window;
        break;
      case MapRequest:
        window->id = xev->xmaprequest.window;
        break;
    }
  }

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
      event = event_make_event(ev_classes[i].klass, xev);
      ev_classes[i].function(event);

      return event;
    }
  }

  return event_make_event(cEvent, xev);
}

VALUE event_make_event(VALUE klass, XEvent *xev) {
  char *type_descs[37];
  VALUE event;

  type_descs[KeyPress]          = "key_press";
  type_descs[KeyRelease]        = "key_release";
  type_descs[ButtonPress]       = "button_press";
  type_descs[ButtonRelease]     = "button_release";
  type_descs[MotionNotify]      = "motion_notify";
  type_descs[EnterNotify]       = "enter_notify";
  type_descs[LeaveNotify]       = "leave_notify";
  type_descs[FocusIn]           = "focus_in";
  type_descs[FocusOut]          = "focus_out";
  type_descs[KeymapNotify]      = "keymap_notify";
  type_descs[Expose]            = "expose";
  type_descs[GraphicsExpose]    = "graphics_expose";
  type_descs[NoExpose]          = "no_expose";
  type_descs[VisibilityNotify]  = "visibility_notify";
  type_descs[CreateNotify]      = "create_notify";
  type_descs[DestroyNotify]     = "destroy_notify";
  type_descs[UnmapNotify]       = "unmap_notify";
  type_descs[MapNotify]         = "map_notify";
  type_descs[MapRequest]        = "map_request";
  type_descs[ReparentNotify]    = "reparent_notify";
  type_descs[ConfigureNotify]   = "configure_notify";
  type_descs[ConfigureRequest]  = "configure_request";
  type_descs[GravityNotify]     = "gravity_notify";
  type_descs[ResizeRequest]     = "resize_request";
  type_descs[CirculateNotify]   = "circulate_notify";
  type_descs[CirculateRequest]  = "circulate_request";
  type_descs[PropertyNotify]    = "property_notify";
  type_descs[SelectionClear]    = "selection_clear";
  type_descs[SelectionRequest]  = "selection_request";
  type_descs[SelectionNotify]   = "selection_notify";
  type_descs[ColormapNotify]    = "colormap_notify";
  type_descs[ClientMessage]     = "client_message";
  type_descs[MappingNotify]     = "mapping_notify";
  type_descs[GenericEvent]      = "generic";
  type_descs[LASTEvent]         = "last";

  event = Data_Wrap_Struct(klass, 0, free, xev);
  rb_ivar_set(event, rb_intern("@type"), ID2SYM(rb_intern(type_descs[xev->type])));

  return event;
}

void event_make_configure_request(VALUE self) {
  set_xev(self);

  rb_ivar_set(self, rb_intern("@window_id"), LONG2NUM(xev->xconfigurerequest.window));
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

  rb_ivar_set(self, rb_intern("@window_id"), LONG2NUM(xev->xmaprequest.window));
}

void event_make_property_notify(VALUE self) {
  set_xev(self);
}

void event_make_unmap_notify(VALUE self) {
  set_xev(self);
}
