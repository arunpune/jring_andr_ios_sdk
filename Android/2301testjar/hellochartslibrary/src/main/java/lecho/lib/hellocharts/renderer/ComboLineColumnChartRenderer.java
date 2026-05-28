package lecho.lib.hellocharts.renderer;

import android.content.Context;

import lecho.lib.hellocharts.provider.ColumnChartDataProvider;
import lecho.lib.hellocharts.provider.LineChartDataProvider;
import lecho.lib.hellocharts.view.Chart;

public class ComboLineColumnChartRenderer extends ComboChartRenderer {

    public static final int TYPE_LINE = 1;
    public static final int TYPE_COLUMN = 2;

    private ColumnChartRenderer columnChartRenderer;
    private LineChartRenderer lineChartRenderer;

    public ComboLineColumnChartRenderer(Context context, Chart chart, ColumnChartDataProvider columnChartDataProvider,
                                        LineChartDataProvider lineChartDataProvider) {
        this(context, chart, new ColumnChartRenderer(context, chart, columnChartDataProvider),
                new LineChartRenderer(context, chart, lineChartDataProvider));
    }

    public ComboLineColumnChartRenderer(Context context, Chart chart, ColumnChartRenderer columnChartRenderer,
                                        LineChartDataProvider lineChartDataProvider) {
        this(context, chart, columnChartRenderer, new LineChartRenderer(context, chart, lineChartDataProvider));
    }

    public ComboLineColumnChartRenderer(Context context, Chart chart, ColumnChartDataProvider columnChartDataProvider,
                                        LineChartRenderer lineChartRenderer) {
        this(context, chart, new ColumnChartRenderer(context, chart, columnChartDataProvider), lineChartRenderer);
    }

    public ComboLineColumnChartRenderer(Context context, Chart chart, ColumnChartRenderer columnChartRenderer,
                                        LineChartRenderer lineChartRenderer) {
        super(context, chart);

        this.columnChartRenderer = columnChartRenderer;
        this.lineChartRenderer = lineChartRenderer;

        renderers.add(this.columnChartRenderer);
        renderers.add(this.lineChartRenderer);
    }

    @Override
    public boolean checkTouch(float touchX, float touchY) {
        selectedValue.clear();

        // Lines are drawn on top, so check line touch first
        if (lineChartRenderer.checkTouch(touchX, touchY)) {
            selectedValue.set(lineChartRenderer.getSelectedValue());
            selectedValue.setThirdIndex(TYPE_LINE);
        } else if (columnChartRenderer.checkTouch(touchX, touchY)) {
            selectedValue.set(columnChartRenderer.getSelectedValue());
            selectedValue.setThirdIndex(TYPE_COLUMN);
        }

        // Clear touch on the other renderer
        if (isTouched()) {
            if (selectedValue.getThirdIndex() == TYPE_LINE) {
                columnChartRenderer.clearTouch();
            } else {
                lineChartRenderer.clearTouch();
            }
        }

        return isTouched();
    }
}