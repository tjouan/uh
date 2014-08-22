#include "holo.h"


VALUE event_alloc(VALUE klass) {
  XEvent *xev;

  xev = calloc(1, sizeof(*xev));

  return Data_Wrap_Struct(klass, 0, free, xev);
}

VALUE event_make(XEvent *xev) {
  VALUE ev;

  ev = Data_Wrap_Struct(cEvent, 0, free, xev);

  return ev;
}

/*
VALUE event_alloc(VALUE klass) {
  VALUE     obj;
  HoloEvent *event;

  obj = Data_Make_Struct(klass, HoloEvent, 0, event_free, event);

  return obj;
}

VALUE event_init(int ac, VALUE *av, VALUE self) {
  VALUE name;

  rb_scan_args(ac, av, "01", &name);

  if (NIL_P(name)) {
    name = Qnil;
  }

  rb_iv_set(self, "@name", name);

  return self;
}
*/
