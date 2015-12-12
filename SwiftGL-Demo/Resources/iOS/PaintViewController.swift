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






class PaintViewController:UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet weak var colorPicker: ColorPicker!
   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        
    }
    enum AppState{
        case viewArtwork
        case viewRevision
        case drawArtwork
        case drawRevision
    }
    var fileName:String!
    var paintMode = PaintMode.Artwork
    var paintManager = PaintManager()
    var appState:AppState = .drawArtwork
    
   
    override func viewDidLoad() {
        toolBarItems = mainToolBar.items
        //mainView.addSubview(noteEditView)
        //noteEditView.frame.offsetInPlace(dx: noteEditView.frame.width, dy: 0)
        
        //the OpenCV
        //print(OpenCVWrapper.calculateImgSimilarity(UIImage(named: "img3"), secondImg: UIImage(named: "img2")))
        
        initAnimateState()
        
        playBackToolbar.clipsToBounds = true
        
        //imageView.image = RefImgManager.instance.refImg
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //imageView.userInteractionEnabled = true
        
        colorPicker.setTheColor(UIColor(hue: 0, saturation: 0.5, brightness: 0.5, alpha: 1.0))
        colorPicker.onColorChange = {(color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                let colors = getNearByColor(color)
                for i in 0...8
                {
                    self.nearbyColorButtons[i].backgroundColor = colors[i]
                }
                
                PaintToolManager.instance.changeColor(color)
            }
        }
        
        
        canvasPanGestureHandler = CanvasPanGestureHandler(pvController: self)

        PaintToolManager.instance.useCurrentTool()
        
        noteEditViewTopConstraint.constant = -384
        
        
        drawNoteEditTextViewStyle()
        
        
        
        
        paintManager.setProgressSlider(progressSlider)
        
        
        //noteEditTextView.delegate = self
        
        print("anchor");
        print(paintView.layer.transform)
        print(paintView.layer.anchorPoint)
        print(paintView.layer.position)
        //mainView.layoutIfNeeded()
        initMode(paintMode)
        if(fileName != nil)
        {
            NoteManager.instance.loadNotes(fileName)
            paintManager.loadArtwork(fileName)
        }
        else
        {
            NoteManager.instance.empty()
            GLContextBuffer.instance.display()
        }
        noteListTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func initMode(paintMode:PaintMode)
    {
        switch(paintMode)
        {
        case .Artwork:
            print("------Artwork Draw Mode-------")
            appState = .drawArtwork
            enterDrawMode()
        case .Revision:
            print("------Revision View Mode-------")
            appState = .viewArtwork
            enterViewMode()
        }
    }
    
    
    @IBOutlet weak var ToolKnob: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var paintView: PaintView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var brushScaleSlider: UISlider!
    
    var last_ori_pos:CGPoint = CGPoint(x: 0, y: 0)
    
    
    @IBAction func brushScaleSliderChanged(sender: UISlider) {
        PaintToolManager.instance.changeSize(sender.value)
    }
    
    
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
    
        func resetAnchor()
    {
        paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        paintView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        paintView.layer.position = CGPoint(x:512,y:406)
        
    }
    

    var pinchPoint:CGPoint!
    
    
    
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
    
    //replay control
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var doublePlayBackButton: UIBarButtonItem!
    
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    let playImage = UIImage(named: "Play-50")
    let pauseImage = UIImage(named: "Pause-50")
    
    var isCellSelectedSentbySlider:Bool = false
            
    
    
    
    
    
    
    
    //var canvasCropView:CanvasCropView!
    
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

      
    
    enum NoteEditMode{
        case Edit
        case New
    }
    var noteEditMode:NoteEditMode = .New
    
    //var selectedNote:Int = -1
    //var selectedNoteCell:NoteDetailCell!
    var selectedPath:NSIndexPath!
    
   

    
    
    
    
     @IBOutlet weak var noteEditTextView: UITextView!
    
     @IBOutlet weak var noteEditTitleTextField: UITextField!
    
    
    
    
    ///////////////////////////////////////////
    // toolbar buttons
    ///////////////////////////////////////////
    
    @IBOutlet weak var mainToolBar: UIToolbar!
    
    //add a note, only in
    @IBOutlet var addNoteButton: UIBarButtonItem!
    
    //結束批改，only in revision mode
    @IBOutlet var reviseDoneButton: UIBarButtonItem!
    
    
    //進入觀看模式
    @IBOutlet var enterViewModeButton: UIBarButtonItem!
    
    //進入繪圖模式
    @IBOutlet var enterDrawModeButton: UIBarButtonItem!
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
   
    
    var toolBarItems:[UIBarButtonItem]!
    
    deinit
    {
        GLContextBuffer.instance = nil
        colorPicker.onColorChange = nil
        colorPicker = nil
        canvasPanGestureHandler.paintViewController = nil
        
        addNoteButton = nil
        reviseDoneButton = nil
        enterViewModeButton = nil
        enterDrawModeButton = nil
        print("deinit")
    }
    
    
    
    /////// paint tool
    @IBOutlet weak var showToolButton: UIButton!
    @IBOutlet var nearbyColorButtons: [UIButton]!
    
    
    
    //replay
}




func CGPointToVec4(p:CGPoint)->Vec4
{
    return Vec4(x:Float(p.x),y: Float(p.y))
}

func CGPointToVec2(p:CGPoint)->Vec2
{
    return Vec2(x:Float(p.x),y: Float(p.y))
}

