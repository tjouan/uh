#include "uh.h"


#define SET_IMAGE(x) \
  UhImage *image;\
  Data_Get_Struct(x, UhImage, image);

#define DPY   image->dpy
#define IMAGE image->image
#define GC    image->gc


void image_deallocate(UhImage *image);


VALUE image_s_new(VALUE klass, VALUE rdisplay, VALUE rwidth, VALUE rheight, VALUE rdata) {
  VALUE rimage;
  SET_DISPLAY(rdisplay);

  rb_funcall(rdisplay, rb_intern("check!"), 0);

  StringValue(rdata);
  rimage = image_make(
    display->dpy,
    FIX2INT(rwidth),
    FIX2INT(rheight),
    RSTRING_PTR(rdata)
  );

  return rimage;
}


VALUE image_put(VALUE self, VALUE rwindow) {
  SET_IMAGE(self);

  XPutImage(
    DPY,
    FIX2INT(rb_funcall(rwindow, rb_intern("id"), 0)),
    GC,
    IMAGE,
    0, 0,
    0, 0,
    IMAGE->width, IMAGE->height
  );

  return Qnil;
}


VALUE image_make(Display *dpy, int width, int height, char *data) {
  UhImage *image;
  VALUE   rimage;

  rimage = Data_Make_Struct(cImage, UhImage, 0, image_deallocate, image);
  image->dpy    = dpy;
  image->gc     = XCreateGC(dpy, ROOT_DEFAULT, 0, NULL);
  image->image  = XCreateImage(
    DPY,
    DefaultVisual(DPY, DefaultScreen(DPY)),
    DEPTH_DEFAULT,
    ZPixmap, 0,
    data, width, height,
    32, 0
  );

  return rimage;
}


void image_deallocate(UhImage *image) {
  XDestroyImage(IMAGE);
  free(image);
}
