#ifndef MBPROXYQUERYMODEL_H
#define MBPROXYQUERYMODEL_H

#include <QSortFilterProxyModel>
#include <QSqlQueryModel>

#include "mbquerymodel.h"

class MbProxyQueryModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QSortFilterProxyModel *moviesModel READ moviesModel NOTIFY moviesModelChanged)
    Q_PROPERTY(QSortFilterProxyModel *seriesModel READ seriesModel NOTIFY seriesModelChanged)
    Q_PROPERTY(QSortFilterProxyModel *episodesModel READ episodesModel NOTIFY episodesModelChanged)
    Q_PROPERTY(QSortFilterProxyModel *musicModel READ musicModel NOTIFY musicModelChanged)
    Q_PROPERTY(QSortFilterProxyModel *gamesModel READ gamesModel NOTIFY gamesModelChanged)

    Q_PROPERTY(MbQueryModel *itemPricesModel READ itemPricesModel NOTIFY itemPricesModelChanged)
    Q_PROPERTY(MbQueryModel *itemTypesModel READ itemTypesModel NOTIFY itemTypesModelChanged)
    Q_PROPERTY(MbQueryModel *copyMediaModel READ copyMediaModel NOTIFY copyMediaModelChanged)
    Q_PROPERTY(MbQueryModel *musicCopyMediaModel READ musicCopyMediaModel NOTIFY musicCopyMediaModelChanged)
    Q_PROPERTY(MbQueryModel *paymentMethodsModel READ paymentMethodsModel NOTIFY paymentMethodsModelChanged)


    Q_PROPERTY(QString seriesTitle READ seriesTitle WRITE setSeriesTitle NOTIFY seriesTitleChanged)
    Q_PROPERTY(QString season READ season WRITE setSeason NOTIFY seasonChanged)

public:
    enum ModelType {
        Movies,
        Series,
        Music,
        Games
    };
    Q_ENUMS(ModelType)

    explicit MbProxyQueryModel(QObject *parent = nullptr);

    QSortFilterProxyModel *moviesModel() const;
    QSortFilterProxyModel *seriesModel() const;
    QSortFilterProxyModel *episodesModel() const;
    QSortFilterProxyModel *musicModel() const;
    QSortFilterProxyModel *gamesModel() const;

    MbQueryModel *itemTypesModel() const;
    MbQueryModel *itemPricesModel() const;
    MbQueryModel *copyMediaModel() const;
    MbQueryModel *musicCopyMediaModel() const;
    MbQueryModel *paymentMethodsModel() const;

    QString seriesTitle() const;
    void setSeriesTitle(const QString &seriesTitle);

    QString season() const;
    void setSeason(const QString &season);

signals:
    void moviesModelChanged();
    void seriesModelChanged();
    void episodesModelChanged();
    void musicModelChanged();
    void gamesModelChanged();

    void itemTypesModelChanged();
    void itemPricesModelChanged();
    void copyMediaModelChanged();
    void musicCopyMediaModelChanged();
    void paymentMethodsModelChanged();

    void seriesTitleChanged(const QString &seriesTitle);
    void seasonChanged(const QString &season);

public slots:
    void initMoviesModel();
    void initSeriesModel();
    void initEpisodesModel();
    void initMusicModel();
    void initGamesModel();

    void initItemTypesModel();
    void initItemPricesModel();
    void initCopyMediaModel();
    void initMusicCopyMediaModel();
    void initPaymentMethodsModel();

    void filter(const ModelType &modelType, const QString &filter = QString());
    void sort(const ModelType &modelType,const int col, const Qt::SortOrder sortOrder = Qt::AscendingOrder);

private:
    QSortFilterProxyModel *m_moviesModel;
    QSortFilterProxyModel *m_seriesModel;
    QSortFilterProxyModel *m_episodesModel;
    QSortFilterProxyModel *m_musicModel;
    QSortFilterProxyModel *m_gamesModel;

    MbQueryModel *m_itemTypesModel;
    MbQueryModel *m_itemPricesModel;
    MbQueryModel *m_copyMediaModel;
    MbQueryModel *m_musicCopyMediaModel;
    MbQueryModel *m_paymentMethodsModel;


    // For getting episodes from database using series title and season
    QString m_seriesTitle;
    QString m_season;
};

#endif // MBPROXYQUERYMODEL_H
