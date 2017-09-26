unit APlayer3Lib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 29/03/2017 6:35:23 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\Public\Thunder Network\APlayer\APlayer_3.9.2.769.dll (1)
// LIBID: {97830570-35FE-4195-83DE-30E79B718713}
// LCID: 0
// Helpfile: 
// HelpString: APlayer3 1.0 ���Ϳ�
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Error creating palette bitmap of (TPlayer) : Error reading control bitmap
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleCtrls, Vcl.OleServer, Winapi.ActiveX;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  APlayer3LibMajorVersion = 1;
  APlayer3LibMinorVersion = 0;

  LIBID_APlayer3Lib: TGUID = '{97830570-35FE-4195-83DE-30E79B718713}';

  DIID__IPlayerEvents: TGUID = '{31D6469C-1DA7-47C0-91F9-38F0C39F9B89}';
  IID_IPlayer: TGUID = '{F19169FA-7EB8-45EB-8800-0D1F7C88F553}';
  CLASS_Player: TGUID = '{A9332148-C691-4B9D-91FC-B9C461DBE9DD}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IPlayerEvents = dispinterface;
  IPlayer = interface;
  IPlayerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Player = IPlayer;


// *********************************************************************//
// DispIntf:  _IPlayerEvents
// Flags:     (4096) Dispatchable
// GUID:      {31D6469C-1DA7-47C0-91F9-38F0C39F9B89}
// *********************************************************************//
  _IPlayerEvents = dispinterface
    ['{31D6469C-1DA7-47C0-91F9-38F0C39F9B89}']
    function OnMessage(nMessage: Integer; wParam: Integer; lParam: Integer): HResult; dispid 1;
    function OnStateChanged(nOldState: Integer; nNewState: Integer): HResult; dispid 2;
    function OnOpenSucceeded: HResult; dispid 3;
    function OnSeekCompleted(nPosition: Integer): HResult; dispid 4;
    function OnBuffer(nPercent: Integer): HResult; dispid 5;
    function OnVideoSizeChanged: HResult; dispid 6;
    function OnDownloadCodec(const strCodecPath: WideString): HResult; dispid 7;
    function OnEvent(nEventCode: Integer; nEventParam: Integer): HResult; dispid 8;
  end;

// *********************************************************************//
// Interface: IPlayer
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F19169FA-7EB8-45EB-8800-0D1F7C88F553}
// *********************************************************************//
  IPlayer = interface(IDispatch)
    ['{F19169FA-7EB8-45EB-8800-0D1F7C88F553}']
    procedure Open(const strUrl: WideString); safecall;
    procedure Close; safecall;
    procedure Play; safecall;
    procedure Pause; safecall;
    function GetVersion: WideString; safecall;
    procedure SetCustomLogo(nLogo: Integer); safecall;
    function GetState: Integer; safecall;
    function GetDuration: Integer; safecall;
    function GetPosition: Integer; safecall;
    function SetPosition(nPosition: Integer): Integer; safecall;
    function GetVideoWidth: Integer; safecall;
    function GetVideoHeight: Integer; safecall;
    function GetVolume: Integer; safecall;
    function SetVolume(nVolume: Integer): Integer; safecall;
    function IsSeeking: Integer; safecall;
    function GetBufferProgress: Integer; safecall;
    function GetConfig(nConfigId: Integer): WideString; safecall;
    function SetConfig(nConfigId: Integer; const strValue: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPlayerDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F19169FA-7EB8-45EB-8800-0D1F7C88F553}
// *********************************************************************//
  IPlayerDisp = dispinterface
    ['{F19169FA-7EB8-45EB-8800-0D1F7C88F553}']
    procedure Open(const strUrl: WideString); dispid 1;
    procedure Close; dispid 2;
    procedure Play; dispid 3;
    procedure Pause; dispid 4;
    function GetVersion: WideString; dispid 5;
    procedure SetCustomLogo(nLogo: Integer); dispid 6;
    function GetState: Integer; dispid 7;
    function GetDuration: Integer; dispid 8;
    function GetPosition: Integer; dispid 9;
    function SetPosition(nPosition: Integer): Integer; dispid 10;
    function GetVideoWidth: Integer; dispid 11;
    function GetVideoHeight: Integer; dispid 12;
    function GetVolume: Integer; dispid 13;
    function SetVolume(nVolume: Integer): Integer; dispid 14;
    function IsSeeking: Integer; dispid 15;
    function GetBufferProgress: Integer; dispid 16;
    function GetConfig(nConfigId: Integer): WideString; dispid 17;
    function SetConfig(nConfigId: Integer; const strValue: WideString): Integer; dispid 18;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TPlayer
// Help String      : APlayer3 Control
// Default Interface: IPlayer
// Def. Intf. DISP? : No
// Event   Interface: _IPlayerEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TPlayerOnMessage = procedure(ASender: TObject; nMessage: Integer; wParam: Integer; lParam: Integer) of object;
  TPlayerOnStateChanged = procedure(ASender: TObject; nOldState: Integer; nNewState: Integer) of object;
  TPlayerOnSeekCompleted = procedure(ASender: TObject; nPosition: Integer) of object;
  TPlayerOnBuffer = procedure(ASender: TObject; nPercent: Integer) of object;
  TPlayerOnDownloadCodec = procedure(ASender: TObject; const strCodecPath: WideString) of object;
  TPlayerOnEvent = procedure(ASender: TObject; nEventCode: Integer; nEventParam: Integer) of object;

  TPlayer = class(TOleControl)
  private
    FOnMessage: TPlayerOnMessage;
    FOnStateChanged: TPlayerOnStateChanged;
    FOnOpenSucceeded: TNotifyEvent;
    FOnSeekCompleted: TPlayerOnSeekCompleted;
    FOnBuffer: TPlayerOnBuffer;
    FOnVideoSizeChanged: TNotifyEvent;
    FOnDownloadCodec: TPlayerOnDownloadCodec;
    FOnEvent: TPlayerOnEvent;
    FIntf: IPlayer;
    function  GetControlInterface: IPlayer;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Open(const strUrl: WideString);
    procedure Close;
    procedure Play;
    procedure Pause;
    function GetVersion: WideString;
    procedure SetCustomLogo(nLogo: Integer);
    function GetState: Integer;
    function GetDuration: Integer;
    function GetPosition: Integer;
    function SetPosition(nPosition: Integer): Integer;
    function GetVideoWidth: Integer;
    function GetVideoHeight: Integer;
    function GetVolume: Integer;
    function SetVolume(nVolume: Integer): Integer;
    function IsSeeking: Integer;
    function GetBufferProgress: Integer;
    function GetConfig(nConfigId: Integer): WideString;
    function SetConfig(nConfigId: Integer; const strValue: WideString): Integer;
    property  ControlInterface: IPlayer read GetControlInterface;
    property  DefaultInterface: IPlayer read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property OnMessage: TPlayerOnMessage read FOnMessage write FOnMessage;
    property OnStateChanged: TPlayerOnStateChanged read FOnStateChanged write FOnStateChanged;
    property OnOpenSucceeded: TNotifyEvent read FOnOpenSucceeded write FOnOpenSucceeded;
    property OnSeekCompleted: TPlayerOnSeekCompleted read FOnSeekCompleted write FOnSeekCompleted;
    property OnBuffer: TPlayerOnBuffer read FOnBuffer write FOnBuffer;
    property OnVideoSizeChanged: TNotifyEvent read FOnVideoSizeChanged write FOnVideoSizeChanged;
    property OnDownloadCodec: TPlayerOnDownloadCodec read FOnDownloadCodec write FOnDownloadCodec;
    property OnEvent: TPlayerOnEvent read FOnEvent write FOnEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

procedure TPlayer.InitControlData;
const
  CEventDispIDs: array [0..7] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008);
  CControlData: TControlData2 = (
    ClassID:      '{A9332148-C691-4B9D-91FC-B9C461DBE9DD}';
    EventIID:     '{31D6469C-1DA7-47C0-91F9-38F0C39F9B89}';
    EventCount:   8;
    EventDispIDs: @CEventDispIDs;
    LicenseKey:   nil (*HR:$80004002*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := UIntPtr(@@FOnMessage) - UIntPtr(Self);
end;

procedure TPlayer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IPlayer;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TPlayer.GetControlInterface: IPlayer;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TPlayer.Open(const strUrl: WideString);
begin
  DefaultInterface.Open(strUrl);
end;

procedure TPlayer.Close;
begin
  DefaultInterface.Close;
end;

procedure TPlayer.Play;
begin
  DefaultInterface.Play;
end;

procedure TPlayer.Pause;
begin
  DefaultInterface.Pause;
end;

function TPlayer.GetVersion: WideString;
begin
  Result := DefaultInterface.GetVersion;
end;

procedure TPlayer.SetCustomLogo(nLogo: Integer);
begin
  DefaultInterface.SetCustomLogo(nLogo);
end;

function TPlayer.GetState: Integer;
begin
  Result := DefaultInterface.GetState;
end;

function TPlayer.GetDuration: Integer;
begin
  Result := DefaultInterface.GetDuration;
end;

function TPlayer.GetPosition: Integer;
begin
  Result := DefaultInterface.GetPosition;
end;

function TPlayer.SetPosition(nPosition: Integer): Integer;
begin
  Result := DefaultInterface.SetPosition(nPosition);
end;

function TPlayer.GetVideoWidth: Integer;
begin
  Result := DefaultInterface.GetVideoWidth;
end;

function TPlayer.GetVideoHeight: Integer;
begin
  Result := DefaultInterface.GetVideoHeight;
end;

function TPlayer.GetVolume: Integer;
begin
  Result := DefaultInterface.GetVolume;
end;

function TPlayer.SetVolume(nVolume: Integer): Integer;
begin
  Result := DefaultInterface.SetVolume(nVolume);
end;

function TPlayer.IsSeeking: Integer;
begin
  Result := DefaultInterface.IsSeeking;
end;

function TPlayer.GetBufferProgress: Integer;
begin
  Result := DefaultInterface.GetBufferProgress;
end;

function TPlayer.GetConfig(nConfigId: Integer): WideString;
begin
  Result := DefaultInterface.GetConfig(nConfigId);
end;

function TPlayer.SetConfig(nConfigId: Integer; const strValue: WideString): Integer;
begin
  Result := DefaultInterface.SetConfig(nConfigId, strValue);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TPlayer]);
end;

end.
