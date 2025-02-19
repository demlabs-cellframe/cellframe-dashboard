#ifndef QRCODEQUICKITEM_H
#define QRCODEQUICKITEM_H

#include <QQuickPaintedItem>
#include <QImage>

class CQR_Encode;

class QrCodeQuickItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QByteArray data READ data WRITE setData NOTIFY dataChanged)
public:
    explicit QrCodeQuickItem(QQuickItem *parent = nullptr);
    ~QrCodeQuickItem() override;

    const QByteArray &data() const;
    void setData(const QByteArray &data);

    Q_INVOKABLE bool saveToFile(const QString &fileName, int width, int height) const;

    void paint(QPainter *painter) override;

signals:
    void dataChanged();

private:
    void createQRImage();
    QImage scaledQRImage(const QSize &size) const;

private:
    CQR_Encode *m_qrEncode;
    QByteArray m_data;
    bool m_successfulEncoding;
    int m_encodeImageSize;
    QImage m_encodeImage;
    QImage m_encodeImageScaled;
    QSize m_encodeImageScaledItemSize;
};

#endif // QRCODEQUICKITEM_H
