TEMPLATE = subdirs

SUBDIRS = app lib test_gui

app.depends = lib
test_gui.depends = lib

OTHER_FILES = README.md
