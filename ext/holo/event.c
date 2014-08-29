#include "holo.h"


#define set_xev(x) \
  XEvent *xev;\
  Data_Get_Struct(x, XEvent, xev);


VALUE event_make_event(VALUE klass, XEvent *xev);
void event_make_key_any(VALUE self);


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  return Data_Make_Struct(klass, XEvent, 0, free, xev);
}

VALUE event_window(VALUE self) {
  set_xev(self);

  switch (xev->type) {
    case ConfigureRequest:
      return window_make(xev->xany.display, xev->xconfigurerequest.window);
    case DestroyNotify:
    case MapRequest:
    case UnmapNotify:
      return window_make(xev->xany.display, xev->xmaprequest.window);
  }

  return Qnil;
}


VALUE event_make(XEvent *xev) {
  typedef struct {
    int   type;
    VALUE klass;
    void  (*function)(VALUE self);
  } EvClass;
  EvClass ev_classes[] = {
    {ConfigureRequest,  cConfigureRequest,  NULL},
    {DestroyNotify,     cDestroyNotify,     NULL},
    {Expose,            cExpose,            NULL},
    {KeyPress,          cKeyPress,          event_make_key_any},
    {KeyRelease,        cKeyRelease,        event_make_key_any},
    {MapRequest,        cMapRequest,        NULL},
    {PropertyNotify,    cPropertyNotify,    NULL},
    {UnmapNotify,       cUnmapNotify,       NULL}
  };
  int   i;
  VALUE event;

  for (i = 0; i < (sizeof ev_classes / sizeof ev_classes[0]); i++) {
    if (ev_classes[i].type == xev->type) {
      event = event_make_event(ev_classes[i].klass, xev);

      if (ev_classes[i].function)
        ev_classes[i].function(event);

      return event;
    }
  }

  return event_make_event(cEvent, xev);
}

VALUE event_make_event(VALUE klass, XEvent *xev) {
  char *type_descs[LASTEvent];
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

  event = Data_Wrap_Struct(klass, 0, free, xev);
  rb_ivar_set(event, rb_intern("@type"), ID2SYM(rb_intern(type_descs[xev->type])));

  return event;
}

void event_make_key_any(VALUE self) {
  set_xev(self);
  KeySym ks;

  ks = XkbKeycodeToKeysym(xev->xany.display, xev->xkey.keycode, 0, 0);
  if (ks == NoSymbol)
    return;

  rb_ivar_set(self, rb_intern("@key"), rb_str_new_cstr(XKeysymToString(ks)));
  rb_ivar_set(self, rb_intern("@mod"), INT2FIX(xev->xkey.state));
}
