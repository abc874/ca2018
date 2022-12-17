inherited frmCutApplicationMP4Box: TfrmCutApplicationMP4Box
  Height = 210
  Constraints.MinHeight = 210
  object lblCommandLineOptions: TLabel [2]
    Left = 8
    Top = 164
    Width = 109
    Height = 13
    Caption = 'Command Line Options'
  end
  inherited edtPath: TEdit
    Width = 344
  end
  inherited btnBrowsePath: TButton
    Left = 356
  end
  inherited edtTempDir: TEdit
    Width = 344
    Enabled = False
  end
  inherited btnBrowseTempDir: TButton
    Left = 356
    Enabled = False
  end
  object edtCommandLineOptions: TEdit [10]
    Left = 8
    Top = 180
    Width = 344
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
  end
  inherited selectFileDlg: TOpenDialog
    Left = 304
  end
end
