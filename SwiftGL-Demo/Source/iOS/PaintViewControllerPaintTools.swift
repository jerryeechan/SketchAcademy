//
//  PaintViewControllerPaintTools.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    @IBAction func paintToolSelect(_ sender: UISegmentedControl) {
        
        //PaintToolManager.instance.changeTool(sender.selectedSegmentIndex)
        
        // brushScaleSlider.value = tool.vInfo.size
        
    }
    @IBAction func closeToolButtonTouched(_ sender: AnyObject) {
        toolViewState.animateHide(0.2)
    }
    
    @IBAction func brushScaleSegmentControlValueChanged(_ sender: UISegmentedControl) {
        var size:Float = 1;
        switch(sender.selectedSegmentIndex)
        {
        case 0:
            size = 5
        case 1:
            size = 10
            
        case 2:
            size = 20
        default:
            size = 10
        }
        
        paintView.paintBuffer.paintToolManager.changeSize(size)
    }
    
    
    
    @IBAction func brushScaleSliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        paintView.paintBuffer.paintToolManager.changeSize(value);
    }
    
    @IBAction func nearByColorButtonClicked(_ sender:UIButton)
    {
        colorPicker.setTheColor(sender.backgroundColor!)
    }
    
    @IBAction func paintToolButtonTouched(_ sender: UIButton) {
        
        
        if sender.tag <= 2 && sender.tag>=0
        {
            
            
            
            paintView.paintBuffer.setBrushDrawSetting(paintView.paintBuffer.paintToolManager.currentTool.toolType)
            
            
        }
        switch(sender.tag)
        {
        case 0:
            paintView.paintBuffer.paintToolManager.changeTool("oilbrush")
        case 1:
            paintView.paintBuffer.paintToolManager.changeTool("calligraphy")
        case 2:
            paintView.paintBuffer.paintToolManager.changeTool("flatpen")
        case 3:
            paintView.paintBuffer.paintToolManager.changeTool("pencil")
           break
            
        case -1:
            if !doubleTap
            {
               _ =  paintView.paintBuffer.paintToolManager.changeTool("eraser")
                paintView.paintBuffer.setBrushDrawSetting(paintView.paintBuffer.paintToolManager.currentTool.toolType)
                
            }
            doubleTap = false
        default:
           paintView.paintBuffer.paintToolManager.changeTool("pen")
        }
        
        
    }
    
    
    /////////////////////////////////////////////////////
    //
    //
    //
    //     Tool Knob
    //
    //
    //
    /////////////////////////////////////////////////////////
    @IBAction func toolKnobPanGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let dis = sender.translation(in: view)
        
        //ToolKnob.layer.transform = CATransform3DTranslate(ToolKnob.layer.transform, dis.x, dis.y, 0)
        
        //print(ToolKnob.layer.anchorPoint)
        
        ToolKnob.layer.position = CGPoint(x:ToolKnob.layer.position.x + dis.x , y:ToolKnob.layer.position.y + dis.y)
        print(ToolKnob.layer.position, terminator: "")
        sender.setTranslation(CGPoint.zero, in: view)
    }
}
