/****************************************************************************
**
** This file is part of the libKelvinDashboardClient library.
** 
** The class implements the essence of the command. The signature of the 
** command includes: the type of the command, the number of arguments in 
** the command, a collection of arguments of the type QVariant.
**
****************************************************************************/

#ifndef DAPCOMMAND_H
#define DAPCOMMAND_H

#include <QVector>
#include <QString>
#include <QByteArray>
#include <QIODevice>
#include <QDataStream>
#include <QDebug>
#include <initializer_list>

/****************************************************************************
**
** This file is part of the libKelvinDashboardClient library.
** 
** The enum type implements the nomenclature of commands used in client-server 
** communication.
**
****************************************************************************/

enum TypeDapCommand
{
    None,                   // Type is undefined
    Authorization,          // User authorization
    ActivateWindowClient,   // Activate the main application window if minimized to the system tray
    CheckExistenceClient,   // Checking the existence of a client connected to the server
    CloseClient             // Shut down the client
};

class DapCommand
{
    /// Overloaded version of stream output.
    /// @param ds Binary data stream.
    /// @param dapCommand The command.
    friend QDataStream& operator<<(QDataStream &ds, const DapCommand &dapCommand);
    /// Overloaded version of streaming input.
    /// @param ds Binary data stream.
    /// @param dapCommand The command.
    friend QDataStream& operator>>(QDataStream &ds, DapCommand &dapCommand);
    
protected:
    /// Type of the command.
    TypeDapCommand      m_typeCommand {TypeDapCommand::None};
    /// Number of arguments.
    unsigned            m_countArguments{0};
    /// Collection of the command.
    QVector<QVariant>   m_arguments;
    /// Interpreting a сommand in a byte array.
    QByteArray          m_byteArrayBuffer;
    
public:
    /// Standart constructor.
    DapCommand() = default;
    /// Redefined сonstructor.
    /// @param byteArray Interpreting a сommand in a byte array.
    DapCommand(const QByteArray& byteArray);
    /// Redefined сonstructor.
    /// @param typeCommand The type of command.
    DapCommand(const TypeDapCommand &typeCommand) : m_typeCommand(typeCommand) { }
    /// Redefined сonstructor.
    /// @param typeCommand The type of command.
    /// @param countArguments Number of arguments.
    /// @param args Сollection of arguments.
    DapCommand(const TypeDapCommand &typeCommand, const unsigned& countArguments, const std::initializer_list<QVariant> &args) 
        : m_typeCommand(typeCommand), m_countArguments(countArguments), m_arguments(args) { }
    /// Redefined сonstructor.
    /// @param typeCommand The type of command.
    /// @param args Сollection of arguments.
    DapCommand(const TypeDapCommand &typeCommand, const std::initializer_list<QVariant> &args) 
        : m_typeCommand(typeCommand), m_arguments(args) { }
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    
    /// Get the type of command.
    /// @return The type of command.
    const TypeDapCommand &getTypeCommand() const;
    /// Set the type of command.
    /// @param The type of command.
    void setTypeCommand(const TypeDapCommand &typeCommand);
    /// Get an argument.
    /// @param pos The position of the argument in the collection of arguments.
    /// @return The argument.
    QVariant getArgument(int pos) const;  
    /// Get a collection of arguments.
    /// @return Сollection of arguments.
    const QVector<QVariant> &getArguments() const;
    /// Set a collection of arguments.
    /// @param arguments Сollection of arguments.
    void setArguments(const std::initializer_list<QVariant> &arguments);
    /// Set a collection of arguments.
    /// @return arguments Сollection of arguments.
    void setArguments(const QVector<QVariant> &arguments);
    /// Serialize a command to a byte array.
    /// @return A serialized command interpreted as a byte array.
    const QByteArray &serialize();
    /// Deserialization of a command from a byte array.
    /// @param byteArray A serialized command interpreted as a byte array.
    void deserialize(const QByteArray &byteArray);
    /// Get the number of arguments.
    /// @return Number of arguments.
    unsigned getCountArguments() const;
    /// Set the number of arguments.
    /// @return Number of arguments.
    void setCountArguments(const unsigned& countArguments);
    /// Add argument.
    /// @param argument The argument.
    void addArgument(const QVariant &argument);
};


#endif // DAPCOMMAND_H
