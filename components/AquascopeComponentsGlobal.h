#include <QtCore/QtGlobal>

#include <QtCore/QtGlobal>

#if defined(AQUASCOPE_COMPONENTS_LIBRARY)
#  define AQUASCOPE_COMPONENTS_EXPORT Q_DECL_EXPORT
#else
#  define AQUASCOPE_COMPONENTS_EXPORT Q_DECL_IMPORT
#endif
