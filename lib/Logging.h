#pragma once

#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(logger)

constexpr auto loggerName = "logger";

void initLogging();
