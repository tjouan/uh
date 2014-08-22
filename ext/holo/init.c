#include "holo.h"


void holo_display();
void holo_events();


void Init_holo(void) {
  mHolo = rb_define_module("Holo");

  eDisplayError = rb_define_class_under(
    mHolo, "DisplayError", rb_eStandardError
  );

  holo_display();
  holo_events();
}

void holo_display() {
  cDisplay = rb_define_class_under(mHolo, "Display", rb_cObject);
  rb_define_alloc_func(cDisplay, display_alloc);
  rb_define_attr(cDisplay, "name", 1, 0);
  rb_define_method(cDisplay, "initialize", display_init, -1);
  rb_define_method(cDisplay, "open", display_open, 0);
  rb_define_method(cDisplay, "close", display_close, 0);
  rb_define_method(cDisplay, "next_event", display_next_event, 0);
  rb_define_method(cDisplay, "listen_events", display_listen_events, 0);
  rb_define_method(cDisplay, "sync", display_sync, 0);
  rb_define_method(cDisplay, "change_window_attributes",
      display_change_window_attributes, 0);
  rb_define_method(cDisplay, "grab_key", display_grab_key, 1);
}

void holo_events() {
  mEvents = rb_define_module_under(mHolo, "Events");

  cEvent = rb_define_class_under(mEvents, "Event", rb_cObject);
  rb_define_alloc_func(cEvent, event_alloc);

  cConfigureRequest = rb_define_class_under(mEvents, "ConfigureRequest", cEvent);
  rb_define_attr(cConfigureRequest, "window_id", 1, 0);

  cDestroyNotify = rb_define_class_under(mEvents, "DestroyNotify", cEvent);

  cExpose = rb_define_class_under(mEvents, "Expose", cEvent);

  cKeyPress = rb_define_class_under(mEvents, "KeyPress", cEvent);
  rb_define_attr(cKeyPress, "key", 1, 0);

  cMapRequest = rb_define_class_under(mEvents, "MapRequest", cEvent);

  cPropertyNotify = rb_define_class_under(mEvents, "PropertyNotify", cEvent);

  cUnmapNotify = rb_define_class_under(mEvents, "UnmapNotify", cEvent);
}
