object AutoAwayForm: TAutoAwayForm
  Left = 360
  Top = 235
  BorderStyle = bsToolWindow
  Caption = 'AutoAway message...'
  ClientHeight = 113
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010002001010100000000000280100002600000010100000010008006805
    00004E0100002800000010000000200000000100040000000000C00000000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000002200022000000002
    22202222000000022222222200000222AA22AA22220021112A22AA2222202111
    1222A2A22220219112222AAA2220022212BBB2A22200222222BBB22222202AA2
    22BBB2AA222002222222222A22000002AA22AA22000000022A222A2200000000
    2220222000000000000000000000FFFF0000F39F0000E10F0000E00F00008003
    000000010000000100000001000080030000000100000001000080030000E00F
    0000E00F0000F11F0000FFFF0000280000001000000020000000010008000000
    00004001000000000000000000000000000000000000929292008080800000FF
    FF0000DCDC000080800000FF000000DC000000B9000000960000008000000000
    FF000000B900000080007A7A7A006E6E6E005656560000737300007300000050
    190000500000000073001A1A1A000E0E0E000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000FFFFFF0017171717171717171717
    1717171717171717171713131717171313171717171717171713080813171308
    0913171717171717171307070813070708131717171717131313060607130606
    071313131717130C0C0C130507130505130708091317130C0B0C0C1307130613
    060707081317130B0A0B0C0913131306050607081317171313130C1302020213
    0513131317171307070711110202021313070708131713050507071102020213
    0505070713171711110711071113130713051313171717171711060507130605
    0713171717171717171107060713070607131717171717171717111113171313
    13171717171717171717171717171717171717171717FFFF0000F39F0000E10F
    0000E00F00008003000000010000000100000001000080030000000100000001
    000080030000E00F0000E00F0000F11F0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object AwayMemo: TMemo
    Left = 8
    Top = 8
    Width = 249
    Height = 65
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 0
    OnClick = Button1Click
  end
end
