#include "DapDappsNetworkManager.h"
#include "httplib.h"

DapDappsNetworkManager::DapDappsNetworkManager(QString path, QString pathPlugins, QWidget *parent)
    : QWidget{parent}, m_path(std::move(path)), m_pathPlugins(std::move(pathPlugins)), m_reconnectTimer(new QTimer(this))
{
    connect(m_reconnectTimer, &QTimer::timeout, this, &DapDappsNetworkManager::onReconnect);
    connect(this, &DapDappsNetworkManager::sigReload, this, &DapDappsNetworkManager::onReload);
}

DapDappsNetworkManager::~DapDappsNetworkManager()
{
    delete m_reconnectTimer;
}

void DapDappsNetworkManager::downloadFile(QString name)
{
    QString url = m_path + name;
    m_fileName = name;
    QString path = m_pathPlugins + m_fileName;
    m_file = new QFile(path);

    quint64 data = 0;
    m_bytesReceived = 0;
    m_cancelDownload = false;

    if (m_file->exists()) {
        if (m_reload) {
            m_file->remove();
            delete m_file;
            m_file = new QFile(path);
            m_reload = false;
        } else {
            QFileInfo fileInfo(*m_file);
            data = fileInfo.size();
            m_bytesReceived = data;
        }
    }

    QString dAppUrlName = "/dashboard/"+name;

    QtConcurrent::run([this, dAppUrlName, path]()
    {
        httplib::Client cli(m_path.toStdString().c_str());
        cli.enable_server_certificate_verification(false);
        cli.set_connection_timeout(5, 0);  // 5 sec timeout connect
        cli.set_read_timeout(10, 0);       // 10 sec timeout ready read

        m_file->open(QIODevice::ReadWrite | QIODevice::Append);

        auto last_activity = std::chrono::steady_clock::now();

        quint64 _load = m_bytesReceived;
        quint64 _total = 0;

        auto resHead = cli.Head(dAppUrlName.toStdString().c_str());
        if (resHead && resHead->status == 200) {
            auto it = resHead->headers.find("Content-Length");
            if (it != resHead->headers.end()) {
                _total = std::stoull(it->second);
            }
        }

        auto res = cli.Get(dAppUrlName.toStdString().c_str(), [this, &last_activity, &_load, &_total](const char *data, size_t data_length) {
            if (m_cancelDownload) return false; //abort

            auto now = std::chrono::steady_clock::now();
            auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(now - last_activity).count();

            if (elapsed > 5) {
                qWarning() << "Connection timeout: No data received for 5 seconds";
                return false;
            }

            last_activity = now;

            if (m_file->isOpen()) {
                m_file->write(data, data_length);
            }

            _load += data_length;
            emit sigDownloadProgress(_load, _total, m_fileName, "Connected");

            return true;
        });
        if (res && res->status == 200) {
            if (!m_cancelDownload) {
                m_file->flush();
                m_file->close();
                emit sigDownloadCompleted(path);
            }
        } else {
            qWarning() << "dApp download failed: " << (res ? res->status : -1);

            if(m_reload)
            {
                emit sigReload();
            }
            else if(!m_cancelDownload)
            {
                emit sigDownloadProgress(_load, _total, m_fileName, "Error. Reconnecting");
                emit sigReload();
            }
        }
        mtx.lock();
        if(m_file) delete m_file;
        mtx.unlock();
    });
}

void DapDappsNetworkManager::cancelDownload(bool ok, bool reload)
{
    m_reload = reload;
    m_cancelDownload = true;

    if(!m_reload)
    {
        m_reconnectTimer->stop();
        emit sigDownloadProgress(0, 0, m_fileName, "Cancelled");
    }
    else
        emit sigDownloadProgress(0, 0, m_fileName, "Reloading");
}

QString DapDappsNetworkManager::repoAddress() const
{
    return m_path;
}

void DapDappsNetworkManager::onReconnect()
{
    m_reconnectTimer->stop();
    if (!m_cancelDownload) {
        downloadFile(m_fileName);
    }
}

void DapDappsNetworkManager::onReload()
{
    if(m_reload)
        downloadFile(m_fileName);
    else
        QTimer::singleShot(1000, [this]() {downloadFile(m_fileName);});
}

void DapDappsNetworkManager::fetchPluginsList()
{
    httplib::Client cli(m_path.toStdString().c_str());
    cli.enable_server_certificate_verification(false); //Disable ssl verify
    cli.set_follow_location(true);  // Auto redirect
    cli.set_keep_alive(false);  // Disable keep-alive
    cli.set_tcp_nodelay(true);  // Disable delay send pack

    cli.set_connection_timeout(10, 0);
    cli.set_read_timeout(10, 0);
    cli.set_write_timeout(10, 0);

    httplib::Result res = cli.Get(QString("/dashboard/").toStdString());

    if (res && res->status == 200) {
        QString response = QString::fromStdString(res->body);
        QRegExp rw("[\\w+|\\s+]{,}.zip");
        int lastPos = 0;

        while ((lastPos = rw.indexIn(response, lastPos)) != -1) {
            lastPos += rw.matchedLength();
            m_bufferFiles.append(rw.cap(0));
        }
        m_bufferFiles.removeDuplicates();
        emit sigPluginsListFetched();
    } else {
        qWarning() << "Failed to fetch plugin list. Code:  " << (res ? res->status : -1 ) << ". Error: " << QString::fromStdString(httplib::to_string(res.error()));
    }
}
