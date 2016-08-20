//
//  VisualizationViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/8/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
import Charts

class VisualizationViewController:UIViewController
{
    weak var delegate:PaintViewController!
    var graphView = ScrollableGraphView()
    var currentGraphType = GraphType.Dark
    var graphConstraints = [NSLayoutConstraint]()
    
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()
    
    // Data
    let numberOfDataItems = 100
    
    lazy var data: [Double] = self.generateRandomData(self.numberOfDataItems, max: 50)
    lazy var labels: [String] = self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
    
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var lineChartView: LineChartView!
    
    
    
    
    
    override func viewDidLoad() {
        
        
        /*
        super.viewDidLoad()
        
        graphView = createDarkGraph(self.view.frame)
        
        graphView.setData(data, withLabels: labels)
        self.view.addSubview(graphView)
        
        data = self.generateRandomData(self.numberOfDataItems, max: 50)
        
        let graphView2 = createDarkGraph(self.view.frame)
        
        graphView2.setData(data, withLabels: labels)
        self.view.addSubview(graphView2)
        setupConstraints()
        
        
        addLabel(withText: "DARK (TAP HERE)")
         */
        super.viewDidLoad()
        
        //setChart(months, values: unitsSold)
        setArtwork(delegate.paintManager.artwork)
    }
    func addDataSet(name:String,values: [Double],color:UIColor){
        var lineDataEntries:[ChartDataEntry] = []
        for i in 0..<values.count {
            lineDataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
            
        }
        let lineChartDataSet = LineChartDataSet(values: lineDataEntries, label: name)
        
        lineChartDataSet.setColor(color)
        lineChartDataSet.fillColor = color
        lineChartDataSet.mode = .CubicBezier
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        
        if((lineChartData) != nil)
        {
            lineChartData.addDataSet(lineChartDataSet)
            
        }
        else
        {
            lineChartData = LineChartData(dataSet: lineChartDataSet)
        }
        lineChartView.data = lineChartData
    }
    var lineChartData:LineChartData!
    func setChart(dataPoints: [String], values: [Double]) {
        //barChartView.noDataTextDescription = "GIVE REASON"
        var dataEntries: [BarChartDataEntry] = []
        var lineDataEntries:[ChartDataEntry] = []
        
        for i in 0..<values.count {
            //            //let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            //dataEntries.append(dataEntry)
            
            lineDataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
            
        }
        
        
        //let chartDataSet = BarChartDataSet(values: dataEntries,label: "Units Sold")
        
        //let chartData = BarChartData(dataSet:chartDataSet)
        //barChartView.data = chartData
        
        
        let lineChartDataSet = LineChartDataSet(values: lineDataEntries, label: "wtf")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.data = lineChartData
        lineChartView.gridBackgroundColor = NSUIColor.blackColor()
        lineChartView.backgroundColor = UIColor.grayColor()
        
        
    }
    func setArtwork(artwork:PaintArtwork)
    {
        let analyzer = StrokeAnalyzer()
        analyzer.analyze(artwork.currentClip.strokes)
        addDataSet("Force", values: analyzer.briefForces(),color:UIColor.cyanColor())
        addDataSet("Speed", values: analyzer.briefSpeeds(),color:UIColor.brownColor())
        addDataSet("Length", values: analyzer.briefLength(),color:UIColor.greenColor())
        //setChart([], values: )
    }
    func didTap(gesture: UITapGestureRecognizer) {
        
        currentGraphType.next()
        
        self.view.removeConstraints(graphConstraints)
        graphView.removeFromSuperview()
        
        /*
        switch(currentGraphType) {
        case .Dark:
            addLabel(withText: "DARK")
            graphView = createDarkGraph(self.view.frame)
        case .Dot:
            addLabel(withText: "DOT")
            graphView = createDotGraph(self.view.frame)
        case .Bar:
            addLabel(withText: "BAR")
            graphView = createBarGraph(self.view.frame)
        case .Pink:
            addLabel(withText: "PINK")
            graphView = createPinkMountainGraph(self.view.frame)
        }*/
        
        graphView.setData(data, withLabels: labels)
        self.view.insertSubview(graphView, belowSubview: label)
        
        setupConstraints()
    }

    private func createDarkGraph(frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        //graphView.backgroundFillColor = UIColor.colorFromHex("#333333")
        graphView.backgroundFillColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        graphView.lineWidth = 1
        graphView.lineColor = UIColor.colorFromHex("#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.Smooth
        
        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.Gradient
        graphView.fillColor = UIColor.colorFromHex("#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.Linear
        graphView.fillGradientStartColor = UIColor.colorFromHex("#555555")
        graphView.fillGradientEndColor = UIColor.colorFromHex("#444444")
        
        graphView.dataPointSpacing = 2
        graphView.dataPointSize = 1
        graphView.dataPointFillColor = UIColor.whiteColor()
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
        graphView.referenceLineColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.whiteColor()
        graphView.numberOfIntermediateReferenceLines = 5
        graphView.dataPointLabelColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        graphView.shouldAnimateOnStartup = false
        graphView.shouldAdaptRange = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.Elastic
        graphView.animationDuration = 0.1
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        return graphView
    }

    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    // Adding and updating the graph switching label in the top right corner of the screen.
    private func addLabel(withText text: String) {
        
        label.removeFromSuperview()
        label = createLabel(withText: text)
        label.userInteractionEnabled = true
        
        let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        
        let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: label.frame.width * 1.5)
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
        label.addGestureRecognizer(tapGestureRecogniser)
        
        self.view.insertSubview(label, aboveSubview: graphView)
        self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(14)
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }
    private func generateRandomData(numberOfItems: Int, max: Double) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(random()) % max
            
            if(random() % 100 < 10) {
                randomNumber *= 3
            }
            
            data.append(randomNumber)
        }
        return data
    }
    private func generateSequentialLabels(numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    // The type of the current graph we are showing.
    enum GraphType {
        case Dark
        case Bar
        case Dot
        case Pink
        
        mutating func next() {
            switch(self) {
            case .Dark:
                self = GraphType.Bar
            case .Bar:
                self = GraphType.Dot
            case .Dot:
                self = GraphType.Pink
            case .Pink:
                self = GraphType.Dark
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
