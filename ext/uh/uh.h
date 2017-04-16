#ifndef RUBY_UH
#define RUBY_UH

#include <ruby.h>

#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/Xinerama.h>


#define SET_DISPLAY(x) \
  UhDisplay *display;\
  Data_Get_Struct(x, UhDisplay, display);

#define ROOT_DEFAULT    DefaultRootWindow(DPY)
#define SCREEN_DEFAULT  DefaultScreen(DPY)


typedef struct s_display  UhDisplay;
typedef struct s_pixmap   UhPixmap;
typedef struct s_window   UhWindow;

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


VALUE mUh, mEvents,
  cColor,
  cDisplay,
  cEvent, cConfigureRequest, cDestroyNotify, cExpose, cKeyPress, cKeyRelease,
    cMapRequest, cPropertyNotify, cUnmapNotify,
  cFont,
  cPixmap,
  cScreen,
  cWindow,
  eError, eRuntimeError, eArgumentError, eDisplayError;


VALUE color_s_new(VALUE klass, VALUE display, VALUE color_name);

VALUE display_s_on_error(VALUE klass);
VALUE display_alloc(VALUE klass);
VALUE display_close(VALUE self);
VALUE display_each_event(VALUE self);
VALUE display_fileno(VALUE self);
VALUE display_flush(VALUE self);
VALUE display_grab_key(VALUE self, VALUE key, VALUE modifier);
VALUE display_listen_events(int argc, VALUE *argv, VALUE self);
VALUE display_next_event(VALUE self);
VALUE display_open(VALUE self);
VALUE display_opened_p(VALUE self);
VALUE display_pending(VALUE self);
VALUE display_root(VALUE self);
VALUE display_root_change_attributes(VALUE self, VALUE mask);
VALUE display_screens(VALUE self);
VALUE display_sync(VALUE self, VALUE discard);

VALUE event_make(XEvent *xev);

VALUE font_s_new(VALUE klass, VALUE rdisplay);

VALUE pixmap_s_new(VALUE klass, VALUE rdisplay, VALUE rwidth, VALUE rheight);
VALUE pixmap_copy(VALUE self, VALUE rwindow);
VALUE pixmap_draw_rect(VALUE self, VALUE x, VALUE y, VALUE w, VALUE h);
VALUE pixmap_draw_string(VALUE self, VALUE x, VALUE y, VALUE str);
VALUE pixmap_gc_black(VALUE self);
VALUE pixmap_gc_color(VALUE self, VALUE rcolor);
VALUE pixmap_gc_white(VALUE self);
VALUE pixmap_make(Display *dpy, int w, int h);

VALUE screen_init(VALUE self, VALUE id, VALUE x, VALUE y, VALUE w, VALUE h);

VALUE window_s_new(VALUE klass, VALUE rdisplay, VALUE rwindow_id);
VALUE window_configure(VALUE self, VALUE rgeo);
VALUE window_configure_event(VALUE self, VALUE rgeo);
VALUE window_create(VALUE self, VALUE rgeo);
VALUE window_create_sub(VALUE self, VALUE rgeo);
VALUE window_cursor_set(VALUE self, VALUE cursor);
VALUE window_destroy(VALUE self);
VALUE window_focus(VALUE self);
VALUE window_icccm_wm_delete(VALUE self);
VALUE window_icccm_wm_protocols(VALUE self);
VALUE window_kill(VALUE self);
VALUE window_map(VALUE self);
VALUE window_mask(VALUE self);
VALUE window_mask_set(VALUE self, VALUE mask);
VALUE window_moveresize(VALUE self, VALUE rgeo);
VALUE window_name(VALUE self);
VALUE window_name_set(VALUE self, VALUE name);
VALUE window_override_redirect(VALUE self);
VALUE window_raise(VALUE self);
VALUE window_unmap(VALUE self);
VALUE window_wclass(VALUE self);
VALUE window_wclass_set(VALUE self, VALUE rwclass);
int window_id(VALUE window);
VALUE window_make(Display *display, Window window_id);


#endif
