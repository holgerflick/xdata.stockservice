object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'XData Web Services'
  ClientHeight = 405
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    697
    405)
  TextHeight = 19
  object txtLog: TMemo
    Left = 8
    Top = 64
    Width = 681
    Height = 333
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object btStart: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 50
    Caption = 'Start'
    TabOrder = 1
    OnClick = btStartClick
  end
  object btStop: TButton
    Left = 583
    Top = 8
    Width = 106
    Height = 50
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    TabOrder = 2
    OnClick = btStopClick
  end
end
