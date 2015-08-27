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
    @IBOutlet weak var colorPicker: ColorPicker!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBOutlet weak var playBackToolbar: UIToolbar!
    
    @IBOutlet weak var playBackView: UIView!
    
    override func viewDidLoad() {
        playBackToolbar.clipsToBounds = true
        
        imageView.image = RefImgManager.instance.refImg
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.userInteractionEnabled = true
        
        colorPicker.setTheColor(UIColor(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 1.0))
        colorPicker.onColorChange = {(color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                PaintToolManager.instance.changeColor(color)
            }
        }
        
        /*
        pickerController?.color = UIColor.redColor()
        
        
        pickerController?.onColorChange = {(color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                PaintToolManager.instance.changeColor(color)
            }
        }*/
        
        canvasPanGestureHandler = CanvasPanGestureHandler(pvController: self)
        
        
        
    }
    override func viewDidLayoutSubviews() {
        edgeGestureHandler = EdgeGestureHandler(pvController: self)
        PaintToolManager.instance.useCurrentTool()
    }
    
    /*
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return paintView
    }*/
    
    var edgeGestureHandler:EdgeGestureHandler!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var paintView: PaintView!
    
    @IBOutlet weak var mainView: UIView!
    
    //@IBOutlet weak var brushScaleSlider: UISlider!
    
    
    @IBOutlet weak var toolView: UIView!
    
    
    var last_ori_pos:CGPoint = CGPoint(x: 0, y: 0)
    
    
    

    
    
    
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
    
    var rect:GLRect!
    
    var canvasPanGestureHandler:CanvasPanGestureHandler!
    
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBAction func uiPanGestureHandler(sender: UIPanGestureRecognizer) {
        //let glkView = view as! GLKView
          //EAGLContext.setCurrentContext(glkView.context)
        
        canvasPanGestureHandler.panGestureHandler(sender)
        
        
        
    }
    
    
    @IBAction func uiTapGestureEvent(sender: UITapGestureRecognizer) {
        
        print("controller double tap")
        paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        
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
            
            
            if paintView.layer.transform.m11 * sender.scale <= 1
            {
                paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
                paintView.layer.anchorPoint = CGPointZero
                paintView.layer.position = CGPointZero
            }
            else if paintView.layer.transform.m11 * sender.scale > 3
            {
                paintView.layer.transform = CATransform3DMakeScale(3, 3, 1)
            }
            else
            {
                paintView.layer.transform = CATransform3DScale(paintView.layer.transform, sender.scale, sender.scale, 1)
            }
            
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
    
    
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBAction func artworkProgressSliderDragged(sender: UISlider) {
        let artwork = PaintRecorder.instance.artwork
        if PaintReplayer.instance.drawProgress(artwork,percentage: sender.value) == true //success draw
            {
                currentProgressValue = sender.value
            }
    }
        
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
    
    
    @IBAction func trashButtonTouched(sender: UIBarButtonItem) {
        PaintRecorder.instance.clear()
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
            
        }
        

    }
    
    @IBAction func paintToolSelect(sender: UISegmentedControl) {
        
        let tool:PaintBrush = PaintToolManager.instance.changeTool(sender.selectedSegmentIndex)
        
       // brushScaleSlider.value = tool.vInfo.size
        
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
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _ = touches.count
        
        for t in touches {
            let touch = t 
            print(touch.majorRadius,touch.locationInView(view))
            
        }
        
        
        
    }
    */
    
    @IBAction func PlayButtonTouched(sender: UIBarButtonItem) {
            PaintReplayer.instance.pauseToggle()
        
    }
    
    @IBAction func fastForwardButtonTouched(sender: UIBarButtonItem) {
        PaintReplayer.instance.doublePlayBackSpeed()
    }
    
    
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
        PaintReplayer.instance.restart()
    }
    
    enum AppMode{
        case drawing
        case browsing
    }
    
    var mode:AppMode = .drawing
    
    @IBAction func addNoteButtonTouched(sender: UIBarButtonItem) {
        displayCropView()
    }
    
    
    
    var canvasCropView:CanvasCropView!
    func displayCropView()
    {
        if !isEditingRectangle
        {
            
            let viewRect = CGRectMake(0, 0, paintView.bounds.size.width,paintView.bounds.size.height);
            canvasCropView = CanvasCropView(frame: viewRect)
            mainView.addSubview(canvasCropView)
            isEditingRectangle = true
        }
        else
        {
            canvasCropView.removeFromSuperview()
            isEditingRectangle = false
        }
        
        
    }
    
    func getView(name:String)->UIView
    {
        return NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)![0] as! UIView
    }
    
    @IBOutlet weak var reviseNoteView: UIView!
   
    var reviseNoteStartPoint:CGPoint!
    var isEditingRectangle:Bool = false
    @IBAction func notePanGestureRecognizerHandler(sender: UIPanGestureRecognizer) {
        
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            reviseNoteStartPoint = reviseNoteView.center
        case UIGestureRecognizerState.Changed:
            let dis = sender.translationInView(reviseNoteView)
            //reviseNote.center = CGPoint(x: reviseNoteStartPoint.x + dis.x, y: reviseNoteStartPoint.y + dis.y)
            reviseNoteView.frame = CGRectOffset(reviseNoteView.frame, dis.x,dis.y)
            
            sender.setTranslation(CGPoint(x: 0,y: 0), inView: reviseNoteView
            )
        default:
            return
        }
    }
    
    
    @IBAction func eidtModeButtonTouched(sender: UIBarButtonItem) {
        
            }
    
    @IBAction func modeSwitcherValueChanged(sender: UISwitch) {
        if sender.on
        {
            mode = AppMode.browsing
            edgeGestureHandler.showPlayBackView()
            edgeGestureHandler.hideToolView()
            edgeGestureHandler.isToolPanelLocked = true
            progressSlider.value = 1

        }
        else
        {
            mode = AppMode.drawing
            edgeGestureHandler.hidePlayBackView()
            edgeGestureHandler.isToolPanelLocked = false
        }
        
    }
    
    
    @IBAction func dismissButtonTouched(sender: UIBarButtonItem) {
        GLContextBuffer.instance.release()
        colorPicker.onColorChange = nil
        colorPicker = nil
        canvasPanGestureHandler.paintViewController = nil
        edgeGestureHandler.pvController = nil
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        //dismissViewControllerAnimated(true, completion: nil)
        
        
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

