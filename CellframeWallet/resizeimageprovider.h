#ifndef RESIZEIMAGEPROVIDER_H
#define RESIZEIMAGEPROVIDER_H

#include <QQuickImageProvider>

class ResizeImageProvider : public QQuickImageProvider
{
public:
    ResizeImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
};

#endif // RESIZEIMAGEPROVIDER_H
