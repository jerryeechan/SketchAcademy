//
//  PaintViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

func DLog(message: String, filename: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__){
    #if DEBUG
         print("\((filename as NSString).lastPathComponent):\(line) \(function):\(message)")
    #else
        print("not debug")
    #endif
}

import GLKit
import SwiftGL
import OpenGLES
func getViewController(identifier:String)->UIViewController
{
    
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
    
}






class PaintViewController:UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate
{
    var themeDarkColor:UIColor!
    var themeLightColor:UIColor!
    
    //UI size attributes
    var viewWidth:CGFloat!
    
   
    
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
    static let canvasWidth:GLint = 1366
    
    static let canvasHeight:GLint = 1024
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var singlePanGestureRecognizer: UIPanGestureRecognizer!
    
    var currentTouchType:String = "None"
    
    override func viewDidLoad() {

        paintView = PaintView(frame: CGRectMake(0, 0, CGFloat(PaintViewController.canvasWidth), CGFloat(PaintViewController.canvasHeight)))
        paintView.multipleTouchEnabled = true
        canvasBGView.addSubview(paintView)
        paintView.addGestureRecognizer(singlePanGestureRecognizer)
        //the OpenCV
        //print(OpenCVWrapper.calculateImgSimilarity(UIImage(named: "img3"), secondImg: UIImage(named: "img2")))

        
        toolBarItems = mainToolBar.items
        initAnimateState()
        
        //weak var paintToolManager = PaintToolManager.instance
        
        nearbyColorButtons = nearbyColorButtons.sort({b1,b2 in return b1.tag > b2.tag})
        
        colorPicker.onColorChange = {[weak self](unowned color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
                DLog("finished")
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                GLContextBuffer.instance.paintToolManager.changeColor(color)
                let colors = getNearByColor(color)
                
                for i in 0...8
                {
                    unowned let button = self!.nearbyColorButtons[i] as! UIButton
                    button.backgroundColor = colors[i]
                    
                }
            }
        }
        
        
        ////

        //canvasPanGestureHandler = CanvasPanGestureHandler(pvController: self)

        GLContextBuffer.instance.paintToolManager.useCurrentTool()
        
       // noteEditViewTopConstraint.constant = -384
        
        
       // drawNoteEditTextViewStyle()
        
        paintManager.masterReplayer.onProgressValueChanged = {[weak self](value) in
            self!.replayProgressBar.setProgress(value, animated: false)
        }
        ////
        
        //paintManager.setProgressSlider(progressSlider)
        
        
        //noteEditTextView.delegate = self
        
        print("anchor");
        print(paintView.layer.transform)
        print(paintView.layer.anchorPoint)
        print(paintView.layer.position)
        //mainView.layoutIfNeeded()
        
        if(fileName != nil)
        {
            NoteManager.instance.loadNotes(fileName)
            paintManager.loadArtwork(fileName)
        }
        else
        {
            NoteManager.instance.empty()
            PaintView.display()
        }
        viewWidth = view.contentScaleFactor * view.frame.width
        noteListTableView.reloadData()
        setUpNoteProgressButton()
        initMode(paintMode)

    }
    
    override func viewDidAppear(animated: Bool) {
        colorPicker.setTheColor(UIColor(hue: 0, saturation: 0.5, brightness: 0.5, alpha: 1.0))
        
        
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
    
    
 
    @IBOutlet weak var canvasBGView: UIView!
    
//    @IBOutlet weak var paintView: PaintView!
    
    var paintView: PaintView!
    
    @IBOutlet weak var mainView: UIView!
    
   
    
    @IBOutlet weak var brushScaleSlider: UISlider!
    
    var last_ori_pos:CGPoint = CGPoint(x: 0, y: 0)
    
    
    @IBAction func brushScaleSliderChanged(sender: UISlider) {
        GLContextBuffer.instance.paintToolManager.changeSize(sender.value)
    }
    
    //note related
     @IBOutlet weak var noteButtonView: NoteProgressView!
    
    @IBOutlet weak var noteTitleField: UITextField!
    
    @IBOutlet weak var noteDescriptionTextView: UITextView!
    
    @IBOutlet weak var noteDetailView: NoteTextView!
    
    var rect:GLRect!
    
    //var canvasPanGestureHandler:CanvasPanGestureHandler!
    
    //@IBOutlet weak var canvasImageView: UIImageView!
    
        func resetAnchor()
    {
        self.paintView.rotation = 0
        self.paintView.translation = CGPoint.zero
        self.paintView.scale = 1
        paintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        paintView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        paintView.layer.position = CGPoint(x:mainView.frame.width/2,y:        mainView.frame.height/2)
        
        imageView.image = GLContextBuffer.instance.image
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
    
    //replay control
    
    @IBOutlet weak var replayProgressBar: UIProgressView!
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
    
   
   
    //plus button in note table
    @IBOutlet weak var addNoteButton: UIBarButtonItem!
    
    
    
     @IBOutlet weak var noteEditTextView: UITextView!
    
     @IBOutlet weak var noteEditTitleTextField: UITextField!
    
    
    
    
    ///////////////////////////////////////////
    // toolbar buttons
    ///////////////////////////////////////////
    
    @IBOutlet weak var mainToolBar: UIToolbar!
    
    //add a note, only in
//    @IBOutlet var addNoteButton: UIBarButtonItem!
    
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
        PaintView.instance = nil
        
        print("deinit")
    }
    
    
    
    /////// paint tool
    @IBOutlet weak var showToolButton: UIButton!
    @IBOutlet var nearbyColorButtons: NSArray!//[UIButton]!
    
    @IBOutlet weak var colorGradientView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
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

