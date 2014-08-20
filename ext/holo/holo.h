#ifndef RUBY_HOLO
#define RUBY_HOLO

#include <ruby.h>

#include <X11/Xlib.h>

typedef struct s_display   HoloDisplay;

struct s_display {
  Display *dpy;
};


VALUE eHoloDisplayError;


VALUE display_alloc(VALUE klass);
VALUE display_init(int ac, VALUE *av, VALUE self);
VALUE display_close(VALUE self);

VALUE xlib_display_alloc(VALUE klass);
VALUE xlib_display_init(int ac, VALUE *av, VALUE self);
VALUE display_open(VALUE self);
VALUE xlib_display_close(VALUE self);


#endif
