package lecho.lib.hellocharts.renderer;

import android.content.Context;
import android.graphics.Canvas;

import java.util.ArrayList;
import java.util.List;

import lecho.lib.hellocharts.model.Viewport;
import lecho.lib.hellocharts.view.Chart;

public class ComboChartRenderer extends AbstractChartRenderer {

    protected List<ChartRenderer> renderers;
    protected Viewport unionViewport = new Viewport();

    public ComboChartRenderer(Context context, Chart chart) {
        super(context, chart);
        this.renderers = new ArrayList<>();
    }

    @Override
    public void initMaxViewport() {
        if (isViewportCalculationEnabled) {
            int rendererIndex = 0;
            for (ChartRenderer renderer : renderers) {
                renderer.initMaxViewport();
                if (rendererIndex == 0) {
                    unionViewport.set(renderer.getMaxViewport());
                } else {
                    unionViewport.union(renderer.getMaxViewport());
                }
                ++rendererIndex;
            }
            computator.setMaxViewport(unionViewport);
        }
    }

    @Override
    public void initCurrentViewport() {
        if (isViewportCalculationEnabled) {
            int rendererIndex = 0;
            for (ChartRenderer renderer : renderers) {
                renderer.initCurrentViewport();
                if (rendererIndex == 0) {
                    unionViewport.set(renderer.getCurrentViewport());
                } else {
                    unionViewport.union(renderer.getCurrentViewport());
                }
                ++rendererIndex;
            }
            computator.setCurrentViewport(unionViewport);
        }
    }

    @Override
    public void initDataMeasuremetns() {
        for (ChartRenderer renderer : renderers) {
            renderer.initDataMeasuremetns();
        }
    }

    @Override
    public void initDataAttributes() {
        super.initDataAttributes();
        for (ChartRenderer renderer : renderers) {
            renderer.initDataAttributes();
        }
    }

    @Override
    public void draw(Canvas canvas) {
        for (ChartRenderer renderer : renderers) {
            renderer.draw(canvas);
        }
    }

    @Override
    public void drawUnclipped(Canvas canvas) {
        for (ChartRenderer renderer : renderers) {
            renderer.drawUnclipped(canvas);
        }
    }

    @Override
    public boolean checkTouch(float touchX, float touchY) {
        selectedValue.clear();
        int rendererIndex = renderers.size() - 1;
        for (; rendererIndex >= 0; rendererIndex--) {
            ChartRenderer renderer = renderers.get(rendererIndex);
            if (renderer.checkTouch(touchX, touchY)) {
                selectedValue.set(renderer.getSelectedValue());
                break;
            }
        }

        //clear the rest of renderers if value was selected
        for (rendererIndex--; rendererIndex >= 0; rendererIndex--) {
            ChartRenderer renderer = renderers.get(rendererIndex);
            renderer.clearTouch();
        }

        return isTouched();
    }

    @Override
    public void clearTouch() {
        for (ChartRenderer renderer : renderers) {
            renderer.clearTouch();
        }
        selectedValue.clear();
    }
}
