
class QgsMapToolIdentify : QgsMapTool
{
%TypeHeaderCode
#include <qgsmaptoolidentify.h>
%End

  public:
    enum IdentifyMode
    {
        DefaultQgsSetting=-1,
        ActiveLayer,
        TopDownStopAtFirst,
        TopDownAll,
    };

    enum LayerType
    {
        AllLayers=-1,
        VectorLayer,
        RasterLayer,
    };

    struct VectorResult
    {
        VectorResult();
        VectorResult(QgsVectorLayer* layer, QgsFeature feature, QMap< QString, QString > derivedAttributes);
        QgsVectorLayer* mLayer;
        QgsFeature mFeature;
        QMap< QString, QString > mDerivedAttributes;
    };
    
    struct RasterResult
    {
        RasterResult();
        RasterResult( QgsRasterLayer* layer, QString label, QMap< QString, QString > attributes, QMap< QString, QString > derivedAttributes);
        QgsRasterLayer* mLayer;
        QString mLabel;
        QMap< QString, QString > mAttributes;
        QMap< QString, QString > mDerivedAttributes;
    };

    struct IdentifyResults
    {
        IdentifyResults();
        IdentifyResults ( QList<QgsMapToolIdentify::VectorResult> vectorResults , QList<QgsMapToolIdentify::RasterResult> rasterResults); 
        QList<QgsMapToolIdentify::VectorResult> mVectorResults;
        QList<QgsMapToolIdentify::RasterResult> mRasterResults;
    };

	//! constructor
    QgsMapToolIdentify( QgsMapCanvas* canvas );

    //! Overridden mouse move event
    virtual void canvasMoveEvent( QMouseEvent * e );

    //! Overridden mouse press event
    virtual void canvasPressEvent( QMouseEvent * e );

    //! Overridden mouse release event
    virtual void canvasReleaseEvent( QMouseEvent * e );

    virtual void activate();

    virtual void deactivate();

    //QgsMapLayer::LayerType LayerType;

    /** Performs the identification.
    @param x x coordinates of mouseEvent
    @param y y coordinates of mouseEvent
    @param layerList Performs the identification within the given list of layers. Default value is an empty list, i.e. uses all the layers.
    @param mode Identification mode. Can use Qgis default settings or a defined mode. Default mode is DefaultQgsSetting.
    @return true if identification succeeded and a feature has been found, false otherwise.*/
    bool identify(int x, int y, QList<QgsMapLayer*> layerList = QList<QgsMapLayer*>(), IdentifyMode mode = DefaultQgsSetting);

    /** Performs the identification.
    To avoid beeing forced to specify IdentifyMode with a list of layers
    this has been made private and two publics methods are offered
    @param x x coordinates of mouseEvent
    @param y y coordinates of mouseEvent
    @param mode Identification mode. Can use Qgis default settings or a defined mode.
    @param layerType Only performs identification in a certain type of layers (raster, vector). Default value is AllLayers.
    @return true if identification succeeded and a feature has been found, false otherwise.*/
    bool identify(int x, int y, IdentifyMode mode, LayerType layerType = AllLayers);

    /** Access to results */
    IdentifyResults &results();

  signals:
    void identifyProgress( int, int );
    void identifyMessage( QString );

  private:
    //! Private helper
    virtual void convertMeasurement( QgsDistanceArea &calc, double &measure, QGis::UnitType &u, bool isArea );

    /** Transforms the measurements of derived attributes in the desired units*/
    virtual QGis::UnitType displayUnits();
};
