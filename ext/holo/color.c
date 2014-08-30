#include "holo.h"


VALUE color_make(unsigned long pixel) {
  VALUE obj;
  VALUE args[0];

  obj = rb_class_new_instance(0, args, cColor);
  rb_ivar_set(obj, rb_intern("@pixel"), LONG2NUM(pixel));

  return obj;
}
