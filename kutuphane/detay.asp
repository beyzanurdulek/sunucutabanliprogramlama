<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Kitap Detayı</title>
</head>
<body>
<%
Dim id
id = CInt(Request("id"))

If Not IsArray(kitaplar) Or id < 0 Or id > UBound(kitaplar) Then
    Response.Write("<p>Geçersiz kitap.</p>")
Else
    Dim parcalar, ad, yazar, yil, tur
    parcalar = Split(kitaplar(id), ";")

    ad    = parcalar(0)
    yazar = parcalar(1)
    yil   = parcalar(2)
    tur   = parcalar(3)

    Response.Write("<h1>" & ad & "</h1>")
    Response.Write("<p><b>Yazar:</b> " & yazar & "</p>")
    Response.Write("<p><b>Yıl:</b> " & yil & "</p>")
    Response.Write("<p><b>Tür:</b> " & tur & "</p>")
End If
%>

<p><a href="index.asp">Ana sayfa</a></p>

</body>
</html>
