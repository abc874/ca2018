object FCutlistRate: TFCutlistRate
  Left = 371
  Top = 160
  ActiveControl = RGRatingByAuthor
  BorderStyle = bsDialog
  Caption = 'Cutlist Rating'
  ClientHeight = 223
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    572
    223)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSendRating: TLabel
    Left = 7
    Top = 7
    Width = 172
    Height = 16
    Caption = 'Send Cutlist Rating to Server:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
  end
  object RGRatingByAuthor: TRadioGroup
    Left = 7
    Top = 33
    Width = 560
    Height = 156
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'How do you rate this cutlist?'
    Items.Strings = (
      
        '&0 - Test, do not use, or dummy cutlist to save only information' +
        ' about the movie'
      
        '&1 - Trimmed beginning and end, but there are one or more commer' +
        'cials still in the movie'
      
        '&2 - All commercials cut out, but cutting was done very roughly ' +
        '(+/- 5 sec.)'
      '&3 - ... cutting was done fairly accurately (+/- 1 sec.)'
      '&4 - ... cutting was done very accurately (to frame)'
      
        '&5 - ... perfect! (Duplicate scenes have been removed if necessa' +
        'ry)')
    TabOrder = 0
    OnClick = RGRatingByAuthorClick
  end
  object cmdCancel: TButton
    Left = 482
    Top = 196
    Width = 85
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cmdOk: TButton
    Left = 392
    Top = 196
    Width = 85
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
end
