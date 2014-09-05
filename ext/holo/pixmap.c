#include "holo.h"


#define set_pixmap(x) \
  HoloPixmap *pixmap;\
  Data_Get_Struct(x, HoloPixmap, pixmap);

#define DPY     pixmap->dpy
#define PIXMAP  pixmap->pixmap
#define GC      pixmap->gc


void pixmap_deallocate(HoloPixmap *p);


VALUE pixmap_draw_rect(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h) {
  set_pixmap(self);

  XFillRectangle(DPY, PIXMAP, GC,
    FIX2INT(x), FIX2INT(y), FIX2INT(w), FIX2INT(h)
  );

  return Qnil;
}

VALUE pixmap_draw_string(VALUE self, VALUE x, VALUE y, VALUE str) {
  set_pixmap(self);

  XDrawString(DPY, PIXMAP, GC,
    FIX2INT(x), FIX2INT(y), RSTRING_PTR(str), RSTRING_LEN(str)
  );

  return Qnil;
}

VALUE pixmap_gc_black(VALUE self) {
  set_pixmap(self);

  XSetForeground(DPY, GC, BlackPixel(DPY, SCREEN_DEFAULT));

  return Qnil;
}

VALUE pixmap_gc_color(VALUE self, VALUE rcolor) {
  set_pixmap(self);

  XSetForeground(DPY, GC, NUM2LONG(rb_ivar_get(rcolor, rb_intern("@pixel"))));

  return Qnil;
}

VALUE pixmap_gc_white(VALUE self) {
  set_pixmap(self);

  XSetForeground(DPY, GC, WhitePixel(DPY, SCREEN_DEFAULT));

  return Qnil;
}


VALUE pixmap__copy(VALUE self, VALUE rwindow_id, VALUE rwidth, VALUE rheight) {
  set_pixmap(self);

  XCopyArea(DPY, PIXMAP, FIX2INT(rwindow_id), GC,
    0, 0, FIX2INT(rwidth), FIX2INT(rheight), 0, 0
  );

  return Qnil;
}


VALUE pixmap_make(Display *display, Pixmap xpixmap, VALUE width, VALUE height) {
  HoloPixmap  *pixmap;
  VALUE       obj;

  obj = Data_Make_Struct(cPixmap, HoloPixmap, 0, pixmap_deallocate, pixmap);
  pixmap->dpy     = display;
  pixmap->pixmap  = xpixmap;
  pixmap->gc      = XCreateGC(display, DefaultRootWindow(display), 0, NULL);

  rb_ivar_set(obj, rb_intern("@width"), width);
  rb_ivar_set(obj, rb_intern("@height"), height);

  return obj;
}


void pixmap_deallocate(HoloPixmap *pixmap) {
  XFreePixmap(DPY, PIXMAP);
  XFreeGC(DPY, GC);
  free(pixmap);
}
