#include "uh.h"


VALUE screen_init(VALUE self, VALUE rid, VALUE rx, VALUE ry, VALUE rw, VALUE rh) {
  rb_ivar_set(self, rb_intern("@id"), rid);
  rb_ivar_set(self, rb_intern("@x"), rx);
  rb_ivar_set(self, rb_intern("@y"), ry);
  rb_ivar_set(self, rb_intern("@width"), rw);
  rb_ivar_set(self, rb_intern("@height"), rh);

  return self;
}
