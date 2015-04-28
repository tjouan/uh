#include "uh.h"


#define SET_PIXMAP(x) \
  UhPixmap *pixmap;\
  Data_Get_Struct(x, UhPixmap, pixmap);

#define DPY           pixmap->dpy
#define PIXMAP        pixmap->pixmap
#define GC            pixmap->gc
#define DEPTH_DEFAULT DefaultDepth(DPY, SCREEN_DEFAULT)


void pixmap_deallocate(UhPixmap *p);


VALUE pixmap_s_new(VALUE klass, VALUE rdisplay, VALUE rwidth, VALUE rheight) {
  VALUE rpixmap;
  SET_DISPLAY(rdisplay);

  rpixmap = pixmap_make(display->dpy, FIX2INT(rwidth), FIX2INT(rheight));
  rb_ivar_set(rpixmap, rb_intern("@width"), rwidth);
  rb_ivar_set(rpixmap, rb_intern("@height"), rheight);

  return rpixmap;
}


VALUE pixmap_draw_rect(VALUE self, VALUE rx, VALUE ry, VALUE rw, VALUE rh) {
  SET_PIXMAP(self)

  XFillRectangle(DPY, PIXMAP, GC,
    FIX2INT(rx), FIX2INT(ry), FIX2INT(rw), FIX2INT(rh)
  );

  return Qnil;
}

VALUE pixmap_draw_string(VALUE self, VALUE rx, VALUE ry, VALUE rstr) {
  SET_PIXMAP(self)

  StringValue(rstr);
  XDrawString(DPY, PIXMAP, GC,
    FIX2INT(rx), FIX2INT(ry), RSTRING_PTR(rstr), RSTRING_LEN(rstr)
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

  XSetForeground(DPY, GC, NUM2LONG(rb_funcall(rcolor, rb_intern("pixel"), 0)));

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


VALUE pixmap_make(Display *dpy, int w, int h) {
  UhPixmap  *pixmap;
  VALUE     rpixmap;

  rpixmap = Data_Make_Struct(cPixmap, UhPixmap, 0, pixmap_deallocate, pixmap);
  pixmap->dpy     = dpy;
  pixmap->pixmap  = XCreatePixmap(dpy, ROOT_DEFAULT, w, h, DEPTH_DEFAULT);
  pixmap->gc      = XCreateGC(dpy, ROOT_DEFAULT, 0, NULL);

  return rpixmap;
}


void pixmap_deallocate(UhPixmap *pixmap) {
  XFreePixmap(DPY, PIXMAP);
  XFreeGC(DPY, GC);
  free(pixmap);
}
