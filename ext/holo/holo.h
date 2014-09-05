#ifndef RUBY_HOLO
#define RUBY_HOLO

#include <ruby.h>

#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/Xinerama.h>


#define set_display(x) \
  HoloDisplay *display;\
  Data_Get_Struct(x, HoloDisplay, display);

#define DPY             display->dpy
#define ROOT_DEFAULT    DefaultRootWindow(DPY)
#define SCREEN_DEFAULT  DefaultScreen(DPY)


typedef struct s_display  HoloDisplay;
typedef struct s_pixmap   HoloPixmap;
typedef struct s_window   HoloWindow;

struct s_display {
  Display *dpy;
};

struct s_pixmap {
  Display *dpy;
  Pixmap  pixmap;
  GC      gc;
};

struct s_window {
  Display *dpy;
  Window  id;
};


VALUE mHolo, mEvents,
  cColor,
  cDisplay,
  cEvent, cConfigureRequest, cDestroyNotify, cExpose, cKeyPress, cKeyRelease,
    cMapRequest, cPropertyNotify, cUnmapNotify,
  cFont,
  cPixmap,
  cScreen,
  cWindow,
  eDisplayError;


VALUE color_make(unsigned long pixel);

VALUE display_s_on_error(VALUE klass, VALUE handler);
VALUE display_alloc(VALUE klass);
VALUE display_close(VALUE self);
VALUE display_color_by_name(VALUE self, VALUE rcolor);
VALUE display_create_pixmap(VALUE self, VALUE w, VALUE h);
VALUE display_each_event(VALUE self);
VALUE display_grab_key(VALUE self, VALUE key, VALUE modifier);
VALUE display_listen_events(VALUE self, VALUE mask);
VALUE display_open(VALUE self);
VALUE display_query_font(VALUE self);
VALUE display_root(VALUE self);
VALUE display_root_change_attributes(VALUE self, VALUE mask);
VALUE display_screens(VALUE self);
VALUE display_sync(VALUE self, VALUE discard);

VALUE event_window(VALUE self);
VALUE event_make(XEvent *xev);

VALUE font_make(int ascent, int descent);

VALUE pixmap__copy(VALUE self, VALUE rwindow_id, VALUE rwidth, VALUE rheight);
VALUE pixmap_draw_rect(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h);
VALUE pixmap_draw_string(VALUE self, VALUE x, VALUE y, VALUE str);
VALUE pixmap_gc_black(VALUE self);
VALUE pixmap_gc_color(VALUE self, VALUE rcolor);
VALUE pixmap_gc_white(VALUE self);
VALUE pixmap_make(Display *display, Pixmap xpixmap, VALUE width, VALUE height);

VALUE screen_init(VALUE self, VALUE id, VALUE x, VALUE y, VALUE w, VALUE h);

VALUE window_focus(VALUE self);
VALUE window_kill(VALUE self);
VALUE window_map(VALUE self);
VALUE window_mask_set(VALUE self, VALUE mask);
VALUE window_name(VALUE self);
VALUE window_override_redirect(VALUE self);
VALUE window_raise(VALUE self);
VALUE window_unmap(VALUE self);
VALUE window_wclass(VALUE self);
VALUE window__configure(VALUE self, VALUE rx, VALUE ry, VALUE rw, VALUE rh);
VALUE window__configure_event(VALUE self, VALUE rx, VALUE ry, VALUE rw, VALUE rh);
VALUE window__create_sub(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h);
VALUE window__moveresize(VALUE self, VALUE x, VALUE y, VALUE width, VALUE height);
VALUE window_make(Display *display, Window window_id);


#endif
