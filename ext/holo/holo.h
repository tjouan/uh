#ifndef RUBY_HOLO
#define RUBY_HOLO

#include <ruby.h>

#include <X11/Xlib.h>
#include <X11/XKBlib.h>


#define set_display(x) \
  HoloDisplay *display;\
  Data_Get_Struct(x, HoloDisplay, display);

#define DPY           display->dpy
#define ROOT_DEFAULT  DefaultRootWindow(DPY)


typedef struct s_display  HoloDisplay;
typedef struct s_window   HoloWindow;

struct s_display {
  Display *dpy;
};

struct s_window {
  Display *dpy;
  Window  id;
};


VALUE mHolo, mEvents,
  cDisplay,
  cEvent, cConfigureRequest, cDestroyNotify, cExpose, cKeyPress, cMapRequest,
    cPropertyNotify, cUnmapNotify,
  cScreen,
  cWindow,
  eDisplayError;


VALUE display_s_on_error(VALUE klass, VALUE handler);
VALUE display_alloc(VALUE klass);
VALUE display_init(VALUE self);
VALUE display_open(VALUE self);
VALUE display_close(VALUE self);
VALUE display_screens(VALUE self);
VALUE display_next_event(VALUE self);
VALUE display_listen_events(VALUE self, VALUE mask);
VALUE display_sync(VALUE self, VALUE discard);
VALUE display_root_change_attributes(VALUE self, VALUE mask);
VALUE display_grab_key(VALUE self, VALUE key);

VALUE event_alloc(VALUE klass);
VALUE event_window(VALUE self);
VALUE event_make(XEvent *xev);

VALUE screen_init(VALUE self, VALUE id, VALUE x, VALUE y, VALUE w, VALUE h);

VALUE window_s_configure(VALUE klass, VALUE rdisplay, VALUE window_id);
VALUE window__moveresize(VALUE self, VALUE x, VALUE y, VALUE width, VALUE height);
VALUE window_map(VALUE self);


#endif
