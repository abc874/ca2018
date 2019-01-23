object FSettings: TFSettings
  Left = 378
  Top = 243
  BorderIcons = []
  Caption = 'Settings'
  ClientHeight = 359
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 590
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pgSettings: TPageControl
    Left = 0
    Top = 0
    Width = 784
    Height = 333
    ActivePage = tabUserData
    Align = alClient
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 0
    object tabUserData: TTabSheet
      Caption = 'General'
      ImageIndex = 4
      DesignSize = (
        776
        302)
      object lblUsername: TLabel
        Left = 20
        Top = 6
        Width = 102
        Height = 13
        Alignment = taRightJustify
        Caption = 'User Name (optional):'
      end
      object lblUserID: TLabel
        Left = 39
        Top = 33
        Width = 83
        Height = 13
        Alignment = taRightJustify
        Caption = 'User ID (random):'
      end
      object lblFramesSize: TLabel
        Left = 29
        Top = 60
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = 'Frame preview size:'
      end
      object lblFramesSizex_nl: TLabel
        Left = 156
        Top = 60
        Width = 19
        Height = 13
        AutoSize = False
        Caption = 'px x'
      end
      object lblFramesCount: TLabel
        Left = 20
        Top = 87
        Width = 102
        Height = 13
        Alignment = taRightJustify
        Caption = 'Frame preview count:'
      end
      object lblFramesSizeChangeHint: TLabel
        Left = 226
        Top = 60
        Width = 114
        Height = 13
        Caption = '(change requires restart)'
      end
      object lblFramesCountChangeHint: TLabel
        Left = 226
        Top = 87
        Width = 114
        Height = 13
        Caption = '(change requires restart)'
      end
      object lblSmallSkip: TLabel
        Left = 50
        Top = 114
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = 'Small skip time:'
      end
      object lblLargeSkip: TLabel
        Left = 49
        Top = 141
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Large skip time:'
      end
      object lblSmallSkipSecs: TLabel
        Left = 156
        Top = 114
        Width = 15
        Height = 14
        AutoSize = False
        Caption = 's'
      end
      object lblLargeSkipSecs: TLabel
        Left = 156
        Top = 141
        Width = 15
        Height = 14
        AutoSize = False
        Caption = 's'
      end
      object lblFramesSizey_nl: TLabel
        Left = 208
        Top = 60
        Width = 11
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'px'
      end
      object lblNetTimeout: TLabel
        Left = 43
        Top = 168
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'Network timeout:'
      end
      object lblNetTimeoutSecs: TLabel
        Left = 156
        Top = 168
        Width = 15
        Height = 14
        AutoSize = False
        Caption = 's'
      end
      object lblLanguage: TLabel
        Left = 72
        Top = 202
        Width = 51
        Height = 13
        Alignment = taRightJustify
        Caption = 'Language:'
      end
      object lblLanguageChangeHint: TLabel
        Left = 568
        Top = 203
        Width = 114
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '(change requires restart)'
      end
      object edtUserName_nl: TEdit
        Left = 128
        Top = 3
        Width = 639
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object edtUserID_nl: TEdit
        Left = 128
        Top = 30
        Width = 639
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object edtFrameWidth_nl: TEdit
        Left = 128
        Top = 57
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 3
        TabOrder = 2
        Text = '180'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object edtFrameHeight_nl: TEdit
        Left = 180
        Top = 57
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 3
        TabOrder = 3
        Text = '135'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object edtFrameCount_nl: TEdit
        Left = 128
        Top = 84
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 2
        TabOrder = 4
        Text = '12'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object rgCutMode: TRadioGroup
        Left = 492
        Top = 60
        Width = 275
        Height = 45
        Hint = 
          'Cut out: New file is everything except cuts.'#13#10'Trim: New file is ' +
          'sum of cuts.'
        Caption = 'Default Cut Mode'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Cut out'
          'Trim')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
      object edtLargeSkip_nl: TEdit
        Left = 128
        Top = 138
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 2
        TabOrder = 6
        Text = '25'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object edtSmallSkip_nl: TEdit
        Left = 128
        Top = 111
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 2
        TabOrder = 5
        Text = '2'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object edtNetTimeout_nl: TEdit
        Left = 128
        Top = 165
        Width = 26
        Height = 21
        AutoSize = False
        MaxLength = 2
        TabOrder = 7
        Text = '20'
        OnExit = edtFrameWidth_nlExit
        OnKeyPress = edtProxyPort_nlKeyPress
      end
      object cmbLanguage_nl: TComboBox
        Left = 128
        Top = 199
        Width = 435
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemIndex = 0
        TabOrder = 14
        Text = ' Standard'
        Items.Strings = (
          ' Standard')
      end
      object cbAutoMuteOnSeek: TJvCheckBox
        Left = 227
        Top = 139
        Width = 110
        Height = 17
        Caption = 'Auto mute on seek'
        TabOrder = 8
        LinkedControls = <>
      end
      object cbExceptionLogging: TJvCheckBox
        Left = 227
        Top = 166
        Width = 105
        Height = 17
        Caption = 'Exception logging'
        TabOrder = 9
        LinkedControls = <>
      end
      object cbNoRateSuccMsg: TJvCheckBox
        Left = 486
        Top = 139
        Width = 166
        Height = 17
        Caption = 'Suppress rating done message'
        TabOrder = 12
        LinkedControls = <>
      end
      object cbNoWarnUseRate: TJvCheckBox
        Left = 486
        Top = 166
        Width = 186
        Height = 17
        Caption = 'Suppress rating proposed message'
        TabOrder = 13
        LinkedControls = <>
      end
      object cbNewNextFrameMethod: TJvCheckBox
        Left = 486
        Top = 112
        Width = 153
        Height = 17
        Caption = 'Use new next frame method'
        TabOrder = 11
        LinkedControls = <>
      end
    end
    object tabSaveMovie: TTabSheet
      Caption = 'Save movie'
      ImageIndex = 1
      DesignSize = (
        776
        302)
      object lblCutMovieExtension: TLabel
        Left = 3
        Top = 68
        Width = 190
        Height = 13
        Caption = 'Automatically insert before file extension:'
        WordWrap = True
      end
      object rgSaveCutMovieMode: TRadioGroup
        Left = 3
        Top = 3
        Width = 765
        Height = 56
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Save cut movie:'
        ItemIndex = 0
        Items.Strings = (
          'with source movie'
          'always in this directory:')
        TabOrder = 0
      end
      object edtCutMovieSaveDir_nl: TEdit
        Left = 142
        Top = 34
        Width = 584
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object edtCutMovieExtension_nl: TEdit
        Left = 212
        Top = 65
        Width = 555
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        Text = '.cut'
      end
      object cmdCutMovieSaveDir: TButton
        Left = 732
        Top = 34
        Width = 27
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 2
        OnClick = cmdCutMovieSaveDirClick
      end
      object cbMovieNameAlwaysConfirm: TJvCheckBox
        Left = 3
        Top = 112
        Width = 201
        Height = 17
        Caption = 'Always confirm filename before cutting'
        TabOrder = 5
        LinkedControls = <>
      end
      object cbUseMovieNameSuggestion: TJvCheckBox
        Left = 3
        Top = 92
        Width = 264
        Height = 17
        Caption = 'Use movie file name suggested by cutlist (if present)'
        TabOrder = 4
        LinkedControls = <>
      end
      object cbAutoSearchCutlists: TJvCheckBox
        Left = 3
        Top = 132
        Width = 264
        Height = 17
        Caption = 'Automatically search for cutlists after opening movie'
        TabOrder = 6
        LinkedControls = <>
      end
    end
    object tabSaveCutlist: TTabSheet
      Caption = 'Save cutlist'
      ImageIndex = 2
      DesignSize = (
        776
        302)
      object rgSaveCutlistMode: TRadioGroup
        Left = 3
        Top = 3
        Width = 764
        Height = 56
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Save cutlist:'
        ItemIndex = 0
        Items.Strings = (
          'with source movie'
          'always in this directory:')
        TabOrder = 0
      end
      object edtCutListSaveDir_nl: TEdit
        Left = 142
        Top = 34
        Width = 583
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object cmdCutlistSaveDir: TButton
        Left = 731
        Top = 34
        Width = 27
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 2
        OnClick = cmdCutlistSaveDirClick
      end
      object cbCutlistNameAlwaysConfirm: TJvCheckBox
        Left = 3
        Top = 86
        Width = 200
        Height = 17
        Caption = 'Always confirm filename before saving'
        TabOrder = 4
        LinkedControls = <>
      end
      object cbCutlistAutoSaveBeforeCutting: TJvCheckBox
        Left = 3
        Top = 106
        Width = 137
        Height = 17
        Caption = 'Auto save before cutting'
        TabOrder = 5
        LinkedControls = <>
      end
      object cbSearchLocalCutlists: TJvCheckBox
        Left = 3
        Top = 126
        Width = 325
        Height = 17
        Caption = 
          'Include cutlist standard directory when auto-searching for cutli' +
          'sts'
        TabOrder = 6
        LinkedControls = <>
      end
      object cbAutoSaveDownloadedCutlists: TJvCheckBox
        Left = 3
        Top = 66
        Width = 208
        Height = 17
        Caption = 'Automatically save downloaded cutlists.'
        Checked = True
        State = cbChecked
        TabOrder = 3
        LinkedControls = <>
      end
    end
    object tabURLs: TTabSheet
      Caption = 'URLs'
      ImageIndex = 3
      Constraints.MinHeight = 210
      DesignSize = (
        776
        302)
      object lblServerUrl: TLabel
        Left = 66
        Top = 6
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cutlist Server'
      end
      object lblInfoUrl: TLabel
        Left = 27
        Top = 60
        Width = 101
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut Assistant Info File'
      end
      object lblHelpUrl: TLabel
        Left = 82
        Top = 87
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wiki Help'
      end
      object lblUploadUrl: TLabel
        Left = 3
        Top = 33
        Width = 125
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cutlist Server Upload Form'
      end
      object edtURL_Cutlist_Home_nl: TEdit
        Left = 134
        Top = 3
        Width = 633
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object edtURL_Info_File_nl: TEdit
        Left = 134
        Top = 57
        Width = 633
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
      end
      object edtURL_Cutlist_Upload_nl: TEdit
        Left = 134
        Top = 30
        Width = 633
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object edtURL_Help_nl: TEdit
        Left = 134
        Top = 84
        Width = 633
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
      end
      object grpProxy: TGroupBox
        Left = 3
        Top = 164
        Width = 764
        Height = 92
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Proxy Prameters'
        TabOrder = 6
        DesignSize = (
          764
          92)
        object lblProxyServer: TLabel
          Left = 34
          Top = 22
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = 'Server'
        end
        object lblProxyPort: TLabel
          Left = 680
          Top = 22
          Width = 19
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Port'
        end
        object lblProxyPass: TLabel
          Left = 551
          Top = 49
          Width = 46
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Password'
        end
        object lblProxyUser: TLabel
          Left = 12
          Top = 49
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = 'User Name'
        end
        object lblProxyPassWarning: TLabel
          Left = 485
          Top = 72
          Width = 266
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Warning: Password will be saved in settings in clear text!'
        end
        object edtProxyServerName_nl: TEdit
          Left = 71
          Top = 19
          Width = 585
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
        end
        object edtProxyPort_nl: TEdit
          Left = 705
          Top = 18
          Width = 46
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          Text = '0'
          OnKeyPress = edtProxyPort_nlKeyPress
        end
        object edtProxyPassword_nl: TEdit
          Left = 603
          Top = 45
          Width = 148
          Height = 21
          Anchors = [akTop, akRight]
          PasswordChar = '*'
          TabOrder = 2
        end
        object edtProxyUserName_nl: TEdit
          Left = 71
          Top = 46
          Width = 452
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
        end
      end
      object cbSearchServerCutlists: TJvCheckBox
        Left = 135
        Top = 116
        Width = 255
        Height = 17
        Caption = 'Use Cutlist server when auto-searching for cutlists'
        Checked = True
        State = cbChecked
        TabOrder = 4
        LinkedControls = <>
      end
      object cbSearchCutlistsByName: TJvCheckBox
        Left = 135
        Top = 140
        Width = 188
        Height = 17
        Caption = 'Additionally search Cutlists by name'
        Checked = True
        State = cbChecked
        TabOrder = 5
        LinkedControls = <>
      end
    end
    object tabInfoCheck: TTabSheet
      Caption = 'Info Check'
      ImageIndex = 9
      object grpInfoCheck: TGroupBox
        Left = 3
        Top = 23
        Width = 286
        Height = 106
        TabOrder = 1
        object lblCheckInterval: TLabel
          Left = 13
          Top = 22
          Width = 209
          Height = 13
          Alignment = taRightJustify
          Caption = 'Days between checking for Infos on server: '
        end
        object ECheckInfoInterval_nl: TEdit
          Left = 244
          Top = 19
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '0'
          OnKeyPress = ECheckInfoInterval_nlKeyPress
        end
        object CBInfoCheckStable: TJvCheckBox
          Left = 13
          Top = 65
          Width = 210
          Height = 17
          Caption = 'Check on server for new stable versions'
          TabOrder = 2
          LinkedControls = <>
        end
        object CBInfoCheckBeta: TJvCheckBox
          Left = 13
          Top = 84
          Width = 203
          Height = 17
          Caption = 'Check on server for new beta versions'
          TabOrder = 3
          LinkedControls = <>
        end
        object CBInfoCheckMessages: TJvCheckBox
          Left = 13
          Top = 46
          Width = 164
          Height = 17
          Caption = 'Check on server for messages'
          TabOrder = 1
          LinkedControls = <>
        end
      end
      object CBInfoCheckEnabled: TJvCheckBox
        Left = 3
        Top = 3
        Width = 179
        Height = 17
        Caption = 'Check Infos on Server on Startup'
        TabOrder = 0
        LinkedControls = <>
      end
    end
    object TabExternalCutApplication: TTabSheet
      Caption = 'External cut application'
      DesignSize = (
        776
        302)
      object lblCutWithWMV: TLabel
        Left = 3
        Top = 24
        Width = 144
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut Windows Media Files with:'
      end
      object lblCutWithAvi: TLabel
        Left = 62
        Top = 51
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut AVI Files with:'
      end
      object lblCutWithOther: TLabel
        Left = 42
        Top = 133
        Width = 105
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut all other Files with:'
      end
      object lblSelectCutApplication: TLabel
        Left = 3
        Top = 0
        Width = 299
        Height = 13
        Caption = 'Please select the Cut Application for each File Type:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCutWithMP4: TLabel
        Left = 40
        Top = 106
        Width = 107
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut MP4 Iso Files with:'
      end
      object lblAutoCloseCuttingWindow: TLabel
        Left = 31
        Top = 162
        Width = 274
        Height = 13
        Alignment = taRightJustify
        Caption = 'Automatically close cutting window after (use 0 to disable):'
      end
      object lblWaitTimeout: TLabel
        Left = 382
        Top = 162
        Width = 5
        Height = 13
        Caption = 's'
      end
      object lblSmartRenderingCodec: TLabel
        Left = 314
        Top = 1
        Width = 208
        Height = 13
        Caption = 'For Smart Rendering use this Codec:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCutWithHQAvi: TLabel
        Left = 43
        Top = 79
        Width = 104
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cut HQ-AVI Files with:'
      end
      object CBWmvApp_nl: TComboBox
        Left = 153
        Top = 21
        Width = 152
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbCutAppChange
        Items.Strings = (
          '')
      end
      object CBAviApp_nl: TComboBox
        Left = 153
        Top = 48
        Width = 152
        Height = 21
        Style = csDropDownList
        TabOrder = 4
        OnChange = cbCutAppChange
        Items.Strings = (
          '')
      end
      object CBOtherApp_nl: TComboBox
        Left = 153
        Top = 130
        Width = 152
        Height = 21
        Style = csDropDownList
        TabOrder = 16
        OnChange = cbCutAppChange
        Items.Strings = (
          '')
      end
      object cbMP4App_nl: TComboBox
        Left = 153
        Top = 103
        Width = 152
        Height = 21
        Style = csDropDownList
        TabOrder = 12
        OnChange = cbCutAppChange
        Items.Strings = (
          '')
      end
      object spnWaitTimeout: TJvSpinEdit
        Left = 314
        Top = 158
        Width = 65
        Height = 21
        CheckMinValue = True
        Alignment = taRightJustify
        ButtonKind = bkStandard
        Decimal = 0
        Value = 20.000000000000000000
        TabOrder = 20
      end
      object cmbCodecWmv_nl: TComboBox
        Left = 314
        Top = 21
        Width = 359
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = cmbCodecChange
      end
      object btnCodecConfigWmv: TButton
        Left = 679
        Top = 21
        Width = 65
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Config'
        TabOrder = 2
        OnClick = btnCodecConfigClick
      end
      object btnCodecAboutWmv: TButton
        Left = 750
        Top = 21
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '?'
        TabOrder = 3
        OnClick = btnCodecAboutClick
      end
      object cmbCodecAvi_nl: TComboBox
        Left = 314
        Top = 48
        Width = 359
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnChange = cmbCodecChange
      end
      object btnCodecConfigAvi: TButton
        Left = 679
        Top = 48
        Width = 65
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Config'
        TabOrder = 6
        OnClick = btnCodecConfigClick
      end
      object btnCodecAboutAvi: TButton
        Left = 750
        Top = 48
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '?'
        TabOrder = 7
        OnClick = btnCodecAboutClick
      end
      object cmbCodecMP4_nl: TComboBox
        Left = 314
        Top = 103
        Width = 359
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 13
        OnChange = cmbCodecChange
      end
      object btnCodecConfigMP4: TButton
        Left = 679
        Top = 103
        Width = 65
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Config'
        TabOrder = 14
        OnClick = btnCodecConfigClick
      end
      object btnCodecAboutMP4: TButton
        Left = 750
        Top = 103
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '?'
        TabOrder = 15
        OnClick = btnCodecAboutClick
      end
      object cmbCodecOther_nl: TComboBox
        Left = 314
        Top = 130
        Width = 359
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 17
        OnChange = cmbCodecChange
      end
      object btnCodecConfigOther: TButton
        Left = 679
        Top = 130
        Width = 65
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Config'
        TabOrder = 18
        OnClick = btnCodecConfigClick
      end
      object btnCodecAboutOther: TButton
        Left = 750
        Top = 130
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '?'
        TabOrder = 19
        OnClick = btnCodecAboutClick
      end
      object CBHQAviApp_nl: TComboBox
        Left = 153
        Top = 76
        Width = 152
        Height = 21
        Style = csDropDownList
        TabOrder = 10
        OnChange = cbCutAppChange
        Items.Strings = (
          '')
      end
      object cmbCodecHQAvi_nl: TComboBox
        Left = 314
        Top = 76
        Width = 359
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 11
        OnChange = cmbCodecChange
      end
      object btnCodecConfigHQAvi: TButton
        Left = 679
        Top = 75
        Width = 65
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Config'
        TabOrder = 8
        OnClick = btnCodecConfigClick
      end
      object btnCodecAboutHQAvi: TButton
        Left = 749
        Top = 75
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '?'
        TabOrder = 9
        OnClick = btnCodecAboutClick
      end
    end
    object tabSourceFilter: TTabSheet
      Caption = 'Source Filter'
      ImageIndex = 8
      Constraints.MinHeight = 250
      Constraints.MinWidth = 548
      OnShow = tabSourceFilterShow
      DesignSize = (
        776
        302)
      object lblSourceFilter: TLabel
        Left = 3
        Top = 9
        Width = 105
        Height = 13
        Caption = 'Preferred Source Filter'
      end
      object lblSourceFilterAvi: TLabel
        Left = 63
        Top = 66
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'for AVI files'
      end
      object lblSourceFilterMP4: TLabel
        Left = 41
        Top = 120
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'for MP4 Iso files'
      end
      object lblSourceFilterOther: TLabel
        Left = 41
        Top = 148
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'for all Other files'
      end
      object lblSourceFilterWmv: TLabel
        Left = 4
        Top = 38
        Width = 112
        Height = 13
        Alignment = taRightJustify
        Caption = 'for Windows Media files'
      end
      object lblBlacklist: TLabel
        Left = 52
        Top = 175
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Filter Blacklist'
      end
      object lblSourceFilterHQAvi: TLabel
        Left = 44
        Top = 93
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = 'for HQ AVI files'
      end
      object pnlPleaseWait_nl: TPanel
        Left = 122
        Top = 3
        Width = 518
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Checking Filters. Please Wait...'
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
      object cmbSourceFilterListAVI_nl: TComboBox
        Left = 122
        Top = 63
        Width = 646
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '(none)'
        OnChange = cmbSourceFilterListChange
      end
      object cmbSourceFilterListMP4_nl: TComboBox
        Left = 122
        Top = 117
        Width = 646
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = '(none)'
        OnChange = cmbSourceFilterListChange
      end
      object cmbSourceFilterListOther_nl: TComboBox
        Left = 122
        Top = 145
        Width = 646
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Text = '(none)'
        OnChange = cmbSourceFilterListChange
      end
      object cmdRefreshFilterList: TButton
        Left = 646
        Top = 6
        Width = 121
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Refresh Filter List'
        TabOrder = 1
        OnClick = cmdRefreshFilterListClick
      end
      object cmbSourceFilterListWMV_nl: TComboBox
        Left = 122
        Top = 35
        Width = 646
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '(none)'
        OnChange = cmbSourceFilterListChange
      end
      object lbchkBlackList_nl: TCheckListBox
        Left = 122
        Top = 173
        Width = 645
        Height = 119
        OnClickCheck = lbchkBlackList_nlClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 7
      end
      object cmbSourceFilterListHQAVI_nl: TComboBox
        Left = 122
        Top = 90
        Width = 646
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = '(none)'
        OnChange = cmbSourceFilterListChange
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 333
    Width = 784
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      784
      26)
    object cmdCancel: TButton
      Left = 693
      Top = 0
      Width = 85
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object cmdOK: TButton
      Left = 602
      Top = 0
      Width = 85
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end
