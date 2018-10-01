#include "DapCommand.h"

/// Redefined сonstructor.
/// @param byteArray Interpreting a сommand in a byte array.
DapCommand::DapCommand(const QByteArray &byteArray)
{
    this->deserialize(byteArray);
}

/// Add argument.
/// @param argument The argument.
void DapCommand::addArgument(const QVariant &argument)
{
    m_arguments.push_back(argument);
}

/// Get the number of arguments.
/// @return Number of arguments.
unsigned DapCommand::getCountArguments() const
{
    return m_countArguments;
}

/// Set the number of arguments.
/// @return Number of arguments.
void DapCommand::setCountArguments(const unsigned &countArguments)
{
    m_countArguments = countArguments;
}

/// Get the type of command.
/// @return The type of command.
const TypeDapCommand& DapCommand::getTypeCommand() const
{
    return m_typeCommand;
}

/// Set the type of command.
/// @param The type of command.
void DapCommand::setTypeCommand(const TypeDapCommand &typeCommand)
{
    m_typeCommand = typeCommand;
}

/// Get an argument.
/// @param pos The position of the argument in the collection of arguments.
/// @return The argument.
QVariant DapCommand::getArgument(int pos) const
{
    if(!m_arguments.isEmpty() && pos >=0 && pos < m_arguments.size())
        return m_arguments.at(pos);
    return QVariant();
}

/// Get a collection of arguments.
/// @return Сollection of arguments.
const QVector<QVariant>& DapCommand::getArguments() const
{
    return m_arguments;
}

/// Set a collection of arguments.
/// @return arguments Сollection of arguments.
void DapCommand::setArguments(const std::initializer_list<QVariant> &arguments)
{
    m_arguments.append(arguments);
}

/// Set a collection of arguments.
/// @return arguments Сollection of arguments.
void DapCommand::setArguments(const QVector<QVariant> &arguments)
{
    m_arguments.append(arguments);
}

/// Serialize a command to a byte array.
/// @return A serialized command interpreted as a byte array.
const QByteArray &DapCommand::serialize()
{
    QDataStream output( &m_byteArrayBuffer, QIODevice::WriteOnly );
    output << (*this);
    return m_byteArrayBuffer;
}

/// Deserialization of a command from a byte array.
/// @param byteArray A serialized command interpreted as a byte array.
void DapCommand::deserialize(const QByteArray &byteArray)
{
    QDataStream input(byteArray);
    input>>(*this);
}

/// Overloaded version of stream output.
/// @param ds Binary data stream.
/// @param dapCommand The command.
QDataStream& operator <<(QDataStream &dataStream, const DapCommand &dapCommand)
{
    dataStream << dapCommand.getTypeCommand() << dapCommand.getCountArguments();
    for(const QVariant& argument : dapCommand.getArguments())
    {
        dataStream << argument;
    }
    return dataStream;
}

/// Overloaded version of streaming input.
/// @param ds Binary data stream.
/// @param dapCommand The command.
QDataStream& operator >>(QDataStream &dataStream, DapCommand &dapCommand)
{
    int typeCommand{0};
    unsigned countArguments{0};
    dataStream >> typeCommand >> countArguments;
    dapCommand.setTypeCommand(static_cast<TypeDapCommand>(typeCommand));
    dapCommand.setCountArguments(countArguments);
    for(register unsigned a{0}; a < countArguments; ++a)
    {
        QVariant argument;
        dataStream >> argument;
        dapCommand.addArgument(argument);
    }
    
    return dataStream;
}
