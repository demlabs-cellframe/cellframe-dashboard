#include "TokenPairsWorker.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

#include <QDebug>

TokenPairsWorker::TokenPairsWorker(QQmlContext *cont, QObject *parent) :
    QObject(parent),
    context(cont)
{
    sendCurrentPairModel();
}

void TokenPairsWorker::setPairModel(const QByteArray &json)
{
    QJsonDocument doc = QJsonDocument::fromJson(json);

    if (!doc.isArray())
        return;

    pairModel.clear();

    QJsonArray pairArray = doc.array();

    for(auto i = 0; i < pairArray.size(); i++)
    {
        /// TODO: Causes redundancy of logs but there may be a need in the future
//        qDebug() << i << pairArray.at(i)["token1"].toString()
//                 << pairArray.at(i)["token2"].toString()
//                 << pairArray.at(i)["network"].toString()
//                 << pairArray.at(i)["rate"].toString()
//                 << pairArray.at(i)["rate"].toString().toDouble()
//                 << pairArray.at(i)["change"].toString();

        QString tokenBuy = pairArray.at(i)["token1"].toString(); // token1
        QString tokenSell = pairArray.at(i)["token2"].toString(); // token2
        QString network = pairArray.at(i)["network"].toString();
        double price = pairArray.at(i)["rate"].toString().toDouble();
        QString priceText = pairArray.at(i)["rate"].toString();
        QString change = pairArray.at(i)["change"].toString();


        pairModel.append(
            TokenPairInfo{tokenBuy, tokenSell, network, price, priceText, change});

        if (m_tokenBuy == tokenBuy &&
            m_tokenSell == tokenSell &&
            m_tokenNetwork == network)
        {
            m_currentPairIndex = i;
        }
    }

    if (m_tokenBuy == "-" &&
        m_tokenSell == "-" &&
        m_tokenNetwork == "-")
    {
        if (pairModel.size() > 0)
        {
            m_tokenBuy = pairModel.first().tokenBuy;
            m_tokenSell = pairModel.first().tokenSell;
            m_tokenNetwork = pairModel.first().network;
            m_tokenPrice = pairModel.first().price;
            m_tokenPriceText = pairModel.first().priceText;

            m_currentPairIndex = 0;
        }
    }

    if (pairModel.size() == 0)
    {
        m_tokenBuy = "-";
        m_tokenSell = "-";
        m_tokenNetwork = "-";
        m_tokenPrice = 0.0;
        m_tokenPriceText = "0.0";

        m_currentPairIndex = 0;
    }

    qDebug() << "current token pair:"
             << m_tokenBuy
             << m_tokenSell
             << m_tokenNetwork
             << m_tokenPrice
             << m_tokenPriceText;

    qDebug() << "m_currentPairIndex"
             << m_currentPairIndex;

    emit setTokenPair(m_tokenBuy, m_tokenSell, m_tokenNetwork);

    sendCurrentPairModel();

    emit currentPairIndexChanged(m_currentPairIndex);

    emit pairModelUpdated();

/*
            if(dapPairModel.count > 0)
            {
                token1Name = dapPairModel.get(currentIndexPair).token1
                token2Name = dapPairModel.get(currentIndexPair).token2
                tokenNetwork = dapPairModel.get(currentIndexPair).network

                stockDataWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

                dapPairModel.clear()
                dapPairModel.append(jsonDocument)

                for(var i = 0; i < dapPairModel.count; i++)
                {
                    var token1New = dapPairModel.get(i).token1
                    var token2New = dapPairModel.get(i).token2
                    var networkNew = dapPairModel.get(i).network

                    if (token1Name === token1New &&
                        token2Name === token2New &&
                        tokenNetwork === networkNew)
                    {
                        currentIndexPair = i
                        modelPairsUpdated()
                        return
                    }
                }
            }
            else
            {
                dapPairModel.clear()
                dapPairModel.append(jsonDocument)
                currentIndexPair = 0

                if(dapPairModel.count > 0)
                {
                    token1Name = dapPairModel.get(currentIndexPair).token1
                    token2Name = dapPairModel.get(currentIndexPair).token2
                    tokenNetwork = dapPairModel.get(currentIndexPair).network
                }
                else
                {
                    token1Name = ""
                    token2Name = ""
                    tokenNetwork = ""
                }

                stockDataWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

                modelPairsUpdated()
            }
*/

}

void TokenPairsWorker::setCurrentPairIndex(int index)
{
//    if (m_currentPairIndex == index)
//        return;

    m_currentPairIndex = index;

    for (auto i = 0; i < pairModel.size(); ++i)
        if (i == m_currentPairIndex)
        {
            m_tokenBuy = pairModel.at(i).tokenBuy;
            m_tokenSell = pairModel.at(i).tokenSell;
            m_tokenNetwork = pairModel.at(i).network;
            m_tokenPrice = pairModel.at(i).price;
            m_tokenPriceText = pairModel.at(i).priceText;

            break;
        }

    qDebug() << "TokenPairsWorker::setCurrentPairIndex"
             << m_tokenBuy
             << m_tokenSell
             << m_tokenNetwork
             << m_tokenPrice
             << m_tokenPriceText;

    emit setTokenPair(m_tokenBuy, m_tokenSell, m_tokenNetwork);

    emit currentPairIndexChanged(m_currentPairIndex);
}

void TokenPairsWorker::sendCurrentPairModel()
{
    model.clear();

    for (auto i = 0; i < pairModel.size(); ++i)
        model << QVariant::fromValue(pairModel.at(i));

    qDebug() << "TokenPairsWorker::sendCurrentPairModel" << model.size();

    context->setContextProperty("dapPairModel", model);
}
