#include "holo.h"


VALUE window_s_configure(VALUE klass, VALUE rdisplay, VALUE window_id) {
  set_display(rdisplay);
  XWindowChanges  wc;
  unsigned int    mask;

  mask = CWX | CWY | CWWidth | CWHeight |
    CWBorderWidth | CWStackMode;
  wc.x            = 0;
  wc.y            = 0;
  wc.width        = 484;
  wc.height       = 100;
  wc.border_width = 0;
  wc.stack_mode   = Above;
  XConfigureWindow(DPY, NUM2LONG(window_id), mask, &wc);

  return Qnil;
}
