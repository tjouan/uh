#include "uh.h"


VALUE color_make(Display *dpy, char *color_name);


VALUE color_s_new(VALUE klass, VALUE rdisplay, VALUE rcolor_name) {
  SET_DISPLAY(rdisplay);

  rb_funcall(rdisplay, rb_intern("check!"), 0);
  StringValue(rcolor_name);

  return color_make(display->dpy, RSTRING_PTR(rcolor_name));
}


VALUE color_make(Display *dpy, char *color_name) {
  Colormap  map;
  XColor    color;
  VALUE     rcolor;
  VALUE     args[0];

  map = DefaultColormap(dpy, DefaultScreen(dpy));
  if (!XAllocNamedColor(dpy, map, color_name, &color, &color))
    rb_raise(eArgumentError, "invalid color name `%s'", color_name);
  rcolor = rb_class_new_instance(0, args, cColor);
  rb_ivar_set(rcolor, rb_intern("@pixel"), LONG2NUM(color.pixel));

  return rcolor;
}
