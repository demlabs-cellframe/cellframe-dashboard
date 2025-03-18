#include "resizeimageprovider.h"
#include <QPainter>
#include <QDebug>

ResizeImageProvider::ResizeImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage ResizeImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    int borderSize = 1;
    const double borderProportion = 0.02;

    Q_UNUSED(size);
    Q_UNUSED(requestedSize);

    QImage image;

    QString path (id.right(id.length()-3));

    qDebug() << "ResizeImageProvider::requestImage" << "id" << id << "path" << path;

    if (image.load(path))
    {
        borderSize = image.width()*borderProportion;

        QImage destImage = QImage(image.width()+borderSize*2,
                                  image.height()+borderSize*2, QImage::Format_ARGB32);

        destImage.fill(Qt::transparent);

        qDebug() << "ResizeImageProvider::requestImage" << "borderSize" << borderSize
                 << "destImage.width()" << destImage.width();

        QPainter painter(&destImage);
        painter.drawImage(borderSize, borderSize, image);
        painter.end();

        return destImage;
    }
    else
        return image;
}
