//
//  GraphCollectionViewCell.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit
import Highcharts

class GraphCollectionViewCell: UICollectionViewCell {

    @IBOutlet var chartView: HIChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createChart(dates: [String], max: [Temperature], min: [Temperature]) {
        let options = HIOptions()
        let chart = HIChart()
        chart.type = "line"
        
        let title = HITitle()
        title.text = "5 day Average Temperature"
        
        let subtitle = HISubtitle()
        subtitle.text = "Source: Accuweather"
        
        let xAxis = HIXAxis()
        xAxis.categories = dates
        
        let yAxisTitle = HITitle()
        yAxisTitle.text = "Temperature (\u{00B0}\(max.first?.unit ?? "C"))"
        
        let yAxis = HIYAxis()
        yAxis.title = yAxisTitle
        
        let plotOptions = HIPlotOptions()
        plotOptions.line = HILine()
        plotOptions.line.dataLabels = HIDataLabels()
        plotOptions.line.dataLabels.enabled = true
        plotOptions.line.enableMouseTracking = false
        
        let line1 = HILine()
        line1.name = "Maximum"
        
        var maxTemperature: [Int] = []
        for maxT in max {
            maxTemperature.append(maxT.value)
        }
        line1.data = maxTemperature

        
        let line2 = HILine()
        line2.name = "Minimum"
        var minTemperature: [Int] = []
        for minT in min {
            minTemperature.append(minT.value)
        }
        line2.data = minTemperature
        
        options.chart = chart
        options.title = title
        options.subtitle = subtitle
        options.xAxis = [xAxis]
        options.yAxis = [yAxis]
        options.plotOptions = plotOptions
        options.series = [line1, line2]
        
        chartView.options = options
    }

}
