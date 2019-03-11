#include "Logging.h"

#include <QDateTime>
#include <QString>
#include <QtGlobal>

#include "spdlog/sinks/rotating_file_sink.h"

Q_LOGGING_CATEGORY(logger, "logger")

static constexpr auto logFilename = "logfile.txt";
static constexpr unsigned max_file_size = 1048576 * 5; // 5 MB
static constexpr unsigned max_files = 1;

static const QString messagePattern("%{category}\t%{file}:%{line}\t{%{function}}\t%{message}");

static void messageHandler(QtMsgType type,
                    const QMessageLogContext &context,
                    const QString &message) {
    static auto logger = spdlog::rotating_logger_mt("logger", logFilename, max_file_size, max_files);
    QString timeUTC = QDateTime::currentDateTime().toUTC().toString("[yyyy-MM-dd h:mm:ss t] ");
    logger->info(qPrintable(timeUTC + qFormatLogMessage(type, context, message)));
}

void initLogging() {
    spdlog::set_pattern("%v");
    qSetMessagePattern(messagePattern);
    qInstallMessageHandler(messageHandler);
    QLoggingCategory::setFilterRules("logger.*=false\n"
                                     "logger.debug=true\n"
                                     "logger.info=true");
}
