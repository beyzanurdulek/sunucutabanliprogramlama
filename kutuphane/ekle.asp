<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Yeni Kitap Ekle</title>
</head>
<body>
    <h1>Yeni Kitap Ekle</h1>

    <form method="post" action="eklekaydet.asp">
        Kitap Adı: <input type="text" name="ad" /><br /><br />
        Yazar: <input type="text" name="yazar" /><br /><br />
        Yıl: <input type="text" name="yil" /><br /><br />
        Tür: <input type="text" name="tur" /><br /><br />

        <input type="submit" value="Kaydet" />
    </form>

    <p><a href="index.asp">Ana sayfa</a></p>
</body>
</html>
