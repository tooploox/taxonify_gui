#ifndef REQUEST_ERROR_H
#define REQUEST_ERROR_H

#include <QObject>

#include "AquascopeComponentsGlobal.h"

class AQUASCOPE_COMPONENTS_EXPORT RequestError : public QObject
{
    Q_OBJECT
    Q_ENUMS(Type)

public:
    enum Type {
        NetworkError, // no network
        HttpStatus, // http statuses like 400, 403, 404, 500, etc.
        ParseError, // response cannot be parsed
        ValidationError // validation error - unexpected response schema
    };
};

#endif // REQUEST_ERROR_H
