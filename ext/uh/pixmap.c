#include "uh.h"


#define SET_PIXMAP(x) \
  UhPixmap *pixmap;\
  Data_Get_Struct(x, UhPixmap, pixmap);

#define DPY     pixmap->dpy
#define PIXMAP  pixmap->pixmap
#define GC      pixmap->gc


void pixmap_deallocate(UhPixmap *p);


VALUE pixmap_draw_rect(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h) {
  SET_PIXMAP(self)

  XFillRectangle(DPY, PIXMAP, GC,
    FIX2INT(x), FIX2INT(y), FIX2INT(w), FIX2INT(h)
  );

  return Qnil;
}

VALUE pixmap_draw_string(VALUE self, VALUE x, VALUE y, VALUE str) {
  SET_PIXMAP(self)

  XDrawString(DPY, PIXMAP, GC,
    FIX2INT(x), FIX2INT(y), RSTRING_PTR(str), RSTRING_LEN(str)
  );

  return Qnil;
}

VALUE pixmap_gc_black(VALUE self) {
  SET_PIXMAP(self)

  XSetForeground(DPY, GC, BlackPixel(DPY, SCREEN_DEFAULT));

  return Qnil;
}

VALUE pixmap_gc_color(VALUE self, VALUE rcolor) {
  SET_PIXMAP(self)

  XSetForeground(DPY, GC, NUM2LONG(rb_ivar_get(rcolor, rb_intern("@pixel"))));

  return Qnil;
}

VALUE pixmap_gc_white(VALUE self) {
  SET_PIXMAP(self)

  XSetForeground(DPY, GC, WhitePixel(DPY, SCREEN_DEFAULT));

  return Qnil;
}


VALUE pixmap_copy(VALUE self, VALUE rwindow) {
  SET_PIXMAP(self)

  XCopyArea(DPY, PIXMAP,
    FIX2INT(rb_funcall(rwindow, rb_intern("id"), 0)),
    GC,
    0, 0,
    FIX2INT(rb_ivar_get(self, rb_intern("@width"))),
    FIX2INT(rb_ivar_get(self, rb_intern("@height"))),
    0, 0
  );

  return Qnil;
}


VALUE pixmap_make(Display *display, Pixmap xpixmap, VALUE width, VALUE height) {
  UhPixmap  *pixmap;
  VALUE     obj;

  obj = Data_Make_Struct(cPixmap, UhPixmap, 0, pixmap_deallocate, pixmap);
  pixmap->dpy     = display;
  pixmap->pixmap  = xpixmap;
  pixmap->gc      = XCreateGC(display, DefaultRootWindow(display), 0, NULL);

  rb_ivar_set(obj, rb_intern("@width"), width);
  rb_ivar_set(obj, rb_intern("@height"), height);

  return obj;
}


void pixmap_deallocate(UhPixmap *pixmap) {
  XFreePixmap(DPY, PIXMAP);
  XFreeGC(DPY, GC);
  free(pixmap);
}
