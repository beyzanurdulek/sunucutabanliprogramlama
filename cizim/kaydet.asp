<!--#include file="db.asp"-->
<%
Dim veri, i, json
veri = Request.Form("veri")

If veri <> "" Then

    ' Önce eski noktaları sil
    conn.Execute "DELETE FROM Noktalar"

    veri = Replace(veri, "[", "")
    veri = Replace(veri, "]", "")
    json = Split(veri, "},")

    For i = 0 To UBound(json)

        Dim satir, x, y
        satir = Replace(json(i), "{", "")
        satir = Replace(satir, "}", "")
        satir = Replace(satir, """", "")

        x = Split(Split(satir, "x:")(1), ",")(0)
        y = Split(satir, "y:")(1)

        conn.Execute _
        "INSERT INTO Noktalar (sira, x, y) VALUES (" & _
        (i+1) & "," & x & "," & y & ")"

    Next
End If

Response.Redirect "ciz.asp"
%>
