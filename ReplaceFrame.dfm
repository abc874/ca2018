object ReplaceFrame: TReplaceFrame
  Left = 0
  Top = 0
  Width = 802
  Height = 32
  Align = alTop
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    802
    32)
  object sbTest: TSpeedButton
    Left = 725
    Top = 4
    Width = 21
    Height = 21
    Hint = 'Test'
    Anchors = [akTop, akRight]
    Caption = 'T'
    OnClick = sbTestClick
  end
  object sbAdd: TSpeedButton
    Left = 749
    Top = 4
    Width = 21
    Height = 21
    Hint = 'Add'
    Anchors = [akTop, akRight]
    Caption = '+'
    OnClick = sbAddClick
  end
  object sbDel: TSpeedButton
    Left = 773
    Top = 4
    Width = 21
    Height = 21
    Hint = 'Delete'
    Anchors = [akTop, akRight]
    Caption = '-'
    OnClick = sbDelClick
  end
  object lbSearch: TLabel
    Left = 8
    Top = 7
    Width = 33
    Height = 13
    Caption = 'Search'
  end
  object lbReplace: TLabel
    Left = 260
    Top = 7
    Width = 38
    Height = 13
    Caption = 'Replace'
  end
  object edSearch: TEdit
    Left = 49
    Top = 3
    Width = 200
    Height = 21
    TabOrder = 0
  end
  object edReplace: TEdit
    Left = 304
    Top = 4
    Width = 200
    Height = 21
    TabOrder = 1
  end
  object cbRegEx: TCheckBox
    Left = 617
    Top = 5
    Width = 50
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'RegEx'
    TabOrder = 2
  end
  object cbActive: TCheckBox
    Left = 673
    Top = 5
    Width = 50
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Active'
    TabOrder = 3
  end
end
