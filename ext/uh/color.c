#include "uh.h"


#define DPY display->dpy


VALUE color_s_new(VALUE klass, VALUE rdisplay, VALUE rcolor_name) {
  Colormap  map;
  XColor    color;
  SET_DISPLAY(rdisplay);

  if (!DPY)
    rb_raise(eDisplayError, "display not opened");
  StringValue(rcolor_name);

  map = DefaultColormap(DPY, SCREEN_DEFAULT);

  if (!XAllocNamedColor(DPY, map, RSTRING_PTR(rcolor_name), &color, &color)) {
    rb_raise(eArgumentError, "invalid color name `%s'",
      RSTRING_PTR(rcolor_name)
    );
  }

  return color_make(color.pixel);
}


VALUE color_make(unsigned long pixel) {
  VALUE obj;
  VALUE args[0];

  obj = rb_class_new_instance(0, args, cColor);
  rb_ivar_set(obj, rb_intern("@pixel"), LONG2NUM(pixel));

  return obj;
}
