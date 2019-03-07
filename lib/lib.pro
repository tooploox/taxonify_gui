QT += qml quick quickcontrols2
CONFIG += c++11

TEMPLATE = lib

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    AquascopeLibGlobal.h \
    Uploader.h \
    Logger.h \
    spdlog/details/async_logger_impl.h \
    spdlog/details/circular_q.h \
    spdlog/details/console_globals.h \
    spdlog/details/file_helper.h \
    spdlog/details/fmt_helper.h \
    spdlog/details/log_msg.h \
    spdlog/details/logger_impl.h \
    spdlog/details/mpmc_blocking_q.h \
    spdlog/details/null_mutex.h \
    spdlog/details/os.h \
    spdlog/details/pattern_formatter.h \
    spdlog/details/periodic_worker.h \
    spdlog/details/registry.h \
    spdlog/details/thread_pool.h \
    spdlog/fmt/bundled/chrono.h \
    spdlog/fmt/bundled/color.h \
    spdlog/fmt/bundled/core.h \
    spdlog/fmt/bundled/format-inl.h \
    spdlog/fmt/bundled/format.h \
    spdlog/fmt/bundled/locale.h \
    spdlog/fmt/bundled/ostream.h \
    spdlog/fmt/bundled/posix.h \
    spdlog/fmt/bundled/printf.h \
    spdlog/fmt/bundled/ranges.h \
    spdlog/fmt/bundled/time.h \
    spdlog/fmt/bin_to_hex.h \
    spdlog/fmt/fmt.h \
    spdlog/fmt/ostr.h \
    spdlog/sinks/android_sink.h \
    spdlog/sinks/ansicolor_sink.h \
    spdlog/sinks/base_sink.h \
    spdlog/sinks/basic_file_sink.h \
    spdlog/sinks/daily_file_sink.h \
    spdlog/sinks/dist_sink.h \
    spdlog/sinks/msvc_sink.h \
    spdlog/sinks/null_sink.h \
    spdlog/sinks/ostream_sink.h \
    spdlog/sinks/rotating_file_sink.h \
    spdlog/sinks/sink.h \
    spdlog/sinks/stdout_color_sinks.h \
    spdlog/sinks/stdout_sinks.h \
    spdlog/sinks/syslog_sink.h \
    spdlog/sinks/wincolor_sink.h \
    spdlog/async.h \
    spdlog/async_logger.h \
    spdlog/common.h \
    spdlog/formatter.h \
    spdlog/logger.h \
    spdlog/spdlog.h \
    spdlog/tweakme.h \
    spdlog/version.h

SOURCES += \
    Uploader.cpp \
    Logger.cpp

DEFINES += AQUASCOPE_LIB_LIBRARY

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    spdlog/fmt/bundled/LICENSE.rst

