object FResultingTimes: TFResultingTimes
  Left = 373
  Top = 377
  ActiveControl = cmdClose
  Caption = 'Check cuts after cutting'
  ClientHeight = 396
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 430
  Constraints.MinWidth = 600
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvTimeList: TListView
    Left = 360
    Top = 0
    Width = 232
    Height = 352
    Align = alRight
    Columns = <
      item
        Caption = 'Part'
        Width = 33
      end
      item
        Caption = 'From'
        Width = 65
      end
      item
        Caption = 'To'
        Width = 65
      end
      item
        AutoSize = True
        Caption = 'Duration'
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stData
    TabOrder = 1
    ViewStyle = vsReport
    OnCompare = lvTimeListCompare
    OnDblClick = lvTimeListDblClick
  end
  object pnlMovieControl: TPanel
    Left = 0
    Top = 352
    Width = 592
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinWidth = 360
    TabOrder = 2
    DesignSize = (
      592
      44)
    object lblDuration: TLabel
      Left = 364
      Top = 9
      Width = 38
      Height = 26
      Hint = 
        'Double click entry in list to jump <x> seconds before end of par' +
        't.'
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Check duration'
      WordWrap = True
    end
    object Label8: TLabel
      Left = 219
      Top = 10
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Volume'
    end
    object lblPosition: TLabel
      Left = 77
      Top = 10
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pos.'
    end
    object lblSeconds: TLabel
      Left = 454
      Top = 16
      Width = 20
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'sec.'
    end
    object cmdClose: TButton
      Left = 492
      Top = 13
      Width = 95
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 6
      OnClick = cmdCloseClick
    end
    object tbVolume: TTrackBar
      Left = 256
      Top = 7
      Width = 99
      Height = 26
      Anchors = [akTop, akRight]
      Max = 10000
      Frequency = 1000
      Position = 5000
      TabOrder = 3
      OnChange = tbVolumeChange
    end
    object cmdPause: TButton
      Left = 41
      Top = 7
      Width = 27
      Height = 26
      Hint = 'Pause'
      Caption = 'II'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = cmdPauseClick
    end
    object cmdPlay: TButton
      Left = 9
      Top = 7
      Width = 27
      Height = 26
      Hint = 'Play'
      Caption = '>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = cmdPlayClick
    end
    object tbPosition: TDSTrackBar
      Left = 98
      Top = 7
      Width = 112
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      Frequency = 300
      TabOrder = 2
      FilterGraph = FilterGraph
    end
    object edtDuration: TEdit
      Left = 412
      Top = 12
      Width = 23
      Height = 21
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object udDuration: TUpDown
      Left = 435
      Top = 12
      Width = 15
      Height = 21
      Anchors = [akTop, akRight]
      Associate = edtDuration
      Max = 99
      TabOrder = 5
      OnChanging = udDurationChanging
    end
  end
  object pnlVideoWindow: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pnlVideoWindowResize
    DesignSize = (
      360
      352)
    object VideoWindow: TVideoWindow
      Left = 0
      Top = 0
      Width = 355
      Height = 262
      FilterGraph = FilterGraph
      VMROptions.Mode = vmrWindowless
      Color = clBlack
      Anchors = [akLeft, akTop, akRight, akBottom]
      OnClick = VideoWindowClick
    end
  end
  object FilterGraph: TFilterGraph
    GraphEdit = True
    LinearVolume = True
    OnSelectedFilter = FilterGraphSelectedFilter
    Left = 144
    Top = 160
  end
end
