win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../../lib/release/ -llib
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../../lib/debug/ -llib
else:unix: LIBS += -L$$OUT_PWD/../../lib/ -llib

message($$OUT_PWD)

INCLUDEPATH += $$PWD/../lib
DEPENDPATH += $$PWD/../lib
