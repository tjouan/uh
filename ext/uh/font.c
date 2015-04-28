#include "uh.h"


VALUE font_make(Display *dpy);


VALUE font_s_new(VALUE klass, VALUE rdisplay) {
  SET_DISPLAY(rdisplay);

  rb_funcall(rdisplay, rb_intern("check!"), 0);

  return font_make(display->dpy);
}


VALUE font_make(Display *dpy) {
  XFontStruct *xfs;
  VALUE       rfont;
  VALUE       args[0];

  if (!(xfs = XQueryFont(dpy,
      XGContextFromGC(DefaultGC(dpy, DefaultScreen(dpy))))))
    rb_raise(eDisplayError, "cannot query font");
  rfont = rb_class_new_instance(0, args, cFont);
  rb_ivar_set(rfont, rb_intern("@width"), INT2FIX(xfs->max_bounds.width));
  rb_ivar_set(rfont, rb_intern("@ascent"), INT2FIX(xfs->ascent));
  rb_ivar_set(rfont, rb_intern("@descent"), INT2FIX(xfs->descent));
  XFreeFontInfo(NULL, xfs, 1);

  return rfont;
}
