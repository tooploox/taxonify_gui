#include "Logging.h"

#include <fstream>

#include <QDateTime>
#include <QString>
#include <QtGlobal>

#include "spdlog/sinks/rotating_file_sink.h"

Q_LOGGING_CATEGORY(logger, loggerName)

namespace {

constexpr auto logFilename = "logfile.txt";
constexpr auto confFilename = "logging.conf";
constexpr unsigned max_file_size = 1048576 * 5; // 5 MB
constexpr unsigned max_files = 1;

QtMessageHandler defaultMessageHandler = nullptr;

const QString messagePattern("(%{type})\t%{file}:%{line}\t{%{function}}\t%{message}");

constexpr auto defaultFilterRules = "logger.*=false\n"
                                    "logger.debug=true\n"
                                    "logger.info=true\n";

void messageHandler(QtMsgType type,
                    const QMessageLogContext &context,
                    const QString &message) {
    if (strcmp(context.category, loggerName) != 0) {
        defaultMessageHandler(type, context, message);
        return;
    }

    static auto logger = spdlog::rotating_logger_mt("logger", logFilename, max_file_size, max_files);
    QString timeUTC = QDateTime::currentDateTime().toUTC().toString("[yyyy-MM-dd h:mm:ss t] ");
    logger->info(qPrintable(timeUTC + qFormatLogMessage(type, context, message)));
}

QString getFilterRules() {
    std::string filterRules(defaultFilterRules);

    std::ifstream confFileStr(confFilename);
    if (confFileStr)
        filterRules = std::string(std::istreambuf_iterator<char>(confFileStr),
                                  std::istreambuf_iterator<char>());

    return QString::fromStdString(filterRules);
}

} // namespace

void initLogging() {
    spdlog::set_pattern("%v");
    qSetMessagePattern(messagePattern);
    defaultMessageHandler = qInstallMessageHandler(messageHandler);
    QLoggingCategory::setFilterRules(getFilterRules());
}
