#include "holo.h"


VALUE font_make(int ascent, int descent) {
  VALUE obj;
  VALUE args[0];

  obj = rb_class_new_instance(0, args, cFont);
  rb_ivar_set(obj, rb_intern("@ascent"), INT2NUM(ascent));
  rb_ivar_set(obj, rb_intern("@descent"), INT2NUM(descent));

  return obj;
}
