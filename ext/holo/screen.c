#include "holo.h"


VALUE screen_init(VALUE self, VALUE id, VALUE x, VALUE y, VALUE w, VALUE h) {
  rb_ivar_set(self, rb_intern("@id"), id);
  rb_ivar_set(self, rb_intern("@x"), x);
  rb_ivar_set(self, rb_intern("@y"), y);
  rb_ivar_set(self, rb_intern("@width"), w);
  rb_ivar_set(self, rb_intern("@height"), h);

  return self;
}
