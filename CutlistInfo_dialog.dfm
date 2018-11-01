object FCutlistInfo: TFCutlistInfo
  Left = 360
  Top = 238
  Width = 580
  Height = 625
  Caption = 'Cutlist Info'
  Color = clBtnFace
  Constraints.MaxHeight = 625
  Constraints.MinHeight = 625
  Constraints.MinWidth = 580
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    572
    591)
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfoCaption: TLabel
    Left = 7
    Top = 7
    Width = 123
    Height = 16
    Caption = 'Infos saved in Cutlist:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
  end
  object lblComment: TLabel
    Left = 7
    Top = 513
    Width = 72
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'User Comment:'
  end
  object lblSuggestedFilename: TLabel
    Left = 7
    Top = 468
    Width = 221
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Suggested movie file name (without extension):'
  end
  object lblFrameRate: TLabel
    Left = 249
    Top = 8
    Width = 88
    Height = 13
    Alignment = taRightJustify
    Caption = 'Frame rate: N/A (-)'
    Layout = tlCenter
  end
  object rgRatingByAuthor: TRadioGroup
    Left = 7
    Top = 33
    Width = 559
    Height = 151
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'How do you rate your cutlist?'
    Items.Strings = (
      
        '&0 - Test, do not use, or dummy cutlist to save only information' +
        ' about the movie (see below)'
      
        '&1 - I trimmed beginning and end, but there may be one or more c' +
        'ommercials still in the movie'
      
        '&2 - All commercials cut out, but I did the cutting very roughly' +
        ' (+/- 5 sec.)'
      '&3 - ... I did the cutting fairly accurate (+/- 1 sec.)'
      '&4 - ... I did the cutting very accurate (to frame)'
      '&5 - ... and I removed duplicate scenes if necessary')
    TabOrder = 1
    OnClick = EnableOK
  end
  object grpDetails: TGroupBox
    Left = 7
    Top = 273
    Width = 559
    Height = 185
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Infos about the movie:'
    TabOrder = 2
    DesignSize = (
      559
      185)
    object edtOtherErrorDescription: TEdit
      Left = 24
      Top = 153
      Width = 523
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
      OnChange = EnableOK
    end
    object edtActualContent: TEdit
      Left = 24
      Top = 39
      Width = 523
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = EnableOK
    end
    object cbEPGError: TJvCheckBox
      Left = 7
      Top = 20
      Width = 385
      Height = 17
      Caption = 
        'Wrong content, EPG error (filename does not match content). Actu' +
        'al content:'
      TabOrder = 0
      OnClick = cbEPGErrorClick
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
    object cbMissingBeginning: TJvCheckBox
      Left = 7
      Top = 67
      Width = 106
      Height = 17
      Caption = 'Missing Beginning'
      TabOrder = 2
      OnClick = EnableOK
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
    object cbMissingEnding: TJvCheckBox
      Left = 7
      Top = 84
      Width = 92
      Height = 17
      Caption = 'Missing Ending'
      TabOrder = 3
      OnClick = EnableOK
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
    object cbMissingVideo: TJvCheckBox
      Left = 7
      Top = 102
      Width = 113
      Height = 17
      Caption = 'Missing Video track'
      TabOrder = 4
      OnClick = EnableOK
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
    object cbMissingAudio: TJvCheckBox
      Left = 7
      Top = 119
      Width = 113
      Height = 17
      Caption = 'Missing Audio track'
      TabOrder = 5
      OnClick = EnableOK
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
    object cbOtherError: TJvCheckBox
      Left = 7
      Top = 136
      Width = 75
      Height = 17
      Caption = 'Other Error:'
      TabOrder = 6
      OnClick = cbOtherErrorClick
      LinkedControls = <>
      HotTrackFont.Charset = ANSI_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Microsoft Sans Serif'
      HotTrackFont.Pitch = fpVariable
      HotTrackFont.Style = []
    end
  end
  object cmdCancel: TButton
    Left = 480
    Top = 561
    Width = 85
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object cmdOk: TButton
    Left = 390
    Top = 561
    Width = 85
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 7
  end
  object edtUserComment: TEdit
    Left = 7
    Top = 533
    Width = 559
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
    OnChange = EnableOK
  end
  object pnlAuthor: TPanel
    Left = 7
    Top = 560
    Width = 376
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 6
    object lblAuthor: TLabel
      Left = 2
      Top = 5
      Width = 372
      Height = 18
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'Cutlist Author unknown'
      Color = clNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
  end
  object edtMovieName: TEdit
    Left = 7
    Top = 487
    Width = 422
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    OnChange = EnableOK
  end
  object cmdMovieNameCopy: TButton
    Left = 435
    Top = 486
    Width = 131
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Copy from Filename'
    TabOrder = 4
    OnClick = cmdMovieNameCopyClick
  end
  object cbFramesPresent: TJvCheckBox
    Left = 434
    Top = 8
    Width = 131
    Height = 17
    TabStop = False
    Anchors = [akTop, akRight]
    Caption = 'Frame numbers present'
    Enabled = False
    TabOrder = 0
    LinkedControls = <>
    HotTrackFont.Charset = ANSI_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Microsoft Sans Serif'
    HotTrackFont.Pitch = fpVariable
    HotTrackFont.Style = []
  end
  object grpServerRating: TGroupBox
    Left = 8
    Top = 191
    Width = 557
    Height = 77
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Cutlist Server'
    TabOrder = 9
    DesignSize = (
      557
      77)
    object lblRatingOnServer: TLabel
      Left = 52
      Top = 20
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = 'Average Rating:'
    end
    object lblRatingCountOnServer: TLabel
      Left = 223
      Top = 20
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Count of Ratings:'
    end
    object lblDownloadTime: TLabel
      Left = 54
      Top = 48
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = 'Downloaded at:'
    end
    object lblRatingSent: TLabel
      Left = 422
      Top = 20
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'User Rating:'
    end
    object edtRatingOnServer: TEdit
      Left = 132
      Top = 16
      Width = 60
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edtRatingCountOnServer: TEdit
      Left = 308
      Top = 16
      Width = 60
      Height = 21
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 1
    end
    object edtDownloadTime: TEdit
      Left = 132
      Top = 44
      Width = 237
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 2
    end
    object edtRatingSent: TEdit
      Left = 484
      Top = 16
      Width = 60
      Height = 21
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 3
    end
  end
end
