//
//  PaintViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

func DLog(message: String, filename: String = #file, line: Int = #line, function: String = #function){
    #if DEBUG
         print("\((filename as NSString).lastPathComponent):\(line):\(message)")
    #else
        print("not debug")
    #endif
}
import AVKit
import GLKit
import SwiftGL
import OpenGLES
func getViewController(identifier:String)->UIViewController
{
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
    
}




var themeDarkColor = uIntColor(36, green: 53, blue: 62, alpha: 255)
var themeLightColor = uIntColor(244, green: 149, blue: 40, alpha: 255)

class PaintViewController:UIViewController, UIGestureRecognizerDelegate
{
    
    static var appMode:ApplicationMode = ApplicationMode.ArtWorkCreation
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
        case editNote
    }
    var fileName:String!
    var paintMode = PaintMode.Artwork
    var paintManager:PaintManager!
    var lastAppState:AppState!
    var appState:AppState = .drawArtwork{
        willSet{
         lastAppState = appState
        }
        didSet
        {
            switch appState
            {
            case .drawArtwork:
                modeText.title = "繪畫模式"
            case .editNote:
                modeText.title = "編輯註解"
            case .viewArtwork:
                modeText.title = "觀看模式"
            case .drawRevision:
                modeText.title = "批改模式"
            default:
                break
            }
        }
        
        
    }
    static let canvasWidth:Int = 1366
    static let canvasHeight:Int = 1024
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var singlePanGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var doubleTapSingleTouchGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var singleTapSingleTouchGestureRecognizer: UITapGestureRecognizer!
    
    @IBAction func dragBoundGestureHandler(sender: UIPanGestureRecognizer) {
        let dis = sender.translationInView(boundBorderView)
        canvasBGLeadingConstraint.constant+=dis.x
            boundBorderViewLeadingConstraint.constant += dis.x
    }
    
    
    var currentTouchType:String = "None"
    var isDrawDone = true
    var eaglContext:EAGLContext!
    var eaglContext2:EAGLContext!
    func pathSetUp()
    {
        if let path = NSBundle.mainBundle().resourcePath {
            NSFileManager.defaultManager().changeCurrentDirectoryPath(path)
        }
        let path = NSBundle.mainBundle().bundlePath
        let fm = NSFileManager.defaultManager()
        
        let dirContents: [AnyObject]?
        do {
            dirContents = try fm.contentsOfDirectoryAtPath(path)
        } catch _ {
            dirContents = nil
        }
        print(dirContents)
    }
    override func viewDidLoad() {
        pathSetUp()
        
        //the OpenCV
        //print(OpenCVWrapper.calculateImgSimilarity(UIImage(named: "img3"), secondImg: UIImage(named: "img2")))

        
        toolBarItems = mainToolBar.items
        initAnimateState()
        
        nearbyColorButtons = nearbyColorButtons.sort({b1,b2 in return b1.tag > b2.tag})
        colorPicker.setup(hueView, colorGradientView: colorGradientView)
        colorPicker.onColorChange = {[weak self](color, finished) in
            if finished {
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
                DLog("finished")
            } else {
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
                self!.paintView.paintBuffer.setBrushDrawSetting(self!.paintView.paintBuffer.paintToolManager.currentTool.toolType)
                
                self!.paintView.paintBuffer.paintToolManager.usePreviousTool()
                self!.paintView.paintBuffer.paintToolManager.changeColor(color)
                let colors = getNearByColor(color)
                
                for i in 0...8
                {
                    unowned let button = self!.nearbyColorButtons[i] as! UIButton
                    button.backgroundColor = colors[i]
                    
                }
                
            }
        }
        
        switch PaintViewController.appMode {
        case ApplicationMode.CreateTutorial:
            paintView = PaintView(frame: CGRectMake(0, 0, CGFloat(PaintViewController.canvasWidth/2), CGFloat(PaintViewController.canvasHeight)))
            
        default:
            paintView = PaintView(frame: CGRectMake(0, 0, CGFloat(PaintViewController.canvasWidth), CGFloat(PaintViewController.canvasHeight)))
            
        }
        paintView.paintBuffer.paintToolManager.useCurrentTool()
        paintManager = PaintManager(paintView:paintView)
        /*1*/
        //paintView init
        paintView.multipleTouchEnabled = true
        canvasBGView.addSubview(paintView)
        paintView.addGestureRecognizer(singlePanGestureRecognizer)
        
        
        if(fileName != nil)
        {
            NoteManager.instance.loadNotes(fileName)
            
            
            paintManager.loadArtwork(self.fileName)
            paintManager.artwork.currentClip.onStrokeIDChanged = {[weak self](id,count) in
                self!.onStrokeProgressChanged(id, totalStrokeCount: count)
            }
            paintView.glDraw()
            
            //TODO ***** 
            //need to remove the switch in paintManager, temporary have switch both
            switch PaintViewController.appMode {
            case .InstructionTutorial:
                    setTutorialStepContent()
            default:
                break
            }
            
            setup()
            
            /*
             
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { // 1
                
                    self.isDrawDone = false
                    dispatch_async(dispatch_get_main_queue()) { // 2
                        self.paintManager.loadArtwork(self.fileName)
                        self.paintManager.artwork.currentClip.onStrokeIDChanged = {[weak self](id,count) in
                            self!.onStrokeProgressChanged(id, totalStrokeCount: count)                            
                        }

                        self.paintView.glDraw()
                        self.isDrawDone = true
                        self.setup()
                    }
            }*/
        }
        else
        {
            paintManager.newArtwork(PaintViewController.canvasWidth,height: PaintViewController.canvasHeight)
            paintManager.artwork.currentClip.onStrokeIDChanged = {[weak self](id,count) in
                self!.onStrokeProgressChanged(id, totalStrokeCount: count)
            }
            NoteManager.instance.empty()
            paintView.glDraw()
            setup()
        }
        
        
        //initMode(paintMode)

    }
    func setup()
    {
        viewWidth = view.contentScaleFactor * view.frame.width
        noteListTableView.reloadData()
        noteProgressButtonSetUp()
        noteEditSetUp()
        replayControlSetup()
        gestureHandlerSetUp()
        enterDrawMode()
    }
    override func viewDidAppear(animated: Bool) {
        colorPicker.setTheColor(UIColor(hue: 0, saturation: 0.0, brightness: 0.2, alpha: 1.0))
        
        //paintManager.playArtworkClip()
    }
    
    /*
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
    */
    
    @IBOutlet weak var ToolKnob: UIView!
    
    
 
    @IBOutlet weak var canvasBGView: UIView!
    
    @IBOutlet weak var instructionBGView: UIView!
//    @IBOutlet weak var paintView: PaintView!
    var instructionView:PaintView!
    var paintView: PaintView!
    
    @IBOutlet weak var mainView: UIView!
    
   
    
    @IBOutlet weak var brushScaleSlider: UISlider!
    
    var last_ori_pos:CGPoint = CGPoint(x: 0, y: 0)
    
    
    @IBAction func brushScaleSliderChanged(sender: UISlider) {
        paintView.paintBuffer.paintToolManager.changeSize(sender.value)
    }
    
    //note related
     @IBOutlet weak var noteButtonView: NoteProgressView!
    
    @IBOutlet weak var noteTitleField: NoteTitleField!
    
    @IBOutlet weak var noteDescriptionTextView: NoteTextArea!
    
    @IBOutlet weak var noteDetailView: NoteTextView!
    
    @IBOutlet weak var editNoteButton: UIBarButtonItem!
    
    @IBAction func editNoteButtonTouched(sender: UIBarButtonItem) {
        editNote()
        noteTitleField.becomeFirstResponder()
    }
    
    @IBAction func deleteNoteButtonTouched(sender: UIBarButtonItem) {
        deleteNote(NoteManager.instance.selectedButtonIndex)
        
    }
    
    
    var disx:CGFloat = 0
    
    
    
    var rect:GLRect!
    
    //var canvasPanGestureHandler:CanvasPanGestureHandler!
    
    //@IBOutlet weak var canvasImageView: UIImageView!
    
    func resetAnchor(targetPaintView:PaintView)
    {
        targetPaintView.rotation = 0
        targetPaintView.translation = CGPoint.zero
        
        targetPaintView.scale = 1
        targetPaintView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        targetPaintView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //*TODO position needs to change
        targetPaintView.layer.position = CGPoint(x:mainView.frame.width/2,y:        mainView.frame.height/2)
        
        //imageView.image = GLContextBuffer.instance.image
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
    @IBOutlet weak var doublePlayBackButton: UIButton!
    
    @IBOutlet weak var playbackControlPanel: PlayBackControlPanel!
    
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    
    
    let playImage = UIImage(named: "Play-50")
    let pauseImage = UIImage(named: "Pause-50")
    
    var isCellSelectedSentbySlider:Bool = false
            
    
    //var canvasCropView:CanvasCropView!
    
    func getView(name:String)->UIView
    {
        return NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)![0] as! UIView
    }
    
    
    var doubleTap:Bool = false
    @IBAction func doubleTapEraserHandler(sender: UIButton) {
        
        paintManager.clean()
        checkUndoRedo()
        paintView.paintBuffer.paintToolManager.usePreviousTool()
        paintView.paintBuffer.setBrushDrawSetting(paintView.paintBuffer.paintToolManager.currentTool.toolType)
        paintView.paintBuffer.paintToolManager.changeColor(colorPicker.color)
        doubleTap = true
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
    
    @IBOutlet weak var boundBorderView: UIView!
    @IBOutlet weak var boundBorderViewLeadingConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var canvasBGLeadingConstraint: NSLayoutConstraint!
    
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
    @IBOutlet var switchModeButton: UIBarButtonItem!
    
    //進入繪圖模式
    
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    @IBOutlet weak var redoButton: UIBarButtonItem!
    
    @IBOutlet var dismissButton: UIBarButtonItem!
   
    @IBOutlet weak var modeText: UIBarButtonItem!
    
    @IBOutlet var demoAreaText: UIBarButtonItem!
    
    @IBOutlet var practiceAreaText: UIBarButtonItem!
    
    var toolBarItems:[UIBarButtonItem]!
    
    
    deinit
    {   
        //PaintView.instance = nil
        //reviseDoneButton = nil
        //enterViewModeButton = nil
        print("deinit", terminator: "")
    }
    
    
    
    /////// paint tool
    @IBOutlet weak var showToolButton: UIButton!
    @IBOutlet var nearbyColorButtons: NSArray!//[UIButton]!
    
    @IBOutlet weak var colorGradientView: ColorGradientView!
    
    @IBOutlet weak var hueView: HueView!
    @IBOutlet weak var imageView: UIImageView!
    
   
    @IBOutlet weak var tutorialNextStepButton: UIBarButtonItem!
    
    @IBOutlet weak var tutorialLastStepButton: UIBarButtonItem!
    
    @IBOutlet weak var tutorialDescriptionTextView: UITextView!
        
    @IBOutlet weak var tutorialTitleLabel: UILabel!
    
    @IBOutlet weak var tutorialControlPanel: UIView!
    
    @IBAction func tutorialPlayPauseBtnTouched(sender: PlayPauseButton) {
        paintManager.tutorialToggle()
    }
    @IBAction func tutorialRestartBtnTouched(sender: UIBarButtonItem) {
    }
    
    
    @IBAction func paperSwitchBtnTouched(sender: UIBarButtonItem) {
        paintView.paintBuffer.switchBG()
        paintView.glDraw()
    }
    
    
    
}


func isPointContain(vertices:[CGPoint],test:CGPoint)->Bool{
    let nvert = vertices.count;
    var c:Bool = false
    
    var i:Int,j:Int
    for (i = 0, j = nvert-1; i < nvert; j = i, i += 1) {
        let verti = vertices[i]
        let vertj = vertices[j]
        if (( (verti.y > test.y) != (vertj.y > test.y) ) &&
        ( test.x < ( vertj.x - verti.x ) * ( test.y - verti.y ) / ( vertj.y - verti.y ) + verti.x) )
        {
            c = !c;
        }
        
    }
    
    return c;
}

func CGPointToVec4(p:CGPoint)->Vec4
{
    return Vec4(x:Float(p.x),y: Float(p.y))
}

func CGPointToVec2(p:CGPoint)->Vec2
{
    return Vec2(x:Float(p.x),y: Float(p.y))
}

