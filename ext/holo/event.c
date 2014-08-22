#include "holo.h"


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  xev = calloc(1, sizeof(*xev));

  return Data_Wrap_Struct(klass, 0, free, xev);
}


VALUE event_make(XEvent *xev) {
  typedef struct {
    int   type;
    VALUE klass;
  } EvClass;
  EvClass ev_classes[] = {
    {ConfigureRequest,  cConfigureRequest},
    {DestroyNotify,     cDestroyNotify},
    {Expose,            cExpose},
    {KeyPress,          cKeyPress},
    {MapRequest,        cMapRequest},
    {PropertyNotify,    cPropertyNotify},
    {UnmapNotify,       cUnmapNotify}
  };
  int   i;
  VALUE klass;

  for (i = 0; i < (sizeof ev_classes / sizeof ev_classes[0]); i++)
    if (ev_classes[i].type == xev->type)
      return Data_Wrap_Struct(ev_classes[i].klass, 0, free, xev);

  return Data_Wrap_Struct(cEvent, 0, free, xev);
  /*
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
  */
}

//rb_define_attr(VALUE klass, const char *name, int read, int writen
