#include "Logger.h"

#include <QString>
#include <QtGlobal>

#include "spdlog/sinks/rotating_file_sink.h"

static constexpr auto logFilename = "logfile.txt";

static const QString messagePattern("[%{time yyyyMMdd h:mm:ss.zzz t} %{if-debug}D%{endif}"
                       "%{if-info}I%{endif}%{if-warning}W%{endif}%{if-critical}C%{endif}"
                       "%{if-fatal}F%{endif}] %{file}:%{line} - %{message}");

static void messageHandler(QtMsgType type,
                    const QMessageLogContext &context,
                    const QString &message) {
    static auto logger = spdlog::rotating_logger_mt("logger", logFilename, 1048576 * 5, 1);
    logger->info(qPrintable(qFormatLogMessage(type, context, message)));
}

void initLogging() {
    spdlog::set_pattern("%v");
    qSetMessagePattern(messagePattern);
    qInstallMessageHandler(messageHandler);
}
