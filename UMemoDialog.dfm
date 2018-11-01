object frmMemoDialog: TfrmMemoDialog
  Left = 733
  Top = 218
  ActiveControl = cmdClose
  AutoScroll = False
  Caption = 'Cut Assistant'
  ClientHeight = 393
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    429
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object cmdClose: TButton
    Left = 330
    Top = 362
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdCloseClick
  end
  object memInfo: TMemo
    Left = 0
    Top = 0
    Width = 429
    Height = 357
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
end
