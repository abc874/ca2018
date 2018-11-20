object FManageFilters: TFManageFilters
  Left = 372
  Top = 359
  Caption = 'Filters'
  ClientHeight = 506
  ClientWidth = 784
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
    784
    506)
  PixelsPerInch = 96
  TextHeight = 13
  object lblClickOnFilter: TLabel
    Left = 180
    Top = 482
    Width = 189
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Double Click on Filter to show properties'
  end
  object cmdRemove: TButton
    Left = 4
    Top = 477
    Width = 165
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'Remove from FilterGraph'
    Enabled = False
    TabOrder = 0
    Visible = False
    OnClick = cmdRemoveClick
  end
  object cmdClose: TButton
    Left = 688
    Top = 477
    Width = 92
    Height = 23
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
    Width = 784
    Height = 464
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpVariable
    Font.Style = []
    MultiSelect = True
    ParentFont = False
    TabOrder = 2
    OnClick = lvFiltersClick
    OnDblClick = lvFiltersDblClick
  end
  object cmdCopy: TButton
    Left = 579
    Top = 477
    Width = 102
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Copy to clipboard'
    TabOrder = 3
    OnClick = cmdCopyClick
  end
  object chkShowPinInfo: TJvCheckBox
    Left = 424
    Top = 480
    Width = 87
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Show Pin Info'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = chkShowPinInfoClick
    LinkedControls = <>
  end
end
