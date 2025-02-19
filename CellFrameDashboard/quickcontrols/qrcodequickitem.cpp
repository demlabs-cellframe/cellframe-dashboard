#include "qrcodequickitem.h"
#include "thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h"
#include <QPainter>

QrCodeQuickItem::QrCodeQuickItem(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    m_qrEncode(new CQR_Encode),
    m_successfulEncoding(false),
    m_encodeImageSize(0)
{

}

QrCodeQuickItem::~QrCodeQuickItem()
{
    delete m_qrEncode;
}

const QByteArray &QrCodeQuickItem::data() const
{
    return m_data;
}

void QrCodeQuickItem::setData(const QByteArray &data)
{
    if (m_data != data) {
        m_data = data;
        createQRImage();
        update();
        emit dataChanged();
    }
}

bool QrCodeQuickItem::saveToFile(const QString &fileName, int width, int height) const
{
    if (!m_successfulEncoding) {
        qWarning("QrCodeQuickItem::saveToFile: QR code not generated");
        return false;
    }

    QImage img(scaledQRImage(QSize(width, height)));
    if (!img.save(fileName)) {
        qWarning("QrCodeQuickItem::saveToFile: Save image error");
        return false;
    }

    return true;
}

void QrCodeQuickItem::paint(QPainter *painter)
{
    if (!m_successfulEncoding)
        return;

    QSize size(width(), height());
    if (m_encodeImageScaled.isNull() || m_encodeImageScaledItemSize != size) {
        m_encodeImageScaled = scaledQRImage(size);
        m_encodeImageScaledItemSize = size;
    }

    painter->drawImage(QPoint((width() - m_encodeImageScaled.width()) / 2, (height() - m_encodeImageScaled.height()) / 2), m_encodeImageScaled);
}

void QrCodeQuickItem::createQRImage()
{
    int levelIndex = 1;
    int versionIndex = 0;
    bool bExtent = true;
    int maskIndex = -1;

    m_successfulEncoding = m_qrEncode->EncodeData(levelIndex, versionIndex, bExtent, maskIndex, m_data.data());
    if (m_successfulEncoding) {
        int qrImageSize = m_qrEncode->m_nSymbleSize;

        m_encodeImageSize = qrImageSize + (QR_MARGIN * 2);
        m_encodeImage = QImage(m_encodeImageSize, m_encodeImageSize, QImage::Format_Mono);
        m_encodeImage.fill(1);

        for (int i = 0; i < qrImageSize; i++) {
            for (int j = 0; j < qrImageSize; j++) {
                if (m_qrEncode->m_byModuleData[i][j]) {
                    m_encodeImage.setPixel(i + QR_MARGIN, j + QR_MARGIN, 0);
                }
            }
        }
    } else {
        qWarning("QrCodeQuickItem::setData: EncodeData error");
        m_encodeImageSize = 0;
        m_encodeImage = QImage();
    }

    m_encodeImageScaled = QImage();
    m_encodeImageScaledItemSize = QSize();
}

QImage QrCodeQuickItem::scaledQRImage(const QSize &size) const
{
    if (!m_successfulEncoding)
        return QImage();
    int scaleSize = m_encodeImageSize * (std::min(size.width(), size.height()) / m_encodeImageSize);
    return m_encodeImage.scaled(scaleSize, scaleSize);
}
