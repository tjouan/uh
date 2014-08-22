#include "holo.h"


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  xev = calloc(1, sizeof(*xev));

  return Data_Wrap_Struct(klass, 0, free, xev);
}


VALUE event_make(XEvent *xev) {
  VALUE klass;

  switch (xev->type) {
    case KeyPress:
      klass = cKeyPress;
      break;
    case MappingNotify:
      klass = cMappingNotify;
      break;
    default:
      klass = cEvent;
      break;
  }

  return Data_Wrap_Struct(klass, 0, free, xev);
}
