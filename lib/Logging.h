#pragma once

#include <QLoggingCategory>

#include "TaxonifyLibGlobal.h"

Q_DECLARE_LOGGING_CATEGORY(logger)

constexpr auto loggerName = "logger";

TAXONIFY_LIB_EXPORT void initLogging();
