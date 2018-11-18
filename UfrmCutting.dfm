object frmCutting: TfrmCutting
  Left = 286
  Top = 125
  BorderIcons = [biMaximize]
  Caption = 'Cutting ...'
  ClientHeight = 440
  ClientWidth = 703
  Color = clBtnFace
  Constraints.MinHeight = 260
  Constraints.MinWidth = 500
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    703
    440)
  PixelsPerInch = 96
  TextHeight = 13
  object memOutput: TMemo
    Left = 6
    Top = 6
    Width = 691
    Height = 397
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnClick = memOutputClick
  end
  object cmdClose_nl: TButton
    Left = 592
    Top = 409
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    Enabled = False
    TabOrder = 4
  end
  object cmdAbort: TButton
    Left = 473
    Top = 409
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Abort'
    TabOrder = 3
    OnClick = cmdAbortClick
  end
  object cmdCopyClipbrd: TButton
    Left = 6
    Top = 409
    Width = 155
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Copy to Clip&board'
    TabOrder = 1
    OnClick = cmdCopyClipbrdClick
  end
  object cmdEmergencyExit: TButton
    Left = 362
    Top = 409
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Terminate Now!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = cmdEmergencyExitClick
  end
  object timAutoClose: TTimer
    Enabled = False
    Interval = 250
    OnTimer = timAutoCloseTimer
    Left = 116
    Top = 312
  end
end
