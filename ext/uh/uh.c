#include "uh.h"


void uh_color();
void uh_display();
void uh_events();
void uh_font();
void uh_image();
void uh_pixmap();
void uh_screen();
void uh_window();


void Init_uh(void) {
  mUh = rb_define_module("Uh");

  eError          = rb_define_class_under(mUh, "Error", rb_eStandardError);
  eRuntimeError   = rb_define_class_under(mUh, "RuntimeError", rb_eRuntimeError);
  eArgumentError  = rb_define_class_under(mUh, "ArgumentError", eError);
  eDisplayError   = rb_define_class_under(mUh, "DisplayError", eRuntimeError);

  uh_color();
  uh_display();
  uh_events();
  uh_font();
  uh_image();
  uh_pixmap();
  uh_screen();
  uh_window();
}

void uh_color() {
  cColor = rb_define_class_under(mUh, "Color", rb_cObject);
  rb_define_singleton_method(cColor, "new", color_s_new, 2);
  rb_define_attr(cColor, "name", 1, 0);
  rb_define_attr(cColor, "pixel", 1, 0);
}

void uh_display() {
  cDisplay = rb_define_class_under(mUh, "Display", rb_cObject);
  rb_define_singleton_method(cDisplay, "on_error", display_s_on_error, 0);
  rb_define_alloc_func(cDisplay, display_alloc);
  rb_define_attr(cDisplay, "name", 1, 0);
  rb_define_method(cDisplay, "close", display_close, 0);
  rb_define_method(cDisplay, "fileno", display_fileno, 0);
  rb_define_method(cDisplay, "flush", display_flush, 0);
  rb_define_method(cDisplay, "grab_key", display_grab_key, 2);
  rb_define_method(cDisplay, "listen_events", display_listen_events, -1);
  rb_define_method(cDisplay, "each_event", display_each_event, 0);
  rb_define_method(cDisplay, "next_event", display_next_event, 0);
  rb_define_method(cDisplay, "open", display_open, 0);
  rb_define_method(cDisplay, "opened?", display_opened_p, 0);
  rb_define_method(cDisplay, "pending", display_pending, 0);
  rb_define_method(cDisplay, "root", display_root, 0);
  rb_define_method(cDisplay, "screens", display_screens, 0);
  rb_define_method(cDisplay, "sync", display_sync, 1);
}

void uh_events() {
  mEvents = rb_define_module_under(mUh, "Events");

  cEvent = rb_define_class_under(mEvents, "Event", rb_cObject);
  rb_define_attr(cEvent, "type", 1, 0);
  rb_define_attr(cEvent, "window", 1, 0);

  cConfigureNotify = rb_define_class_under(mEvents, "ConfigureNotify", cEvent);
  rb_define_attr(cConfigureNotify, "x", 1, 0);
  rb_define_attr(cConfigureNotify, "y", 1, 0);
  rb_define_attr(cConfigureNotify, "width", 1, 0);
  rb_define_attr(cConfigureNotify, "height", 1, 0);

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
  rb_define_attr(cExpose, "x", 1, 0);
  rb_define_attr(cExpose, "y", 1, 0);
  rb_define_attr(cExpose, "width", 1, 0);
  rb_define_attr(cExpose, "height", 1, 0);

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

void uh_font() {
  cFont = rb_define_class_under(mUh, "Font", rb_cObject);
  rb_define_singleton_method(cFont, "new", font_s_new, 1);
  rb_define_attr(cFont, "width", 1, 0);
  rb_define_attr(cFont, "ascent", 1, 0);
  rb_define_attr(cFont, "descent", 1, 0);
}

void uh_image() {
  cImage = rb_define_class_under(mUh, "Image", rb_cObject);
  rb_define_singleton_method(cImage, "new", image_s_new, 4);
  rb_define_method(cImage, "put", image_put, 1);
}

void uh_pixmap() {
  cPixmap = rb_define_class_under(mUh, "Pixmap", rb_cObject);
  rb_define_singleton_method(cPixmap, "new", pixmap_s_new, 3);
  rb_define_attr(cPixmap, "width", 1, 0);
  rb_define_attr(cPixmap, "height", 1, 0);
  rb_define_method(cPixmap, "copy", pixmap_copy, 1);
  rb_define_method(cPixmap, "draw_rect", pixmap_draw_rect, 4);
  rb_define_method(cPixmap, "draw_string", pixmap_draw_string, 3);
  rb_define_method(cPixmap, "gc_black", pixmap_gc_black, 0);
  rb_define_method(cPixmap, "gc_color", pixmap_gc_color, 1);
  rb_define_method(cPixmap, "gc_white", pixmap_gc_white, 0);
}

void uh_screen() {
  cScreen = rb_define_class_under(mUh, "Screen", rb_cObject);
  rb_define_method(cScreen, "initialize", screen_init, 5);
  rb_define_attr(cScreen, "id", 1, 0);
  rb_define_attr(cScreen, "x", 1, 0);
  rb_define_attr(cScreen, "y", 1, 0);
  rb_define_attr(cScreen, "width", 1, 0);
  rb_define_attr(cScreen, "height", 1, 0);
}

void uh_window() {
  cWindow = rb_define_class_under(mUh, "Window", rb_cObject);
  rb_define_singleton_method(cWindow, "new", window_s_new, 2);
  rb_define_attr(cWindow, "id", 1, 0);
  rb_define_method(cWindow, "configure", window_configure, 1);
  rb_define_method(cWindow, "configure_event", window_configure_event, 1);
  rb_define_method(cWindow, "create", window_create, 1);
  rb_define_method(cWindow, "create_sub", window_create_sub, 1);
  rb_define_method(cWindow, "cursor=", window_cursor_set, 1);
  rb_define_method(cWindow, "destroy", window_destroy, 0);
  rb_define_method(cWindow, "focus", window_focus, 0);
  rb_define_method(cWindow, "icccm_wm_delete", window_icccm_wm_delete, 0);
  rb_define_method(cWindow, "icccm_wm_protocols", window_icccm_wm_protocols, 0);
  rb_define_method(cWindow, "kill", window_kill, 0);
  rb_define_method(cWindow, "map", window_map, 0);
  rb_define_alias(cWindow, "show", "map");
  rb_define_method(cWindow, "mask", window_mask, 0);
  rb_define_method(cWindow, "mask=", window_mask_set, 1);
  rb_define_method(cWindow, "moveresize", window_moveresize, 1);
  rb_define_method(cWindow, "name", window_name, 0);
  rb_define_method(cWindow, "name=", window_name_set, 1);
  rb_define_method(cWindow, "override_redirect?", window_override_redirect, 0);
  rb_define_method(cWindow, "raise", window_raise, 0);
  rb_define_method(cWindow, "unmap", window_unmap, 0);
  rb_define_method(cWindow, "wclass", window_wclass, 0);
  rb_define_method(cWindow, "wclass=", window_wclass_set, 1);
}
