object FrmMain: TFrmMain
  Width = 1106
  Height = 498
  Caption = 'Stock Example'
  CSSLibrary = cssBootstrap
  ElementFont = efCSS
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  OnDOMContentLoaded = WebFormDOMContentLoaded
  object BtnShowChart: TWebButton
    Left = 48
    Top = 56
    Width = 96
    Height = 25
    ElementID = 'BtnShowChart'
    ElementFont = efCSS
    HeightStyle = ssAuto
    HeightPercent = 100.000000000000000000
    Visible = False
    WidthPercent = 100.000000000000000000
    OnClick = BtnShowChartClick
  end
  object Connection: TXDataWebConnection
    OnConnect = ConnectionConnect
    Left = 376
    Top = 192
  end
  object Client: TXDataWebClient
    Connection = Connection
    Left = 376
    Top = 272
  end
end
