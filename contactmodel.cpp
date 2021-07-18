/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "contactmodel.h"

ContactModel::ContactModel(QObject *parent ) : QAbstractListModel(parent)
{
}

int ContactModel::rowCount(const QModelIndex &) const
{
    return m_contacts.count();
}

QVariant ContactModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < rowCount())
        switch (role) {
        case FullNameRole               : return m_contacts.at(index.row()).fullName;
        case SpecialtyRole              : return m_contacts.at(index.row()).specialty;
        case AddressTypeRole            : return m_contacts.at(index.row()).addressType;
        case AddressStreetRole          : return m_contacts.at(index.row()).addressStreet;
        case AddressNumberRole          : return m_contacts.at(index.row()).addressNumber;
        case AddressComplementRole      : return m_contacts.at(index.row()).addressComplement;
        case AddressNeighborhoodRole    : return m_contacts.at(index.row()).addressNeighborhood;
        case AddressZipRole             : return m_contacts.at(index.row()).addressZip;
        case AddressCityRole            : return m_contacts.at(index.row()).addressCity;
        case AddressStateRole           : return m_contacts.at(index.row()).addressState;
        case ContactNumberRole          : return m_contacts.at(index.row()).contactNumber;
        default: return QVariant();
    }
    return QVariant();
}

QHash<int, QByteArray> ContactModel::roleNames() const
{
    static const QHash<int, QByteArray> roles {
        { FullNameRole,             "fullName" },
        { SpecialtyRole,            "specialty" },
        { AddressTypeRole,          "addressType" },
        { AddressStreetRole,        "addressStreet" },
        { AddressNumberRole,        "addressNumber" },
        { AddressComplementRole,    "addressComplement" },
        { AddressNeighborhoodRole,  "addressNeighborhood" },
        { AddressZipRole,           "addressZip" },
        { AddressCityRole,          "addressCity" },
        { AddressStateRole,         "addressState" },
        { ContactNumberRole,        "contactNumber" }
    };
    return roles;
}

QVariantMap ContactModel::get(int row) const
{
    const Contact contact = m_contacts.value(row);
    return { {"fullName", contact.fullName}, {"specialty", contact.specialty},
             {"addressType", contact.addressType}, {"addressStreet", contact.addressStreet}, {"addressNumber", contact.addressNumber}, {"complement", contact.addressComplement},
             {"neighborhood", contact.addressNeighborhood}, {"zip", contact.addressZip}, {"city", contact.addressCity}, {"state", contact.addressState},
             {"contactNumber", contact.contactNumber} };
}

void ContactModel::append(const QString &fullName, const QString &specialty, const QString &addressType, const QString &addressStreet, const QString &addressNumber, const QString &addressComplement, const QString &addressNeighborhood, const QString &addressZip, const QString  &addressCity, const QString &addressState, const QString &contactNumber)
{
    int row = 0;
    while (row < m_contacts.count() && fullName > m_contacts.at(row).fullName)
        ++row;
    beginInsertRows(QModelIndex(), row, row);
    m_contacts.insert(row, { fullName,
                             specialty,
                             addressType,
                             addressStreet,
                             addressNumber,
                             addressComplement,
                             addressNeighborhood,
                             addressZip,
                             addressCity,
                             addressState,
                             contactNumber});
    endInsertRows();
}

void ContactModel::set(int row, const QString &fullName, const QString &specialty, const QString &addressType, const QString &addressStreet, const QString &addressNumber, const QString &addressComplement, const QString &addressNeighborhood, const QString &addressZip, const QString  &addressCity,const QString &addressState, const QString &contactNumber)
{
    if (row < 0 || row >= m_contacts.count())
        return;

    m_contacts.replace(row, { fullName,
                             specialty,
                             addressType,
                             addressStreet,
                             addressNumber,
                             addressComplement,
                             addressNeighborhood,
                             addressZip,
                             addressCity,
                             addressState,
                             contactNumber});
    dataChanged(index(row, 0), index(row, 0), { FullNameRole,
                                                SpecialtyRole,
                                                AddressTypeRole,
                                                AddressStreetRole,
                                                AddressNumberRole,
                                                AddressComplementRole,
                                                AddressNeighborhoodRole,
                                                AddressZipRole,
                                                AddressCityRole,
                                                AddressStateRole,
                                                ContactNumberRole });
}

void ContactModel::remove(int row)
{
    if (row < 0 || row >= m_contacts.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_contacts.removeAt(row);
    endRemoveRows();
}

void ContactModel::clear()
{
    m_contacts.clear();
}
