object FManageFilters: TFManageFilters
  Left = 372
  Top = 359
  AutoScroll = False
  Caption = 'Filters'
  ClientHeight = 359
  ClientWidth = 800
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    800
    359)
  PixelsPerInch = 96
  TextHeight = 13
  object lblClickOnFilter: TLabel
    Left = 148
    Top = 326
    Width = 103
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = 'Double Click on Filter to show properties'
    WordWrap = True
  end
  object cmdRemove: TButton
    Left = 4
    Top = 330
    Width = 131
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Remove from FilterGraph'
    Enabled = False
    TabOrder = 0
    Visible = False
    OnClick = cmdRemoveClick
  end
  object cmdClose: TButton
    Left = 735
    Top = 330
    Width = 61
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdCloseClick
  end
  object lvFilters: TListBox
    Left = 0
    Top = 0
    Width = 800
    Height = 317
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpVariable
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 2
    OnClick = lvFiltersClick
    OnDblClick = lvFiltersDblClick
  end
  object cmdCopy: TButton
    Left = 627
    Top = 330
    Width = 102
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Copy to clipboard'
    Default = True
    TabOrder = 3
    OnClick = cmdCopyClick
  end
  object chkShowPinInfo: TJvCheckBox
    Left = 496
    Top = 334
    Width = 87
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Show Pin Info'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = chkShowPinInfoClick
    LinkedControls = <>
    HotTrackFont.Charset = ANSI_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Microsoft Sans Serif'
    HotTrackFont.Pitch = fpVariable
    HotTrackFont.Style = []
  end
end
