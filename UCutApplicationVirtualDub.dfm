inherited frmCutApplicationVirtualDub: TfrmCutApplicationVirtualDub
  Width = 435
  Height = 243
  Constraints.MinHeight = 210
  Constraints.MinWidth = 435
  DesignSize = (
    435
    243)
  inherited edtPath: TEdit
    Width = 398
  end
  inherited btnBrowsePath: TButton
    Left = 407
  end
  inherited edtTempDir: TEdit
    Width = 398
  end
  inherited btnBrowseTempDir: TButton
    Left = 407
  end
  object cbNotClose: TJvCheckBox [6]
    Left = 6
    Top = 164
    Width = 275
    Height = 17
    Caption = 'Do not close virtualdub after cutting (not for vdub.exe)'
    TabOrder = 4
    LinkedControls = <>
  end
  object cbUseSmartRendering: TJvCheckBox [7]
    Left = 6
    Top = 187
    Width = 275
    Height = 17
    Caption = 'Use Smart Rendering (only VirtualDub.exe 1.7 or later)'
    TabOrder = 5
    LinkedControls = <>
  end
  object cbShowProgressWindow: TJvCheckBox [8]
    Left = 6
    Top = 210
    Width = 134
    Height = 17
    Caption = 'Show Progress Window'
    Checked = True
    State = cbChecked
    TabOrder = 9
    LinkedControls = <>
  end
  inherited cbRedirectOutput: TJvCheckBox
    TabOrder = 6
  end
  inherited cbShowAppWindow: TJvCheckBox
    TabOrder = 7
  end
  inherited cbCleanUp: TJvCheckBox
    TabOrder = 8
  end
  inherited selectFileDlg: TOpenDialog
    Left = 364
    Top = 144
  end
end
