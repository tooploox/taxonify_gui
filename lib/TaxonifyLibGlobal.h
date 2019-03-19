#include <QtCore/QtGlobal>

#if defined(TAXONIFY_LIB_LIBRARY)
#  define TAXONIFY_LIB_EXPORT Q_DECL_EXPORT
#else
#  define TAXONIFY_LIB_EXPORT Q_DECL_IMPORT
#endif
