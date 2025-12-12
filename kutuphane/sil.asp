<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Kitap Sil</title>
</head>
<body>
<%
Dim id
id = CInt(Request("id"))

If Not IsArray(kitaplar) Or id < 0 Or id > UBound(kitaplar) Then
    Response.Write("<p>Geçersiz kitap.</p>")
Else
    Dim eskiBoyut, yeniBoyut, i, j, yeniDizi
    eskiBoyut = UBound(kitaplar)
    yeniBoyut = eskiBoyut - 1

    If yeniBoyut < 0 Then
        Response.Write("<p>Tek kitap vardı, onu da sildin.</p>")
    Else
        ReDim yeniDizi(yeniBoyut)
        j = 0

        For i = 0 To eskiBoyut
            If i <> id Then
                yeniDizi(j) = kitaplar(i)
                j = j + 1
            End If
        Next

        Response.Write("<h2>Kitap silindi </h2>")
        Response.Write("<h3>Güncel Liste</h3>")
        Response.Write("<ul>")
        For i = 0 To UBound(yeniDizi)
            Dim parc, ad2, yazar2, yil2, tur2
            parc   = Split(yeniDizi(i), ";")
            ad2    = parc(0)
            yazar2 = parc(1)
            yil2   = parc(2)
            tur2   = parc(3)
            Response.Write("<li>" & ad2 & " - " & yazar2 & " (" & yil2 & ", " & tur2 & ")</li>")
        Next
        Response.Write("</ul>")
    End If
End If
%>

<p><a href="index.asp">Ana sayfa</a></p>

</body>
</html>
