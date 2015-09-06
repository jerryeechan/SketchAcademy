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
func getViewController(identifier:String)->UIViewController
{
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
}
class PaintViewController:UIViewController,UIDocumentPickerDelegate, UITextViewDelegate
{
    @IBOutlet weak var colorPicker: ColorPicker!
    
    
    
    @IBOutlet weak var playBackToolbar: UIToolbar!
    
    @IBOutlet weak var playBackView: UIView!
    @IBOutlet weak var noteEditTextView: UITextView!
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        //mainView.addSubview(noteEditView)
        //noteEditView.frame.offsetInPlace(dx: noteEditView.frame.width, dy: 0)
        
        
        
        playBackToolbar.clipsToBounds = true
        
        //imageView.image = RefImgManager.instance.refImg
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //imageView.userInteractionEnabled = true
        
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
        edgeGestureHandler = EdgeGestureHandler(pvController: self)
        PaintToolManager.instance.useCurrentTool()
        
        //noteEditViewTopConstraint.constant = -384
        mainView.layoutIfNeeded()
        //noteEditTextView.delegate = self
        
    }
    /*
    func textViewDidBeginEditing(textView: UITextView) {
    }*/
    
    
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
        
        switch(mode)
        {
        case AppMode.drawing:
            print("controller double tap")
            paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            paintView.layer.anchorPoint = CGPointZero
            paintView.layer.position = CGPointZero
        case AppMode.browsing:
            //view.addSubview(noteEditView)
            showNoteEditModal()
            break
            
        }
        
        
    }
    
    
    var noteEditViewOriginCenter:CGPoint!
    
    
    @IBOutlet weak var noteEditViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func noteEditButtonTouched(sender: UIBarButtonItem) {
        
        paintView.layer.position = CGPointZero
        paintView.layer.anchorPoint = CGPointZero
        
        
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = 0
            self.noteEditView.layoutIfNeeded()
            
            })
        
        noteEditTextView.becomeFirstResponder()
        
        /*
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            self.noteEditView.center.y = self.noteEditViewOriginCenter.y
        })
        */
    }
    
    @IBOutlet weak var noteEditView: UIView!
    
    func showNoteEditModal()
    {
//
        let noteEditController =  getViewController("NoteEdit")
        
        
        noteEditController.modalPresentationStyle = UIModalPresentationStyle.Popover
        noteEditController.preferredContentSize = CGSize(width: 600, height: 400)
        
        let popoverController = noteEditController.popoverPresentationController
        popoverController?.permittedArrowDirections = .Any
        
        
        //popoverController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        popoverController?.sourceView = view
        
        
        
        presentViewController(noteEditController, animated: true, completion: nil)
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
        case .Ended:
            paintView.layer.anchorPoint = CGPointZero
            paintView.layer.position = CGPointZero
            
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
        
        PaintToolManager.instance.changeTool(sender.selectedSegmentIndex)
        
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
    
    
    
    
    
    var canvasCropView:CanvasCropView!
    
    func getView(name:String)->UIView
    {
        return NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)![0] as! UIView
    }
    
    
    
    
    /*
    @IBAction func addNoteButtonTouched(sender: UIBarButtonItem) {
    displayCropView()
    }
    
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
*/
    
    
    @IBAction func modeSwitcherValueChanged(sender: UISwitch) {
        if sender.on
        {
            mode = AppMode.browsing
            edgeGestureHandler.showPlayBackView(0.2)
            edgeGestureHandler.hideToolView(0.2)
            edgeGestureHandler.isToolPanelLocked = true
            progressSlider.value = 1

        }
        else
        {
            mode = AppMode.drawing
            edgeGestureHandler.hidePlayBackView(0.2)
            edgeGestureHandler.isToolPanelLocked = false
        }
        
    }
    
    
    @IBAction func noteEditViewCompleteButtonTouched(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(1, 1, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = -384
            self.noteEditView.layoutIfNeeded()
            
            
        })
        noteDisplayTextView.text = noteEditTextView.text
        view.endEditing(true)
    }
   
   
    @IBOutlet weak var toolViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playBackViewBottomConstraint: NSLayoutConstraint!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath)
        let note = NoteManager.instance.noteList[indexPath.row]
        
        //cell.imageView?.image = FileManager.instance.loadImg(fName)
        cell.textLabel?.text = note.title
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteManager.instance.noteList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fileName = FileManager.instance.fileNames[indexPath.row]
        
        PaintRecorder.instance.loadArtwork(fileName)
        //FileManager.instance.loadPaintArtWork(fileName).replayAll()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBOutlet weak var noteDisplayTextView: UITextView!
    
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

