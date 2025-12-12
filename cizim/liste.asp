<!--#include file="db.asp"-->
<html>
<head>
<meta charset="utf-8">
<title>Veritabanı Kayıtları</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f0f0f0;
}
table {
    border-collapse: collapse;
    margin: 30px auto;
    background: white;
}
th, td {
    border: 1px solid black;
    padding: 8px 12px;
    text-align: center;
}
th {
    background: #3399ff;
    color: white;
}
h3 {
    text-align: center;
}
</style>
</head>

<body>

<h3>SQLite Veritabanında Kayıtlı Noktalar</h3>

<table>
<tr>
    <th>Sıra</th>
    <th>X</th>
    <th>Y</th>
</tr>

<%
Dim rs
Set rs = conn.Execute("SELECT * FROM Noktalar ORDER BY sira")

Do While Not rs.EOF
%>
<tr>
    <td><%=rs("sira")%></td>
    <td><%=rs("x")%></td>
    <td><%=rs("y")%></td>
</tr>
<%
    rs.MoveNext
Loop
%>

</table>

</body>
</html>
