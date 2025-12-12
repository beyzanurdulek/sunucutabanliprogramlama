<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Arama Sonuçları</title>
</head>
<body>
<%
Dim q, qTemiz, i
q = Request("q")   ' index.asp teki arama kutusu

' Boşlukları sil, küçük harfe çevir (Replace + Lcase)
qTemiz = Lcase(Replace(q, " ", ""))

Response.Write("<h1>Arama Sonuçları</h1>")
Response.Write("<p>Arama ifadesi: <b>" & Server.HTMLEncode(q) & "</b></p>")

If Not IsArray(kitaplar) Then
    Response.Write("<p>Hiç kitap yok.</p>")
Else
    Dim bulundu
    bulundu = False

    Response.Write("<table border='1' cellpadding='5' cellspacing='0'>")
    Response.Write("<tr><th>Kitap Adı</th><th>Yazar</th><th>Yıl</th><th>Tür</th><th>İşlem</th></tr>")

    For i = 0 To UBound(kitaplar)
        Dim parcalar, ad, yazar, yil, tur
        parcalar = Split(kitaplar(i), ";")  ' Split: "ad;yazar;yıl;tur"

        ad    = parcalar(0)
        yazar = parcalar(1)
        yil   = parcalar(2)
        tur   = parcalar(3)

        ' Arama için normalize et (küçük harf + boşluksuz)
        Dim adKucuk, yazarKucuk
        adKucuk    = Lcase(Replace(ad, " ", ""))
        yazarKucuk = Lcase(Replace(yazar, " ", ""))

        ' q boşsa tüm kitaplar; doluysa içinde geçenler
        If qTemiz = "" Or Instr(adKucuk, qTemiz) > 0 Or Instr(yazarKucuk, qTemiz) > 0 Then
            bulundu = True

            ' Left: uzun kitap adlarını kes
            Dim adOzet
            adOzet = ad
            If Len(adOzet) > 30 Then
                adOzet = Left(adOzet, 30) & "..."
            End If

            ' Mid: yazar bilgisini Mid ile gösterelim
            Dim yazarOzet
            If Len(yazar) > 0 Then
                yazarOzet = Mid(yazar, 1, Len(yazar))
            Else
                yazarOzet = yazar
            End If

            Response.Write("<tr>")
            Response.Write("<td><a href='detay.asp?id=" & i & "'>" & adOzet & "</a></td>")
            Response.Write("<td>" & yazarOzet & "</td>")
            Response.Write("<td>" & yil & "</td>")
            Response.Write("<td>" & tur & "</td>")
            Response.Write("<td><a href='sil.asp?id=" & i & "'>Sil</a></td>")
            Response.Write("</tr>")
        End If
    Next

    Response.Write("</table>")

    If Not bulundu Then
        Response.Write("<p>Aramanıza uygun kitap bulunamadı.</p>")
    End If
End If
%>

<p><a href="index.asp">Yeni arama</a> | <a href="ekle.asp">Yeni kitap ekle</a></p>

</body>
</html>
