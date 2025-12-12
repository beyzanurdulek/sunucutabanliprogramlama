<%@ Language=VBScript %>
<!-- #include file="global.asp" -->
<html>
<head>
    <meta charset="utf-8" />
    <title>Kitap Arama</title>
</head>
<body>
    <h1>Kitap Arama Sistemi</h1>

    <form method="get" action="ara.asp">
        Arama (kitap adı / yazar): 
        <input type="text" name="q" />
        <input type="submit" value="Ara" />
    </form>

    <p>
        <a href="ekle.asp">Yeni Kitap Ekle</a>
    </p>
</body>
</html>
