object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'AniToon - Watch Dubbed Anime'
  ClientHeight = 422
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 73
    Width = 649
    Height = 305
    Align = alClient
    TabOrder = 3
    OnDownloadComplete = WebBrowser1DownloadComplete
    OnDocumentComplete = WebBrowser1DocumentComplete
    ExplicitLeft = -115
    ExplicitTop = 88
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C00000013430000861F00000100000001020000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 369
    Top = 189
    Width = 256
    Height = 144
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 403
    Width = 649
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
    ExplicitTop = 364
    ExplicitWidth = 633
  end
  object Button1: TButton
    Left = 0
    Top = 378
    Width = 649
    Height = 25
    Align = alBottom
    Caption = 'Play'
    TabOrder = 1
    OnClick = Button1Click
    ExplicitTop = 339
    ExplicitWidth = 633
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 649
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Menu Fluent Design'
    TabOrder = 4
    ExplicitWidth = 633
  end
  object OpenDialog1: TOpenDialog
    Left = 312
    Top = 200
  end
end
