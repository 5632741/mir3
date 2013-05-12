(*****************************************************************************************
 *   LomCN Mir3 Control core File 2012                                                   *
 *                                                                                       *
 *   Web       : http://www.lomcn.co.uk                                                  *
 *   Version   : 0.0.0.13                                                                *
 *                                                                                        *
 *   - File Info -                                                                       *
 *                                                                                       *
 *   It hold the mir3 game controls (no Delphi Forms / Objects)                          *
 *   It use full Persistante Objects (fast, stabel, etc.)                                *
 *                                                                                       *
 *                                                                                       *
 *****************************************************************************************
 * Change History                                                                        *
 *                                                                                       *
 *  - 0.0.0.1  [2012-10-04] Coly : first init                                            *
 *  - 0.0.0.2  [2013-02-25] Coly : add new controls (TextXXX)                            *
 *  - 0.0.0.3  [2013-02-27] Coly : Fix Assassen and Form Handling                        *
 *  - 0.0.0.4  [2013-03-01] Coly : add Pre and Post Processing                           *
 *  - 0.0.0.5  [2013-03-02] Coly : Fix Wizard and Edit Control                           *
 *  - 0.0.0.6  [2013-03-07] Coly : Fix Edit Control add StringBuffer                     *
 *  - 0.0.0.7  [2013-03-09] Coly : hint render system                                    *
 *  - 0.0.0.8  [2013-03-10] Coly : add Sound to Create Char                              *
 *  - 0.0.0.9  [2013-03-10] Coly : create PageControl                                    *
 *  - 0.0.0.10 [2013-03-25] Coly : create Scrollbar and MagicButton                      *
 *  - 0.0.0.11 [2013-04-07] Coly : add TextButton Auto Adjustmend for Multi Language use *
 *  - 0.0.0.12 [2013-05-02] 1PKRyan : code clean-up                                      *
 *  - 0.0.0.13 [2013-05-09] Coly : rewrite SelectChar Controls                           * 
 *                                                                                       *
 *****************************************************************************************
 *  - TODO List for this *.pas file -                                                    *
 *---------------------------------------------------------------------------------------*
 *  if a todo finished, then delete it here...                                           *
 *  if you find a global TODO thats need to do, then add it here..                       *
 *---------------------------------------------------------------------------------------*
 *                                                                                       *
 *  - TODO : -all -fill *.pas header information                                         *
 *                 (how to need this file etc.)                                          *
 *                                                                                       *
 *****************************************************************************************)

unit mir3_core_controls;

interface

uses
  { Delphi }
  Windows,
  Messages,
  Classes,
  Controls,
  SysUtils,
  Math,
  { DirectX}
  Direct3D9,
  D3DX9,
  { Mir3 Game }
  mir3_global_config,
  mir3_game_file_manager,
  mir3_game_font_engine,
  mir3_game_language_engine,
  mir3_game_sound_engine,
  mir3_misc_utils;

const
  // Minimum scroll bar thumb size
  SCROLLBAR_MINTHUMBSIZE                 = 8;
  // Delay and repeat period when clicking on the scroll bar arrows
  SCROLLBAR_ARROWCLICK_DELAY             = 0.33;
  SCROLLBAR_ARROWCLICK_REPEAT            = 0.05;

const
  EVENT_SYSTEM_TOOL_X                    =   100;
  EVENT_FORM_X                           =  1000;
  EVENT_PANEL_X                          =  2000;
  EVENT_EDITBOX_RETURN                   =  3000;
  EVENT_EDITBOX_CHANGE                   =  3001;
  EVENT_GRID_X                           =  4000;
  EVENT_BUTTON_DOWN                      =  5000;
  EVENT_BUTTON_UP                        =  5001;
  EVENT_BUTTON_DBCLICKED                 =  5002;
  EVENT_LISTBOX_X                        =  6000;
  EVENT_COMBOBOX_X                       =  7000;
  EVENT_CHECKBOX_X                       =  8000;
  EVENT_RADIOBUTTON_X                    =  9000;
  EVENT_SLIDER_VALUE_CHANGED             = 10000;
  EVENT_SCROLLBAR_VALUE_CHANGED          = 10100;
  EVENT_TIMER_TIME_EXPIRE                = 20000;

////////////////////////////////////////////////////////////////////////////////
///  Key Handling Info Constanten

  MIR3_VK_CTRL_A                         = 1;
  MIR3_VK_CTRL_B                         = 2;
  MIR3_VK_CTRL_D                         = 4;
  MIR3_VK_CTRL_E                         = 5;
  MIR3_VK_CTRL_F                         = 6;
  MIR3_VK_CTRL_G                         = 7;
  MIR3_VK_CTRL_I                         = 9;
  MIR3_VK_CTRL_J                         = 10;
  MIR3_VK_CTRL_K                         = 11;
  MIR3_VK_CTRL_L                         = 12;
  MIR3_VK_CTRL_N                         = 14;
  MIR3_VK_CTRL_O                         = 15;
  MIR3_VK_CTRL_P                         = 16;
  MIR3_VK_CTRL_Q                         = 17;
  MIR3_VK_CTRL_R                         = 18;
  MIR3_VK_CTRL_S                         = 19;
  MIR3_VK_CTRL_T                         = 20;
  MIR3_VK_CTRL_U                         = 21;
  MIR3_VK_CTRL_V                         = 22;
  MIR3_VK_CTRL_W                         = 23;
  MIR3_VK_CTRL_X                         = 24;
  MIR3_VK_CTRL_Y                         = 25;
  MIR3_VK_CTRL_Z                         = 26;
  MIR3_VK_CTRL_BRACE_C                   = 27; // ]
  MIR3_VK_CTRL_SLASH                     = 28; // \
  MIR3_VK_CTRL_BRACE_O                   = 29; // [

type
  (* Enum Declaration *)
  TMIR3_GUI_Type         = (ctNone, ctForm, ctPanel, ctEdit, ctGrid, ctButton, ctListBox, ctComboBox, ctCheckBox, 
                            ctRadioButton, ctSelectChar, ctTextButton, ctTextLabel, ctSlider, ctProgress, ctScrollbar,
                            ctMagicButton, ctTimer);
  TMIR3_GUI_Form_Type    = (ftNone, ftMoving, ftUIStatic, ftBackground);
  TMIR3_Control_State    = (csNormal, csMouseOver, csPress, csHoldDown);
  TMIR3_Button_State     = (bsBase, bsMouseOver, bsPress, bsDisabled, bsSelected);
  TMIR3_CharSystem       = (csSelectChar, csCreateChar);
  TMIR3_ScrollKind       = (skVertical, skHorizontal);
  TMIR3_TexturAlign      = (taTop, taCenter, taBottom);
  TMIR3_ProgressType     = (ptHorizontal, ptVertical, ptSpecial);
  TMIR3_DLG_Btn          = (mbYes, mbNo, mbOK, mbCancel, mbEditField, mbExtraText_C, mbExtraText_L, mbExtraText_R);
  TMIR3_DLG_Buttons      = set of TMIR3_DLG_Btn;
  TCharSet               = set of Char;

  (* Forward Declaration *)
  TMIR3_GUI_Manager      = class;
  TMIR3_GUI_Default      = class;
  TMIR3_GUI_Form         = class;
  TMIR3_GUI_Panel        = class;
  TMIR3_GUI_Edit         = class;
  TMIR3_GUI_Grid         = class;
  TMIR3_GUI_Button       = class;
  TMIR3_GUI_List_Box     = class;
  TMIR3_GUI_ComboBox     = class;
  TMIR3_GUI_CheckBox     = class;
  TMIR3_GUI_RadioButton  = class;
  TMIR3_GUI_SelectChar   = class;
  TMIR3_GUI_TextButton   = class;
  TMIR3_GUI_TextLabel    = class;
  TMIR3_GUI_Slider       = class;
  TMIR3_GUI_Progress     = class;
  TMIR3_GUI_Scrollbar    = class;
  TMIR3_GUI_MagicButton  = class;
  TMIR3_GUI_Timer        = class;

  (* Class Pointer Declaration *)
  PMIR3_GUI_Form         = ^TMIR3_GUI_Form;
  PMIR3_GUI_Default      = ^TMIR3_GUI_Default;
  PMIR3_GUI_Panel        = ^TMIR3_GUI_Panel;
  PMIR3_GUI_Edit         = ^TMIR3_GUI_Edit;
  PMIR3_GUI_Grid         = ^TMIR3_GUI_Grid;
  PMIR3_GUI_Button       = ^TMIR3_GUI_Button;
  PMIR3_GUI_List_Box     = ^TMIR3_GUI_List_Box;
  PMIR3_GUI_ComboBox     = ^TMIR3_GUI_ComboBox;
  PMIR3_GUI_CheckBox     = ^TMIR3_GUI_CheckBox;
  PMIR3_GUI_RadioButton  = ^TMIR3_GUI_RadioButton;
  PMIR3_GUI_SelectChar   = ^TMIR3_GUI_SelectChar;
  PMIR3_GUI_TextButton   = ^TMIR3_GUI_TextButton;
  PMIR3_GUI_TextLabel    = ^TMIR3_GUI_TextLabel;
  PMIR3_GUI_Slider       = ^TMIR3_GUI_Slider;
  PMIR3_GUI_Progress     = ^TMIR3_GUI_Progress;
  PMIR3_GUI_Scrollbar    = ^TMIR3_GUI_Scrollbar;
  PMIR3_GUI_MagicButton  = ^TMIR3_GUI_MagicButton;
  PMIR3_GUI_Timer        = ^TMIR3_GUI_Timer;

  (* Records *)
  THintMessage             = record
    GUIObject              : TMIR3_GUI_Default;
    DrawSetting            : TDrawSetting;
    Caption                : WideString;
  end;

  TMir3_DrawSetting_Set    = record
    dsDrawSetting          : TDrawSetting;
    dsDrawSettingHint      : TDrawSetting;
  end;
  
  TMIR3_UI_Animation              = record
    // Texture File ID
    gui_Animation_Texture_File_ID : Integer;
    // Texture IDs
    gui_Animation_Texture_From    : Integer;
    gui_Animation_Texture_To      : Integer;
    // Blending
    gui_Animation_Blend_Mode      : Integer;
    // Timer
    gui_Animation_Interval        : LongWord;
    gui_Animation_Current         : Integer;
    // Extra Offset
    gui_Animation_Offset_X        : Integer;
    gui_Animation_Offset_Y        : Integer;
    // Extra Option
    gui_Animation_Max_Count       : Integer;
  end;

  TMIR3_UI_Extra_Texture          = record
    // Texture ID
    gui_Background_Texture_ID     : Integer;           {Control Basis Texture}
    // Mouse Texture ID    
    gui_Mouse_Over_Texture_ID     : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Down_Texture_ID     : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Select_Texture_ID   : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Disable_Texture_ID  : Integer;           {for Buttons and class inheritance}
  end;

  TMIR3_UI_Control_Texture        = record
    //
    gui_Texture_Align             : TMIR3_TexturAlign;
    // Texture File ID
    gui_Texture_File_ID           : Integer;
    // Texture ID
    gui_Background_Texture_ID     : Integer;           {Control Basis Texture}
    // Mouse Texture ID
    gui_Mouse_Over_Texture_ID     : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Down_Texture_ID     : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Select_Texture_ID   : Integer;           {for Buttons and class inheritance}
    gui_Mouse_Disable_Texture_ID  : Integer;           {for Buttons and class inheritance}
    // Slider Texture ID
    gui_Slider_Texture_ID         : Integer;           {for Slider}
    // Random Texture IDs
    gui_Random_Texture_From       : Integer;           {using for Login Screen and Notice Screen}
    gui_Random_Texture_To         : Integer;           {using for Login Screen and Notice Screen}
    // Extra Texture and file For Body System
    gui_ExtraTexture_File_ID      : Integer;
    gui_ExtraBackground_Texture_ID: Integer;           {if set then the image is in background of gui_Background_Texture_ID}
    // Special for On/Off Button
    gui_Extra_Texture_Set         : TMIR3_UI_Extra_Texture;
  end;

  TMIR3_UI_Fonts                  = record
    gui_Font_Use_ID               : Integer;
    gui_Font_Size                 : Integer;              // The Text Font Size
    gui_Font_Color                : TD3DColor;            // The Color
    gui_Font_Use_Kerning          : Boolean;              // Using Font Kerning
    gui_Font_Text_HAlign          : TMIR3_Align;
    gui_Font_Text_VAlign          : TMIR3_VAlign;
    gui_Font_Setting              : TMIR3_FontSettings;
    gui_Font_Script_MouseNormal   : WideString;
    gui_Font_Script_MouseOver     : WideString;
    gui_Font_Script_MouseDown     : WideString;
  end;
  
  TMIR3_UI_Window_Info            = record
    gui_Window_Caption_ID         : Integer;              // Windows Text using Language System
    gui_Window_Caption            : WideString;           // Windows Text using Hardcode Text
    gui_Top                       : Integer;              // Top Position for the Windows Text
    gui_Left                      : Integer;              // Left Position for the Windows Text
    gui_Cation_Font               : TMIR3_UI_Fonts;
  end;

  TMIR3_UI_BTN_Font_Color         = record
    gui_ColorSelect               : TD3DColor;
    gui_ColorPress                : TD3DColor;
    gui_ColorDisabled             : TD3DColor;
  end;
  
  TMIR3_UI_Color                  = record
    gui_ControlColor              : TD3DColor;
    gui_BorderColor               : TD3DColor;  
  end;

  TMIR3_UI_Slider_Setup           = record
    gui_Min                       : Integer;
    gui_Max                       : Integer;
    gui_Value                     : Integer;
    gui_Btn_Size                  : TRect;
  end;
  
  TMIR3_UI_ScrollBar_Setup        = record
    gui_ScrollKind                : TMIR3_ScrollKind;
    gui_Slider_Info               : TMIR3_UI_Slider_Setup;
  end;  

  TMIR3_UI_Progress_Setup         = record
    gui_Min                       : Integer;
    gui_Max                       : Integer;
    gui_Value                     : Integer;
    gui_Progress_Type             : TMIR3_ProgressType;
    gui_ShowText                  : Boolean;
  end;

  TMIR3_UI_Extra_Text             = record
    gui_Caption_Offset            : Integer;
    gui_Extra_Font                : TMIR3_UI_Fonts;
    gui_CaptionExtraID            : Integer;
  end;

  PMir3_GUI_Ground_Info        = ^TMir3_GUI_Ground_Info;
  TMir3_GUI_Ground_Info        = record
    gui_Unique_Control_Number  : Integer;
    gui_Type                   : TMIR3_GUI_Type;       // Control Typ Info
    gui_Form_Type              : TMIR3_GUI_Form_Type;  // Only for forms Movable / Static / Background
    gui_WorkField              : TRect;                // This Special Var is used to determine the real Control in a Texture (needed for Mouse Operations)
    gui_Top                    : Integer;
    gui_Left                   : Integer;
    gui_Height                 : Integer;
    gui_Width                  : Integer;
    gui_Null_Point_X           : Integer;   // Used for Equip Offset Calculation
    gui_Null_Point_Y           : Integer;   // Used for Equip Offset Calculation
    gui_Strech_Rate_X          : Single;
    gui_Strech_Rate_Y          : Single;
    gui_Extra_Offset_X         : Integer;   //
    gui_Extra_Offset_Y         : Integer;   // used at Magic System atm (Move the scroll Offset) (Button and Magic Button) 
    gui_Cut_Rect_Position_X    : Integer;   // used to move Cutted Image
    gui_Cut_Rect_Position_Y    : Integer;   // used to move Cutted Image
    gui_Clip_Rect              : TRect;
    gui_Repeat_Count           : Integer;
    gui_Timer_Intervall        : Integer;
    gui_Blend_Size             : Byte;
    gui_Blend_Size_Extra       : Byte;
    gui_Blend_Mode             : Integer;
    gui_Blend_Mode_Extra       : Integer;
    gui_CaptionID              : Integer;
    gui_HintID                 : Integer;                  //used the Basic Language file
    gui_MagicHintID            : Integer;                  //used the Magic Language file
    gui_Window_Text            : TMir3_UI_Window_Info;
    gui_Font                   : TMIR3_UI_Fonts;
    gui_Control_Texture        : TMir3_UI_Control_Texture;
    gui_Animation              : TMir3_UI_Animation;
    gui_Password_Char          : String[1];
    gui_Edit_Max_Length        : Integer;
    gui_Edit_Using_ASCII       : TCharSet;//Set of Chars;  //[#8, #13, #46, #48..#57,#96..#105]
    gui_Color                  : TMIR3_UI_Color;
    gui_Btn_Font_Color         : TMIR3_UI_BTN_Font_Color;
    gui_Slider_Setup           : TMIR3_UI_Slider_Setup;
    gui_ScrollBar_Setup        : TMIR3_UI_ScrollBar_Setup;
    gui_Progress_Setup         : TMIR3_UI_Progress_Setup;
    gui_Caption_Extra          : TMIR3_UI_Extra_Text;     // atm only on TextLabel and Panel Controls
    gui_PreSelected            : Boolean;
    gui_Scroll_Text            : Boolean;
    gui_Use_Extra_Caption      : Boolean;
    gui_Use_Animation_Texture  : Boolean;
    gui_Use_Random_Texture     : Boolean;
    gui_Use_Strech_Texture     : Boolean;
    gui_Use_Repeat_Texture     : Boolean;
    gui_Use_Image_Offset       : Boolean;
    gui_Use_Cut_Rect           : Boolean;
    gui_Use_Null_Point_Calc    : Boolean;
    gui_Use_Offset_Calc        : Boolean;
    gui_ShowBorder             : Boolean;
    gui_ShowPanel              : Boolean;
    gui_ShowHint               : Boolean;
    gui_Modal_Event            : Boolean;
    gui_Enabled                : Boolean;
    gui_Visible                : Boolean;
  end;

  (* Callback Functions *)
  PCallbackHotKeyEvent    = procedure (AChar: LongWord); stdcall;
  PCallBackEventNotify    = procedure (AEventID: LongWord; AControlID: Cardinal; AControl: PMIR3_GUI_Default); stdcall;
  PCallBackPreProcessing  = function (AD3DDevice: IDirect3DDevice9; AElapsedTime: Single; ADebugMode: Boolean): HRESULT; stdcall;
  PCallBackPostProcessing = function (AD3DDevice: IDirect3DDevice9; AElapsedTime: Single; ADebugMode: Boolean): HRESULT; stdcall;

  {$REGION ' - ::::: Classes :::::  '}

  (* String Helper TStringBuffer *)
  IStringBuffer = interface
  ['{4F9E882F-9FBE-4CF5-AF15-DBC0ACF84EA0}']
    function GetChar(I: Integer): WideChar;
    procedure SetChar(I: Integer; ch: WideChar);
    function InsertString(AIndex: Integer; const AString: PWideChar; ACount: Integer = -1): Boolean;
    function InsertChar(AIndex: Integer; AChar: WideChar): Boolean;
    function RemoveChar(AIndex: Integer): Boolean;
    function GetTextSize: Integer;
    function GetBufferSize: Integer;
    function GetBuffer: PWideChar;
    function GetMaxLength: Integer;
    function SetBufferSize(ANewSize: Integer): Boolean;
    procedure SetText(AText: PWideChar);
    procedure SetMaxLength(AValue: Integer);
    procedure Clear;
    property BufferSize : Integer   read GetBufferSize;
    property Buffer     : PWideChar read GetBuffer;
    property TextSize   : Integer   read GetTextSize;
    property MaxLength  : Integer   read GetMaxLength write SetMaxLength;
    property Chars[I: Integer]: WideChar read GetChar write SetChar; default;
  end;

  (* String Helper TStringBuffer *)
  TStringBuffer = class(TInterfacedObject, IStringBuffer)
  private
    FBufferSize     : Integer;
    FBuffer         : PWideChar;
    FMaxLength      : Integer;
  private
    function GetChar(I: Integer): WideChar;
    procedure SetChar(I: Integer; ch: WideChar);
    function GetMaxLength: Integer;
    procedure SetMaxLength(AValue: Integer);
  public
    constructor Create(AInitialSize: Integer = 1);
    destructor Destroy; override;
  public
    function InsertString(AIndex: Integer; const AString: PWideChar; ACount: Integer = -1): Boolean;
    function InsertChar(AIndex: Integer; AChar: WideChar): Boolean;
    function RemoveChar(AIndex: Integer): Boolean;
    function GetTextSize: Integer;
    function GetBufferSize: Integer;
    function GetBuffer: PWideChar;
    function SetBufferSize(ANewSize: Integer): Boolean;
    procedure SetText(AText: PWideChar);
    procedure Clear;
  public
    property BufferSize : Integer   read GetBufferSize;
    property Buffer     : PWideChar read GetBuffer;
    property TextSize   : Integer   read GetTextSize;
    property MaxLength  : Integer   read GetMaxLength write SetMaxLength;
    property Chars[I: Integer]: WideChar read GetChar write SetChar; default;
  end;

  (* GUI Control and Manager Class Declaration *)
  TMIR3_GUI_Manager     = class
  private
    FFormList               : TList;
    FDebugMode              : Boolean;
    FHintMessage            : THintMessage;
    FFormFocusHandle        : TMIR3_GUI_Form;
    FCallbackHotKeyEvent    : PCallbackHotKeyEvent;
    FCallbackEventNotify    : PCallBackEventNotify;
    FCallbackPreProcessing  : PCallBackPreProcessing;
    FCallbackPostProcessing : PCallBackPostProcessing;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure SetHotKeyEventCallback(ACallback: PCallbackHotKeyEvent);
    procedure SetEventCallback(ACallback: PCallBackEventNotify);
    procedure SetPreProcessingCallback(ACallback: PCallBackPreProcessing);
    procedure SetPostProcessingCallback(ACallback: PCallBackPostProcessing);    
    procedure SendEvent(AEvent: LongWord; ATriggerByUser: Boolean; AControl: PMIR3_GUI_Default);
    procedure SetZOrder(AGUIForm: TObject);
    function OnRender(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single): HRESULT;
    function OnMsgProc(hWnd: HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    procedure OnKeyboardProc(AChar: LongWord; AKeyDown, AAltDown: Boolean);
    procedure DeleteAllControls;
    procedure HideAllForms;
    procedure RequestFocus(AControl: PMIR3_GUI_Default);
    function GetComponentByID(ACompID: Cardinal): TObject;
    function GetFormByID(ACompID: Cardinal): TObject;
    // Add Forms
    function AddForm(AGroundInfo: TMir3_GUI_Ground_Info; AVisible: Boolean): TObject; overload;
    function AddForm(AFormType: TMIR3_GUI_Form_Type; ACaptionID: Integer; AX, AY, AWidth, AHeight: Integer; AVisible: Boolean; AUIContolID: Integer): TObject; overload;
    // Add Controls
    function AddControl(AGUIForm: TObject; AGroundInfo: TMir3_GUI_Ground_Info; AVisible: Boolean): TObject; overload;
    function AddControl(AGUIForm: TObject; AControlType: TMIR3_GUI_Type; AX, AY, AWidth, AHeight: Integer; AVisible: Boolean; AUIContolID: Integer): TObject; overload;
    // Add Hint Messages
    procedure AddHintMessage(ACaption: WideString; ADrawSetting: TDrawSetting; AGUIObject: TMIR3_GUI_Default);
    (* Published *)
    property DebugMode: Boolean read FDebugMode write FDebugMode;
  end;

  (* class TMIR3_GUI_Form *)
  TMIR3_GUI_Form        = class
  private
    FEventTypeID        : Integer;
    FTop                : Integer;                   // Control Top Position
    FLeft               : Integer;                   // Control Left Positiomn
    FWidth              : Integer;                   // Control Width
    FHeight             : Integer;                   // Control Height
    FCaptionHeight      : Integer;                   // Control Caption Height
    FTimeLastRefresh    : Double;                    // Control Refresh time
    //FLockPosition       : Boolean;                   // with this we can stick the Form  (later)
    FDragMode           : Boolean;
  private
    function GetVisible: Boolean;
    procedure SetVisible(AValue: Boolean);
  protected
    FCaption            : WideString;                // Window Caption Text
    FVisibleCaption     : Boolean;                   // Show  / Hidde Caption
    FEnabled            : Boolean;                   // Enabled / Disabled Control
    FVisible            : Boolean;                   // Shown   / Hidden   Control
    FMinimized          : Boolean;                   // For Form Controls
    FControlList        : TList;                     // List with all added Controls
    FMousClickPoint     : TPoint;
    FControlIdentifier  : Cardinal;                  // unique control / form number
    FGUIMouseOver       : TMIR3_GUI_Default;         // The control which is hovered over
    FFormType           : TMIR3_GUI_Form_Type;       // if Static or Movable Form
    FParentGUIContainer : TMIR3_GUI_Manager;         // Parent GUI Container
  public
    FGUI_Definition     : TMir3_GUI_Ground_Info;
  public
    constructor Create(AFormType: TMIR3_GUI_Form_Type; PParentGUIManager: TMIR3_GUI_Manager = nil);
    destructor Destroy; override;
  public
    procedure OnRenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    procedure Add_GUI_Definition(PGUI_Definition: PMir3_GUI_Ground_Info);
    function OnMsgProc(hWnd: HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    procedure OnMouseMove(AMousePoint: TPoint);
    procedure OnMouseDown(AMousePoint: TPoint);
    procedure OnMouseUp(AMousePoint: TPoint);
    procedure Refresh;
    procedure SetFormLocation(AX, AY: Integer);
    procedure SetTextureID(ATextureID: Integer; AType: Integer=0);
    function GetControlAtPoint(AMousePoint: TPoint): TMIR3_GUI_Default;
  public
    property EventTypeID       : Integer  read FEventTypeID       write FEventTypeID;
    property ControlIdentifier : Cardinal read FControlIdentifier write FControlIdentifier;
    property Top               : Integer  read FTop               write FTop;
    property Left              : Integer  read FLeft              write FLeft;
    property Visible           : Boolean  read GetVisible         write SetVisible;
  end;
  
  (* class TMIR3_GUI_Default *)
  TMIR3_GUI_Default     = class
  private // Getter / Setter
    function GetEnabled: Boolean;
    procedure SetEnabled(AEnabled: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(AVisible: Boolean);  
  protected
    FBoundingBox            : TRect;
    FFocus                  : Boolean;               // Flag thats get the Control Focus
    FMouseOver              : Boolean;               // If Mouse Over Control
    FEnabled                : Boolean;               // Enabled / Disabled Control
    FVisible                : Boolean;               // Shown   / Hidden   Control
    FMinimized              : Boolean;               // For Form Controls
    FDebugMode              : Boolean;               // Only for Programming
    FControlIdentifier      : Cardinal;              // unique control number
  public
    FGUI_Definition         : TMir3_GUI_Ground_Info;
    FTop                    : Integer;               // Control Top Position
    FLeft                   : Integer;               // Control Left Position
    FWidth                  : Integer;               // Control Width
    FHeight                 : Integer;               // Control Height
    FControlParentID        : Integer;               // Parent Identifier
    FControlType            : TMIR3_GUI_Type;        // Control Type Identifier
    FParentGUIContainer     : TMIR3_GUI_Manager;     // Parent GUI Container
    FParentGUIForm          : TMIR3_GUI_Form;        // Parent GUI Form
    FControlState           : TMIR3_Control_State;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); dynamic;
    destructor Destroy; override;
  public
    function ContainsPoint(AMousePoint: TPoint): LongBool;                       virtual;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); virtual;
    procedure Add_GUI_Definition(PGUI_Definition: PMir3_GUI_Ground_Info);        virtual;
    procedure OnRefresh;                                                         virtual;
    procedure OnFocusIn;                                                         virtual;
    procedure OnFocusOut;                                                        virtual;
    procedure OnMouseEnter;                                                      virtual;
    procedure OnMouseLeave;                                                      virtual;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;                           virtual;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;                    virtual;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;  virtual;
  public
    property ControlIdentifier : Cardinal read FControlIdentifier write FControlIdentifier;
    property Enabled           : Boolean  read GetEnabled         write SetEnabled;
    property Visible           : Boolean  read GetVisible         write SetVisible;
  end;
  
  (* class TMIR3_GUI_Panel *)    
  TMIR3_GUI_Panel       = class(TMIR3_GUI_Default)
  private
    FMouseState     : TMIR3_Button_State;
  private
    procedure SetCaption(ACaption: WideString);
    function GetCaption: WideString;
  protected
    FCurrentMaxCount: Integer;
    FAnimationTime  : LongWord;
    FAnimationCount : Integer;
    FCaption        : WideString;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override;
    procedure SetTextureID(ATextureID: Integer; AType: Integer=0);
  public
    property Caption : WideString read GetCaption write SetCaption;
  end;
  
  (* class TMIR3_GUI_Edit *)
  TMIR3_GUI_Edit        = class(TMIR3_GUI_Default)
  private
    FCaretPos         : Integer;                   // Caret position, in characters
    procedure SetText(AText: PWideChar);
    function GetText: PWideChar;
    procedure SetMaxLength(AValue: Integer);
    function GetMaxLength: Integer;
  protected
    FTextRect         : TRect;
    FStringBuffer     : IStringBuffer;
    FBlinkCaret       : Double;                    // Caret blink time in milliseconds
    FLastBlinkCaret   : Double;                    // Last timestamp of caret blink
    FFirstVisibleChar : Integer;
    FSelectStartPos   : Integer;
    FCaretOn          : Boolean;
    FSelectColor      : TD3DColor;
    FCaretColor       : TD3DColor;
    FInsertMode       : Boolean;
    FMouseDrag        : Boolean;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    procedure SetFocus;
    procedure OnFocusIn; override;
    procedure ResetCaretBlink;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    procedure ClearText;
    procedure DeleteSelectionText;
    procedure PlaceCaret(ACaretPlace: Integer);
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;                           override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;                    override;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;  override;
  public
    property Text   : PWideChar read GetText       write SetText;
    property MaxLen : Integer   read GetMaxLength  write SetMaxLength;
  end;

  (* class TMIR3_GUI_Grid *)  
  TMIR3_GUI_Grid        = class(TMIR3_GUI_Default)
  private
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

  (* class TMIR3_GUI_Button *)
  TMIR3_GUI_Button      = class(TMIR3_GUI_Default)
  private
    FColorSelect   : TD3DColor;
    FColorPress    : TD3DColor;
    FColorDisabled : TD3DColor;
    FSelected      : Boolean;
    FSwitchOn      : Boolean;
    FCaption       : WideString;
    FButtonState   : TMIR3_Button_State;
  private
    function GetSelected: Boolean;
    procedure SetSelected(AValue: Boolean);
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    function ContainsPoint(AMousePoint: TPoint): LongBool; override;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override;
  public
    property Caption       : WideString read FCaption       write FCaption;
    property SwitchOn      : Boolean    read FSwitchOn      write FSwitchOn;
    property Selected      : Boolean    read GetSelected    write SetSelected;
    property ColorSelect   : TD3DColor  read FColorSelect   write FColorSelect;
    property ColorPress    : TD3DColor  read FColorPress    write FColorPress;
    property ColorDisabled : TD3DColor  read FColorDisabled write FColorDisabled;
  end;
  
  (* class TMIR3_GUI_List_Box *)
  TMIR3_GUI_List_Box    = class(TMIR3_GUI_Default)
  private
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;
  
  (* class TMIR3_GUI_ComboBox *)  
  TMIR3_GUI_ComboBox    = class(TMIR3_GUI_Default)
  private
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

  (* class TMIR3_GUI_CheckBox *)
  TMIR3_GUI_CheckBox    = class(TMIR3_GUI_Default)
  private
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;
  
  (* class TMIR3_GUI_RadioButton *)
  TMIR3_GUI_RadioButton = class(TMIR3_GUI_Default)
  private
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;  
  end;

  (* class TMIR3_GUI_SelectChar *)
  TMIR3_GUI_SelectChar  = class(TMIR3_GUI_Button)
  private
    FLastOffsetX        : Integer;
    FLastOffsetY        : Integer;
    FStartTime          : Cardinal;
    FUseEffect          : Boolean;
    FSelected           : Boolean;
    FFrameStart         : Integer;
    FAnimationState     : Integer;
    FAnimationCount     : Integer;
    FAnimation_State_0  : Integer;
    FAnimation_State_2  : Integer;
    FAnimation_State_1  : Integer;
    FEffectImageNumber  : Integer;
    FShadowImageNumber  : Integer;
    FCurrentImageNumber : Integer;
    FCharSystem         : TMIR3_CharSystem;
    FCharacterInfo      : TMir3Character;
  private
    function GetCharacterInfo: TMir3Character;
    procedure SetCharacterInfo(AValue : TMir3Character);
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    function ContainsPoint(AMousePoint: TPoint): LongBool; override;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    procedure ResetSelection(ASelected: Boolean);
  public
    property Selected        : Boolean          read FSelected        write FSelected;
    property CharacterInfo   : TMir3Character   read GetCharacterInfo write SetCharacterInfo;
    property CharacterSystem : TMIR3_CharSystem read FCharSystem      write FCharSystem;
  end;

  (* class TMIR3_GUI_TextButton *)
  TMIR3_GUI_TextButton  = class(TMIR3_GUI_Button)
  private
    FDrawOptionSet : TMir3_DrawSetting_Set;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

  (* class TMIR3_GUI_TextLabel *)
  TMIR3_GUI_TextLabel  = class(TMIR3_GUI_Panel)
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

  (* class TMIR3_GUI_Slider *)
  TMIR3_GUI_Slider  = class(TMIR3_GUI_Default)
  protected
    FValue       : Integer;
    FMin         : Integer;
    FMax         : Integer;
    FDragX       : Integer;
    FButtonX     : Integer;
    FDragOffset  : Integer;
    FPressed     : Boolean;
    FButton      : TRect;
    FLButton     : Integer;
  protected
    procedure UpdateRects;
    procedure SetValueInternal(AValue: Integer; AFromInput: Boolean);
    function ValueFromPos(AValue: Integer): Integer;
    procedure SetValue(AValue: Integer);
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure OnMouseLeave; override;
    function ContainsPoint(AMousePoint: TPoint): LongBool; override;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override;
    procedure GetRange(out AMin, AMax: Integer);
    procedure SetRange(AMin, AMax: Integer);
    property Value : Integer read FValue write SetValue;
  end;

  (* class TMIR3_GUI_Progress *)
  TMIR3_GUI_Progress  = class(TMIR3_GUI_Default)
  public
    FCaption : WideString;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

    // ARROWSTATE indicates the state of the arrow buttons.
    // CLEAR            No arrow is down.
    // CLICKED_UP       Up arrow is clicked.
    // CLICKED_DOWN     Down arrow is clicked.
    // HELD_UP          Up arrow is held down for sustained period.
    // HELD_DOWN        Down arrow is held down for sustained period.
  TMIR3_ScrollBar_ArrayState = (CLEAR, CLICKED_UP, CLICKED_DOWN, HELD_UP, HELD_DOWN);
  (* class TMIR3_GUI_Scrollbar *)
  TMIR3_GUI_Scrollbar  = class(TMIR3_GUI_Default)
  protected
    m_bShowThumb   : Boolean;
    FCanDrag        : Boolean;
    FUpButton     : TRect;
    FDownButton   : TRect;
    FTrack        : TRect;
    FSliderThumb  : TRect;
    FPosition     : Integer;  // Position of the first displayed item
    FPageSize     : Integer;  // How many items are displayable in one page
    FMin          : Integer;  // First item
    FMax          : Integer;  // The index after the last item
    FLastMouse    : TPoint;   // Last mouse position
    FArrowButtonState   : TMIR3_ScrollBar_ArrayState; // State of the arrows
    FArrowTime     : Double;    // Timestamp of last arrow event.
  protected
    procedure UpdateThumbRect;
    procedure UpdateRects;
    procedure SetTrackRange(AMin, AMax: Integer);
    procedure Cap;
    procedure SetPageSize(APageSize: Integer);
    procedure SetTrackPos(APosition: Integer);
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure OnMouseLeave; override;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    function HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override;
    //function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    procedure ShowItem(AIndex: Integer);
    procedure Scroll(nDelta: Integer);
    property Maximum : Integer read FMax      write FMax;
    property Value   : Integer read FPosition write FPosition;
  end;

  (* class TMIR3_GUI_MagicButton *)
  TMIR3_GUI_MagicButton  = class(TMIR3_GUI_Button)
  protected
    FCaption   : WideString;
    FMagicFKey : Integer;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    function ContainsPoint(AMousePoint: TPoint): LongBool; override;
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
  end;

  (* class TMIR3_GUI_Timer *)
  TMIR3_GUI_Timer  = class(TMIR3_GUI_Default)
  protected
    FTickTime      : Cardinal;
    FTimerEnable   : Boolean;
  public
    constructor Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil); override;
  public
    procedure RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); override;
    procedure SetTimerEnabled(AEnabled: Boolean);
  end;

  {$ENDREGION}  

implementation

uses mir3_game_backend, mir3_game_engine, mir3_game_file_manager_const;

var
  G_MousePoint      : TPoint;
  G_FControlFocus   : TMIR3_GUI_Default = nil;
  FTimeRefresh      : Double            = 0.0;

 /// TStringBuffer

  {$REGION ' - TStringBuffer :: constructor / destructor   '}
    constructor TStringBuffer.Create(AInitialSize: Integer);
    begin
      FBufferSize    := 0;
      FBuffer        := nil;
      if (AInitialSize > 0) then
        SetBufferSize(AInitialSize);
    end;


    destructor TStringBuffer.Destroy;
    begin
      FreeMem(FBuffer);

      inherited;
    end;
  {$ENDREGION}

  {$REGION ' - TStringBuffer :: functions  '}
    function TStringBuffer.GetChar(I: Integer): WideChar;
    begin
      Result := FBuffer[I];
    end;

    procedure TStringBuffer.SetChar(I: Integer; ch: WideChar);
    begin
      FBuffer[I] := ch;
    end;

    function TStringBuffer.GetMaxLength: Integer;
    begin
      Result := FMaxLength;
    end;

    procedure TStringBuffer.SetMaxLength(AValue: Integer);
    begin
      if FMaxLength <> AValue then
        FMaxLength := AValue;
    end;

    function TStringBuffer.InsertString(AIndex: Integer; const AString: PWideChar; ACount: Integer = -1): Boolean;
    begin
      Assert(AIndex >= 0);
      Result := False;

      if (AIndex > lstrlenW(FBuffer)) then Exit; // invalid index

      if (-1 = ACount) then ACount := lstrlenW(AString);

      // Check for maximum length allowed
      if (TextSize + ACount >=  FMaxLength) then Exit;

      if (lstrlenW(FBuffer) + ACount >= FBufferSize) then
      begin
        if not SetBufferSize(lstrlenW(FBuffer) + ACount + 1) then Exit; // out of memory
      end;

      MoveMemory(FBuffer + AIndex + ACount, FBuffer + AIndex, SizeOf(WideChar) * (lstrlenW(FBuffer) - AIndex + 1));
      CopyMemory(FBuffer + AIndex, AString, ACount * SizeOf(WideChar));
      Result:= True;
    end;

    function TStringBuffer.InsertChar(AIndex: Integer; AChar: WideChar): Boolean;
    var
      FDesti  : PWideChar;
      FStop   : PWideChar;
      FSource : PWideChar;
    begin
      Assert(AIndex >= 0);
      Result := False;

      if (AIndex < 0) or (AIndex > lstrlenW(FBuffer))   then Exit;  // invalid index

      // Check for maximum length allowed
      if (TextSize + 1 >= FMaxLength) then Exit;

      if (lstrlenW(FBuffer) + 1 >= FBufferSize) then
      begin
        if not SetBufferSize(-1) then Exit;  // out of memory
      end;

      Assert(FBufferSize >= 2);

      // Shift the characters after the index, start by copying the null terminator
      FDesti  := FBuffer + lstrlenW(FBuffer)+1;
      FStop   := FBuffer + AIndex;
      FSource := FDesti - 1;

      while (FDesti > FStop) do
      begin
        FDesti^ := FSource^;
        Dec(FDesti); Dec(FSource);
      end;

      // Set new character
      FBuffer[AIndex] := AChar;
      Result          := True;
    end;

    function TStringBuffer.RemoveChar(AIndex: Integer): Boolean;
    begin
      if (lstrlenW(FBuffer) = 0) or (AIndex < 0) or (AIndex >= lstrlenW(FBuffer)) then
      begin
        Result := False;  // Invalid index
        Exit;
      end;

      MoveMemory(FBuffer + AIndex, FBuffer + AIndex + 1, SizeOf(WideChar) * (lstrlenW(FBuffer) - AIndex));
      Result := True;
    end;

    function TStringBuffer.GetTextSize: Integer;
    begin
      Result:= lstrlenW(FBuffer);
    end;

    function TStringBuffer.GetBufferSize: Integer;
    begin
      Result := FBufferSize;
    end;

    function TStringBuffer.GetBuffer: PWideChar;
    begin
      Result := FBuffer;
    end;

    function TStringBuffer.SetBufferSize(ANewSize: Integer): Boolean;
    var
      AAllocateSize: Integer;
      PTempBuffer  : PWideChar;
    begin
      // If the current size is already the maximum
      // allowed, we can't possibly allocate more.
      if (FBufferSize = $FFFF) then
      begin
        Result:= False;
        Exit;
      end;

      AAllocateSize    := IfThenInt((ANewSize = -1) or (ANewSize < FBufferSize * 2),
                          IfThenInt((FBufferSize <> 0), FBufferSize * 2, 256), ANewSize * 2);

      // Cap the buffer size at the maximum allowed.
      if (AAllocateSize > $FFFF) then
        AAllocateSize := $FFFF;

      try
        GetMem(PTempBuffer, SizeOf(WideChar) * AAllocateSize);
      except
        Result := False;
        Exit;
      end;

      if (FBuffer <> nil) then
      begin
        CopyMemory(PTempBuffer, FBuffer, (lstrlenW(FBuffer) + 1) * SizeOf(WideChar));
        FreeMem(FBuffer);
      end else ZeroMemory(PTempBuffer, SizeOf(WideChar) * AAllocateSize);

      FBuffer     := PTempBuffer;
      FBufferSize := AAllocateSize;

      Result := True;
    end;

    procedure TStringBuffer.SetText(AText: PWideChar);
    var
      FRequired: Integer;
    begin
      Assert(AText <> nil);

      FRequired := lstrlenW(AText) + 1;

      // Check for maximum length allowed
      if (FRequired >= $FFFF) then
        raise EOutOfMemory.Create('TStringBuffer.SetText - max length reached'); // Result:= False;

      while (BufferSize < FRequired) do
        if not SetBufferSize(-1) then Break;
      // Check again in case out of memory occurred inside while loop.
      if (BufferSize >= FRequired) then
        lstrcpynW(FBuffer, AText, BufferSize)
      else raise EOutOfMemory.Create('TStringBuffer.Grow'); // Result:= False;
    end;

    procedure TStringBuffer.Clear;
    begin
      FBuffer^ := #0;
    end;

  {$ENDREGION}

 /// TMIR3_GUI_Manager

  {$REGION ' - TMIR3_GUI_Manager :: constructor / destructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Form control constructor
    //..............................................................................    
    constructor TMIR3_GUI_Manager.Create;
    begin
      inherited Create;

      FCallbackHotKeyEvent     := nil;
      FCallbackEventNotify     := nil;
      FCallBackPreProcessing   := nil;
      FCallBackPostProcessing  := nil;
      ZeroMemory(@FHintMessage, SizeOf(THintMessage));
      FFormList                := TList.Create;
    end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Form control destructor
    //..............................................................................     
    destructor TMIR3_GUI_Manager.Destroy;
    begin
      DeleteAllControls;
      ZeroMemory(@FHintMessage, SizeOf(THintMessage)); 
      if Assigned(FFormList) then
      begin
        FFormList.Clear;
        FreeAndNil(FFormList);
      end;

      inherited;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Manager :: class getter and setter    '}

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Set Callback function for Event Processing
    //..............................................................................
    procedure TMIR3_GUI_Manager.SetHotKeyEventCallback(ACallback: PCallbackHotKeyEvent);
    begin
      FCallbackHotKeyEvent := ACallback;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Set Callback function for Event Processing
    //..............................................................................   
    procedure TMIR3_GUI_Manager.SetEventCallback(ACallback: PCallBackEventNotify);
    begin
      FCallbackEventNotify := ACallback;
    end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Set Callback function for Pre Processing
    //..............................................................................
    procedure TMIR3_GUI_Manager.SetPreProcessingCallback(ACallback: PCallBackPreProcessing);
    begin
      FCallbackPreProcessing := ACallback;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Set Callback function for Post Processing
    //..............................................................................    
    procedure TMIR3_GUI_Manager.SetPostProcessingCallback(ACallback: PCallBackPostProcessing);
    begin
      FCallbackPostProcessing := ACallback;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Manager :: functions                  '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Set the Forms Z Order
    //..............................................................................   
    procedure TMIR3_GUI_Manager.SetZOrder(AGUIForm: TObject);
    var
      I : Integer;
    begin
      for I := 0 to FFormList.Count - 1 do
      begin
        if FFormList[I] = AGUIForm then
        begin
          FFormList.Move(I, FFormList.Count - 1);
        end;
      end;
    end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Send Control Event to the given Event callback
    //..............................................................................    
    procedure TMIR3_GUI_Manager.SendEvent(AEvent: LongWord; ATriggerByUser: Boolean; AControl: PMIR3_GUI_Default);
    begin
      // If no callback has been registered there's nowhere to send the event to
      if (@FCallbackEventNotify = nil) then Exit;
      if not ATriggerByUser            then Exit;

      FCallbackEventNotify(AEvent, AControl.FControlIdentifier, AControl);
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Scene Basis Randerer Include Pre and Post Rendering
    //..............................................................................      
    function TMIR3_GUI_Manager.OnRender(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single): HRESULT;
    var
      I         : Integer;
    begin
      Result := S_OK;
      
      (* Pre Render Processing if Callback set *)
      if Assigned(FCallbackPreProcessing) then
      begin
        Result := FCallbackPreProcessing(AD3DDevice, AElapsedTime, FDebugMode);
      end;
      
      case FDebugMode of
        True  : begin
          // add it for now (can more debug add later)
          for I := 0 to FFormList.Count-1 do
          begin
            if (TMIR3_GUI_Form(FFormList[I]).FVisible) then
              TMIR3_GUI_Form(FFormList[I]).OnRenderControl(AD3DDevice, AElapsedTime);
          end;
        end;
        False : begin
          for I := 0 to FFormList.Count-1 do
          begin
            if (TMIR3_GUI_Form(FFormList[I]).FVisible) then
              TMIR3_GUI_Form(FFormList[I]).OnRenderControl(AD3DDevice, AElapsedTime);
          end;
        end;
      end;
      
      (* Post Render Processing if Callback set *)  
      if Assigned(FCallbackPostProcessing) then
      begin
        if Result = S_OK then
          Result := FCallbackPostProcessing(AD3DDevice, AElapsedTime, FDebugMode);
      end;

      (* Hint Render System *)
      if FHintMessage.Caption <> '' then
      begin
        G_MousePoint := Mouse.CursorPos;
        ScreenToClient(GRenderEngine.GetGameHWND, G_MousePoint);
        if (FHintMessage.GUIObject.ContainsPoint(G_MousePoint))  then
        begin
          GGameEngine.FontManager.DrawHint(G_MousePoint.X, G_MousePoint.Y , PWideChar(FHintMessage.Caption), @FHintMessage.DrawSetting);
          ZeroMemory(@FHintMessage, sizeOf(THintMessage));
        end;
        //GGameEngine.FontManager.DrawItemHint(G_MousePoint.X, G_MousePoint.Y , FHintMessage.Caption , @FHintMessage.DrawSetting);
        ZeroMemory(@FHintMessage, SizeOf(THintMessage));
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Scene Basis Window Message Processing
    //..............................................................................
    procedure TMIR3_GUI_Manager.AddHintMessage(ACaption: WideString; ADrawSetting: TDrawSetting; AGUIObject: TMIR3_GUI_Default);
    begin
      with FHintMessage do
      begin
        GUIObject   := AGUIObject;
        DrawSetting := ADrawSetting;
        Caption     := ACaption;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Scene Basis Window Message Processing
    //..............................................................................
    function TMIR3_GUI_Manager.OnMsgProc(hWnd: HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      I           : Integer;
      FMousePoint : TPoint;
      FTempForm   : TMIR3_GUI_Form;
    begin
      Result       := False;
      FMousePoint  := Point(LOWORD(DWORD(lParam)), HIWORD(DWORD(lParam)));
      for I := FFormList.Count - 1 downto 0 do
      begin
        FTempForm := TMIR3_GUI_Form(FFormList[I]);
        if Assigned(FTempForm) then
          if  (FTempForm.FVisible) and not (FTempForm.FMinimized) and (FTempForm.FEnabled)   then
          begin
            Result := FTempForm.OnMsgProc(hWnd, uMsg, wParam, lParam);
            if Result then
              Exit;
            if FTempForm.FGUI_Definition.gui_Modal_Event then
              Break;
          end;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Scene Basis Keyboard Message Processing
    //..............................................................................     
    procedure TMIR3_GUI_Manager.OnKeyboardProc(AChar: LongWord; AKeyDown, AAltDown: Boolean);
    begin
      if Assigned(FCallbackHotKeyEvent) and not(G_FControlFocus is TMIR3_GUI_Edit) then
        FCallbackHotKeyEvent(AChar);
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Delete and Free all Scene controls
    //..............................................................................    
    procedure TMIR3_GUI_Manager.DeleteAllControls;
    var
      I : Integer;
    begin
      {$REGION ' - DeleteAllControls  '}
      for I := 0 to FFormList.Count - 1 do
      begin
        if TMIR3_GUI_Form(FFormList[I]) <> nil then
        begin
          TMIR3_GUI_Form(FFormList[I]).Free;
          FFormList[I] := nil;
        end;
      end;
      FFormList.Clear;
      {$ENDREGION}
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Hide all Scene Forms and Controls
    //..............................................................................      
    procedure TMIR3_GUI_Manager.HideAllForms;
    var
      I : Integer;
    begin
      {$REGION ' - HideAllForms  '}
      for I := 0 to FFormList.Count - 1 do
      begin
        if TMIR3_GUI_Form(FFormList[I]) <> nil then
        begin
          TMIR3_GUI_Form(FFormList[I]).FVisible := False;
        end;
      end;
      {$ENDREGION}
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Requst Focus for given Control
    //..............................................................................    
    procedure TMIR3_GUI_Manager.RequestFocus(AControl: PMIR3_GUI_Default);
    begin
      if G_FControlFocus = @AControl then Exit;
      if (G_FControlFocus <> nil)   then
        G_FControlFocus.OnFocusOut;

      AControl.OnFocusIn;
      G_FControlFocus := AControl^;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Aquiere Component with given Component ID
    //..............................................................................      
    function TMIR3_GUI_Manager.GetComponentByID(ACompID: Cardinal): TObject;
    var
      I, I2      : Integer;
      FTempForm  : TMIR3_GUI_Form;
    begin
      Result := nil;
      try
        for I := 0 to FFormList.Count - 1 do
        begin
          FTempForm := TMIR3_GUI_Form(FFormList[I]);
          if Assigned(FTempForm) and Assigned(FTempForm.FControlList) then
          begin
            for I2 := 0 to FTempForm.FControlList.Count - 1 do
            begin
              if TMIR3_GUI_Default(FTempForm.FControlList[I2]).FControlIdentifier = ACompID then
              begin
                Result := TObject(FTempForm.FControlList[I2]);
                Exit;
              end;
            end;
          end;
        end;
      except
        Result := nil;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager Aquiere Form with given Component ID
    //..............................................................................        
    function TMIR3_GUI_Manager.GetFormByID(ACompID: Cardinal): TObject;
    var
      I         : Integer;
      FTempForm : TMIR3_GUI_Form;
    begin
      Result := nil;
      try
        for I := 0 to FFormList.Count-1 do
        begin
          FTempForm := TMIR3_GUI_Form(FFormList[I]);
          if Assigned(FTempForm) then
          begin
            if FTempForm.FControlIdentifier = ACompID then
            begin
              Result := FTempForm;
              Exit;
            end;
          end;
        end;
      except
        Result := nil;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager override Add Form with Ground Info to this Scene
    //..............................................................................     
    function TMIR3_GUI_Manager.AddForm(AGroundInfo: TMir3_GUI_Ground_Info; AVisible: Boolean): TObject;
    var
      FFormControl : TMIR3_GUI_Form;
    begin
    //@override
      FFormControl := TMIR3_GUI_Form.Create(AGroundInfo.gui_Form_Type, Self);
      with FFormControl do
      begin                                         
        FGUI_Definition    := AGroundInfo;
        FControlIdentifier := AGroundInfo.gui_Unique_Control_Number;
        FVisible           := AVisible;
        FEnabled           := AGroundInfo.gui_Enabled;
        FLeft              := AGroundInfo.gui_Left;
        FTop               := AGroundInfo.gui_Top;
        FWidth             := AGroundInfo.gui_Width;
        FHeight            := AGroundInfo.gui_Height;
        FFormType          := AGroundInfo.gui_Form_Type;
        if  AGroundInfo.gui_Window_Text.gui_Window_Caption_ID > 0 then
           FCaption := GGameEngine.GameLanguage.GetTextFromLangSystem(AGroundInfo.gui_Window_Text.gui_Window_Caption_ID)
        else FCaption := AGroundInfo.gui_Window_Text.gui_Window_Caption;
        if FGUI_Definition.gui_Use_Random_Texture then
        begin
          with FGUI_Definition.gui_Control_Texture do
            gui_Background_Texture_ID := RandomRange(gui_Random_Texture_From, gui_Random_Texture_To);
        end;
      end;
      FFormList.Add(FFormControl);
      Result := FFormControl;
    end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager override Add Form to this Scene
    //..............................................................................     
    function TMIR3_GUI_Manager.AddForm(AFormType: TMIR3_GUI_Form_Type; ACaptionID: Integer; AX, AY, AWidth, AHeight: Integer; AVisible: Boolean; AUIContolID: Integer): TObject;
    var
      FFormControl : TMIR3_GUI_Form;
    begin
    //@override
      FFormControl := TMIR3_GUI_Form.Create(AFormType, Self);
      with FFormControl do
      begin
        FControlIdentifier := AUIContolID;
        FVisible           := AVisible;
        FLeft              := AX;
        FTop               := AY;
        FWidth             := AWidth;
        FHeight            := AHeight;
        FFormType          := AFormType;
        
      end;
      FFormList.Add(FFormControl);
      Result := FFormControl;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager override Add Control to given form in this Scene
    //..............................................................................     
    function TMIR3_GUI_Manager.AddControl(AGUIForm: TObject; AGroundInfo: TMir3_GUI_Ground_Info; AVisible: Boolean): TObject;
    var
      FControl : TMIR3_GUI_Default;
    begin
    //@override    
      Result := nil;
      {$REGION ' - Add Controls  '}
      case AGroundInfo.gui_Type of
        ctNone     : begin
          Exit;
        end;

        ctPanel    : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Panel.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctPanel;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctEdit     : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Edit.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctEdit;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctGrid     : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Grid.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctGrid;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctButton   : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Button.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctListBox  : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_List_Box.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctListBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctComboBox : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_ComboBox.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctComboBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctCheckBox : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_CheckBox.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctCheckBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctRadioButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_RadioButton.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctRadioButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctSelectChar : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_SelectChar.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctSelectChar;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTextButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_TextButton.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctTextButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTextLabel : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_TextLabel.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctTextLabel;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctSlider : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Slider.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctSlider;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
            SetRect(FBoundingBox, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FParentGUIForm.FLeft + FLeft +FHeight, FParentGUIForm.FTop + FTop+FWidth);
            TMIR3_GUI_Slider(FControl).UpdateRects;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctProgress : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Progress.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctProgress;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;
        
        ctScrollbar : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Scrollbar.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctScrollbar;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
            SetRect(FBoundingBox, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FParentGUIForm.FLeft + FLeft +FHeight, FParentGUIForm.FTop + FTop+FWidth);
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;
        
        ctMagicButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_MagicButton.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctMagicButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTimer : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Timer.Create(@AGroundInfo, Self);
          with FControl do
          begin
            FGUI_Definition   := AGroundInfo;
            FControlType      := ctTimer;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AGroundInfo.gui_Unique_Control_Number;
            FLeft             := AGroundInfo.gui_Left;
            FTop              := AGroundInfo.gui_Top;
            FWidth            := AGroundInfo.gui_Width;
            FHeight           := AGroundInfo.gui_Height;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;
          
      end;
      {$ENDREGION}
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Manager override Add Control to given form in this Scene
    //..............................................................................  
    function TMIR3_GUI_Manager.AddControl(AGUIForm: TObject; AControlType: TMIR3_GUI_Type; AX, AY, AWidth, AHeight: Integer; AVisible: Boolean; AUIContolID: Integer): TObject;
    var
      FControl : TMIR3_GUI_Default;
    begin
    //@override    
      Result := nil;
      {$REGION ' - Add Controls  '}
      case AControlType of
        ctNone     : begin
          Exit;
        end;

        ctPanel    : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Panel.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctPanel;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctEdit     : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Edit.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctEdit;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctGrid     : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Grid.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctGrid;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctButton   : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Button.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctListBox  : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_List_Box.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctListBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctComboBox : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_ComboBox.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctComboBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctCheckBox : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_CheckBox.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctCheckBox;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctRadioButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_RadioButton.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctRadioButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctSelectChar : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_SelectChar.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctSelectChar;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTextButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_TextButton.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctTextButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTextLabel : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_TextLabel.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctTextLabel;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctSlider : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Slider.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctSlider;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctProgress : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Progress.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctProgress;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;
        
        ctScrollbar : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Scrollbar.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctScrollbar;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;  

        ctMagicButton : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_MagicButton.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctMagicButton;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

        ctTimer : begin
          if not Assigned(AGUIForm) then Exit;

          FControl := TMIR3_GUI_Timer.Create(nil, Self);
          with FControl do
          begin
            FControlType      := ctTimer;
            FParentGUIForm    := TMIR3_GUI_Form(AGUIForm);
            FControlIdentifier:= AUIContolID;
            FLeft             := AX;
            FTop              := AY;
            FWidth            := AWidth;
            FHeight           := AHeight;
            FVisible          := AVisible;
          end;
          TMIR3_GUI_Form(AGUIForm).FControlList.Add(FControl);
          Result              := FControl;
          if Assigned(FControl) then
            FControl.FDebugMode := FDebugMode;
        end;

      end;
      {$ENDREGION}
    end;

  {$ENDREGION}

 /// TMIR3_GUI_Form

  {$REGION ' - TMIR3_GUI_Form :: constructor / destructor      '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_Form.Create(AFormType: TMIR3_GUI_Form_Type; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      FEventTypeID             := 0;
      FTimeLastRefresh         := 0;
      FCaptionHeight           := 20;
      FTop                     := 0;
      FLeft                    := 0;
      FWidth                   := 0;
      FHeight                  := 0;
      FCaption                 := '.';
      FTimeRefresh             := 1;
      FVisibleCaption          := False;
      FEnabled                 := True;
      FVisible                 := True;
      FMinimized               := False;
      FParentGUIContainer      := PParentGUIManager;
      FFormType                := AFormType;
      FControlList             := TList.Create;
      FGUIMouseOver            := nil;
      FMousClickPoint          := Point(0,0);
      FDragMode                := False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Form control destructor
    //.............................................................................. 
    destructor TMIR3_GUI_Form.Destroy;
    var
      I : Integer;
    begin
      FParentGUIContainer := nil;
      if Assigned(FControlList) then
      begin
        for I := 0 to FControlList.Count - 1 do
        begin
          TMIR3_GUI_Default(FControlList[I]).Free;
        end;
        FControlList.Clear;
        FreeAndNil(FControlList);
      end;
      inherited Destroy;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Form :: class getter and setter    '}

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Get Visible state of the form
    //..............................................................................
    function TMIR3_GUI_Form.GetVisible: Boolean;
    begin
      Result := FVisible;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Set Visible state of the form and set ZOrder of the form
    //..............................................................................
    procedure TMIR3_GUI_Form.SetVisible(AValue: Boolean);
    begin
      if (FFormType <> ftBackground) and
         (FFormType <> ftNone)       then
      begin
        Self.FParentGUIContainer.SetZOrder(Self);
      end;
      
      if FVisible <> AValue then
      begin
        FVisible := AValue;
      end;
    end;

  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Form :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Render Form and the placed Controls
    //..............................................................................  
    procedure TMIR3_GUI_Form.OnRenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      I : Integer;
    begin
	    if not (Self.FMinimized) then
      begin
        // See if the dialog needs to be refreshed
        if (FTimeLastRefresh < FTimeRefresh) then
        begin
          FTimeLastRefresh := GRenderEngine.Timer_GetTime;
          Refresh;
        end;

	      (* Render Form it self *)
        if FParentGUIContainer.FDebugMode then
        begin
		      (* Render Form without Texture in Debug Mode *)
          GRenderEngine.Rectangle(FLeft, FTop, FWidth, FHeight, $FFFF0000, True);
        end else begin
		      (* Render Form with given Texture *)
          with FGUI_Definition, gui_Control_Texture, GGameEngine.FGameFileManger do
          begin
            if gui_Texture_File_ID <> 0 then
            begin
              if FGUI_Definition.gui_Use_Strech_Texture then
              begin
                DrawTextureStretch(gui_Background_Texture_ID, gui_Texture_File_ID, FLeft, FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, 2{BLEND_DEFAULT}, gui_Blend_Size);
              end else begin
                DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FLeft, FTop, 2{BLEND_DEFAULT}, gui_Blend_Size);
              end;
            end;
          end;
        end;

       (* Render all Form placed Controls *)
        for I := 0 to FControlList.Count-1 do
        begin
          if (TMIR3_GUI_Default(FControlList[I]).FVisible) then
            TMIR3_GUI_Default(FControlList[I]).RenderControl(AD3DDevice, AElapsedTime);
        end;
      end else begin
        (* Render Form as Icon with a Icon Texture [Minimize] *)

      end;
    end;

    procedure TMIR3_GUI_Form.Add_GUI_Definition(PGUI_Definition: PMir3_GUI_Ground_Info);
    begin
      if Assigned(PGUI_Definition) then
      begin
        FGUI_Definition    := PGUI_Definition^;
        FControlIdentifier := FGUI_Definition.gui_Unique_Control_Number;
        FLeft              := FGUI_Definition.gui_Left;
        FTop               := FGUI_Definition.gui_Top;
        FWidth             := FGUI_Definition.gui_Width;
        FHeight            := FGUI_Definition.gui_Height;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Form Window Message Processing
    //..............................................................................      
    function TMIR3_GUI_Form.OnMsgProc(hWnd: HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      FHandled    : Boolean;
      FMousePoint : TPoint;
      FControl    : TMIR3_GUI_Default;
    begin
      Result := True;
      //////////////////////////////////////////////////////////////////////////////////////
      // For invisible form, do not handle anything.
      if not FVisible then
      begin
        Result := False;
        Exit;
      end;
      //////////////////////////////////////////////////////////////////////////////////////
      // If caption is enable, check for clicks in the caption area.
      if FVisibleCaption or (FGUI_Definition.gui_Form_Type = ftMoving) then
      begin
        // Test if Control under the Mouse
        FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));
        FControl    := GetControlAtPoint(FMousePoint);
        if not Assigned(FControl) then
        begin
          if (uMsg = WM_MOUSEMOVE) and FDragMode then
          begin
            FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));
            SetFormLocation((FMousePoint.X - FMousClickPoint.X), (FMousePoint.Y - FMousClickPoint.Y));
            Exit;
          end;

          if (uMsg = WM_LBUTTONDBLCLK) then
          begin
            FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));
            if Self.FGUI_Definition.gui_WorkField.Bottom > 0 then
            begin
              with Self.FGUI_Definition do
              begin
                if (FMousePoint.x >= FLeft  + gui_WorkField.Left) and
                   (FMousePoint.x <  FLeft  + gui_WorkField.Left + gui_WorkField.Right) and
                   (FMousePoint.y >= FTop   + gui_WorkField.Top ) and
                   (FMousePoint.y <  FTop   + gui_WorkField.Top  + gui_WorkField.Bottom) then
                begin
                  FParentGUIContainer.SetZOrder(Self);
                  ReleaseCapture;
                  FDragMode  := False;
                  //FMinimized := not FMinimized;
                  Exit;
                end;
              end;
            end else begin
              if (FMousePoint.x >= FLeft) and (FMousePoint.x < FLeft + FWidth)  and
                 (FMousePoint.y >= FTop)  and (FMousePoint.y < FTop + FCaptionHeight) then
              begin
                FParentGUIContainer.SetZOrder(Self);
                ReleaseCapture;
                FDragMode  := False;
                //FMinimized := not FMinimized;
                Exit;
              end;
            end;
          end;

          if (uMsg = WM_LBUTTONDOWN) then
          begin
            FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));
            if Self.FGUI_Definition.gui_WorkField.Bottom > 0 then
            begin
              with Self.FGUI_Definition do
              begin
                if (FMousePoint.x >= FLeft  + gui_WorkField.Left) and
                   (FMousePoint.x <  FLeft  + gui_WorkField.Left + gui_WorkField.Right) and
                   (FMousePoint.y >= FTop   + gui_WorkField.Top ) and
                   (FMousePoint.y <  FTop   + gui_WorkField.Top  + gui_WorkField.Bottom) then
                begin
                  FParentGUIContainer.FFormFocusHandle := Self;
                  if Self.FGUI_Definition.gui_Form_Type <> ftBackground then
                  begin
                    FParentGUIContainer.SetZOrder(Self);
                    FDragMode := True;
                  end;
                  //SetCapture(GRenderEngine.GetGameHWND);
                  FMousClickPoint.x := FMousePoint.X - FLeft;
                  FMousClickPoint.y := FMousePoint.Y - FTop;
                  Exit;
                end;
              end;
            end else begin
              if (FMousePoint.x >= FLeft) and (FMousePoint.x < FLeft + FWidth ) and
                 (FMousePoint.y >= FTop)  and (FMousePoint.y < FTop  + FHeight) then
              begin
                FParentGUIContainer.FFormFocusHandle := Self;
                if Self.FGUI_Definition.gui_Form_Type <> ftBackground then
                begin
                  FParentGUIContainer.SetZOrder(Self);
                  FDragMode := True;
                end;
                //SetCapture(GRenderEngine.GetGameHWND);
                FMousClickPoint.x := FMousePoint.X - FLeft;
                FMousClickPoint.y := FMousePoint.Y - FTop;
                Exit;
              end;
            end;
          end else begin
            if (uMsg = WM_LBUTTONUP) then
            begin
              FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));
              if Self.FGUI_Definition.gui_WorkField.Bottom > 0 then
              begin
                with Self.FGUI_Definition do
                begin
                  if (FMousePoint.x >= FLeft  + gui_WorkField.Left) and
                     (FMousePoint.x <  FLeft  + gui_WorkField.Left + gui_WorkField.Right) and
                     (FMousePoint.y >= FTop   + gui_WorkField.Top ) and
                     (FMousePoint.y <  FTop   + gui_WorkField.Top  + gui_WorkField.Bottom) then
                  begin
                    //ReleaseCapture;
                    FDragMode  := False;
                    FParentGUIContainer.FFormFocusHandle := nil;
                    Exit;
                  end;
                end;
              end else begin
                if (FMousePoint.x >= FLeft) and (FMousePoint.x < FLeft + FWidth)  and
                   (FMousePoint.y >= FTop)  and (FMousePoint.y < FTop  + FHeight) then
                begin
                  //ReleaseCapture;
                  FDragMode  := False;
                  FParentGUIContainer.FFormFocusHandle := nil;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
      //////////////////////////////////////////////////////////////////////////////////////
      // If the Form is minimized, don't send any messages to controls.
      if (FMinimized) then
      begin
        Result := False;
        Exit;
      end;
      //////////////////////////////////////////////////////////////////////////////////////
      // If a control is in focus, it belongs to this dialog, and it's enabled,
      // then give it the first chance at handling the message.
      if (G_FControlFocus <> nil)   then//             and
         //(G_FControlFocus.FParentGUIForm = Self) and
        // (G_FControlFocus.Enabled)               then
      begin
        // If the control MsgProc handles it, then we don't.
        if (G_FControlFocus.MsgProc(uMsg, wParam, lParam)) then
        begin
          Exit;
        end;
      end;

      case uMsg of
        WM_SIZE,
        WM_MOVE        : begin
          //////////////////////////////////////////////////////////////////////////////////////
          // Handle sizing and moving messages so that in case the mouse cursor is moved out
          // of an UI control because of the window adjustment, we can properly
          // unhighlight the highlighted control.
          OnMouseMove(Point(-1, -1));
        end;
        WM_ACTIVATEAPP :  begin
          //////////////////////////////////////////////////////////////////////////////////////
          // Call OnFocusIn()/OnFocusOut() of the control that currently has the focus
          // as the application is activated/deactivated.  This matches the Windows behavior.
          if (G_FControlFocus <> nil)                and
             (G_FControlFocus.FParentGUIForm = Self) and
             (G_FControlFocus.GetEnabled)            then
          begin
            if (wParam <> 0) then
              G_FControlFocus.OnFocusIn
            else G_FControlFocus.OnFocusOut;
          end;
        end;
      { Keyboard messages }
        WM_KEYDOWN   ,
        WM_SYSKEYDOWN,
        WM_KEYUP     ,
        WM_SYSKEYUP  : begin
          // If a control is in focus, it belongs to this dialog, and it's enabled, then give
          // it the first chance at handling the message.
          if (G_FControlFocus <> nil)                     and
             //(G_FControlFocus.FParentGUIForm = Self) and
             (G_FControlFocus.GetEnabled)                 then
          begin
            if (G_FControlFocus.HandleKeyboard(uMsg, wParam, lParam)) then Exit;
          end;
          
          // Not yet handled, check for focus messages
          if (uMsg = WM_KEYDOWN) then
          begin
            case wParam of
              VK_RIGHT,
              VK_DOWN:
                if (G_FControlFocus <> nil) then
                begin
                  //Result:= OnCycleFocus(True);
                  Exit;
                end;
              VK_LEFT,
              VK_UP:
                if (G_FControlFocus <> nil) then
                begin
                  //Result:= OnCycleFocus(False);
                  Exit;
                end;
              VK_TAB:
              begin
                //bShiftDown := ((GetKeyState(VK_SHIFT) and $8000) <> 0);
                //Result     := OnCycleFocus(not bShiftDown);
                Exit;
              end;
            end;
          end;
        end;
      { Mouse messages }
        WM_MOUSEMOVE,
        WM_LBUTTONDOWN,
        WM_LBUTTONUP,
        WM_MBUTTONDOWN,
        WM_MBUTTONUP,
        WM_RBUTTONDOWN,
        WM_RBUTTONUP,
        //WM_XBUTTONDOWN,
        //WM_XBUTTONUP,
        WM_LBUTTONDBLCLK,
        WM_MBUTTONDBLCLK,
        WM_RBUTTONDBLCLK,
        //WM_XBUTTONDBLCLK,
        WM_MOUSEWHEEL : begin

          FMousePoint := Point(short(LOWORD(DWORD(lParam))), short(HIWORD(DWORD(lParam))));

          if (G_FControlFocus <> nil)                and
             (G_FControlFocus.FParentGUIForm = Self) and
             (G_FControlFocus.GetEnabled)            then
          begin
            if G_FControlFocus.HandleMouse(uMsg, FMousePoint, wParam, lParam) then
              Exit;
          end;

          FControl := GetControlAtPoint(FMousePoint);

          if (FControl <> nil) {and (FControl.FControlType <> ctPanel)} then
          begin
            FHandled := FControl.HandleMouse(uMsg, FMousePoint, wParam, lParam);
            if FHandled then
              Exit;
          end else begin
            //////////////////////////////////////////////////////////////////////////////////////
            // Mouse not over any controls in this dialog, if there was a control
            // which had focus it just lost it
            if (uMsg = WM_LBUTTONDOWN)                 and
               (G_FControlFocus <> nil)                and
               (G_FControlFocus.FParentGUIForm = Self) then
            begin
              G_FControlFocus.OnFocusOut;
              G_FControlFocus := nil;
              OnMouseDown(FMousePoint);
            end;
          end;
          //////////////////////////////////////////////////////////////////////////////////////
          // Still not handled, hand this off to the dialog. Return false to indicate the
          // message should still be handled by the application (usually to move the camera).
          case uMsg of
            WM_MOUSEMOVE:
            begin
              OnMouseMove(FMousePoint);
              Result := False;
              Exit;
            end;
          end;

        end;
        WM_CAPTURECHANGED: begin
          //////////////////////////////////////////////////////////////////////////////////////
          // The application has lost mouse capture.
          // The dialog object may not have received
          // a WM_MOUSEUP when capture changed. Reset
          // m_bDrag so that the dialog does not mistakenly
          // think the mouse button is still held down.
         if (THandle(lParam) <> hWnd) then
            FDragMode := False;
        end;
      end;
      Result:= False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Forms On Mouse Move Notifycation
    //..............................................................................    
    procedure TMIR3_GUI_Form.OnMouseMove(AMousePoint: TPoint);
    var
      FControl: TMIR3_GUI_Default;
    begin
      // Figure out which control the mouse is over now
      FControl := GetControlAtPoint(AMousePoint);

      // If the mouse is still over the same control, nothing needs to be done
      if (FControl = FGUIMouseOver) then Exit;

      // Handle mouse leaving the old control
      if (FGUIMouseOver <> nil) then
        TMIR3_GUI_Default(FGUIMouseOver).OnMouseLeave;

      // Handle mouse entering the new control
      FGUIMouseOver := FControl;

      if (FControl <> nil) then
        TMIR3_GUI_Default(FGUIMouseOver).OnMouseEnter;
	  end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Forms On Mouse Down Notifycation
    //..............................................................................        
    procedure TMIR3_GUI_Form.OnMouseDown(AMousePoint: TPoint);
    begin
    
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Forms On Mouse Up Notifycation
    //..............................................................................      
    procedure TMIR3_GUI_Form.OnMouseUp(AMousePoint: TPoint);
    begin
      FGUIMouseOver := nil;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Refresh Form and all Controls
    //..............................................................................    
    procedure TMIR3_GUI_Form.Refresh;
    var
      i: Integer;
    begin
      if (G_FControlFocus <> nil) then
        G_FControlFocus.OnFocusOut;

      if (FGUIMouseOver <> nil) then
        FGUIMouseOver.OnMouseLeave;

      G_FControlFocus := nil;
      FGUIMouseOver   := nil;

      for i:= 0 to FControlList.Count - 1 do
      begin
        TMIR3_GUI_Default(FControlList[i]).OnRefresh;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Set the Form Location after Moving it
    //..............................................................................
    procedure TMIR3_GUI_Form.SetFormLocation(AX, AY: Integer);
    begin
      FLeft := AX;
      FTop  := AY;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Helper function to set Textures
    //..............................................................................
    procedure TMIR3_GUI_Form.SetTextureID(ATextureID: Integer; AType: Integer=0);
    begin
      with FGUI_Definition.gui_Control_Texture do
      begin
        case AType of
         0  : gui_Background_Texture_ID                          := ATextureID;
         1  : gui_Mouse_Over_Texture_ID                          := ATextureID;
         2  : gui_Mouse_Down_Texture_ID                          := ATextureID;
         3  : gui_Mouse_Select_Texture_ID                        := ATextureID;
         4  : gui_Mouse_Disable_Texture_ID                       := ATextureID;
         5  : gui_Slider_Texture_ID                              := ATextureID;
         6  : gui_Random_Texture_From                            := ATextureID;
         7  : gui_Random_Texture_To                              := ATextureID;
         8  : gui_Extra_Texture_Set.gui_Background_Texture_ID    := ATextureID;
         9  : gui_Extra_Texture_Set.gui_Mouse_Over_Texture_ID    := ATextureID;
         10 : gui_Extra_Texture_Set.gui_Mouse_Down_Texture_ID    := ATextureID;
         11 : gui_Extra_Texture_Set.gui_Mouse_Select_Texture_ID  := ATextureID;
         12 : gui_Extra_Texture_Set.gui_Mouse_Disable_Texture_ID := ATextureID;
        end;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Form Test Mouse is placed on Control
    //..............................................................................     
    function TMIR3_GUI_Form.GetControlAtPoint(AMousePoint: TPoint): TMIR3_GUI_Default;
    var
      I        : Integer;
      FControl : TMIR3_GUI_Default;
    begin
      // Search through all child controls for the
      // first one which contains the mouse point
      for I := FControlList.Count - 1 downto 0 do
      begin
        FControl := TMIR3_GUI_Default(FControlList[I]);

        if (FControl = nil) then
         Continue;

        if FControl.ContainsPoint(AMousePoint) and FControl.Enabled and FControl.Visible then
        begin
          Result := FControl;
          Exit;
        end;
      end;
      Result:= nil;
    end;

  {$ENDREGION}

 /// TMIR3_GUI_Default

  {$REGION ' - TMIR3_GUI_Default :: constructor / destructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Form control constructor
    //..............................................................................
    constructor TMIR3_GUI_Default.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited Create;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer      := PParentGUIManager;
      FParentGUIForm           := nil;
      FTop                     := 0;
      FLeft                    := 0;
      FWidth                   := 0;
      FHeight                  := 0;	  
      FEnabled                 := True;
      FVisible                 := True; 
    end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Form control destructor
    //..............................................................................     
    destructor TMIR3_GUI_Default.Destroy;
    begin
      FParentGUIContainer := nil;
      FParentGUIForm      := nil;
      inherited;
    end;
  {$ENDREGION} 

  {$REGION ' - TMIR3_GUI_Default :: class getter and setter  '}
    procedure TMIR3_GUI_Default.Add_GUI_Definition(PGUI_Definition: PMir3_GUI_Ground_Info);
    begin
      if Assigned(PGUI_Definition) then
      begin
        FGUI_Definition    := PGUI_Definition^;
        FControlIdentifier := FGUI_Definition.gui_Unique_Control_Number;
        FLeft              := FGUI_Definition.gui_Left;
        FTop               := FGUI_Definition.gui_Top;
        FWidth             := FGUI_Definition.gui_Width;
        FHeight            := FGUI_Definition.gui_Height;
      end;
    end;


    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Get Enabled 
    //..............................................................................  
    function TMIR3_GUI_Default.GetEnabled: Boolean;
    begin
      Result := FEnabled;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Set Enabled 
    //..............................................................................    
    procedure TMIR3_GUI_Default.SetEnabled(AEnabled: Boolean);
    begin
      if AEnabled <> FEnabled then
        FEnabled := AEnabled;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Get Visible 
    //..............................................................................    
    function TMIR3_GUI_Default.GetVisible: Boolean;
    begin
      Result := FVisible;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Set Visible 
    //..............................................................................    
    procedure TMIR3_GUI_Default.SetVisible(AVisible: Boolean);
    begin
      if AVisible <> FVisible then
        FVisible := AVisible;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Default :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual
    //..............................................................................    
    function TMIR3_GUI_Default.ContainsPoint(AMousePoint: TPoint): LongBool;
    begin
	  // @virtual
      if FParentGUIForm = nil then
      begin
        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint);
      end else begin
        Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft ,FParentGUIForm.FTop + FTop,FParentGUIForm.FLeft + FLeft+FWidth,FParentGUIForm.FTop + FTop+FHeight), AMousePoint);
      end;
    end;
	
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual render function
    //..............................................................................    
    procedure TMIR3_GUI_Default.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    begin
    //@virtual
  	end;
    
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual On Control Refresh Notifycation  
    //.............................................................................. 
    procedure TMIR3_GUI_Default.OnRefresh;
    begin
	//@virtual	
      FMouseOver := False;
      FFocus     := False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual On Focus in Notifycation
    //..............................................................................    
    procedure TMIR3_GUI_Default.OnFocusIn;
    begin
	//@virtual
      FFocus := True;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual On Focus out Notifycation
    //..............................................................................    
    procedure TMIR3_GUI_Default.OnFocusOut;
    begin
	//@virtual
      FFocus := False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Control On Mouse Enter Notifycation
    //..............................................................................    
    procedure TMIR3_GUI_Default.OnMouseEnter;
    begin
	//@virtual
      FMouseOver := True;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default Control On Mouse Leave Notifycation
    //..............................................................................    
    procedure TMIR3_GUI_Default.OnMouseLeave;
    begin
    //@virtual
      FMouseOver := False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual Handle Windows Messages 
    //..............................................................................    
    function TMIR3_GUI_Default.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
	  //@virtual
      Result := False; 
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual Handle Keyboard 
    //..............................................................................    
    function TMIR3_GUI_Default.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
	  //@virtual
      Result := False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Default virtual Handle Mouse
    //..............................................................................    
    function TMIR3_GUI_Default.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
	  //@virtual
      Result := False;
    end;
	
  {$ENDREGION} 	

 /// TMIR3_GUI_Panel

  {$REGION ' - TMIR3_GUI_Panel :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Panel Form control constructor
    //..............................................................................   
    constructor TMIR3_GUI_Panel.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FMouseState         := bsBase;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctPanel;
      FCaption            := '';
      FAnimationCount     := 30;
      FCurrentMaxCount    := 1;
      FAnimationTime      := GetTickCount;
      FGUI_Definition.gui_Animation.gui_Animation_Current := 0;
    end;
  {$ENDREGION} 
  
  {$REGION ' - TMIR3_GUI_Panel :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Panel override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_Panel.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
     I              : Integer;
     FMoveRect      : TRect;
     FTempX, FTempY : Integer;
     FTempImageID   : Integer;
     FTempImage     : PImageHeaderD3D;
     FDrawSetting   : TDrawSetting;
    begin
	  // @override
	    (* Render Panel *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Panel without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
        if FGUI_Definition.gui_ShowPanel then
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, FGUI_Definition.gui_Color.gui_ControlColor, True);
        if FGUI_Definition.gui_ShowBorder then
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, FGUI_Definition.gui_Color.gui_BorderColor, False);
          
        (* Render Panel with given Texture *)
        with FGUI_Definition, gui_Font, gui_Control_Texture, gui_Caption_Extra, gui_Animation, GGameEngine.FGameFileManger, GGameEngine.FontManager do
        begin
          if gui_Texture_File_ID > 74 then
          begin
            if (gui_ExtraBackground_Texture_ID > 0) and (gui_ExtraTexture_File_ID > 74) then
            begin
              if gui_Use_Strech_Texture then
              begin
                DrawTextureStretch(gui_ExtraBackground_Texture_ID, gui_ExtraTexture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, gui_Strech_Rate_X, gui_Strech_Rate_Y, gui_Blend_Mode_Extra, gui_Blend_Size_Extra);
              end else begin
                DrawTexture(gui_ExtraBackground_Texture_ID, gui_ExtraTexture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, gui_Blend_Mode_Extra, gui_Blend_Size_Extra);
              end;
            end;

            if gui_Background_Texture_ID > 0 then
            begin
              if gui_Use_Strech_Texture then
              begin
                DrawTextureStretch(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, gui_Blend_Mode, gui_Blend_Size);
              end else begin
                if gui_Use_Repeat_Texture then
                begin
                  FTempImage := GGameEngine.FGameFileManger.GetImageD3DDirect(gui_Background_Texture_ID, gui_Texture_File_ID);
                  for I := 0 to gui_Repeat_Count do
                  begin
                    if Assigned(FTempImage) then
                    begin
                      DrawTexture(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop + ((FTempImage.ihORG_Height-1) * I), gui_Blend_Mode, gui_Blend_Size);
                    end;
                  end;
                end else if gui_Use_Null_Point_Calc then
                         begin
                           FTempImage := GGameEngine.FGameFileManger.GetImageD3DDirect(gui_Background_Texture_ID, gui_Texture_File_ID);
                           if Assigned(FTempImage) then
                           begin
                             DrawTexture(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + gui_Null_Point_X + FTempImage.ihOffset_X, FParentGUIForm.FTop + gui_Null_Point_Y + FTempImage.ihOffset_Y, gui_Blend_Mode, gui_Blend_Size);
                           end;
                         end else begin
                           if gui_Use_Cut_Rect then
                           begin
                             SetRect(FMoveRect, gui_WorkField.Left  + gui_Cut_Rect_Position_X, gui_WorkField.Top    + gui_Cut_Rect_Position_Y,
                                                gui_WorkField.Right + gui_Cut_Rect_Position_X, gui_WorkField.Bottom + gui_Cut_Rect_Position_Y);
                             DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FMoveRect, gui_Blend_Mode, gui_Blend_Size);
                           end else begin
                             case gui_Texture_Align of
                               taTop    : DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Blend_Mode, gui_Blend_Size);
                               taCenter : begin
                                 FTempImage := GGameEngine.FGameFileManger.GetImageD3DDirect(gui_Background_Texture_ID, gui_Texture_File_ID);
                                 FTempX := (FWidth  div 2) - (FTempImage.ihORG_Width  div 2);
                                 FTempY := (FHeight div 2) - (FTempImage.ihORG_Height div 2);
                                 DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + FTempX, FParentGUIForm.FTop + FTop +FTempY, gui_Blend_Mode, gui_Blend_Size);
                               end;
                               taBottom : begin
                                 FTempImage := GGameEngine.FGameFileManger.GetImageD3DDirect(gui_Background_Texture_ID, gui_Texture_File_ID);
                                 FTempY     := FHeight - FTempImage.ihORG_Height;
                                 DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop + FTempY, gui_Blend_Mode, gui_Blend_Size);
                               end;
                             end;
                           end;
                         end;
              end;
            end;

            if (gui_Use_Animation_Texture) and ((gui_Animation_Max_Count = 0) or (FCurrentMaxCount <= gui_Animation_Max_Count)) then
            begin
              if (gui_Animation_Texture_File_ID > 0) and (gui_Animation_Texture_From > 0) and (gui_Animation_Texture_To > 0)  then
              begin
                if gui_Use_Null_Point_Calc then
                begin
                  FTempImageID := (gui_Animation_Current + gui_Animation_Texture_From);
                  FTempImage   := GGameEngine.FGameFileManger.GetImageD3DDirect(FTempImageID, gui_Animation_Texture_File_ID);
                  if Assigned(FTempImage) then
                  begin
                    if gui_Use_Strech_Texture then
                    begin
                      DrawTextureStretch(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + gui_Null_Point_X + FTempImage.ihOffset_X, FParentGUIForm.FTop + gui_Null_Point_Y + FTempImage.ihOffset_Y, gui_Strech_Rate_X, gui_Strech_Rate_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                    end else begin
                      DrawTexture(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + gui_Null_Point_X + FTempImage.ihOffset_X, FParentGUIForm.FTop + gui_Null_Point_Y + FTempImage.ihOffset_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                    end;
                  end;
                end else if gui_Use_Offset_Calc then
                         begin
                           FTempImageID := (gui_Animation_Current + gui_Animation_Texture_From);
                           FTempImage   := GGameEngine.FGameFileManger.GetImageD3DDirect(FTempImageID, gui_Animation_Texture_File_ID);
                           if Assigned(FTempImage) then
                           begin
                             if gui_Use_Strech_Texture then
                             begin
                               DrawTextureStretch(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + FLeft + FTempImage.ihOffset_X, FParentGUIForm.FTop + FTop + FTempImage.ihOffset_Y, gui_Strech_Rate_X, gui_Strech_Rate_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                             end else begin
                               DrawTexture(FTempImage.ihD3DTexture, FParentGUIForm.FLeft + FLeft + FTempImage.ihOffset_X, FParentGUIForm.FTop + FTop + FTempImage.ihOffset_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                             end;
                           end;
                         end else begin
                           if gui_Use_Strech_Texture then
                           begin
                             DrawTextureStretch(gui_Animation_Current + gui_Animation_Texture_From, gui_Animation_Texture_File_ID, FParentGUIForm.FLeft + gui_Animation_Offset_X, FParentGUIForm.FTop + gui_Animation_Offset_Y, gui_Strech_Rate_X, gui_Strech_Rate_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                           end else begin
                             DrawTexture(gui_Animation_Current + gui_Animation_Texture_From, gui_Animation_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Animation_Offset_X, FParentGUIForm.FTop + FTop + gui_Animation_Offset_Y, gui_Animation_Blend_Mode, gui_Blend_Size);
                           end;
                         end;
                if (GetTickCount - FAnimationTime) > gui_Animation_Interval then
                begin
                  FAnimationTime := GetTickCount;
                  if (gui_Animation_Current + gui_Animation_Texture_From) >= gui_Animation_Texture_To then
                    gui_Animation_Current := 0
                  else Inc(gui_Animation_Current);
                  Inc(FCurrentMaxCount);
                end;
              end;
            end else gui_Use_Animation_Texture := False;

            if (gui_CaptionID > 0) or (Trim(FCaption) <> '') then
            begin
              with FDrawSetting do
              begin
                dsControlWidth  := FWidth;
                dsControlHeigth := FHeight;
                dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                dsAY            := FParentGUIForm.FTop  + FTop  + 1 + gui_Caption_Offset;
                dsFontHeight    := gui_Font_Size;
                dsFontSetting   := gui_Font_Setting;
                dsFontType      := 0;
                dsFontSpacing   := 0;
                dsUseKerning    := gui_Font_Use_Kerning;
                dsColor         := gui_Font_Color;
                dsHAlign        := gui_Font_Text_HAlign;
                dsVAlign        := gui_Font_Text_VAlign;
                dsMagicUse      := False;
              end;
              if gui_CaptionID > 0 then
              begin
                DrawText(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
                //DrawTextColor(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
              end else begin
                DrawText(PWideChar(FCaption), @FDrawSetting);
                //DrawTextColor(PWideChar(FCaption), @FDrawSetting);
              end;
            end;
          end else if (Trim(FCaption) <> '') or (gui_CaptionID > 0) then
                   begin
                     case gui_Scroll_Text of
                       True  : begin
                         with FDrawSetting do
                         begin
                           dsControlWidth  := FWidth;
                           dsControlHeigth := FHeight;
                           dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                           dsAY            := FParentGUIForm.FTop  + FTop  + 1 + gui_Caption_Offset;
                           dsFontHeight    := gui_Font_Size;
                           dsFontSetting   := gui_Font_Setting;
                           dsFontType      := 0;
                           dsFontSpacing   := 0;
                           dsUseKerning    := gui_Font_Use_Kerning;
                           dsColor         := gui_Font_Color;
                           dsHAlign        := gui_Font_Text_HAlign;
                           dsVAlign        := gui_Font_Text_VAlign;
                           dsMagicUse      := False;
                         end;
                         if gui_CaptionID > 0 then
                         begin
                           if GetTickCount - FAnimationTime > 36 then
                           begin
                             FAnimationTime := GetTickCount;
                             if FAnimationCount >= FHeight + GetLineCount(PChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)))*(gui_Font_Size + 1) then
                               FAnimationCount := 0
                             else Inc(FAnimationCount, 1);
                           end;
                           DrawMoveV(FAnimationCount, GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID), @FDrawSetting);
                         end else begin
                           if GetTickCount - FAnimationTime > 36 then
                           begin
                             FAnimationTime := GetTickCount;
                             if FAnimationCount >= FHeight + GetLineCount(PChar(FCaption)) * (gui_Font_Size + 1) then
                               FAnimationCount := 0
                             else Inc(FAnimationCount, 1);
                           end;
                           DrawMoveV(FAnimationCount , FCaption, @FDrawSetting);
                         end;
                       end;
                       False : begin
                         with FDrawSetting do
                         begin
                           dsControlWidth  := FWidth;
                           dsControlHeigth := FHeight;
                           dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                           dsAY            := FParentGUIForm.FTop  + FTop  + 1 + gui_Caption_Offset;
                           dsFontHeight    := gui_Font_Size;
                           dsFontSetting   := gui_Font_Setting;
                           dsFontType      := 0;
                           dsFontSpacing   := 0;
                           dsUseKerning    := gui_Font_Use_Kerning;
                           dsColor         := gui_Font_Color;
                           dsHAlign        := gui_Font_Text_HAlign;
                           dsVAlign        := gui_Font_Text_VAlign;
                           dsMagicUse      := False;
                         end;
                         if gui_CaptionID > 0 then
                         begin
                           DrawText(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
                           //DrawTextColor(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
                         end else begin
                           DrawText(PWideChar(FCaption), @FDrawSetting);
                           //DrawTextColor(PWideChar(FCaption), @FDrawSetting);
                         end;
                       end;
                     end;
                   end;
          (* Render Hint *)
          if (FMouseOver) and (gui_HintID <> 0) then
          begin
            with FDrawSetting do
            begin
              dsFontHeight    := 18;
              dsFontSetting   := [];
              dsFontType      := 0;
              dsFontSpacing   := 0;              
              dsHAlign        := alLeft;
              dsVAlign        := avTop;
              dsUseKerning    := False;
              dsColor         := $FFF7F767;
              dsMagicUse      := False;
            end;
            FParentGUIContainer.AddHintMessage(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_HintID), FDrawSetting, Self);
          end;                   
        end;
      end;
	  end;

    function TMIR3_GUI_Panel.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
      Result := True;
      if not FEnabled or not FVisible then
      begin
        Result := False;
        Exit;
      end;

      case uMsg of
        WM_LBUTTONDOWN     : begin
          if ContainsPoint(AMousePoint) then
          begin
            FParentGUIContainer.SendEvent(EVENT_BUTTON_DOWN, True, @Self);
            Exit;
          end;
        end;
        WM_LBUTTONDBLCLK   : begin
          if ContainsPoint(AMousePoint) then
          begin
            FParentGUIContainer.SendEvent(EVENT_BUTTON_DBCLICKED, True, @Self);
            Exit;
          end;
        end;
        WM_LBUTTONUP:
        begin
          if ContainsPoint(AMousePoint) then
            FParentGUIContainer.SendEvent(EVENT_BUTTON_UP, True, @Self);
          Exit;
        end;
      end;

      Result:= False;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Panel Helper function to set Textures
    //..............................................................................
    procedure TMIR3_GUI_Panel.SetTextureID(ATextureID: Integer; AType: Integer=0);
    begin
      with FGUI_Definition.gui_Control_Texture do
      begin
        case AType of
         0  : gui_Background_Texture_ID                          := ATextureID;
         1  : gui_Mouse_Over_Texture_ID                          := ATextureID;
         2  : gui_Mouse_Down_Texture_ID                          := ATextureID;
         3  : gui_Mouse_Select_Texture_ID                        := ATextureID;
         4  : gui_Mouse_Disable_Texture_ID                       := ATextureID;
         5  : gui_Slider_Texture_ID                              := ATextureID;
         6  : gui_Random_Texture_From                            := ATextureID;
         7  : gui_Random_Texture_To                              := ATextureID;
         8  : gui_Extra_Texture_Set.gui_Background_Texture_ID    := ATextureID;
         9  : gui_Extra_Texture_Set.gui_Mouse_Over_Texture_ID    := ATextureID;
         10 : gui_Extra_Texture_Set.gui_Mouse_Down_Texture_ID    := ATextureID;
         11 : gui_Extra_Texture_Set.gui_Mouse_Select_Texture_ID  := ATextureID;
         12 : gui_Extra_Texture_Set.gui_Mouse_Disable_Texture_ID := ATextureID;
        end;
      end;
    end;

  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Panel :: class getter and setter  '}
    procedure TMIR3_GUI_Panel.SetCaption(ACaption: WideString);
    begin
      if ACaption <> FCaption then
        FCaption := ACaption;
    end;

    function TMIR3_GUI_Panel.GetCaption: WideString;
    begin
      Result := FCaption;
    end;
  {$ENDREGION}

 /// TMIR3_GUI_Edit
 
  {$REGION ' - TMIR3_GUI_Edit :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Edit Form control constructor
    //..............................................................................   
    constructor TMIR3_GUI_Edit.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctEdit;
      FBlinkCaret         := GetCaretBlinkTime * 0.001;
      FStringBuffer       := TStringBuffer.Create;
      FLastBlinkCaret     := DX9GetGlobalTimer.GetAbsoluteTime;
      FFocus              := False;
      FFirstVisibleChar   := 0;
      FCaretPos           := 0;
      FSelectStartPos     := 0;
      MaxLen              := 255;
      FCaretOn            := True;
      FInsertMode         := True;
      FMouseDrag          := False;
      FSelectColor        := D3DCOLOR_ARGB(128, 70, 108, 155);
      FCaretColor         := D3DCOLOR_ARGB(245, 110, 110, 110);
      if Assigned(PGUI_Definition) then
      begin
        FGUI_Definition := PGUI_Definition^;
        MaxLen          := FGUI_Definition.gui_Edit_Max_Length;
      end;      
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Edit :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Edit override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_Edit.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FCaretRect     : TRect;
      FCaretX        : Integer;
      FSelStartX     : Integer;
      FSelLeftX      : Integer;
      FSelRightX     : Integer;
      FTemp          : Integer;
      FFirstChar     : Integer;
      FRightEdgeX    : Integer;
      FDrawSetting   : TDrawSetting;
      FTextSelection : TRect;
      FTextPW        : WideString;
    begin
    //@override
	    (* Render Edit *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Edit without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FF050505, True);
      end else begin
        FCaretX    := 0;
        FSelStartX := 0;
        FFirstChar := 0;

        with FGUI_Definition, gui_Font, gui_Color, FDrawSetting, GGameEngine.FontManager do
        begin                                                                                                                     
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, gui_ControlColor, True);
          if FGUI_Definition.gui_ShowBorder then
            GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, gui_BorderColor, False);

          SetRect(FTextRect, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FParentGUIForm.FLeft + FLeft+FWidth, FParentGUIForm.FTop + FTop+FHeight);
          PlaceCaret(FCaretPos);
          GGameEngine.FontManager.GetFirstVisibleChar(gui_Font_Use_ID, Text, FFirstVisibleChar, FFirstChar);
          GGameEngine.FontManager.GetFirstVisibleChar(gui_Font_Use_ID, Text, FCaretPos        , FCaretX);

          if (FCaretPos <> FSelectStartPos) then
            GGameEngine.FontManager.GetFirstVisibleChar(gui_Font_Use_ID, Text, FSelectStartPos, FSelStartX)
          else FSelStartX := FCaretX;

          dsControlWidth  := FWidth;
          dsControlHeigth := FHeight;
          dsAX            := FParentGUIForm.FLeft + FLeft + 2;
          dsAY            := FParentGUIForm.FTop  + FTop  + 3;
          dsFontHeight    := gui_Font_Size;
          dsFontSetting   := gui_Font_Setting;
          dsFontType      := 0;
          dsFontSpacing   := 0;
          dsUseKerning    := gui_Font_Use_Kerning;
          dsColor         := gui_Font_Color;
          dsHAlign        := gui_Font_Text_HAlign;
          dsVAlign        := gui_Font_Text_VAlign;
          dsMaxWidth      := dsAX + FWidth -4;
          
          if gui_Password_Char <> '' then
          begin
            FTextPW := StringOfChar(gui_Password_Char[1] , FStringBuffer.TextSize);
            DrawTextRect(PWideChar(FTextPW), FFirstVisibleChar, @FDrawSetting);
            GGameEngine.FontManager.GetFirstVisibleChar(gui_Font_Use_ID, FTextPW, FCaretPos, FCaretX);
          end else DrawTextRect(FStringBuffer.Buffer, FFirstVisibleChar, @FDrawSetting);

          // Render the selection rectangle
          if (FCaretPos <> FSelectStartPos) then
          begin
            FSelLeftX  := FCaretX;
            FSelRightX := FSelStartX;
            // Swap if left is bigger than right
            if (FSelLeftX > FSelRightX) then
            begin
              FTemp      := FSelLeftX;
              FSelLeftX  := FSelRightX;
              FSelRightX := FTemp;
            end;

            SetRect(FTextSelection, FSelLeftX, FTextRect.top, FSelRightX+1, FTextRect.bottom);
            OffsetRect(FTextSelection, FTextRect.left - FFirstChar, 0);
            IntersectRect(FTextSelection, FTextRect, FTextSelection);
            GRenderEngine.Rectangle(FTextSelection.Left, FTextSelection.Top, FTextSelection.Right - FTextSelection.Left, FTextSelection.Bottom -FTextSelection.Top, FSelectColor, True);
          end;

          // Blink the caret
          if (DX9GetGlobalTimer.GetAbsoluteTime - FLastBlinkCaret >= FBlinkCaret) then
          begin
            FCaretOn        := not FCaretOn;
            FLastBlinkCaret := DX9GetGlobalTimer.GetAbsoluteTime;
          end;

          // Render the caret if this control has the focus
          if (FFocus and FCaretOn) then
          begin
            FCaretRect := Rect((FTextRect.left +2) - FFirstChar + FCaretX   , FTextRect.top+2,
                               (FTextRect.left +2) - FFirstChar + FCaretX +1, FTextRect.bottom-2);

            // If we are in overwrite mode, adjust the caret rectangle to fill the entire character.
            if (not FInsertMode) then
            begin
             // Obtain the right edge X coord of the current character
              GGameEngine.FontManager.GetFirstVisibleChar(gui_Font_Use_ID, Text, FCaretPos, FRightEdgeX);
              FCaretRect.right := FTextRect.left - FFirstChar + FRightEdgeX;
            end;
            GRenderEngine.Rectangle(FCaretRect.Left, FCaretRect.Top, FCaretRect.Right - FCaretRect.Left, FCaretRect.Bottom -FCaretRect.Top, FCaretColor, True);
          end;
        end;
      end;
	  end;

    function TMIR3_GUI_Edit.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
      if (not FEnabled or not FVisible) then
      begin
        Result := False;
        Exit;
      end;

      case uMsg of
        WM_KEYUP   : begin
          {$REGION ' - Key UP Handling '}
            Result := True;
            Exit;
          {$ENDREGION}
        end;
        WM_KEYDOWN : begin
          {$REGION ' - Key Down Handling '}
            Result := False;
            case wParam of
              VK_HOME  : begin
                PlaceCaret(0);
                if (GetKeyState(VK_SHIFT) >= 0) then
                begin
                  FSelectStartPos := FCaretPos;
                end;
                ResetCaretBlink;
                Result := True;
              end;
              VK_END   : begin
                PlaceCaret(Length(Text));
                if (GetKeyState(VK_SHIFT) >= 0) then
                  FSelectStartPos := FCaretPos;
                ResetCaretBlink;
                Result := True;
              end;
              VK_LEFT  : begin
                if (GetKeyState(VK_CONTROL) < 0) then
                begin
                  if FCaretPos > 0 then
                    Dec(FCaretPos);
                  
                  PlaceCaret(FCaretPos);
                end else if (FCaretPos > 0) then
                           PlaceCaret(FCaretPos -1);
                if (GetKeyState(VK_SHIFT) >= 0) then
                  FSelectStartPos := FCaretPos;
                ResetCaretBlink;
                Result := True;
              end;
              VK_RIGHT  : begin
                if (GetKeyState(VK_CONTROL) < 0) then
                begin
                  if FCaretPos < Length(Text) then
                    Inc(FCaretPos);
                  PlaceCaret(FCaretPos);
                end else if (FCaretPos < Length(Text)) then
                           PlaceCaret(FCaretPos + 1);
                if (GetKeyState( VK_SHIFT ) >= 0) then
                  FSelectStartPos := FCaretPos;
                ResetCaretBlink;
                Result := True;
              end;
            end;
            Exit;
          {$ENDREGION}
        end;
        WM_CHAR    : begin
          {$REGION ' - Key Char Handling '}
            if not(Char(wParam) in FGUI_Definition.gui_Edit_Using_ASCII) then
            begin
              Result := True;
              exit;
            end;
            case wParam of
              VK_BACK   : begin  // Backspace
                // If there's a selection, treat this like a delete key.
                if (FCaretPos <> FSelectStartPos) then
                begin
                  DeleteSelectionText;
                  FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
                end else if (FCaretPos > 0) then  // Move the caret, then delete the char.
                         begin
                           PlaceCaret(FCaretPos - 1);
                           FSelectStartPos := FCaretPos;
                           FStringBuffer.RemoveChar(FCaretPos);
                           FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
                         end;
                ResetCaretBlink;
              end;
              MIR3_VK_CTRL_X ,      // Ctrl-X Cut
              VK_CANCEL      : begin // Ctrl-C Copy
                CopyToClipboard;
                // If the key is Ctrl-X, delete the selection too.
                if (wParam = MIR3_VK_CTRL_X) then
                begin
                  DeleteSelectionText;
                  FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
                end;
              end;
              MIR3_VK_CTRL_V : begin  // Ctrl-V Paste
                PasteFromClipboard;
                FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
              end;
              MIR3_VK_CTRL_A : begin  // Ctrl-A Select All
                if (FSelectStartPos = FCaretPos) then
                begin
                  FSelectStartPos := 0;
                  PlaceCaret(FStringBuffer.TextSize);
                end;
              end;
              VK_RETURN     ,
              VK_TAB        : begin
                // Invoke the callback when the user presses Enter or Tab.
                FParentGUIContainer.SendEvent(EVENT_EDITBOX_RETURN, True, @Self);
              end;
              // Junk characters we don't want in the string
              MIR3_VK_CTRL_B,
              MIR3_VK_CTRL_D,
              MIR3_VK_CTRL_E,
              MIR3_VK_CTRL_F,
              MIR3_VK_CTRL_G,
              //MIR3_VK_CTRL_I,
              MIR3_VK_CTRL_J,                        
              MIR3_VK_CTRL_K,                        
              MIR3_VK_CTRL_L,
              MIR3_VK_CTRL_N,                        
              MIR3_VK_CTRL_O,                        
              MIR3_VK_CTRL_P,
              MIR3_VK_CTRL_Q,
              MIR3_VK_CTRL_R,
              MIR3_VK_CTRL_S,                        
              MIR3_VK_CTRL_T,
              MIR3_VK_CTRL_U,                        
              MIR3_VK_CTRL_W,                        
              MIR3_VK_CTRL_Y,
              MIR3_VK_CTRL_Z,
              MIR3_VK_CTRL_BRACE_C,                  // ]
              MIR3_VK_CTRL_SLASH,                    // \
              MIR3_VK_CTRL_BRACE_O: {Do Nothing} ;   // [
            else {case}
              if not(Char(wParam) in FGUI_Definition.gui_Edit_Using_ASCII) then
              begin
                Result := True;
                exit;
              end;
              // If there's a selection and the user
              // starts to type, the selection should be deleted.
              if (FCaretPos <> FSelectStartPos) then
                DeleteSelectionText;

              // If we are in overwrite mode and there is already
              // a char at the caret's position, simply replace it.
              // Otherwise, we insert the char as normal.
              if not FInsertMode and (FCaretPos < FStringBuffer.TextSize) then
              begin
                FStringBuffer[FCaretPos] := WideChar(wParam);
                PlaceCaret(FCaretPos + 1);
                FSelectStartPos := FCaretPos;
              end else begin
                // Insert the char
                if FStringBuffer.TextSize < FStringBuffer.MaxLength then
                begin
                  if FStringBuffer.InsertChar(FCaretPos, WideChar(wParam)) then
                  begin
                    PlaceCaret(FCaretPos + 1);
                    FSelectStartPos := FCaretPos;
                  end;
                end;
              end;
              ResetCaretBlink;
              FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
            end;
          Result := True;
          Exit;
          {$ENDREGION}
        end;
      end;

      Result:= False;
    end;

    function TMIR3_GUI_Edit.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      FTempCaredPt : Integer;
      FTempFirstX1 : Integer;
      FOffset      : TRect;
    begin
      Result := True;
      if (not FEnabled or not FVisible) then
      begin
        Result := False;
        Exit;
      end;
      FOffset := FTextRect;
      OffsetRect(FOffset, FParentGUIForm.FLeft , FParentGUIForm.FTop);
      case uMsg of
        WM_LBUTTONDOWN   ,
        WM_LBUTTONDBLCLK : begin
          {$REGION ' - Mouse Handling BUTTON DOWN / DBClick '}
          if (not FFocus) then
          begin
            FParentGUIContainer.RequestFocus(@Self);
          end;

          if not ContainsPoint(AMousePoint) then
          begin
            Result := False;
            Exit;
          end;

          FMouseDrag   := True;
          FTempFirstX1 := 0;
          FTempCaredPt := 0;
          SetCapture(GRenderEngine.GetGameHWND);
          // Determine the character corresponding to the coordinates.
          GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, FFirstVisibleChar, FTempFirstX1);
          GGameEngine.FontManager.GetFirstPositionOfChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, AMousePoint.x - FOffset.left + FTempFirstX1, FTempCaredPt, True);
          PlaceCaret(FTempCaredPt);
          FSelectStartPos := FCaretPos;
          ResetCaretBlink;
          Exit;
          {$ENDREGION}
        end;
        WM_LBUTTONUP     : begin
          {$REGION ' - Mouse Handling BUTTON UP '}
          ReleaseCapture;
          FMouseDrag := False;
          {$ENDREGION}
        end;
        WM_MOUSEMOVE     : begin
          {$REGION ' - Mouse Handling Move '}
          if (FMouseDrag) then
          begin
            // Determine the character corresponding to the coordinates.
            FTempFirstX1 := 0;
            FTempCaredPt := 0;
            GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, FFirstVisibleChar, FTempFirstX1);
            GGameEngine.FontManager.GetFirstPositionOfChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, AMousePoint.x - FOffset.left + FTempFirstX1, FTempCaredPt);
            PlaceCaret(FTempCaredPt);
          end;
          {$ENDREGION}
        end;
      end;

      Result:= false;
    end;

    function TMIR3_GUI_Edit.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      bHandled: Boolean;
    begin
      Result := False;
      if (not FEnabled or not FVisible) then Exit;

      bHandled := False;

      case uMsg of
        WM_KEYDOWN  : begin
          case wParam of
            VK_TAB    : begin
             // Invoke the callback when the user presses Tab.
             FParentGUIContainer.SendEvent(EVENT_EDITBOX_RETURN, True, @Self);
            end;
            VK_HOME   : begin
              PlaceCaret(0);
              if (GetKeyState(VK_SHIFT) >= 0) then
              begin
                // Shift is not down. Update selection
                // start along with the caret.
                FSelectStartPos := FCaretPos;
              end;
              ResetCaretBlink;
              bHandled := True;
            end;
            VK_END    : begin
              PlaceCaret(Length(Text));
              if (GetKeyState(VK_SHIFT) >= 0) then
                  // Shift is not down. Update selection
                  // start along with the caret.
                  FSelectStartPos := FCaretPos;
              ResetCaretBlink;
              bHandled := True;
            end;
            VK_INSERT : begin
              if (GetKeyState(VK_CONTROL) < 0) then
              begin // Control Insert. Copy to clipboard
                CopyToClipboard;
              end else if (GetKeyState(VK_SHIFT) < 0) then
                       begin // Shift Insert. Paste from clipboard
                         PasteFromClipboard;
                       end else begin // Toggle caret insert mode
                                  FInsertMode := not FInsertMode;
                                end;
            end;
            VK_DELETE : begin
              // Check if there is a text selection.
              if (FCaretPos <> FSelectStartPos) then
              begin
                DeleteSelectionText;
                FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
              end else begin // Deleting one character
                if (FStringBuffer.RemoveChar(FCaretPos)) then
                  FParentGUIContainer.SendEvent(EVENT_EDITBOX_CHANGE, True, @Self);
              end;
              ResetCaretBlink;
              bHandled := True;
            end;
            VK_LEFT   : begin
              if (GetKeyState(VK_CONTROL) < 0) then
              begin
                // Control is down. Move the caret to a new item
                // instead of a character.
                // FStringBuffer.GetPriorItemPos(FCaretPos, FCaretPos);  <-- Create this function later (it only move word by word)
                PlaceCaret(FCaretPos);
              end else if (FCaretPos > 0) then 
                         PlaceCaret( FCaretPos - 1);
              if (GetKeyState(VK_SHIFT) >= 0) then
                // Shift is not down. Update selection
                // start along with the caret.
                FSelectStartPos := FCaretPos;
              ResetCaretBlink;
              bHandled := True;
            end;
            VK_RIGHT  : begin
              if (GetKeyState(VK_CONTROL) < 0) then
              begin
                // Control is down. Move the caret to a new item
                // instead of a character.
                //FStringBuffer.GetNextItemPos(FCaretPos, FCaretPos);   <-- Create this function later (it only move word by word)
                PlaceCaret(FCaretPos);
              end else if (FCaretPos < FStringBuffer.TextSize) then
                         PlaceCaret(FCaretPos + 1);
               // Shift is not down. Update selection
              // start along with the caret.
              if (GetKeyState( VK_SHIFT ) >= 0) then
                FSelectStartPos := FCaretPos;
              ResetCaretBlink;
              bHandled := True;
            end;
            VK_UP       ,
            VK_DOWN     : begin
            // Trap up and down arrows so that the dialog
            // does not switch focus to another control.
            bHandled := true;
          end;
          else bHandled := wParam <> VK_ESCAPE;  // Let the application handle Esc.
        end;
       end;
     end;
     Result := bHandled;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Edit :: class getter and setter  '}
    procedure TMIR3_GUI_Edit.SetText(AText: PWideChar);
    begin
      Assert(AText <> nil);
      FStringBuffer.SetText(AText);
      FFirstVisibleChar := 0;
      PlaceCaret(FStringBuffer.TextSize);
      FSelectStartPos := IfThen(False, 0, FCaretPos);
    end;

    function TMIR3_GUI_Edit.GetText: PWideChar;
    begin
      Result := FStringBuffer.Buffer;
    end;

    procedure TMIR3_GUI_Edit.SetMaxLength(AValue: Integer);
    begin
      if (FStringBuffer.MaxLength <> AValue) and
         (AValue <> 0) then
        FStringBuffer.MaxLength := AValue;
    end;

    function TMIR3_GUI_Edit.GetMaxLength: Integer;
    begin
      Result := FStringBuffer.MaxLength;
    end;

  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Edit :: functions   '}
    procedure TMIR3_GUI_Edit.SetFocus;
    begin
      if (not FFocus) then
      begin
        FParentGUIContainer.RequestFocus(@Self);
      end;
    end;

    procedure TMIR3_GUI_Edit.OnFocusIn;
    begin
      inherited;
      ResetCaretBlink;
    end;

    procedure TMIR3_GUI_Edit.ResetCaretBlink;
    begin
      FCaretOn        := True;
      FLastBlinkCaret := DX9GetGlobalTimer.GetAbsoluteTime;
    end;

    procedure TMIR3_GUI_Edit.CopyToClipboard;
    var
      FHBlock : HGLOBAL;
      FWText  : PWideChar;
      FFirst  : Integer;
      FLast   : Integer;
    begin
      if FGUI_Definition.gui_Password_Char <> '' then Exit;
      if (FCaretPos <> FSelectStartPos) and OpenClipboard(0) then
      begin
        EmptyClipboard;
    
        FHBlock := GlobalAlloc(GMEM_MOVEABLE, SizeOf(WideChar) * (FStringBuffer.TextSize + 1));
        if (FHBlock <> 0) then
        begin
          FWText := GlobalLock(FHBlock);
          if (FWText <> nil) then
          begin
            FFirst := Min(FCaretPos, FSelectStartPos);
            FLast := Max(FCaretPos, FSelectStartPos);
            if (FLast - FFirst > 0) then
              CopyMemory(FWText, FStringBuffer.Buffer + FFirst, (FLast - FFirst) * SizeOf(WideChar));
            FWText[FLast - FFirst] := #0;  // Terminate it
            GlobalUnlock(FHBlock);
          end;
          SetClipboardData(CF_UNICODETEXT, FHBlock);
        end;
        CloseClipboard;
        if (FHBlock <> 0) then 
          GlobalFree(FHBlock);
      end;
    end;

    procedure TMIR3_GUI_Edit.PasteFromClipboard;
    var
      FHandle: THandle;
      FWText: PWideChar;
    begin
      DeleteSelectionText;

      if FGUI_Definition.gui_Password_Char <> '' then Exit;
    
      if OpenClipboard(0) then
      begin
        FHandle := GetClipboardData(CF_UNICODETEXT);
        if (FHandle <> 0) then
        begin
          FWText := GlobalLock(FHandle);
          if (FWText <> nil) then
          begin
            if FStringBuffer.InsertString(FCaretPos, FWText) then
              PlaceCaret(FCaretPos + lstrlenW(FWText));
            FSelectStartPos := FCaretPos;
            GlobalUnlock(FHandle);
          end;
        end;
        CloseClipboard;
      end;
    end;

    procedure TMIR3_GUI_Edit.DeleteSelectionText;
    var
      FFirst : Integer;
      FLast  : Integer;
      I      : Integer;
    begin
      FFirst := Min(FCaretPos, FSelectStartPos);
      FLast  := Max(FCaretPos, FSelectStartPos);
      PlaceCaret(FFirst);
      FSelectStartPos := FCaretPos;
      for i := FFirst to FLast - 1 do
        FStringBuffer.RemoveChar(FFirst);
    end;

    procedure TMIR3_GUI_Edit.ClearText;
    begin
      FStringBuffer.Clear;
      FFirstVisibleChar := 0;
      PlaceCaret(0);
      FSelectStartPos   := 0;
    end;
    
    procedure TMIR3_GUI_Edit.PlaceCaret(ACaretPlace: Integer);
    var
      nX1st, nX, nX2: Integer;
      nXNewLeft: Integer;
      nCPNew1st: Integer;
      nXNew1st: Integer;
      
      function RectWidth(const prc: TRect): Integer; inline;
      begin
        Result:= prc.right - prc.left;
      end;

    begin
      FCaretPos := ACaretPlace;

      GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, FFirstVisibleChar, nX1st); // 1st visible char
      GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, ACaretPlace, nX); // LEAD

      if (ACaretPlace = FStringBuffer.TextSize) then
        nX2 := nX
      else GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, ACaretPlace, nX2); // TRAIL

      if (nX < nX1st) then
      begin
        FFirstVisibleChar := ACaretPlace;
      end else if (nX2 > nX1st + RectWidth(FGUI_Definition.gui_WorkField)) then
               begin
                 nCPNew1st := 0;
                 nXNewLeft := nX2 - RectWidth(FGUI_Definition.gui_WorkField);

                 GGameEngine.FontManager.GetFirstPositionOfChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, nXNewLeft, nCPNew1st);
                 GGameEngine.FontManager.GetFirstVisibleChar(FGUI_Definition.gui_Font.gui_Font_Use_ID, Text, nCPNew1st, nXNew1st);
                 if (nXNew1st < nXNewLeft) then Inc(nCPNew1st);

                 FFirstVisibleChar := nCPNew1st;
               end;
    end;

  {$ENDREGION}

 /// TMIR3_GUI_Grid

  {$REGION ' - TMIR3_GUI_Grid :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Grid Form control constructor
    //..............................................................................    
    constructor TMIR3_GUI_Grid.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctGrid;
    end;
  {$ENDREGION} 
 
  {$REGION ' - TMIR3_GUI_Grid :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Grid override render function for this control
    //..............................................................................  
    procedure TMIR3_GUI_Grid.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    begin
    // @override
	    (* Render Grid *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Grid without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
		    (* Render Grid with given Texture *)
        with FGUI_Definition, gui_Control_Texture, GGameEngine.FGameFileManger do
        begin
          if gui_Texture_File_ID > 74 then
          begin
            if gui_Use_Strech_Texture then
            begin
              DrawTextureStretch(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
            end else begin
              DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
            end;
          end;
        end;
	    end;
    end;
  {$ENDREGION}
 
  /// TMIR3_GUI_Button

  {$REGION ' - TMIR3_GUI_Button :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Button Form control constructor
    //..............................................................................   
    constructor TMIR3_GUI_Button.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctButton;
      FButtonState        := bsBase;

      with FGUI_Definition, gui_Btn_Font_Color do
      begin
        if gui_ColorSelect <> 0 then
          ColorSelect := gui_ColorSelect
        else ColorSelect := D3DCOLOR_ARGB($FF,$f1,$d4,$7b);
        if gui_ColorPress <> 0 then
          ColorPress := gui_ColorPress
        else ColorPress := D3DCOLOR_ARGB($FF,$d2,$90,$5b);
        if gui_ColorDisabled <> 0 then
          ColorDisabled := gui_ColorDisabled
        else ColorDisabled := D3DCOLOR_ARGB($FF,$09,$09,$09);
        SwitchOn := gui_PreSelected;
      end;
    end;
  {$ENDREGION} 

  {$REGION ' - TMIR3_GUI_Button :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Button override render function for this control
    //..............................................................................  
    procedure TMIR3_GUI_Button.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FTempTextureID : Integer;
      FDrawSetting   : TDrawSetting;
      FRenderColor   : TD3DColor;
    begin
    // @override
	    (* Render Button *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Button without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
        with FGUI_Definition, gui_Caption_Extra ,gui_Control_Texture, gui_Font, GGameEngine.FGameFileManger do
        begin
          if FMouseOver and (FButtonState = bsBase) then
          begin
            FButtonState := bsMouseOver;
            FParentGUIForm.FGUIMouseOver := Self;
          end else if not FMouseOver and (FButtonState = bsMouseOver) then
                   begin
                     FButtonState := bsBase;
                   end;

          if not FEnabled then
          begin
            FButtonState := bsDisabled;
          end;

          if FSelected then
          begin
            FButtonState := bsSelected;
          end else if FButtonState = bsSelected then
                     FButtonState := bsBase;

          case FButtonState of
            bsBase      : begin
              FRenderColor   := gui_Font_Color;
              if not(FSwitchOn) then
              begin
                FTempTextureID := gui_Background_Texture_ID;
              end else begin
                FTempTextureID := gui_Extra_Texture_Set.gui_Background_Texture_ID;
              end;
            end;
            bsMouseOver : begin
              if not(FSwitchOn) then
              begin
                FTempTextureID := gui_Mouse_Over_Texture_ID;
              end else begin
                FTempTextureID := gui_Extra_Texture_Set.gui_Mouse_Over_Texture_ID;
              end;
              if gui_Enabled then
                FRenderColor := ColorSelect;
            end;
            bsPress     : begin
              if not(FSwitchOn) then
              begin
                FTempTextureID := gui_Mouse_Down_Texture_ID;
              end else begin
                FTempTextureID := gui_Extra_Texture_Set.gui_Mouse_Down_Texture_ID;
              end;
              if gui_Enabled then
                FRenderColor := ColorPress;
            end;
            bsDisabled  : begin
              if not(FSwitchOn) then
              begin
                FTempTextureID := gui_Mouse_Disable_Texture_ID;
              end else begin
                FTempTextureID := gui_Extra_Texture_Set.gui_Mouse_Disable_Texture_ID;
              end;
              if gui_Enabled then
                FRenderColor := ColorDisabled;
            end;
            bsSelected  : begin
              if not(FSwitchOn) then
              begin
                FTempTextureID := gui_Mouse_Select_Texture_ID;
              end else begin
                FTempTextureID := gui_Extra_Texture_Set.gui_Mouse_Select_Texture_ID;
              end;
              if gui_Enabled then
                FRenderColor := ColorSelect;
            end;
          end;

          if FTempTextureID > 0 then //gui_Texture_File_ID > 75 then
          begin
		        (* Render Button with given Texture *)
            if gui_Use_Strech_Texture then
            begin
              DrawTextureStretch(FTempTextureID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, gui_Strech_Rate_X, gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
            end else begin
              DrawTexture(FTempTextureID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, BLEND_DEFAULT, gui_Blend_Size);
            end;
          end;
          
          if (FCaption <> '') or (gui_CaptionID <> 0) then
          begin
           (* Render Button with given Texture *)
            with FDrawSetting do
            begin
              dsControlWidth  := FWidth;
              dsControlHeigth := FHeight;
              dsAX            := FParentGUIForm.FLeft + FLeft + 1;
              dsAY            := FParentGUIForm.FTop  + FTop  + 2 + gui_Caption_Offset;
              dsFontHeight    := gui_Font_Size;
              dsFontSetting   := gui_Font_Setting;
              dsFontType      := 0;
              dsFontSpacing   := 0;              
              dsUseKerning    := gui_Font_Use_Kerning;
              dsColor         := FRenderColor;
              dsHAlign        := gui_Font_Text_HAlign;
              dsVAlign        := gui_Font_Text_VAlign;
              dsMagicUse      := False;
            end;
            if gui_CaptionID <> 0 then
              GGameEngine.FontManager.DrawText(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting)
            else GGameEngine.FontManager.DrawText(PWideChar(FCaption), @FDrawSetting);
          end;

          (* Hint Render System *)
          if ((FMouseOver) or (FButtonState = bsPress)) and (gui_HintID <> 0) then
          begin
            with FDrawSetting do
            begin
              dsFontHeight    := 18;
              dsFontSetting   := [];
              dsFontType      := 0;
              dsFontSpacing   := 0;
              dsHAlign        := alLeft;
              dsVAlign        := avTop;
              dsUseKerning    := False;
              dsColor         := $FFF7F767;
              dsMagicUse      := False;
            end;
            FParentGUIContainer.AddHintMessage(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_HintID), FDrawSetting, Self);
          end;
        end;
      end;
	  end;

    function TMIR3_GUI_Button.ContainsPoint(AMousePoint: TPoint): LongBool;
    begin
      if FParentGUIForm = nil then
      begin
        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint);
      end else begin
        Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft ,FParentGUIForm.FTop + FTop,FParentGUIForm.FLeft + FLeft+FWidth,FParentGUIForm.FTop + FTop+FHeight), AMousePoint);
      end;
    end;

    function TMIR3_GUI_Button.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    begin
      Result := True;
      if not FEnabled or not FVisible then
      begin
        Result := False;
        Exit;
      end;

      case uMsg of
        WM_LBUTTONDOWN     : begin
          if ContainsPoint(AMousePoint) then
          begin
            FButtonState := bsPress;
            //SetCapture(GRenderEngine.GetGameHWND);
            if (not FFocus) then
              FParentGUIContainer.RequestFocus(@Self);

            FParentGUIContainer.SendEvent(EVENT_BUTTON_DOWN, True, @Self);
            Exit;
          end;
        end;
        WM_LBUTTONDBLCLK   : begin
          if ContainsPoint(AMousePoint) then
          begin
            FButtonState := bsPress;
            //SetCapture(GRenderEngine.GetGameHWND);
            if (not FFocus) then
              FParentGUIContainer.RequestFocus(@Self);

            FParentGUIContainer.SendEvent(EVENT_BUTTON_DBCLICKED, True, @Self);
            Exit;
          end;
        end;
        WM_LBUTTONUP:
        begin
          FButtonState := bsBase;
         // ReleaseCapture;
          if ContainsPoint(AMousePoint) then
            FParentGUIContainer.SendEvent(EVENT_BUTTON_UP, True, @Self);
          Exit;
        end;
      end;

      Result:= False;
    end;

    function TMIR3_GUI_Button.GetSelected: Boolean;
    begin
      Result := FSelected;
    end;

    procedure TMIR3_GUI_Button.SetSelected(AValue: Boolean);
    begin
      if AValue <> FSelected then
        FSelected := AValue;
    end;
  {$ENDREGION}    

  /// TMIR3_GUI_List_Box

  {$REGION ' - TMIR3_GUI_List_Box :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_List_Box Form control constructor
    //.............................................................................. 
    constructor TMIR3_GUI_List_Box.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctListBox;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_List_Box :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_List_Box override render function for this control
    //..............................................................................  
    procedure TMIR3_GUI_List_Box.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); 
    begin
	// @override
	    (* List Box *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render List Box without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
		    (* Render List Box with given Texture *)
        with FGUI_Definition, gui_Control_Texture, GGameEngine.FGameFileManger do
        begin
          if gui_Texture_File_ID > 74 then
          begin
            if gui_Use_Strech_Texture then
            begin
              DrawTextureStretch(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, 2{BLEND_DEFAULT}, gui_Blend_Size);
            end else begin
              DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, 2{BLEND_DEFAULT}, gui_Blend_Size);
            end;
          end;
        end;
      end;
    end;
  {$ENDREGION}   

  /// TMIR3_GUI_ComboBox
 
  {$REGION ' - TMIR3_GUI_ComboBox :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_ComboBox Form control constructor
    //..............................................................................   
    constructor TMIR3_GUI_ComboBox.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctComboBox;
    end;
  {$ENDREGION}  
  
  {$REGION ' - TMIR3_GUI_ComboBox :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_ComboBox override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_ComboBox.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single); 
    begin
    // @override
    
	end;
  {$ENDREGION}   
  
   /// TMIR3_GUI_CheckBox
 
  {$REGION ' - TMIR3_GUI_CheckBox :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_CheckBox Form control constructor
    //..............................................................................    
    constructor TMIR3_GUI_CheckBox.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctCheckBox;
    end;
  {$ENDREGION}  
 
  {$REGION ' - TMIR3_GUI_CheckBox :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_CheckBox override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_CheckBox.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    begin
	  // @override
    
	  end;
  {$ENDREGION}   
 
   /// TMIR3_GUI_RadioButton

  {$REGION ' - TMIR3_GUI_RadioButton :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_RadioButton Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_RadioButton.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctRadioButton;
    end;
  {$ENDREGION}  

  {$REGION ' - TMIR3_GUI_RadioButton :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_RadioButton override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_RadioButton.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    begin
	  // @override

	end;
  {$ENDREGION}

  /// TMIR3_GUI_SelectChar

  {$REGION ' - TMIR3_GUI_SelectChar :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_SelectChar Form control constructor
    //.............................................................................. 
    constructor TMIR3_GUI_SelectChar.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctSelectChar;
      FStartTime          := GetTickCount;
      FAnimationState     := 0;
      FAnimationCount     := 0;
      FAnimation_State_0  := 0;
      FAnimation_State_2  := 0;
      FAnimation_State_1  := 0;
      FFrameStart         := 0;
      FEffectImageNumber  := 0;
      FShadowImageNumber  := 0;
      FCurrentImageNumber := 0;
      FLastOffsetX        := 0;
      FLastOffsetY        := 0;
      FUseEffect          := False;
      FSelected           := False;
      CharacterSystem     := csSelectChar;
    end;

    function TMIR3_GUI_SelectChar.GetCharacterInfo: TMir3Character;
    begin
      Result := FCharacterInfo;
    end;

    procedure TMIR3_GUI_SelectChar.SetCharacterInfo(AValue : TMir3Character);
    begin
      if (AValue.Char_Found  <> FCharacterInfo.Char_Found)  or
         (AValue.Char_Name   <> FCharacterInfo.Char_Name)   or
         (AValue.Char_Job    <> FCharacterInfo.Char_Job)    or
         (AValue.Char_Gold   <> FCharacterInfo.Char_Gold)   or
         (AValue.Char_Level  <> FCharacterInfo.Char_Level)  or
         (AValue.Char_Gender <> FCharacterInfo.Char_Gender) then
      begin
        FCharacterInfo := AValue;
      end;
    end;

    function TMIR3_GUI_SelectChar.ContainsPoint(AMousePoint: TPoint): LongBool;
    begin
      if FParentGUIForm = nil then
      begin
        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint);
      end else begin
        Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft + FLastOffsetX, FParentGUIForm.FTop + FTop + FLastOffsetY, FParentGUIForm.FLeft + FLeft+FWidth+ FLastOffsetX, FParentGUIForm.FTop + FTop+FHeight + FLastOffsetY), AMousePoint);
      end;
    end;

  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_SelectChar :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_SelectChar override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_SelectChar.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FBaseX       : Integer;
      FBaseY       : Integer;
      //FBlendState  : Integer;
      FCharImage   : PImageHeaderD3D;
      FShadowImage : PImageHeaderD3D;
      FEffectImage : PImageHeaderD3D;
    begin
    // @override
      try
	      (* Select Char Panel *)
        if FParentGUIContainer.FDebugMode then
        begin
		      (* Render Select Char Panel without Texture in Debug Mode *)
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FF0000FF, True);
        end else begin
        //if FGUI_Definition.gui_ShowBorder then
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, FGUI_Definition.gui_Color.gui_BorderColor, False);

          case CharacterSystem of
            csSelectChar : begin
              {$REGION ' - Select Char Render System  '}
              case FCharacterInfo.Char_Job of
                C_WARRIOR  : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FFrameStart         := 199;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 12;
                               end;
                               C_FEMALE : begin
                                 FFrameStart         := 399;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 12;
                               end;
                             end;
                C_WIZZARD  : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FFrameStart         := 699;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 9;
                               end;
                               C_FEMALE : begin
                                 FFrameStart         := 899;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 14;
                               end;
                             end;
                C_TAOIST   : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FFrameStart         := 1199;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 14;
                               end;
                               C_FEMALE : begin
                                 FFrameStart         := 1399;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 9;
                               end;
                             end;
                C_ASSASSIN : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FFrameStart         := 1699;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 15;
                               end;
                               C_FEMALE : begin
                                 FFrameStart         := 1899;
                                 FAnimation_State_0  := 1;
                                 FAnimation_State_1  := 9;
                               end;
                             end;
              end;
              
              if FCurrentImageNumber = 0 then
              begin
                FCurrentImageNumber := FFrameStart;
                FShadowImageNumber  := FFrameStart + 20;
              end;

              if FSelected and (FAnimationState = 0) then
                FAnimationState := 1;

              if (GetTickCount - FStartTime > 130) then
              begin
                case FAnimationState of
                  0: begin
                    FAnimationCount     := FAnimation_State_0;
                    FCurrentImageNumber := FFrameStart + FAnimationCount;
                    FShadowImageNumber  := FCurrentImageNumber + 20;
                  end;
                  1: begin
                    if (FAnimationCount < FAnimation_State_1) then
                    begin
                      Inc(FAnimationCount);
                      FStartTime := GetTickCount;
                    end else begin
                      FAnimationCount := 0;
                    end;
                    FCurrentImageNumber := FFrameStart + FAnimationCount;
                    FShadowImageNumber  := FCurrentImageNumber + 20;
                  end;
                end;
              end;
              
              // Test ohne Offsets um zu sehen woran es liegen k�nnte
              with FGUI_Definition, gui_Control_Texture, GGameEngine.FGameFileManger do
              begin
		          (* Render Select Char Panel with given Texture *)
                if gui_Texture_File_ID > 74 then
                begin
                  if FSelected then
                  begin
                    if gui_Use_Strech_Texture then
                    begin
                      FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                      if Assigned(FShadowImage) then
                        DrawTextureStretch(FShadowImage.ihD3DTexture, (FLeft + FShadowImage.ihOffset_X)+9, (FTop + FShadowImage.ihOffset_Y)-45, gui_Strech_Rate_X,  gui_Strech_Rate_Y, BLEND_DEFAULT, 150);
                        //DrawTextureStretch(FShadowImage.ihD3DTexture, (FLeft + FShadowImage.ihOffset_X), (FTop + FShadowImage.ihOffset_Y), gui_Strech_Rate_X,  gui_Strech_Rate_Y, BLEND_DEFAULT, 150);

                      FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                      if Assigned(FCharImage) then
                      begin
                        FLastOffsetX := FCharImage.ihOffset_X;
                        FLastOffsetY := FCharImage.ihOffset_Y;
                        //GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft+ FLastOffsetX , FParentGUIForm.FTop + FTop + FLastOffsetY, FWidth, FHeight, FGUI_Definition.gui_Color.gui_BorderColor, False);
                        DrawTextureStretch(FCharImage.ihD3DTexture  , (FLeft + FCharImage.ihOffset_X  ), (FTop + FCharImage.ihOffset_Y), gui_Strech_Rate_X,  gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
                      end;
                    end else begin
                      FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                      if Assigned(FShadowImage) then
                        DrawTexture(FShadowImage.ihD3DTexture, (FLeft + FShadowImage.ihOffset_X), (FTop + FShadowImage.ihOffset_Y), BLEND_DEFAULT, 150);

                      FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                      if Assigned(FCharImage) then
                      begin
                        FLastOffsetX := FCharImage.ihOffset_X;
                        FLastOffsetY := FCharImage.ihOffset_Y;
                        //GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft+ FLastOffsetX , FParentGUIForm.FTop + FTop + FLastOffsetY, FWidth, FHeight, $FFFF0000, False);
                        DrawTexture(FCharImage.ihD3DTexture  , (FLeft + FCharImage.ihOffset_X  ), (FTop + FCharImage.ihOffset_Y), BLEND_DEFAULT, gui_Blend_Size);
                      end;
                    end;
                  end else begin
                    if gui_Use_Strech_Texture then
                    begin
                      FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                      if Assigned(FShadowImage) then
                        DrawTextureStretch(FShadowImage.ihD3DTexture, (FLeft + FShadowImage.ihOffset_X)+9, (FTop + FShadowImage.ihOffset_Y)-45, gui_Strech_Rate_X,  gui_Strech_Rate_Y, BLEND_DEFAULT, 150);

                      FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                      if Assigned(FCharImage) then
                      begin
                        FLastOffsetX := FCharImage.ihOffset_X;
                        FLastOffsetY := FCharImage.ihOffset_Y;
                        DrawTextureGrayScaleStretch(FCharImage.ihD3DTexture  , (FLeft + FCharImage.ihOffset_X), (FTop + FCharImage.ihOffset_Y), gui_Strech_Rate_X,  gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
                      end;
                    end else begin
                      FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                      if Assigned(FShadowImage) then
                        DrawTexture(FShadowImage.ihD3DTexture, (FLeft + FShadowImage.ihOffset_X), (FTop + FShadowImage.ihOffset_Y), BLEND_DEFAULT, 150);

                      FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                      if Assigned(FCharImage) then
                      begin
                        FLastOffsetX := FCharImage.ihOffset_X;
                        FLastOffsetY := FCharImage.ihOffset_Y;                      
                        DrawTextureGrayScale(FCharImage.ihD3DTexture  , (FLeft + FCharImage.ihOffset_X), (FTop + FCharImage.ihOffset_Y), BLEND_DEFAULT, gui_Blend_Size);
                      end;
                    end;
                  end;
                end;
              end;
              {$ENDREGION}
	          end;
            csCreateChar : begin
              {$REGION ' - Create Char Render System  '}
              case FCharacterInfo.Char_Job of
                C_WARRIOR  : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 239;
                                 FAnimation_State_0  := 21;
                                 FUseEffect          := False;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('JMCre.wav');
                               end;
                               C_FEMALE : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;                               
                                 FFrameStart         := 439;
                                 FAnimation_State_0  := 27;
                                 FUseEffect          := False;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('JWCre.wav');
                               end;
                             end;
                C_WIZZARD  : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 739;
                                 FAnimation_State_0  := 19;
                                 FUseEffect          := True;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('SMCre.wav');
                               end;
                               C_FEMALE : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 939;
                                 FAnimation_State_0  := 25;
                                 FUseEffect          := True;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('SWCre.wav');
                               end;
                             end;
                C_TAOIST   : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 1239;
                                 FAnimation_State_0  := 26;
                                 FUseEffect          := False;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('DMCre.wav');
                               end;
                               C_FEMALE : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 1439;
                                 FAnimation_State_0  := 19;
                                 FUseEffect          := True;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('DWCre.wav');
                               end;
                             end;
                C_ASSASSIN : case FCharacterInfo.Char_Gender of
                               C_MALE   : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 1739;
                                 FAnimation_State_0  := 24;
                                 FUseEffect          := True;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('AMCre.wav');
                               end;
                               C_FEMALE : begin
                                 FBaseX              := 0;
                                 FBaseY              := 0;
                                 FFrameStart         := 1939;
                                 FAnimation_State_0  := 19;
                                 if (FCurrentImageNumber = FFrameStart) then
                                   GGameEngine.SoundManager.PlaySound('AWCre.wav');
                               end;
                             end;
              end;

              (* Save Start *)
              if FCurrentImageNumber = 0 then
              begin
                FCurrentImageNumber := FFrameStart;
                FEffectImageNumber  := FCurrentImageNumber + 100;
                FShadowImageNumber  := FCurrentImageNumber + 30;
              end;
              if (GetTickCount - FStartTime > 165) then
              begin
                case FSelected of
                  True  : begin
                    if (FAnimationCount < FAnimation_State_0) then
                    begin
                      Inc(FAnimationCount);
                      FStartTime := GetTickCount;
                    end else begin
                      FAnimationCount := 0;
                    end;
                    FCurrentImageNumber := FFrameStart + FAnimationCount;
                    FEffectImageNumber  := FCurrentImageNumber + 100;
                    FShadowImageNumber  := FCurrentImageNumber + 30;
                  end;
                  False : begin
                    FUseEffect          := False;
                    FCurrentImageNumber := FFrameStart;
                    FShadowImageNumber  := FCurrentImageNumber + 30;
                  end;
                end;
              end;

		          (* Render Create Char Panel with given Texture *)
              with FGUI_Definition, gui_Control_Texture, GGameEngine.FGameFileManger do
              begin
                if gui_Texture_File_ID > 74 then
                begin
                  if FSelected then
                  begin
                    FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                    FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                    DrawTexture(FShadowImage.ihD3DTexture, (FParentGUIForm.FLeft + FLeft + FBaseX + FShadowImage.ihOffset_X), (FParentGUIForm.FTop + FTop + FBaseY + FShadowImage.ihOffset_Y), Blend_DestBright, gui_Blend_Size);
                    DrawTexture(FCharImage.ihD3DTexture  , (FParentGUIForm.FLeft + FLeft + FBaseX + FCharImage.ihOffset_X  ), (FParentGUIForm.FTop + FTop + FBaseY + FCharImage.ihOffset_Y  ), BLEND_DEFAULT, gui_Blend_Size);
                    if FUseEffect then
                    begin
                      FEffectImage := GetImageD3DDirect(FEffectImageNumber, gui_Texture_File_ID);
                      if Assigned(FEffectImage) and Assigned(FEffectImage.ihD3DTexture) then
                        DrawTexture(FEffectImage.ihD3DTexture  , (FParentGUIForm.FLeft + FLeft + FBaseX + FEffectImage.ihOffset_X  ), (FParentGUIForm.FTop + FTop + FBaseY + FEffectImage.ihOffset_Y  ), Blend_ADD, gui_Blend_Size);
                    end;
                  end else begin
                    FCharImage   := GetImageD3DDirect(FCurrentImageNumber, gui_Texture_File_ID);
                    FShadowImage := GetImageD3DDirect(FShadowImageNumber , gui_Texture_File_ID);
                    DrawTexture(FShadowImage.ihD3DTexture, (FParentGUIForm.FLeft + FLeft + FBaseX + FShadowImage.ihOffset_X), (FParentGUIForm.FTop + FTop + FBaseY + FShadowImage.ihOffset_Y), Blend_DestBright, gui_Blend_Size);
                    DrawColor(FCharImage.ihD3DTexture, (FParentGUIForm.FLeft + FLeft + FBaseX + FCharImage.ihOffset_X  ), (FParentGUIForm.FTop + FTop + FBaseY + FCharImage.ihOffset_Y  ), $F0303030);
                  end;
                end;
              end;
              {$ENDREGION}
            end;
          end;
        end;
      except
        GRenderEngine.System_Log('ERROR::TMIR3_GUI_SelectChar::Render CI:'+IntToStr(FCurrentImageNumber) + ' - SI:'+IntToStr(FShadowImageNumber)+ ' - AC:'+IntToStr(FAnimationCount)+ ' - EI:'+IntToStr(FEffectImageNumber)+ ' - EB:'+BoolToStr(FUseEffect));
      end;
	  end;

    procedure TMIR3_GUI_SelectChar.ResetSelection(ASelected: Boolean);
    begin
      if ASelected then
      begin
        FStartTime          := GetTickCount;
        FAnimationState     := 0;
        FAnimationCount     := 0;
        FAnimation_State_0  := 0;
        FAnimation_State_2  := 0;
        FAnimation_State_1  := 0;
        FFrameStart         := 0;
        FEffectImageNumber  := 0;
        FShadowImageNumber  := 0;
        FCurrentImageNumber := 0;
        FUseEffect          := False;
        FSelected           := True;
      end else begin
        FStartTime          := GetTickCount;
        FAnimationState     := 0;
        FAnimationCount     := 0;
        FAnimation_State_0  := 0;
        FAnimation_State_2  := 0;
        FAnimation_State_1  := 0;
        FFrameStart         := 0;
        FEffectImageNumber  := 0;
        FShadowImageNumber  := 0;
        FCurrentImageNumber := 0;
        FUseEffect          := False;
        FSelected           := False;
      end;
    end;

  {$ENDREGION}

   /// TMIR3_GUI_TextButton

  {$REGION ' - TMIR3_GUI_TextButton :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_TextButton Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_TextButton.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctTextButton;
      with FDrawOptionSet do
      begin
        dsDrawSetting.dsOptimizeSet     := False;
        dsDrawSettingHint.dsOptimizeSet := False;
      end;

      with FGUI_Definition.gui_Btn_Font_Color do
      begin
        if gui_ColorSelect <> 0 then
          ColorSelect := gui_ColorSelect
        else ColorSelect := D3DCOLOR_ARGB($FF,$FF,$D7,$0A);
        if gui_ColorPress <> 0 then
          ColorPress := gui_ColorPress
        else ColorPress := D3DCOLOR_ARGB($FF,$DF,$FF,$00);
        if gui_ColorDisabled <> 0 then
          ColorDisabled := gui_ColorDisabled
        else ColorDisabled := D3DCOLOR_ARGB($FF,$09,$09,$09);
      end;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_TextButton :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_TextButton override render function for this control
    //..............................................................................  
    procedure TMIR3_GUI_TextButton.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FScriptWidth : Single;
      FScriptText  : WideString;
      FRenderColor : TD3DColor;
    begin
    // @override
      (* Render Button *)
      if FParentGUIContainer.FDebugMode then
      begin
        (* Render Button without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin

        with FGUI_Definition, gui_Control_Texture, gui_Font, GGameEngine.FGameFileManger do
        begin
          FRenderColor := gui_Font_Color;
          if FMouseOver and (FButtonState = bsBase) then
          begin
            FButtonState := bsMouseOver;
          end else if not FMouseOver and (FButtonState = bsMouseOver) then
                   begin
                     FButtonState := bsBase;
                   end;

          if not FEnabled then
          begin
            FButtonState := bsDisabled;
          end;

          if FSelected then
          begin
            FButtonState := bsSelected;
          end else if FButtonState = bsSelected then
                     FButtonState := bsBase;

          case FButtonState of
            bsBase      : begin
              FRenderColor := gui_Font_Color;
              FScriptText  := gui_Font_Script_MouseNormal;
            end;
            bsMouseOver : begin
              if gui_Enabled then
              begin
                FRenderColor := ColorSelect;
                FScriptText  := gui_Font_Script_MouseOver;
              end;
            end;
            bsPress     : begin
              if gui_Enabled then
              begin
                FRenderColor := ColorPress;
                FScriptText  := gui_Font_Script_MouseDown;
              end;
            end;
            bsDisabled  : begin
              if gui_Enabled then
                FRenderColor := ColorDisabled;
            end;
            bsSelected  : begin
              if gui_Enabled then
                FRenderColor := ColorSelect;
            end;
          end;

         (* Render Button with given Texture *)


          with FDrawOptionSet.dsDrawSetting do
          begin
            if not dsOptimizeSet then
            begin
              dsControlWidth  := FWidth;
              dsControlHeigth := FHeight;
              dsAX            := FParentGUIForm.FLeft + FLeft + 1;
              dsAY            := FParentGUIForm.FTop  + FTop  + 2;
              dsFontHeight    := gui_Font_Size;
              dsFontSetting   := gui_Font_Setting;
              dsFontType      := gui_Font_Use_ID;
              dsFontSpacing   := 0;
              dsUseKerning    := gui_Font_Use_Kerning;
              dsColor         := FRenderColor;
              dsHAlign        := gui_Font_Text_HAlign;
              dsVAlign        := gui_Font_Text_VAlign;
              dsMagicUse      := False;
              dsOptimizeSet   := True;
              // Get Line width and auto adjust Control width (Special hack for Multilanguage use)
              FScriptWidth := GGameEngine.FontManager.GetScriptedTextWidth(0,PWideChar(FScriptText+GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawOptionSet.dsDrawSetting);
              if FWidth < FScriptWidth then
                 FWidth := Round(FScriptWidth);
            end;
          end;
          GGameEngine.FontManager.DrawTextColor(PWideChar(FScriptText+GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawOptionSet.dsDrawSetting);

          (* Render Hint *)
          if ((FButtonState = bsMouseOver) or (FButtonState = bsPress)) and (gui_HintID <> 0) then
          begin
            with FDrawOptionSet.dsDrawSettingHint do
            begin
              if not dsOptimizeSet then
              begin
                dsFontHeight    := 18;
                dsFontSetting   := [];
                dsFontType      := 0;
                dsFontSpacing   := 0;
                dsHAlign        := alLeft;
                dsVAlign        := avTop;
                dsUseKerning    := False;
                dsColor         := $FFF7F767;
                dsMagicUse      := False;
                dsOptimizeSet   := True;
              end;
            end;
            FParentGUIContainer.AddHintMessage(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_HintID), FDrawOptionSet.dsDrawSettingHint, Self);
          end;
        end;
      end;
    end;
  {$ENDREGION}

 /// TMIR3_GUI_TextLabel

  {$REGION ' - TMIR3_GUI_TextLabel :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_TextLabel Form control constructor
    //..............................................................................
    constructor TMIR3_GUI_TextLabel.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctTextLabel;
      FCaption            := '';
    end;
  {$ENDREGION}
  
  {$REGION ' - TMIR3_GUI_TextLabel :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_TextLabel override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_TextLabel.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FScriptText  : WideString;
      FDrawSetting : TDrawSetting;
    begin
	  // @override
	    (* Render TextLabel *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render TextLabel without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
		    (* Render TextLabel with given Texture *)
        with FGUI_Definition, gui_Font, GGameEngine.FGameFileManger do
        begin
          if (Trim(FCaption) <> '') or (gui_CaptionID > 0) then
          begin
            if gui_CaptionID > 0 then
            begin
              with FDrawSetting do
              begin
                dsControlWidth  := FWidth;
                dsControlHeigth := FHeight;
                dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                dsAY            := FParentGUIForm.FTop  + FTop  + 1;
                dsFontHeight    := gui_Font_Size;
                dsFontSetting   := gui_Font_Setting;
                dsFontType      := gui_Font_Use_ID;
                dsFontSpacing   := 0;
                dsUseKerning    := gui_Font_Use_Kerning;
                dsColor         := gui_Font_Color;
                dsHAlign        := gui_Font_Text_HAlign;
                dsVAlign        := gui_Font_Text_VAlign;
                dsMagicUse      := False;
              end;
              FScriptText := gui_Font_Script_MouseNormal;
              //GGameEngine.FontManager.DrawTextColor(PWideChar(FScriptText+GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
              GGameEngine.FontManager.DrawText(PWideChar(FScriptText+GGameEngine.GameLanguage.GetTextFromLangSystem(gui_CaptionID)), @FDrawSetting);
            end else begin
              with FDrawSetting do
              begin
                dsControlWidth  := FWidth;
                dsControlHeigth := FHeight;
                dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                dsAY            := FParentGUIForm.FTop  + FTop  + 1;
                dsFontHeight    := gui_Font_Size;
                dsFontSetting   := gui_Font_Setting;
                dsFontType      := gui_Font_Use_ID;
                dsFontSpacing   := 0;
                dsUseKerning    := gui_Font_Use_Kerning;
                dsColor         := gui_Font_Color;
                dsHAlign        := gui_Font_Text_HAlign;
                dsVAlign        := gui_Font_Text_VAlign;
                dsMagicUse      := False;
              end;
              FScriptText := gui_Font_Script_MouseNormal;
              //GGameEngine.FontManager.DrawTextColor(PWideChar(FScriptText+FCaption), @FDrawSetting);
              GGameEngine.FontManager.DrawText(PWideChar(FScriptText+FCaption), @FDrawSetting);
            end;

            if gui_Use_Extra_Caption then
            begin
              if gui_Caption_Extra.gui_CaptionExtraID > 0 then
              begin
                with FDrawSetting, gui_Caption_Extra do
                begin
                  dsControlWidth  := FWidth;
                  dsControlHeigth := FHeight;
                  dsAX            := FParentGUIForm.FLeft + FLeft + 1;
                  dsAY            := FParentGUIForm.FTop  + FTop  + 1 + gui_Caption_Offset;
                  dsFontHeight    := gui_Extra_Font.gui_Font_Size;
                  dsFontSetting   := gui_Extra_Font.gui_Font_Setting;
                  dsFontType      := gui_Font_Use_ID;
                  dsFontSpacing   := 0;
                  dsUseKerning    := gui_Extra_Font.gui_Font_Use_Kerning;
                  dsColor         := gui_Extra_Font.gui_Font_Color;
                  dsHAlign        := gui_Extra_Font.gui_Font_Text_HAlign;
                  dsVAlign        := gui_Extra_Font.gui_Font_Text_VAlign;
                end;
                GGameEngine.FontManager.DrawTextColor(PWideChar(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_Caption_Extra.gui_CaptionExtraID)), @FDrawSetting);
              end;
            end;

            (* Render Hint *)
            if (FMouseOver) and (gui_HintID <> 0) then
            begin
              with FDrawSetting do
              begin
                dsFontHeight    := 18;
                dsFontSetting   := [];
                dsFontType      := 0;
                dsFontSpacing   := 0;
                dsHAlign        := alLeft;
                dsVAlign        := avTop;
                dsUseKerning    := False;
                dsColor         := $FFF7F767;
                dsMagicUse      := False;
              end;
              FParentGUIContainer.AddHintMessage(GGameEngine.GameLanguage.GetTextFromLangSystem(gui_HintID), FDrawSetting, Self);
            end;
          end;
        end;
      end;
    end;
  {$ENDREGION}


  /// TMIR3_GUI_Slider

  {$REGION ' - TMIR3_GUI_Slider :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Slider Form control constructor
    //..............................................................................
    constructor TMIR3_GUI_Slider.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctSlider;
      if FGUI_Definition.gui_Slider_Setup.gui_Max <> 0 then
      begin
        FMin                := FGUI_Definition.gui_Slider_Setup.gui_Min;
        FMax                := FGUI_Definition.gui_Slider_Setup.gui_Max;
        FValue              := FGUI_Definition.gui_Slider_Setup.gui_Value;
      end else begin
        FMin                := 0;
        FMax                := 100;
        FValue              := 50;
      end;
      FDragOffset           := 0;
      FPressed              := False;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Slider :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Slider override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_Slider.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FSlidRect : TRect;
    begin
	  // @override
	    (* Render Slider *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Slider without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
		    (* Render Slider with given Texture *)
        with FGUI_Definition, gui_Control_Texture, gui_Font, GGameEngine.FGameFileManger do
        begin

          if (gui_Background_Texture_ID > 0) then
          begin
            SetRect(FSlidRect, gui_WorkField.Left, gui_WorkField.Top, FLButton, gui_WorkField.Bottom);
		        (* Render Slider with given Texture *)
            if gui_Use_Strech_Texture then
            begin
              DrawTextureStretch(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
            end else begin
              DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FSlidRect, BLEND_DEFAULT, gui_Blend_Size);
            end;
          end;
          {Render Slider Button}
          if (gui_Slider_Texture_ID > 0)  then
          begin
		        (* Render Button with given Texture *)
            if gui_Use_Strech_Texture then
            begin
              DrawTextureStretch(gui_Slider_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, gui_Strech_Rate_X, gui_Strech_Rate_Y, BLEND_DEFAULT, gui_Blend_Size);
            end else begin
              DrawTextureClipRect(gui_Slider_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + FLButton-5 , FParentGUIForm.FTop + FTop + gui_Slider_Setup.gui_Btn_Size.Top, gui_Slider_Setup.gui_Btn_Size ,BLEND_DEFAULT, gui_Blend_Size);
            end;
          end;

        end;
      end;
      (*
      procedure TFrmDlg.mcOption_FX_VolumeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      begin
        g_SoundVolume := 0 - mcOption_FX_Volume.outidx * 20;
      end;

      procedure TFrmDlg.mcOption_BGM_VolumeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      begin
        g_BGVolume := 100 - mcOption_BGM_Volume.outidx;
        g_BGChannel.SetVolume(g_BGVolume);
      end;
      *)
	  end;

    function TMIR3_GUI_Slider.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      FScrollAmount: Integer;
    begin
      if not FEnabled or not FVisible then
      begin
        Result := False;
        Exit;
      end;

      Result := True;

      case uMsg of
        WM_LBUTTONDOWN,
        WM_LBUTTONDBLCLK:
        begin
          SetRect(FButton, FParentGUIForm.FLeft + FLeft + FLButton-5, FParentGUIForm.FTop + FTop,
                   FParentGUIForm.FLeft + FLeft+ FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Right+ FLButton,
                   FParentGUIForm.FTop  + FTop + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Bottom);

          if PtInRect(FButton, AMousePoint) then
          begin
            // Pressed while inside the control
            FPressed := True;
            SetCapture(GRenderEngine.GetGameHWND);

            FDragX      := AMousePoint.x;
            FDragOffset := FButtonX - FDragX;

            if not FFocus then FParentGUIContainer.RequestFocus(@Self);
            Exit;
          end;

          if PtInRect(FBoundingBox, AMousePoint) then
          begin
            FDragX      := AMousePoint.x;
            FDragOffset := 0;
            FPressed    := True;

            if not FFocus then FParentGUIContainer.RequestFocus(@Self);

            if (AMousePoint.x > FButtonX) then
            begin
              SetValueInternal(FValue + 1, True);
              Exit;
            end;

            if (AMousePoint.x < FButtonX) then
            begin
              SetValueInternal(FValue - 1, True);
              Exit;
            end;
          end;
        end;
        WM_LBUTTONUP:
        begin
          if FPressed then
          begin
            FPressed := False;
            ReleaseCapture;
            FParentGUIContainer.SendEvent(EVENT_SLIDER_VALUE_CHANGED, True, @Self);
            Exit;
          end;
        end;
        WM_MOUSEMOVE:
        begin
          if FPressed then
          begin
            SetValueInternal(ValueFromPos(AMousePoint.x + FDragOffset), True);
            Exit;
          end;
        end;
        WM_MOUSEWHEEL:
        begin
          FScrollAmount := Integer(ShortInt(HIWORD(wParam))) div WHEEL_DELTA;
          SetValueInternal(FValue - FScrollAmount, True);
          Exit;
        end;
      end;
      Result:= False;
    end;

    procedure TMIR3_GUI_Slider.OnMouseLeave;
    begin
    //@override
      if FPressed then
      begin
        FPressed := False;
        ReleaseCapture;
        FParentGUIContainer.SendEvent(EVENT_SLIDER_VALUE_CHANGED, True, @Self);
      end;
      inherited;
    end;

    procedure TMIR3_GUI_Slider.GetRange(out AMin, AMax: Integer);
    begin
      AMin := FMin;
      AMax := FMax;
    end;

    procedure TMIR3_GUI_Slider.SetRange(AMin, AMax: Integer);
    begin
      FMin := AMin;
      FMax := AMax;
      SetValueInternal(FValue, False);
    end;

    function TMIR3_GUI_Slider.ContainsPoint(AMousePoint: TPoint): LongBool;
    begin
      if FParentGUIForm = nil then
      begin
        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint) or PtInRect(FButton, AMousePoint);
      end else begin
        Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft ,FParentGUIForm.FTop + FTop,FParentGUIForm.FLeft + FLeft+FWidth,FParentGUIForm.FTop + FTop+FHeight), AMousePoint) or
                  PtInRect(Rect(FParentGUIForm.FLeft + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Left + FLButton,FParentGUIForm.FTop +  FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Top,FParentGUIForm.FLeft +  FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Left+ FLButton + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Right,FParentGUIForm.FTop +  FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Top+ FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Bottom), AMousePoint);
      end;
    end;

    procedure TMIR3_GUI_Slider.UpdateRects;
    begin
      inherited;
      FLButton := 0;
      if (FMax - FMin) <> 0 then
      begin
        FButtonX := Trunc(((FValue - FMin) * RectWidth(FGUI_Definition.gui_WorkField) / (FMax - FMin)));
        FLButton := FLButton + FButtonX;
      end;
      SetRect(FButton, FParentGUIForm.FLeft + FLeft+FLButton, FParentGUIForm.FTop + FTop,
                       FParentGUIForm.FLeft + FLeft+ FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Right+FLButton,
                       FParentGUIForm.FTop  + FTop + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Bottom);
    end;

    procedure TMIR3_GUI_Slider.SetValueInternal(AValue: Integer; AFromInput: Boolean);
    begin
      // Clamp to range
      AValue := Max(FMin, AValue);
      AValue := Min(FMax, AValue);
      if (AValue = FValue) then Exit;
      FValue := AValue;
      UpdateRects;
      FParentGUIContainer.SendEvent(EVENT_SLIDER_VALUE_CHANGED, AFromInput, @Self);
    end;

    function TMIR3_GUI_Slider.ValueFromPos(AValue: Integer): Integer;
    var
      FValuePerPixel: Single;
    begin
      FValuePerPixel := (FMax - FMin) / RectWidth(FGUI_Definition.gui_WorkField);
      Result         := Trunc((0.5 + FMin + FValuePerPixel * (AValue - FGUI_Definition.gui_WorkField.left)));
    end;

    procedure TMIR3_GUI_Slider.SetValue(AValue: Integer);
    begin
      SetValueInternal(AValue, False);
    end;

  {$ENDREGION}


   /// TMIR3_GUI_Progress

  {$REGION ' - TMIR3_GUI_Progress :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Progress Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_Progress.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctProgress;
      FCaption := '10000 / 10000';
    end;
  {$ENDREGION}  

  {$REGION ' - TMIR3_GUI_Progress :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Progress override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_Progress.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      I             : Integer;
      FSize         : Integer;
      FProgressRect : TRect;
      FDrawSetting  : TDrawSetting;
    begin
	  // @override
      with FGUI_Definition, gui_Progress_Setup, gui_Control_Texture, gui_Font, GGameEngine.FGameFileManger do
      begin
        if gui_Value > gui_Max then
          gui_Value := gui_Max;
        if (gui_Value * 100 div gui_Max) > 0 then
        begin
          case gui_Progress_Type of
            ptHorizontal: begin
              FSize := (ABS(gui_WorkField.Right-gui_WorkField.Left) * gui_Value div (gui_Max));
              SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
              if (gui_Background_Texture_ID > 0) then
              begin
		            (* Render Progressbar with given Texture *)
                DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
              end;
            end;
            ptVertical  : begin
              FSize := ((gui_WorkField.Bottom - gui_WorkField.Top) * gui_Value div (gui_Max));
              SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top + (gui_WorkField.Bottom - FSize), gui_WorkField.Right, gui_WorkField.Bottom);
              if (gui_Background_Texture_ID > 0) then
              begin
		            (* Render Progressbar with given Texture *)
                DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop +(gui_WorkField.Bottom - FSize), FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
              end;
              if FMouseOver and gui_ShowHint then
              begin
                (* Render Hint *)
                with FDrawSetting do
                begin
                  dsFontHeight    := 18;
                  dsFontSetting   := [];
                  dsFontType      := 0;
                  dsFontSpacing   := 0;
                  dsHAlign        := alLeft;
                  dsVAlign        := avTop;
                  dsUseKerning    := False;
                  dsColor         := $FFe9e9d9;
                  dsMagicUse      := False;
                end;
                //TODO : Fix me
                FParentGUIContainer.AddHintMessage('Bag Size : 100/140', FDrawSetting, Self);
              end;
            end;
            ptSpecial   : begin
               { Test % Range }
               FSize := (gui_Value * 100 div gui_Max);
               case FSize of
                 0..10  : begin
                   FSize := Round(((FSize *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 11..20 : begin
                   FSize := Round((((FSize-10) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+71, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 21..30 : begin
                   FSize := Round((((FSize-20) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 1 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+140, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 31..40 : begin
                   FSize := Round((((FSize-30) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 2 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+210, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 41..50 : begin
                   FSize := Round((((FSize-40) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 3 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+280, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 51..60 : begin
                   FSize := Round((((FSize-50) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 4 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+350, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 61..70 : begin
                   FSize := Round((((FSize-60) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 5 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+420, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 71..80 : begin
                   FSize := Round((((FSize-70) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 6 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+490, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 81..90 : begin
                   FSize := Round((((FSize-80) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 7 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+560, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
                 91..100: begin
                   FSize := Round((((FSize-90) *10) / 100) * gui_WorkField.Right);
                   SetRect(FProgressRect,gui_WorkField.Left, gui_WorkField.Top, FSize, gui_WorkField.Bottom);
                   if (gui_Background_Texture_ID > 0) then
                   begin
                     for I := 0 to 8 do
                     begin
                       DrawTexture(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + (I*70)   , FParentGUIForm.FTop + FTop, BLEND_DEFAULT, gui_Blend_Size);
                     end;
                     DrawTextureClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft+630, FParentGUIForm.FTop + FTop, FProgressRect, BLEND_DEFAULT, gui_Blend_Size);
                   end;
                 end;
               end;
               if FMouseOver then
               begin
                 (* Render Hint *)
                 with FDrawSetting do
                 begin
                   dsFontHeight    := 18;
                   dsFontSetting   := [];
                   dsFontType      := 0;
                   dsFontSpacing   := 0;
                   dsHAlign        := alLeft;
                   dsVAlign        := avTop;
                   dsUseKerning    := False;
                   dsColor         := $FFe9e9d9;
                   dsMagicUse      := False;
                 end;
                 FParentGUIContainer.AddHintMessage('Experience : ' + IntToStr(gui_Value * 100 div gui_Max) + ' %', FDrawSetting, Self);
               end;
            end;
          end;
        end;

        if gui_ShowText then
        begin
//          case True of
//            0;
//          end;
          //TODO : add Text Rendering Centered on the Control...
          // need some Checks if it external Text or is it % Rate of them etc.
          // We need one for Exp Hint info

          //FAKE  Text atm
         with FDrawSetting do
         begin
           dsControlWidth  := FWidth;
           dsControlHeigth := FHeight;
           dsAX            := FParentGUIForm.FLeft + FLeft + 1;
           dsAY            := FParentGUIForm.FTop  + FTop  + 1;
           dsFontHeight    := gui_Font_Size;
           dsFontSetting   := gui_Font_Setting;
           dsFontType      := 0;
           dsFontSpacing   := 0;
           dsUseKerning    := gui_Font_Use_Kerning;
           dsColor         := gui_Font_Color;
           dsHAlign        := gui_Font_Text_HAlign;
           dsVAlign        := gui_Font_Text_VAlign;
           dsMagicUse      := False;
         end;
         GGameEngine.FontManager.DrawControlText(PWideChar(FCaption), @FDrawSetting);
        end;
      end;
	  end;
  {$ENDREGION}
  
  
   /// TMIR3_GUI_Scrollbar  
  
  {$REGION ' - TMIR3_GUI_Scrollbar :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Scrollbar Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_Scrollbar.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctScrollbar;

      m_bShowThumb  := True;
      FCanDrag      := False;
      SetRect(FUpButton   , 0, 0, 0, 0);
      SetRect(FDownButton , 0, 0, 0, 0);
      SetRect(FTrack      , 0, 0, 0, 0);
      SetRect(FSliderThumb, 0, 0, 0, 0);
      FPosition := 0;
      FPageSize := 1;
      FMin      := FGUI_Definition.gui_ScrollBar_Setup.gui_Slider_Info.gui_Min;
      FMax      := FGUI_Definition.gui_ScrollBar_Setup.gui_Slider_Info.gui_Max;
      UpdateRects;
    end;
  {$ENDREGION}  

  {$REGION ' - TMIR3_GUI_Scrollbar :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Scrollbar override render function for this control
    //..............................................................................   
    procedure TMIR3_GUI_Scrollbar.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FCurrTime: Double;
    begin
	  // @override
	    (* Render Scrollbar *)
      if FParentGUIContainer.FDebugMode then
      begin
		    (* Render Scrollbar without Texture in Debug Mode *)
        GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FWidth, FHeight, $FFFF0000, True);
      end else begin
		    (* Render Scrollbar with given Texture *)
        with FGUI_Definition, gui_Control_Texture, gui_Font, gui_ScrollBar_Setup, GGameEngine.FGameFileManger do
        begin

          // Check if the arrow button has been held for a while.
          // If so, update the thumb position to simulate repeated
          // scroll.
          if (FArrowButtonState <> CLEAR) then
          begin
            FCurrTime := DX9GetGlobalTimer.GetTime;
            if PtInRect(FUpButton, FLastMouse) then
            begin
              case FArrowButtonState of
                CLICKED_UP:
                  if (SCROLLBAR_ARROWCLICK_DELAY < FCurrTime - FArrowTime) then
                  begin
                    Scroll(-1);
                    FArrowButtonState := HELD_UP;
                    FArrowTime        := FCurrTime;
                    FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
                  end;

                HELD_UP:
                  if (SCROLLBAR_ARROWCLICK_REPEAT < FCurrTime - FArrowTime) then
                  begin
                    Scroll(-1);
                    FArrowTime := FCurrTime;
                    FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
                  end;
              end; {case}
            end else
            if PtInRect(FDownButton, FLastMouse) then
            begin
              case FArrowButtonState of
                CLICKED_DOWN:
                  if (SCROLLBAR_ARROWCLICK_DELAY < FCurrTime - FArrowTime) then
                  begin
                    Scroll(1);
                    FArrowButtonState := HELD_DOWN;
                    FArrowTime        := FCurrTime;
                    FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
                  end;

                HELD_DOWN:
                  if (SCROLLBAR_ARROWCLICK_REPEAT < FCurrTime - FArrowTime) then
                  begin
                    Scroll(1);
                    FArrowTime := FCurrTime;
                    FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
                  end;
              end;
            end;
          end;

          DrawTexture(gui_Slider_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + FSliderThumb.Left, FParentGUIForm.FTop + FTop + FSliderThumb.Top, BLEND_DEFAULT, gui_Blend_Size);




//          if (gui_Background_Texture_ID > 0) then
//          begin
//            case gui_ScrollKind of
//              skVertical   : begin
//                SetRect(FScrollBarRect, gui_WorkField.Left, gui_WorkField.Top, gui_WorkField.Right, FLButton);               
//              end;
//              skHorizontal : begin
//                SetRect(FScrollBarRect, gui_WorkField.Left, gui_WorkField.Top, FLButton, gui_WorkField.Bottom);
//              end;                 
//            end; (* Render Button with given Texture *)
//            DrawClipRect(gui_Background_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop, FScrollBarRect, BLEND_DEFAULT, gui_Blend_Size);
//          end;
//
//          {Render Slider Button}
//          if (gui_Slider_Texture_ID > 0)  then
//          begin
//            case gui_ScrollKind of
//              skVertical   : begin
// 		        (* Render Button with given Texture *)
//                DrawClipRect(gui_Slider_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Slider_Info.gui_Btn_Size.Left, FParentGUIForm.FTop + FTop + FLButton-5, gui_Slider_Info.gui_Btn_Size ,BLEND_DEFAULT, gui_Blend_Size);
//              end;               
//              skHorizontal : begin
//		       (* Render Button with given Texture *)
//                DrawClipRect(gui_Slider_Texture_ID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + FLButton-5 , FParentGUIForm.FTop + FTop + gui_Slider_Info.gui_Btn_Size.Top, gui_Slider_Info.gui_Btn_Size ,BLEND_DEFAULT, gui_Blend_Size);
//              end;
//            end;
//          end;

        end;
      end;
	  end;

{$REGION 'MyRegion'}
  //    function TMIR3_GUI_Scrollbar.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
  //    var
  //      FScrollAmount: Integer;
  //    begin
  //      if not FEnabled or not FVisible then
  //      begin
  //        Result := False;
  //        Exit;
  //      end;
  //
  //      Result := True;
  //
  //      case uMsg of
  //        WM_LBUTTONDOWN,
  //        WM_LBUTTONDBLCLK:
  //        begin
  //          with FGUI_Definition, gui_ScrollBar_Setup do
  //          begin
  //            
  //            if PtInRect(gui_Button_Rect_BR, AMousePoint) then
  //            begin   
  //              SetCapture(GRenderEngine.GetGameHWND);
  //              SetValueInternal(FValue +1, True);
  //              FPressed := True;
  //            end else if PtInRect(gui_Button_Rect_TL, AMousePoint) then 
  //                     begin      
  //                       SetCapture(GRenderEngine.GetGameHWND);
  //                       SetValueInternal(FValue -1, True);
  //                       FPressed := True;
  //                     end;
  //        
  //            case gui_ScrollKind of 
  //              skVertical   : begin           
  //                SetRect(FButton, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop+ FLButton-5,
  //                         FParentGUIForm.FLeft + FLeft+ FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Right,
  //                         FParentGUIForm.FTop  + FTop + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Bottom + FLButton);
  //              end;           
  //              skHorizontal : begin
  //                SetRect(FButton, FParentGUIForm.FLeft + FLeft + FLButton-5, FParentGUIForm.FTop + FTop,
  //                         FParentGUIForm.FLeft + FLeft+ FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Right+ FLButton,
  //                         FParentGUIForm.FTop  + FTop + FGUI_Definition.gui_Slider_Setup.gui_Btn_Size.Bottom);
  //              end;
  //            end;
  //          end;        
  //
  //          if PtInRect(FButton, AMousePoint) then
  //          begin
  //            // Pressed while inside the control
  //            FPressed := True;
  //            SetCapture(GRenderEngine.GetGameHWND);
  //           
  //           with FGUI_Definition, gui_ScrollBar_Setup do
  //            begin
  //              case gui_ScrollKind of
  //                skVertical   : begin           
  //                  FDragX := AMousePoint.y;
  //                end;           
  //                skHorizontal : begin
  //                  FDragX := AMousePoint.x;
  //                end;
  //              end;
  //            end;
  //            
  //            FDragOffset := FButtonX - FDragX;
  //
  //            if not FFocus then FParentGUIContainer.RequestFocus(@Self);
  //            Exit;
  //          end;
  //
  //          if PtInRect(FBoundingBox, AMousePoint) then
  //          begin
  //            with FGUI_Definition, gui_ScrollBar_Setup do
  //            begin
  //              case gui_ScrollKind of 
  //                skVertical   : begin           
  //                  FDragX      := AMousePoint.y;
  //                  FDragOffset := 0;
  //                  FPressed    := True;
  //                  
  //                  if not FFocus then FParentGUIContainer.RequestFocus(@Self);
  //                  
  //                  if (AMousePoint.y > FButtonX) then
  //                  begin
  //                    SetValueInternal(FValue + 1, True);
  //                    Exit;
  //                  end;
  //                  
  //                  if (AMousePoint.y < FButtonX) then
  //                  begin
  //                    SetValueInternal(FValue - 1, True);
  //                    Exit;
  //                  end;
  //                end;           
  //                skHorizontal : begin
  //                  FDragX      := AMousePoint.x;
  //                  FDragOffset := 0;
  //                  FPressed    := True;
  //                  
  //                  if not FFocus then FParentGUIContainer.RequestFocus(@Self);
  //                  
  //                  if (AMousePoint.x > FButtonX) then
  //                  begin
  //                    SetValueInternal(FValue + 1, True);
  //                    Exit;
  //                  end;
  //                  
  //                  if (AMousePoint.x < FButtonX) then
  //                  begin
  //                    SetValueInternal(FValue - 1, True);
  //                    Exit;
  //                  end;
  //                end;
  //              end;
  //            end;           
  //          end;
  //        end;
  //        WM_LBUTTONUP:
  //        begin
  //          if FPressed then
  //          begin
  //            FPressed := False;
  //            ReleaseCapture;
  //            FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
  //            Exit;
  //          end;
  //        end;
  //        WM_MOUSEMOVE:
  //        begin
  //          if FPressed then
  //          begin
  //            with FGUI_Definition, gui_ScrollBar_Setup do
  //            begin
  //              case gui_ScrollKind of 
  //                skVertical   : begin
  //                  SetValueInternal(ValueFromPos(AMousePoint.y + FDragOffset), True);
  //                end;           
  //                skHorizontal : begin
  //                  SetValueInternal(ValueFromPos(AMousePoint.x + FDragOffset), True);
  //                end;
  //              end;
  //            end;
  //            exit;
  //          end;
  //        end;
  //        WM_MOUSEWHEEL:
  //        begin
  //          FScrollAmount := Integer(ShortInt(HIWORD(wParam))) div WHEEL_DELTA;
  //          SetValueInternal(FValue - FScrollAmount, True);
  //          FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
  //          Exit;
  //        end;
  //      end;
  //      Result:= False;
  //    end;
  //
  //    procedure TMIR3_GUI_Scrollbar.GetRange(out AMin, AMax: Integer);
  //    begin
  //      AMin := FMin;
  //      AMax := FMax;
  //    end;
  //
  //    procedure TMIR3_GUI_Scrollbar.SetRange(AMin, AMax: Integer);
  //    begin
  //      FMin := AMin;
  //      FMax := AMax;
  //      SetValueInternal(FValue, False);
  //    end;
  //
  //    function TMIR3_GUI_Scrollbar.ContainsPoint(AMousePoint: TPoint): LongBool;
  //    begin
  //      if FParentGUIForm = nil then
  //      begin
  //        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint) or PtInRect(FButton, AMousePoint);
  //      end else begin
  //        with FGUI_Definition, gui_ScrollBar_Setup do
  //        begin
  //          case gui_ScrollKind of 
  //            skVertical   : begin      
  //              Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft ,FParentGUIForm.FTop + FTop,FParentGUIForm.FLeft + FLeft+FWidth,FParentGUIForm.FTop + FTop+FHeight), AMousePoint) or
  //                        PtInRect(Rect(FParentGUIForm.FLeft + gui_Slider_Info.gui_Btn_Size.Left + FLButton,FParentGUIForm.FTop + gui_Slider_Info.gui_Btn_Size.Top,FParentGUIForm.FLeft + gui_Slider_Info.gui_Btn_Size.Left + gui_Slider_Info.gui_Btn_Size.Right,
  //                                      FParentGUIForm.FTop  + gui_Slider_Info.gui_Btn_Size.Top  + FLButton + gui_Slider_Info.gui_Btn_Size.Bottom), AMousePoint);
  //            end;
  //            skHorizontal : begin
  //              Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft ,FParentGUIForm.FTop + FTop,FParentGUIForm.FLeft + FLeft+FWidth,FParentGUIForm.FTop + FTop+FHeight), AMousePoint) or
  //                        PtInRect(Rect(FParentGUIForm.FLeft + gui_Slider_Info.gui_Btn_Size.Left + FLButton,FParentGUIForm.FTop + gui_Slider_Info.gui_Btn_Size.Top,FParentGUIForm.FLeft + gui_Slider_Info.gui_Btn_Size.Left+ FLButton + gui_Slider_Info.gui_Btn_Size.Right,
  //                                      FParentGUIForm.FTop  + gui_Slider_Info.gui_Btn_Size.Top  + gui_Slider_Info.gui_Btn_Size.Bottom), AMousePoint);
  //            end;
  //          end;
  //        end;
  //      end;
  //    end;
  //
  //    procedure TMIR3_GUI_Scrollbar.UpdateRects;
  //    begin
  //      inherited;
  //      FLButton := 0;
  //      with FGUI_Definition, gui_ScrollBar_Setup do
  //      begin
  //        case gui_ScrollKind of 
  //          skVertical   : begin
  //            if (FMax - FMin) <> 0 then
  //            begin
  //              FButtonX := Trunc(((FValue - FMin) * RectHeight(gui_WorkField) / (FMax - FMin)));
  //              FLButton := FLButton + FButtonX;
  //            end;
  //            SetRect(FButton, FParentGUIForm.FLeft + FLeft, FParentGUIForm.FTop + FTop +FLButton,
  //                             FParentGUIForm.FLeft + FLeft+ gui_Slider_Info.gui_Btn_Size.Right,
  //                             FParentGUIForm.FTop  + FTop + gui_Slider_Info.gui_Btn_Size.Bottom+FLButton);
  //          end;           
  //          skHorizontal : begin
  //            if (FMax - FMin) <> 0 then
  //            begin
  //              FButtonX := Trunc(((FValue - FMin) * RectWidth(gui_WorkField) / (FMax - FMin)));
  //              FLButton := FLButton + FButtonX;
  //            end;
  //            SetRect(FButton, FParentGUIForm.FLeft + FLeft+FLButton, FParentGUIForm.FTop + FTop,
  //                             FParentGUIForm.FLeft + FLeft+ gui_Slider_Info.gui_Btn_Size.Right+FLButton,
  //                             FParentGUIForm.FTop  + FTop + gui_Slider_Info.gui_Btn_Size.Bottom);
  //          end;
  //        end;
  //      end;        
  //    end;
  //
  //    procedure TMIR3_GUI_Scrollbar.SetValueInternal(AValue: Integer; AFromInput: Boolean);
  //    begin
  //      // Clamp to range
  //      AValue := Max(FMin, AValue);
  //      AValue := Min(FMax, AValue);
  //      if (AValue = FValue) then Exit;
  //      FValue := AValue;
  //      UpdateRects;
  //      FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, AFromInput, @Self);
  //    end;
  //
  //    function TMIR3_GUI_Scrollbar.ValueFromPos(AValue: Integer): Integer;
  //    var
  //      FValuePerPixel: Single;
  //    begin
  //      with FGUI_Definition, gui_ScrollBar_Setup do
  //      begin
  //        case gui_ScrollKind of 
  //          skVertical   : begin
  //            FValuePerPixel := (FMax - FMin) / RectHeight(gui_WorkField);
  //            Result         := Trunc((0.5 + FMin + FValuePerPixel * (AValue - gui_WorkField.top)));
  //          end;               
  //          skHorizontal : begin
  //            FValuePerPixel := (FMax - FMin) / RectWidth(gui_WorkField);
  //            Result         := Trunc((0.5 + FMin + FValuePerPixel * (AValue - gui_WorkField.left)));
  //          end;
  //        end;  
  //      end;
  //    end;
  //
  //    procedure TMIR3_GUI_Scrollbar.SetValue(AValue: Integer);
  //    begin
  //      SetValueInternal(AValue, False);
  //    end;
{$ENDREGION}


    var
      ThumbOffsetY: Integer = 0;

    function TMIR3_GUI_Scrollbar.HandleMouse(uMsg: LongWord; AMousePoint: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
    var
      FTestPoint  : TPoint;
      nMaxFirstItem: Integer;
      nMaxThumb: Integer;
      FScrollAmount: Integer;
    begin
      if not FEnabled or not FVisible then
      begin
        Result := False;
        Exit;
      end;

      Result := True;

      FTestPoint.x := AMousePoint.X - (FParentGUIForm.Left + FLeft);
      FTestPoint.y := AMousePoint.Y - (FParentGUIForm.Top  + FTop);
      FLastMouse   := FTestPoint;

      case uMsg of
        WM_LBUTTONDOWN,
        WM_LBUTTONDBLCLK:
        begin
          // Check for click on up button
          if PtInRect(FUpButton, FTestPoint) then
          begin
            SetCapture(GRenderEngine.GetGameHWND);
            if (FPosition > FMin) then Dec(FPosition);
            UpdateThumbRect;
            FArrowButtonState := CLICKED_UP;
            FArrowTime        := DX9GetGlobalTimer.GetTime;
            if not FFocus then FParentGUIContainer.RequestFocus(@Self);
            Exit;
          end;

          // Check for click on down button
          if PtInRect(FDownButton, FTestPoint) then
          begin
            SetCapture(GRenderEngine.GetGameHWND);
            if (FPosition + FPageSize < FMax) then Inc(FPosition);
            UpdateThumbRect;
            FArrowButtonState := CLICKED_DOWN;
            FArrowTime        := DX9GetGlobalTimer.GetTime;
            if not FFocus then FParentGUIContainer.RequestFocus(@Self);
            Exit;
          end;

          // Check for click on thumb
          if PtInRect(FSliderThumb, FTestPoint) then
          begin
            SetCapture(GRenderEngine.GetGameHWND);
            FCanDrag     := True;
            ThumbOffsetY := FTestPoint.y - FSliderThumb.top;
            if not FFocus then FParentGUIContainer.RequestFocus(@Self);
            Exit;
          end;

          // Check for click on track
          if (FSliderThumb.left <= FTestPoint.x) and (FSliderThumb.right > FTestPoint.x) then
          begin
            SetCapture(GRenderEngine.GetGameHWND);
            if (FSliderThumb.top > FTestPoint.y) and
               (FTrack.top      <= FTestPoint.y) then
            begin
              Scroll(-(FPageSize - 1));
              if not FFocus then FParentGUIContainer.RequestFocus(@Self);
              Exit;
            end else
            if (FSliderThumb.bottom <= FTestPoint.y) and
               (FTrack.bottom        > FTestPoint.y) then
            begin
              Scroll(FPageSize - 1);
              if not FFocus then FParentGUIContainer.RequestFocus(@Self);
              Exit;
            end;
          end;
        end;

        WM_LBUTTONUP:
        begin
          FCanDrag := False;
          ReleaseCapture;
          FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
          UpdateThumbRect;
          FArrowButtonState := CLEAR;
        end;

        WM_MOUSEMOVE:
        begin
          if FCanDrag then
          begin
            Inc(FSliderThumb.bottom, FTestPoint.y - ThumbOffsetY - FSliderThumb.top);
            FSliderThumb.top := FTestPoint.y - ThumbOffsetY;
            if (FSliderThumb.top    < FTrack.top)    then
              OffsetRect(FSliderThumb, 0, FTrack.top - FSliderThumb.top) else
            if (FSliderThumb.bottom > FTrack.bottom) then
              OffsetRect(FSliderThumb, 0, FTrack.bottom - FSliderThumb.bottom);

            // Compute first item index based on thumb position
            nMaxFirstItem := FMax - FMin - FPageSize;                        // Largest possible index for first item
            nMaxThumb     := RectHeight(FTrack) - RectHeight(FSliderThumb);  // Largest possible thumb position from the top

            // Shift by half a row to avoid last row covered by only one pixel
            FPosition := FMin + ( FSliderThumb.top - FTrack.top + nMaxThumb div (nMaxFirstItem * 2) ) * nMaxFirstItem  div nMaxThumb;
            FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
           // Exit;
          end;
        end;
        WM_MOUSEWHEEL:
        begin
          FScrollAmount := Integer(ShortInt(HIWORD(wParam))) div WHEEL_DELTA;
          FPosition     := FPosition - FScrollAmount;
          if (FPosition > FMin) and (FPosition + FPageSize < FMax) then
          begin
            UpdateThumbRect;
            FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
          end;
          Exit;
        end;
      end;

      Result:= False;
    end;

    procedure TMIR3_GUI_Scrollbar.OnMouseLeave;
    begin
    //@override
      FCanDrag := False;
      ReleaseCapture;
      FParentGUIContainer.SendEvent(EVENT_SCROLLBAR_VALUE_CHANGED, True, @Self);
      UpdateThumbRect;
      FArrowButtonState := CLEAR;
      inherited;
    end;

//    function TMIR3_GUI_Scrollbar.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
//    begin
//      if (WM_CAPTURECHANGED = uMsg) then
//      begin
//        // The application just lost mouse capture. We may not have gotten
//        // the WM_MOUSEUP message, so reset FCanDrag here.
//        if (THandle(lParam) <> GRenderEngine.GetGameHWND) then
//          FCanDrag := False;
//      end;
//      Result:= False;
//    end;



    // Compute the dimension of the scroll thumb
    procedure TMIR3_GUI_Scrollbar.UpdateThumbRect;
    var
      FThumbHeight: Integer;
      FMaxPosition: Integer;
    begin
      if (FMax - FMin > FPageSize) then
      begin
        FThumbHeight        := Max(RectHeight(FTrack) * FPageSize div (FMax - FMin), SCROLLBAR_MINTHUMBSIZE);
        FMaxPosition        := FMax - FMin - FPageSize;
        FSliderThumb.top    := FTrack.top    + (FPosition - FMin) * (RectHeight(FTrack) - FThumbHeight) div FMaxPosition;
        FSliderThumb.bottom := FSliderThumb.top +  30;//+ FThumbHeight;
        FSliderThumb.Right  := 20;
        FSliderThumb.Left   := 2;
        m_bShowThumb        := True;
      end else
      begin
        // No content to scroll
        FSliderThumb.bottom := FSliderThumb.top;
        m_bShowThumb        := False;
      end;
    end;

    procedure TMIR3_GUI_Scrollbar.UpdateRects;
    begin
      inherited;
      // Make the buttons square
      with FGUI_Definition do
      begin
        SetRect(FUpButton   , gui_WorkField.left, gui_WorkField.top, gui_WorkField.right, gui_WorkField.top + RectWidth(gui_WorkField));
        SetRect(FDownButton , gui_WorkField.left, gui_WorkField.bottom - RectWidth(gui_WorkField), gui_WorkField.right, gui_WorkField.bottom);
        SetRect(FTrack      , FUpButton.left , FUpButton.bottom, FDownButton.right, FDownButton.top);
        FSliderThumb.left  := FUpButton.left +1;
        FSliderThumb.right := FUpButton.right-1;
      end;
      UpdateThumbRect;
    end;

    // Scroll() scrolls by nDelta items.  A positive value scrolls down, while a negative
    // value scrolls up.
    procedure TMIR3_GUI_Scrollbar.Scroll(nDelta: Integer);
    begin
      // Perform scroll
      Inc(FPosition, nDelta);
      // Cap position
      Cap;
      // Update thumb position
      UpdateThumbRect;
    end;

    procedure TMIR3_GUI_Scrollbar.ShowItem(AIndex: Integer);
    begin
      // Cap the index
      if (AIndex < 0)     then
        AIndex := 0;
      if (AIndex >= FMax) then
        AIndex := FMax - 1;

      // Adjust position
      if (FPosition > AIndex) then
        FPosition := AIndex
      else if (FPosition + FPageSize <= AIndex) then
             FPosition := AIndex - FPageSize + 1;

      UpdateThumbRect;
    end;

    procedure TMIR3_GUI_Scrollbar.SetTrackRange(AMin, AMax: Integer);
    begin
      FMin := AMin;
      FMax := AMax;
      Cap;
      UpdateThumbRect;
    end;

    procedure TMIR3_GUI_Scrollbar.Cap; // Clips position at boundaries. Ensures it stays within legal range.
    begin
      if (FPosition < FMin) or
         (FMax - FMin <= FPageSize) then
      begin
        FPosition := FMin;
      end else if (FPosition + FPageSize > FMax) then
                 FPosition := FMax - FPageSize;
    end;

    procedure TMIR3_GUI_Scrollbar.SetPageSize(APageSize: Integer);
    begin
      FPageSize := APageSize;
      Cap;
      UpdateThumbRect;
    end;

    procedure TMIR3_GUI_Scrollbar.SetTrackPos(APosition: Integer);
    begin
      FPosition := APosition;
      Cap;
      UpdateThumbRect;
    end;

  {$ENDREGION}
 
   /// TMIR3_GUI_MagicButton

  {$REGION ' - TMIR3_GUI_MagicButton :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_MagicButton Form control constructor
    //..............................................................................  
    constructor TMIR3_GUI_MagicButton.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctMagicButton;
      FCaption            := '0';
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_MagicButton :: functions   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_MagicButton override
    //..............................................................................
    function TMIR3_GUI_MagicButton.ContainsPoint(AMousePoint: TPoint): LongBool;
    begin
	  // @override
      if FParentGUIForm = nil then
      begin
        Result := PtInRect(Rect(FLeft,FTop,FLeft+FWidth,FTop+FHeight), AMousePoint);
      end else begin
        with FGUI_Definition do
          Result := PtInRect(Rect(FParentGUIForm.FLeft + FLeft+ gui_Extra_Offset_X ,FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y,FParentGUIForm.FLeft + FLeft+ gui_Extra_Offset_X+FWidth,FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y+FHeight), AMousePoint);
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_MagicButton override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_MagicButton.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    var
      FClipRect     : TRect;
      FShowFlag    : Integer;
      FDrawSetting : TDrawSetting;
      FTempTextureID : Integer;
    begin
    // @override
	    (* Render Button *)
      with FGUI_Definition, gui_Control_Texture, gui_Font, GGameEngine.FGameFileManger do
      begin
        if FParentGUIContainer.FDebugMode then
        begin
		      (* Render Button without Texture in Debug Mode *)
          GRenderEngine.Rectangle(FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, FWidth, FHeight, $FFFF0000, True);
        end else begin
          if (FTop + gui_Extra_Offset_Y > gui_Clip_Rect.Bottom) or (FTop  + gui_Extra_Offset_Y < gui_Clip_Rect.Top-35) then
          begin
            FShowFlag := 0;
          end else begin
            FShowFlag := 1;
            if (FTop + gui_Extra_Offset_Y > (gui_Clip_Rect.Bottom - 44)) then
            begin
              FShowFlag := 2;
            end;
            if (FTop + gui_Extra_Offset_Y > (gui_Clip_Rect.Bottom - 36)) then
            begin
              FShowFlag := 3;
            end;
            if (FTop + gui_Extra_Offset_Y < gui_Clip_Rect.top) then
            begin
              FShowFlag := 4;
            end;

            FTempTextureID :=gui_Control_Texture.gui_Extra_Texture_Set.gui_Background_Texture_ID;
            if (FSwitchOn) and (FTempTextureID > 0) and (gui_Texture_File_ID > 75) then
            begin
              case FShowFlag of
                1,2: begin
                  SetRect(FClipRect,0,0,34,34);
                  DrawTextureClipRect(FTempTextureID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, FClipRect, BLEND_DEFAULT, gui_Blend_Size);
                  if (FMagicFKey  > 0) and (FMagicFKey  <= 12) then
                  begin
                    SetRect(FClipRect,0,0,32,18);
                    DrawTextureClipRect(1660+FMagicFKey, GAME_TEXTURE_GAMEINTER_INT, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, FClipRect, BLEND_DEFAULT, 180);
                  end;
                end;
                3  : begin
                  SetRect(FClipRect,0,0,34,ABS(34-(FTop + gui_Extra_Offset_Y-(gui_Clip_Rect.Bottom - 36))));
                  DrawTextureClipRect(FTempTextureID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, FClipRect, BLEND_DEFAULT, gui_Blend_Size);
                  if (FMagicFKey  > 0) and (FMagicFKey  <= 12) then
                  begin
                    SetRect(FClipRect,0,0,32,ABS(18-(FTop + gui_Extra_Offset_Y-(gui_Clip_Rect.Bottom - 18))));
                    DrawTextureClipRect(1660+FMagicFKey, GAME_TEXTURE_GAMEINTER_INT, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y, FClipRect, BLEND_DEFAULT, 180);
                  end;
                end;
                4: begin
                  SetRect(FClipRect,0,ABS(ABS((FTop + gui_Extra_Offset_Y) - gui_Clip_Rect.top)),34,34);
                  DrawTextureClipRect(FTempTextureID, gui_Texture_File_ID, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y + ABS(ABS((FTop + gui_Extra_Offset_Y) - gui_Clip_Rect.top)), FClipRect, BLEND_DEFAULT, gui_Blend_Size);
                  if (FMagicFKey  > 0) and (FMagicFKey  <= 12) then
                  begin
                    SetRect(FClipRect,0,ABS(ABS((FTop + gui_Extra_Offset_Y) - gui_Clip_Rect.top)),32,18);
                    DrawTextureClipRect(1660+FMagicFKey, GAME_TEXTURE_GAMEINTER_INT, FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X, FParentGUIForm.FTop + FTop + gui_Extra_Offset_Y + ABS(ABS((FTop + gui_Extra_Offset_Y) - gui_Clip_Rect.top)), FClipRect, BLEND_DEFAULT, 180);
                  end;
                end;
              end;
            end;
          end;

      // TODO : Add F1-F12 Key Overlay Texture Rendering 
      //      : Add Check Variable thats hold the F* Key = 0 nothing

      (*  
         if FMagicFKey  > 0 then
         begin
           Render (BaseID+FMagicFKey,....)
         end;
      *)

        (* Render Magic Button Text *)
          if (Trim(FCaption) <> '') and (FSwitchOn) and ((FShowFlag = 1) or (FShowFlag = 4)) then
          begin
            with FDrawSetting do
            begin
              dsControlWidth  := 16;
              dsControlHeigth := 16;
              dsAX            := FParentGUIForm.FLeft + FLeft + gui_Extra_Offset_X + 33;
              dsAY            := FParentGUIForm.FTop  + FTop  + gui_Extra_Offset_Y + 33;
              dsFontHeight    := gui_Font_Size;
              dsFontSetting   := gui_Font_Setting;
              dsFontType      := 0;
              dsFontSpacing   := 0;
              dsUseKerning    := gui_Font_Use_Kerning;
              dsColor         := gui_Font_Color;
              dsHAlign        := gui_Font_Text_HAlign;
              dsVAlign        := gui_Font_Text_VAlign;
              dsMagicUse      := False;
            end;
            GGameEngine.FontManager.DrawControlText(PWideChar(FCaption), @FDrawSetting);
          end;
          (* Render Magic Hint *)
          if (FSwitchOn) and (FShowFlag > 0) and (FMouseOver) and (gui_MagicHintID <> 0) then
          begin
            with FDrawSetting do
            begin  (* Exclusive for Magic Hint *)
              dsFontHeight    := 16;
              dsFontSetting   := [];
              dsFontType      := 0;
              dsFontSpacing   := 0;
              dsHAlign        := alLeft;
              dsVAlign        := avTop;
              dsUseKerning    := False;
              dsColor         := $FFFEFEFE; //f2cba0;
              (* Blue *)
              dsColorMC_1     := $9F0a0a1a;
              dsColorMC_2     := $AF020202;
              (* Red *)
              //dsColorMC_1     := $9F2a0a0a;
              //dsColorMC_2     := $AF020202;

              dsColorMC_B     := $EF454555; //Border
              dsColorMC_B2    := $EF121222;
              dsMagicUse      := True;
              dsUseMultiColor := True;
            end;
            FParentGUIContainer.AddHintMessage(GGameEngine.GameLanguage.GetMagicTextFromLangSystem(gui_MagicHintID), FDrawSetting, Self);
          end;          
        end;
      end;
  	end;
  {$ENDREGION}
  

  {$REGION ' - TMIR3_GUI_Timer :: constructor   '}
    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Timer Form control constructor
    //..............................................................................
    constructor TMIR3_GUI_Timer.Create(PGUI_Definition: PMir3_GUI_Ground_Info = nil; PParentGUIManager: TMIR3_GUI_Manager = nil);
    begin
      inherited;
      if Assigned(PGUI_Definition) then
        FGUI_Definition := PGUI_Definition^;
      FParentGUIContainer := PParentGUIManager;
      FControlType        := ctTimer;
      FTimerEnable        := False;
      FTickTime           := GetTickCount;
    end;
  {$ENDREGION}

  {$REGION ' - TMIR3_GUI_Timer :: functions   '}

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Timer override render function for this control
    //..............................................................................
    procedure TMIR3_GUI_Timer.RenderControl(AD3DDevice: IDirect3DDevice9; AElapsedTime: Single);
    begin
      // @override
      with FGUI_Definition do
      begin
        if FTimerEnable then
          if (GetTickCount - FTickTime) > gui_Timer_Intervall then
          begin
            FParentGUIContainer.SendEvent(EVENT_TIMER_TIME_EXPIRE, True, @Self);
            FTickTime := GetTickCount;
          end;
      end;
  	end;

    ////////////////////////////////////////////////////////////////////////////////
    // TMIR3_GUI_Timer Enable function for this control
    //..............................................................................
    procedure TMIR3_GUI_Timer.SetTimerEnabled(AEnabled: Boolean);
    begin
      case AEnabled of
        True  : begin
          FTickTime    := GetTickCount;
          FTimerEnable := True;
        end;
        False : begin
          FTimerEnable := False;
        end;
      end;
  	end;

  {$ENDREGION}


end.