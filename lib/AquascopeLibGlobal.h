#include <QtCore/QtGlobal>

#if defined(AQUASCOPE_LIB_LIBRARY)
#  define AQUASCOPE_LIB_EXPORT Q_DECL_EXPORT
#else
#  define AQUASCOPE_LIB_EXPORT Q_DECL_IMPORT
#endif
