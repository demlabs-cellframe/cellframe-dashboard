#ifndef DAPUIQMLWIDGET_H
#define DAPUIQMLWIDGET_H

#include <QObject>

class DapUiQmlWidget : public QObject
{
    Q_OBJECT
    
protected:
    QString     m_name;
    QString     m_URLpage;
    QString     m_image;
    bool        m_visible{false};
public:
    explicit DapUiQmlWidget(QObject *parent = nullptr);
    explicit DapUiQmlWidget(const QString &name, const QString &URLpage, const QString &image, const bool &visible  = false, QObject *parent = nullptr);
    
    /// 
    Q_PROPERTY(QString Name MEMBER m_nameService READ getName WRITE setName NOTIFY nameChanged)
    /// 
    Q_PROPERTY(QString URLpage MEMBER m_nameService READ getURLpage WRITE setURLpage NOTIFY URLpageChanged)
    /// 
    Q_PROPERTY(QString Image MEMBER m_nameService READ getImage WRITE setImage NOTIFY imageChanged)
    /// 
    Q_PROPERTY(bool Visible MEMBER m_nameService READ getVisible WRITE setVisible NOTIFY visibleChanged)
    
    QString getName() const;
    void setName(const QString &name);
    
    QString getURLpage() const;
    void setURLpage(const QString &URLpage);
    
    QString getImage() const;
    void setImage(const QString &image);
    
    bool getVisible() const;
    void setVisible(bool visible);
    
signals:
    void nameChanged(const QString &name);
    void URLpageChanged(const QString &URLpage);
    void imageChanged(const QString &image);
    void visibleChanged(const bool &visible);
    
public slots:
};

#endif // DAPUIQMLWIDGET_H
