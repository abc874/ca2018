object FUploadList: TFUploadList
  Left = 334
  Top = 396
  Caption = 'Uploaded Cutlists'
  ClientHeight = 288
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 254
    Width = 797
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      797
      34)
    object cmdCancel: TButton
      Left = 697
      Top = 6
      Width = 95
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object cmdDelete: TButton
      Left = 596
      Top = 6
      Width = 95
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Delete'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object lvLinklist: TListView
    Left = 0
    Top = 0
    Width = 797
    Height = 254
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 41
      end
      item
        Caption = 'File'
        Width = 488
      end
      item
        Caption = 'Date'
        Width = 122
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
  end
end
