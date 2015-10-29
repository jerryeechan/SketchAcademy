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
class PaintViewController:UIViewController, UITextViewDelegate
{
    @IBOutlet weak var colorPicker: ColorPicker!
   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        //mainView.addSubview(noteEditView)
        //noteEditView.frame.offsetInPlace(dx: noteEditView.frame.width, dy: 0)
        print(OpenCVWrapper.calculateImgSimilarity(UIImage(named: "img3"), secondImg: UIImage(named: "img2")))
        
        initAnimateState()
        
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
        
        
        canvasPanGestureHandler = CanvasPanGestureHandler(pvController: self)

        PaintToolManager.instance.useCurrentTool()
        
        noteEditViewTopConstraint.constant = -384
        mainView.layoutIfNeeded()
        
        drawNoteEditTextViewStyle()
        
        PaintReplayer.instance.progressSlider = progressSlider
        //noteEditTextView.delegate = self
        
        
        
    }
    
    
    /*
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return paintView
    }*/
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var paintView: PaintView!
    
    @IBOutlet weak var mainView: UIView!
    
    //@IBOutlet weak var brushScaleSlider: UISlider!
    
    
    
    
    
    
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
            if isCanvasManipulationEnabled
            {
              showNoteEditView()
            }
            break
            
        }
        
        
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
        case .Ended:()
            
            
            //paintView.layer.anchorPoint = CGPointZero
         //   paintView.layer.position = CGPointZero
            
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
    
    var isCellSelectedSentbySlider:Bool = false
    @IBAction func artworkProgressSliderDragged(sender: UISlider) {
        
        if PaintReplayer.instance.drawProgress(sender.value) == true //success draw
            {
                currentProgressValue = sender.value

                let index = NoteManager.instance.getNoteIndexFromStrokeID(PaintReplayer.instance.currentStrokeID)

                print("note index\(index)");
                if index != -1
                {
                    isCellSelectedSentbySlider = true
                    
                    noteListTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                    tableView(noteListTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                }
                else
                {
                    noteListTableView.deselectRowAtIndexPath(NSIndexPath(forRow: NoteManager.instance.selectedNoteIndex, inSection: 0), animated: true)
                }
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
        saveFileIOS9();
    }
    
    
    @IBAction func loadButtonTouched(sender: UIButton) {
       
        //UIAlertManager.instance.displayloadView(self)
        let fileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("fileTableView") as! FileTableViewController
        
        fileTableViewController.delegate = self
        
        self.presentViewController(fileTableViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func trashButtonTouched(sender: UIBarButtonItem) {
        PaintRecorder.instance.clear()
    }
    

    
    @IBAction func paintToolSelect(sender: UISegmentedControl) {
        
        PaintToolManager.instance.changeTool(sender.selectedSegmentIndex)
        
       // brushScaleSlider.value = tool.vInfo.size
        
    }
    
    @IBAction func brushScaleSliderValueChanged(sender: UISlider) {
        let value = sender.value
        PaintToolManager.instance.changeSize(value);
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
            enterNoteMode()
        }
        else
        {
            mode = AppMode.drawing
            playBackViewState.animateHide(0.2)
            noteListViewState.animateHide(0.2)
            toolViewState.isLocked = false
            //subViewAnimationGestureHandler.hidePlayBackView(0.2)
            //subViewAnimationGestureHandler.isToolPanelLocked = false
        }
        
    }
    
    var isCanvasManipulationEnabled:Bool = true
    
    //Extra Panels--------------------
    //Extra Panels-----------.---.----
    //Extra Panels-------------.------
    //Extra Panels--------------------
    //Extra Panels--------------------
    
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var toolViewLeadingConstraint: NSLayoutConstraint!
    var toolViewState:SubViewPanelAnimateState!
    
    
    
    @IBOutlet weak var noteEditView: UIView!
    @IBOutlet weak var noteEditViewTopConstraint: NSLayoutConstraint!
    var noteEditViewState:SubViewPanelAnimateState!
    
    @IBOutlet weak var noteListView: UIView!
    @IBOutlet weak var noteListTableView: UITableView!
    @IBOutlet weak var noteListViewTrailingConstraint: NSLayoutConstraint!
    var noteListViewState:SubViewPanelAnimateState!
    
    
    @IBOutlet weak var playBackToolbar: UIToolbar!
    @IBOutlet weak var playBackView: UIView!
    @IBOutlet weak var playBackViewBottomConstraint: NSLayoutConstraint!
    var playBackViewState:SubViewPanelAnimateState!

    func initAnimateState()
    {
        toolViewState = SubViewPanelAnimateState(view: toolView, constraint: toolViewLeadingConstraint, hideValue: -240, showValue: 0)
        
        noteEditViewState = SubViewPanelAnimateState(view: noteEditView, constraint: noteEditViewTopConstraint, hideValue: -384 , showValue: 0)
        
        noteListViewState = SubViewPanelAnimateState(view: noteListView, constraint: noteListViewTrailingConstraint, hideValue: -240, showValue: 0)
        
        playBackViewState = SubViewPanelAnimateState(view: playBackView, constraint: playBackViewBottomConstraint, hideValue: 128, showValue: 0)
        
        toolViewState.animateHide(0)
        noteListViewState.animateHide(0)
        playBackViewState.animateHide(0)
        
    }
    
    
    @IBAction func showToolViewButtonTouched(sender: UIBarButtonItem) {
        toolViewState.animateShow(0.2)
    }
    @IBAction func hideToolViewButtonTouched(sender: UIBarButtonItem) {
        toolViewState.animateHide(0.2)
    }
    
   
    
    @IBAction func noteEditButtonTouched(sender: UIBarButtonItem) {
        
        showNoteEditView()
        noteEditTextView.text = ""
        noteEditTitleTextField.text = ""
        noteEditMode = .New
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyBoardHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func onKeyBoardHide(notification:NSNotification)
    {
        hideNoteEditView()
    }

    
    @IBAction func noteEditViewCompleteButtonTouched(sender: AnyObject) {
        
        hideNoteEditView()
        noteDisplayTextView.text = noteEditTextView.text
        
        switch(noteEditMode)
        {
        case NoteEditMode.Edit:
            NoteManager.instance.editNote(noteEditTitleTextField.text!,description: noteEditTextView.text)
        case NoteEditMode.New:
                NoteManager.instance.addNote(noteEditTitleTextField.text!, description: noteEditTextView.text
            )
        }
        noteListTableView.reloadData()
        view.endEditing(true)
    }
   
    @IBAction func noteEditViewCancelButtonTouched(sender: UIBarButtonItem) {
        hideNoteEditView()
        view.endEditing(true)
    }
    
    
    
    enum NoteEditMode{
        case Edit
        case New
    }
    var noteEditMode:NoteEditMode = .New
    
    
    //tableViewStart
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableCell
        let note = NoteManager.instance.getNote(indexPath.row)
        
        cell.titleLabel.text = note.title
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.tag = indexPath.row
        
        //cell.editButton.addTarget(self, action: "editButtonTouched:", forControlEvents: .TouchUpInside)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteManager.instance.noteCount()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let note = NoteManager.instance.selectNote(indexPath.row)
        
        noteDisplayTextView.text = note.description
        if isCellSelectedSentbySlider
        {
            print("sent by slider")
            isCellSelectedSentbySlider = false
        }
        else
        {
            PaintReplayer.instance.drawStrokeProgress(note.value.strokeIndex)
            progressSlider.value = Float(note.value.strokeIndex)/Float(PaintReplayer.instance.strokeCount())
            
        }

    }
    
   

    @IBAction func noteCellEditButtonTouched(sender: UIButton) {
        let index = sender.tag
        print(sender.tag)
        let note = NoteManager.instance.getNote(index)
        showNoteEditView()
        noteEditTitleTextField.text = note.title
        noteEditTextView.text = note.description
        NoteManager.instance.editingNoteIndex = index
        noteEditMode = .Edit
        //noteListTableView.reloadData()
    }
    
    @IBAction func noteCellDeleteButtonTouched(sender: UIButton) {
        let index = sender.tag
        NoteManager.instance.deleteNote(index)
        noteListTableView.reloadData()
    }
    
    
    @IBOutlet weak var noteDisplayTextView: UITextView!
    
     @IBOutlet weak var noteEditTextView: UITextView!
    
     @IBOutlet weak var noteEditTitleTextField: UITextField!
    
    
    
   
    
    @IBAction func dismissButtonTouched(sender: UIBarButtonItem) {
        GLContextBuffer.instance.release()
        colorPicker.onColorChange = nil
        colorPicker = nil
        canvasPanGestureHandler.paintViewController = nil
        
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

