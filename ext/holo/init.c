#include "holo.h"


void holo_display();
void holo_events();
void holo_screen();
void holo_window();


void Init_holo(void) {
  mHolo = rb_define_module("Holo");

  eDisplayError = rb_define_class_under(
    mHolo, "DisplayError", rb_eStandardError
  );

  holo_display();
  holo_events();
  holo_screen();
  holo_window();
}

void holo_display() {
  cDisplay = rb_define_class_under(mHolo, "Display", rb_cObject);
  rb_define_singleton_method(cDisplay, "on_error", display_s_on_error, 1);
  rb_define_alloc_func(cDisplay, display_alloc);
  rb_define_attr(cDisplay, "name", 1, 0);
  rb_define_method(cDisplay, "open", display_open, 0);
  rb_define_method(cDisplay, "close", display_close, 0);
  rb_define_method(cDisplay, "screens", display_screens, 0);
  rb_define_method(cDisplay, "next_event", display_next_event, 0);
  rb_define_method(cDisplay, "listen_events", display_listen_events, 1);
  rb_define_method(cDisplay, "sync", display_sync, 1);
  rb_define_method(cDisplay, "root_change_attributes",
    display_root_change_attributes, 1);
  rb_define_method(cDisplay, "grab_key", display_grab_key, 1);
}

void holo_events() {
  mEvents = rb_define_module_under(mHolo, "Events");

  cEvent = rb_define_class_under(mEvents, "Event", rb_cObject);
  rb_define_alloc_func(cEvent, event_alloc);
  rb_define_attr(cEvent, "type", 1, 0);
  rb_define_method(cEvent, "window", event_window, 0);

  cConfigureRequest = rb_define_class_under(mEvents, "ConfigureRequest", cEvent);
  rb_define_attr(cConfigureRequest, "window_id", 1, 0);

  cDestroyNotify = rb_define_class_under(mEvents, "DestroyNotify", cEvent);

  cExpose = rb_define_class_under(mEvents, "Expose", cEvent);

  cKeyPress = rb_define_class_under(mEvents, "KeyPress", cEvent);
  rb_define_attr(cKeyPress, "key", 1, 0);

  cMapRequest = rb_define_class_under(mEvents, "MapRequest", cEvent);
  rb_define_attr(cMapRequest, "window_id", 1, 0);

  cPropertyNotify = rb_define_class_under(mEvents, "PropertyNotify", cEvent);

  cUnmapNotify = rb_define_class_under(mEvents, "UnmapNotify", cEvent);
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
  rb_define_singleton_method(cWindow, "configure", window_s_configure, 2);
  rb_define_method(cWindow, "focus", window_focus, 0);
  rb_define_method(cWindow, "map", window_map, 0);
  rb_define_method(cWindow, "raise", window_raise, 0);
  rb_define_private_method(cWindow, "_moveresize", window__moveresize, 4);
}
