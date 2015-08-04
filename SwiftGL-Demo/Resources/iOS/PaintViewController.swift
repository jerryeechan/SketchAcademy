//
//  PaintViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import GLKit
import SwiftGL
import OpenGLES
class PaintViewController: UIViewController,UIDocumentPickerDelegate
{
    //var pickerController:ColorPickerController!
    
   
    
    override func viewDidLoad() {
        
        imageView.image = RefImgManager.instance.refImg
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.userInteractionEnabled = true
        /*
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: huePicker!, colorWell: colorWell!)
        pickerController?.color = UIColor.redColor()
        
        
        pickerController?.onColorChange = {(color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                PaintToolManager.instance.changeColor(color)
            }
        }
        
        println(paintView.layer.anchorPoint)
        println(paintView.layer.position)
        
        */
        
    }
    /*
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return paintView
    }*/
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var paintView: PaintView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var brushScaleSlider: UISlider!
    
    
    
    var last_ori_pos:CGPoint = CGPoint(x: 0, y: 0)
    
    
    var twoTouchSwipeCount:Int = 0;
    
    enum TwoSwipeState{
        case Unknown
        case FastSwipe
        case Dragging
    }
    

    var twoSwipeState:TwoSwipeState = .Unknown
    
    
    @IBAction func imageViewPanGestureHandler(sender: UIPanGestureRecognizer) {
        let dis = sender.translationInView(imageView)
        
        print("image view pan")
        let scale = imageView.layer.transform.m11
        
        switch(sender.state)
        {
        case UIGestureRecognizerState.Changed:
            // CATransform3DMakeTranslation(dis.x/scale, dis.y/scale, 0)
             imageView.layer.transform = CATransform3DTranslate(imageView.layer.transform, dis.x/scale , dis.y/scale, 0)
        default:
            print("image view pan")
        }
        
        
        sender.setTranslation(CGPointZero, inView: imageView)
    }
    
    @IBAction func uiPanGestureHandler(sender: UIPanGestureRecognizer) {
        //let glkView = view as! GLKView
          //EAGLContext.setCurrentContext(glkView.context)
        let velocity = sender.velocityInView(paintView)
        
        let current_pos = sender.locationInView(paintView)
        
        //current_pos.y = CGFloat(paintView.bounds.height) - current_pos.y
        
        
        let dis = sender.translationInView(scrollView)
        

        
        if sender.numberOfTouches() == 2
        {
            /**
            Two touches
            **/
            
            
            switch(sender.state)
            {
            case UIGestureRecognizerState.Began:
                twoTouchSwipeCount = 0;
                twoSwipeState = TwoSwipeState.Unknown
            case UIGestureRecognizerState.Changed:
                if twoSwipeState == TwoSwipeState.Unknown
                {
                    let v = sender.velocityInView(scrollView)
                    print("velocity:\(v)")
                    if v.x < -600
                    {
                        twoSwipeState = TwoSwipeState.FastSwipe
                        print("fast swipe")
                        return
                    }
                    else if v.x>600
                    {
                        twoSwipeState = TwoSwipeState.FastSwipe
                        print("fast swipe")
                        return
                    }
                    
                    twoTouchSwipeCount++
                    if twoTouchSwipeCount > 20
                    {
                        twoSwipeState = TwoSwipeState.Dragging
                    }
                }
                else if twoSwipeState == TwoSwipeState.Dragging
                {
                    let scale = paintView.layer.transform.m11
                    paintView.layer.transform = CATransform3DTranslate(paintView.layer.transform, dis.x/scale , dis.y/scale, 0)
                }
                
            default: ()
                
            }
            
        }
        else
        {
            //record painting 
            let current_time = CFAbsoluteTimeGetCurrent()
            switch(sender.state)
            {
                
            case UIGestureRecognizerState.Began:
                PaintRecorder.instance.startPoint(CGPointToVec2(current_pos)*Float(paintView.contentScaleFactor), velocity: CGPointToVec2(velocity), time: current_time)
            case UIGestureRecognizerState.Changed:
                PaintRecorder.instance.movePoint(CGPointToVec2(current_pos)*Float(paintView.contentScaleFactor), velocity: CGPointToVec2(velocity), time: current_time)
            case UIGestureRecognizerState.Ended:
                PaintRecorder.instance.endStroke()
            default :
                return
            }

            
        }
        
        sender.setTranslation(CGPointZero, inView: scrollView)
    }
    
    
    @IBAction func uiTapGestureEvent(sender: UITapGestureRecognizer) {
        
        print("controller double tap")
        paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        
        //paintView.layer.transform = CATransform3DMakeTranslation(<#tx: CGFloat#>, <#ty: CGFloat#>, <#tz: CGFloat#>)
        
        paintView.layer.anchorPoint = CGPointZero
        paintView.layer.position = CGPointZero
        
    }
    var pinchPoint:CGPoint!
    
    @IBAction func uiPinchGestrueEvent(sender: UIPinchGestureRecognizer) {
        var center:CGPoint = CGPointMake(0, 0)
        for i in 0...sender.numberOfTouches()-1
        {
           let p = sender.locationOfTouch(i, inView: paintView)
            center.x += p.x
            center.y += p.y
        }
        
        center.x /= CGFloat(sender.numberOfTouches())
        center.y /= CGFloat(sender.numberOfTouches())
        
        setAnchorPoint(CGPointMake(center.x/paintView.bounds.size.width,center.y / paintView.bounds.size.height), forView: paintView)
        
        
        //println("anchor point\(center.x/paintView.bounds.size.width) \(center.y/paintView.bounds.size.height)")
        
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            
    
            
        case UIGestureRecognizerState.Changed:
            
            if sender.scale < 0.5
            {
                sender.scale = 0.5
            }
            else if sender.scale > 3
            {
                sender.scale = 3
            }
            paintView.layer.transform = CATransform3DScale(paintView.layer.transform, sender.scale, sender.scale, 1)
            
            //paintView.layer.transform = CATransform3DMakeScale(sender.scale, sender.scale, 1)
            //paintView.layer.transform = CGAffineTransformScale(paintView.transform, sender.scale, )
            sender.scale = 1
        default: ()
        }
        
        
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    var currentProgressValue:Float = 0
    
    
    @IBAction func ArtworkProgressSlide(sender: UISlider) {
            /*
        
        if sender.value > currentProgressValue {
            
        
            if PaintArtwork.instance.drawProgress(currentProgressValue,endPercentage: sender.value) == true //success draw
            {
                currentProgressValue = sender.value
            }
        }
        else{
            GLContextBuffer.erase()
            PaintArtwork.instance.drawProgress(0,endPercentage: sender.value)
            currentProgressValue = sender.value
        }
        
        GLContextBuffer.display()
        */
    }
    
    
    
    @IBOutlet weak var artworkProgressSlider: UISlider!
    
    
   
   
    @IBAction func colorPicking(sender: UISegmentedControl) {
        //PaintToolManager.instance. sender.selectedSegmentIndex
        
    }
    
    //@IBOutlet weak var colorPicker: ColorPicker!
    //@IBOutlet weak var huePicker: HuePicker!
    //@IBOutlet weak var colorWell: ColorWell!
    
    @IBAction func saveButtonTouched(sender: UIButton) {
        print("PaintViewController: save touch")
//        for iOS under 7 use default file name
        //PaintRecorder.instance.saveArtwork("file1.paw")
//
        saveFileIOS8();
    }
    /**
    save both paint tracks and the snapshot image
    */
    func saveFile(fileName:String)
    {
        
        let img = GLContextBuffer.instance.contextImage()
        PaintRecorder.instance.saveArtwork(fileName,img:img)
        GLContextBuffer.instance.releaseImgBuffer()

    }
    func saveFileIOS8()
    {
        let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        var inputTextField: UITextField?
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            self.saveFile(inputTextField!.text!)
        })
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        saveAlertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            inputTextField = textField
            // Here you can configure the text field (eg: make it secure, add a placeholder, etc)
        }
        
        saveAlertController.addAction(ok)
        saveAlertController.addAction(cancel)
        
        presentViewController(saveAlertController, animated: true, completion: nil)
    }
    
    /*
    func saveContextToImage()->UIImage
    {
        
        UIGraphicsBeginImageContext(paintView.bounds.size);
        paintView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }
*/
    
    @IBAction func loadButtonTouched(sender: UIButton) {
       
        //UIAlertManager.instance.displayloadView(self)
        let fileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("fileTableView") as! FileTableViewController
        
        self.presentViewController(fileTableViewController, animated: true, completion: nil)
        
    }
    
    

    @IBAction func clearButtonTouched(sender: UIButton) {
        PaintRecorder.instance.clear()
    }
    @IBAction func trashButtonTouched(sender: UIBarButtonItem) {
        PaintRecorder.instance.clear()
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
            
        }

    }
    
    @IBAction func paintToolSelect(sender: UISegmentedControl) {
        
        let tool:PaintBrush = PaintToolManager.instance.changeTool(sender.selectedSegmentIndex)
        
        brushScaleSlider.value = tool.vInfo.size
        
    }
    
    @IBAction func brushScaleSliderValueChanged(sender: UISlider) {
        let value = sender.value
        PaintToolManager.instance.changeSize(value);
    }
    
    
    /*
    @IBAction func loadDocBtnTouched(sender: UIBarButtonItem) {
        displayDocumentPicker()
    }
    func displayDocumentPicker()
    {
        var imgPicker = UIImagePickerController()
        
        var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], inMode: UIDocumentPickerMode.Import)
        
        documentPicker.delegate = self 
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
        
        
    }
    */
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _ = touches.count
        
        for t in touches {
            let touch = t 
            print(touch.majorRadius,touch.locationInView(view))
            
        }
        
        
    }
    
    
    @IBAction func PlayButtonTouched(sender: UIBarButtonItem) {
            PaintReplayer.instance.pauseToggle()
        
    }
    
    @IBAction func fastForwardButtonTouched(sender: UIBarButtonItem) {
        PaintReplayer.instance.doublePlayBackSpeed()
    }
    
    
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
        PaintReplayer.instance.restart()
    }
    
}




func CGPointToVec4(p:CGPoint)->Vec4
{
    return Vec4(x:Float(p.x),y: Float(p.y))
}

func CGPointToVec2(p:CGPoint)->Vec2
{
    return Vec2(x:Float(p.x),y: Float(p.y))
}

