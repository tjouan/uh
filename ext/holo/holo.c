#include "holo.h"

void Init_holo(void) {
  VALUE mHolo;
  VALUE cDisplay;
  VALUE mXlib;
  VALUE cXlibDisplay;

  mHolo = rb_define_module("Holo");

  eHoloDisplayError = rb_define_class_under(
    mHolo, "DisplayError", rb_eStandardError
  );

  cDisplay = rb_define_class_under(mHolo, "Display", rb_cObject);
  rb_define_alloc_func(cDisplay, display_alloc);
  rb_define_attr(cDisplay, "name", 1, 0);
  rb_define_method(cDisplay, "initialize", display_init, -1);
  rb_define_method(cDisplay, "open", display_open, 0);
  rb_define_method(cDisplay, "close", display_close, 0);

  mXlib = rb_define_module_under(rb_define_module("Holo"), "Xlib");

  cXlibDisplay = rb_define_class_under(mXlib, "Display", rb_cObject);
  rb_define_alloc_func(cXlibDisplay, xlib_display_alloc);
  rb_define_method(cXlibDisplay, "close", xlib_display_close, 0);
}
