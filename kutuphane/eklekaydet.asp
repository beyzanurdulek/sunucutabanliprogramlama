<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Kitap Kaydet</title>
</head>
<body>
<%
Dim ad, yazar, yil, tur, hata
ad    = Trim(Request.Form("ad"))
yazar = Trim(Request.Form("yazar"))
yil   = Trim(Request.Form("yil"))
tur   = Trim(Request.Form("tur"))

hata = ""

' 1) Kitap adı boş olamaz
If ad = "" Then
    hata = hata & "Kitap adı boş olamaz.<br />"
End If

' 2) Yazar en az 4 karakter
If Len(yazar) < 4 Then
    hata = hata & "Yazar adı en az 4 karakter olmalıdır.<br />"
End If

' 3) Yıl sayısal ve 1950–2025 arasında olmalı
If Not IsNumeric(yil) Then
    hata = hata & "Yıl sayısal olmalıdır.<br />"
Else
    If CInt(yil) < 1950 Or CInt(yil) > 2025 Then
        hata = hata & "Yıl 1950-2025 arasında olmalıdır.<br />"
    End If
End If

If hata <> "" Then
    Response.Write("<h2>Hata!</h2>")
    Response.Write(hata)
    Response.Write("<p><a href='ekle.asp'>Geri dön</a></p>")
Else
    ' Dinamik dizi: ReDim Preserve ile büyüt
    Dim yeniIndex
    yeniIndex = UBound(kitaplar) + 1
    ReDim Preserve kitaplar(yeniIndex)

    ' ; karakterlerini temizle (Replace)
    ad    = Replace(ad, ";", "")
    yazar = Replace(yazar, ";", "")
    tur   = Replace(tur, ";", "")

    Dim kayit
    kayit = ad & ";" & yazar & ";" & yil & ";" & tur

    kitaplar(yeniIndex) = kayit

    Response.Write("<h2>Kitap başarıyla eklendi </h2>")

    ' Bu istekteki güncel listeyi göster
    Dim i, parcalar, ad2, yazar2, yil2, tur2
    Response.Write("<h3>Güncel Liste</h3>")
    Response.Write("<ul>")
    For i = 0 To UBound(kitaplar)
        parcalar = Split(kitaplar(i), ";")
        ad2    = parcalar(0)
        yazar2 = parcalar(1)
        yil2   = parcalar(2)
        tur2   = parcalar(3)
        Response.Write("<li>" & ad2 & " - " & yazar2 & " (" & yil2 & ", " & tur2 & ")</li>")
    Next
    Response.Write("</ul>")
End If
%>

<p><a href="index.asp">Ana sayfa</a></p>

</body>
</html>
