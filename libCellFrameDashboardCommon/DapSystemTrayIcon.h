#ifndef DAPSYSTEMTRAYICON_H
#define DAPSYSTEMTRAYICON_H

#include <QObject>
#include <QWidget>
#include <QHelpEvent>
#include <QSystemTrayIcon>
#include <QTimer>

class DapSystemTrayIcon : public QSystemTrayIcon
{
    Q_OBJECT

    QTimer      m_timer;
    QRect       m_rectIcon;
    QWidget     * m_pToolTipWidget {nullptr};

public:
    explicit DapSystemTrayIcon(QObject *parent = nullptr);

    void setToolTipWidget(QWidget * apToolTip);
    const QWidget * getToolTipWidget() const;

signals:
    void iconPosChaged(const QRect& aPos);
    void mousePosChanged(const QPoint& aPos);

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private slots:
    void determinePosIcon(const QRect& aPos);
    void getMousePosition();
    void checkRange(const QPoint& aPos);

};

#endif // DAPSYSTEMTRAYICON_H
