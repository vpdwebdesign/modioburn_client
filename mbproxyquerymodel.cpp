#include <QSortFilterProxyModel>
#include <QSqlQuery>
#include <QDebug>

#include "mbproxyquerymodel.h"
#include "mbquerymodel.h"

MbProxyQueryModel::MbProxyQueryModel(QObject *parent)
    : QObject(parent)
{
    initMoviesModel();
    initSeriesModel();
    initMusicModel();
    initGamesModel();

    initItemTypesModel();
    initItemPricesModel();
    initCopyMediaModel();
    initMusicCopyMediaModel();
    initPaymentMethodsModel();
}

QSortFilterProxyModel *MbProxyQueryModel::moviesModel() const
{
    return m_moviesModel;
}

QSortFilterProxyModel *MbProxyQueryModel::seriesModel() const
{
    return m_seriesModel;
}

QSortFilterProxyModel *MbProxyQueryModel::episodesModel() const
{
    return m_episodesModel;
}

QSortFilterProxyModel *MbProxyQueryModel::musicModel() const
{
    return m_musicModel;
}

QSortFilterProxyModel *MbProxyQueryModel::gamesModel() const
{
    return m_gamesModel;
}

MbQueryModel *MbProxyQueryModel::itemTypesModel() const
{
    return m_itemTypesModel;
}

MbQueryModel *MbProxyQueryModel::itemPricesModel() const
{
    return m_itemPricesModel;
}

MbQueryModel *MbProxyQueryModel::copyMediaModel() const
{
    return m_copyMediaModel;
}

MbQueryModel *MbProxyQueryModel::musicCopyMediaModel() const
{
    return m_musicCopyMediaModel;
}

MbQueryModel *MbProxyQueryModel::paymentMethodsModel() const
{
    return m_paymentMethodsModel;
}

void MbProxyQueryModel::initMoviesModel()
{
    MbQueryModel *moviesModel = new MbQueryModel(this);
    QSortFilterProxyModel *moviesProxyModel = new QSortFilterProxyModel(this);
    QSqlQuery q("SELECT movies.title, movies.stars, movies.director, movies.category, movies.year, movies.file_path AS url, movies.trailer_url, movie_posters.thumb FROM movies, movie_posters WHERE movies.id = movie_posters.id");
    moviesModel->setQuery(q);
    moviesModel->generateRoleNames();

    moviesProxyModel->setSourceModel(moviesModel);

    m_moviesModel = moviesProxyModel;
}

void MbProxyQueryModel::initSeriesModel()
{
    MbQueryModel *seriesModel = new MbQueryModel(this);
    QSortFilterProxyModel *seriesProxyModel = new QSortFilterProxyModel(this);

    QSqlQuery q("SELECT series.title, series.season, series.stars, series.category, series.year, series.trailer_url, series_posters.thumb FROM series, series_posters WHERE series.id = series_posters.id");

    seriesModel->setQuery(q);
    seriesModel->generateRoleNames();

    seriesProxyModel->setSourceModel(seriesModel);

    m_seriesModel = seriesProxyModel;
}

void MbProxyQueryModel::initEpisodesModel()
{
    qDebug() << m_seriesTitle << m_season;
    MbQueryModel *episodesModel = new MbQueryModel(this);
    QSortFilterProxyModel *episodesProxyModel = new QSortFilterProxyModel(this);

    QString seriesTitle_(m_seriesTitle);
    QString season_(m_season);

    QSqlQuery q(QString("SELECT e.title, e.aired, e.file_path "
                        "FROM episodes e "
                        "WHERE e.id IN "
                        "(SELECT DISTINCT(episode_id) "
                        " FROM series_episodes se "
                        "JOIN series s ON se.series_id = s.id "
                        "WHERE lower(s.title) = %1 AND s.season = %2)")
                        .arg("'" + seriesTitle_ + "'")
                        .arg("'" + season_ + "'"));

    episodesModel->setQuery(q);
    episodesModel->generateRoleNames();

    episodesProxyModel->setSourceModel(episodesModel);

    m_episodesModel = episodesProxyModel;
}

void MbProxyQueryModel::initMusicModel()
{
    MbQueryModel *musicModel = new MbQueryModel(this);
    QSortFilterProxyModel *musicProxyModel = new QSortFilterProxyModel(this);

    QSqlQuery q("SELECT music.title, music.artist, music.album, music.category, music.year, music.duration, music.file_path AS url, music_album_cover_art.thumb FROM music, music_album_cover_art WHERE music.id = music_album_cover_art.id");

    musicModel->setQuery(q);
    musicModel->generateRoleNames();

    musicProxyModel->setSourceModel(musicModel);

    m_musicModel = musicProxyModel;
}

void MbProxyQueryModel::initGamesModel()
{
    MbQueryModel *gamesModel = new MbQueryModel(this);
    QSortFilterProxyModel *gamesProxyModel = new QSortFilterProxyModel(this);

    QSqlQuery q("SELECT games.title, games.developer, games.publisher, games.category, games.year, games.trailer_url, games_posters.thumb FROM games, games_posters WHERE games.id = games_posters.id");
    gamesModel->setQuery(q);
    gamesModel->generateRoleNames();

    gamesProxyModel->setSourceModel(gamesModel);

    m_gamesModel = gamesProxyModel;
}

void MbProxyQueryModel::initItemTypesModel()
{
    MbQueryModel *itemTypesModel = new MbQueryModel(this);

    QSqlQuery q("SELECT item_types.item_type FROM item_types "
                "ORDER BY item_types.id ASC");
    itemTypesModel->setQuery(q);
    itemTypesModel->generateRoleNames();

    m_itemTypesModel = itemTypesModel;
}

void MbProxyQueryModel::initItemPricesModel()
{
    MbQueryModel *itemPricesModel = new MbQueryModel(this);

    QSqlQuery q("SELECT item_types.item_type, item_prices.price_per_unit "
                "FROM item_types, item_prices "
                "WHERE item_types.id = item_prices.item_type_id "
                "ORDER BY item_types.id ASC");
    itemPricesModel->setQuery(q);
    itemPricesModel->generateRoleNames();

    m_itemPricesModel = itemPricesModel;
}

void MbProxyQueryModel::initCopyMediaModel()
{
    MbQueryModel *copyMediaModel = new MbQueryModel(this);

    QSqlQuery q("SELECT copy_media.copy_medium FROM copy_media "
                "ORDER BY copy_media.id ASC");
    copyMediaModel->setQuery(q);
    copyMediaModel->generateRoleNames();

    m_copyMediaModel = copyMediaModel;
}

void MbProxyQueryModel::initMusicCopyMediaModel()
{
    MbQueryModel *musicCopyMediaModel = new MbQueryModel(this);

    QSqlQuery q("SELECT video_copy_media.video_copy_medium FROM video_copy_media "
                "ORDER BY video_copy_media.id ASC");
    musicCopyMediaModel->setQuery(q);
    musicCopyMediaModel->generateRoleNames();

    m_musicCopyMediaModel = musicCopyMediaModel;

}

void MbProxyQueryModel::initPaymentMethodsModel()
{
    MbQueryModel *paymentMethodsModel = new MbQueryModel(this);

    QSqlQuery q("SELECT payment_methods.payment_method FROM payment_methods "
                "ORDER BY payment_methods.id ASC");
    paymentMethodsModel->setQuery(q);
    paymentMethodsModel->generateRoleNames();

    m_paymentMethodsModel = paymentMethodsModel;

}

void MbProxyQueryModel::filter(const ModelType &modelType, const QString &filter)
{
    QSortFilterProxyModel *model = new QSortFilterProxyModel(this);

    switch (modelType) {
    case Movies:
        model = m_moviesModel;
        break;
    case Series:
        model = m_seriesModel;
        break;
    case Music:
        model = m_musicModel;
        break;
    case Games:
        model = m_gamesModel;
        break;
    default:
        break;
    }

    // Filter test
    QRegExp regExp(filter, Qt::CaseInsensitive, QRegExp::FixedString);

    model->setFilterRegExp(regExp);
    model->setFilterKeyColumn(-1);
    qDebug() << "Filter Called: filter string =" << filter;
}

void MbProxyQueryModel::sort(const ModelType &modelType, const int col, const Qt::SortOrder sortOrder)
{
    QSortFilterProxyModel *model = new QSortFilterProxyModel(this);

    switch (modelType) {
    case Movies:
        model = m_moviesModel;
        break;
    case Series:
        model = m_seriesModel;
        break;
    case Music:
        model = m_musicModel;
        break;
    case Games:
        model = m_gamesModel;
        break;
    default:
        break;
    }

    // Sort Test
    model->setSortCaseSensitivity(Qt::CaseInsensitive);
    model->sort(col, sortOrder);
    qDebug() << "Sort Called: sort column =" << col;
}

QString MbProxyQueryModel::season() const
{
    return m_season;
}

void MbProxyQueryModel::setSeason(const QString &season)
{
    if (m_season != season)
    {
        m_season = season;
        emit seasonChanged(season);
    }
}

QString MbProxyQueryModel::seriesTitle() const
{
    return m_seriesTitle;
}

void MbProxyQueryModel::setSeriesTitle(const QString &seriesTitle)
{
    if (m_seriesTitle != seriesTitle)
    {
        m_seriesTitle = seriesTitle;
        emit seriesTitleChanged(seriesTitle);
    }
}

