#include "uh.h"


#define SET_XEV(x) \
  XEvent *xev;\
  Data_Get_Struct(x, XEvent, xev);


VALUE event_make_event(VALUE klass, XEvent *xev);
void event_make_configure_request(VALUE self);
void event_make_key_any(VALUE self);
void event_make_win_any(VALUE self);


VALUE event_make(XEvent *xev) {
  typedef struct {
    int   type;
    VALUE klass;
    void  (*function)(VALUE self);
  } EvClass;
  EvClass       ev_classes[] = {
    {ConfigureRequest,  cConfigureRequest,  event_make_configure_request},
    {DestroyNotify,     cDestroyNotify,     NULL},
    {Expose,            cExpose,            NULL},
    {KeyPress,          cKeyPress,          event_make_key_any},
    {KeyRelease,        cKeyRelease,        event_make_key_any},
    {MapRequest,        cMapRequest,        NULL},
    {PropertyNotify,    cPropertyNotify,    NULL},
    {UnmapNotify,       cUnmapNotify,       NULL}
  };
  unsigned int  i;
  VALUE         event;

  for (i = 0; i < (sizeof ev_classes / sizeof ev_classes[0]); i++) {
    if (ev_classes[i].type == xev->type) {
      event = event_make_event(ev_classes[i].klass, xev);
      event_make_win_any(event);
      if (ev_classes[i].function)
        ev_classes[i].function(event);

      return event;
    }
  }

  return event_make_event(cEvent, xev);
}

VALUE event_make_event(VALUE klass, XEvent *xev) {
  const char  *type_descs[LASTEvent];
  VALUE       event;

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

  event = Data_Wrap_Struct(klass, 0, 0, xev);
  rb_ivar_set(event, rb_intern("@type"),
    ID2SYM(rb_intern(type_descs[xev->type])));

  return event;
}

void event_make_configure_request(VALUE self) {
  SET_XEV(self);

  if (xev->xconfigurerequest.value_mask & CWX)
    rb_ivar_set(self, rb_intern("@x"), INT2FIX(xev->xconfigurerequest.x));

  if (xev->xconfigurerequest.value_mask & CWY)
    rb_ivar_set(self, rb_intern("@y"), INT2FIX(xev->xconfigurerequest.y));

  if (xev->xconfigurerequest.value_mask & CWWidth)
    rb_ivar_set(self, rb_intern("@width"),
      INT2FIX(xev->xconfigurerequest.width));

  if (xev->xconfigurerequest.value_mask & CWHeight)
    rb_ivar_set(self, rb_intern("@height"),
      INT2FIX(xev->xconfigurerequest.height));

  rb_ivar_set(self, rb_intern("@above_window_id"),
    LONG2NUM(xev->xconfigurerequest.above));
  rb_ivar_set(self, rb_intern("@detail"),
    INT2FIX(xev->xconfigurerequest.detail));
  rb_ivar_set(self, rb_intern("@value_mask"),
    LONG2NUM(xev->xconfigurerequest.detail));
}

void event_make_key_any(VALUE self) {
  KeySym ks;
  SET_XEV(self);

  ks = XkbKeycodeToKeysym(xev->xany.display, xev->xkey.keycode, 0, 0);
  if (ks == NoSymbol)
    return;

  rb_ivar_set(self, rb_intern("@key"), rb_str_new_cstr(XKeysymToString(ks)));
  rb_ivar_set(self, rb_intern("@modifier_mask"), INT2FIX(xev->xkey.state));
}

void event_make_win_any(VALUE self) {
  Window window;
  SET_XEV(self);

  switch (xev->type) {
    case ConfigureRequest:
      window = xev->xconfigurerequest.window;
      break;
    case DestroyNotify:
      window = xev->xdestroywindow.window;
      break;
    case Expose:
      window = xev->xexpose.window;
      break;
    case KeyPress:
      window = xev->xkey.window;
      break;
    case MapRequest:
      window = xev->xmaprequest.window;
      break;
    case PropertyNotify:
      window = xev->xproperty.window;
      break;
    case UnmapNotify:
      rb_ivar_set(self, rb_intern("@event_window"),
        window_make(xev->xany.display, xev->xunmap.event));
      window = xev->xunmap.window;
      break;
    default:
      window = xev->xany.window;
      break;
  }

  rb_ivar_set(self, rb_intern("@window"),
    window_make(xev->xany.display, window));
}
