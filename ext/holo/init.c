#include "holo.h"


void holo_color();
void holo_display();
void holo_events();
void holo_font();
void holo_pixmap();
void holo_screen();
void holo_window();


void Init_holo(void) {
  mHolo = rb_define_module("Holo");

  eDisplayError = rb_define_class_under(
    mHolo, "DisplayError", rb_eStandardError
  );

  holo_color();
  holo_display();
  holo_events();
  holo_font();
  holo_pixmap();
  holo_screen();
  holo_window();
}

void holo_color() {
  cColor = rb_define_class_under(mHolo, "Color", rb_cObject);
  rb_define_attr(cColor, "pixel", 1, 0);
}

void holo_display() {
  cDisplay = rb_define_class_under(mHolo, "Display", rb_cObject);
  rb_define_singleton_method(cDisplay, "on_error", display_s_on_error, 1);
  rb_define_alloc_func(cDisplay, display_alloc);
  rb_define_attr(cDisplay, "name", 1, 0);
  rb_define_method(cDisplay, "close", display_close, 0);
  rb_define_method(cDisplay, "color_by_name", display_color_by_name, 1);
  rb_define_method(cDisplay, "create_pixmap", display_create_pixmap, 2);
  rb_define_method(cDisplay, "grab_key", display_grab_key, 2);
  rb_define_method(cDisplay, "listen_events", display_listen_events, 1);
  rb_define_method(cDisplay, "next_event", display_next_event, 0);
  rb_define_method(cDisplay, "open", display_open, 0);
  rb_define_method(cDisplay, "query_font", display_query_font, 0);
  rb_define_method(cDisplay, "root", display_root, 0);
  rb_define_method(cDisplay, "screens", display_screens, 0);
  rb_define_method(cDisplay, "sync", display_sync, 1);
}

void holo_events() {
  mEvents = rb_define_module_under(mHolo, "Events");

  cEvent = rb_define_class_under(mEvents, "Event", rb_cObject);
  rb_define_alloc_func(cEvent, event_alloc);
  rb_define_attr(cEvent, "type", 1, 0);
  rb_define_method(cEvent, "window", event_window, 0);

  cConfigureRequest = rb_define_class_under(mEvents, "ConfigureRequest", cEvent);
  rb_define_attr(cConfigureRequest, "x", 1, 0);
  rb_define_attr(cConfigureRequest, "y", 1, 0);
  rb_define_attr(cConfigureRequest, "width", 1, 0);
  rb_define_attr(cConfigureRequest, "height", 1, 0);
  rb_define_attr(cConfigureRequest, "above_window_id", 1, 0);
  rb_define_attr(cConfigureRequest, "detail", 1, 0);
  rb_define_attr(cConfigureRequest, "value_mask", 1, 0);

  cDestroyNotify = rb_define_class_under(mEvents, "DestroyNotify", cEvent);

  cExpose = rb_define_class_under(mEvents, "Expose", cEvent);

  cKeyPress = rb_define_class_under(mEvents, "KeyPress", cEvent);
  rb_define_attr(cKeyPress, "key", 1, 0);
  rb_define_attr(cKeyPress, "modifier_mask", 1, 0);

  cKeyRelease = rb_define_class_under(mEvents, "KeyRelease", cEvent);
  rb_define_attr(cKeyRelease, "key", 1, 0);
  rb_define_attr(cKeyRelease, "modifier_mask", 1, 0);

  cMapRequest = rb_define_class_under(mEvents, "MapRequest", cEvent);

  cPropertyNotify = rb_define_class_under(mEvents, "PropertyNotify", cEvent);

  cUnmapNotify = rb_define_class_under(mEvents, "UnmapNotify", cEvent);
}

void holo_font() {
  cFont = rb_define_class_under(mHolo, "Font", rb_cObject);
  rb_define_attr(cFont, "ascent", 1, 0);
  rb_define_attr(cFont, "descent", 1, 0);
}

void holo_pixmap() {
  cPixmap = rb_define_class_under(mHolo, "Pixmap", rb_cObject);
  rb_define_attr(cPixmap, "width", 1, 0);
  rb_define_attr(cPixmap, "height", 1, 0);
  rb_define_method(cPixmap, "draw_rect", pixmap_draw_rect, 4);
  rb_define_method(cPixmap, "draw_string", pixmap_draw_string, 3);
  rb_define_method(cPixmap, "gc_black", pixmap_gc_black, 0);
  rb_define_method(cPixmap, "gc_color", pixmap_gc_color, 1);
  rb_define_method(cPixmap, "gc_white", pixmap_gc_white, 0);
  rb_define_private_method(cPixmap, "_copy", pixmap__copy, 3);
}

void holo_screen() {
  cScreen = rb_define_class_under(mHolo, "Screen", rb_cObject);
  rb_define_method(cScreen, "initialize", screen_init, 5);
  rb_define_attr(cScreen, "x", 1, 0);
  rb_define_attr(cScreen, "y", 1, 0);
  rb_define_attr(cScreen, "width", 1, 0);
  rb_define_attr(cScreen, "height", 1, 0);
}

void holo_window() {
  cWindow = rb_define_class_under(mHolo, "Window", rb_cObject);
  rb_define_attr(cWindow, "id", 1, 0);
  rb_define_method(cWindow, "focus", window_focus, 0);
  rb_define_method(cWindow, "kill", window_kill, 0);
  rb_define_method(cWindow, "map", window_map, 0);
  rb_define_method(cWindow, "mask=", window_mask_set, 1);
  rb_define_method(cWindow, "name", window_name, 0);
  rb_define_method(cWindow, "override_redirect?", window_override_redirect, 0);
  rb_define_method(cWindow, "raise", window_raise, 0);
  rb_define_method(cWindow, "unmap", window_unmap, 0);
  rb_define_method(cWindow, "wclass", window_wclass, 0);
  rb_define_private_method(cWindow, "_configure", window__configure, 4);
  rb_define_private_method(cWindow, "_configure_event",
    window__configure_event, 4);
  rb_define_private_method(cWindow, "_create_sub", window__create_sub, 4);
  rb_define_private_method(cWindow, "_moveresize", window__moveresize, 4);
}
