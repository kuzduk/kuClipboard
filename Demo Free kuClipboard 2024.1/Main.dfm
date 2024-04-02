object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'kuClipboard DEMO'
  ClientHeight = 536
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    714
    536)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 14
    Width = 698
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'E:\! SOFT\Delphi Turbo'
    ExplicitWidth = 640
  end
  object Label2: TLabel
    Left = 376
    Top = 427
    Width = 241
    Height = 100
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 
      #1055#1088#1080#1084#1077#1088' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103' '#1074#1099#1088#1077#1079#1072#1085#1080#1103' '#1092#1072#1081#1083#1086#1074'/'#1087#1072#1087#1086#1082' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072'.    '#1042#1099#1076 +
      #1077#1083#1080#1090#1077' '#1074' '#1089#1080#1085#1077#1084' '#1086#1082#1085#1077' '#1092#1072#1081#1083#1099' '#1080' '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091'  Copy '#1080#1083#1080' Cut - '#1092#1072#1081#1083#1099' ' +
      #1086#1090#1087#1088#1072#1074#1103#1090#1089#1103' '#1074' '#1073#1091#1092#1077#1088', '#1080' '#1087#1086#1090#1086#1084' '#1080#1093' '#1084#1086#1078#1085#1086' '#1073#1091#1076#1077#1090' '#1074#1089#1090#1072#1074#1080#1090#1100' '#1074' '#1083#1102#1073#1086#1084' '#1092#1072#1081#1083 +
      #1086#1074#1086#1084' '#1084#1077#1085#1077#1076#1078#1077#1088#1077', '#1085#1072#1087#1088#1080#1084#1077#1088' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1077', Ctrl+V.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object FileListBox1: TFileListBox
    Left = 255
    Top = 40
    Width = 451
    Height = 369
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16777183
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object btnMail: TButton
    Left = 8
    Top = 437
    Width = 171
    Height = 26
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'kuzduk@mail.ru'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 121
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnMailClick
  end
  object btnSait: TButton
    Left = 8
    Top = 469
    Width = 171
    Height = 27
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'autor'#39's site'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 121
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnSaitClick
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 40
    Width = 241
    Height = 369
    Anchors = [akLeft, akTop, akBottom]
    DirLabel = Label1
    FileList = FileListBox1
    ItemHeight = 16
    TabOrder = 3
  end
  object btnCopy: TButton
    Left = 255
    Top = 419
    Width = 100
    Height = 32
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Copy'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 121
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnCopyClick
  end
  object btnCut: TButton
    Left = 255
    Top = 457
    Width = 100
    Height = 32
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Cut'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 121
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnCutClick
  end
  object btnPaste: TButton
    Left = 255
    Top = 495
    Width = 100
    Height = 32
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Paste'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 121
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnPasteClick
  end
end
